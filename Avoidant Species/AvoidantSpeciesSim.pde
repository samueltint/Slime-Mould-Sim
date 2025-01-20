ArrayList<Agent> agents = new ArrayList<Agent>();
float populationPercentage = 0.3;
int agentSpawnRadius = 75;

int wallRadius = 100;
int padding = 10;

float decay = 0.99;
int blurSize = 1;
color[] speciesList = {#00ff00, #ff0000, #0000ff};

void settings() {
  size((wallRadius + padding) * 2, (wallRadius + padding) * 2);
}

void setup() {
  background(0);
  stroke(255);
  int population = 0;
  while (population < (wallRadius * wallRadius * PI) * populationPercentage) {
    for(color species : speciesList){
      agents.add(new Agent(PVector.random2D().mult(random(agentSpawnRadius)).add(width / 2, height / 2), random(TAU), species));
      population++;
    }
  }
  print(population);
}


void draw() {
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
  
  for (Agent agent : agents) {
    agent.sense();
  }
  for (Agent agent : agents) {
    agent.move();
  }
  for (Agent agent : agents) {
    agent.display();
  }

  //println(frameRate);
}
    
    
