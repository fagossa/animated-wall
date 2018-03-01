class Missile{

  public Missile(float x, float y, int videoScale) {
    _videoScale = videoScale;
    x *= _videoScale;
    y *= _videoScale;
    Top = new Point(x, y - 40);
    Right = new Point(x + 10, y - 10);
    Bottom = new Point(x, y);
    Left = new Point(x - 10, y - 10);
  }

  
  public Point Top;
  public Point Right;
  public Point Bottom;
  public Point Left;
  private int speedFactor = 2;
  private int _videoScale;
  
  void move() {
    this.Top.Y -= speedFactor * _videoScale;
    this.Right.Y -= speedFactor * _videoScale;
    this.Bottom.Y -= speedFactor * _videoScale;
    this.Left.Y -= speedFactor * _videoScale;
  }
  
  void draw() {
    fill(0, 138, 253);
    quad(Top.X, Top.Y, Right.X, Right.Y, Bottom.X, Bottom.Y, Left.X, Left.Y);
  }
}