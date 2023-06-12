#include <EEPROM.h>

#define Xdir 12
#define Ydir 5
#define Zdir 24
#define Pdir 16

#define Xenable 7
#define Yenable 15
#define Zenable 34
#define Penable 21

#define motorPulseX 11 
#define motorPulseY 4
#define motorPulseZ 26
#define motorPulseP 17
#define X1bump 37
#define X2bump A2

#define Y1bump 35
#define Y2bump A3

#define Z1bump A4
#define Z2bump 33

#define P1bump A0
#define P2bump A1


long XcurrStep=0L; 
long YcurrStep=0L; 
long ZcurrStep=0L; 
long PcurrStep=0L;


//long Ax=0L,Ay=0L,Az=0L,Bx=0L,By=0L,Bz=0L,Cx=0L,Cy=0L,Cz=0L,Dx=0L,Dy=0L,Dz=0L;
long nextXstep = 0;
long nextYstep = 0;
long nextZstep = 0;
long nextPstep = 0;


int needtocheckXmovement=0,needtocheckYmovement=0,needtocheckZmovement=0,needtocheckPmovement=0;
long limitTOXfocus = 20000L;
long limitTOYfocus = 20000L;
long limitTOZfocus = 20000L;
long limitTOPfocus = 20000L;





void setup() {
  Serial.begin(57600);

  pinMode(Zdir, OUTPUT);  pinMode(Ydir, OUTPUT); pinMode(Xdir, OUTPUT); 
  pinMode(Pdir, OUTPUT); 
  pinMode(Penable,OUTPUT);
  pinMode(Xenable,OUTPUT);
  pinMode(Yenable,OUTPUT);
  pinMode(Zenable,OUTPUT);
  
  //******************** The bump switchs****************************//
  //******************** The bump switchs****************************//
  pinMode(X1bump, INPUT); pinMode(X2bump, INPUT);
  pinMode(Y1bump, INPUT); pinMode(Y2bump, INPUT);
  pinMode(P1bump,INPUT); pinMode(P2bump,INPUT);
  pinMode(Z1bump, INPUT);  pinMode(Z2bump, INPUT);
  //******************* X,Y,Z,P -Axis M0,M1,M2 Pins******************//
  pinMode(8, OUTPUT); pinMode(9, OUTPUT); pinMode(10, OUTPUT); //X-Axis Step Size
  pinMode(14, OUTPUT); pinMode(2, OUTPUT); pinMode(3, OUTPUT); //Y-Axis Step Size
  pinMode(32, OUTPUT); pinMode(30, OUTPUT); pinMode(28, OUTPUT);//Z-axis Step Size
  pinMode(20, OUTPUT); pinMode(19, OUTPUT); pinMode(18, OUTPUT);//P-axis Step Size
  //****************** X,Y-0.2um and Z-0.1um ********************//
  digitalWrite(8, HIGH); digitalWrite(9, HIGH); digitalWrite(10, HIGH);
  digitalWrite(14, HIGH); digitalWrite(2, HIGH); digitalWrite(3, HIGH);
  digitalWrite(32, HIGH); digitalWrite(30, HIGH); digitalWrite(28, HIGH);
  digitalWrite(20, HIGH); digitalWrite(19, HIGH); digitalWrite(18, HIGH);
  digitalWrite(Xenable, LOW); digitalWrite(Yenable, LOW); digitalWrite(Zenable, LOW); 
  digitalWrite(Penable, LOW);
}

