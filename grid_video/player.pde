class Player {
  
  private int x, y;

  private int w = 10;
  private int h = 10;
  private int videoScale;
  
  private int minx, maxx;
  
  public Player(int x,int y, int minx, int maxx, int videoScale) {
    this.x=x;
    this.y=y;
    this.minx=minx;
    this.maxx=maxx;
    this.videoScale = videoScale;
  }
  
  void moveLeft(int delta) {
    int newx = this.x - delta;
    this.x = newx > minx ? newx : this.x;
  }
  
  void moveRight(int delta) {
    int newx = this.x + delta;
    this.x = newx < maxx ? newx : this.x;
  }
  
  void draw() {
    color c = color(255, 0, 0);
    
    fill(c);
    stroke(0);
  
    rect(
      x * videoScale,
      y * videoScale,
      w * videoScale,
      h * videoScale
    );
  }
  
}