class Enemy {
  private int x1,  y1, w1;
  
  public Enemy(int x1, int y1, int w1) {
    this.x1 = x1;
    this.y1 = y1;
    this.w1 = w1;
  }
  
  void draw() {
    pushMatrix();

    fill(0, 138, 253);
    stroke(0, 138, 253);

    quad(x1, y1,
    x1 + w1, y1,
    x1 , y1 + 100,
    x1 - w1, y1 + 100);

    popMatrix();
  }
}