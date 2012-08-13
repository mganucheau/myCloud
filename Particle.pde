
// A simple Particle class, renders the particle as an image

class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float timer;
  PImage img;
  float accSpread;
  float velSpread;

  Particle(PVector l,PImage img_) {
    accSpread = 0.01;
    velSpread = 0.5;
    acc = new PVector(random(-accSpread,accSpread),random(-accSpread,accSpread),0);
    vel = new PVector(random(-velSpread,velSpread),random(-velSpread,velSpread),0);
    loc = l.get();
    timer = 255.0;
    img = img_;
  }

  void run() {
    update();
    render();
  }

  // Method to apply a force vector to the Particle object
  // Note we are ignoring "mass" here
  void add_force(PVector f) {
    acc.add(f);
  }  

  // Method to update location
  void update() {
    vel.add(acc);
    loc.add(vel);
    timer -=2.5;
  }

  // Method to display
  void render() {
    imageMode(CORNER);
    tint(255,timer);
    image(img,loc.x-img.width/2,loc.y-img.height/2);
  }

  // Is the particle still useful?
  boolean dead() {
    if (timer <= 0.0) {
      return true;
    } 
    else {
      return false;
    }
  }
}





