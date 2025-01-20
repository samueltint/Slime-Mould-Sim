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
  
  void sense() {
    // sense in three direction in front of the agent
    PVector left = pos.copy().add(dir.copy().rotate( -sensorAngle).mult(sensorDistance));
    PVector center = pos.copy().add(dir.copy().mult(sensorDistance));
    PVector right = pos.copy().add(dir.copy().rotate(sensorAngle).mult(sensorDistance));
    
    // decide the next travel direction
    color leftSense = get((int)left.x,(int)left.y);
    color centerSense = get((int)center.x,(int)center.y);
    color rightSense = get((int)right.x,(int)right.y);
    decide(leftSense, centerSense, rightSense);
  }
  
  void decide(color leftSense, color centerSense, color rightSense){
    //by default an agent will turn towards brighter pixels 
    float leftStrength = brightness(leftSense);
    float centerStrength = brightness(centerSense);
    float rightStrength = brightness(rightSense);
    if (leftStrength > centerStrength && leftStrength > rightStrength) {
      dir.rotate( -rotationAngle);
    } else if (rightStrength > centerStrength && rightStrength > leftStrength) {
      dir.rotate(rotationAngle);
    }
  }
  
  void move() {  
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
    stroke(#ffffff);
    point(pos.x, pos.y);
  }
}

class RedAgent extends Agent {    
  RedAgent(PVector _pos, float _angle) {
    super(_pos, _angle);
  }
  
  @Override
  void display() {
    strokeWeight(1);
    stroke(#ff0000);
    point(pos.x, pos.y);
  }
}

class BlueAgent extends Agent {    
  BlueAgent(PVector _pos, float _angle) {
    super(_pos, _angle);
  }
  
  @Override
  void decide(color leftSense, color centerSense, color rightSense){
    float leftBlue = blue(leftSense);
    float centerBlue = blue(centerSense);
    float rightBlue = blue(rightSense);
    
    float leftRed = red(leftSense);
    float centerRed = red(centerSense);
    float rightRed = red(rightSense);
    
    if (leftBlue > centerBlue && leftBlue > rightBlue && leftRed < leftBlue) {
      dir.rotate( -rotationAngle);
    } else if (rightBlue > centerBlue && rightBlue > leftBlue && rightRed < rightBlue) {
      dir.rotate(rotationAngle);
    }
  }
  
  @Override
  void display() {
    strokeWeight(1);
    stroke(#0000ff);
    point(pos.x, pos.y);
  }
}
