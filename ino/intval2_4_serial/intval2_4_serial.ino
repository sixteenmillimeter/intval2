#include "McopySerial.h"
#include "Intval2.h"

McopySerial mc;
Intval2 intval;
volatile char cmd_char = 'z';

void setup() {
  mc.begin(mc.CAMERA_IDENTIFIER);
  intval.begin();
}

void loop () {
  cmd_char = mc.loop();
  cmd(cmd_char);

  intval.loop();
}

void cmd (char val) {
  if (val == mc.CAMERA) {
    //intval::Camera();
  } else if (val == mc.CAMERA_FORWARD) {
    //CameraDirection(true);
  } else if (val == mc.CAMERA_BACKWARD) {
    //CameraDirection(false);
  } else if (val == mc.CAMERA_OPEN) {
    //CameraOpen();
  } else if (val == mc.CAMERA_CLOSE) {
    //CameraClose();
  } else if (val == mc.CAMERA_EXPOSURE) {
    //CameraExposure();  
  } else if (val == mc.STATE) {
    //State();
  }
}

void State () {
  String stateString = String(mc.STATE);
  stateString += String(mc.CAMERA_EXPOSURE);
  //stateString += intval2.State();
  stateString += String(mc.STATE);
  mc.sendString(stateString);
}