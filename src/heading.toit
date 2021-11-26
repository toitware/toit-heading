// Copyright (C) 2021 Toitware ApS. All rights reserved.
// Use of this source code is governed by an MIT-style license that can be found
// in the LICENSE file.

import math

/**
Returns the heading of the device with respect to the given $base_vector.

Uses the $acceleration to find "down". If the device is moved, the heading
  thus might be off.

The units of the $acceleration and $magnetic_field are not important as they
  are only used to find a direction.

Returns the heading in degrees.
*/
compute_heading --acceleration/math.Point3f --magnetic_field/math.Point3f --base_vector/math.Point3f -> float:
  a_vector := acceleration
  mag_vector := magnetic_field

  e_vector := vector_cross_ mag_vector a_vector
  e_normalized := vector_normalize_ e_vector
  n_vector := vector_cross_ a_vector e_normalized
  n_normalized := vector_normalize_ n_vector

  heading_rads := math.atan2
      vector_dot_ e_normalized base_vector
      vector_dot_ n_normalized base_vector
  heading := heading_rads * 180 / math.PI
  if heading < 0.0: heading += 360.0
  return heading

vector_cross_ v1/math.Point3f v2/math.Point3f -> math.Point3f:
  return math.Point3f
      v1.y * v2.z - v1.z * v2.y
      v1.z * v2.x - v1.x * v2.z
      v1.x * v2.y - v1.y * v2.x

vector_dot_ v1/math.Point3f v2/math.Point3f -> float:
  return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z)

vector_normalize_ v/math.Point3f -> math.Point3f:
  len := math.sqrt (vector_dot_ v v)
  return v / len
