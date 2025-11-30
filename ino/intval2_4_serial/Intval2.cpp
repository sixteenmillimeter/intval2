
#include "Intval2.h"

/**
 * 
 **/

void Intval2::begin () {
	PinsInit();
	ButtonsInit();
	//timed_open = OpenTiming();
}

void Intval2::loop () {
	timer = millis();
  
	Button(0);
	Button(1);
	Button(2);
	Button(3);

	if (timelapse && delaying) {
		TimelapseWatchDelay();
	}

	if (running) {
		if (timed_exposure) {
			TimedExposureWatch();  
		} else {
			ReadMicroswitch(); 
		}
	}

	if (opening) {
		OpeningWatchDelay();
	}

	if (closing) {
		ReadMicroswitch();
	}

	if (!running && !timelapse && !delaying){ 
		delay(LOOP_DELAY);
	}
}

void Intval2::PinsInit () {
	pinMode(PIN_MOTOR_FORWARD, OUTPUT);
	pinMode(PIN_MOTOR_BACKWARD, OUTPUT);
	pinMode(PIN_MICROSWITCH, INPUT_PULLUP);
	pinMode(PIN_INDICATOR, OUTPUT);
}

void Intval2::ButtonsInit () {
	for (int i = 0; i < 4; i++) {
		pinMode(BUTTONS[i], INPUT_PULLUP);
	}
}

void Intval2::TimelapseWatchDelay () {
	if (timer - delay_start >= timelapse_delay) {
		delaying = false;
		Camera();
	}
}

void Intval2::ReadMicroswitch () {
	if (timer - frame_start >= MICROSWITCH_DELAY) {
		microswitch_position = digitalRead(PIN_MICROSWITCH);
    	if (microswitch_position == LOW && !microswitch_primed) {
			microswitch_primed = true;
    	} else if (microswitch_position == HIGH && microswitch_primed) {
    		if (running) {
    			Stop();
    		} else if (closing) {
				ClosingStop();
			}
    	}
    	delay(2); //smooths out signal
	}
}

void Intval2::OpeningWatchDelay () {
	if (opening && timer - open_start >= open_stop) {
		OpeningStop();
	}
}

void Intval2::Direction (boolean state) {
	direction = state;
}

void Intval2::Exposure (unsigned long ms) {
	if (ms < 600) {
		timed_exposure_ms = 0;
    	timed_exposure = false;
	} else {
		timed_exposure_ms = ms;
		timed_exposure = true;
	}
}

void Intval2::Camera () {
	frame_start = millis();

	if (timed_exposure) {
		timed_exposure_opening = true;
		open_start = millis();
		if (direction) {
			open_stop = round( (float) avg * MOTOR_OPEN_FORWARD );
		} else {
			open_stop = round((float) avg * MOTOR_OPEN_BACKWARD);
		}
		timed_exposure_delay = timed_exposure_ms - round( (float) avg * MOTOR_OPEN_ANGLE );
	}
	MotorStart();
	running = true;
	microswitch_primed = false;
}

void Intval2::Stop () {
	delay(10); //examine
	MotorStop();

	exposure = timer - frame_start;
	running = false;
	closed = true;
	open = false;

	if (direction) {
		counter += 1;
	} else {
		counter -= 1;
	}  

	if (timed_exposure) {
		timed_exposure_avg = round((timed_exposure_avg + exposure) / 2);
		close_avg = round((close_avg + (timer - close_start)) / 2);
		timed_exposure_closing = false;
		timed_exposure_opening = false;
		timed_exposure_open = false;
	} else {
		avg = round((avg + exposure) / 2);
	}

	if (timelapse) {
		delaying = true;
		delay_start = millis();
	}
}

void Intval2::Open () {
	opening = true;
	closing = false;
	open = false;
	closed = false;
	open_start = millis();
	frame_start = millis();

	if (direction) {
		open_stop = round((float) avg * MOTOR_OPEN_FORWARD);
	} else {
		open_stop = round((float) avg * MOTOR_OPEN_BACKWARD);
	}

	if (!open) {
		MotorStart();
	} else {
		opening = false;
	}
}

