class Timer {
  
  private int initTimeout = 25 * 1000;
  private int scoreMax = 100000;
  private int scoreMin = 1000;
  
  private Point position;
  private int previousTime;  
  private int timeout;
  
  private boolean isStop;
  
  Timer(Point position) {
    this.position = position;
  }
  
  void start() {
    previousTime = millis();
    timeout = initTimeout;
    isStop = false;
  }
  
  void stop() {
    updateTimeout();
    isStop = true;
  }
  
  int score() {
    int rate = ((scoreMax - scoreMin * 5) / initTimeout);
    return timeout > 0 ? scoreMax - (initTimeout - timeout) * rate : scoreMin;
  }
  
  boolean isOver() {
    return timeout <= 0;
  }
  
  void updateTimeout() {
    
    if (!isStop) {
      int newTime = millis();
      int diff = newTime - previousTime;
      previousTime = newTime;
      timeout -= diff;
      if (timeout < 0)
        timeout = 0;
    }
  }

  void draw() {
    updateTimeout();
    
    int nbSeconds = timeout / 1000;
    int nbMillis = timeout - nbSeconds * 1000;
    
    String text = nf(nbSeconds, 2) + "." + nf(nbMillis, 3);
    
    fill(255,255,255);
    rect(this.position.X, this.position.Y, 91, 28, 6); 

    fill(0);
    if (timeout <= 5000)
      fill(255, 0, 0);
    textSize(24);
    text(text, position.X + 4, position.Y + 23); 
  }


}
