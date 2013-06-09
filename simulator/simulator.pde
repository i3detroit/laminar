// Laminar flow fountain simulator

// Number of ms water takes to reach another barrel
int periodA = 2000;
int periodB = 2000;
int periodC = 2000;

// Demo pattern and fountain state
int[] onA = new int[1000];
int[] onB = new int[1000];
int[] onC = new int[1000];
int remainsA = 0;
int remainsB = 0;
int remainsC = 0;
int lastA;
int lastB;
int lastC;
int indexA = 0;
int indexB = 0;
int indexC = 0;
boolean stateA;
boolean stateB;
boolean stateC;
int lastMillis;

// Display configuration
color onColor = color(127, 127, 255);
color offColor = color(0, 0, 0);

void createDemo() {
  // On 1/2, off 1/2
  onA[0] = periodA/2;
  onA[1] = periodA/2;
  lastA = 1;
  indexA = 0;
  // Wait for pulse from A to reach B
  onB[0] = 0;
  onB[1] = periodA;
  // On 1/4, off 1/4, twice
  onB[2] = periodB/4;
  onB[3] = periodB/4;
  onB[4] = periodB/4;
  onB[5] = periodB/4;
  lastB = 5;
  indexB = 0;
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
  lastC = 11;
  indexC = 0;
  
  // Init state
  stateA = true;
  stateB = true;
  stateC = true;
  remainsA = onA[0];
  remainsB = onB[0];
  remainsC = onC[0];
  lastMillis = millis();
}

void setup() {
  size(400, 400);
  createDemo();
}
void draw() {
  // Go back to the beginning if we've finished
  if (
    indexA == lastA && indexB == lastB && indexC == lastC
    && remainsA == 0 && remainsB == 0 && remainsC == 0
  ) {
    print("Resetting\n");
    createDemo();
  }
  
  // Find out how much time has ellapsed since the last draw()
  int curMillis = millis();
  int elapsed = curMillis - lastMillis;
  lastMillis = curMillis;
  
  // Update A state
  int toAdvance = elapsed;
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
      } else {
        break;
      }
    } else {
      // Still time remaining, just subtact it
      remainsC -= toAdvance;
      toAdvance = 0;
    }
  }
  
  // Draw barrels
  float a = width/2.0;
  float r = 50.0;
  if (stateA) {
    fill(onColor);
  } else {
    fill(offColor);
  }
  ellipse(width/2, height/2.0 - a/sqrt(3), r, r);
  if (stateB) {
    fill(onColor);
  } else {
    fill(offColor);
  }
  ellipse(width/2.0 - a/2.0, height/2.0 + a*sqrt(3)/2.0 - a/sqrt(3), r, r);
  if (stateC) {
    fill(onColor);
  } else {
    fill(offColor);
  }
  ellipse(width/2.0 + a/2.0, height/2.0 + a*sqrt(3)/2.0 - a/sqrt(3), r, r);
}

