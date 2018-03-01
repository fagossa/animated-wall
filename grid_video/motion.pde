
class MotionRegion {

  private int x1,  y1,  w,  h;
  private float[] motions;
  private int videoScale;
  
  private float threshold = 15; // How different must a pixel be to be a "motion" pixel
  private boolean moved = false;
  
  public MotionRegion(int x1, int y1, int w, int h, int pixelsAmt, int videoScale) {
    this.x1 = x1;
    this.y1 = y1;
    this.w = w;
    this.h = h;
    this.motions = new float[pixelsAmt];
    this.videoScale = videoScale;
  }
  
  void motionBetween(Capture video, PImage prevFrame) {    
    for (int i = x1; i < w; i++) { // columns
      for (int j = y1; j < h; j++) { // rows
        int k = i + j * video.width;
        motions[k] = motionAt(k, video, prevFrame);
      }
    }
    
    int motionAmount = 0;
    for (int i = 0; i < cols; i++) { // columns
      for (int j = 0; j < rows; j++) { // rows
        motionAmount += hasChanged(i, j, video) ? 1 : 0;
      }
    }
    //print(motionAmount);
    this.moved = motionAmount > 0;
  }
  
  float motionAt(int i, Capture video, PImage prevFrame) {
    // Step 2, what is the current color
    color current = video.pixels[i];
  
    // Step 3, what is the previous color
    color previous = prevFrame.pixels[i];
  
    // Step 4, compare colors (previous vs. current)
    float r1 = red(current);
    float g1 = green(current);
    float b1 = blue(current);
    float r2 = red(previous);
    float g2 = green(previous);
    float b2 = blue(previous);
  
    // Motion for an individual pixel is the difference between the previous color and current color.
    return dist(r1, g1, b1, r2, g2, b2);
  }
  
  boolean hasChanged(int i, int j, Capture video) {
    return (motions[i + j * video.width] > threshold);
  }
 
  void draw() {
    color c = moved ? color(255, 255, 255) : color(0, 0, 0);
    
    fill(c);
    stroke(0);
  
    rect(
      x1 * videoScale, 
      y1 * videoScale, 
      w * videoScale, 
      h * videoScale
    );
  }
}

void printArr(float[] numbers) {
  for (int i = 0; i < video.pixels.length; i ++ ) {
    print(numbers[i] + " ");
  }
}