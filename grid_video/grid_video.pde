
import processing.video.*;

// Size of each cell in the grid, ratio of window size to video size
// 80 * 8 = 640
// 60 * 8 = 480
int videoScale = 8;

// Number of columns and rows in our system
int cols, rows;
Capture video;

// Previous Frame
PImage prevFrame;

MotionRegion rightRegion;
MotionRegion leftRegion;

// ----
void setup() {
  size(640, 480);

  // Initialize columns and rows
  cols = width/videoScale;
  rows = height/videoScale;

  video = new Capture(this, 80, 60);
  video.start();

  // Create an empty image the same size as the video
  prevFrame = createImage(video.width, video.height, RGB);
  
  rightRegion = new MotionRegion(
    10, 40, 10, 10, 
    video.pixels.length,
    videoScale);

  leftRegion = new MotionRegion(
    60, 40, 10, 10, 
    video.pixels.length,
    videoScale);
}

void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();

  video.read();
}

void draw() {
  background(0);
  drawGrid();
}

void drawGrid() {
  //image(video, 0, 0); // You don't need to display it to analyze it!

  video.loadPixels();
  prevFrame.loadPixels();
  
  drawAllCells();
  
  rightRegion.motionBetween(video, prevFrame);
  leftRegion.motionBetween(video, prevFrame);
  
  rightRegion.draw();
  leftRegion.draw();
}

void drawAllCells() {
  rightRegion.motionBetween(video, prevFrame);
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

  // Looking up the appropriate color in the pixel array
  color c = video.pixels[i + j * video.width];
  
  fill(c);
  stroke(0);
  rect(x, y, videoScale, videoScale);
}