void loop() { 
     
int choice = Serial.read();
while (!Serial.available()) { /* wait */ }
if (choice){
  Serial.write(choice);
       
     switch(choice){

      case('A') :        digitalWrite(Xdir,LOW);   delayMicroseconds(10);  doXSteps(1);  XcurrStep=XcurrStep-1;                 // T == Z up by 5 counts
                break;

      case('B') :        digitalWrite(Xdir,HIGH);  delayMicroseconds(10);  doXSteps(1);  XcurrStep=XcurrStep+1;                  // G == Z down
                break;

      case('a') :        digitalWrite(Xdir,LOW);   delayMicroseconds(10);  doXSteps(1000);      
                break;         
      
      case('b') :        digitalWrite(Xdir, HIGH );   delayMicroseconds(10);  doXSteps(1000);  
                break; 
      
      case('k') :        digitalWrite(Xdir,LOW);   delayMicroseconds(1);  doXSteps(10000);    
                break;         
       
      case('l') :        digitalWrite(Xdir, HIGH );   delayMicroseconds(1);  doXSteps(10000);  
                break; 
                
      case('n') :        gotoXSetStep(getStep());  
                break;


                
      case('C') :        digitalWrite(Ydir,LOW);   delayMicroseconds(10);  doYSteps(1);  YcurrStep=YcurrStep-1;                 // T == Z up by 5 counts
                break;

      case('D') :        digitalWrite(Ydir,HIGH);  delayMicroseconds(10);  doYSteps(1);  YcurrStep=YcurrStep+1;                  // G == Z down
                break;
      
      case('c') :        digitalWrite(Ydir,LOW);   delayMicroseconds(10);  doYSteps(1000);    
                break;         
       
      case('d') :        digitalWrite(Ydir, HIGH );   delayMicroseconds(10);  doYSteps(1000);  
                break; 

      case('i') :        digitalWrite(Ydir,LOW);   delayMicroseconds(10);  doYSteps(10000);    
                break;         
       
      case('j') :        digitalWrite(Ydir, HIGH );   delayMicroseconds(10);  doYSteps(10000);  
                break; 

                
      case('m') :        gotoYSetStep(getStep());  
                break;

                
   
      case('E') :        digitalWrite(Zdir,LOW);   delayMicroseconds(10);  doZSteps(1);  ZcurrStep=ZcurrStep-1;                 // T == Z up by 5 counts
               break;

      case('F') :        digitalWrite(Zdir,HIGH);  delayMicroseconds(10);  doZSteps(1);  ZcurrStep=ZcurrStep+1;                  // G == Z down
                break;

      case('e') :        digitalWrite(Zdir,LOW);   delayMicroseconds(10);  doZSteps(1000);      
                break;         
       
      case('f') :        digitalWrite(Zdir, HIGH );   delayMicroseconds(10);  doZSteps(1000);  
                break; 
      
      case('r') :        digitalWrite(Zdir,LOW);   delayMicroseconds(10);  doZSteps(10000);    
                break;         
       
      case('s') :        digitalWrite(Zdir, HIGH );   delayMicroseconds(10);  doZSteps(10000);  
                break; 
                
      case('o') :        gotoZSetStep(getStep());  
                break;


      


    //dispensing = 0.005 X 71 microcsteps  
      case('G') :        digitalWrite(Pdir,LOW);   delayMicroseconds(10);  doPSteps(1);  PcurrStep=PcurrStep-1;                 // T == Z up by 5 counts
                break;

      case('H') :        digitalWrite(Pdir,HIGH);  delayMicroseconds(10);  doPSteps(1);  PcurrStep=PcurrStep+1;                  // G == Z down
               break;
      
      case('g') :       digitalWrite(Pdir, LOW );   delayMicroseconds(10);  doPSteps(3000);  
                break;

      case('h') :       digitalWrite(Pdir, HIGH );   delayMicroseconds(10);  doPSteps(3000);  
                break;

      case('x') :        gotoPSetStep(getStep());  
                break;  
                              
      
      case('z') : gotohome();
                break;

      case('Z') : loadtip();
                break;

      case('y') : gotodevice();
                break;
      case('p'): extract();
                break;
      case('q'): dispense();
                break;          

      case('Q') : goZhome();
                break;
          case ('1') :
      break;
     
      case ('2') :
                 break;
      
      case ('0') :         EEPROM.write(0, 0);
                 break;
   
      case ('7') :         Serial.print('7');  Serial.print("#");
                 break;
      
//      case ('3') :         digitalWrite(Zdir, HIGH);   delayMicroseconds(10); Serial3.print("X"); ZcurrStep = ZcurrStep + 1;
//                 break;
      
//      case ('5') :         digitalWrite(Zdir, LOW);   delayMicroseconds(10); Serial3.print("X"); ZcurrStep = ZcurrStep - 1;

//                 default : break;
                

              }
}
}
//////////X BUMP HIT//////////
int x1val=0;
int isX1bumpHit()
{
  int x1val = digitalRead(X1bump);
  if (x1val == LOW)    {
    return 1 ; 
  }
  return 0;
}


int x2val=0;
int isX2bumpHit()
{
  int x2val = digitalRead(X2bump);
  if (x2val == LOW)    {
    return 1 ; 
  }
  return 0;
}

////////////////Y BUMP HITS/////////////
int y1val=0;
int isY1bumpHit()
{
  int y1val = digitalRead(Y1bump);
  if (y1val == LOW)    {
    return 1 ; 
  }
  return 0;
}



