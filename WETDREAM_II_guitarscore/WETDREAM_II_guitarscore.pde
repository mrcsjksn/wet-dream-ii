//WET DREAM II GUITAR SCORE
//Marcus Jackson, 2018

//Premiere: Nelson Composers Workshop
//e.gt: Jake Church kit: Justin DeHart

/*
 FINGER IS REGULAR, SLAP IS SLAP/HAMMER ON
 
 - value rejection
 - strumming
 - hide things if they aren't changing?
 
 - rate of change defines when new note hits
 - find pictures to display of rockstars
 
 */

//----------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------

//CONTROLP5
import controlP5.*;

ControlP5 cp5;
ControlTimer c;
Textlabel textlabel;

//OSCP5
import oscP5.*;
import netP5.*;

OscP5 oscp5;
NetAddress myRemoteLocation;

//java for partsys
import java.util.Iterator;
ArrayList<Fingering> lhFingers;

Pedal vol1;
Pedal vol2;
Pedal pitchshift;

//ToneSelector ts;

float topPos = 100;
float bottomPos = 300;
float fingerWidth = 23;
float rArmPos = 1000;
float lArmPos = 100;
float angle = 0;
float spacing = 200/6;
float armOffset = 0;

float t = 0;
float v1 = 0;
float v2 = 0;
int frameNum = 70;

float lPressure = 255;
float rPressure = 255;

PShape pickup, l, topround, bottomround;

color onPed = color(255);
color offPed = color(0);

float[] pColor = {255, 255, 255};

float receivedValue;
float rateChangeL = 0;
float rateChangeR = 0;

float[] str_hPos = new float[6];
PedalButton[] p;
boolean[] pedalButtonState = { true, true, false, true, false};

Table dataTable;
int rowNums;
int columnNums;

PShape trem;

//----------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------

