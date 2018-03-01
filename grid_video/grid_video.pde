
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

Enemy rightEnemy;
Enemy leftEnemy;

Player player;
ArrayList<Missile> _missiles;
int _maxMissileCount = 20;
int _lastMissileSpawn = 0; 

void moveAllMissiles() {
  for (Missile missile : _missiles) {
    missile.move();
  }
}

void drawAllMissiles() {
  for (Missile missile : _missiles) {
    missile.draw();
  }
}

void trySpawnMissile() {
  if (_missiles.size() < _maxMissileCount && abs(_lastMissileSpawn - millis()) > 1000) {
    _missiles.add(new Missile(player.x, player.y, videoScale));
    _lastMissileSpawn = millis();
  }
}


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
    10, 50, 10, 10, 
    video.pixels.length,
    videoScale);

  leftRegion = new MotionRegion(
    70, 50, 10, 10, 
    video.pixels.length,
    videoScale);
    
   leftEnemy = new Enemy(width / 2 - 40, 50, 40);
   rightEnemy = new Enemy(width / 2 + 20, 50, 40);
    player = new Player(
    35, 45, //pos
    10, 60, // max x pos
    videoScale);
    
    _missiles = new ArrayList<Missile>();
}

void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();

  video.read();
  
  // update state
  video.loadPixels();
  prevFrame.loadPixels();
  
  rightRegion.motionBetween(video, prevFrame);
  leftRegion.motionBetween(video, prevFrame);
  
  if (rightRegion.hasMoved()) {
    player.moveLeft(2);
  } else if (leftRegion.hasMoved()) {
    player.moveRight(2);
  }
  
  moveAllMissiles();
}

void draw() {
  background(0);
  
  drawAllCells();
  
  rightRegion.draw();
  leftRegion.draw();
  leftEnemy.draw();
  rightEnemy.draw();
  
  player.draw();
  trySpawnMissile();
  drawAllMissiles();
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