int y2val=0;
int isY2bumpHit()
{
  int y2val = digitalRead(Y2bump);
  if (y2val == LOW)    {
    return 1 ; 
  }
  return 0;
}


/////////////////Z BUMP HIT///////////////////
int z1val=0;
int isZ1bumpHit()
{
  int z1val = digitalRead(Z1bump);
  if (z1val == LOW)  {
    
    Serial.print("Hit");
    return 1 ; 
  }
  return 0;
}

int z2val=0;
int isZ2bumpHit()
{
  int z2val = digitalRead(Z2bump);
  if (z2val == LOW)  {
    
    Serial.print("Hit");
    return 1 ; 
  }
  return 0;
}

//////////// P BUMP HIT////////////
int p1val=0;
int isP1bumpHit()
{
  int p1val = digitalRead(P1bump);
  if (p1val == LOW)  {
    return 1 ; 
  }
  return 0;
}


void doXSteps(long num) { 
 if (isX1bumpHit() != 1 && isX2bumpHit() != 1)
 {
  while (num > 0 )  {
      digitalWrite( motorPulseX ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseX ,HIGH);   delayMicroseconds(15);
      digitalWrite( motorPulseX ,LOW);    delayMicroseconds(15); 
       num--;
  }
 }

  if (isX1bumpHit() == 1)
     {
  while (num > 0 )  {
      digitalWrite(Xdir,LOW);
      digitalWrite( motorPulseX , HIGH);    delayMicroseconds(15); 
      digitalWrite( motorPulseX ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseX ,HIGH);    delayMicroseconds(15); 

       num--;
  }
     }
 
  if (isX2bumpHit() == 1)
     {
  while (num > 0 )  {
      digitalWrite(Xdir,HIGH);
      digitalWrite( motorPulseX , HIGH);    delayMicroseconds(15); 
      digitalWrite( motorPulseX ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseX ,HIGH);    delayMicroseconds(15); 

       num--;
  }
     }
}


void doYSteps(long num) { 
  if (isY1bumpHit() != 1 && isY2bumpHit() != 1)
{
  while (num > 0 )  {
      digitalWrite( motorPulseY ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseY ,HIGH);   delayMicroseconds(15);
      digitalWrite( motorPulseY ,LOW);    delayMicroseconds(15); 
       num--;
        
   
  } 
}
  if (isY1bumpHit() == 1)
     {   
  while (num > 0 )  {
      digitalWrite(Ydir,HIGH);
      digitalWrite( motorPulseY , HIGH);    delayMicroseconds(15); 
      digitalWrite( motorPulseY ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseY ,HIGH);    delayMicroseconds(15); 

       num--;
  }
     }
 
  if (isY2bumpHit() == 1)
     {
  while (num > 0 )  {
      digitalWrite(Ydir,LOW);
      digitalWrite( motorPulseY , HIGH);    delayMicroseconds(15); 
      digitalWrite( motorPulseY ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseY ,HIGH);    delayMicroseconds(15); 

       num--;
  }
     }
}

void doZSteps(long num) { 
  if (isZ1bumpHit() != 1 && isZ2bumpHit() != 1)
{
  while (num > 0 )  {
      digitalWrite( motorPulseZ ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseZ ,HIGH);   delayMicroseconds(15);
      digitalWrite( motorPulseZ,LOW);    delayMicroseconds(15); 
       num--; 
  } 
}
  if (isZ1bumpHit() ==  0)
     {
  while (num > 0 )  {
      digitalWrite(Zdir,HIGH);
      digitalWrite( motorPulseZ , HIGH);    delayMicroseconds(15); 
      digitalWrite( motorPulseZ ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseZ ,HIGH);    delayMicroseconds(15); 

       num--;
  }
     }
 
  if (isZ2bumpHit() == 0)
     {
  while (num > 0 )  {
      digitalWrite(Zdir,LOW);
      digitalWrite( motorPulseZ , HIGH);    delayMicroseconds(15); 
      digitalWrite( motorPulseZ ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseZ ,HIGH);    delayMicroseconds(15); 

       num--;
  }
     }
}