void setup() {
  size(1200, 600);
  //noSmooth(); //needed??????
  background(255);
  frameRate(30);
  cp5 = new ControlP5(this);
  c = new ControlTimer();
  textlabel = cp5.addTextlabel("--")
    .setText(c.toString())
    .setPosition(0, 0)
    .setFont(createFont("Times New Roman", 60))
    .setColor(0);
  ;
  c.setSpeedOfTime(1);

  lhFingers = new ArrayList<Fingering>(10);

  //OSC listening on port 12000 for incoming messages
  oscp5 = new OscP5(this, 12000);
  //OSC sending to port 12001 (blackhole tbh)
  myRemoteLocation = new NetAddress("127.0.0.1", 12001);

  /*
  //table
   dataTable = loadTable("guitar-score.csv", "header");
   rowNums = dataTable.getRowCount();
   columnNums = dataTable.getColumnCount();
   println(rowNums + "total rows in table");
   println(columnNums + "total columns in table");
   */

  p = new PedalButton[5];
  p[0] = new PedalButton(0+100*0, height-150, false, "PITCHFORK");
  p[1] = new PedalButton(0+100*1, height-150, false, "DELAY");
  p[2] = new PedalButton(0+100*2, height-150, false, "PHASER");

  //setup pedals
  vol1 = new Pedal(width-250, 350, 49, 250, "LEFT VOLUME");
  vol2 = new Pedal(width-50, 350, 49, 250, "RIGHT VOLUME");
  pitchshift = new Pedal(width-150, 350, 49, 250, "PITCHSHIFT");

  //tone selector setup
  //ts = new ToneSelector(5*width/6, 50, 5);

  textSize(80);
  textAlign(LEFT, TOP);
  text("WET DREAM II", 10, 0);
  //colorMode();

  //pickup position
  pickup = createShape(GROUP);
  noStroke();
  l = createShape(RECT, 0, 0, 40, 200);
  l.setFill(color(#B2B2B2));
  ellipseMode(CENTER);
  topround = createShape(ELLIPSE, 20, 0, 40, 40);
  topround.setFill(color(#B2B2B2));
  ellipseMode(CENTER);
  bottomround = createShape(ELLIPSE, 20, 200, 40, 40);
  bottomround.setFill(color(#B2B2B2));
  pickup.addChild(l);
  pickup.addChild(topround);
  pickup.addChild(bottomround);

  //initialize trem
  trem = loadShape("tremolo.svg");

  //define string positions
  for (int i = 0; i < 6; i++) {
    str_hPos[i] = 100+spacing*i+200/12;
    println(str_hPos[i]);
  }
}

//----------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------

void draw() {
  frameRate(30);
  background(255);

  for (int i = 0; i < 3; i++) {
    p[i].display(pColor[i]);
  }

  textlabel.setValue(c.toString());
  textlabel.draw(this);
  textlabel.setPosition(0, 0);

  noStroke();
  shape(pickup, 50+(6.9*width/8), -100+height/3);
  noStroke();
  shape(pickup, 50+(6.2*width/8), -100+height/3);
  noStroke();
  shape(pickup, 50+(10*width/11), -100+height/3);

  //draw fret references
  stroke(200);
  strokeWeight(2);
  line(width/2, str_hPos[0]-10, width/2, str_hPos[5]+10);
  textAlign(CENTER, BOTTOM);
  textSize(40);
  fill(200);
  text("XII", width/2, str_hPos[0]-15);

  //draw strings
  for (int i = 0; i < 6; i++) {
    stroke(127);
    strokeWeight(1);
    line(0, str_hPos[i], width, str_hPos[i]);
  }

  //arm position
  //lArmPos = (map(noise(t), 0., 1., 0, 800));
  //rArmPos = (map(noise(t+1000), 0., 1., 850, width));

  //finger pressure
  lPressure = (map(noise(t+10000), 0., 1., 50, 255));
  rPressure = (map(noise(t+100000), 0., 1., 100, 255));

  if (mousePressed) {
    fill(lPressure);
    //noStroke();
    stroke(lPressure);
    strokeWeight(2);
    quad(lArmPos, topPos, lArmPos+fingerWidth, topPos, lArmPos+fingerWidth+angle, bottomPos, lArmPos+angle, bottomPos);
    //leftArm(lArmPos);

    //rArmPos = width-lArmPos;
    fill(rPressure);
    //noStroke();
    stroke(rPressure);
    strokeWeight(2);
    quad(rArmPos, topPos, rArmPos+fingerWidth, topPos, rArmPos+fingerWidth+angle, bottomPos, rArmPos+angle, bottomPos);
    //rightArm(rArmPos);
  } else {
    //how to index and constrain to hand possibilities
    //run particle system

    if (lArmPos < 0.4*width && frameCount % 4 == 0) {
      int str = int(str_hPos[int(random(6))]);
      lhFingers.add(new Fingering(new PVector(lArmPos, str)));
      //lhFingers.add(new Tremolo(new PVector(rArmPos, str)));
      if(rateChangeR < 0.5){
        lhFingers.add(new Tremolo(new PVector(rArmPos, str)));
      }
      if(rateChangeR > 0.5 && rateChangeR < 0.9){
        lhFingers.add(new Pick(new PVector(rArmPos, str_hPos[int(random(6))])));
      }
      else{
        lhFingers.add(new Slap(new PVector(rArmPos, str_hPos[int(random(6))])));
      }
    } 
    
    if (lArmPos > 0.4*width && lArmPos < 0.92*width  && frameCount % 5 == 0) {
      lhFingers.add(new HarmonicFingering(new PVector(lArmPos, str_hPos[int(random(6))])));
      if(rateChangeR < 0.5){
        lhFingers.add(new Tremolo(new PVector(rArmPos, str_hPos[int(random(6))])));
      }
      if(rateChangeR > 0.5 && rateChangeR < 0.9){
        lhFingers.add(new Pick(new PVector(rArmPos, str_hPos[int(random(6))])));
      }
      else{
        lhFingers.add(new Slap(new PVector(rArmPos, str_hPos[int(random(6))])));
      }
    } 
    
    else if(frameCount % 4 == 0) {
      lhFingers.add(new Slap(new PVector(lArmPos, str_hPos[int(random(6))])));
      if(rateChangeR < 0.5){
        lhFingers.add(new Tremolo(new PVector(rArmPos, str_hPos[int(random(6))])));
      }
      if(rateChangeR > 0.5 && rateChangeR < 0.9){
        lhFingers.add(new Pick(new PVector(rArmPos, str_hPos[int(random(6))])));
      }
      else{
        lhFingers.add(new Slap(new PVector(rArmPos, str_hPos[int(random(6))])));
      }
    }


    //Create ArrayList Iterator - way better than for loop, don't use for loop
    Iterator<Fingering> it = lhFingers.iterator(); //aim iterator at particular arraylist
    while (it.hasNext()) {
      Fingering p = it.next();
      p.run(); //display() and update() in one function
      if (p.isDead()) {
        it.remove();
      }
    }
  }

  /*
    v1 = map(noise(t+500), 0, 1, 0, 100);
   
   v2 = map(noise(t), 0, 1, 0, 100);
   */

  //display()s
  vol1.display(v1);
  pitchshift.display(map(noise(t), 0, 1, 0, 100));
  vol2.display(v2);
  
  t += map(noise(t+10), 0, 1, 0, 0.05);
}

//----------------------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------------------

void rightArm(float _rArmPos) {
  strokeWeight(2);
  stroke(0);
  line(_rArmPos+(fingerWidth/2)+angle, -100+height/3+2, _rArmPos+(fingerWidth/2)+angle, -100+height/3+40);
  line(width, -100+2*height/3-40, _rArmPos+(fingerWidth/2)+angle, -100+2*height/3-40);
}

void leftArm(float _lArmPos) {
  strokeWeight(2);
  stroke(0);
  line(_lArmPos+(fingerWidth/2)+angle, -100+2*height/3-2, _lArmPos+(fingerWidth/2)+angle, -100+2*height/3-40);
  line(0, -100+height/3+40, _lArmPos+(fingerWidth/2)+angle, -100+height/3+40);
}

void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/guitar/hands")) {
    if (theOscMessage.checkTypetag("ffff")) {
      //println("received OSC");
      lArmPos = map(theOscMessage.get(0).floatValue(), 0, 1, 0, width-200);
      rArmPos = map(theOscMessage.get(1).floatValue(), 0, 1, width, width-400);
      rateChangeL = int(map(theOscMessage.get(3).floatValue(), 0, 1, 60, 1));
      rateChangeR = theOscMessage.get(2).floatValue();
      //return;
    }
  }
  if (theOscMessage.checkAddrPattern("/guitar/vols")) {
    if (theOscMessage.checkTypetag("ff")) {
      //println("received OSC");
      v1 = map(theOscMessage.get(0).floatValue(), 0, 1., 0, 100);
      v2 = map(theOscMessage.get(1).floatValue(), 0, 1., 0, 100);
      //return;
    }
  }
  if (theOscMessage.checkAddrPattern("/guitar/pedals")) {
    if (theOscMessage.checkTypetag("ffi")) {
      println("received OSC");
      pColor[1] = map(theOscMessage.get(0).floatValue(), 0, 1000, 255, 0);
      pColor[2] = map(theOscMessage.get(1).floatValue(), 0, 1000, 255, 0);
      pColor[0] = map(theOscMessage.get(2).intValue(), 0, 1, 255, 0);
      //return;
    }
  }
}

//treat as a reset function
//go to start of txt etc
void keyPressed() {
  if (key == ENTER) {
    c.reset();
  }
}