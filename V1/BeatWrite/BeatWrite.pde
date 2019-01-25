/**
  * This sketch demonstrates how to use the BeatDetect object in FREQ_ENERGY mode.<br />
  * You can use <code>isKick</code>, <code>isSnare</code>, </code>isHat</code>, <code>isRange</code>, 
  * and <code>isOnset(int)</code> to track whatever kind of beats you are looking to track, they will report 
  * true or false based on the state of the analysis. To "tick" the analysis you must call <code>detect</code> 
  * with successive buffers of audio. You can do this inside of <code>draw</code>, but you are likely to miss some 
  * audio buffers if you do this. The sketch implements an <code>AudioListener</code> called <code>BeatListener</code> 
  * so that it can call <code>detect</code> on every buffer of audio processed by the system without repeating a buffer 
  * or missing one.
  * <p>
  * This sketch plays an entire song so it may be a little slow to load.
  */

import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Arduino arduino;

int motorPin1 = 13;
int motorPin2 = 12;
int motorPin3 = 11;
int motorPin4 = 10;
int motorPin5 = 9;
int motorPin6 = 8;

//int builtLED = 16;

float kickSize, snareSize, hatSize;

void setup() {
  size(512, 200, P3D);
  
  minim = new Minim(this);
  printArray(Arduino.list());

  arduino = new Arduino(this, "/dev/cu.usbmodem14301", 57600);
  //arduino = new Arduino(this, "/dev/cu.HC-05-DevB", 9600);
  // arduino = new Arduino(this, Arduino.list()[1], 57600);
  
  song = minim.loadFile("Bluesette.mp3", 2048);
  song.play();
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  beat.setSensitivity(500);    // originally 500  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
 
  //arduino.pinMode(builtLED, Arduino.OUTPUT); 
 
  arduino.pinMode(motorPin1, Arduino.OUTPUT);
  arduino.pinMode(motorPin2, Arduino.OUTPUT);
  arduino.pinMode(motorPin3, Arduino.OUTPUT);
  arduino.pinMode(motorPin4, Arduino.OUTPUT);
  arduino.pinMode(motorPin5, Arduino.OUTPUT);
  arduino.pinMode(motorPin6, Arduino.OUTPUT);
  
  //String portName = Serial.list()[1];
  // myPort = new Serial(this, portName, 9600);

}

void draw() {
background(0);
  fill(255);
  if(beat.isHat()) {
      arduino.digitalWrite(motorPin1, Arduino.HIGH);   // set the LED on
      arduino.digitalWrite(motorPin2, Arduino.HIGH);   // set the LED on
       
      hatSize = 32;
    //   arduino.digitalWrite(builtLED, Arduino.HIGH);
      
  }
  
  if(beat.isSnare() ) {
      // println("I'm on!");
      arduino.digitalWrite(motorPin3, Arduino.HIGH);   // set the LED on
      arduino.digitalWrite(motorPin4, Arduino.HIGH);   // set the LED on
      snareSize = 32;
        
      //println("Snare detected");
      printArray(Arduino.list());
        
       
  }
  if(beat.isKick()) {
      arduino.digitalWrite(motorPin5, Arduino.HIGH);   // set the LED on
      arduino.digitalWrite(motorPin6, Arduino.HIGH);   // set the LED on
      kickSize = 32;
  }
  
  if (hatSize <= 22)
  {
    arduino.digitalWrite(motorPin1, Arduino.LOW); 
    arduino.digitalWrite(motorPin2, Arduino.LOW); 
    hatSize =16;
  }
 if (snareSize <= 22)
  {
    arduino.digitalWrite(motorPin3, Arduino.LOW); 
    arduino.digitalWrite(motorPin4, Arduino.LOW); 
    snareSize =16;
  }
  if (kickSize <= 22)
  {
    arduino.digitalWrite(motorPin5, Arduino.LOW); 
    arduino.digitalWrite(motorPin6, Arduino.LOW); 
    kickSize =16;
  }
  
  textSize(kickSize);
  text("KICK", width/4, height/2);
  textSize(snareSize);
  text("SNARE", width/2, height/2);
  textSize(hatSize);
  text("HAT", 3*width/4, height/2);
  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
}

void stop() {
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}
