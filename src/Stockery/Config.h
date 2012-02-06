#ifndef __CONFIG_H__
#define __CONFIG_H__

// Wifi parameters
//char passphrase[] = "bbdo2007wlan";
//char ssid[] = "BBDOBELGIUM";

char passphrase[] = "w1nn13th3p00h";
char ssid[] = "GhettoAir";

// CONST
int BAUDRATE = 9600;
int LED_RED = 11;
int LED_ORANGE = 12;
int LED_GREEN = 13;
int DELAY = 200;
int TIMEOUT = 10000;     // time to wait between ws polls
int INTRO_TIMEOUT = 3000;

// VARS
float avg;
int  serIn;
char inputString[200];
int  serInIndx  = 0;
int  serOutIndx = 0;
boolean nextLine = true;
int row = 0;
int previousMillis = 0;


// Stockery API
char * apiServer = "stockery-arduino.herokuapp.com";
String apiServerStr = "stockery-arduino.herokuapp.com";
String apiEndpoint = "/portfolios/jeroenb.json";

//char * apiServer = "jozefienenjeroen.be";
//char * apiServer = "fluxdesign.be";
//String apiEndpoint = "/stockery.php";

int apiPort = 80;

#endif
