//Intval for pro trinket arduinos
//Using 12vdc motors in place of a stepper
//HBridge for motor control
//Microswitch for control

//BUTTON MODEL, NO FSK

/*
----------------------------------------------------
Microswitch (use INPUT_PULLUP!!)
GND-----\ | \-----PIN
----------------------------------------------------
*/

/* ------------------------------------------------
 *  cmd - for Serial
 * ------------------------------------------------*/
volatile int cmd_input = 0;
const int CMD_FORWARD = 102; //f
const int CMD_BACKWARD = 98; //b
const int CMD_BLACK = 110; //n

/* ------------------------------------------------
 *  buttons
 * ------------------------------------------------*/

/* ------------------------------------------------
 *  pins
 * ------------------------------------------------*/
const int PIN_INDICATOR = 13;

const int PIN_MOTOR_FORWARD = 10;
const int PIN_MOTOR_BACKWARD = 11;

const int PIN_MICRO = 8;

/* ------------------------------------------------
 *  loop
 * ------------------------------------------------*/
const int LOOP_DELAY = 10;

/* ------------------------------------------------
 *  state
 * ------------------------------------------------*/
const int FWD_SPEED = 255;
const int BWD_SPEED = 255;

volatile boolean direction = true;

volatile boolean running = false;
volatile boolean cam_dir = true;

volatile int micro_position = 0;
volatile boolean micro_primed = false;

unsigned long timer = 0;
volatile int timer_int = 0;

volatile int cam_count = 0;
volatile int cam_pos = 0;

void setup () {
  Serial.begin(9600);
  Serial.flush();
  modem.begin();
  Pins_init();
  Serial.println("Welcome to intval2.");
}

void loop () {
  if (Serial.available() > 0 && !running){
    cmd_input = Serial.read();
  }
  if (cmd_input == CMD_FORWARD 
    && !running) {
    Frame(true);
  }
  if (cmd_input == CMD_BACKWARD
    && !running) {
    Frame(false);
  }
      
  if (cmd_input != 0) {      
    cmd_input = 0;
  }
  if (running) {
    Read_micro();
  } else {
    Read_buttons();
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
  //Serial.println("Starting Frame()...");
  Time_start();
  cam_dir = dir;
  if (cam_dir) {
   // Serial.println("Forward");
    analogWrite(PIN_MOTOR_FORWARD, FWD_SPEED);
    analogWrite(PIN_MOTOR_BACKWARD, 0);
  } else {
    //Serial.println("Backwards");
    analogWrite(PIN_MOTOR_BACKWARD, BWD_SPEED);
    analogWrite(PIN_MOTOR_FORWARD, 0);
  }
  Indicator(true);
  running = true;
  micro_primed = false;
}

void Read_micro () {
  micro_position = digitalRead(PIN_MICRO);
  //Serial.println(micro_position);
  if (micro_position == LOW 
      && micro_primed == false) {
    micro_primed = true;
    //Serial.println("Frame micro_primed");
  } else if (micro_position == HIGH 
            && micro_primed == true) {
    Stop();
  }
  delay(1);//smooths out signal
}

void Read_buttons () {

}

void Stop () {
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
  
  //Serial.println("Frame ran");
  Time_end();
 
  cam_count++;
  if (cam_dir) {
    cam_pos++;
  } else {
    cam_pos--;
  }
  
  running = false;
  micro_primed = false;
  Indicator(false);
}

void Time_start () {
  timer = millis();
}

void Time_end () {
  timer = millis() - timer;
  timer_int = int(timer);
  //Serial.print(timer_int);
  //Serial.println("ms");
}

void Indicator (boolean state) {
  if (state) {
    digitalWrite(PIN_INDICATOR, HIGH);
  } else {
    digitalWrite(PIN_INDICATOR, LOW);
  }
}
