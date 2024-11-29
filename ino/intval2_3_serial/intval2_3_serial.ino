#include "McopySerial.h"


//Can be controlled via serial, with mcopy and filmout_manager
//Buttons are optional
//Exposure controls assumes use  of a 120RPM motor
//Uses L298N H-bridge breakout board
//Target board is an Arduino Nano

/*
----------------------------------------------------
Microswitch (use INPUT_PULLUP!!)
GND-----\ | \-----PIN
----------------------------------------------------
*/

const int MOTOR_RPM = 120;
const int BOLEX_C = round((133 / (1.66 * 360)) * 1000); //bolex exposure constant
const int FAST_PWM = 255;

/* ------------------------------------------------
 *  pins
 * ------------------------------------------------*/
//Arduino Nano
const int PIN_INDICATOR = 13;
const int PIN_MOTOR_FORWARD = 9;
const int PIN_MOTOR_BACKWARD = 10;
const int PIN_MICRO = 19;
//6, 5, 4
//1, 2, 3
const int BUTTON[4] = {3, 4, 5, 6};  //trigger, delay, speed, direction

/* ------------------------------------------------
 *  loop
 * ------------------------------------------------*/
const int LOOP_DELAY = 10;

/* ------------------------------------------------
 *  state
 * ------------------------------------------------*/
volatile int button_state[4] = {1, 1, 1, 1};
volatile long button_time[4] = {0, 0, 0, 0};
volatile long buttontime = 0;

volatile boolean sequence = false;
volatile boolean running = false;
volatile boolean cam_dir = true;
volatile boolean delaying = false;
volatile boolean timed = false;

volatile int counter = 0;

volatile int micro_position = 0;
volatile boolean micro_primed = false;

unsigned long timer = 0;
unsigned long frame_start = 0;
unsigned long delay_start = 0;

String timed_str = "600";
unsigned long timed_val = 600;
unsigned long timed_open = 300; //ms after start_frame to pause
volatile boolean timed_paused = false;
unsigned long timed_delay = 0;
unsigned long timed_last = 0;
unsigned long timed_avg = 600;

volatile int fwd_speed = FAST_PWM;
volatile int bwd_speed = FAST_PWM;

volatile long seq_delay = 42;
volatile boolean is_open = false;

/* ------------------------------------------------
 *  serial
 * ------------------------------------------------*/
McopySerial mc;
volatile char cmd_char = 'z';

const int serialDelay = 5;

void setup() {
  mc.begin(mc.CAMERA_IDENTIFIER);
  PinsInit();
  ButtonsInit();
}

void loop() {
  cmd_char = mc.loop();
  cmd(cmd_char);

  timer = millis();
  
  Button(0);
  Button(1);
  Button(2);
  Button(3);
  
  if (sequence && delaying) {
    WatchDelay();
  }
  
  if (running) {
    if (timed) {
     ReadTimed();  
    } else {
     ReadMicro(); 
    }
  }
  if (!running && !sequence && !delaying){ 
    delay(LOOP_DELAY);
  }
}

void cmd (char val) {
  if (val == mc.CAMERA) {
    Camera();
  } else if (val == mc.CAMERA_FORWARD) {
    CameraDirection(true);
  } else if (val == mc.CAMERA_BACKWARD) {
    CameraDirection(false);
  } else if (val == mc.CAMERA_OPEN) {
    CameraOpen();
  } else if (val == mc.CAMERA_CLOSE) {
    CameraClose();
  } else if (val == mc.CAMERA_EXPOSURE) {
    CameraExposure();  
  } else if (val == mc.STATE) {
    State();
  }
}

//sending "0" will reset to default exposure time
void CameraExposure () {
  timed_str = mc.getString();
  timed_val = timed_str.toInt();
  if (timed_val < 600) {
    timed_val = 600;
    timed_str = "600";
    timed = false;
  } else {
    timed_delay = timed_val - BOLEX_C;
    timed = true;
  }
  mc.confirm(mc.CAMERA_EXPOSURE);
  mc.log("Set exposure time to: ");
  mc.log(timed_str);
}

void PinsInit () {
  pinMode(PIN_MOTOR_FORWARD, OUTPUT);
  pinMode(PIN_MOTOR_BACKWARD, OUTPUT);
  pinMode(PIN_MICRO, INPUT_PULLUP);
  pinMode(PIN_INDICATOR, OUTPUT);
}

void ButtonsInit () {
  for (int i = 0; i < 4; i++) {
    pinMode(BUTTON[i], INPUT_PULLUP);
  }
}

void Button (int index) {
  int val = digitalRead(BUTTON[index]);
  if (val != button_state[index]) {
    if (val == LOW) { // pressed
      button_time[index] = millis();
      //button_start(index);
    } else if (val == HIGH) { // not pressed
      buttontime = millis() - button_time[index];
      ButtonEnd(index, buttontime);
    }
  }
  button_state[index] = val;
}

/*
 * dormant for now
 * void button_start (int index) {
  if (index == 0) {
  }
}*/

void ButtonEnd (int index, long buttontime) {
  if (index == 0) {
    if (buttontime > 1000) {
      if (!sequence && !running) {
        sequence = true;
        Output(2, 75);
        Camera();
      }
    } else {
       if (sequence) {
        sequence = false;
        //Output(2, 75);
      } else {
         Camera();
      }
    }
  } else if (index == 1) { //set delay
    if (buttontime < 42) {
      seq_delay = 42;
      Output(1, 500);
    } else {
      seq_delay = buttontime;
      Output(2, 250);
    }
  }  else if (index == 2) { // set speed
    if (buttontime >= 1000) {
      timed_delay = buttontime - BOLEX_C;
      timed = true;
      Output(2, 250);
    } else if (buttontime < 1000) {
      timed_delay = 0;
      timed = false;
      Output(1, 500);    
    }
  } else if (index == 3) { //set direction
    if (buttontime < 1000) {
      cam_dir = true;
      Output(1, 500);
    } else if (buttontime > 1000) {
      cam_dir = false;
      Output(2, 250);
    }
  }
  buttontime = 0;
}

