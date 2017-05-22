#include <Servo.h>
#define USE_SOFTWARE_SERIAL
Servo myservo;

String code = "12345";                     //initial permanent code
String input = "";
String data = "";
int lastData = 0;                         //stop door being unlocked twice in a row before being locked or vice versa
String oneTimeCode = "";

byte h = 0, v = 0;                        //variables used in for loops
const unsigned long period = 50;          //little period used to prevent error
unsigned long kdelay = 0;                 // variable used in non-blocking delay
const byte rows = 4;                      //number of rows of keypad
const byte columns = 4;                   //number of columnss of keypad
const byte Output[rows] = {2, 3, 4, 5};   //array of pins used as output for rows of keypad
const byte Input[columns] = {6, 7, 8, 9}; //array of pins used as input for columnss of keypad

byte keypad() // function used to detect which button is used
{
  static bool no_press_flag = 0; //static flag used to ensure no button is pressed
  for (byte x = 0; x < columns; x++) // for loop used to read all inputs of keypad to ensure no button is pressed
  {
    if (digitalRead(Input[x]) == HIGH); //read every input if high continue else break;
    else
      break;
    if (x == (columns - 1)) //if no button is pressed
    {
      no_press_flag = 1;
      h = 0;
      v = 0;
    }
  }
  if (no_press_flag == 1) //if no button is pressed
  {
    for (byte r = 0; r < rows; r++) //for loop used to make all output as low
      digitalWrite(Output[r], LOW);
    for (h = 0; h < columns; h++) // for loop to check if one of inputs is low
    {
      if (digitalRead(Input[h]) == HIGH) //if specific input is remain high (no press on it) continue
        continue;
      else    //if one of inputs is low
      {
        for (v = 0; v < rows; v++) //for loop used to specify the number of row
        {
          digitalWrite(Output[v], HIGH);  //make specified output as HIGH
          if (digitalRead(Input[h]) == HIGH) //if the input selected from first for loop is change to high
          {
            no_press_flag = 0;              //reset the no press flag;
            for (byte w = 0; w < rows; w++) // make all outputs as low
              digitalWrite(Output[w], LOW);
            return v * 4 + h; //return number of button
          }
        }
      }
    }
  }
  return 50;
}

void lock()
{
  lastData = 0;
  myservo.attach(10);
  myservo.write(360);
  delay(700);
  myservo.write(180);
  myservo.detach();
  Serial.flush();
}

void unlock()
{
  lastData = 1;
  myservo.attach(10);
  myservo.write(0);
  delay(700);
  myservo.write(180);
  myservo.detach();
  Serial.flush();
}

void setup()
{

  Serial.begin(9600);         //Sets the data rate in bits per second (baud) for serial data transmission
  for (byte i = 0; i < rows; i++) //for loop used to make pin mode of outputs as output
  {
    pinMode(Output[i], OUTPUT);
  }
  for (byte s = 0; s < columns; s++) //for loop used to makk pin mode of inputs as inputpullup
  {
    pinMode(Input[s], INPUT_PULLUP);
  }
  pinMode(13, OUTPUT);        //Sets digital pin 13 as output pin
  pinMode(10, OUTPUT);
  Serial.flush();
}

void loop()
{
  if (Serial.available() > 0) //if input sent from app
  {        
        data = Serial.readString();

        if (data == "11" && lastData != 1) //unlocks door from app
        {
            unlock();
            Serial.println("Homeowner Unlocked");
        }
        else if (data == "00" && lastData != 0) //locks door from app
        {
            lock();
            Serial.println("Homeowner Locked");
        }
        else if (data.length() == 8) //generated one time access code from app
        {
              oneTimeCode = data;
              Serial.print("Temporary Sent");
              Serial.flush();
        }
        else if (data.length() == 5) //changes permanent code from app to be used on keypad
        {
              code = data;
              Serial.println("Code Changed");
              Serial.flush();
        }
   }
   
   if (millis() - kdelay > period) //used to make non-blocking delay
   {
       kdelay = millis(); //capture time from millis function
       switch (keypad())  //switch used to specify which button
       {
         //-------------------------------------------- 
        case 0:
          input += "1";
          break;
        //-------------------------------------------- 
        case 1:
           input += "2";
          break;
        //-------------------------------------------- 
        case 2:
           input += "3";
          break;
        //-------------------------------------------- 
        case 3: //A
          break;
        //-------------------------------------------- 
        case 4:
          input += "4";
          break;
        //-------------------------------------------- 
        case 5:
          input += "5";
          break;
        //-------------------------------------------- 
        case 6:
          input += "6";
          break;
        //-------------------------------------------- 
        case 7: //B
          break;
        //-------------------------------------------- 
        case 8:
          input += "7";
          break;
        //-------------------------------------------- 
        case 9:
          input += "8";
          break;
        //-------------------------------------------- 
        case 10:
          input += "9";
          break;
        //-------------------------------------------- 
        case 11: //C (clears input)
          input = "";
          Serial.flush();
          break;
        //-------------------------------------------- 
        case 12: //*
          if (input == code) //if correct permanent code entered
          {
            if(lastData !=1) //unlocks door
            {
                unlock();
                Serial.println("Keypad Unlocked");
            }
          }
          else
            Serial.println("Keypad Incorrect");
          input = "";
          Serial.flush();
          break;
        //-------------------------------------------- 
        case 13:
          input += "0";
          break;
        //-------------------------------------------- 
        case 14: //#
          if (input == oneTimeCode && input != "") //if correct one time access code entered
          {
            oneTimeCode = "";
            if(lastData !=1) //unlocks door
            {
                unlock();
                Serial.println("Temporary Unlocked");
            }
          }
          else
            Serial.println("Temporary Incorrect");
          input = "";
          Serial.flush();
          break;
        //-------------------------------------------- 
        case 15: //D (enter)
          if(lastData != 0) //locks door
          {
             lock();
             Serial.println("Keypad Locked");
          }
          input = "";
          Serial.flush();
          break;
        //-------------------------------------------- 
        default: ;
      } 
    }
}

