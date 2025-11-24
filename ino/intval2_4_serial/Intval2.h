#ifndef INTVAL2
#define INTVAL2

#include <Arduino.h>

class Intval2 {
	private:

	// PIN CONST
	const uint8_t PIN_INDICATOR = 13; //Arduino Nano LED
	const uint8_t PIN_MOTOR_FORWARD = 9;
	const uint8_t PIN_MOTOR_BACKWARD = 10;
	const uint8_t PIN_MICROSWITCH = 19; //A5
	const uint8_t BUTTONS[4] = {3, 4, 5, 6};  //trigger, delay, speed, direction

	//MOTOR CONST
	const uint16_t MOTOR_RPM = 120; 
	const float MOTOR_OPEN_FORWARD = 0.25;
	const float MOTOR_OPEN_BACKWARD = 0.75;
	const uint8_t MOTOR_PWM = 255; // Not varying this for now
	const uint16_t MICROSWITCH_DELAY = 50;

	//ETC CONST
	const uint16_t LOOP_DELAY = 10;

	//STATE VAR
	volatile uint32_t counter = 0;
	volatile boolean direction = true;
	volatile boolean running = false;
	volatile boolean timelapse = false;
	volatile boolean timed_exposure = false;
	volatile boolean delaying = false;
	volatile boolean open = false; //is the shutter open
	volatile boolean timed_exposure_open = false; //is the shutter open only during a timed exposure
	volatile uint8_t microswitch_position = 0;
	volatile boolean microswitch_primed = false;

	//BUTTON VAR
	volatile int button_states[4] = {1, 1, 1, 1};
	volatile long button_times[4] = {0, 0, 0, 0};
	volatile long button_time = 0;

	//TIME VAR
	volatile unsigned long timer;
	volatile unsigned long frame_start = 0;
	volatile unsigned long delay_start = 0;

	volatile unsigned long timelapse_delay = 42; //time between frames during timelapse

	volatile String timed_exposure_str = "600";
	volatile unsigned long timed_exposure_val = 600;
	volatile unsigned long timed_open = 100; //ms after start_frame to pause
	volatile unsigned long timed_delay = 0;
	
	volatile unsigned long exposure = 0;

	volatile unsigned long avg = 600;
	volatile unsigned long timed_exposure_avg = 600;

	void PinsInit();
	void ButtonsInit();
	void Button (uint8_t index);
	void ButtonEnd (uint8_t index, long time);
	boolean WatchMicroswitchDelay();
	void TimelapseWatchDelay();
	void ReadMicroswitch();
	void TimedExposureReadMicroswitch();
	void TimedExposureStart();
	void TimedExposurePause();
	void Stop();
	void Output(uint8_t number, uint16_t len);
	void Indicator(boolean state);

	public:
	void begin();
	void loop();
	void Camera();
	String State();

};

#endif