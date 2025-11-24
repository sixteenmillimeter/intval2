
#include "Intval2.h"


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
			TimedExposureReadMicroswitch();  
		} else {
			ReadMicroswitch(); 
		}
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

boolean Intval2::WatchMicroswitchDelay () {
  if (timer - frame_start >= MICROSWITCH_DELAY) {
    return true;
  }
  return false;
}

void Intval2::ReadMicroswitch () {
  if (WatchMicroswitchDelay()) {
    microswitch_position = digitalRead(PIN_MICROSWITCH);
    if (microswitch_position == LOW 
        && microswitch_primed == false) {
      microswitch_primed = true;
    } else if (microswitch_position == HIGH 
              && microswitch_primed == true) {
      Stop();
    }
    delay(2);//smooths out signal
  }
}

void Intval2::TimedExposureReadMicroswitch () {
  //TODO: FIX
  if (!timed_exposure_open) {
    if (timer - frame_start > timed_open 
      && timer - frame_start < timed_open + timed_delay) {
       TimedExposurePause();
    } else if (timer - frame_start > timed_open + timed_delay) {
      microswitch_position = digitalRead(PIN_MICROSWITCH);
      if (microswitch_position == HIGH) {
        Stop();
      }
      delay(2);//smooths out signal  
    }
  }
  //TODO: FIX
  if (timed_exposure_open && timer - frame_start > timed_open + timed_delay) {
    TimedExposureStart();   
  }
}

void Intval2::Stop () {
  delay(10); //examine
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
  
  running = false;
  microswitch_primed = false;

  if (direction) {
    counter += 1;  
  } else {
    counter -= 1;
  }

  exposure = timer - frame_start;
  
  if (timed_exposure) {
    timed_exposure_avg = round((timed_exposure_avg + exposure) / 2);
  } else {
    avg = round((avg + exposure) / 2);
  }

  if (timelapse) {
    delaying = true;
    delay_start = millis();
  }
}

void Intval2::TimedExposureStart () {
  timed_exposure_open = false;
   if (direction) {
    analogWrite(PIN_MOTOR_FORWARD, MOTOR_PWM);
    analogWrite(PIN_MOTOR_BACKWARD, 0);
  } else {
    analogWrite(PIN_MOTOR_BACKWARD, MOTOR_PWM);
    analogWrite(PIN_MOTOR_FORWARD, 0);
  } 
}

void Intval2::TimedExposurePause () {
  timed_exposure_open = true;
  analogWrite(PIN_MOTOR_FORWARD, 0);
  analogWrite(PIN_MOTOR_BACKWARD, 0);
}

void Intval2::Button (uint8_t index) {
  int val = digitalRead(BUTTONS[index]); // ;)
  if (val != button_states[index]) {
    if (val == LOW) { // pressed
      button_times[index] = millis();
    } else if (val == HIGH) { // not pressed
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
  time = 0;
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