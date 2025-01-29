import controlP5.*;
ControlP5 cp5;

boolean runSim = true;

ArrayList<Agent> agents = new ArrayList<Agent>();
float populationPercentage = 0.6;
int agentSpawnRadius = 75;

ArrayList<Resource> resources = new ArrayList<Resource>();
int resourceCount = 0;
int resourceSize = 10;
int resourceSpawnRadius = 75;

int wallRadius = 100;
int lPadding = 10;
int rPadding = 200;
int tPadding = 10;
int bPadding = 10;

float decay = 0.95;
int blurSize = 1;

void settings() {
  size((wallRadius * 2 + lPadding + rPadding), (wallRadius * 2 + tPadding + bPadding));
}

void setup() {
  background(0);
  stroke(255);
  cp5 = new ControlP5(this);
  cp5.addButton("play")
     .setLabel("Play/Pause")
     .setPosition((lPadding + wallRadius) * 2, 20)
     .setSize(80, 30);
       
  for (int i = 0; i < (width - lPadding - rPadding ) * (height - tPadding - bPadding) * populationPercentage; i++) {
    if(random(1) > .5){
      agents.add(new Agent(PVector.random2D().mult(random(agentSpawnRadius)).add(lPadding + wallRadius, tPadding + wallRadius), random(TAU), color(255,0,0)));
    } else {
      agents.add(new Agent(PVector.random2D().mult(random(agentSpawnRadius)).add(lPadding + wallRadius, tPadding + wallRadius), random(TAU), color(0,255,0)));
    }
  }
  
  for (int i = 0; i < resourceCount; i++) {
    resources.add(new Resource(PVector.random2D().mult(random(resourceSpawnRadius)).add(width / 2, height / 2), resourceSize));
  }
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
        if (x > lPadding + wallRadius * 2 || x < lPadding || y > tPadding + wallRadius * 2 || y < tPadding) {
          continue;
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
  //println(frameRate);
}
    
public void play() {
  runSim = !runSim;
}
    
