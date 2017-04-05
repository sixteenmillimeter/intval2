#include <Servo.h>



//Intval for pro trinket arduinos
//Using 12vdc motors in place of a stepper
//HBridge for motor control
//Microswitch for control

Servo blackout;

/*
----------------------------------------------------
Microswitch (use INPUT_PULLUP!!)
GND-----\ | \-----PIN
----------------------------------------------------
*/
const int MOTOR_RPM = 120;
const int BOLEX_C = round((133 / (1.66 * 360)) * 1000); //bolex exposure constant

const int FAST_PWM = 255;
const int SLOW_PWM = 127;

/* ------------------------------------------------
 *  pins
 * ------------------------------------------------*/
//Trinket Pro
const int PIN_INDICATOR = 13;
const int PIN_MOTOR_FORWARD = 9;
const int PIN_MOTOR_BACKWARD = 10;
//const int PIN_MICRO = 12;
const int PIN_MICRO = 19; //laser cut version
const int BUTTON[4] = {3, 6, 5, 4};  //trigger, direction, speed, delay


volatile int button_state[4] = {1, 1, 1, 1};
volatile long button_time[4] = {0, 0, 0, 0};
volatile long buttontime = 0;

/* ------------------------------------------------
 *  loop
 * ------------------------------------------------*/
const int LOOP_DELAY = 10;

/* ------------------------------------------------
 *  state
 * ------------------------------------------------*/
volatile int fwd_speed = FAST_PWM;
volatile int bwd_speed = FAST_PWM;

volatile boolean sequence = false;
volatile boolean running = false;
volatile boolean cam_dir = true;
volatile boolean delaying = false;
volatile boolean timed = false;

volatile int micro_position = 0;
volatile boolean micro_primed = false;

unsigned long timer = 0;
unsigned long frame_start = 0;
unsigned long delay_start = 0;

volatile int cam_count = 0;
volatile int cam_pos = 0;

unsigned long timed_open = 300; //ms after start_frame to pause
volatile boolean timed_paused = false;
unsigned long timed_delay = 0;
unsigned long timed_last = 0;
unsigned long timed_avg = 600;

volatile long seq_delay = 42;

volatile boolean black = true;
const int black_delay = 250;
const int black_start = 0;
const int black_end = 90;
const int black_timed = 1;
volatile boolean black_paused = false;


void setup () {
  blackout.attach(12);
  Black_off();
  
  Pins_init();
  Buttons_init();
}

void loop () {
  timer = millis();
  
  Btn(0);
  Btn(1);
  Btn(2);
  Btn(3);
  
  if (sequence && delaying) {
    Watch_delay();
  }
  
  if (running) {
    if (timed && black) {
     Read_timed();  
    } else {
     Read_micro(); 
    }
  }
  if (!running && !sequence && !delaying){ 
    delay(LOOP_DELAY);
  }
}

void Pins_init () {
  pinMode(PIN_MOTOR_FORWARD, OUTPUT);
  pinMode(PIN_MOTOR_BACKWARD, OUTPUT);
  pinMode(PIN_MICRO, INPUT_PULLUP);
  pinMode(PIN_INDICATOR, OUTPUT);
}

void Frame () {
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

void Pause_timed () {
  timed_paused = true;
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
}

void Start_timed () {
  timed_paused = false;
   if (cam_dir) {
    analogWrite(PIN_MOTOR_FORWARD, fwd_speed);
    analogWrite(PIN_MOTOR_BACKWARD, 0);
  } else {
    analogWrite(PIN_MOTOR_BACKWARD, bwd_speed);
    analogWrite(PIN_MOTOR_FORWARD, 0);
  } 
}

boolean Read_delay () {
  if (fwd_speed == FAST_PWM) {
      if (timer - frame_start >= 300) {
        return true;
      }
  } else {
      if (timer - frame_start >= 600) {
        return true;
      }
  }
  return false;
}

void Watch_delay () {
  if (timer - delay_start >= seq_delay) {
    delaying = false;
    Frame();
  }
}

void Read_micro () {
  if (Read_delay()) {
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

void Read_timed () {
  if (!timed_paused) {
    if (timer - frame_start > timed_open 
      && timer - frame_start < timed_open + timed_delay) { 
       Pause_timed();
       black_paused = true;
    } else if (timer - frame_start > timed_open + timed_delay) {
      micro_position = digitalRead(PIN_MICRO);
      if (micro_position == HIGH) {
        Stop();
      }
      delay(2);//smooths out signal  
    }
  }
  if (timed_paused && timer - frame_start > timed_open + timed_delay) {
    Start_timed();   
  }
}
void Stop () {
  delay(10);
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
 
  cam_count++;
  if (cam_dir) {
    cam_pos++;
  } else {
    cam_pos--;
  }
  
  running = false;
  micro_primed = false;
  
  if (sequence) {
    if (black) {
      Black_on(); 
    } else {
      Black_off(); 
    }
    delaying = true;
    delay_start = millis();
  }
}

void Indicator (boolean state) {
  if (state) {
    digitalWrite(PIN_INDICATOR, HIGH);
  } else {
    digitalWrite(PIN_INDICATOR, LOW);
  }
}

void Buttons_init () {
  for (int i = 0; i < 4; i++) {
    pinMode(BUTTON[i], INPUT_PULLUP);
  }
}

void Btn (int index) {
  int val = digitalRead(BUTTON[index]);
  if (val != button_state[index]) {
    if (val == LOW) { // pressed
      button_time[index] = millis();
      //button_start(index);
    } else if (val == HIGH) { // not pressed
      buttontime = millis() - button_time[index];
      button_end(index, buttontime);
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

void button_end (int index, long buttontime) {
  if (index == 0) {
    if (buttontime > 1000) {
      if (!sequence) {
        sequence = true;
        Output(2, 75);
        Frame();
      }
    } else {
      if (sequence) {
        sequence = false;
        //Output(2, 75);
      } else {
        //Output(2, 75);
        Frame();
      }
    }
  } else if (index == 1) { //set direction
    if (buttontime < 1000) {
      cam_dir = true;
      Output(1, 500);
    } else if (buttontime > 1000) {
      cam_dir = false;
      Output(2, 250);
    }
  } else if (index == 2) { // set speed
    if (buttontime >= 1000) {
      timed_delay = buttontime - BOLEX_C;
      timed = true;
      Output(2, 250);
    } else if (buttontime < 1000) {
      timed_delay = 0;
      timed = false;
      Output(1, 500);    
    }
  } else if (index == 3) { //set delay
    if (buttontime < 42) {
      seq_delay = 42;
      Output(1, 500);
    } else {
      seq_delay = buttontime;
      Output(2, 250);
    }
  }
  buttontime = 0;
}

void Output (int number, int len) {
  for (int i = 0; i < number; i++) {
    Indicator(true);
    delay(len);
    Indicator(false);
    delay(42);
  }
}

void Black_on () {
  blackout.write(black_start); 
  delay(black_delay);
  black = false; 
}

void Black_off () {
  blackout.write(black_end);
  delay(black_delay);
  black = true;   
}
