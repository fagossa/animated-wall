
class MotionRegion {

  private int x1,  y1,  w,  h;
  private float[] motions;
  private int videoScale;
  
  private float threshold = 20; // How different must a pixel be to be a "motion" pixel
  private boolean moved = false;
  
  public MotionRegion(int x1, int y1, int w, int h, int pixelsAmt, int videoScale) {
    this.x1 = x1;
    this.y1 = y1;
    this.w = w;
    this.h = h;
    this.motions = new float[pixelsAmt];
    this.videoScale = videoScale;
  }
  
  void motionBetween(PImage currFrame, PImage prevFrame) {
    double motionAmount = 0;
    for (int i = x1; i < x1 + w; i++) { // columns
      for (int j = y1; j < y1 + h; j++) { // rows
        int k = k(i, j, currFrame);
        motions[k] = motionAt(k, currFrame, prevFrame);
        motionAmount += motions[k(i, j, currFrame)];
      }
    }
    //println(motionAmount);
    this.moved = motionAmount / (w * h) > threshold;
  }
  
  float motionAt(int k, PImage video, PImage prevFrame) {
    // Step 2, what is the current color
    color current = video.pixels[k];
  
    // Step 3, what is the previous color
    color previous = prevFrame.pixels[k];
  
    // Step 4, compare colors (previous vs. current)
    float r1 = red(current);
    float g1 = green(current);
    float b1 = blue(current);
    
    float r2 = red(previous);
    float g2 = green(previous);
    float b2 = blue(previous);
  
    // Motion for an individual pixel is the difference between the previous color and current color.
    return dist(
      r1, g1, b1, 
      r2, g2, b2);
  }
  
  int k(int i, int j, PImage img) {
    return i + (j * img.width);
  }
  
  boolean hasMoved() {
    return moved;
  }
 
  void draw() {
    color c = moved ? color(255, 255, 255) : color(0, 0, 0);
    
    fill(c);
    stroke(0);
  
    ellipse(
      x1 * videoScale, 
      y1 * videoScale, 
      w * videoScale, 
      h * videoScale
    );
    
    fill(color(255, 0, 0));
  }
}

void printArr(float[] numbers) {
  for (int i = 0; i < video.pixels.length; i ++ ) {
    print(numbers[i] + " ");
  }
  println(" ------------ ");
}