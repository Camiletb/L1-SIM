// Authors: 
// Cam
// P
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
IntegratorType _integrator = IntegratorType.RK4;   // ODE integration method

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
//final PVector C2 = (0, -200); //Altura del muelle C2 

//final float C1 = 200; //Longitud al muelle C1


final float K_e1=10; //La força amb la que espija
final float l_01=4;//A la que li agrada estar
final float K_e2=8;
final float l_02=5;
final float theta= radians(45);
final float L = 10; //Longitut rampa
final PVector C1 = new PVector(cos(theta)* L, 0);
final PVector C2 = new PVector(0, sin(theta)* L);
final PVector s0 = new PVector((C1.x / 2),(C2.y/2));
final float Ra = 0.6; //Rozamiento aire
final float Rp = 1.6; //Rozamiento plano
boolean plano = true;
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


final float h = C2.y; //altura del triángulo
final float w = C1.x; //base del triángulo

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
  text("Plano (P): " + plano, width*0.025, height*0.15);
  
  fill(REFERENCE_COLOR[0], REFERENCE_COLOR[1], REFERENCE_COLOR[2]);
  strokeWeight(1);

  PVector screenPos = new PVector();
  worldToScreen(new PVector(), screenPos);
  //circle(screenPos.x, screenPos.y, 20);
  line(screenPos.x, screenPos.y, screenPos.x + DISPLAY_SIZE_X, screenPos.y);
  line(screenPos.x, screenPos.y, screenPos.x, screenPos.y - DISPLAY_SIZE_Y);
  //C2 y C1
  PVector c1screen = new PVector();
  PVector c2screen = new PVector();
  worldToScreen(C1, c1screen);
  worldToScreen(C2, c2screen);
  circle(c2screen.x, c2screen.y, 20); //Muelle 2
  fill(150);
  circle(c1screen.x, c1screen.y, 20); //Muelle 1
  //println(C1);
  //Pendiente
  if(plano){
    line(c1screen.x, c1screen.y, c2screen.x, c2screen.y);
  }
}

void drawMovingElements()
{
  PVector c1screen = new PVector();
  PVector c2screen = new PVector();
  worldToScreen(C1, c1screen);
  worldToScreen(C2, c2screen);
  
  fill(OBJECTS_COLOR[0], OBJECTS_COLOR[1], OBJECTS_COLOR[2]);
  strokeWeight(1);

  PVector screenPos = new PVector();
  worldToScreen(_s, screenPos);

  circle(screenPos.x, screenPos.y, worldToPixels(OBJECTS_SIZE));
  line(c2screen.x, c2screen.y, screenPos.x, screenPos.y); //Muelle
  line(c1screen.x, c1screen.y, screenPos.x, screenPos.y); //Muelle
}

void PrintInfo()
{
  println("Energy: " + _energy + " J");
  println("Elapsed time = " + _elapsedTime + " s");
  println("Simulated time = " + _simTime + " s \n");
  println("Plano (P): " + plano);
}

void initSimulation()
{
  _simTime = 0.0;
  _elapsedTime = 0.0;
  _s = s0.copy();
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
  _s.add(PVector.mult(_v, SIM_STEP));
  _v.add(PVector.mult(_a, SIM_STEP));
}

void updateSimulationSimplecticEuler()
{
  _a = calculateAcceleration(_s, _v);
  _v.add(PVector.mult(_a, SIM_STEP));
  _s.add(PVector.mult(_v, SIM_STEP));
}

void updateSimulationHeun()
{
  PVector v_promedio = new PVector();
  PVector _a2 = new PVector();
  PVector a_promedio = new PVector();

  _a = calculateAcceleration(_s, _v);

  PVector s2 = PVector.add( _s, PVector.mult(_v, SIM_STEP));
  PVector v2 = PVector.add( _v, PVector.mult(_a, SIM_STEP));

  v_promedio = PVector.mult(PVector.add(_v, v2), 0.5);
  _s.add(PVector.mult(v_promedio, SIM_STEP));


  _a2 = calculateAcceleration(s2, v2);

  a_promedio = PVector.mult(PVector.add(_a, _a2), 0.5);

  _v.add(PVector.mult(a_promedio, SIM_STEP));
}

void updateSimulationRK2()
{
  _a = calculateAcceleration(_s, _v);

  PVector k1s = PVector.mult(_v, SIM_STEP);
  PVector k1v = PVector.mult(_a, SIM_STEP);

  PVector s2 = PVector.add(_s, PVector.mult(k1s, 0.5)); //(s(t)+k1s/2)
  PVector v2 = PVector.add(_v, PVector.mult(k1v, 0.5));

  PVector a2 = calculateAcceleration (s2, v2); //aceleración al final del intervalo

  PVector k2v = PVector.mult(a2, SIM_STEP); //velocidad al final del intervalo
  PVector k2s = PVector.mult(PVector.add(_v, PVector.mult(k1v, 0.5)), SIM_STEP); //(v + k1v/2)*h

  _v.add(k2v);
  _s.add(k2s);
}

