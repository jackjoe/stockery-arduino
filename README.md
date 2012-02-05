Stockery ~ Arduino
==================

Small Arduino sketch that reads the portfolio of a user from his/her [Stockery](http://stockery-arduino.herokuapp.com/) account.
Uses the WiFly Shield and WiFly library, and the aJson library to parse the result.

Then - according to the status of your stock portfolio - flashes a green LED (inc of min 1%), yellow LED (status quo or inc < 1%) or red LED (dec), 
and an LCD ticker with your stocks.

Hardware
--------

The electronic setup consists of an Arduino Duemilanove (any Arduino should do), a WiFly Shield , a standard Hitachi HD44780 compatible LCD display and some LEDs. Most tutorials about connecting an LCD to the Arduino use the pins 12, 11, 7, 8, 9, 10. But we were already using them for the WiFly shield, so we choose other pins. The mapping is as such:

### LCD ###

    Pin No. Symbol   Destination    Description
    ------  ------   -----------    ------------------------
    1          VSS → GND            Ground
    2          VDD → 5V             Supply Voltage for logic
    3           V0 → Pot Leg 2      Variable Operating voltage for LCD
    4           RS → Arduino 7      Register Selector (H: DATA, L: Instruction code)
    5          R/W → GND            Read/Write Selector (H: Read(MPU→Module) L: Write(MPU→Module))
    6           EN → Arduino 6      Chip enable signal
    7          DB0 → No Connection  Data bit 0
    8          DB1 → No Connection  Data bit 1
    9          DB2 → No Connection  Data bit 2
    10         DB3 → No Connection  Data bit 3
    11         DB4 → Arduino 2      Data bit 4
    12         DB5 → Arduino 3      Data bit 5
    13         DB6 → Arduino 4      Data bit 6
    14         DB7 → Arduino 5      Data bit 7
    15      LED(+) → 5V             Anode of LED Backlight
    16      LED(-) → GND            Cathode of LED Backlight

LCD Pin Explanation
-------------------
(Taken from the Arduino site, might be helpful)

A **register select (RS)** pin that controls where in the LCD's memory you're writing data to. You can select either the data register, which holds what goes on the screen, or an instruction register, which is where the LCD's controller looks for instructions on what to do next.

A **Read/Write (R/W)** pin that selects reading mode or writing mode

An **Enable** pin that enables writing to the registers

8 **data pins (D0 -D7)**. The states of these pins (high or low) are the bits that you're writing to a register when you write, or the values you're reading when you read.

There's also a display constrast pin (Vo), power supply pins (+5V and Gnd) and LED Backlight (Bklt+ and BKlt-) pins that you can use to power the LCD, control the display contrast, and turn on and off the LED backlight, respectively.

Software
--------

-- coming soon


Remarks
-------

WPA/WPA2 only
G mode (mixed mode gave problem)
