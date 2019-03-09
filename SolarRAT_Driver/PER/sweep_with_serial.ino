//---------------------------------------------------------------------------
// Description: Using arduino as slave for basys board output from switches
// 
//
// Todo:
//      - Finish all cases
//      - Have speed control??
//
//---------------------------------------------------------------------------

#include <Servo.h>

Servo myservo;  // create servo object to control a servo
#define PIN0 0
#define PIN1 1
#define PIN2 2
#define PIN3 3
#define PIN4 4
#define PIN5 5
#define PIN6 6
#define PIN7 7

int pos = 0;    // variable to store the servo position
int basys_in[8]; // initalize all commands to zero


void setup() {
  // initialize for digital input from basys board
  pinMode(PIN0,INPUT);
  pinMode(PIN1,INPUT);
  pinMode(PIN2,INPUT);
  pinMode(PIN3,INPUT);
  pinMode(PIN4,INPUT);
  pinMode(PIN5,INPUT);
  pinMode(PIN6,INPUT);
  pinMode(PIN7,INPUT);  
  Serial.begin(9600);
  myservo.attach(9);  // attaches the servo on pin 9 to the servo object
}

void loop() {

    // Receive all values from basys board and store in array
    // Note: might need time delay to allow time to read all values
    basys_in[0] = digitalRead(PIN0); 
    basys_in[1] = digitalRead(PIN1); // not working for some reason (TX??)
    basys_in[2] = digitalRead(PIN2);
    basys_in[3] = digitalRead(PIN3);
    basys_in[4] = digitalRead(PIN4);
    basys_in[5] = digitalRead(PIN5);
    basys_in[6] = digitalRead(PIN6);
    basys_in[7] = digitalRead(PIN7);

    //delay(1000);
    //Serial.print("PORT 1:");
    //Serial.println(basys_in[0]);
    Serial.print("PORT 3:");
    Serial.println(basys_in[3]);
    if (basys_in[0] == 1)
    {
      pos = 30;
      myservo.write(pos); // might need to update pos to retain value  
    } 
    else if(basys_in[2] == 1)
    {
      pos = 60;
      myservo.write(pos);
    }
    else if(basys_in[3] == 1)
    {
      pos = 90;
      myservo.write(pos);  
    }    
      
    else if(basys_in[4] == 1)
    {
        pos = 120;
        myservo.write(pos);    
    }
      
    else if(basys_in[5] == 1)
        myservo.write(150);
    else if(basys_in[6] == 1)
        myservo.write(180);
    else if(basys_in[7] == 1) // SWEEP
    {
       for (pos = 0; pos <= 180; pos += 15) 
       { // goes from 0 degrees to 180 degrees
        // in steps of 1 degree
          myservo.write(pos);              // tell servo to go to position in variable 'pos'
          delay(25);                       // waits 15ms for the servo to reach the position
       }
       for (pos = 180; pos >= 0; pos -= 15) 
       { // goes from 180 degrees to 0 degrees
          myservo.write(pos);              // tell servo to go to position in variable 'pos'
        delay(25);                       // waits 15ms for the servo to reach the position
       }  
    }
                    
    else      
        myservo.write(0);  // if no switches high, maintain at zero



    
    
}

