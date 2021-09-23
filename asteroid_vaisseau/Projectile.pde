class Projectile extends GraphicObject {
  boolean isVisible = false;
  
  Projectile () {
    super();
    rectangle = new Rectangle(location.x,location.y,3,3);
  }
  
  void activate() {
    isVisible = true;
  }
  
  void setDirection(PVector v) {
    velocity = v;
  }
  
   public boolean isCollided(Rectangle rectV)
  {
    if(rectangle.intersect(rectV) == true)
    {
      return true;
    }
    return false;
  }
  void update(float deltaTime) {
    
    if (!isVisible) return;
    
    super.update();
    
    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) {
      isVisible = false;
    }
    
    rectangle.x = location.x;
    rectangle.y = location.y;
  }
  void reset()
  {
    isVisible = false;
  }
  void display() {
    
    if (isVisible) {
      pushMatrix();
        translate (location.x, location.y);
        fill(200);
        ellipse (0, 0, 3, 3);
      popMatrix();
    }
  }
}
