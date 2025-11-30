#include "McopySerial.h"
#include "Intval2.h"

McopySerial mc;
Intval2 intval2;
volatile char cmd_char = 'z';

volatile boolean camera_running = false;
volatile boolean open_running = false;
volatile boolean close_running = false;
volatile boolean debug = false;

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

	if (camera_running && !intval2.IsRunning()) {
		mc.confirm(mc.CAMERA);
		if (debug) {
			mc.log("Camera completed");
			mc.log(String(intval2.GetExposure()));
		}
		camera_running = false;
	}

	if (open_running && !intval2.IsOpening()) {
		mc.confirm(mc.CAMERA_OPEN);
		mc.log("camera_open()");
		open_running = false;
	}

	if (close_running && !intval2.IsClosing()) {
		mc.confirm(mc.CAMERA_CLOSE);
		mc.log("camera_close()");
		close_running = false;
	}
}

void cmd (char val) {
	if (val == mc.CAMERA) {
		camera_running = true;
		intval2.Camera();
		camera_running = true;
	} else if (val == mc.CAMERA_FORWARD) {
		SetDirection(true);
	} else if (val == mc.CAMERA_BACKWARD) {
		SetDirection(false);
	} else if (val == mc.CAMERA_OPEN) {
		open_running = true;
		intval2.Open();
	} else if (val == mc.CAMERA_CLOSE) {
		close_running = true;
		intval2.Close();
	} else if (val == mc.CAMERA_EXPOSURE) {
		SetExposure();  
	} else if (val == mc.STATE) {
		State();
	} else if (val == mc.DEBUG) {
		debug = !debug;
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
		mc.confirm(mc.CAMERA_BACKWARD);
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