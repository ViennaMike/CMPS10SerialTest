// Serial interface test, returning the high precision bearing and raw magnetometer
// readings.  

// 10/20/2012 Added raw magnetometer readings and cleaned up the code.


#include <SparkSoftLCD.h>
#include <SoftwareSerial.h>

#define DEBUG 1 

// Set compass pins 
int Compass_RX = 12;
int Compass_TX = 13;
SoftwareSerial compass(Compass_RX, Compass_TX); 
 
// LCD transmit pin and initialize library for Sparkfun serial LCD
int LCD_TX = 9;
SparkSoftLCD lcd = SparkSoftLCD(LCD_TX);

float bearing;
float rawBearing;
byte highBearing, lowBearing;
byte bearingCmd = 0x13;
byte rawMagCmd = 0x21;

// Function to display heading
void displayBearings (float h, float rh) {  
  lcd.cursorTo(1,1);
  lcd.print("Bearing: ");
  lcd.print(h, (byte) 1); 
  lcd.cursorTo(2, 1);
  lcd.print("Raw B: ");
  lcd.print(rh, (byte) 1);
  }

void setup(){
  #ifdef DEBUG  
    Serial.begin(9600);
    Serial.println("Compass Test"); 
  #endif
  delay(100);
  pinMode(Compass_TX, OUTPUT);
  pinMode(Compass_RX, INPUT);
  compass.begin(9600);

  delay(100);
   // setup lcd
   pinMode(LCD_TX, OUTPUT);
   lcd.begin(9600);
   delay(100);
   lcd.clear();
   lcd.cursor(0);    // hidden cursor
}// End setup

void loop(){
  // Get heading and raw data from compass and display to LCD
  byte xHigh, xLow, yHigh, yLow, zHigh, zLow;
  double x, y, rawH;
  
  compass.write(bearingCmd);
  if (compass.available() > 1) {
    highBearing = compass.read();
    lowBearing = compass.read();
  }
  bearing = ((highBearing<<8)+lowBearing)/10.;
  compass.write(rawMagCmd);
  if (compass.available() > 5) {
    xHigh = compass.read();
    xLow = compass.read();
    yHigh = compass.read();
    yLow = compass.read();
    zHigh = compass.read();
    zLow = compass.read();
  }
  x = (int) word(xHigh, xLow);
  y = (int) word(yHigh, yLow);
  rawH = (atan2(y, x)) ;
 // Correct for when signs are reversed.
 if (rawH < 0) {
   rawH += 2*PI;
 }
 // Convert radians to degrees for readability.
 rawBearing = RAD_TO_DEG * rawH;  // Correct for when signs are reversed.
         
  #ifdef DEBUG
    Serial.print(" Command: ");
    Serial.write(bearingCmd);
    Serial.print(" highByte: ");
    Serial.print(highBearing, HEX);
    Serial.print(" lowByte: ");
    Serial.println(lowBearing, HEX); 
    Serial.print(" Bearing: ");
    Serial.println(bearing);
    Serial.print(" Command: ");
    Serial.write(rawMagCmd);
    Serial.print(" xHigh: ");
    Serial.print(xHigh, HEX);
    Serial.print(" xLow: ");
    Serial.print(xLow, HEX);
    Serial.print(" yHigh: ");
    Serial.print(yHigh, HEX);
    Serial.print(" yLow: ");
    Serial.println(yLow, HEX);
    Serial.print("raw bearing: ");
    Serial.println(rawBearing);
  #endif
  displayBearings(bearing, rawBearing);
  delay(640);
} // End loop
