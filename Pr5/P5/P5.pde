import peasy.*;

/* GLOBALES */
// Cámara y display
PeasyCam camera;
final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;
int DISPLAY_SIZE_X = 1000;
int DISPLAY_SIZE_Y = 1000;
final float FOV = 60;   // Field of view (º)
final float NEAR = 0.01;   // Camera near distance (m)
final float FAR = 1000.0;   // Camera far distance (m)

final color BACKGROUND_COLOR = color(20, 40, 60);   // Background color (RGB)
final color MESH_COLOR = color(240, 30, 100, 100);   // Mesh lines color (RGB)

//Simulación
final boolean REAL_TIME = true;
final float TIME_ACCEL = 1.0;
float SIM_STEP = 0.001;

//Time
int _lastTimeDraw = 0;
float _deltaTimeDraw = 0.0;
float _simTime = 0.0;
float _elapsedTime = 0.0;

/* FUNCIONES */

// Settings del Display
void settings()
{
  if (FULL_SCREEN)
  {
    fullScreen(P3D);
    DISPLAY_SIZE_X = displayWidth;
    DISPLAY_SIZE_Y = displayHeight;
  } 
  else
  {
    size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y, P3D);
  }
}

/* MAIN */

// Setup de la escena
void setup(){
  //size(800, 600, P3D);
  
  /* FrameRate */
  frameRate(DRAW_FREQ);
  _lastTimeDraw = millis();
  SIM_STEP *= TIME_ACCEL;
  
  /* Camera */
  float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);  
  perspective((FOV*PI)/180, aspect, NEAR, FAR);
  camera = new PeasyCam(this, 0);

  //initSimulation(OlaType.RADIAL);
  
}

void initSimulation(){
  _simTime = 0.0;
  _elapsedTime = 0.0;
  
  //Crear la superficie para las olas
}

void resetSimulation(){
  
}

void updateSimulation(){
  // Update wave
  _simTime += SIM_STEP;
}

void drawStaticEnvironment(){

  
}

void drawDynamicEnvironment(){
  //wave.draw();
}

void draw(){
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;
  
  background(BACKGROUND_COLOR);
  //drawDynamicEnvironment();
  
  if (REAL_TIME){
    float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
    float expectedIterations = expectedSimulatedTime/SIM_STEP;
    int iterations = 0; 

    for (; iterations < floor(expectedIterations); iterations++)
      updateSimulation();

    if ((expectedIterations - iterations) > random(0.0, 1.0)){
      updateSimulation();
      iterations++;
    }
  } else
      updateSimulation();

  printInfo();
  
}

void printInfo(){
  
  
}
