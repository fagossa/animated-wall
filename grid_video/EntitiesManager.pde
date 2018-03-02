class EntitiesManager {
  
  public Player Player;
  public ArrayList<Enemy> Enemies;
  public ArrayList<Missile> Missiles;
  private int _maxMissileCount = 4;
  private int _lastMissileSpawn;
  private SoundFile endGameSound;
  private boolean gameOver = false;

  public EntitiesManager(SoundFile endGameSound) {
      this.endGameSound = endGameSound;
      Enemies = new ArrayList<Enemy>();
  }
  
  public void setup() {
    _lastMissileSpawn = 0;
    
    Enemies.clear();
    Enemies.add(new Enemy(width / 2 - 40, 50, 40));
    Enemies.add(new Enemy(width / 2 + 20, 50, 40));
    
    Player = new Player(
      10, 45, //pos
      10, 60, // max x pos
      videoScale);
  
    Missiles = new ArrayList<Missile>();
    
    gameOver = false;
  }
  
  void checkEndGame() {
    int count = 0;
    for (Enemy enemy : Enemies) {
      count += enemy.isFull() ? 1 : 0;
    }
    if (count == Enemies.size()) {
      gameOver = true;
      //endGameSound.play();
    }
  }
  
  void draw() {
    Player.draw();
    drawAllEnemies();
    
    if (!gameOver) {
      spawnAndMoveMissiles();
      drawAllMissiles();
    }
  }
  
  private void spawnAndMoveMissiles() {
    trySpawnMissile();
    moveAllMissiles();
    checkHitboxes();
  }

  private void drawAllEnemies() {
    for (Enemy enemy : Enemies) {
      enemy.draw();
    }
  }
  
  private void drawAllMissiles() {
    for (Missile missile : Missiles) {
      missile.draw();
    }
  }
  
  private void moveAllMissiles() {
    for (Missile missile : Missiles) {
      missile.move();
    }
  }
  
  private void trySpawnMissile() {
    if (Missiles.size() < _maxMissileCount && abs(_lastMissileSpawn - millis()) > 1000) {
      Missiles.add(new Missile(Player.x, Player.y, videoScale));
      _lastMissileSpawn = millis();
    }
  }
  
  private void checkHitboxes() {
    ArrayList<Missile> toRemove = new ArrayList<Missile>();
    // Check missiles hitboxes
    for (Missile missile : Missiles) {
      if (missile.Top.Y <= 0) {
        toRemove.add(missile);
        continue;
      }
      for (Enemy enemy : Enemies) {
        if (enemy.isHittingEnemy(missile.Top)) {
          enemy.onHit();
          toRemove.add(missile);
        }
      }
    }
    
    // Remove all missiles that hit
    for (Missile missile : toRemove) {
      Missiles.remove(missile);
    }
  }
}