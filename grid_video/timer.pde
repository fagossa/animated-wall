class Timer {
  
  private Point position;
  private int startTime;
  private int endTime;
  
  Timer(Point position) {
    this.position = position;
  }
  
  void start() {
    startTime = millis();
    endTime = 0;
  }
  
  void stop() {
    endTime = millis();
  }

  void draw() {
    int currentTime = (endTime > 0 ? endTime : millis()) - startTime;
    
    int nbSeconds = currentTime / 1000;
    int nbMillis = currentTime - nbSeconds * 1000;
    
    String text = nf(nbSeconds, 2) + "." + nf(nbMillis, 3);

    fill(0);
    stroke(0);
    textSize(32);
    text(text, position.X, position.Y); 
  }


}