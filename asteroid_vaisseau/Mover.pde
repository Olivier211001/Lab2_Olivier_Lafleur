class Mover extends GraphicObject {
  float topSpeed = 2;
  float topSteer = 0.03;
  boolean isVisible;
  float mass = 1;
  
  float theta = 0;
  float r = 10; // Rayon du boid
  
  float radiusSeparation = 10 * r;
  float radiusAlignment = 20 * r;

  float weightSeparation = 1.5;
  float weightAlignment = 1;
  
  PVector steer;
  PVector sum;

  boolean debug = false;
  String debugMessage = "";
  int msgCount = 0;
  
  Mover () {
    location = new PVector();
    velocity = new PVector();
    acceleration = new PVector();
  }
 
  Mover (PVector loc, PVector vel) {
    this.location = loc;
    this.velocity = vel;
    this.acceleration = new PVector (0 , 0);
    rectangle = new Rectangle(location.x-r, location.y-r,r*2,(r*4));
    isVisible = true;
  }
  
  void checkEdges() {
    if (location.x < 0) {
      location.x = width - r;
    } else if (location.x + r> width) {
      location.x = 0;
    }
    
    if (location.y < 0) {
      location.y = height - r;
    } else if (location.y + r> height) {
      location.y = 0;
    }
  }
  public boolean isCollided(Rectangle rectV)
  {
    if(rectangle.intersect(rectV) == true)
    {
      return true;
    }
    return false;
  }
  void flock (ArrayList<Mover> boids) {
    PVector separation = separate(boids);
    PVector alignment = align(boids);
    
    separation.mult(weightSeparation);
    alignment.mult(weightSeparation);

    applyForce(separation);
    applyForce(alignment);
  }
  
  
  void update(float deltaTime) {
    checkEdges();
    
    velocity.add (acceleration);

    velocity.limit(topSpeed);

    location.add (velocity);

    acceleration.mult (0);      
    
    rectangle.x = location.x;
    rectangle.y = location.y;
  }
  
  void display() {
    noStroke();
    fill (fillColor);
    
    theta = velocity.heading() + radians(90);
    
    pushMatrix();
    translate(location.x, location.y);
    rotate (theta);
    
    beginShape(TRIANGLES);
      vertex(0, -r * 2);
      vertex(-r, r * 2);
      vertex(r, r * 2);
    
    endShape();
    
    popMatrix();
    rectangle.heading = theta;
    //rectangle.display();
  }
  
  PVector separate (ArrayList<Mover> boids) {
    if (steer == null) {
      steer = new PVector(0, 0, 0);
    }
    else {
      steer.setMag(0);
    }
    
    int count = 0;
    
    for (Mover other : boids) {
      float d = PVector.dist(location, other.location);
      
      if (d > 0 && d < radiusSeparation) {
        PVector diff = PVector.sub(location, other.location);
        
        diff.normalize();
        diff.div(d);
        
        steer.add(diff);
        
        count++;
      }
    }
    
    if (count > 0) {
      steer.div(count);
    }
    
    if (steer.mag() > 0) {
      steer.setMag(topSpeed);
      steer.sub(velocity);
      steer.limit(topSteer);
    }
    
    return steer;
  }

  PVector align (ArrayList<Mover> boids) {

    if (sum == null) {
      sum = new PVector();      
    } else {
      sum.mult(0);

    }

    int count = 0;

    for (Mover other : boids) {
      float d = PVector.dist(this.location, other.location);

      if (d > 0 && d < radiusAlignment) {
        sum.add(other.velocity);
        count++;
      }
    }

    if (count > 0) {
      sum.div((float)count);
      sum.setMag(topSpeed);


      PVector steer = PVector.sub(sum, this.velocity);
      steer.limit(topSteer);

      return steer;
    } else {
      return new PVector();
    }
      
    
  }
  
  void applyForce (PVector force) {
    PVector f;
    
    if (mass != 1)
      f = PVector.div (force, mass);
    else
      f = force;
   
    this.acceleration.add(f);    
  }
}
  
