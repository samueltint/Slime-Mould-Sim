class Source {
  PVector pos;
  int size;
  
  Source(PVector _pos, int _size) {
    pos = _pos;
    size = _size;
  }
  
  void display() {
    strokeWeight(size);
    point(pos.x, pos.y);
  }
}
