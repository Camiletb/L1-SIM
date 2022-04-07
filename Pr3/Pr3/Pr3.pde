// ...
// ...
// ...

final float SIM_STEP = 0.01;   // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)

ParticleSystem _system;   // Particle system
ArrayList<PlaneSection> _planes;    // Planes representing the limits
boolean _computePlaneCollisions = true;

// ...
// ...
// ...

void settings()
{
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

  // ...
  // ...
  // ...
}

void drawStaticEnvironment()
{
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
