
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

// Previous Frame
PImage prevFrame;

MotionRegion rightRegion;
MotionRegion leftRegion;
EntitiesManager _entitiesManager;

Timer timer;

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

   _entitiesManager = new EntitiesManager(new SoundFile(this, "end-game.mp3"));
   _entitiesManager.setup();
   
   timer = new Timer(new Point(width - 120, 30));
   timer.start();
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
    _entitiesManager.Player.moveRight(2);
  } else if (leftRegion.hasMoved()) {
    _entitiesManager.Player.moveLeft(2);
  }
  _entitiesManager.checkEndGame();
}

void flipVideo(Capture video, PImage videoMirror) {
   video.loadPixels();
  //Mirroring the video
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
      _entitiesManager.setup();
      timer.start();
  }
}

void draw() {
  background(0);
  
  drawAllCells();
  rightRegion.draw();
  leftRegion.draw();
  
  _entitiesManager.draw();
  timer.draw();
}

void drawAllCells() {
  for (int i = 0; i < cols; i++) { // columns
    for (int j = 0; j < rows; j++) { // rows
      drawCell(i, j);
    }
  }
}

// Scaling up to draw a rectangle at (x,y)
void drawCell(int i, int j) {
  int x = i*videoScale;
  int y = j*videoScale;

  // looking up the appropriate color in the pixel array
  color c = videoMirror.pixels[i + j * videoMirror.width];
  
  fill(c);
  stroke(0);
  rect(x, y, videoScale, videoScale);
}