class Cloud {
  ArrayList skeleton;  // A list to keep track of all the points in our cloud
  int cloudID;
  float radius;        // The radius of the entire cloud
  float xpos;
  float ypos;
  float totalPoints;   // How many points make up the cloud
  float bodyRadius;    // The radius of each body that makes up the skeleton
  float density;
  float frequencyHz;
  float dampingRatio;

  public float totalX = 0;
  public float totalY = 0;
  float timer;

  Cloud(int cloudID_, float radius_, float xpos_, float ypos_, float totalPoints_, float bodyRadius_, float density_, float frequencyHz_, float dampingRatio_ ) {
    cloudID = cloudID_  ;
    radius = radius_;
    xpos = xpos_;
    ypos = ypos_;
    totalPoints = totalPoints_;
    bodyRadius = bodyRadius_;
    density = density_;
    frequencyHz = frequencyHz_;
    dampingRatio = dampingRatio_;

    skeleton = new ArrayList();                                 // Create the empty 
    ConstantVolumeJointDef cvjd = new ConstantVolumeJointDef(); // Let's make a volume of joints!
    Vec2 center = new Vec2(xpos,ypos);                          // Where and how big is the cloud

    // Initialize all the points
    for (int i = 0; i < totalPoints; i++) {

      float noiseScale = noise(.02);
      float theta = PApplet.map(i, 0, totalPoints, 0, TWO_PI);  // Look polar to cartesian coordinate transformation!

      float x = center.x + radius * cos(theta);
      float y = center.y + radius * sin(theta);

      BodyDef bd = new BodyDef();    // Make each individual body
      bd.fixedRotation = false;      // no rotation!
      bd.position.set(box2d.coordPixelsToWorld(x,y));
      Body body = box2d.createBody(bd);
      CircleDef cd = new CircleDef(); // The body is a circle
      cd.radius = box2d.scalarPixelsToWorld(bodyRadius);
      cd.density = density;
      cd.restitution = 1.5f;     // Restitution is bounciness
      body.createShape(cd);           // Finalize the body
      cvjd.addBody(body);             // Add it to the volume
      body.setMassFromShapes();       // We always do this at the end
      skeleton.add(body);             // Store our own copy for later rendering
    }

    cvjd.frequencyHz = frequencyHz;   //how stiff vs. jiggly the cloud is
    cvjd.dampingRatio = dampingRatio;
    box2d.world.createJoint(cvjd);    // Put the joint thing in our world!
  }

  void display(int s1_, int keyone_, int keytwo_, int keythree_, int keyfour_, int keyfive_, int keysix_) {
    s1       = s1_;
    keyone   = keyone_;
    keytwo   = keytwo_;
    keythree = keythree_;
    keyfour  = keyfour_;
    keyfive  = keyfive_;
    keysix   = keysix_;

    beginShape();
    totalX = 0;
    totalY = 0;
    fill(255);
    noStroke();
    for (int i = 0; i < skeleton.size(); i++) {

      Body b = (Body) skeleton.get(i);   // We look at each body and get its screen position
      Vec2 pos = box2d.getBodyPixelCoord(b);

      totalX += pos.x; 
      totalY += pos.y;     

      if(i % 2 == 0) {     
      ps.add(new ParticleSystem(1,new PVector(pos.x,pos.y),img));
      }
    }
    endShape(CLOSE);
    totalX = totalX / totalPoints;
    totalY /= totalPoints;
    ps.add(new ParticleSystem(1,new PVector(totalX,totalY),img));  // a center point particle system
    float boxsize = radius*3;

    //  -----------------  Body Border Box
//        stroke(0);
//        fill(0,0,0,0);
//        rectMode(CENTER);
//        rect (totalX,totalY,boxsize,boxsize);
//        fill(255,100);
//        noStroke();

    float sz = random(2,6);

    if (s1 == cloudID) {
      if (keyone == 1) {
        hits.add(new Hit(totalX,totalY-(boxsize/2),sz,4,boxsize));   // up
      }
      if (keytwo == 1) {
        hits.add(new Hit(totalX,totalY+(boxsize/2),sz,2,boxsize));   // down
      }
      if (keythree == 1) {
        hits.add(new Hit(totalX-(boxsize/2),totalY+(boxsize/4),sz,1,boxsize));   // left1
      }
      if (keyfour == 1) {
        hits.add(new Hit(totalX+(boxsize/2),totalY+(boxsize/4),sz,3,boxsize));   // right1
      }
      if (keyfive == 1) {
        hits.add(new Hit(totalX-(boxsize/2),totalY-(boxsize/4),sz,1,boxsize));   // left2
      }
      if (keysix == 1) {
        hits.add(new Hit(totalX+(boxsize/2),totalY-(boxsize/4),sz,3,boxsize));   // right2
      }
      
    }
  }
}


public void createJoint(Body body1, Body body2, Vec2 any1, Vec2 any2) {
  DistanceJointDef jd = new DistanceJointDef();
  jd.initialize(body1, body2, any1, any2);
  jd.collideConnected = true;
  box2d.world.createJoint(jd);
}




