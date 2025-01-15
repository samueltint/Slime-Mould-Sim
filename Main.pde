ArrayList<Agent> agents = new ArrayList<Agent>();
int agentCount = 1000;


void setup() {
  size(500,500);
  background(255);
  stroke(0);
  fill(255, 10);
  for (int i = 0; i < agentCount; i++) {
    agents.add(new Agent(PVector.random2D().mult(random(100)).add(width / 2, height / 2), random(TAU)));
  }
}


void draw() {
  rect(0,0,width,height);
  for (Agent agent : agents) {
    agent.update();
    agent.display();
  }
}
