#include <EEPROM.h>

#define Xdir 12
#define Ydir 5
#define Zdir 24

#define Xenable 7
#define Yenable 15
#define Zenable 34

#define Xbump A2
#define Ybump A1 
#define Zbump A0

/***************************************************************************************
This is what matters when you change the Step size : change the FoV accordingly
Rest of everything is calculated in terms of steps only
So the GUI needs to take care of step size to um conversion
***************************************************************************************/
// FoV size. This is in steps. Calcuated as FoV (steps) = FoV (um) / stepSize
// The step size as on 27 June is 198 nm / step
//long xFoV = 1843, yFoV = 2323;


// updating for getting CDS data
long xFoV = 2000, yFoV = 1600;
bool XmotorEnabled = false, YmotorEnabled = false, ZmotorEnabled = false;

long XMaxStep = 300000L, YMaxStep = 150000L, ZMaxStep = 200000L;
long limitTOZfocus = 50000L, limitToXZero = 100000, limitToYZero = -20000; //limitToXZero=220000,limitToYZero=8000; Previous Values

long XcurrStep = 0L, YcurrStep = 0L,  ZcurrStep = 0L;
long Ax = 0L, Ay = 0L, Az = 0L, Bx = 0L, By = 0L, Bz = 0L, Cx = 0L, Cy = 0L, Cz = 0L;
long nextZstep = 0, XdeltaZperFoV = 0, YdeltaZperFoV = 0;

void gotoXYZSetStep(long XsetStep = XcurrStep, long YsetStep = YcurrStep, long ZsetStep = ZcurrStep);

void setup() {
  Serial.begin(57600);
  // pulse : X,Y,Z  :: TX 1,2,3
  //  Serial1.begin(38400); Serial2.begin(38400); Serial3.begin(38400);
  pinMode(Zdir, OUTPUT); pinMode(Ydir, OUTPUT); pinMode(Xdir, OUTPUT);
  //******************** The bump switchs****************************//
  pinMode(Xbump, INPUT); pinMode(Ybump, INPUT); pinMode(Zbump, INPUT);
  //******************* X,Y,Z -Axis M0,M1,M2 Pins******************//
  pinMode(8, OUTPUT); pinMode(9, OUTPUT); pinMode(10, OUTPUT); //X-Axis Step Size
  pinMode(14, OUTPUT); pinMode(2, OUTPUT); pinMode(3, OUTPUT); //Y-Axis Step Size
  pinMode(32, OUTPUT); pinMode(30, OUTPUT); pinMode(28, OUTPUT); //Z-axis Step Size
  //****************** X,Y-0.2um and Z-0.1um ********************//
  digitalWrite(8, LOW); digitalWrite(9, LOW); digitalWrite(10, HIGH);
  digitalWrite(14, LOW); digitalWrite(2, LOW); digitalWrite(3, HIGH);
  digitalWrite(32, HIGH); digitalWrite(30, HIGH); digitalWrite(28, HIGH);
  digitalWrite(Xenable, HIGH); digitalWrite(Yenable, HIGH); digitalWrite(Zenable, HIGH);

  //*************************************************************//
}

