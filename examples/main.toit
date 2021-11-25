// Copyright (C) 2021 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import gpio
import i2c
import lsm303dlhc show *
import math
import device show FlashStore

BASE_VECTOR ::= math.Point3f 1.0 0.0 0.0

main:
  store := FlashStore
  bus := i2c.Bus
    --sda=gpio.Pin 21
    --scl=gpio.Pin 22

  calibration := (FlashStore).get "mag-calibration"
  if not calibration: calibration = [0, 0, 0]

  magnetometer := Magnetometer (bus.device Magnetometer.I2C_ADDRESS)
  accelerometer := Accelerometer (bus.device Accelerometer.I2C_ADDRESS)

  magnetometer.enable
  accelerometer.enable

  while true:
    magnetic_field := magnetometer.read --raw
    acceleration := accelerometer.read
    magnetic_point3f := math.Point3f
        (magnetic_field[0] - calibration[0]).to_float
        (magnetic_field[1] - calibration[1]).to_float
        (magnetic_field[2] - calibration[2]).to_float

    heading := compute_heading
        --acceleration=acceleration
        --magnetic_field=magnetic_point3f
        --base_vector=BASE_VECTOR

    print heading

    sleep --ms=200