void updateSimulationRK4()
{
  _a = calculateAcceleration(_s, _v); 
  PVector k1s = PVector.mult(_v, SIM_STEP);// k1s = v(t)*h
  PVector k1v = PVector.mult(_a, SIM_STEP);// k1v = a(s(t),v(t))*h

  PVector s2  = PVector.add(_s, PVector.mult(k1s, 0.5));                         
  PVector v2  = PVector.add(_v, PVector.mult(k1v, 0.5));
  PVector a2 = calculateAcceleration(s2, v2);
  PVector k2v = PVector.mult(a2, SIM_STEP);// k2v = a(s(t)+k1s/2, v(t)+k1v/2)*h
  PVector k2s = PVector.mult(v2, SIM_STEP); // k2s = (v(t)+k1v/2)*h

  PVector s3  = PVector.add(_s, PVector.mult(k2s, 0.5));                         
  PVector v3  = PVector.add(_v, PVector.mult(k2v, 0.5));
  PVector a3 = calculateAcceleration(s3, v3);
  PVector k3v = PVector.mult(a3, SIM_STEP); // k3v = a(s(t)+k2s/2, v(t)+k2v/2)*h
  PVector k3s = PVector.mult(v3, SIM_STEP); // k3s = (v(t)+k2v/2)*h

  PVector s4  = PVector.add(_s, k3s);                         
  PVector v4  = PVector.add(_v, k3v);
  PVector a4 = calculateAcceleration(s4, v4);
  PVector k4v = PVector.mult(a4, SIM_STEP); // k4v = a(s(t)+k3s, v(t)+k3v)*h
  PVector k4s = PVector.mult(v4, SIM_STEP); // k4s = (v(t)+k3v)*h


  // v(t+h) = v(t) + (1/6)*k1v + (1/3)*k2v + (1/3)*k3v +(1/6)*k4v  
  _v.add(PVector.mult(k1v, 1/6.0));
  _v.add(PVector.mult(k2v, 1/3.0));
  _v.add(PVector.mult(k3v, 1/3.0));
  _v.add(PVector.mult(k4v, 1/6.0));

  // s(t+h) = s(t) + (1/6)*k1s + (1/3)*k2s + (1/3)*k3s +(1/6)*k4s  
  _s.add(PVector.mult(k1s, 1/6.0));
  _s.add(PVector.mult(k2s, 1/3.0));
  _s.add(PVector.mult(k3s, 1/3.0));
  _s.add(PVector.mult(k4s, 1/6.0));
}

PVector calculateAcceleration(PVector s, PVector v)
{
  PVector a = new PVector(0, 0);
  
  PVector screenPos = new PVector();
  worldToScreen(_s, screenPos);
  
  PVector vFe1, vFe2, vFw, vFn, F, vRp, vRa;
  PVector pen1, pen2, peso, normal;
  float Fe1, Fe2, Fw, Fn;

  
  /*Parámetros de fuerzas*/
  PVector L1, L2, vl1, vl2, vk1;
  float aux1, aux2;
  
  //L1 = PVector.sub(C1,_s); //ACTUAL
  aux1 = C1.copy().dist(_s);
  //L2 = PVector.sub(C2,_s); //Actual
  aux2 = C2.copy().dist(_s);
  //k_muelle * (Elongacion_actual - Elongacion_reposo)
  //Sacamos los módulos de las fuerzas elásticas
  Fe1 = K_e1 * (aux1- l_01);
  Fe2 = K_e2 * (aux2- l_02);
  //Dirección elastic.
  vFe1 = PVector.mult(C1.copy().sub(_s).normalize(), Fe1);
  vFe2 = PVector.mult(C2.copy().sub(_s).normalize(), Fe2);
  //C1-s ->lo normalizas, y ese vector lo multiplicas por la fuerza del muelle.
  
  //vl1 = PVector.mult(L1.copy().normalize(), l_01); //elongacion del muelle en reposo hecha vector
  //vl2 = PVector.mult(L2.copy().normalize(), l_02);
  
  //vFe1 = PVector.mult(PVector.sub(L1, vl1), K_e1);
  //vFe2 = PVector.mult(PVector.sub(L2, vl2), K_e2);
  
   
  
  //Fe2 = K_e2 * (L2-l_02);
  Fw = M * Gc;
  Fn = M * Gc * cos(theta); // 90

  
  
  /*Vectores dirección*/
  pen1 = new PVector(w-w/2, 0-h/2);
  pen2 = new PVector(0-w/2, h-h/2);
  normal = new PVector(h/2, w/2);
  
    /*Vectores de fuerzas*/
  //vFe1 = (PVector.mult((pen1), Fe1));
  //vFe2 = (PVector.mult((pen2), Fe2));
  vFw = G.copy();
  
  if(!plano){
    vFn=new PVector(0, 0); 
    vRp=new PVector(0, 0);
  }else{
    vFn = (PVector.mult((normal), Fn));
    vFn.setMag(Fn);
    vRp= (PVector.mult((_v.copy().normalize()), Rp));
  }
  
  //vRa = new PVector(0, 0);
  vRa= (PVector.mult((_v.copy().normalize()), Ra));
  
  vFe1.sub(vRp);
  vFe1.sub(vRp);
  /*Sumatorio de fuerzas*/
  F = vFw.copy();
  F.add(vFn);
  //F = new PVector();
  F.add(vFe1);
  F.add(vFe2);
  //F.sub(vRp);
  F.sub(vRa);

  a = PVector.div(F, M);

  //PVector s_to_px = new PVector();
  //PVector f_to_px = new PVector();
    

  //worldToScreen(_s, s_to_px);
  //worldToScreen(PVector.add(_s, vFn), f_to_px);

  //line(s_to_px.x, s_to_px.y, f_to_px.x, f_to_px.y);


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
  drawStaticEnvironment();
  drawMovingElements();
  
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  //println("\nDraw step = " + _deltaTimeDraw + " s - " + 1.0/_deltaTimeDraw + " Hz");

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

  // drawStaticEnvironment();
  // drawMovingElements();

  calculateEnergy();
  //PrintInfo();
}

void mouseClicked() 
{
  // ...
  // ...
  // ...
}

void keyPressed()
{
  if(key=='P' || key=='p'){
    plano = !plano;
  }
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