void loop() {

  int choice = Serial.read();

  switch (choice) {
    case ('T') :        digitalWrite(Zdir, LOW);   delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep, ZcurrStep - 1);             // T == Z up by 5 counts
      break;
      
    case ('G') :        digitalWrite(Zdir, HIGH);  delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep, ZcurrStep + 1);              // G == Z down
      break;
      
    case ('t') :        digitalWrite(Zdir, LOW);   delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep, ZcurrStep - 100);             // T == Z up by 5 counts
      break;
      
    case ('g') :        digitalWrite(Zdir, HIGH);  delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep, ZcurrStep + 100);              // G == Z down
      break;
      
    case ('C') :        digitalWrite(Zdir, LOW);   delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep, ZcurrStep - 5000);             // T == Z up by 5 counts
      break;
      
    case ('V') :        digitalWrite(Zdir, HIGH);  delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep, ZcurrStep + 5000);              // G == Z down
      break;
      
    case ('c') :        digitalWrite(Zdir, LOW);   delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep, ZcurrStep - 1000);             // T == Z up by 5 counts
      break;
      
    case ('v') :        digitalWrite(Zdir, HIGH);  delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep, ZcurrStep + 1000);              // G == Z down
      break;
      
    case ('A') :        digitalWrite(Xdir, HIGH);   delayMicroseconds(10);  gotoXYZSetStep(XcurrStep - xFoV, YcurrStep, ZcurrStep);
      break;
      
    case ('D') :        digitalWrite(Xdir, LOW);  delayMicroseconds(10);  gotoXYZSetStep(XcurrStep + xFoV, YcurrStep, ZcurrStep);
      break;
      
    case ('W') :        digitalWrite(Ydir, LOW);  delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep + yFoV, ZcurrStep);  
      break;
      
    case ('S') :        digitalWrite(Ydir, HIGH);    delayMicroseconds(10);  gotoXYZSetStep(XcurrStep, YcurrStep - yFoV, ZcurrStep);  
      break;
      
    case ('J') :        XcurrStep = 0;                                                                                    // J == X reset
      break;
    case ('K') :        YcurrStep = 0;                                                                       // K == Y reset
      break;
    case ('L') :        ZcurrStep = 0;       //                                                                        // L == Z reset
      break;
    case ('B') :        gotoXYZSetStep(getStep(), YcurrStep, ZcurrStep);
      break;
    case ('N') :        gotoXYZSetStep(XcurrStep, getStep(), ZcurrStep);
      break;
    case ('M') :        gotoXYZSetStep(XcurrStep, YcurrStep, getStep());
      break;
    case (';') :        gotoXYZSetStep(getStep(), getStep(), ZcurrStep);
      break;
    case ('[') :        gotoXYZSetStep(getStep(), YcurrStep, getStep());
      break;
    case (']') :        gotoXYZSetStep(XcurrStep, getStep(), getStep());
      break;
    case (',') :        gotoXYZSetStep(getStep(), getStep(), getStep());
      break;
      break;
    case ('I') :         Serial3.flush(); Serial.print('X'); Serial.print("#"); Serial.print(XcurrStep); Serial.print("#");
      break;
    case ('O') :         Serial2.flush(); Serial.print('Y'); Serial.print("#"); Serial.print(YcurrStep); Serial.print("#");
      break;
    case ('P') :         Serial1.flush(); Serial.print('Z'); Serial.print("#"); Serial.print(ZcurrStep); Serial.print("#");
      break;

      // Set A,B,C - Codes are E,R,Y respectively
    case ('E')  :        Ax = XcurrStep; Ay = YcurrStep; Az = ZcurrStep;
      break;
    case ('R')  :        Bx = XcurrStep; By = YcurrStep; Bz = ZcurrStep;
      break;
    case ('Y')  :        Cx = XcurrStep; Cy = YcurrStep; Cz = ZcurrStep;
      break;
    case ('U')  :
      break;
    case ('X')  :
      break;
//    case ('V')  :        debug();
//      break;
    case ('Q') :         gohome();
      break;

    case ('1') :
      break;
    case ('2') :
      break;
    case ('0') :         EEPROM.write(0, 0);
      break;
    case ('7') :         Serial.print('7');  Serial.print("#");
      break;
    case ('3') :         digitalWrite(Zdir, HIGH);   delayMicroseconds(10); Serial3.print("X"); ZcurrStep = ZcurrStep + 1;
      break;
    case ('5') :         digitalWrite(Zdir, LOW);   delayMicroseconds(10); Serial3.print("X"); ZcurrStep = ZcurrStep - 1;

    default : break;
  }
}



