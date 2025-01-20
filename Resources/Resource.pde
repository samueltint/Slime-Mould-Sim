class Resource {
  PVector pos;
  int size;
  
  Resource(PVector _pos, int _size) {
    pos = _pos;
    size = _size;
  }
  
  void display() {
    strokeWeight(size);
    stroke(#ffffff);
    point(pos.x, pos.y);
  }
}
