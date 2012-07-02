
#include <SparkSoftLCD.h>
#include <SoftwareSerial.h>

#define DEBUG 1 

// Set compass pins 
int Compass_RX = 2;
int Compass_TX = 3;
SoftwareSerial compass(2, 3); 
 
// LCD transmit pin and initialize library for Sparkfun serial LCD
int LCD_TX = 9;
SparkSoftLCD lcd = SparkSoftLCD(LCD_TX);

float bearing;
byte highByte, lowByte;
byte command = 0x13;

// Function to display heading
void displayBearing (float h) {  
  lcd.cursorTo(1,1);
  lcd.print("Bearing: ");
  lcd.print(h, (byte) 1); 
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
  byte highByte, lowByte;
  // Get heading from compass and display to LCD
  compass.write(command);
  if (compass.available() <1);
  highByte = compass.read();
  lowByte = compass.read();
  bearing = ((highByte<<8)+lowByte)/10.;
   
  #ifdef DEBUG
    Serial.print(" Command: ");
    Serial.write(command);
    Serial.print(" highByte: ");
    Serial.print(highByte, HEX);
    Serial.print(" lowByte: ");
    Serial.print(lowByte, HEX); 
    Serial.print(" Bearing: ");
    Serial.println(bearing);
  #endif
  displayBearing(bearing);
} // End loop