void doPSteps(long num) { 
   if (isP1bumpHit() != 1)
  while (num > 0 )  { 
      digitalWrite( motorPulseP ,HIGH);    delayMicroseconds(15); 
      digitalWrite( motorPulseP ,LOW);   delayMicroseconds(15);
      digitalWrite( motorPulseP,HIGH);    delayMicroseconds(15); 
       num--; 
  }  
   
  if (isP1bumpHit() == 1)
     {
  while (num > 0 )  {
      digitalWrite(Pdir,LOW);
      digitalWrite( motorPulseP , HIGH);    delayMicroseconds(15); 
      digitalWrite( motorPulseP ,LOW);    delayMicroseconds(15); 
      digitalWrite( motorPulseP ,HIGH);    delayMicroseconds(15); 

       num--;
  }
     }
}

void loadtip(){
  gotohome();
  digitalWrite(Xdir, LOW);   delayMicroseconds(10);  doXSteps(191000);
  digitalWrite(Ydir, HIGH);   delayMicroseconds(10);  doYSteps(12000);
  digitalWrite(Zdir,HIGH);   delayMicroseconds(10);  doZSteps(210000); 
  delay(2000);
  while (isZ2bumpHit() != 1){
  digitalWrite(Zdir,LOW);   delayMicroseconds(10);  doZSteps(1000); 
  }
  digitalWrite(Xdir, HIGH);   delayMicroseconds(10);  doXSteps(40000);
  gotohome();
  extract();
  extract();
  }

void goZhome(){
  while (isZ2bumpHit() != 1){
  digitalWrite(Zdir,LOW);   delayMicroseconds(10);  doZSteps(1000); 
  }  
  digitalWrite(Zdir, HIGH );   delayMicroseconds(10);  doZSteps(200000);
  digitalWrite(Zdir, HIGH );   delayMicroseconds(10);  doZSteps(16000);
}
void gotohome(){
  
  while (isZ2bumpHit() != 1){
  digitalWrite(Zdir,LOW);   delayMicroseconds(10);  doZSteps(1000); 
  }
  while (isX1bumpHit() != 1){
   digitalWrite(8, LOW); digitalWrite(9, LOW); digitalWrite(10, HIGH);
   digitalWrite(Xdir, HIGH );   delayMicroseconds(10);  doXSteps(1000);
  }
  
  while (isY1bumpHit() != 1){
   digitalWrite(14, LOW); digitalWrite(2, LOW); digitalWrite(3, HIGH);
   digitalWrite(Ydir,LOW);   delayMicroseconds(10);  doYSteps(1000);    
  }
   digitalWrite(Ydir,HIGH);   delayMicroseconds(10);  doYSteps(10000);
 
}

void gotodevice(){
  gotohome();
  digitalWrite(8, LOW); digitalWrite(9, LOW); digitalWrite(10, HIGH);
  digitalWrite(Xdir, LOW );   delayMicroseconds(10);  doXSteps(150000);

  digitalWrite(14, LOW); digitalWrite(2, LOW); digitalWrite(3, HIGH);
  digitalWrite(Ydir,HIGH);   delayMicroseconds(10);  doYSteps(100000);

  digitalWrite(Zdir, HIGH );   delayMicroseconds(10);  doZSteps(200000);
   
  digitalWrite(8, HIGH); digitalWrite(9, HIGH); digitalWrite(10, HIGH);
  digitalWrite(14, HIGH); digitalWrite(2, HIGH); digitalWrite(3, HIGH);   
}

void extract(){
   digitalWrite(Pdir, LOW );   delayMicroseconds(10);  doPSteps(12000);
   while (isZ1bumpHit() != 1){
   digitalWrite(Zdir, HIGH );   delayMicroseconds(10);  doZSteps(1000);
   }
   digitalWrite(Pdir, HIGH );   delayMicroseconds(10);  doPSteps(12000);
   while (isZ2bumpHit() != 1){
   digitalWrite(Zdir, LOW );   delayMicroseconds(10);  doZSteps(1000); 
   }    
}

void dispense(){
  
  digitalWrite(Pdir, LOW );   delayMicroseconds(10);  doPSteps(51000);
  delay(1000);
  while (isZ2bumpHit() != 1){
   digitalWrite(Zdir, LOW );   delayMicroseconds(10);  doZSteps(1000); 
   }  
  digitalWrite(Pdir, HIGH );   delayMicroseconds(10);  doPSteps(51000);
  }


