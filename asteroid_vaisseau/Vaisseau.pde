class Vaisseau extends GraphicObject {
  float angularVelocity = 0.0;
  float angularAcceleration = 0.0;
  float shootingAngle = QUARTER_PI;
  float angle = 0.0;  
  float heading = 0.0;
  
  float w = 20;
  float h = 10;
  // pour location du top du vaisseau
  // x = cos(heading - HALF_PI) * size + location.x;
  //y = sin (même chose que en haut)
  // pour debugger ellipse(v.getTip().x , v.getTip().y , 10,10)
  
  float mass = 1.0;
  
  float speedLimit = 5;
  boolean thrusting = false;
  
  PVector vaisseauTip = new PVector();
  PVector shootingVector = new PVector();
  
  int life = 3;
  
  Vaisseau() {
    initValues();
  }
  
  void initValues() {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
    rectangle = new Rectangle(location.x, location.y, size*2, size*2);
  }
  
  PVector getVaisseauTip() {   
  
    vaisseauTip.x = cos(heading - HALF_PI) * size + location.x;
    vaisseauTip.y = sin(heading - HALF_PI) * size + location.y;
    return vaisseauTip;    
  }
  
  PVector getShootingVector() {

     return shootingVector;
  }
  

  
  void applyForce (PVector force) {
    PVector f;
    
    if (mass != 1)
      f = PVector.div (force, mass);
    else
      f = force;
   
    this.acceleration.add(f);
  }
  
  void checkEdges() {
    if (location.x < -size) location.x = width + size;
    if (location.y < -size) location.y = height + size;
    if (location.x > width + size) location.x = -size;
    if (location.y > height + size) location.y = -size;
  }
  
  void thrust(){
    float angle = heading - PI/2;
    
    PVector force = new PVector (cos(angle), sin(angle));
    force.mult(0.1);
    
    applyForce(force);
    
    thrusting = true;    
  }
  
  void update(float deltaTime) {
    checkEdges();
    shootingVector.y = cos(heading+PI);
    shootingVector.x = sin(heading);
    shootingVector.normalize();
    velocity.add(acceleration);
    
    velocity.limit(speedLimit);
    
    location.add(velocity);
    
    acceleration.mult(0);
    
    angularVelocity += angularAcceleration;
    angle += angularVelocity;
    
    angularAcceleration = 0.0;
    
    rectangle.x = location.x;
    rectangle.y = location.y;
    
  }
  
  float size = 20;
  
  float spawnDistance = size * 5;
  
  public float SpawnX()
  {
    float x;
    float cote = random(0,1);
    if(cote < 0.5)
    {
      x = (random(0,(location.x - spawnDistance)));
    }
    else
    {
       x = (random((location.x + spawnDistance ),width));
    }
    return x;
  }
   
  public float SpawnY()
  {
    float y;
    float cote = random(0,1);
    if(cote < 0.5)
    {
       y = (random(0,(location.y - spawnDistance)));
    }
    else
    {
       y = (random((location.y + spawnDistance ),height));
    }
    return y;
  }
  
  void display() {
    pushMatrix();
      translate (location.x, location.y);
      rotate (heading);
      
      //fill(200);
      //noStroke();
      fill(255,200,200);
      beginShape(TRIANGLES);
        vertex(0, -size);
        vertex(size, size);
        vertex(-size, size);
      endShape();
      fill(200);
      if (thrusting) {
        fill(200, 0, 0);
      }
   
      noStroke();
      rect(-size + (size/4), size, size / 2, size / 2);
      rect(size - ((size/4) + size/2), size, size / 2, size / 2);
      
    popMatrix();
    rectangle.heading = heading;
    //rectangle.display();
  }
  
  void pivote(float angle) {
    heading += angle;
    // code pour mouvment de l'angle de tire du vaisseau
    if(angle > 0)
    {
      shootingAngle += angle;
    }
    else
    {
      shootingAngle += -angle;
    }
    // X et Y sont inverses
    // Calcul du bout du canon
   
  }
  
  void noThrust() {
    thrusting = false;
  }
  
  void reset()
  {
    angularVelocity = 0.0;
    angularAcceleration = 0.0;
    angle = 0.0;  
    heading = 0.0;
    w = 20;
    h = 10;
    thrusting = false;
    acceleration.x = 0;
    acceleration.y = 0;
    velocity.x = 0;
    velocity.y = 0;
    location.x = 450;
    location.y = 350;
    life = 3;
  }
}
