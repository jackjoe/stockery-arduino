#include <aJSON.h>
#include <WiFly.h>

#include "Config.h"

/* -----------------------------------------------------
* Arduino - Stockery
* --------------------------------------------------- */

// CONST
int BAUD_RATE = 9600;
int LED_RED = 11;
int LED_ORANGE = 12;
int LED_GREEN = 13;
int DELAY = 200;
int TIMEOUT = 1000;     // time to wait between ws polls

// VARS
float avg;
int  serIn;
char inputString[200];
int  serInIndx  = 0;
int  serOutIndx = 0;

// Stockery API
char * api_server = "http://www.google.com";
String api_endpoint = "/";
int api_port = 80;

// Webclient
Client client(api_server, api_port);

// read a string from the serial and store it in an array
void readSerialString () {
  int sb;   
  while (Serial.available()){ 
    sb = Serial.read();             
    inputString[serInIndx] = sb;
    serInIndx++;
  }
  Serial.println();
}

void clearSerialString() {
  if( serInIndx > 0) {
    //loop through all bytes in the array and print them out
    for(serOutIndx=0; serOutIndx < serInIndx; serOutIndx++) {     
      inputString[serOutIndx] = '0';
    }

    serOutIndx = 0;
    serInIndx  = 0;
  }
}

void blinkLed(int led) {
  digitalWrite(led, HIGH);
  delay(DELAY);
  digitalWrite(led, LOW);   
}

void updateUI() {
  if(avg >= 1) {
    blinkLed(LED_GREEN);
  } else if(avg < 1 && avg >= 0) {
    blinkLed(LED_ORANGE);
  } else {
    blinkLed(LED_RED);
  } 
}

void parseResponse() {
  // parse to json
  aJsonObject* response = aJson.parse(inputString);

  // read average for LED blinking
  aJsonObject* tmp = aJson.getObjectItem(response, "avg");
   avg = (float) tmp->valuefloat;
  Serial.println(tmp->valuefloat);
}

void setup() {
  // setup serial communication
  Serial.begin(BAUD_RATE);
  
  Serial.println("Init WiFly...");
  
  WiFly.begin();
  
  if (!WiFly.join(ssid, passphrase)) {
    Serial.println("Association failed.");
    while (1) {
      // Hang on failure.
    }
  }  
  
  Serial.println("Connecting...");
  
   if (client.connect()) {
    Serial.println("connected");
    client.println("GET /search?q=arduino HTTP/1.0");
    client.println();
  } else {
    Serial.println("connection failed");
  }
  
  // setup LED lights 
  pinMode(LED_RED, OUTPUT);
  pinMode(LED_ORANGE, OUTPUT);
  pinMode(LED_GREEN, OUTPUT);
}

void loop () {
  if (client.available()) {
    char c = client.read();
    Serial.println("-- char read");
    Serial.print(c);
  }
  
  if (!client.connected()) {
    Serial.println();
    Serial.println("disconnecting.");
    client.stop();
    for(;;)
      ;
  }
  
  /*
  
  if(Serial.available()) { 
    // reset read buffer
    clearSerialString();
    
    // read the serial port and create a string
    readSerialString();
   
    // analyse string and create visual output
    parseResponse();
  }
  
  updateUI();
  
  // wait for next poll
  delay(TIMEOUT);
  */
}