void gotoXYZSetStep(long XsetStep, long YsetStep, long ZsetStep)
{

  long Xstepstodo = 0, Ystepstodo = 0, Zstepstodo = 0;

  if (XsetStep != XcurrStep) {
   // if (XsetStep > XMaxStep)
    //  XsetStep = XMaxStep;
    
    if (XsetStep > XcurrStep && (isXbumpHit() != 1))
    {
      Xstepstodo = abs(XsetStep - XcurrStep);
      digitalWrite(Xdir, LOW);//change
      XcurrStep = XsetStep;
//      doXYZSteps(Xstepstodo, Ystepstodo, Zstepstodo);
    }
    else if (XsetStep < XcurrStep  && (isXbumpHit() != 2)) 
    {
      Xstepstodo = abs(XsetStep - XcurrStep);
      digitalWrite(Xdir, HIGH);//change
      XcurrStep = XsetStep;
    }
    
  }
  if (YsetStep != YcurrStep) 
  {
//    if (YsetStep > YMaxStep)
//      YsetStep = YMaxStep;
    
    if (YsetStep > YcurrStep && (isYbumpHit() != 1))
    {
      Ystepstodo = abs(YsetStep - YcurrStep);
      digitalWrite(Ydir, LOW);//change
      YcurrStep = YsetStep;
    }
    else if (YsetStep < YcurrStep  && (isYbumpHit() != 2)) 
    {
      Ystepstodo = abs(YsetStep - YcurrStep);
      digitalWrite(Ydir, HIGH);//change
      YcurrStep = YsetStep;
    }
  }

  if (ZsetStep != ZcurrStep) {
//    if (ZsetStep > ZMaxStep)
//      ZsetStep = ZMaxStep;
  
    if (ZsetStep > ZcurrStep && (isZbumpHit() != 2))
    {
      Zstepstodo = abs(ZsetStep - ZcurrStep);
      digitalWrite(Zdir, LOW);//change
      ZcurrStep = ZsetStep;
    }
    else if (ZsetStep < ZcurrStep  && (isZbumpHit() != 1)) 
    {
      Zstepstodo = abs(ZsetStep - ZcurrStep);
      digitalWrite(Zdir, HIGH);//change
      ZcurrStep = ZsetStep;
    }
  }
  doXYZSteps(Xstepstodo, Ystepstodo, Zstepstodo);
}



void doXYZSteps(long numX, long numY, long numZ) 
{
//  long XsetStep = numX;  long YsetStep = numY;  long ZsetStep = numZ;

  while (numX > 0 || numY > 0 || numZ > 0) 
  {
    if (XmotorEnabled) 
    {
      if ( numX <= 0 )
        {
//          Serial.print("hit numX"); Serial.print("#");          
          digitalWrite(Xenable, HIGH);//
          XmotorEnabled = false;
        }
      
      else if ( digitalRead (Xdir) == LOW && isXbumpHit() == 1)
        {
//          Serial.print("hit low"); Serial.print("#");
          XcurrStep = XcurrStep - numX;
          numX = 0;
        }
      else if (digitalRead (Xdir) == HIGH && isXbumpHit() == 2)
        {
//          Serial.print("hit high"); Serial.print("#");
          XcurrStep = XcurrStep + numX;
          numX = 0;
        }     
    } 
    else if (numX > 0) 
    {
      digitalWrite(Xenable, LOW);
      XmotorEnabled = true;    
    }
    

    if (YmotorEnabled) 
    {
      if ( numY <= 0 )
        {
          digitalWrite(Yenable, HIGH);
          YmotorEnabled = false;
        }
      
      else if (digitalRead (Ydir) == LOW && isYbumpHit() == 1)
        {
          YcurrStep = YcurrStep - numY;
          numY = 0;
        }
      else if (digitalRead (Ydir) == HIGH && isYbumpHit() == 2)
        {
          YcurrStep = YcurrStep + numY;
          numY = 0;
        }     
    } 
    else 
    {
      if (numY > 0) 
      {
        digitalWrite(Yenable, LOW);
        YmotorEnabled = true;    
      }
    }

    if (ZmotorEnabled) 
    {
      if ( numZ <= 0 )
        {
          digitalWrite(Zenable, HIGH);
          ZmotorEnabled = false;
        }
      else if (digitalRead (Zdir) == LOW && isZbumpHit() == 1)
        {
          ZcurrStep = ZcurrStep + numZ;
          numZ = 0;
        }
      else if (digitalRead (Zdir) == HIGH && isZbumpHit() == 2)
        {
          ZcurrStep = ZcurrStep - numZ;
          numZ = 0;
        }     
    } 
    else 
    {
      if (numZ > 0) 
      {
        digitalWrite(Zenable, LOW);
        ZmotorEnabled = true;    
      }
    }


    // PWM for motor driver
    digitalWrite(11, LOW); digitalWrite(4, LOW); digitalWrite(26, LOW);
    delayMicroseconds(1);
    digitalWrite(11, HIGH); digitalWrite(4, HIGH); digitalWrite(26, HIGH);
    delayMicroseconds(1);
    //    digitalWrite(11, LOW); digitalWrite(4, LOW); digitalWrite(26, LOW);

    if (XmotorEnabled)  
    {
      numX--;  // Delay added for motor motion syncing with signal
      if (numX <= 5) delay(1);
    }
    if (YmotorEnabled)  
    {
      numY--;  // and ramping out at the end
      if (numY <= 5) delay(1);
    }
    if (ZmotorEnabled)  
    {
      numZ--;
      if (numZ <= 5) delay(1);
    }

  }
}

