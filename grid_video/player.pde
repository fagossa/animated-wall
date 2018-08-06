class Player {
  
  private int x, y;

  private int videoScale;
  private int minx, maxx;
  
  private int old_x, old_y;
 
  private PShape plane;
  private int shapeWidth;
  private int shapeHeight;
  
  public Player(int x,int y, int minx, int maxx, int videoScale) {
    this.x=x;
    this.y=y;
 
    this.old_x = x;
    this.old_y = y;
    
    this.minx=minx;
    this.maxx=maxx;
    this.videoScale = videoScale;
    this.loadPlane();
  }
  
  private void loadPlane(){
    plane=loadShape("warplane.svg");
    this.shapeWidth=200*videoScale;
    this.shapeHeight=200*videoScale;
    this.maxx=this.maxx + this.shapeWidth/(2*videoScale);
  }
  
  void moveLeft(int delta) {
    int newx = this.x - delta;
    this.x = newx > minx ? newx : this.x ;
  }
  
  void moveRight(int delta) {
    int newx = this.x + delta;
    this.x = newx < maxx? newx: this.x;
  }
  
  void reset() {
   this.x = old_x;
   this.y = old_y;
  }
 
  void draw() {
    int xHead=(x*videoScale)-this.shapeWidth/2;
    shape(plane,xHead,y*videoScale-20,this.shapeWidth,this.shapeHeight);
  }
  
}