void Intval2::OpeningStop () {
	MotorStop();
	opening = false;
	open = true;
	open_avg = round(((timer - open_start) + open_avg) / 2);
}

void Intval2::Close () {
	closing = true;
	opening = false;
	open = false;
	closed = false;
	close_start = millis();
	frame_start = millis();

	if (!closed) {
		MotorStart();
	} else {
		closing = false;
	}
}

void Intval2::ClosingStop () {
	MotorStop();
	closing = false;
	closed = true;
	close_avg = round(((timer - close_start) + close_avg) / 2);
}

void Intval2::MotorStart () {
	if (direction) {
		analogWrite(PIN_MOTOR_FORWARD, MOTOR_PWM);
    	analogWrite(PIN_MOTOR_BACKWARD, 0);
	} else {
    	analogWrite(PIN_MOTOR_BACKWARD, MOTOR_PWM);
    	analogWrite(PIN_MOTOR_FORWARD, 0);
	} 
}

void Intval2::MotorStop () {
	analogWrite(PIN_MOTOR_FORWARD, 0);
	analogWrite(PIN_MOTOR_BACKWARD, 0);
}

void Intval2::TimedExposureClose () {
	MotorStart();
	open = false;
	timed_exposure_open = false;
	timed_exposure_closing = true;
	close_start = millis();
}

void Intval2::TimedExposurePause () {
	timed_exposure_open = true;
	timed_exposure_opening = false;
	open = true;
	MotorStop();
	open_avg = round(((timer - open_start) + open_avg) / 2);
}



void Intval2::TimedExposureWatch () {
	if (timed_exposure_opening) {
		if (timer - frame_start >= open_stop) {
			TimedExposurePause();
		}
	} else if (timed_exposure_open) {
		if (timer - frame_start >= open_stop + timed_exposure_delay) {
			TimedExposureClose();
		}
	} else if (timed_exposure_closing) {
		ReadMicroswitch();
	}
}

void Intval2::Button (uint8_t index) {
	int val = digitalRead(BUTTONS[index]); // ;)
	if (val != button_states[index]) {
		if (val == LOW) {
			// pressed
			button_times[index] = millis();
		} else if (val == HIGH) { 
			// not pressed
			button_time = millis() - button_times[index]; //time?
			ButtonEnd(index, button_time);
		}
	}
	button_states[index] = val;
}

void Intval2::ButtonEnd (uint8_t index, long time) {
	if (index == 0) {
		if (time > 1000) {
			if (!timelapse && !running) {
				timelapse = true;
				Output(2, 75);
				Camera();
			}
		} else {
			if (timelapse) {
				timelapse = false;
				//Output(2, 75);
			} else {
				Camera();
			}
		}
	} else if (index == 1) { //set delay
		if (time < 42) {
			timelapse_delay = 42;
			Output(1, 500);
		} else {
			timelapse_delay = time;
			Output(2, 250);
		}
	}  else if (index == 2) { // set speed
		if (time >= 1000) {
			//timed_delay = time - BOLEX_C;
			timed_exposure = true;
			Output(2, 250);
		} else if (time < 1000) {
			//timed_delay = 0;
			timed_exposure = false;
			Output(1, 500);    
		}
	} else if (index == 3) { //set direction
		if (time < 1000) {
			direction = true;
			Output(1, 500);
		} else if (time > 1000) {
			direction = false;
			Output(2, 250);
		}
	}
	//time = 0;
}

void Intval2::Output (uint8_t number, uint16_t len) {
	for (int i = 0; i < number; i++) {
		Indicator(true);
		delay(len);
		Indicator(false);
		delay(42);
	}
}

void Intval2::Indicator (boolean state) {
	if (state) {
		digitalWrite(PIN_INDICATOR, HIGH);
	} else {
		digitalWrite(PIN_INDICATOR, LOW);
	}
}



String Intval2::State () {
	if (timed_exposure) {
		return String(timed_exposure_avg);
	}
	return String(avg);
}

boolean Intval2::IsOpening() {
	return opening;
}
	
boolean Intval2::IsClosing() {
	return closing;
}
	
boolean Intval2::IsRunning() {
	return running;
}
