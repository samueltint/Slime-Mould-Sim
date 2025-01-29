import controlP5.*;
ControlP5 cp5;

boolean runSim = true;

ArrayList<Agent> agents = new ArrayList<Agent>();
ArrayList<Resource> resources = new ArrayList<Resource>();
int maxAgents = 30000;

int wallRadius = 100;
int lPadding = 10;
int rPadding = 200;
int tPadding = 10;
int bPadding = 10;

float decay = 0.95;
int blurSize = 1;

float brushRadius = 10;
float brushStrength = 10;
color brushColor = #ff0000;

void settings() {
  size((wallRadius * 2 + lPadding + rPadding), (wallRadius * 2 + tPadding + bPadding));
}

void setup() {
  ellipseMode(RADIUS);
  background(0);
  stroke(255);
  cp5 = new ControlP5(this);
  cp5.addButton("play")
    .setLabel("Play/Pause")
    .setPosition((lPadding + wallRadius) * 2, 20)
    .setSize(100, 30);
  
  cp5.addButton("redBrush")
    .setLabel("Add Red Agents")
    .setPosition((lPadding + wallRadius) * 2, 60)
    .setSize(100, 20);
     
  cp5.addButton("greenBrush")
    .setLabel("Add Green Agents")
    .setPosition((lPadding + wallRadius) * 2, 90)
    .setSize(100, 20);
   
  cp5.addButton("blueBrush")
    .setLabel("Add Blue Agents")
    .setPosition((lPadding + wallRadius) * 2, 120)
    .setSize(100, 20);
}


void draw() {
  if(runSim){
    loadPixels();
    
    float[] tempRed = new float[width * height];
    float[] tempGreen = new float[width * height];
    float[] tempBlue = new float[width * height];
    
    float[] partialBlurRed = new float[width * height];
    float[] partialBlurGreen = new float[width * height];
    float[] partialBlurBlue = new float[width * height];
    
    // Copy pixel colors to temp arrays
    for (int i = 0; i < pixels.length; i++) {
      color c = pixels[i];
      tempRed[i] = red(c);
      tempGreen[i] = green(c);
      tempBlue[i] = blue(c);
    }
    
    // Apply horizontal blur
    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        PVector pixelPos = new PVector(x, y);
        PVector center = new PVector(lPadding + wallRadius, tPadding + wallRadius);
    
        if (PVector.sub(pixelPos, center).mag() >= wallRadius) {
          continue; // Skip pixels outside the circular region
        }
        
        float sumRed = 0, sumGreen = 0, sumBlue = 0;
        int count = 0;
        
        for (int k = -blurSize; k <= blurSize; k++) {
          int xk = constrain(x + k, 0, width - 1);
          int index = y * width + xk;
          sumRed += tempRed[index];
          sumGreen += tempGreen[index];
          sumBlue += tempBlue[index];
          count++;
        }
        
        int index = y * width + x;
        partialBlurRed[index] = sumRed / count;
        partialBlurGreen[index] = sumGreen / count;
        partialBlurBlue[index] = sumBlue / count;
      }
    } 
    
    // Apply vertical blur
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        PVector pixelPos = new PVector(x, y);
        PVector center = new PVector(lPadding + wallRadius, tPadding + wallRadius);
    
        if (PVector.sub(pixelPos, center).mag() >= wallRadius) {
          continue; // Skip pixels outside the circular region
        }
        
        float sumRed = 0, sumGreen = 0, sumBlue = 0;
        int count = 0;
        
        for (int k = -blurSize; k <= blurSize; k++) {
          int yk = constrain(y + k, 0, height - 1);
          int index = yk * width + x;
          sumRed += partialBlurRed[index];
          sumGreen += partialBlurGreen[index];
          sumBlue += partialBlurBlue[index];
          count++;
        }
        
        int index = y * width + x;
        pixels[index] = color(sumRed * decay / count, sumGreen * decay / count, sumBlue * decay / count);
      }
    }
    updatePixels();
    
    for (Resource resource : resources) {
      resource.display();
    }
    for (Agent agent : agents) {
      agent.sense();
    }
    for (Agent agent : agents) {
      agent.move();
    }
    for (Agent agent : agents) {
      agent.display();
    }
  }
}

void mouseDragged(){
  if (agents.size() < maxAgents){
    for(int i = 0; i < brushStrength; i++){
      PVector offset = PVector.random2D().mult(random(brushRadius)); // Ensures uniform distribution
      PVector spawnPos = new PVector(mouseX, mouseY).add(offset);

      PVector center = new PVector(lPadding + wallRadius, tPadding + wallRadius);
      if (PVector.sub(spawnPos, center).mag() > wallRadius - 5) {
        continue;
      }
      
      agents.add(new Agent(spawnPos, random(TAU), brushColor));
    }
  }  
}

public void redBrush() {
  brushColor = #ff0000;
}

public void greenBrush() {
  brushColor = #00ff00;
}

public void blueBrush() {
  brushColor = #0000ff;
}
