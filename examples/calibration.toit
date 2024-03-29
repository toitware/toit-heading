// Copyright (C) 2021 Toitware ApS.
// Use of this source code is governed by a Zero-Clause BSD license that can
// be found in the EXAMPLES_LICENSE file.

import gpio
import i2c
import lsm303dlhc show *
import system.storage

/**
Example program to show how to calibrate a magnetometer in preparation for
  computing the heading.

While running the program move the sensor in a figure 8 shape. Ideally,
  the sensor should be in almost every angle/orientation possible.

The goal of the calibration is to find the min/max values the sensor measures.

The calibration settings are stored in the flash with the key
  "mag-calibration". This way, any other app on the device can take
  advantage of the calibration settings.
*/

main:
  bucket := storage.Bucket.open --flash "toitware/toit-heading"
  bus := i2c.Bus
      --sda=gpio.Pin 21
      --scl=gpio.Pin 22

  device := bus.device Magnetometer.I2C_ADDRESS
  magnetometer := Magnetometer device

  min_x := 0x3FFF_FFFF
  min_y := 0x3FFF_FFFF
  min_z := 0x3FFF_FFFF
  max_x := -(0x3FFF_FFFF)
  max_y := -(0x3FFF_FFFF)
  max_z := -(0x3FFF_FFFF)

  old_calibration := null
  magnetometer.enable
  counter := 0
  while true:
    field := magnetometer.read --raw
    x := field[0]
    y := field[1]
    z := field[2]
    if x < min_x: min_x = x
    if x > max_x: max_x = x
    if y < min_y: min_y = y
    if y > max_y: max_y = y
    if z < min_z: min_z = z
    if z > max_z: max_z = z
    counter++
    // Update the store every 32 values.
    if counter & 0x1F == 0:
      calibration := [(max_x + min_x) / 2, (max_y + min_y) / 2, (max_z + min_z) / 2]
      if calibration != old_calibration:
        old_calibration = calibration
        bucket["mag-calibration"] = calibration
        print "New calibration: $calibration"
    sleep --ms=50
