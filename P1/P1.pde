// Authors: 
// ...
// ...

// Problem description:
// ...
// ...
// ...

// Differential equations:
// ...
// ...
// ...

// Definitions:

enum IntegratorType 
{
  NONE,
  EXPLICIT_EULER, 
  SIMPLECTIC_EULER, 
  HEUN, 
  RK2, 
  RK4
}

// Parameters of the numerical integration:

final boolean REAL_TIME = true;
final float SIM_STEP = 0.01;   // Simulation time-step (s)
IntegratorType _integrator = IntegratorType.EXPLICIT_EULER;   // ODE integration method

// Display values:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)

// Draw values:

final int [] BACKGROUND_COLOR = {200, 200, 255};
final int [] REFERENCE_COLOR = {0, 255, 0};
final int [] OBJECTS_COLOR = {255, 0, 0};
final float OBJECTS_SIZE = 1.0;   // Size of the objects (m)
final float PIXELS_PER_METER = 20.0;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m)

// Parameters of the problem:

final float M = 1.0;   // Particle mass (kg)
final float Gc = 9.801;   // Gravity constant (m/(s*s))
final PVector G = new PVector(0.0, -Gc);   // Acceleration due to gravity (m/(s*s))
final float C2 = -200; //Altura del muelle C2 
final float C1 = 200; //Longitud al muelle C1
final float h = C2; //altura del triángulo
final float w = C1; //base del triángulo
final float K_e1=0;
final float l_01=0;
final float K_e2=0;
final float l_02=0;
final float theta=atan2(C2, C1);
//final float K_d, mu;
  //K_d=0;
  //mu=0;

// ...
// ...
// ...
// ...
// ...


// Time control:

int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;   // Simulated time (s)
float _elapsedTime = 0.0;   // Elapsed (real) time (s)

// Output control:

PrintWriter _output;
final String FILE_NAME = "data.txt";

// Auxiliary variables:

float _energy;   // Total energy of the particle (J)

// Variables to be solved:

PVector _s = new PVector();   // Position of the particle (m)
PVector _v = new PVector(0, 0);   // Velocity of the particle (m/s)
PVector _a = new PVector(0, 0);   // Accleration of the particle (m/(s*s))


// Main code:

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

void drawStaticEnvironment()
{
  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);

  textSize(20);
  text("Sim. Step = " + SIM_STEP + " (Real Time = " + REAL_TIME + ")", width*0.025, height*0.075);  
  text("Integrator = " + _integrator, width*0.025, height*0.1);
  text("Energy = " + _energy + " J", width*0.025, height*0.125);
  
  fill(REFERENCE_COLOR[0], REFERENCE_COLOR[1], REFERENCE_COLOR[2]);
  strokeWeight(1);

  PVector screenPos = new PVector();
  worldToScreen(new PVector(), screenPos);
  circle(screenPos.x, screenPos.y, 20);
  line(screenPos.x, screenPos.y, screenPos.x + DISPLAY_SIZE_X, screenPos.y);
  line(screenPos.x, screenPos.y, screenPos.x, screenPos.y - DISPLAY_SIZE_Y);
  //C2 y C1
  circle(screenPos.x, screenPos.y + C2, 20); //Muelle 2
  fill(150);
  circle(screenPos.x + C1, screenPos.y, 20); //Muelle 1
  //Pendiente
  line(screenPos.x, screenPos.y + C2, screenPos.x + C1, screenPos.y);
}

void drawMovingElements()
{
  fill(OBJECTS_COLOR[0], OBJECTS_COLOR[1], OBJECTS_COLOR[2]);
  strokeWeight(1);

  PVector screenPos = new PVector();
  worldToScreen(_s, screenPos);
  //Partícula
  float yp = screenPos.y + C2/2; //Luego tenemos que poder cambiar P1 y P2 (h y w)
  float xp = screenPos.x + C1/2;
  _s.y = screenPos.y + C2/2;
  _s.x = screenPos.x + C1/2;
  circle(_s.x, _s.y, worldToPixels(OBJECTS_SIZE)); // Luego la posición cambiará
  line(w/2, h/2, _s.x, _s.y);
  line(screenPos.x, screenPos.y + C2, xp, yp);
  line(xp,  yp, screenPos.x + C1, screenPos.y);
}

