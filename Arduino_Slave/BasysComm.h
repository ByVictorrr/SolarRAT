// ------------------------------------------------------------
// Author: Julio Tena
// Descrition: Library to establish communication between Basys3
//             board and Arduino. Basys3 sends 8-bits to Arduino
//             to represent data for 9g Servo motor control.
//
//
// ------------------------------------------------------




/*
    Reads inputs from 8 different pins (pins 2 - 9)
*/
void readPorts(int basys_inputs[])
{
  // 4-bits to determine location of Servo
  // Range of location: 0 - 12 (decimal)
  basys_inputs[0] = digitalRead(2);
  basys_inputs[1] = digitalRead(3);
  basys_inputs[2] = digitalRead(4);
  basys_inputs[3] = digitalRead(5);

  // 4-bits to determine voltage readings from xadc
  // Range of voltage levels: 0 - 16 (decimal)
  basys_inputs[4] = digitalRead(6);
  basys_inputs[5] = digitalRead(7);
  basys_inputs[6] = digitalRead(8);
  basys_inputs[7] = digitalRead(9);
}

bool interrupt(int basys_input[])
{
    if (basys_input[7] == 1 && basys_input[4] == 0 && basys_input[5] == 0 && basys_input[6] == 0)
      return true;
    return false;
}


void manualMode(int basys_input[],int &pos_in)
{
  if (basys_input[0] == 0 && basys_input[1] == 0)
    pos_in = 45;
  else if(basys_input[0] == 1 && basys_input[1] == 0)
    pos_in = 90;
  else if(basys_input[0] == 0 && basys_input[1] == 1)
    pos_in = 135;
  else if(basys_input[0] == 1 && basys_input[1] == 1)
  {
    pos_in = 15;
  }
}

void sweep(int basys_input[], int &pos_in)
{


  //location 0:
  if (basys_input[0] == 0 && basys_input[1] == 0 && basys_input[2] == 0 && basys_input[3] == 0)
    pos_in = pos_in;

  //location 1:
  if (basys_input[0] == 1 && basys_input[1] == 0 && basys_input[2] == 0 && basys_input[3] == 0)
    pos_in = 15;

  //location 2:
  if (basys_input[0] == 0 && basys_input[1] == 1 && basys_input[2] == 0 && basys_input[3] == 0)
    pos_in = 30;

  //location 3:
  if (basys_input[0] == 1 && basys_input[1] == 1 && basys_input[2] == 0 && basys_input[3] == 0)
    pos_in = 45;

  //location 4:
  if (basys_input[0] == 0 && basys_input[1] == 0 && basys_input[2] == 1 && basys_input[3] == 0)
    pos_in = 60;

  //location 5:
  if (basys_input[0] == 1 && basys_input[1] == 0 && basys_input[2] == 1 && basys_input[3] == 0)
    pos_in = 75;


  //location 6:
  if (basys_input[0] == 0 && basys_input[1] == 1 && basys_input[2] == 1 && basys_input[3] == 0)
    pos_in = 90;

  //location 7:
  if (basys_input[0] == 1 && basys_input[1] == 1 && basys_input[2] == 1 && basys_input[3] == 0)
    pos_in = 105;

  //location 8:
  if (basys_input[0] == 0 && basys_input[1] == 0 && basys_input[2] == 0 && basys_input[3] == 1)
    pos_in = 120;

  //location 9:
  if (basys_input[0] == 1 && basys_input[1] == 0 && basys_input[2] == 0 && basys_input[3] == 1)
    pos_in = 135;

  //location 10:
  if (basys_input[0] == 0 && basys_input[1] == 1 && basys_input[2] == 0 && basys_input[3] == 1)
    pos_in = 150;



}
