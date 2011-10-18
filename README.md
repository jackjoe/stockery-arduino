Stockery ~ Arduino
==================

Small Arduino sketch that reads the portfolio of a user from his/her [Stockery](http://stockery-arduino.herokuapp.com/) account.
Uses the WiFly Shield and WiFly library, and the aJson library to parse the result.

Then - according to the status of your stock portfolio - flashes a green LED (inc of min 1%), yellow LED (status quo or inc < 1%) or red LED (dec), 
and an LCD ticker with your stocks.

Hardware
--------

The electronic setup consists of an Arduino Duemilanove (any Arduino should do), a WiFly Shield , a standard Hitachi HD44780 compatible LCD display and some LEDs.

LCD PIN           ARDUINO PIN
RS  = 4     ->      7
EN  = 6     ->      8
D7  = 14    ->      12
D6  = 13    ->      11
D5  = 12    ->      10
D4  = 11    ->      9
GND = 16    ->      GND
5V  = 15    ->      5V
      1     ->      GND
      2     ->      5V
      3     ->      CONTRAST (POTENTIOMETER)
      5     ->      GND (R/W PIN)

Software
--------

-- coming soon


