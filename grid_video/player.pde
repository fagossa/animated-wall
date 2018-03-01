class Player {
  
  private int x, y;

  private int videoScale;
  private int minx, maxx;
  private PShape plane;
  
  public Player(int x,int y, int minx, int maxx, int videoScale) {
    this.x=x;
    this.y=y;
    this.minx=minx;
    this.maxx=maxx;
    this.videoScale = videoScale;
    this.loadPlane();
  }
  
  private void loadPlane(){
    plane=loadShape("warplane.svg");
  }
  
  void moveLeft(int delta) {
    int newx = this.x - delta;
    this.x = newx > minx ? newx : this.x ;
  }
  
  void moveRight(int delta) {
    int newx = this.x + delta;
    this.x = newx < maxx? newx: this.x;
  }
  
  void draw() {
    color c = color(255, 0, 0);
    
    fill(c);
    stroke(0);
  
    shape(plane,x*videoScale,y*videoScale-20,15*videoScale,15*videoScale);
  }
  
}