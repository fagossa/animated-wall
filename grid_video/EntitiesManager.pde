class EntitiesManager {
  
  public Player Player;
  public ArrayList<Enemy> Enemies;
  public ArrayList<Missile> Missiles;
  private int _maxMissileCount = 4;
  private int _lastMissileSpawn; 

  public EntitiesManager() {
  }
  
  public void InitializeEntities() {
    _lastMissileSpawn = 0;
    Enemies = new ArrayList<Enemy>();
    Enemies.add(new Enemy(width / 2 - 40, 50, 40));
    Enemies.add(new Enemy(width / 2 + 20, 50, 40));
    
    Player = new Player(
      10, 45, //pos
      10, 60, // max x pos
      videoScale);
  
    Missiles = new ArrayList<Missile>();
  }
  
  public void DrawPlayer() {
    Player.draw();
  }
  
  public void SpawnAndMoveMissiles() {
    trySpawnMissile();
    moveAllMissiles();
    checkHitboxes();
  }

  public void DrawAllEnemies() {
    for (Enemy enemy : Enemies) {
      enemy.draw();
    }
  }
  
  public void DrawAllMissiles() {
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