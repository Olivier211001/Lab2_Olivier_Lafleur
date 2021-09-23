int currentTime;
int previousTime;
int deltaTime;
int maxBullets = 6;
boolean saveVideo = false;
ArrayList<Projectile> bullets;
ArrayList<Mover> flock;
int flockSize;
int level = 1;
int score = 0;
boolean scoreIncrease = false;
boolean isCollided;
boolean collidePaM;
int nbVisible;
Vaisseau v;

void setup () {
  size (900, 700);
  currentTime = millis();
  previousTime = millis();
  flockSize = 20;
  v = new Vaisseau();
  v.location.x = width / 2;
  v.location.y = height / 2;
  bullets = new ArrayList<Projectile>();
  nbVisible = 0;
  flock = new ArrayList<Mover>();
  scoreIncrease = false;
  flock();
}

void draw () {
  currentTime = millis();
  deltaTime = currentTime - previousTime;
  previousTime = currentTime;

  
  update(deltaTime);
  display();
 
  savingFrames(5, deltaTime);  
  
}

PVector thrusters = new PVector(0, -0.02);

/***
  The calculations should go here
*/
void update(int delta) {
 if(v.life > 0)
 {
  if (keyPressed) {
    switch (key) {
      case ' ':
        v.thrust();
        break;
      case 'a' :
        v.pivote(-.03);
        break;
      case 'd' :
        v.pivote(.03);
        break;
      //case 'r':
      //  v.reset();
      //  resetGame();
      //  break;
      case 's':
        fire(v);
        break;
    }
  }
 }
  nbVisible = 0;
  for ( Projectile p : bullets) {
    p.update(delta);
    for(Mover m : flock)
    {
        collidePaM = false;
        if(m.isVisible == true)
        {
          collidePaM = p.isCollided(m.rectangle);
        }
        if(collidePaM == true)
        {
          m.isVisible = false;
          score ++; 
         
        }
     
    }
  }
  for (Mover m : flock) {
    m.flock(flock);
    m.update(delta);
    isCollided = false;
    if(m.isVisible == true)
    {
      isCollided = m.isCollided(v.rectangle);
       nbVisible ++;
    }
    if(isCollided == true)
    {
      m.isVisible = false;
      v.life --;
    }
  }
  if(nbVisible == 0)
  {
    LevelUp();
  }
  v.update(delta);
  verifyScore();
}

/***
  The rendering should go here
*/
void keyPressed()
{
  if(key == 'r')
  {
    v.reset();
    resetGame();
  }
}
void verifyScore()
{
  if(score % 5 != 0)
  {
    scoreIncrease = true;
  }
  if(score % 5 == 0 && scoreIncrease == true)
  {
    v.life ++;
    scoreIncrease = false;
  }
}

void display () {
  if(v.life <= 0)
  {
    background(0);
    fill(255);
    textSize(50);
    text("Game Over",350,350);
  }
  else
  {
    background(0);
    fill(255);
    textSize(30);
    text("Life: " + v.life,width-86,40);
    fill(255);
    textSize(30);
    text("Level : " + level,380,40);
    fill(255);
    textSize(30);
    text("score : " + score,50,40);
    pushMatrix();
    for ( Projectile p : bullets) {
      p.display();
    }
    for (Mover m : flock) {
      if(m.isVisible == true)
      {
        m.display();
      }
    }
    v.display();
    popMatrix();
  }
}

void LevelUp()
{
  flock.clear();
  level += 1;
  v.velocity.x = 0;
  v.velocity.y = 0;
  v.location.x = 450;
  v.location.y = 350;
  flockSize += 20;
  flock();
}

void flock()
{  
  for (int i = 0; i < flockSize; i++) {
    //int xrand = (int)random(0,4);

    Mover m = new Mover(new PVector(height,width), new PVector(random (-2, 2), random(-2, 2)));
    m.fillColor = color(255, 204, 0);
    flock.add(m);
  }
}
//Saving frames for video
//Put saveVideo to true;
int savingAcc = 0;
int nbFrames = 0;

void savingFrames(int forMS, int deltaTime) {
  
  if (!saveVideo) return;
  
  savingAcc += deltaTime;
  
  if (savingAcc < forMS) {
    saveFrame("frames/####.tiff");
	nbFrames++;
  } else {
	println("Saving frames done! " + nbFrames + " saved");
    saveVideo = false;
  }
}

void keyReleased() {
    switch (key) {
      case ' ':
        v.noThrust();
        break;
    }  
}
void resetGame()
{
  setup();
  level = 1;
  score = 0;
  flock.clear();
  v.reset();
  flock();
}
void fire (GraphicObject m)
{
 
   Vaisseau v = (Vaisseau)m;
  
   if (bullets.size() < maxBullets) {
    Projectile p = new Projectile();
    
    p.location = v.getVaisseauTip().copy();
    p.topSpeed = 10;
    p.velocity = v.getShootingVector().copy().mult(p.topSpeed);
   
    p.activate();
    
    bullets.add(p);
  } else {
    for ( Projectile p : bullets) {
      if (!p.isVisible) {
        p.location.x = v.getVaisseauTip().x;
        p.location.y = v.getVaisseauTip().y;
        p.velocity.x =v.getShootingVector().x;
        p.velocity.y =v.getShootingVector().y;
        p.velocity.mult(p.topSpeed);
        p.activate();
        break;
      }
    }
  }
}
