#include "McopySerial.h"
#include "Intval2.h"

McopySerial mc;
Intval2 intval2;
volatile char cmd_char = 'z';

volatile boolean camera_running;
volatile boolean open_running;
volatile boolean close_running;

String timed_exposure_str = "0";
volatile unsigned long timed_exposure_ms = 0;

void setup() {
  mc.begin(mc.CAMERA_IDENTIFIER);
  intval2.begin();
}

void loop () {
  cmd_char = mc.loop();
  cmd(cmd_char);

  intval2.loop();
}

void cmd (char val) {
  if (val == mc.CAMERA) {
  	camera_running = true;
    intval2.Camera();
  } else if (val == mc.CAMERA_FORWARD) {
    SetDirection(true);
  } else if (val == mc.CAMERA_BACKWARD) {
    SetDirection(false);
  } else if (val == mc.CAMERA_OPEN) {
  	open_running = true;
    //CameraOpen();
  } else if (val == mc.CAMERA_CLOSE) {
  	close_running = true;
    //CameraClose();
  } else if (val == mc.CAMERA_EXPOSURE) {
    SetExposure();  
  } else if (val == mc.STATE) {
    State();
  }
}

void State () {
  String stateString = String(mc.STATE);
  stateString += String(mc.CAMERA_EXPOSURE);
  stateString += intval2.State();
  stateString += String(mc.STATE);
  mc.sendString(stateString);
}

void SetDirection (boolean state) {
  intval2.Direction(state);
  if (state) {
    mc.confirm(mc.CAMERA_FORWARD);
    mc.log("camera_direction(true)");
  } else {
    mc.confirm(mc.CAMERA_FORWARD);
    mc.log("camera_direction(false)");
  }
}

//sending "0" will reset to default exposure time
void SetExposure () {
  timed_exposure_str = mc.getString();
  timed_exposure_ms = timed_exposure_str.toInt();
  intval2.Exposure(timed_exposure_ms);
  mc.confirm(mc.CAMERA_EXPOSURE);
  mc.log("Set exposure time to: ");
  mc.log(timed_exposure_str);
}