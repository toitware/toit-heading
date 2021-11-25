# Heading

Compute the heading given the acceleration and magnetic field.

Some sensors, like the sensors of the LSM303 family, provide an acceleration
and magnetic field.

This package uses the acceleration to compute the ground-vector, assuming that
acceleration vector points towards the ground. If the sensors experiences other
accelerations the computed heading might thus be off.
