#include <SoftwareSerial.h>
#include <Servo.h>

int LED = 13;   // onboard led on pin 13
Servo myservo;  // create servo object
SoftwareSerial BLE_Shield(4,5);   // setting rx/tx to 4,5 instead of 4,5

void setup() {
  // put your setup code here, to run once:

  pinMode(LED, OUTPUT);     // set pin 13 as an output
  digitalWrite(LED, HIGH);  // turn on led to high voltage

  myservo.attach(9);        // attach servo object to pin 9
  myservo.write(0);         // initial servo position to 0

  BLE_Shield.begin(9600);   // setup serial port at 9600 bps (default baud rate)
  
}

void loop() {
  // put your main code here, to run repeatedly:

  delay(500);
  digitalWrite(LED, LOW);
  delay(500);
  digitalWrite(LED, HIGH);

  // see if new position data is available
  if (BLE_Shield.available()) {
    myservo.write(BLE_Shield.read());   // write position to servo
  }

}