int isXbumpHit()
{
  int xval = analogRead(Xbump);

  if (xval <= 200)    {
    return 1 ;
  }
  if ((xval > 200) && ((xval <= 800)))    {
    return 2;
  }
  if (xval > 800)    {
    return 0;
  }

}

int isYbumpHit()
{
  int yval = analogRead(Ybump);

  if (yval <= 200)    {
    return 1 ;
  }
  if ((yval > 200) && ((yval <= 800)))    {
    return 2;
  }
  if (yval > 800)    {
    return 0;
  }

}

int isZbumpHit()
{
  int zval = analogRead(Zbump);

  if (zval <= 200)    {
    return 1 ;
  }
  if ((zval > 200) && ((zval <= 800)))    {
    return 2;
  }
  if (zval > 800)    {
    return 0;
  }

}

long getStep()
{
  long index = 0, inpStep[7] = {0, 0, 0, 0, 0, 0, 0}, invalidInput = 0;
  long setStep = 0L;


  for (index = 0; index < 8; index++ )
  {
    while ( Serial.available() < 1 );
    inpStep[index] = Serial.read()  - 48;
  }

  // DISCARD first byte : MATLAB sends the terminator character there. We need it since if we turn it off, MATALB won't read the Tx from this arduino
  // ALSO igmore the second byte : that's the sign symbol
  setStep =  (inpStep[2] * 100000) + (inpStep[3] * 10000) + (inpStep[4] * 1000) + (inpStep[5] * 100) + (inpStep[6] * 10) + (inpStep[7] * 1) + 0L ;

  // check what sign was sent. If it was anything other than a '-' then dont worry
  if (inpStep[1] + 48  == '-'  )  {
    setStep = setStep * (-1);
  }
  return setStep;
}


void enableMotors() {
  digitalWrite(Xenable, LOW); digitalWrite(Yenable, LOW); digitalWrite(Zenable, LOW);
}
void disableMotors() {
  digitalWrite(Xenable, HIGH); digitalWrite(Yenable, HIGH); digitalWrite(Zenable, HIGH);
}






//88888888888888888888888888888888888888888888888888888888888888888
// THIS IS THE GOHOME() FUNCTION
//88888888888888888888888888888888888888888888888888888888888888888
void gohome()
{
  gotoXYZSetStep(500000, -200000, -200000);
  if((isXbumpHit()==1) && (isYbumpHit()==1) && (isZbumpHit()==1))
  {
//  delay(1000);
    return;
//    XcurrStep = 0L; YcurrStep = 0L;  ZcurrStep = 0L;
  }
  //  enableMotors();
  //  gotoXSetStep(-100000);
  //  disableMotors();
  //  Serial.print("S#");
}

void debug()
{

  // calc steps in X
  long XstepCount = abs(Bx - Ax) ;    long numXsteps = (XstepCount / xFoV) ;

  // calc steps in Y
  long YstepCount = abs(Cy - By) ;    long numYsteps = (YstepCount / yFoV) ;

  // calc the z changes
  long XZdeltaCount = Bz - Az ;        long XdeltaZperFoV =  XZdeltaCount / (numXsteps - 1);
  long YZdeltaCount = Cz - Bz ;        long YdeltaZperFoV =  YZdeltaCount / (numYsteps - 1);

  // set the initial delta z to the x one. Later, in the loop, it will be changed continously
  long deltaZperFoV = XdeltaZperFoV;

  Serial.print(" Ax: "); Serial.print(Ax); Serial.print(" Ay: "); Serial.print(Ay); Serial.print(" Az: "); Serial.print(Az);
  Serial.print(" Bx: "); Serial.print(Bx); Serial.print(" By: "); Serial.print(By); Serial.print(" Bz: "); Serial.print(Bz);
  Serial.print(" Cx: "); Serial.print(Cx); Serial.print(" Cy: "); Serial.print(Cy); Serial.print(" Cz: "); Serial.print(Cz);
  Serial.print(" XdeltaZperFoV: "); Serial.print(XdeltaZperFoV);
  Serial.print(" YdeltaZperFoV: "); Serial.print(YdeltaZperFoV);
  Serial.print("#");

}
