//---------------------------------------------------------------------------
// Author: Julio Tena
// Description: Using arduino as slave for basys board output from switches
//
//
// Todo:
//      - Finish all cases
//      - Have speed control??
//
//---------------------------------------------------------------------------

#include <Servo.h>
#include "BasysComm.h"

Servo myservo;  // create servo object to control a servo

#define PIN2 2
#define PIN3 3
#define PIN4 4
#define PIN5 5
#define PIN6 6
#define PIN7 7
#define PIN8 8
#define PIN9 9

#define PIN10 10

int pos = 15;    // variable to store the servo position
int basys_in[8] = {0};
int check = 0;



void setup() {
  // initialize for digital input from basys board
  pinMode(PIN2,INPUT);
  pinMode(PIN3,INPUT);
  pinMode(PIN4,INPUT);
  pinMode(PIN5,INPUT);
  pinMode(PIN6,INPUT);
  pinMode(PIN7,INPUT);
  pinMode(PIN8,INPUT);
  pinMode(PIN9,INPUT);


  Serial.begin(9600);
  myservo.attach(PIN10);  // attaches the servo on pin 10 to the servo object
}

void loop() {

    // Receive all values from basys board and store in array
    // Note: might need time delay to allow time to read all values
    myservo.write(pos);
    readPorts(basys_in);

    if(interrupt(basys_in))
    {
      delay(1000);
      readPorts(basys_in);
      manualMode(basys_in,pos);
      if(basys_in[0] == 1 && basys_in[1] == 1)
      {
        for (int pos = 0; pos <= 165; pos += 15) { // goes from 0 degrees to 180 degrees
        // in steps of 1 degree
        myservo.write(pos);              // tell servo to go to position in variable 'pos'
        delay(250);                       // waits 15ms for the servo to reach the position
      }
      for (int pos = 165; pos >= 0; pos -= 15) { // goes from 180 degrees to 0 degrees
      myservo.write(pos);              // tell servo to go to position in variable 'pos'
      delay(250);                       // waits 15ms for the servo to reach the position
      }
      }
      //check = digitalRead(PIN9);
      Serial.println("INTERRUPT ENABLE");
      Serial.print("PORTS 7: ");
      Serial.print(basys_in[7]);
      Serial.print("\n");
      //Serial.print("CHECK: ");
      //Serial.print(check);
      //Serial.print("\n");
    }
    else
    {
        sweep(basys_in, pos);
      //delay(750);
      Serial.print("PORTS 0:");
      Serial.println(basys_in[0]);
      Serial.print("PORTS 1:");
      Serial.println(basys_in[1]);
      Serial.print("PORTS 2:");
      Serial.println(basys_in[2]);
      Serial.print("PORTS 3:");
      Serial.println(basys_in[3]);
      Serial.print("PORTS 4:");
      Serial.println(basys_in[4]);
      Serial.print("PORTS 5:");
      Serial.println(basys_in[5]);
      Serial.print("PORTS 6:");
      Serial.println(basys_in[6]);
      Serial.print("PORTS 7:");
      Serial.println(basys_in[7]);
      Serial.print("POS:");
      Serial.println(pos);
      delay(1000);

    }





}
