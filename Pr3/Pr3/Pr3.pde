// ...
// ...
// ...

final float SIM_STEP = 0.01;   // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)
int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)

ParticleSystem _system;   // Particle system
Particle p1;
ArrayList<PlaneSection> _planes;    // Planes representing the limits
boolean _computePlaneCollisions = true;

final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1200;   // Display width (pixels)
int DISPLAY_SIZE_Y = 700;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {10, 10, 25};


final float PIXELS_PER_METER = 300;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m
Boolean randMov;


// Converts distances from world length to pixel length
float worldToPixels(float dist)
{
  return dist*PIXELS_PER_METER;
}

// Converts distances from pixel length to world length
float pixelsToWorld(float dist)
{
  return dist/PIXELS_PER_METER;
}

// Converts a point from world coordinates to screen coordinates
void worldToScreen(PVector worldPos, PVector screenPos)
{
  screenPos.x = 0.5*DISPLAY_SIZE_X + (worldPos.x - DISPLAY_CENTER.x)*PIXELS_PER_METER;
  screenPos.y = 0.5*DISPLAY_SIZE_Y - (worldPos.y - DISPLAY_CENTER.y)*PIXELS_PER_METER;
}

// Converts a point from screen coordinates to world coordinates
void screenToWorld(PVector screenPos, PVector worldPos)
{
  worldPos.x = ((screenPos.x - 0.5*DISPLAY_SIZE_X)/PIXELS_PER_METER) + DISPLAY_CENTER.x;
  worldPos.y = ((0.5*DISPLAY_SIZE_Y - screenPos.y)/PIXELS_PER_METER) + DISPLAY_CENTER.y;
}

void settings()
{
  size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
  fill(35,68,78);
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();
  
  //initSimulation();
  randMov = false;
  initSimulation();
}

void initSimulation()
{
  _system = new ParticleSystem(/* ???? */);
  _planes = new ArrayList<PlaneSection>();
  p1 = new Particle(_system, 1, new PVector(200, 200), new PVector(0, 0), 1, 5);
  _system.addParticle(1, new PVector(200, 200), new PVector(0, 0), 1.0, 5.0);

  //planes
  _planes.add(new PlaneSection(50, 50, 1150, 50, true)); //N
  _planes.add(new PlaneSection(1150, 50, 1150, 650, true)); //E
  _planes.add(new PlaneSection(50, 650, 1150, 650, false)); //S
  _planes.add(new PlaneSection(50, 50, 50, 650, false)); //W

  // ...
  // ...
  // ...
}

void drawStaticEnvironment()
{
  //Mesa de billar
  fill(27, 100, 150);
  strokeWeight(2);
  rect(50, 50, 1100, 600);
  
  for(int i = 0; i < _planes.size(); i++)
  {
      PlaneSection p = _planes.get(i);
      p.draw();
  }
}

void draw() 
{
  // ...
  // ...
  // ...
  
  drawStaticEnvironment();
  if(randMov){
    _system.run();
    _system.computeCollisions(_planes, _computePlaneCollisions);  
    _system.display();  
  }
  _simTime += SIM_STEP;

  // ...
  // ...
  // ...
}

void mouseClicked() 
{
  //se selecciona la bola
  //si mouseX, mouse Y coincide con el área de esa bola
}

void mouseDragged()
{
  //se usa el taco
  
}

void keyPressed()
{
  if(key=='M' || key=='m'){
    if(!randMov)
      initSimulation();
    randMov = !randMov;
  }
  if(key=='R' || key=='r'){
    initSimulation();
  }
}
  
void stop()
{
}
