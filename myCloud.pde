/* ---------------------------------------
myCloud 
an interactive cloud controlled by a custom soft circuit controller
by Matt Ganucheau (mganucheau@gmail.com)

Libraries Used: 
pbox2d   - https://github.com/shiffman/PBox2D
oscP5    - http://www.sojamo.de/libraries/oscP5/

Commands:
B - shows/hides boundaries
P - shows/hides particles

This sketch uses code from the following sources:
Blobby - PBox2D example, 2008, Daniel Shiffman.
Webcam Piano - Copyright (c) 2008, Memo Akten, www.memo.tv

*/


import processing.opengl.*;
import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;  
import org.jbox2d.dynamics.joints.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
PBox2D box2d;
PImage img;

ArrayList boundaries;
ArrayList hits;
ArrayList clouds;

Random generator;
ArrayList ps;
PImage msk;

float theta = 0.0f;
float theta_vel = 0.005f; // speed
float sz = 0.0;
int input;
int keyone   = 0;
int keytwo   = 0;
int keythree = 0;
int keyfour  = 0;
int keyfive  = 0;
int keysix   = 0;
int cloudID;
int s1 = 4;
int s2;
int s3;
int s4;
int s5;
int s6;
int s7;
boolean showHits = true;

void setup() {
  size(screen.width, screen.height, OPENGL);
  smooth(); 
  initOsc();
  box2d = new PBox2D(this);
  box2d.createWorld();
  box2d.setGravity(0,0);  // gravity!

  ps = new ArrayList();
  hits = new ArrayList();
  clouds = new ArrayList();
  boundaries = new ArrayList();

  generator = new Random();
  msk = loadImage("texture2.png");
  img = new PImage(msk.width,msk.height);
  for (int i = 0; i < img.pixels.length; i++) img.pixels[i] = color(255);
  img.mask(msk);

  int boundaryOffset = 20;
  boundaries.add(new Boundary(width/2,boundaryOffset,width,1));          // top
  boundaries.add(new Boundary(width/2,height-boundaryOffset,width,1));   // bottom
  boundaries.add(new Boundary(width-boundaryOffset,height/2,1,height));  // right
  boundaries.add(new Boundary(boundaryOffset,height/2,1,height));        // left

//Cloud = cloudID, radius, xpos, ypos, totalPoints, bodyRadius, density, frequencyHz, dampingRatio
  clouds.add(new Cloud(4, 65, width/2, height/2, 20, 1, 1f, 1f, 1.0f));
}

void initOsc() {
  oscP5 = new OscP5(this,8080);
  myRemoteLocation = new NetAddress("127.0.0.1",8080);
  oscP5.plug(this, "sensor1", "/s1");
  oscP5.plug(this, "sensor2", "/s2");
  oscP5.plug(this, "sensor3", "/s3");
  oscP5.plug(this, "sensor4", "/s4");
  oscP5.plug(this, "sensor5", "/s5");
  oscP5.plug(this, "sensor6", "/s6");
  oscP5.plug(this, "sensor7", "/s7");
}

void draw() {
  noCursor();
  background(165, 180, 255);
  sensorOSC();
  box2d.step();

  for (int i = 0; i < clouds.size(); i++) {
    Cloud c = (Cloud) clouds.get(i);
    c.display(s1,keyone,keytwo,keythree,keyfour,keyfive,keysix);
  }

  for (int i = ps.size()-1; i >= 0; i--) {
    ParticleSystem psys = (ParticleSystem) ps.get(i);
    psys.run();
    if (psys.dead()) {
      ps.remove(i);
    }
  }

  for (int i = 0; i < hits.size(); i++) {
    Hit h = (Hit) hits.get(i);
    keyone   = 0;
    keytwo   = 0;
    keythree = 0;
    keyfour  = 0; 
    keyfive  = 0;
    keysix   = 0;
    if (showHits) {
      h.display();
    }
  }  

  for (int i = hits.size()-1; i >= 0; i--) {
    Hit h = (Hit) hits.get(i);
    if (h.done()) {
      hits.remove(i);
    }
  }
}

void keyPressed() {
  if (key == '1') {
    s1 = 3;
  }
  if (key == '2') {
    s1 = 4;
  }
  if (key == '0') {
    s1 = 0;
  }
  if (key == 'p') {
    showHits = !showHits;
  } 
  if (key == 'w') {
    keyone = 1;
  } 
  if (key == 'x') {
    keytwo = 1;
  }  
  if (key == 'a') {
    keythree = 1;
  }  
  if (key == 'd') {
    keyfour = 1;
  }
  if (key == 'z') {
    keyfive = 1;
  }
  if (key == 'c') {
    keysix = 1;
  }

  if (key == 'o') {
    for (int i = 0; i < clouds.size(); i++) {
      clouds.remove(i);  
    }
  }
}

void sensorOSC() {
  if (s2 > 0) {
    keyone = 1;
  } 
  if (s3 > 0) {
    keytwo = 1;
  } 
  if (s4 > 0) {
    keythree = 1;
  } 
  if (s5 > 0) {
    keyfour = 1;
  } 
  if (s6 > 0) {
    keyfive = 1;
  } 
  if (s7 > 0) {
    keysix = 1;
  } 
}

void sensor1(int value) {
  s1 = value;
}
void sensor2(int value) {
  s2 = value;
}
void sensor3(int value) {
  s3 = value;
}
void sensor4(int value) {
  s4 = value;
}
void sensor5(int value) {
  s5 = value;
}
void sensor6(int value) {
  s6 = value;
}
void sensor7(int value) {
  s7 = value;
}




