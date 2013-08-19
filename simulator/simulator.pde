// Laminar flow fountain simulator

// Show debugging info
boolean debug = false;

// Number of ms water takes to reach another barrel
int periodA = 1250;
int periodB = 1250;
int periodC = 1250;

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
int indexA = -1;
int indexB = -1;
int indexC = -1;
boolean stateA;
boolean stateB;
boolean stateC;
int lastMillis;

// Display configuration
color onColor = color(127, 127, 255);
color offColor = color(0, 0, 0);

// Class representing a pulse of water
class Pulse {
  float x, y;
  float start, end;
  float len;
  float progress;
  Pulse (float x, float y, float s, float l) {
    this.x = x;
    this.y = y;
    progress = 0;
    start = s;
    end = s - PI;
    len = l;
  }
  void addProgress(float p) {
    progress = progress + p;
  }
  boolean isDone() {
    return progress > PI + len;
  }
  void draw() {
    float r = width/2.0;
    float from = start - max(0, progress - len);
    float to = max(start - progress, start - PI);
    if (debug) {
      println("start:" + start + " progress:" + progress);
      println("from:" + start + " to:" + progress);
    }
    noFill();
    stroke(onColor);
    strokeWeight(5);
    arc(x, y, r, r, to, from);
  }
}

// Load the state variables for the demo
void createDemo() {
  int a = 0;
  int b = 0;
  int c = 0;
  // Turn streams on, then off in order
  onA[a++] = 9000;
  onA[a++] = 9000;
  onB[b++] = 0;
  onB[b++] = 3000;
  onB[b++] = 9000;
  onB[b++] = 6000;
  onC[c++] = 0;
  onC[c++] = 6000;
  onC[c++] = 9000;
  onC[c++] = 3000;
  // Turn all on at same time
  onA[a++] = 3000;
  onB[b++] = 3000;
  onC[c++] = 3000;
  // Turn all off at same time
  onA[a++] = 3000;
  onB[b++] = 3000;
  onC[c++] = 3000;
  // Make a pulse leap through each fountain
  onA[a++] = periodA / 5;
  onA[a++] = periodA * 4/5;
  onA[a++] = 0;
  onA[a++] = periodB + periodC;
  onB[b++] = 0;
  onB[b++] = periodA;
  onB[b++] = periodB / 5;
  onB[b++] = periodB * 4/5;
  onB[b++] = 0;
  onB[b++] = periodC;
  onC[c++] = 0;
  onC[c++] = periodA + periodB;
  onC[c++] = periodC / 5;
  onC[c++] = periodC * 4/5;
  // Make two pulses leap through each fountain
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA * 2/5;
  onA[a++] = 0;
  onA[a++] = periodB + periodC;
  onB[b++] = 0;
  onB[b++] = periodA;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB * 2/5;
  onB[b++] = 0;
  onB[b++] = periodC;
  onC[c++] = 0;
  onC[c++] = periodA + periodB;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC * 2/5;
  // Make three pulses leap through each fountain
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA + periodB + periodC;
  onB[b++] = 0;
  onB[b++] = periodA;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB + periodC;
  onC[c++] = 0;
  onC[c++] = periodA + periodB;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;  
  onC[c++] = periodC;
  // Turn all on
  onA[a++] = 2 * max(periodA, max(periodB, periodC));
  onB[b++] = 2 * max(periodA, max(periodB, periodC));
  onC[c++] = 2 * max(periodA, max(periodB, periodC));
  // Make a break leap through each fountain
  onA[a++] = periodA / 5;
  onA[a++] = periodA * 4/5 + periodB + periodC;
  onB[b++] = 0;
  onB[b++] = periodA;
  onB[b++] = periodB / 5;
  onB[b++] = periodB * 4/5 + periodC;
  onC[c++] = 0;
  onC[c++] = periodA + periodB;
  onC[c++] = periodC / 5;
  onC[c++] = periodC * 4/5;
  // Make two breaks leap through
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA * 2/5 + periodB + periodC;
  onB[b++] = 0;
  onB[b++] = periodA;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB * 2/5 + periodC;
  onC[c++] = 0;
  onC[c++] = periodA + periodB;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC * 2/5;
  // Make three breaks leap through
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodA / 5;
  onA[a++] = periodB + periodC + periodC;
  onA[a++] = periodC;
  onB[b++] = 0;
  onB[b++] = periodA;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodB / 5;
  onB[b++] = periodC + periodC;
  onB[b++] = periodC;
  onC[c++] = 0;
  onC[c++] = periodA + periodB;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC / 5;
  onC[c++] = periodC;
  onC[c++] = periodC;
  
  // End program
  lastA = a;
  lastB = b;
  lastC = c;
  
  // Init state
  indexA = -1;
  indexB = -1;
  indexC = -1;
  stateA = false;
  stateB = false;
  stateC = false;
  remainsA = 0;
  remainsB = 0;
  remainsC = 0;
  lastMillis = millis();
}


