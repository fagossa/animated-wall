class Missile{

  public Missile(float x, float y) {
    _top = new Point(x, y - 20);
    _right = new Point(x + 20, y - 10);
    _bottom = new Point(x, y);
    _left = new Point(x - 20, y - 10);
  }
  
  class Point{
    
    public Point(float x, float y) {
      X = x;
      Y = y;
    }
    public float X;
    public float Y;
  }
  
  private Point _top;
  private Point _right;
  private Point _bottom;
  private Point _left;
  private int speedFactor = 2;

  void move() {
    this._top.Y -= speedFactor;
    this._right.Y -= speedFactor;
    this._bottom.Y -= speedFactor;
    this._left.Y -= speedFactor;
  }
  
  void draw() {
    fill(0, 138, 253);
    quad(_top.X, _top.Y, _right.X, _right.Y, _bottom.X, _bottom.Y, _left.X, _left.Y);
  }
}