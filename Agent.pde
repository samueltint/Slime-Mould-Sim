class Agent {
  PVector pos;
  PVector dir;
  float speed = 2;
  
  Agent(PVector _pos, float _angle) {
    pos = _pos;
    dir = PVector.fromAngle(_angle);
  }
  
  void update() {
    PVector delta = dir.copy().mult(speed);
    //check walls
    if (pos.x + delta.x > width || pos.x + delta.x < 0) {
      delta.x *= -1;
      dir.x *= -1;
    }
    if (pos.y + delta.y > width || pos.y + delta.y < 0) {
      delta.y *= -1;
      dir.y *= -1;
    }
    pos.add(delta);
  }
  
  void display() {
    point(pos.x, pos.y);
  }
}
