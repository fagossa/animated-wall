 class EntitiesManager {

  public Player Player;
  public ArrayList<Enemy> Enemies;
  public ArrayList<Missile> Missiles;
  private int _maxMissileCount = 4;
  private int _lastMissileSpawn;
  private SoundFile endGameSound;
  private SoundFile explosionSound;
  private boolean gameOver = false;
  private Timer timer;

  public EntitiesManager(SoundFile endGameSound, SoundFile explosionSound) {
     this.endGameSound = endGameSound;
     this.explosionSound = explosionSound;
     Enemies = new ArrayList<Enemy>();

     timer = new Timer(new Point(width - 98, 5));
     timer.start();
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
    if(endGameSound.isPlaying()>0) {
      endGameSound.stop();
    }
    timer.stop();
    timer.start();

    ps = new ParticleSystem(new PVector(width/2, 50));

  }

  void checkEndGame() {
    if (!gameOver) {
      int count = 0;
      for (Enemy enemy : Enemies) {
        count += enemy.isFull() ? 1 : 0;
      }
      if (count == Enemies.size()) {
        gameOver = true;
        timer.stop();
        endGameSound.play();
        nbParticules = 200;
      }
    }
  }

  void draw() {
    Player.draw();
    drawAllEnemies();
    timer.draw();

    if (gameOver) {
      drawGameOver();
    } else {
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

  private void GetSmallestPointInList(ArrayList<HitResult> allHits, HitResult interesection) {
    for (HitResult hit : allHits) {
      if (hit.HitPoint.Y > interesection.HitPoint.Y) {
        interesection.HitPoint.X = hit.HitPoint.X;
        interesection.HitPoint.Y = hit.HitPoint.Y;
        interesection.HitEnemy = hit.HitEnemy;
      }
    }
  }

  private boolean GetIntersectionWithEnemies(Missile missile, HitResult intersection) {
    Segment missileToTop = new Segment(missile.Top, new Point (missile.Top.X, 0));
    ArrayList<HitResult> allInterectionPoints = new ArrayList<HitResult>();
    for (Enemy enemy : Enemies) {
      for (Segment enemySegment : enemy.segments) {
        Point tmpIntersection = new Point(0,0);
        if (missileToTop.GetIntersectionPoint(enemySegment, tmpIntersection)) {
          allInterectionPoints.add(new HitResult(tmpIntersection, enemy));
        }
      }
    }
    if (allInterectionPoints.size() > 0) {
      GetSmallestPointInList(allInterectionPoints, intersection);
      return true;
    }
    return false;
  }

  private void trySpawnMissile() {
    if (Missiles.size() < _maxMissileCount && abs(_lastMissileSpawn - millis()) > 1000) {
      Missile newMissile = new Missile(Player.x, Player.y, videoScale);
      HitResult intersection = new HitResult(new Point(0,0), null);
      if (GetIntersectionWithEnemies(newMissile, intersection)) {
        newMissile.hitResult = intersection;
      }
      Missiles.add(newMissile);
      _lastMissileSpawn = millis();
    }
  }

  private void checkHitboxes() {
    ArrayList<Missile> toRemove = new ArrayList<Missile>();
    // Check missiles hitboxes
    for (Missile missile : Missiles) {
      if (missile.Top.Y <= 0 || missile.Top.X <= 0 
      || missile.Top.X >= width || missile.Top.Y >= height) {
        explosionSound.play();
        toRemove.add(missile);
        continue;
      }
      if (missile.hitResult != null && missile.hitResult.HitPoint.Y >= missile.Top.Y) {
        if (missile.hitResult.HitEnemy.isFull()) {
          missile.rebound();
        }
        else {
          missile.hitResult.HitEnemy.onHit();
          explosionSound.play();
          toRemove.add(missile);
        }
      }
    }

    // Remove all missiles that hit
    for (Missile missile : toRemove) {
      Missiles.remove(missile);
    }
  }

  private void drawGameOver() {
    if (nbParticules > 0) {
      ps.addParticle();
      nbParticules--;
    }
    ps.run();

    // background
    fill(color(0, 0, 0), 100);
    rect(0, height / 2 - 65, width, 100);

    // foreground
    fill(color(255, 255, 0));
    stroke(0);
    textSize(52);
    String text = timer.score() + " points";
    int offset = text.length() * 15;
    text(text, width / 2 - offset, height / 2);
  }
}