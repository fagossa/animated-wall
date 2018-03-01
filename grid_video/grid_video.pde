
import processing.video.*;

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

ArrayList<Enemy> _enemies;

Player player;
ArrayList<Missile> _missiles;
int _maxMissileCount = 4;
int _lastMissileSpawn = 0; 

void drawAllEnemies() {
  for (Enemy enemy : _enemies) {
    enemy.draw();
  }
}

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

boolean isHittingEnemy(Enemy enemy, Point point) {
  return (enemy.topRight.X >= point.X && enemy.topLeft.X <= point.X && enemy.bottomRight.Y >= point.Y);
}

void checkHitboxes() {
  ArrayList<Missile> toRemove = new ArrayList<Missile>();
  // Check missiles hitboxes
  for (Missile missile : _missiles) {
    if (missile.Top.Y <= 0) {
      toRemove.add(missile);
      continue;
    }
    for (Enemy enemy : _enemies) {
      if (isHittingEnemy(enemy, missile.Top)) {
        enemy.onHit();
        toRemove.add(missile);
        continue;
      }
    }
  }
  
  // Remove all missiles that hit
  for (Missile missile : toRemove) {
    _missiles.remove(missile);
  }
}

// ----
void setup() {
  size(640, 480);

  // Initialize columns and rows
  cols = width/videoScale;
  rows = height/videoScale;

  video = new Capture(this, 80, 60);
  color c = color(255, 255, 255);
  tint(c,0);
  
  videoMirror = new PImage(video.width,video.height);
  
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
    
    _enemies = new ArrayList<Enemy>();
    _enemies.add(new Enemy(width / 2 - 40, 50, 40));
    _enemies.add(new Enemy(width / 2 + 20, 50, 40));
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
  updateVideo(video,videoMirror);
  prevFrame.loadPixels();

 
  
  rightRegion.motionBetween(video, prevFrame);
  leftRegion.motionBetween(video, prevFrame);
  
  if (rightRegion.hasMoved()) {
    player.moveRight(2);
  } else if (leftRegion.hasMoved()) {
    player.moveLeft(2);
  }
  
  checkHitboxes();
  moveAllMissiles();
}

void draw() {
  background(0);
  
  drawAllCells();
  
  rightRegion.draw();
  leftRegion.draw();
  drawAllEnemies();
  
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
  color c = videoMirror.pixels[i + j * videoMirror.width];
  
  fill(c);
  stroke(0);
  rect(x, y, videoScale, videoScale);
}

void updateVideo(Capture video,PImage videoMirror){
   video.loadPixels();
  //Mirroring the video
  for(int x = 0; x < video.width; x++){
    for(int y = 0; y < video.height; y++){
      videoMirror.pixels[x+y*video.width] = video.pixels[(video.width-(x+1))+y*video.width];
    }
  }
  videoMirror.updatePixels();
  image(videoMirror,0,0);
}