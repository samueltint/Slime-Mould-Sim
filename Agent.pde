float speed = 1;
float sensorAngle = PI / 4;
float rotationAngle = PI / 4;
float rotationRandomness = PI / 16;
float sensorDistance = 9;

class Agent {
  PVector pos;
  PVector dir;
  
  Agent(PVector _pos, float _angle) {
    pos = _pos;
    dir = PVector.fromAngle(_angle);
  }
  
  void update() {
    // sense in three direction in front of the agent
    PVector left = pos.copy().add(dir.copy().rotate( -sensorAngle).mult(sensorDistance));
    PVector center = pos.copy().add(dir.copy().mult(sensorDistance));
    PVector right = pos.copy().add(dir.copy().rotate(sensorAngle).mult(sensorDistance));
    
    //debug sensor positions
    //stroke(#ff0000);
    //point(left.x, left.y);    
    //stroke(#00ff00);
    //point(center.x, center.y);    
    //stroke(#0000ff);
    //point(right.x, right.y);
    //stroke(0);
    
    // decide the next travel direction
    float leftSense = brightness(get((int)left.x,(int)left.y));
    float centerSense = brightness(get((int)center.x,(int)center.y));
    float rightSense = brightness(get((int)right.x,(int)right.y));
    if (leftSense > centerSense && leftSense > rightSense) {
      dir.rotate( -rotationAngle);
    } else if (rightSense > centerSense && rightSense > leftSense) {
      dir.rotate(rotationAngle);
    }
    
    PVector delta = dir.copy().rotate(random(-rotationRandomness / 2, rotationRandomness / 2)).mult(speed);
    
    //check walls
    if (pos.x + delta.x > width - padding || pos.x + delta.x < padding) {
      delta.x *= -1;
      dir.x *= -1;
    }
    if (pos.y + delta.y > height - padding || pos.y + delta.y < padding) {
      delta.y *= -1;
      dir.y *= -1;
    }
    
    pos.add(delta);
  }
  
  void display() {
    strokeWeight(1);
    point(pos.x, pos.y);
  }
}
