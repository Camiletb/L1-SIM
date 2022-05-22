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

final color BACKGROUND_COLOR = color(220, 240, 220);   // Background color (RGB)
final color MESH_COLOR = color(0, 0, 0);   // Mesh lines color (RGB)

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
