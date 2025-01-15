class Agent {
  PVector pos;
  float dir;
  float speed = 1;
  
  Agent(PVector _pos, float _dir) {
    pos = _pos;
    dir = _dir;
  }
  
  void update() {
    PVector delta = PVector.fromAngle(dir).mult(speed);
    pos.add(delta);
    println(pos);
  }
  
  void display() {
    point(pos.x, pos.y);
  }
}
