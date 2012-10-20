This is a simple example of using the serial interface to Devantech's CMPS10 tilt-compensated compass to an Arduino.
It loops through sending the command requesting the 16 bit (two byte) heading angle (precision of 0.1 degrees) AND 
the raw x and y magnetometer values. It displays both the returned  bearing and the bearing computed from the 
x and y (only) values on a serial LCD display.  If #debug is true, it also send the returned bytes and bearing results
to the default serial port.


To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights 
to this software to the public domain worldwide. 
This software is distributed without any warranty. 

Attribution is appreciated but not required.