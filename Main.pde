ArrayList<Agent> agents = new ArrayList<Agent>();
int agentCount = 5000;
int spawnRadius = 300;

// blur
float v = 1.0 / 9.0;
float[][] kernel = {{ v, v, v } ,
                    { v, v, v } ,
                    { v, v, v } };

void setup() {
  //size(500,500);
  fullScreen();
  background(0);
  stroke(255);
  for (int i = 0; i < agentCount; i++) {
    agents.add(new Agent(PVector.random2D().mult(random(spawnRadius)).add(width / 2, height / 2), random(TAU)));
  }
}


void draw() {
  loadPixels();
  
  PImage blurImg = createImage(width, height, RGB);
  // Loop through every pixel in the image
  for (int y = 1; y < height - 1; y++) {
    for (int x = 1; x < width - 1; x++) {
      float sumRed = 0;   // Kernel sums for this pixel
      float sumGreen = 0;
      float sumBlue = 0;
      for (int ky = -1; ky <= 1; ky++) {
        for (int kx = -1; kx <= 1; kx++) {
          //Calculate the adjacent pixel for this kernel point
          int pos = (y + ky) * width + (x + kx);
          
          //Process each channel separately, Red first.
          float valRed = red(pixels[pos]);
          //Multiply adjacent pixels based on the kernel values
          sumRed += kernel[ky + 1][kx + 1] * valRed;
          
          //Green
          float valGreen = green(pixels[pos]);
          sumGreen += kernel[ky + 1][kx + 1] * valGreen;
          
          //Blue
          float valBlue = blue(pixels[pos]);
          sumBlue += kernel[ky + 1][kx + 1] * valBlue;
        }
      }
      //For this pixel in the new image, set the output value
      //based on the sum from the kernel
      blurImg.pixels[y * blurImg.width + x] = color(sumRed, sumGreen, sumBlue);
      
    }
  }
  //State that there are changes to blurImg.pixels[]
  blurImg.updatePixels();
  
  image(blurImg, 0, 0); // Draw the new image
  for (Agent agent : agents) {
    agent.update();
    agent.display();
  }
}
