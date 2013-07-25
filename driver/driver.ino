// Laminar flow fountain driver

// Output pins
int onPinA = 2;
int offPinA = 3;
int onPinB = 4;
int offPinB = 5;
int onPinC = 6;
int offPinC = 7
long remainsPinA = 0;
long remainsPinB = 0;
long remainsPinC = 0;

// Number of ms to pulse actuator
long actuatorMs = 120;

// Number of ms water takes to reach another barrel
int periodA = 1500;
int periodB = 1500;
int periodC = 1500;

// Demo pattern and fountain state
int onA[100];
int onB[100];
int onC[100];
int remainsA = 0;
int remainsB = 0;
int remainsC = 0;
int lastA;
int lastB;
int lastC;
int indexA = -1;
int indexB = -1;
int indexC = -1;
boolean stateA;
boolean stateB;
boolean stateC;
long lastMillis;

// Load the state variables for the demo
void createDemo() {
  // On 1/2, off 1/2
  onA[0] = periodA/2;
  onA[1] = periodA/2;
  lastA = 1;
  indexA = -1;
  // Wait for pulse from A to reach B
  onB[0] = 0;
  onB[1] = periodA;
  // On 1/4, off 1/4, twice
  onB[2] = periodB/4;
  onB[3] = periodB/4;
  onB[4] = periodB/4;
  onB[5] = periodB/4;
  lastB = 5;
  indexB = -1;
  // Wait for pulse from A to reach B
  onC[0] = 0;
  onC[1] = periodA;
  // Wait for pulse from B to reach C
  onC[2] = 0;
  onC[3] = periodB;
  // On 1/8, off 1/8, four times
  onC[4] = periodC/8;
  onC[5] = periodC/8;
  onC[6] = periodC/8;
  onC[7] = periodC/8;
  onC[8] = periodC/8;
  onC[9] = periodC/8;
  onC[10] = periodC/8;
  onC[11] = periodC/8;
  // Wait for last pulse to finish
  onC[11] = 0;
  onC[11] = periodC*7/8;
  lastC = 13;
  indexC = -1;
  
  // Init state
  stateA = false;
  stateB = false;
  stateC = false;
  remainsA = 0;
  remainsB = 0;
  remainsC = 0;
  lastMillis = millis();
}

void setup() {
  pinMode(pinA, OUTPUT);
  pinMode(pinB, OUTPUT);
  pinMode(pinC, OUTPUT);
  pinMode(13, OUTPUT);
  digitalWrite(onPinA, LOW);
  digitalWrite(onPinB, LOW);
  digitalWrite(onPinC, LOW);
  digitalWrite(offPinA, LOW);
  digitalWrite(offPinB, LOW);
  digitalWrite(offPinC, LOW);
  digitalWrite(13, LOW);
  createDemo();
}

void loop() {
  // Go back to the beginning if we've finished
  if (
    indexA == lastA && indexB == lastB && indexC == lastC
    && remainsA == 0 && remainsB == 0 && remainsC == 0
  ) {
    createDemo();
  }
  
  // Find out how much time has ellapsed since the last draw()
  long curMillis = millis();
  long elapsed = curMillis - lastMillis;
  lastMillis = curMillis;

  updateActuators(elapsed);

  // Update A state
  long toAdvance = elapsed;
  while (toAdvance > 0) {
    // Check whether we've finished the current state
    if (remainsA <= toAdvance) {
      // Subtract time left on current state, and move to next state
      toAdvance -= remainsA;
      remainsA = 0;
      if (indexA < lastA) {
        indexA++;
        remainsA = onA[indexA];
        stateA = !stateA;
        setActuatorA(stateA);
      } else {
        break;
      }
    } else {
      // Still time remaining, just subtact it
      remainsA -= toAdvance;
      toAdvance = 0;
    }
  }
  
  // Update B state
  toAdvance = elapsed;
  while (toAdvance > 0) {
    // Check whether we've finished the current state
    if (remainsB <= toAdvance) {
      // Subtract time left on current state, and move to next state
      toAdvance -= remainsB;
      remainsB = 0;
      if (indexB < lastB) {
        indexB++;
        remainsB = onB[indexB];
        stateB = !stateB;
        setActuatorB(stateB);
      } else {
        break;
      }
    } else {
      // Still time remaining, just subtact it
      remainsB -= toAdvance;
      toAdvance = 0;
    }
  }
  
  // Update C state
  toAdvance = elapsed;
  while (toAdvance > 0) {
    // Check whether we've finished the current state
    if (remainsC <= toAdvance) {
      // Subtract time left on current state, and move to next state
      toAdvance -= remainsC;
      remainsC = 0;
      if (indexC < lastC) {
        indexC++;
        remainsC = onC[indexC];
        stateC = !stateC;
        setActuatorC(stateC);
      } else {
        break;
      }
    } else {
      // Still time remaining, just subtact it
      remainsC -= toAdvance;
      toAdvance = 0;
    }
  }
}

void setActuatorA(boolean state) {
  if (state) {
    digitalWrite(onPinA, HIGH);
    digitalWrite(onPinA, LOW);
    remainsPinA = actuatorMs;
  } else {
    digitalWrite(onPinA, LOW);
    digitalWrite(onPinA, HIGH);
    remainsPinA = actuatorMs;
  }
}

void setActuatorB(boolean state) {
  if (state) {
    digitalWrite(onPinB, HIGH);
    digitalWrite(onPinB, LOW);
    remainsPinA = actuatorMs;
  } else {
    digitalWrite(onPinB, LOW);
    digitalWrite(onPinB, HIGH);
    remainsPinA = actuatorMs;
  }
}

void setActuatorC(boolean state) {
  if (state) {
    digitalWrite(onPinC, HIGH);
    digitalWrite(onPinC, LOW);
    remainsPinA = actuatorMs;
  } else {
    digitalWrite(onPinC, LOW);
    digitalWrite(onPinC, HIGH);
    remainsPinA = actuatorMs;
  }
}

void updateActuators(long elapsed) {
  if (remainsPinA < elapsed) {
    digitalWrite(onPinA, LOW);
    digitalWrite(offPinA, LOW);
  }
  if (remainsPinB < elapsed) {
    digitalWrite(onPinB, LOW);
    digitalWrite(offPinB, LOW);
  }
  if (remainsPinC < elapsed) {
    digitalWrite(onPinC, LOW);
    digitalWrite(offPinC, LOW);
  }
  remainsPinA = max(0, remainsPinA - elapsed);
  remainsPinB = max(0, remainsPinB - elapsed);
  remainsPinC = max(0, remainsPinC - elapsed);
}
