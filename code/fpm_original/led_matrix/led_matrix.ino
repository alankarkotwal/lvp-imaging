/**************************************************************************
% Fourier Ptychographic Imaging for transparent objects, transmitted light
% LED Matrix Driver
%
% Author: Alankar Kotwal <alankarkotwal13@gmail.com>
%
% I assume for LEDs: +ve 'along X', -ve 'along Y'
**************************************************************************/

#define nX 32
#define nY 32

int xC, yC;

void setup() {
  Serial.begin(9600);
}

void loop() {
 if(Serial.available()) {
    if(Serial.read() == 255) {
      xC = (int)Serial.read();
      yC = (int)Serial.read();
      setArray(xC, yC)
    }
 }
}


void clearArray() {
  
}

void setArray(int x, int y) {
  clearArray();
  
}
