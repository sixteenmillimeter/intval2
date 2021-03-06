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

const int FAST_PWM = 255;
const int SLOW_PWM = 127;

/* ------------------------------------------------
 *  pins
 * ------------------------------------------------*/
//5V Trinket Pro
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

volatile int fwd_speed = FAST_PWM;
volatile int bwd_speed = FAST_PWM;

volatile boolean sequence = false;
volatile boolean running = false;
volatile boolean cam_dir = true;
volatile boolean delaying = false;

volatile int micro_position = 0;
volatile boolean micro_primed = false;

unsigned long timer = 0;
unsigned long frame_start = 0;
unsigned long delay_start = 0;

volatile int cam_count = 0;
volatile int cam_pos = 0;

volatile long seq_delay = 42;

/* ------------------------------------------------
 *  Runs once at startup, defines pin modes for
 *  buttons and other inputs.
 * ------------------------------------------------*/
void setup () {
  Pins_init();
  Buttons_init();
}

/* ------------------------------------------------
 *  Runs constantly, sets a timer at beginning of loop,
 *  checks states of every button and then either compares
 *  the timer to the delay end, watches for the microswitch
 *  to stop the frame or alternately delays for LOOP_DELAY.
 * ------------------------------------------------*/
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
    Read_micro();
  }
  if (!running && !sequence && !delaying){ 
    delay(LOOP_DELAY);
  }
}

/* ------------------------------------------------
 *  Defines pin modes for motor control pins, microswitch
 *  and the indicator (LED) pin.
 * ------------------------------------------------*/
void Pins_init () {
  pinMode(PIN_MOTOR_FORWARD, OUTPUT);
  pinMode(PIN_MOTOR_BACKWARD, OUTPUT);
  pinMode(PIN_MICRO, INPUT_PULLUP);
  pinMode(PIN_INDICATOR, OUTPUT);
}

/* ------------------------------------------------
 *  Starts a frame by updating the frame_start timer,
 *  starts motor in set direction, sets running flag
 *  to true and primes the micoswitch flag.
 * ------------------------------------------------*/
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

/* ------------------------------------------------
 *  Determines whether or not the motor has turned
 *  far enough to start reading the micoswitch state.
 *  This prevents the switch from checking too early,
 *  while it is not yet pressed.
 * ------------------------------------------------*/
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

/* ------------------------------------------------
 *  Reads the state of the microswitch after the
 *  Read_delay() period. If the micoswitch is pressed,
 *  set the micro_primed flag to true. If primed and
 *  microswitch gets opened, Stop() the frame.
 * ------------------------------------------------*/
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

/* ------------------------------------------------
 *  Determines when the delay period between frames
 *  in a sequence is over.
 * ------------------------------------------------*/
void Watch_delay () {
  if (timer - delay_start >= seq_delay) {
    delaying = false;
    Frame();
  }
}

/* ------------------------------------------------
 *  Stops the motor after a 10ms delay. Increments
 *  a cam counter when complete. Resets running and
 *  micro_primed flags to false, starts delaying if
 *  sequence flag is set to true.
 * ------------------------------------------------*/
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
    delaying = true;
    delay_start = millis();
  }
}
/* ------------------------------------------------
 *  Turns on or off the indicator LED.
 * ------------------------------------------------*/
void Indicator (boolean state) {
  if (state) {
    digitalWrite(PIN_INDICATOR, HIGH);
  } else {
    digitalWrite(PIN_INDICATOR, LOW);
  }
}

/* ------------------------------------------------
 *  Declare the pin mode of all buttons as, input pullup
 *  which enables the internal pullup resistor.
 * ------------------------------------------------*/
void Buttons_init () {
  for (int i = 0; i < 4; i++) {
    pinMode(BUTTON[i], INPUT_PULLUP);
  }
}

/* ------------------------------------------------
 *  Reads the state of a specific button and compares
 *  it to a stored value in the button_state array.
 *  If the value is different than what is stored,
 *  check if button is pressed and store new timer value,
 *  if button is released, compare current time to the stored
 *  time value and pass that to the button_end function.
 * ------------------------------------------------*/
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

/* ------------------------------------------------
 *  Determines a specific action for each press length
 *  of each button. In most cases a press over 1 second is
 *  distinct from one less than 1 second.
 * ------------------------------------------------*/
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
    if (buttontime <= 1000) {
      fwd_speed = FAST_PWM;
      bwd_speed = FAST_PWM;
      Output(1, 500);
    } else if (buttontime > 1000) {
      fwd_speed = SLOW_PWM;
      bwd_speed = SLOW_PWM;
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


/* ------------------------------------------------
 *  Display a specified number of flashes on the 
 *  indicator LED for a specified amount of time.
 * ------------------------------------------------*/
void Output (int number, int len) {
  for (int i = 0; i < number; i++) {
    Indicator(true);
    delay(len);
    Indicator(false);
    delay(42);
  }
}