void Indicator (boolean state) {
  if (state) {
    digitalWrite(PIN_INDICATOR, HIGH);
  } else {
    digitalWrite(PIN_INDICATOR, LOW);
  }
}

void Output (int number, int len) {
  for (int i = 0; i < number; i++) {
    Indicator(true);
    delay(len);
    Indicator(false);
    delay(42);
  }
}

void Camera () {
  frame_start = millis();
  if (cam_dir) {
    analogWrite(PIN_MOTOR_FORWARD, fwd_speed);
    analogWrite(PIN_MOTOR_BACKWARD, 0);
  } else {
    analogWrite(PIN_MOTOR_BACKWARD, bwd_speed);
    analogWrite(PIN_MOTOR_FORWARD, 0);
  }
  running = true;
  micro_primed = false;
}

void CameraOpen () {
  if (cam_dir) {
    analogWrite(PIN_MOTOR_FORWARD, fwd_speed);
    analogWrite(PIN_MOTOR_BACKWARD, 0);
  } else {
    analogWrite(PIN_MOTOR_BACKWARD, bwd_speed);
    analogWrite(PIN_MOTOR_FORWARD, 0);
  }
  running = true;
  micro_primed = false;
  
  delay(timed_open);

  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);

  micro_position = digitalRead(PIN_MICRO);
  if (micro_position == LOW) {
    micro_primed = true;
  }

  mc.confirm(mc.CAMERA_OPEN);
  mc.log("camera_open()");
  is_open = true;
  running = false;
}

void CameraClose () {
  bool microswitch_open = false;
  if (is_open) {
    if (cam_dir) {
      analogWrite(PIN_MOTOR_FORWARD, fwd_speed);
      analogWrite(PIN_MOTOR_BACKWARD, 0);
    } else {
      analogWrite(PIN_MOTOR_BACKWARD, bwd_speed);
      analogWrite(PIN_MOTOR_FORWARD, 0);
    }

    while (!microswitch_open) {
      micro_position = digitalRead(PIN_MICRO);
      if (micro_position == HIGH) {
        microswitch_open = true;
      }
      delay(2);
    }
    delay(10);

    analogWrite(PIN_MOTOR_FORWARD, 0);
    analogWrite(PIN_MOTOR_BACKWARD, 0);
  } else {
    micro_position = digitalRead(PIN_MICRO);
    if (micro_position == HIGH) {
      mc.log("WARNING: Camera already closed");
    }
  }
  mc.confirm(mc.CAMERA_CLOSE);
  mc.log("camera_close()");
  is_open = false;
}

boolean ReadDelay () {
  if (timer - frame_start >= timed_open) {
    return true;
  }
  return false;
}

void WatchDelay () {
  if (timer - delay_start >= seq_delay) {
    delaying = false;
    Camera();
  }
}

void ReadTimed () {
  if (!timed_paused) {
    if (timer - frame_start > timed_open 
      && timer - frame_start < timed_open + timed_delay) {
       PauseTimed();
    } else if (timer - frame_start > timed_open + timed_delay) {
      micro_position = digitalRead(PIN_MICRO);
      if (micro_position == HIGH) {
        Stop();
      }
      delay(2);//smooths out signal  
    }
  } 
  if (timed_paused && timer - frame_start > timed_open + timed_delay) {
    StartTimed();   
  }
}

void PauseTimed () {
  timed_paused = true;
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
}

void StartTimed () {
  timed_paused = false;
   if (cam_dir) {
    analogWrite(PIN_MOTOR_FORWARD, fwd_speed);
    analogWrite(PIN_MOTOR_BACKWARD, 0);
  } else {
    analogWrite(PIN_MOTOR_BACKWARD, bwd_speed);
    analogWrite(PIN_MOTOR_FORWARD, 0);
  } 
}

void ReadMicro () {
  if (ReadDelay()) {
    micro_position = digitalRead(PIN_MICRO);
    if (micro_position == LOW 
        && micro_primed == false) {
      micro_primed = true;
    } else if (micro_position == HIGH 
              && micro_primed == true) {
      Stop();
    }
    delay(2);//smooths out signal
  }
}

void Stop () {
  delay(10);
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
  
  running = false;
  micro_primed = false;

  if (cam_dir) {
    counter += 1;  
  } else {
    counter -= 1;
  }

  timed_last = timer - frame_start;
  timed_avg = (timed_avg + timed_last) / 2;

  mc.confirm(mc.CAMERA);
  mc.log("Camera completed");
  mc.log(String(timed_last));
  if (sequence) {
    delaying = true;
    delay_start = millis();
  }
}

void CameraDirection (boolean state) {
  cam_dir = state;
  if (state) {
    timed_open = 300;
    mc.confirm(mc.CAMERA_FORWARD);
    mc.log("camera_direction(true)");
  } else {
    timed_open = 400;
    mc.confirm(mc.CAMERA_FORWARD);
    mc.log("camera_direction(false)");
  }
}

void State () {
  String stateString = String(mc.STATE);
  stateString += String(mc.CAMERA_EXPOSURE);
  stateString += String(timed_avg);
  stateString += String(mc.STATE);
  mc.sendString(stateString);
}
