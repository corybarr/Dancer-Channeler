Particle p[];
float fadeRate;
int numParticles = 50;
PVector mouseAttractVec;

void setup() {
  size(500, 500);
  background(0);
  smooth();
  noStroke();
  frameRate(30);
  mouseAttractVec = new PVector(1.0f, 1.0f, 1.0f);
  
  fadeRate = 15.0f;
  p = new Particle[numParticles];
  
  for (int i=0; i < numParticles; i++) {
    p[i] = new Particle();
  }
}

void draw() {
  
  if (frameCount % frameRate / 2 == 0) {
  }
  
  background(0);
  updateParticles(p);
}

void updateParticles(Particle _p[]) {
  for (int i = 0; i < _p.length; i++) {
    _p[i].render();
    _p[i].move();
  
    if (_p[i].lifeOver()) {
      _p[i] = new Particle();
    }
  }
}

class Particle {
  PVector position;
  PVector velocity;
  float partSize;
  float partInnerSize;
  float minMagnitude = 1.0f;
  float maxMagnitude = 3.0f;
  int lifespan = 100;
  int life = 0;
  float zScalar = 0.9; //for determining how the z axis is graphically interpreted
  float curPartSize;
  float innerRingMultiplier;
  boolean allowAttraction = true;
  
  Particle() {
    
    position = new PVector(width / 2.0f, height / 2.0f, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1), random(-1, 0.5));
    velocity.normalize();
    velocity.mult(random(minMagnitude, maxMagnitude));
    partSize = random(30, 60);
    curPartSize = partSize;
    innerRingMultiplier = random(0.2, 5);
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
    } else {
      position.add(velocity);
    }
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