// Load the state variables for the demo
void createDemo1() {
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

ArrayList<Pulse> aPulses;
ArrayList<Pulse> bPulses;
ArrayList<Pulse> cPulses;

void setup() {
  size(600, 400);
  createDemo();
  aPulses = new ArrayList<Pulse>();
  bPulses = new ArrayList<Pulse>();
  cPulses = new ArrayList<Pulse>();
}
void draw() {
  // Calculate barrel coordinates
  float a = width/2.0;
  float ax = width/2.0;
  float ay = height/2.0 - a/sqrt(3);
  float bx = width/2.0 - a/2.0;
  float by = height/2.0 + a*sqrt(3)/2.0 - a/sqrt(3);
  float cx = width/2.0 + a/2.0;
  float cy = height/2.0 + a*sqrt(3)/2.0 - a/sqrt(3);
  
  // Clear screen
  background(127);
  
  // Go back to the beginning if we've finished
  if (
    indexA == lastA && indexB == lastB && indexC == lastC
    && remainsA == 0 && remainsB == 0 && remainsC == 0
  ) {
    print("Resetting\n");
    aPulses.clear();
    bPulses.clear();
    cPulses.clear();
    createDemo();
  }
  
  // Find out how much time has ellapsed since the last draw()
  int curMillis = millis();
  int elapsed = curMillis - lastMillis;
  lastMillis = curMillis;

  // Advance existing pulses
  for (Pulse p : aPulses) {
    p.addProgress((float)elapsed/periodA*PI);
  }
  for (Pulse p : bPulses) {
    p.addProgress((float)elapsed/periodB*PI);
  }
  for (Pulse p : cPulses) {
    p.addProgress((float)elapsed/periodC*PI);
  }
  
  // Update A state
  Pulse nextPulse;
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
        if (stateA) {
          // Create a new pulse
          nextPulse = new Pulse((ax+bx)/2.0, (ay+by)/2.0, 5.0*PI/3.0, (float)remainsA/periodA*PI);
          nextPulse.addProgress(toAdvance/periodA*PI);
          aPulses.add(nextPulse);
        }
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
        if (stateB) {
          // Create a new pulse
          nextPulse = new Pulse((bx+cx)/2.0, (by+cy)/2.0, PI, (float)remainsB/periodB*PI);
          nextPulse.addProgress(toAdvance/periodB*PI);
          bPulses.add(nextPulse);
        }
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
        if (stateC) {
          // Create a new pulse
          nextPulse = new Pulse((cx+ax)/2.0, (cy+ay)/2.0, PI/3.0, (float)remainsC/periodC*PI);
          nextPulse.addProgress(toAdvance/periodC*PI);
          cPulses.add(nextPulse);
        }
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
  float r = 50.0;
  if (stateA) {
    fill(onColor);
  } else {
    fill(offColor);
  }
  ellipse(ax, ay, r, r);
  if (stateB) {
    fill(onColor);
  } else {
    fill(offColor);
  }
  ellipse(bx, by, r, r);
  if (stateC) {
    fill(onColor);
  } else {
    fill(offColor);
  }
  ellipse(cx, cy, r, r);
  
  // Draw pulses
  for (Pulse p : aPulses) {
    p.draw();
  }
  for (Pulse p : bPulses) {
    p.draw();
  }
  for (Pulse p : cPulses) {
    p.draw();
  }
}

