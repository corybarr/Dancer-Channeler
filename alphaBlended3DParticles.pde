Particle p[];
float fadeRate;
int numParticles = 15;
int curNumParticles = 3;
PVector mouseAttractVec;
boolean userHasInteracted = false;
PImage dancer;
PVector partEmitPos;
float zPush = 0.45f; //max amount dancer can push particles

void setup() {
  size(512, 512);
  background(0);
  smooth();
  noStroke();
  frameRate(30);
  mouseAttractVec = new PVector(0.146f, 0.6f, zPush);
  partEmitPos = new PVector(169, 32, 0);
  
  dancer = loadImage("danielle.jpg");
  
  fadeRate = 15.0f;
  p = new Particle[numParticles];
  
  for (int i=0; i < numParticles; i++) {
    p[i] = new Particle(partEmitPos);
  }
}

void draw() {
  background(0);
  imageMode(CENTER);
  image(dancer, width / 2, height / 2);
  
  //this code is so dancer dose not emit all particles at very beginning
  if ((curNumParticles < numParticles) && (frameCount % (int) (frameRate / 2) == 0)) {
    curNumParticles++;
  }
    
  if (userHasInteracted && (frameCount % (int) (frameRate / 4) == 0)) {
      mouseAttractVec = getMouseAttractVec();
  }
  
  updateParticles(p);
  
  //println("frameRate: " + frameRate);
}

void mouseMoved() {
  userHasInteracted = true;
}

void mousePressed() {
  userHasInteracted = true;
}

PVector getMouseAttractVec() {    
    PVector maxDistances = new PVector(width, height);
    maxDistances.sub(partEmitPos);
    float newXVal = (mouseX - partEmitPos.x) / maxDistances.x;
    float newYVal = (mouseY - partEmitPos.y) / maxDistances.y;

    return new PVector(newXVal, newYVal, zPush);
}

void updateParticles(Particle _p[]) {
  
  for (int i = 0; i < curNumParticles; i++) {
    _p[i].render();
  
    if (_p[i].lifeOver()) {
      _p[i] = new Particle(partEmitPos);
    }
  }
}

class Particle {
  PVector position;
  PVector velocity;
  float partSize;
  float partInnerSize;
  float minMagnitude = 2.0f;
  float maxMagnitude = 6.0f;
  int lifespan = 130;
  int life = 0;
  float zScalar = 0.9; //for determining how the z axis is graphically interpreted
  float curPartSize;
  float innerRingMultiplier;
  boolean allowAttraction = true;
  
  Particle(PVector _pos) {
    
    position = _pos.get();
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 0.5));
    velocity.normalize();
    velocity.mult(random(minMagnitude, maxMagnitude));
    partSize = random(30, 60);
    curPartSize = partSize;
    innerRingMultiplier = random(0.2, 5);
    lifespan = floor(random(120, 150));
  }
    
  void render() {
    
    curPartSize = getPartSize();
    
    int numInnerRings = 10;
    for (int i = 0; i < numInnerRings; i++) {
      float curWhiteVal = map(i, 0, numInnerRings - 1, 0, 255);
      float curAlpha = map(i, 0, numInnerRings - 1, 20, 200);
      float ringSize = curPartSize / (i * innerRingMultiplier + 1.0f);

      fill(curWhiteVal, curWhiteVal, 255, curAlpha);
      ellipse(position.x, position.y, ringSize, ringSize);
    }
    
    life++;
    move();
  }
  
  float getPartSize() {
    return partSize + position.z * zScalar;
  }
  
  float getInnerSize() {
    return partSize / 2.0f;
  }
  
  void updateSize() {
    partSize = partSize + position.z * zScalar;
    partInnerSize = getInnerSize();
  }
  
  boolean lifeOver() {
    boolean over = life > lifespan ? true : false;
    
    if (!over) {
      over = isOutOfBounds();
    }
    
    if (!over && (curPartSize <= 0.0f)) {
      over = true;
    }
    
    return over;
  }
  
  void move() {
    if (allowAttraction) {
      float attractionAmount;
      PVector localMouseAttract = mouseAttractVec.get();
      localMouseAttract.mult(0.25);
      
      float curMagnitude = velocity.mag();
      velocity.add(localMouseAttract);
      velocity.normalize();
      velocity.mult(curMagnitude);
    } 

    position.add(velocity);
  }
  
  boolean isOutOfBounds() {
    boolean outOfBounds = false;
    if (position.x > width || position.x < 0) {
      outOfBounds = true;
    } else if (position.y > height || position.y < 0) {
      outOfBounds = true;
    }
    return outOfBounds;
  }
}


