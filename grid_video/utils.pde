class Point{
  
  public Point(float x, float y) {
    X = x;
    Y = y;
  }
  public float X;
  public float Y;
}

// Game reset
void keyPressed() {
  if (key == 'n') {
    for (Enemy enemy : _enemies) {
      enemy.reset();
    }

    player.reset();
    timer.start();
  }
}