class Missile{
  
  public HitResult hitResult;
  public Point Top;
  public Point Right;
  public Point Bottom;
  public Point Left;
  private float YspeedFactor = 4;
  private float XspeedFactor;
  private int _videoScale;
  private boolean _hasRebounded;
  
  public Missile(float x, float y, int videoScale) {
    _videoScale = videoScale;
    x *= _videoScale;
    y *= _videoScale;
    Top = new Point(x, y - 20);
    Right = new Point(x + 10, y - 10);
    Bottom = new Point(x, y);
    Left = new Point(x - 10, y - 10);
  }
  
  void rebound() {
    _hasRebounded = true;
    XspeedFactor = random(-4,4);
    YspeedFactor = random(2,4);
  }

  void move() {
    if (_hasRebounded) {
      this.Top.Y += YspeedFactor * _videoScale;
      this.Right.Y += YspeedFactor * _videoScale;
      this.Bottom.Y += YspeedFactor * _videoScale;
      this.Left.Y += YspeedFactor * _videoScale;
      this.Top.X += XspeedFactor * _videoScale;
      this.Right.X += XspeedFactor * _videoScale;
      this.Bottom.X += XspeedFactor * _videoScale;
      this.Left.X += XspeedFactor * _videoScale;
    }
    else {
      this.Top.Y -= YspeedFactor * _videoScale;
      this.Right.Y -= YspeedFactor * _videoScale;
      this.Bottom.Y -= YspeedFactor * _videoScale;
      this.Left.Y -= YspeedFactor * _videoScale;
    }
  }
  
  boolean missedTarget() {
    return this.Top.Y <= 0 || 
      this.Top.X <= 0 || 
      this.Top.X >= width || 
      this.Top.Y >= height;
  }
  
  boolean hasHit() {
    return this.hitResult != null && this.hitResult.HitPoint.Y >= this.Top.Y;
  }
  
  void draw() {
    fill(0, 138, 253);
    quad(Top.X, Top.Y, Right.X, Right.Y, Bottom.X, Bottom.Y, Left.X, Left.Y);
  }
}