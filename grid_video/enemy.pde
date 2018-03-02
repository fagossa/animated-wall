class Enemy {
  private float x1, y1, w;
  private float level = 0;
  private float h = 200;

  public Point topLeft;
  public Point topRight;
  public Point bottomLeft;
  public Point bottomRight;
  public ArrayList<Segment> segments;

  public Enemy(float x1, float y1, float w) {
    this.x1 = x1;
    this.y1 = y1;
    this.w = w;    

    topLeft = new Point(x1, y1);
    topRight = new Point(x1 + w, y1);
    bottomLeft = new Point(x1 - w, y1 + h);
    bottomRight = new Point(x1, y1 + h);
    
    segments = new ArrayList<Segment>();
    segments.add(new Segment(topLeft, topRight));
    segments.add(new Segment(topRight, bottomRight));
    segments.add(new Segment(bottomRight, bottomLeft));
    segments.add(new Segment(bottomLeft, topLeft));
  }

  void draw() {
    color colorForeground = color(0, 138, 253);
    color colorBackground = color(0, 0, 0);

    fill(colorBackground);
    stroke(colorBackground);

    quad(topLeft.X, topLeft.Y, 
      topRight.X, topRight.Y, 
      bottomRight.X, bottomRight.Y, 
      bottomLeft.X, bottomLeft.Y);

    // On hit
    fill(colorForeground);
    stroke(colorForeground);

    float fillRatio = level / 100;

    float xFillEnd1 = (x1 + w) - (w * fillRatio);
    float xFillEnd2 = xFillEnd1 - w;

    float yFillEnd = y1 + (h * fillRatio);

    quad(
      x1, y1, 
      x1 + w, y1, 
      xFillEnd1, yFillEnd, 
      xFillEnd2, yFillEnd
      );
  }

  void reset() {
    level = 0;
  }

  boolean isFull() {
    return this.level >= 100;
  }

  void onHit() {
    if (level <100)
      level += 20;
  }

  boolean isHittingEnemy(Point point) {
    return (this.topRight.X >= point.X && this.bottomLeft.X <= point.X && this.bottomRight.Y >= point.Y);
  }
}