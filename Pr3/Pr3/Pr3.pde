// ...
// ...
// ...

final float SIM_STEP = 0.01;   // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

ParticleSystem _system;   // Particle system
Particle p1;
ArrayList<PlaneSection> _planes;    // Planes representing the limits
boolean _computePlaneCollisions = true;

final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1200;   // Display width (pixels)
int DISPLAY_SIZE_Y = 700;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {10, 10, 25};

void settings()
{
  size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
  // ...
  // ...
  // ...
  
  initSimulation();
}

void initSimulation()
{
  _system = new ParticleSystem(/* ???? */);
  _planes = new ArrayList<PlaneSection>();
  p1 = new Particle(_system, 1, new PVector(200, 200), new PVector(0, 0), 1, 5);
  _system.addParticle(1, new PVector(200, 200), new PVector(0, 0), 1.0, 5.0);

  // ...
  // ...
  // ...
}

void drawStaticEnvironment()
{
  plane0 = n
  fill(27, 147, 183);
  strokeWeight(2);
  rect(50, 50, 1100, 600);
}

void draw() 
{
  // ...
  // ...
  // ...
  
  drawStaticEnvironment();
    
  _system.run();
  _system.computeCollisions(_planes, _computePlaneCollisions);  
  _system.display();  

  _simTime += SIM_STEP;

  // ...
  // ...
  // ...
}

void mouseClicked() 
{
}

void keyPressed()
{
}
  
void stop()
{
}
