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

  setupWiFly();

  log("Connecting...", true);

  if (client.connect()) {
    log("Connected", true);
    client.println("GET /stockery.php HTTP/1.0");
    client.println("host: fluxdesign.be");
    client.println(); // VERY IMPORTANT!
  } 
  else {
    log("Connection failed", true);     
  }

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


#define stringlength 120

void loop () {

  //setup variables for message parsing
  String readstring = String(stringlength);
  char secondtry[stringlength];
  boolean current_state=false;
  boolean validmessage=false;


  //Serial.println("looped");

  /*
  if (client) {
   // an http request ends with a blank line
   boolean current_line_is_blank = true;
   while (client.connected()) {
   if (client.available()) {
   char c = client.read();
   
   for (int i = 0; i<=stringlength-1; i++){
   secondtry[i]=secondtry[i+1];
   }
   secondtry[stringlength-1]=c;
   
   // if we've gotten to the end of the line (received a newline
   // character) and the line is blank, the http request has ended,
   // so we can send a reply
   if (c == '\n' && current_line_is_blank) {
   Serial.println("new HTTP request received");
   //Content-Length: 145
   //Serial.println(secondtry);
   Serial.println("----------------");
   String tmp = secondtry;
   String tmp_cl = tmp.substring(tmp.indexOf("Content-Length"));
   tmp_cl = tmp_cl.substring(17, 3);
   Serial.println(tmp_cl);
   Serial.println("----------------");
   }
   if (c == '\n') {
   //          Serial.println("Non-Blank line received");
   readstring="";
   for (int i=0;i<=stringlength;i++){
   readstring.concat(secondtry[i]);
   }
   //          Serial.println("###############");
   //          Serial.println(readstring);
   if (validmessage==false){
   int questionmark = readstring.indexOf('?');
   if(readstring.substring(questionmark + 1 , questionmark + 7) == "Set=On")
   {
   
   Serial.println("Turned On Kettle");
   current_state=true;
   validmessage=true;
   }
   else if(readstring.substring(questionmark + 1 , questionmark + 8) == "Set=Off")
   {
   
   Serial.println("Turned Off Kettle");
   current_state=false;
   validmessage=true;
   }    
   }
   
   // we're starting a new line
   current_line_is_blank = true;
   } 
   else if (c != '\r') {
   // we've gotten a character on the current line
   current_line_is_blank = false;
   }
   }
   }
   // give the web browser time to receive the data
   delay(200);
   client.stop();
   validmessage=false;
   }
   
   
   
   
   if (!client.connected()) {
   Serial.println();
   Serial.println("disconnecting.");
   Serial.println(secondtry);
   client.stop();
   for(;;)
   ;
   }
   
   */
  /*
  if(nextLine) {
   nextLine = false;
   displayMsgScroll(apiServer); 
   }
   
   delay(TIMEOUT);
   */

  if (client.available()) {
    char c = client.read();
    //Serial.print(c);
    int tmp = sprintf(inputString, "%c", c);
    log(tmp, false);
  }

  if (!client.connected()) {
    log("Disconnecting", true);
    log(inputString, false);
    client.stop();
    for(;;)
      ;
  }



  // wait for next poll

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
   */
}


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
  } 
  else if(avg < 1 && avg >= 0) {
    blinkLed(LED_ORANGE);
  } 
  else {
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



// function displayMsgScroll()
// scrolls a string from right to left across an LCD
// alternaltes between lines to even wear on a lcd-compatible VFD
// expects a pointer to an array of chars
// returns nothing
void displayMsgScroll(char *currentString) {
  int strPos,
  bufPos,
  relStrPos,
  strSize,
  bufSize,
  r;

  row = 0;
  previousMillis = 0;

  char displayBuffer[21] = "                    ";

  bufSize = (strlen(displayBuffer)) - 1;
  strSize = (strlen(currentString)) - 1;

  // slide the buffer from the left side of the string all the way
  // over to the right side plus the length of the buffer
  for (strPos = 0; strPos < (strSize + bufSize + 1); strPos++)
  {
    // fill the buffer with spaces to clear it each time for display
    // we are only going to copy data where it exists
    // but only if we aren't past the end of the string
    if (strPos < strSize)
    {
      for (r = 0; r < (strlen(displayBuffer) - 1); r++)
      {
        displayBuffer[r] = ' ';
      }
    }
    // store the current position in the string
    relStrPos = strPos;
    // start from the right side of the buffer
    bufPos = bufSize;
    // loop until we try to copy past the left side of the string
    // or we reach the left side of the buffer
    while ((relStrPos > -1) && (bufPos > -1))
    {
      // only copy if the relative position in the string based on the position in
      // the buffer is not past the right side of the string
      if (relStrPos < (strSize + 1))
      {
        displayBuffer[bufPos] = currentString[relStrPos];
      }
      else
        // if the buffer is past the end of the string insert spaces
      {
        displayBuffer[bufPos] = ' ';
      }

      // move left one in the string
      relStrPos--;
      // move left one in the buffer
      bufPos--;
    }

    // set the cursor to the start of the row
    lcd.setCursor(0, row);

    // send the buffer to the lcd
    lcd.print(displayBuffer);

    // loop and check serial for data
    previousMillis = millis();
    while (millis() - previousMillis < 200)
    {
      if (Serial.available() > 0)
      {
        // jump back to main
        // even the wear on the VFD by toggling the row used
        if (row == 0)
        {
          row = 1;
        }
        else
        {
          row = 0;
        }  
        lcd.clear();
        return;
      }
    }
  }
  nextLine = true;
}




