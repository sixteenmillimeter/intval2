#!/bin/bash

set -e

arduino-cli compile -b "arduino:avr:nano"
arduino-cli upload -b "arduino:avr:nano" -p /dev/ttyUSB0 .
arduino-cli monitor -p /dev/ttyUSB0 -b arduino:avr:nano --config 57600