void PrintInfo()
{
  println("Energy: " + _energy + " J");
  println("Elapsed time = " + _elapsedTime + " s");
  println("Simulated time = " + _simTime + " s \n");
}

void initSimulation()
{
  _simTime = 0.0;
  _elapsedTime = 0.0;
  
  // ...
  // ...
  // ...
}

void updateSimulation()
{
  switch (_integrator)
  {
  case EXPLICIT_EULER:
    updateSimulationExplicitEuler();
    break;

  case SIMPLECTIC_EULER:
    updateSimulationSimplecticEuler();
    break;

  case HEUN:
    updateSimulationHeun();
    break;

  case RK2:
    updateSimulationRK2();
    break;

  case RK4:
    updateSimulationRK4();
    break;
  }
  
  _simTime += SIM_STEP;
}

void updateSimulationExplicitEuler()
{
  _a = calculateAcceleration(_s, _v);
  _s.add(PVector.mult(_v, SIM_STEP)); //dt = SIM_STEP
  _v.add(PVector.mult(_a, SIM_STEP));
  
  // ...
  // ... use calculateAcceleration()
  // ...
}

void updateSimulationSimplecticEuler()
{
  // ...
  // ... use calculateAcceleration()
  // ...
}

void updateSimulationHeun()
{
  // ...
  // ... use calculateAcceleration()
  // ...
}

void updateSimulationRK2()
{
  // ...
  // ... use calculateAcceleration()
  // ...
}

void updateSimulationRK4()
{
  // ...
  // ... use calculateAcceleration()
  // ...
}

PVector calculateAcceleration(PVector s, PVector v)
{
  PVector a = new PVector(0, 0);
  
  PVector screenPos = new PVector();
  worldToScreen(_s, screenPos);
  
  PVector vFe1, vFe2, vFw, vFn;
  PVector pen1, pen2, peso, normal;
  float Fe1, Fe2, Fw, Fn;

  
  /*Parámetros de fuerzas*/
  Fe1 = K_e1 * l_01;
  Fe2 = K_e2 * l_02;
  Fw = M * Gc;
  Fn = M * Gc * cos(theta);
  
  /*Vectores dirección*/
  pen1 = new PVector(w-w/2, 0-h/2);
  pen2 = new PVector(0-w/2, h-h/2);
  peso = new PVector(0, 1);
  normal = new PVector(h/2, -w/2);
  
    /*Vectores de fuerzas*/
  vFe1 = (PVector.mult((pen1), Fe1));
  vFe2 = (PVector.mult((pen2), Fe2));
  vFw = (PVector.mult((peso), Fw));
  vFn = (PVector.mult((normal), Fn));
  
  /*Sumatorio de fuerzas*/
  a.add(vFe1);
  a.add(vFe2);
  a.add(vFw);
  a.add(vFn);
  // ...
  // ...
  // ...
  return a;
}

void calculateEnergy()
{  
  // ...
  // ...
  // ...
}

void settings()
{
  if (FULL_SCREEN)
  {
    fullScreen();
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();

  initSimulation();
}

void draw()
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  println("\nDraw step = " + _deltaTimeDraw + " s - " + 1.0/_deltaTimeDraw + " Hz");

  if (REAL_TIME)
  {
    float expectedSimulatedTime = 1.0*_deltaTimeDraw;
    float expectedIterations = expectedSimulatedTime/SIM_STEP;
    int iterations = 0; 

    for (; iterations < floor(expectedIterations); iterations++)
      updateSimulation();

    if ((expectedIterations - iterations) > random(0.0, 1.0))
    {
      updateSimulation();
      iterations++;
    }

    //println("Expected Simulated Time: " + expectedSimulatedTime);
    //println("Expected Iterations: " + expectedIterations);
    //println("Iterations: " + iterations);
  } 
  else
    updateSimulation();

  drawStaticEnvironment();
  drawMovingElements();

  calculateEnergy();
  PrintInfo();
}

void mouseClicked() 
{
  // ...
  // ...
  // ...
}

void keyPressed()
{
  // ...
  // ...
  // ...
}

void stop()
{
  // ...
  // ...
  // ...  
}
