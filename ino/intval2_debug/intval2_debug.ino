/**
 * DEBUG SCRIPT
 *
 * Functions for debugging hardware and software issues.
 *
 **/

#include "McopySerial.h"

McopySerial mc;
volatile char cmd_char = 'z';

//Arduino Nano
const int PIN_INDICATOR = 13;
const int PIN_MOTOR_FORWARD = 9;
const int PIN_MOTOR_BACKWARD = 10;
const int PIN_MICRO = 19;
const int BUTTON[4] = {3, 4, 5, 6};  //trigger, delay, speed, direction

unsigned long timed_val = 600;
unsigned long timed_open = 300;

volatile int micro_position = 0;
volatile boolean micro_primed = false;

unsigned long timer = 0;
unsigned long frame_start = 0;
unsigned long delay_start = 0;



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

void setup() {
  mc.begin(mc.CAMERA_IDENTIFIER);
  PinsInit();
  ButtonsInit();
}

void loop() {
  cmd_char = mc.loop();
  cmd(cmd_char);

  timer = millis();
  
}

void cmd (char c) {

}

boolean ReadDelay () {
  if (timer - frame_start >= timed_open) {
    return true;
  }
  return false;
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
}