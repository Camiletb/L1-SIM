// ...
// ...
// ...

final float SIM_STEP = 0.01;   // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)
int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)

ParticleSystem _system;   // Particle system
ArrayList<PlaneSection> _planes;    // Planes representing the limits
boolean _computePlaneCollisions = true;

final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1500;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1200;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {10, 10, 25};

final float PIXELS_PER_METER = 300;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m
int tam = 2000; //Numero de particulas
boolean puerta = false;

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
  initSimulation();
}

void initSimulation()
{
  _system = new ParticleSystem();
  _planes = new ArrayList<PlaneSection>();

  _planes.add(new PlaneSection(1450, 30, 50, 30, false));
  _planes.add(new PlaneSection(50, 30, 200, 400,false));
  _planes.add(new PlaneSection(1250, 400, 1450, 30,true));
  _planes.add(new PlaneSection(200, 400, 350, 450, false)); //Izquierda abajo
  _planes.add(new PlaneSection(1250, 400, 1450, 300, false)); //Derecha abajo
  _planes.add(new PlaneSection(650, 680, 850, 680, false)); //Horizontal abajo
  
}

void drawStaticEnvironment()
{
  fill(0);
  textSize(20);
  
  for(PlaneSection p : _planes)
      p.draw();
  
}

void printInfo(){

}


void draw() 
{
  drawStaticEnvironment();
    
  _system.run();
  _system.computeCollisions(_planes, _computePlaneCollisions);  
  _system.display();  

  _simTime += SIM_STEP;

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
