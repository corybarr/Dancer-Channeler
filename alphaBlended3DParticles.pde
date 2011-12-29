Particle p[];
float fadeRate;
int numParticles = 50;

void setup() {
  size(500, 500);
  background(0);
  smooth();
  noStroke();
  frameRate(30);
  
  fadeRate = 15.0f;
  p = new Particle[numParticles];
  
  for (int i=0; i < numParticles; i++) {
    p[i] = new Particle();
  }
}

void draw() {
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
  color baseColor = color(255, 0, 0);
  float minMagnitude = 1.0f;
  float maxMagnitude = 3.0f;
  int lifespan = 100;
  int life = 0;
  
  Particle() {
    
    position = new PVector(width / 2.0f, height / 2.0f, 0);
    velocity = new PVector(random(-1, 1), random(-1, 1), 0.0f);
    velocity.normalize();
    velocity.mult(random(minMagnitude, maxMagnitude));
    partSize = random(30, 60);
    partInnerSize = getInnerSize();
  }
    
  void render() {
    fill(baseColor, 20);
    ellipse(position.x, position.y, partSize, partSize);
    fill(baseColor, 100);
    ellipse(position.x, position.y, getInnerSize(), getInnerSize());    
    life++;
    updateSize();
    move();
  }
  
  float getInnerSize() {
    return partSize / 2.0f;
  }
  
  void updateSize() {
    partSize = partSize;
    partInnerSize = getInnerSize();
  }
  
  boolean lifeOver() {
    boolean over = life > lifespan ? true : false;
    
    if (!over) {
      over = isOutOfBounds();
    }
    
    return over;
  }
  
  void move() {
    position.x += velocity.x;
    position.y += velocity.y;
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

