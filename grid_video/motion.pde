
float[] motionBetween(Capture video, PImage prevFrame) {
  float[] numbers = new float[video.pixels.length];
  for (int i = 0; i < video.pixels.length; i ++ ) {
    numbers[i] = motionAt(i, video, prevFrame);
  }
  return numbers;
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