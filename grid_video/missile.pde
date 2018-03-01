class Missile{

  public Missile(float x, float y, int videoScale) {
    _videoScale = videoScale;
    x *= _videoScale;
    y *= _videoScale;
    _top = new Point(x, y - 40);
    _right = new Point(x + 10, y - 10);
    _bottom = new Point(x, y);
    _left = new Point(x - 10, y - 10);
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
  private int _videoScale;
  
  void move() {
    this._top.Y -= speedFactor * _videoScale;
    this._right.Y -= speedFactor * _videoScale;
    this._bottom.Y -= speedFactor * _videoScale;
    this._left.Y -= speedFactor * _videoScale;
  }
  
  void draw() {
    fill(0, 138, 253);
    quad(_top.X, _top.Y, _right.X, _right.Y, _bottom.X, _bottom.Y, _left.X, _left.Y);
  }
}