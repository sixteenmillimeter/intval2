//Intval for pro trinket arduinos
//Using 12vdc motors in place of a stepper
//Microswitch for control

#include <SoftModem.h>
#include <ctype.h>
/*
----------------------------------------------------

----------------------------------------------------
*/

//FSK INPUT PIN 6
SoftModem modem;

/* ------------------------------------------------
 *  cmd
 * ------------------------------------------------*/
volatile int c = 0;
 
volatile int cmd_input = 0;
const int CMD_FORWARD = 102; //f
const int CMD_BACKWARD = 98; //b
const int CMD_BLACK = 110; //n

/* ------------------------------------------------
 *  pins
 * ------------------------------------------------*/
const int PIN_INDICATOR = 13;
const int PIN_MOTOR_FORWARD = 5;
const int PIN_MOTOR_BACKWARD = 6;
const int PIN_MICRO = 2;

/* ------------------------------------------------
 *  loop
 * ------------------------------------------------*/
const int LOOP_DELAY = 100;

/* ------------------------------------------------
 *  speed
 * ------------------------------------------------*/
const int FWD_SPEED = 240;
const int BWD_SPEED = 240;

volatile boolean running = false;
volatile boolean cam_dir = true;

volatile int micro_position = 0;
volatile boolean micro_primed = false;

unsigned long timer = 0;

volatile int cam_count = 0;
volatile int cam_pos = 0;

void setup () {
  Serial.begin(9600);
  Serial.flush();
  Pins_init();
  Serial.println("Welcome to intval2.");
}

void loop () {
  while (modem.available() > 0 && !running) { 
    c = modem.read(); 
    Serial.println(c);
  }
  if (Serial.available() > 0 && !running){
    cmd_input = Serial.read();
    //Serial.println(cmd_input);
  }
  if (cmd_input == 102) {
    Frame(true);
  }
  if (running) {
    Frame_check();
  } else {
      delay(LOOP_DELAY);
  }
  cmd_input = 0;
}

void Pins_init () {
  pinMode(PIN_MOTOR_FORWARD, OUTPUT);
  pinMode(PIN_MOTOR_BACKWARD, OUTPUT);
  pinMode(PIN_MICRO, INPUT);
  pinMode(PIN_INDICATOR, OUTPUT);
}

void Frame (boolean dir) {
  Time_start();
  cam_dir = dir;
  if (cam_dir) {
    analogWrite(PIN_MOTOR_FORWARD, FWD_SPEED);
  } else {
    analogWrite(PIN_MOTOR_BACKWARD, BWD_SPEED);
  }
  Indicator(true);
  running = true;
  micro_primed = false;
  cmd_input = 0;
}

void Frame_check () {
  micro_position = digitalRead(PIN_MICRO);
  //Serial.println(micro_position);
  if (micro_position == LOW && micro_primed == false) {
    micro_primed = true;
    Serial.println("Frame micro_primed");
  } else if (micro_position == HIGH && micro_primed == true) {
    Stop();
  }
  delay(1);//smooths out signal
}

void Stop () {
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
  
  Serial.println("Frame ran");
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
  int timer_int = int(timer);
  Serial.print(timer_int);
  Serial.println("ms");
}

void Indicator (boolean state) {
  if (state) {
    digitalWrite(PIN_INDICATOR, HIGH);
  } else {
    digitalWrite(PIN_INDICATOR, LOW);
  }
}
