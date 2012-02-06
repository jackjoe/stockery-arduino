#include <aJSON.h>
#include <WiFly.h>
#include <LiquidCrystal.h>
#include "Config.h"


/* ----------------------------------------------------------
 * Arduino - Stockery
 *
 * Author: Jeroen Bourgois (http://github.com/jeroenbourgois)
 * Version: 0.1
 *
 * Stockery by Pierot (http://github.com/pierot/)
 *
 * Source is on github:
 *   https://github.com/basht/stockery-arduino
 * ---------------------------------------------------------- */

/* ----------------------------------------------------------
 *
 * More info on the implementation and pin numbering can
 * also be found in the project README.md
 *
 * Connecting the LCD
 *
 * Pin No. Symbol   Destination    Description
 * ------  ------   -----------    ------------------------
 * 1          VSS → GND            Ground
 * 2          VDD → 5V             Supply Voltage for logic
 * 3           V0 → Pot Leg 2      Variable Operating voltage for LCD
 * 4           RS → Arduino 7      Register Selector (H: DATA, L: Instruction code)
 * 5          R/W → GND            Read/Write Selector (H: Read(MPU→Module) L: Write(MPU→Module))
 * 6           EN → Arduino 6      Chip enable signal
 * 7          DB0 → No Connection  Data bit 0
 * 8          DB1 → No Connection  Data bit 1
 * 9          DB2 → No Connection  Data bit 2
 * 10         DB3 → No Connection  Data bit 3
 * 11         DB4 → Arduino 2      Data bit 4
 * 12         DB5 → Arduino 3      Data bit 5
 * 13         DB6 → Arduino 4      Data bit 6
 * 14         DB7 → Arduino 5      Data bit 7
 * 15      LED(+) → 5V             Anode of LED Backlight
 * 16      LED(-) → GND            Cathode of LED Backlight
 *
 * ---------------------------------------------------------- */

// Webclient
Client client("fluxdesign.be", 80);

// LCD
LiquidCrystal lcd(7, 6, 2, 3, 4, 5);

// Vars
String LOG_PREFIX_SERIAL = "Stockery ~ Arduino: ";
String LOG_PREFIX_LCD = "";

////////////////////////////////////////////////////////
// SETUP
////////////////////////////////////////////////////////


void setup() {
  // init serial comm
  Serial.begin(BAUDRATE);

  log("Setup", false);

  setupLCD();
  
  log("Stockery ~ 0.1", true);

  delay(INTRO_TIMEOUT);
  
  setupWiFly();

  log("Connecting...", true);

  /*
  if (client.connect()) {
   log("Connected", true);
   client.println("GET /stockery.php HTTP/1.0");
   client.println("host: fluxdesign.be");
   client.println(); // VERY IMPORTANT!
   } 
   else {
   log("Connection failed", true);     
   }
   */

  //pinMode(2, OUTPUT);
  //pinMode(3, OUTPUT);
  //pinMode(4, OUTPUT);
  // setup LED lights 
  //  pinMode(LED_RED, OUTPUT);
  //  pinMode(LED_ORANGE, OUTPUT);
  //  pinMode(LED_GREEN, OUTPUT);

}

void setupLCD() {
  lcd.begin(16, 2);
  lcd.setCursor(0, 0);

  log("LCD ready", true);
}

void setupWiFly() {
  log("Init WiFly", true);

  WiFly.begin();

  log("Wifly inited", true);

  if (!WiFly.join(ssid, passphrase)) {
    log("Association failed", true);
    while (1) {
      // Hang on failure.
    }
  }
}

void log(String message, boolean tolcd) {
  Serial.println(LOG_PREFIX_SERIAL + message);

  if(tolcd) {
    lcd.clear();
    lcd.print(LOG_PREFIX_LCD + message);
  }
}

/**
 * The main loop
 */
void loop () {
  if (client.connect()) {
    log("Request successfull", false);
    client.println("GET /stockery.php HTTP/1.0");
    client.println("host: fluxdesign.be");
    client.println(); // VERY IMPORTANT!
  }
  else {
    log("Request failed", false);     
  }

  // parse the response from the client
  String httpResponse = String();

  if (client) {
    while (client.connected()) {
      if (client.available()) { 
        char c = client.read();
        httpResponse += c;
      }
    }
  }

  // extract the data from the httpResponse
  String data = httpResponse.substring(httpResponse.indexOf('{'));

  // parse that data (which is json) and handle the visual outcome
  // the functions returns 1, 0 or -1 depending on the average value
  int average = parseResponse(data);

  if(average >= 1) {
    log("It's bigger!", true);
  } 
  else if(average < 1 && average >= 0) {
    log("It's equal", true);
  } 
  else {
    log("It's lower!", true);
  } 

  /*
  // disconnect the client
   if (!client.connected()) {
   log("Disconnecting", false);
   client.stop();
   for(;;)
   ;
   }
   */

  // wait for next poll
  delay(TIMEOUT);

  /* 
   updateUI();
   */
}


void blinkLed(int led) {
  digitalWrite(led, HIGH);
  delay(DELAY);
  digitalWrite(led, LOW);   
}

void updateUI() {
  if(avg >= 1) {
    blinkLed(LED_GREEN);
  } 
  else if(avg < 1 && avg >= 0) {
    blinkLed(LED_ORANGE);
  } 
  else {
    blinkLed(LED_RED);
  } 
}

/**
 * Helper function to parse the server json response
 *
 * We receive a jsonobject, of this form:
 *    {"average":"0.97","email":"info@jeroenbourgois.be","name":"jeroenb","stocks":[{"name":"Apple","symbol":"APL"},{"name":"Google","symbol":"GOOG"}]}
 * so to parse, we search for the beginning of `average`, then work our way through the delimiters and quotes to extract the value for this property
 */
int parseResponse(String data) {
  int avgIndex = data.indexOf("average");

  int avgDataDelimiterIndex = data.indexOf(":", avgIndex);
  int avgDataBeginIndex = data.indexOf('"', avgDataDelimiterIndex);
  int avgDataEndIndex = data.indexOf('"', avgDataBeginIndex+1);

  String average = data.substring(avgDataBeginIndex+1, avgDataEndIndex); // exclude first quote, exclude last

  return atoi(average.cstr());
}





