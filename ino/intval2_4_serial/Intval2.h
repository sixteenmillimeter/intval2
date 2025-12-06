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
	const uint8_t TRIGGER = 0;
	const uint8_t DELAY = 1;
	const uint8_t SPEED = 2;
	const uint8_t DIRECTION = 3;

	const uint16_t OUTPUT_SHORT = 75;
	const uint16_t OUTPUT_MEDIUM = 250;
	const uint16_t OUTPUT_LONG = 500;

	const uint8_t OUTPUT_ONE = 1;
	const uint8_t OUTPUT_TWO = 2;

	const unsigned long TIMED_EXPOSURE_CUTOFF = 1000;

	//MOTOR CONST
	const uint16_t MOTOR_RPM = 120; 
	const float MOTOR_OPEN_FORWARD = 0.275; // 99deg
	const float MOTOR_OPEN_BACKWARD = 0.675; //243deg
	const float MOTOR_OPEN_ANGLE = 0.3694; // 133deg
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
	volatile boolean opening = false;
	volatile boolean closing = false;
	volatile boolean delaying = false;
	volatile boolean open = false;
	volatile boolean closed = true;
	volatile boolean bulb = false;
	volatile boolean bulb_running = false;

	volatile boolean timed_exposure_open = false; //is the shutter open only during a timed exposure
	volatile boolean timed_exposure_opening = false;
	volatile boolean timed_exposure_closing = false;

	volatile uint8_t microswitch_position = 0;
	volatile boolean microswitch_primed = false;


	//BUTTON VAR
	volatile uint8_t button_states[4] = {1, 1, 1, 1};
	volatile unsigned long button_times[4] = {0, 0, 0, 0};
	volatile unsigned long button_time = 0;

	//TIME VAR
	volatile unsigned long timer;
	volatile unsigned long frame_start = 0;
	volatile unsigned long delay_start = 0;
	volatile unsigned long open_start = 0;
	volatile unsigned long open_stop = 100; //ms to stop running after when camera is fully-opened
	volatile unsigned long open_avg = 300;
	volatile unsigned long close_start = 0;
	volatile unsigned long close_avg = 300;
	volatile unsigned long timelapse_delay = 42; //time between frames during timelapse
	volatile unsigned long timed_exposure_ms = 0;
	volatile unsigned long timed_exposure_delay = 0; //ms to delay once camera is open
	volatile unsigned long timed_exposure_avg = 600;
	volatile unsigned long exposure = 0;
	volatile unsigned long avg = 600;
	


	void PinsInit();
	void ButtonsInit();
	void Button (uint8_t index);
	void ButtonStart (uint8_t index);
	void ButtonEnd (uint8_t index, long time);

	void TimelapseWatchDelay();
	void OpeningWatchDelay();

	void ReadMicroswitch();

	void TimedExposureWatch();
	void TimedExposurePause();
	void TimedExposureClose();

	void Stop();
	void OpeningStop();
	void ClosingStop();
	void Output(uint8_t number, uint16_t len);
	void Indicator(boolean state);
	void MotorStart();
	void MotorStop();

	public:
	void begin();
	void loop();
	void Camera();
	void Open();
	void Close();
	void Direction(boolean state);
	void Exposure(unsigned long ms);

	String State();

	boolean IsOpening();
	boolean IsClosing();
	boolean IsRunning();

	unsigned long GetExposure();
};

#endif