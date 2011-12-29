Particle p[];
float fadeRate;
int numParticles = 5;

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
  
    if (_p[i].isOutOfBounds()) {
      _p[i] = new Particle();
    }
  }
}

class Particle {
  float xPos;
  float yPos;
  float xDir;
  float yDir;
  float speed;
  float partSize;
  float partInnerSize;
  color baseColor = color(255, 0, 0);
  float particleMinXSpeed = 2.0f;
  float particleMinYSpeed = particleMinXSpeed;
  float particleMaxXSpeed = 5.0f;
  float particleMaxYSpeed = particleMaxXSpeed;
  int lifespan = 1000;
  int life = 0;
  
  Particle() {
    
    xPos = width / 2.0f;
    yPos = height / 2.0f;
    xDir = random(particleMinXSpeed, particleMaxXSpeed);
    yDir = random(particleMinYSpeed, particleMaxYSpeed);
    if (floor(random(0, 2)) == 1) {
      xDir *= -1.0f;
    }
    if (floor(random(0, 2)) == 1) {
      yDir *= -1.0f;
    }
    
    speed = 1.0f;
    partSize = random(30, 60);
    partInnerSize = partSize / 2.0f;
  }
    
  void render() {
    fill(baseColor, 20);
    ellipse(xPos, yPos, partSize, partSize);
    fill(baseColor, 100);
    ellipse(xPos, yPos, partInnerSize, partInnerSize);    
    life++;
  }
  
  boolean lifeOver() {
    boolean over = life > lifespan ? true : false;
    return over;
  }
  
  void move() {
    xPos += xDir * speed;
    yPos += yDir * speed;
  }
  
  boolean isOutOfBounds() {
    boolean outOfBounds = false;
    if (xPos > width || xPos < 0) {
      outOfBounds = true;
    } else if (yPos > height || yPos < 0) {
      outOfBounds = true;
    }
    return outOfBounds;
  }
  
}

