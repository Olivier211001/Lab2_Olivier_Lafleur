class Rectangle {
  float x, y, w, h, heading;
  
  Rectangle(float _x, float _y, float _w, float _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }
  
  Boolean contains(Rectangle _r) {
    Boolean result = false;
    
    if (x <= _r.x && ((x + w) >= (_r.x + _r.w)) && y <= _r.y && ((y + h) >= (_r.y + _r.h))) {
      result = true;
    }
    
    return result;
  }
  
  float left () {return x-(w/2);}
  float top () {return y-(h/2);}
  float right () {return x + (w/2);}
  float bottom () {return y +(h/2);}
  
  Boolean intersect(Rectangle _r) {
    Boolean result = false;
    
    if (!(this.left() > _r.right() ||
        this.right() < _r.left() ||
        this.top() > _r.bottom() ||
        this.bottom() < _r.top())) {
      result = true;
    }
        
    return result;
  }
   
  void display() {
    pushMatrix();
    translate (x, y);
    rotate(heading);
    rect(0-(w/2), 0-(h/2), w, h);
    popMatrix();
  }
}
