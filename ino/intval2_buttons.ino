//Intval for pro trinket arduinos
//Using 12vdc motors in place of a stepper
//L289N HBridge for motor control
//Microswitch for control

/*
----------------------------------------------------
Microswitch (use INPUT_PULLUP!!)
GND-----\ | \-----PIN
----------------------------------------------------
*/


/* ------------------------------------------------
 *  pins
 * ------------------------------------------------*/
//Trinket Pro
const int PIN_INDICATOR = 13;
const int PIN_MOTOR_FORWARD = 9;
const int PIN_MOTOR_BACKWARD = 10;
const int PIN_MICRO = 19; //laser cut version
const int BUTTON[4] = {3, 6, 5, 4};  //trigger, direction, speed, delay

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

volatile int fwd_speed = 255;
volatile int bwd_speed = 255;

volatile boolean sequence = false;
volatile boolean running = false;
volatile boolean cam_dir = true;

volatile int micro_position = 0;
volatile boolean micro_primed = false;

unsigned long timer = 0;
volatile int timer_int = 0;

volatile int cam_count = 0;
volatile int cam_pos = 0;

volatile long seq_delay = 42;

void setup () {
  Pins_init();
  Buttons_init();
}

void loop () {
  Btn(0);
  Btn(1);
  Btn(2);
  Btn(3);
  if (running) {
    Read_micro();
  } else { 
    delay(LOOP_DELAY);
  }
}

void Pins_init () {
  pinMode(PIN_MOTOR_FORWARD, OUTPUT);
  pinMode(PIN_MOTOR_BACKWARD, OUTPUT);
  pinMode(PIN_MICRO, INPUT_PULLUP);
  pinMode(PIN_INDICATOR, OUTPUT);
}

void Frame (boolean dir) {
  Time_start();
  cam_dir = dir;
  if (cam_dir) {
    analogWrite(PIN_MOTOR_FORWARD, fwd_speed);
    analogWrite(PIN_MOTOR_BACKWARD, 0);
  } else {
    analogWrite(PIN_MOTOR_BACKWARD, bwd_speed);
    analogWrite(PIN_MOTOR_FORWARD, 0);
  }
  running = true;
  if (fwd_speed == 255) {
      delay(300);
  } else {
      delay(600);
  }
  micro_primed = false;
}

void Read_micro () {
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

void Stop () {
  delay(10);
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
  
  Time_end();
 
  cam_count++;
  if (cam_dir) {
    cam_pos++;
  } else {
    cam_pos--;
  }
  
  running = false;
  micro_primed = false;
  
  if (sequence) {
    delay(seq_delay);
    Trigger();
  }
}

void Time_start () {
  timer = millis();
}

void Time_end () {
  timer = millis() - timer;
  timer_int = int(timer);
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
      button_start(index);
    } else if (val == HIGH) { // not pressed
      buttontime = millis() - button_time[index];
      button_end(index, buttontime);
    }
  }
  button_state[index] = val;
}

void button_start (int index) {
  if (index == 0) {
    if (sequence) {
      sequence = false;
      Output(2, 250);
    }
  }
}

void button_end (int index, long buttontime) {
  if (index == 0) {
    if (buttontime > 1000) {
      if (!sequence) {
        sequence = true;
        Output(2, 250);
      }
      Trigger();
    } else {
      Trigger();
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
    if (buttontime <= 1000) {
      fwd_speed = 255;
      bwd_speed = 255;
      Output(1, 500);
    } else if (buttontime > 1000) {
      fwd_speed = 127;
      bwd_speed = 127;
      Output(2, 250);    
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

void Trigger () {
  Frame(cam_dir);
}

void Output (int number, int len) {
  for (int i = 0; i < number; i++) {
    Indicator(true);
    delay(len);
    Indicator(false);
    delay(42);
  }
}
