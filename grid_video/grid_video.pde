
import processing.video.*;
import processing.sound.*;

// Size of each cell in the grid, ratio of window size to video size
// 80 * 8 = 640
// 60 * 8 = 480
int videoScale = 8;

// Number of columns and rows in our system
int cols, rows;
Capture video;
PImage videoMirror;

ParticleSystem ps;
int nbParticules = 200;

// Previous Frame
PImage prevFrame;

MotionRegion rightRegion;
MotionRegion leftRegion;
EntitiesManager game;

// ----
void setup() {
  size(640, 480);

  // Initialize columns and rows
  cols = width/videoScale;
  rows = height/videoScale;

  video = new Capture(this, 80, 60);
  video.start();
  
  // Create an empty image the same size as the video
  videoMirror = createImage(video.width, video.height, RGB);
  prevFrame   = createImage(video.width, video.height, RGB);
  
  leftRegion = new MotionRegion(
    10, 50, 10, 10, 
    video.pixels.length,
    videoScale);

  rightRegion = new MotionRegion(
    70, 50, 10, 10, 
    video.pixels.length,
    videoScale);

  game = new EntitiesManager(
    new SoundFile(this, "end-game.mp3"), 
    new SoundFile(this, "explosion.mp3"),
    new SoundFile(this, "hit.mp3"));
  game.setup();
}

void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(videoMirror, 0, 0, videoMirror.width, videoMirror.height, 0, 0, videoMirror.width, videoMirror.height);
  prevFrame.updatePixels();
  
  // capture frames
  video.read();
  flipVideo(video, videoMirror);// flip video
 
  // calculate motion
  rightRegion.motionBetween(videoMirror, prevFrame);
  leftRegion.motionBetween(videoMirror, prevFrame);
  
  if (rightRegion.hasMoved()) {
    game.Player.moveRight(2);
  } else if (leftRegion.hasMoved()) {
    game.Player.moveLeft(2);
  }
  game.checkEndGame();
}

void flipVideo(Capture video, PImage videoMirror) {
  video.loadPixels();
  for(int x = 0; x < video.width; x++){
    for(int y = 0; y < video.height; y++){
      videoMirror.pixels[x + y * video.width] = video.pixels[(video.width - (x + 1)) + y * video.width];
    }
  }
  videoMirror.updatePixels();
}

// Game reset
void keyPressed() {
  if (key == 'n') {
      game.setup();
  }
}

void draw() {
  drawAllCells();
  fill(0,120); 
  rect(0,0,640,480);
  rightRegion.draw();
  leftRegion.draw();
  
  game.draw();
}

void drawAllCells() {
  for (int i = 0; i < cols; i++) { // columns
    for (int j = 0; j < rows; j++) { // rows
      drawCell(i, j);
    }
  }
}

void drawCell(int i, int j) {
  int x = i*videoScale;
  int y = j*videoScale;

  color c = videoMirror.pixels[i + j * videoMirror.width];
  
  fill(c);
  stroke(1);
  rect(x, y, videoScale, videoScale);
}