long getStep()
{
  long index = 0, inpStep[7] = {0, 0, 0, 0, 0, 0, 0}, invalidInput = 0;
  long setStep = 0L;


  for (index = 0; index < 8; index++ )
  {
    while ( Serial.available() < 1 );
    inpStep[index] = Serial.read() - 48;
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


void gotoXSetStep(long XsetStep)
{
  //if(XsetStep > XMaxStep)  {XsetStep = XMaxStep;}
  long stepstodo = abs(XsetStep - XcurrStep)/5 ;
  Serial.println(XcurrStep);
  Serial.println(stepstodo);
  
 if (XsetStep > XcurrStep)
  { needtocheckXmovement=0 ;
   Serial.println(XcurrStep);
   Serial.println("hi");
    digitalWrite(Xdir,HIGH);   delayMicroseconds(10);  XcurrStep=XsetStep;  doXSteps( stepstodo );  }

  if (XsetStep < XcurrStep)
  { 
    needtocheckXmovement=1 ;
    Serial.println(XcurrStep);
    Serial.println("hello");
    digitalWrite(Xdir,LOW);   delayMicroseconds(10);  XcurrStep=XsetStep; doXSteps( stepstodo );
    Serial.println(XcurrStep); 
    }
}


void gotoYSetStep(long YsetStep)
{
  //if(YsetStep > YMaxStep)  {YsetStep = YMaxStep;}
  long stepstodo = abs(YsetStep - YcurrStep)/5 ;
  Serial.println(YcurrStep);
  Serial.println(stepstodo);
  
 if (YsetStep > YcurrStep)
  { needtocheckYmovement=0 ;
   Serial.println(YcurrStep);
   Serial.println("hi");
    digitalWrite(Ydir,HIGH);   delayMicroseconds(10);  YcurrStep=YsetStep;  doYSteps( stepstodo );  }

  if (YsetStep < YcurrStep)
  { 
    needtocheckYmovement=1 ;
    Serial.println(YcurrStep);
    Serial.println("hello");
    digitalWrite(Ydir,LOW);   delayMicroseconds(10);  YcurrStep=YsetStep; doYSteps( stepstodo );
    Serial.println(YcurrStep); 
    }
}


void gotoZSetStep(long ZsetStep)
{
  //if(ZsetStep > ZMaxStep)  {ZsetStep = ZMaxStep;}
  long stepstodo = abs(ZsetStep - ZcurrStep)/5 ;
  Serial.println(ZcurrStep);
  Serial.println(stepstodo);
  
 if (ZsetStep > ZcurrStep)
  { needtocheckZmovement=0 ;
   Serial.println(ZcurrStep);
   Serial.println("hi");
    digitalWrite(Zdir,HIGH);   delayMicroseconds(10);  ZcurrStep=ZsetStep;  doZSteps( stepstodo );  }

  if (ZsetStep < ZcurrStep)
  { 
    needtocheckZmovement=1 ;
    Serial.println(ZcurrStep);
    Serial.println("hello");
    digitalWrite(Zdir,LOW);   delayMicroseconds(10);  ZcurrStep=ZsetStep; doZSteps( stepstodo );
    Serial.println(ZcurrStep); 
    }
}

void gotoPSetStep(long PsetStep)
{
  //if(PsetStep > PMaxStep)  {PsetStep = PMaxStep;}
  long stepstodo = abs(PsetStep - PcurrStep)/5 ;
  Serial.println(PcurrStep);
  Serial.println(stepstodo);
  
 if (PsetStep > PcurrStep)
  { needtocheckPmovement=0 ;
   Serial.println(PcurrStep);
   Serial.println("hi");
    digitalWrite(Pdir,HIGH);   delayMicroseconds(10);  PcurrStep=PsetStep;  doPSteps( stepstodo );  }

  if (PsetStep < PcurrStep)
  { 
    needtocheckPmovement=1 ;
    Serial.println(PcurrStep);
    Serial.println("hello");
    digitalWrite(Pdir,LOW);   delayMicroseconds(10);  PcurrStep=PsetStep; doPSteps( stepstodo );
    Serial.println(PcurrStep); 
    }
}


void gohome()
{  
   int v=digitalRead(6);
   while(v<1)
   { gotoXSetStep(6400);
     XcurrStep=0L;  
     v=digitalRead(6);
     Serial.println(v);
   }
   
 
   
   { gotoYSetStep(6400);
     YcurrStep=0L;  
     v=digitalRead(6);
     Serial.println(v);
   }   

   
   { gotoZSetStep(6400);
     ZcurrStep=0L;  
     v=digitalRead(6);
     Serial.println(v);
       
   }  

   
   { gotoPSetStep(6400);
     PcurrStep=0L;  
     v=digitalRead(6);
     Serial.println(v);      
   }  

 
 
   XcurrStep=0L;
   YcurrStep=0L;
   ZcurrStep=0L;
   PcurrStep=0L;

}
