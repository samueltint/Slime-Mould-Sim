float speed = 1;
float sensorAngle = PI / 4;
float rotationAngle = PI / 4;
float rotationRandomness = PI / 16;
float sensorDistance = 9;
float maxDensity = 241;

class Agent {
  PVector pos;
  PVector dir;
  color species;
  
  Agent(PVector _pos, float _angle, color _species) {
    pos = _pos;
    dir = PVector.fromAngle(_angle);
    species = _species;
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
    float leftStrength = colorToPVector(leftSense).dot(colorToPVector(species));
    float centerStrength = colorToPVector(centerSense).dot(colorToPVector(species));
    float rightStrength = colorToPVector(rightSense).dot(colorToPVector(species));
    if (leftStrength > centerStrength && leftStrength > rightStrength) {
      dir.rotate( -rotationAngle);
    } else if (rightStrength > centerStrength && rightStrength > leftStrength) {
      dir.rotate(rotationAngle);
    }
    
    PVector posNext = pos.copy().add(dir.copy().mult(speed));
    if(brightness(get((int)posNext.x, (int)posNext.y)) > maxDensity){
      dir.rotate(random(TAU));
    } else {
    }
  }
  
  void move() {  
    PVector delta = dir.copy().rotate(random(-rotationRandomness / 2, rotationRandomness / 2)).mult(speed);
    
    //check walls
    PVector posFromCenter = pos.copy().add(delta).sub(lPadding + wallRadius, tPadding + wallRadius);
    if(posFromCenter.mag() > wallRadius){
      PVector normal = posFromCenter.copy().normalize().mult(-1);
      dir.sub(normal.copy().mult(2 * dir.copy().dot(normal.copy())));

    }
    pos.add(delta);
  }
  
  void display() {
    strokeWeight(1);
    stroke(species);
    point(pos.x, pos.y);
  }
}

PVector colorToPVector(color c) {
  float r = red(c);
  float g = green(c);
  float b = blue(c);
  return new PVector(r, g, b);
}
