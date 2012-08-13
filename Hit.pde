// Hit Is a particle class that is created to push in a direction

class Hit {
  Body body;
  float x;
  float y;
  float r;   // radius
  float dir; // direction
  float boxsize;
  float life = 70;  // life span

  Hit(float x, float y, float r_, float dir_, float boxsize_) {
    r = r_;
    dir = dir_;
    makeBody(x,y,r,dir);   //puts the particle in the Box2d world
    boxsize = boxsize_;
  }

  void killBody() {
    box2d.destroyBody(body);  // removes the particle from the box2d world
  }

  boolean done() {
    life--;
    Vec2 pos = box2d.getBodyPixelCoord(body);     //finds the screen position of the particle
    if (life < 0) {
      killBody();
      return true;
    }
      return false;
   }

  void display() {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    pushMatrix();
    translate(pos.x,pos.y);
    noStroke();
    fill(100);
    ellipse(0, 0+0.1, 0.05+r*2, 0.1+r*2 );
    popMatrix();
  }

  void makeBody(float x, float y, float r, float dir) {
    BodyDef bd = new BodyDef();  // Define a body
    bd.position = box2d.coordPixelsToWorld(x,y);  // Set its position
    body = box2d.world.createBody(bd);

    CircleDef cd = new CircleDef();     // Make the body's shape a circle
    cd.radius = box2d.scalarPixelsToWorld(r);
    cd.density = 1f;
    cd.friction = 0.02f;
    cd.restitution = 1f;     // Restitution is bounciness
    body.createShape(cd);
    body.setMassFromShapes();  // Always do this at the end

    if (dir == 1) {
      body.setLinearVelocity(new Vec2(random(5f,5f),random(-5f,5f))); // right
    }
    if (dir == 2) {
      body.setLinearVelocity(new Vec2(random(-5f,5f),random(5f,5f))); // up
    }
    if (dir == 3) {
      body.setLinearVelocity(new Vec2(random(-5f,-5f),random(-5f,5f))); // left  
    }
    if (dir == 4) {
      body.setLinearVelocity(new Vec2(random(-5f,5f),random(-5f,-5f))); // down 
    }
//    if (dir == 5) {
//      body.setLinearVelocity(new Vec2(random(-5f,5f),random(-5f,-5f))); // down 
//    }
//    if (dir == 6) {
//      body.setLinearVelocity(new Vec2(random(-5f,5f),random(-5f,-5f))); // down 
//    }


  }

}



