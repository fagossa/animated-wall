class Enemy {
  private float x1,  y1, w;
  private float level = 0;
  private float h = 100;
  
  public Enemy(float x1, float y1, float w) {
    this.x1 = x1;
    this.y1 = y1;
    this.w = w;
  }
  
  void draw() {
    color colorForeground = color(0, 138, 253);
    color colorBackground = color(0, 0, 0);

    fill(colorBackground);
    stroke(colorBackground);

    float x2 = x1 + w;
    float x3 = x1 - w;
    
    float y2 = y1 + h;

    quad(x1, y1,
      x2, y1,
      x1, y2,
      x3, y2);

    fill(colorForeground);
    stroke(colorForeground);
    
    float fillRatio = level / 100;

    float xFillEnd1 = x2 - (w * fillRatio);
    float xFillEnd2 = xFillEnd1 - w;
    
    float yFillEnd = y1 + (h * fillRatio);

    quad(
      x1, y1,
      x2, y1,
      xFillEnd1, yFillEnd,
      xFillEnd2, yFillEnd
    );
    
    if (level < 100)
      level += 1;
  }
}