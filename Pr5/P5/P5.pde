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
final float FAR = 10000.0;   // Camera far distance (m)

final color BACKGROUND_COLOR = color(20, 40, 60);   // Background color (RGB)
final color MESH_COLOR = color(240, 30, 100, 100);   // Mesh lines color (RGB)

//Simulación
final boolean REAL_TIME = true;
final float TIME_ACCEL = 1.0;
float time = 0.001;

//Time
int _lastTimeDraw = 0;
float _deltaTimeDraw = 0.0;
float _simTime = 0.0;
float _elapsedTime = 0.0;

//Escena
HeightMap _heightMap;
float amplitud = 10f;
float lambda = 20f;
float velprop = 5f;
PVector epicentro = new PVector(0,0,0);

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
    time *= TIME_ACCEL;
    
    /* Camera */
    float aspect = float(DISPLAY_SIZE_X)/float(DISPLAY_SIZE_Y);  
    perspective((FOV*PI)/180, aspect, NEAR, FAR);
    camera = new PeasyCam(this, 100);
    camera.lookAt(0, 0, 0);
    //float cam[] = camera.getPosition();
    camera.setPitchRotationMode(); // Rotate on the X axis
    //println("Camera: " + cam[1]);

    /* Escena */
    _heightMap = new HeightMap(60f, 30);
    //initSimulation(OlaType.RADIAL);
    initSimulation();
    //Debug
        //println("Ellipse: " + );
    //drawStaticEnvironment();
  
}

void initSimulation(){
  _simTime = 0.0;
  _elapsedTime = 0.0;
  
  //Crear la superficie para las olas
  _heightMap.init();

  //_heightMap.waveArray.clear();
    _heightMap.listaWaves = new Wave[0];
    _heightMap.addWave(new RadialWave(amplitud, lambda, velprop, new PVector(7f, 0f, 5f), epicentro));
}

void resetSimulation(){
  
}

void updateSimulation(){
  // Update wave
  //println("Dentro de updatesimulation");
  _heightMap.update();
  _simTime += time;
}

void drawStaticEnvironment(){
    noStroke();
    fill(255);
    ellipse(0,0,1,1);
  
}

void drawDynamicEnvironment(){
    _heightMap.draw();
    //_heightMap.addWave(new RadialWave(amplitud, lambda, velprop, new PVector(7f, 0f, 5f), epicentro));
    //println("Wave: " + _heightMap.waves[0]._A);
  //wave.draw();
}

void draw(){
    println("Llegamos a P5.draw");
    int now = millis();
    _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
    _elapsedTime += _deltaTimeDraw;
    _lastTimeDraw = now;

    background(BACKGROUND_COLOR);
    drawStaticEnvironment();    
    drawDynamicEnvironment();
    if (REAL_TIME){
      //println("Dentro del if");
        float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
        float expectedIterations = expectedSimulatedTime/time;
        int iterations = 0; 

        for (; iterations < floor(expectedIterations); iterations++){
          //println("Dentro del for");
          updateSimulation();
        }

        if ((expectedIterations - iterations) > random(0.0, 1.0)){
          //println("Dentro del segundo if");
        updateSimulation();
        iterations++;
        }
    } else{
        updateSimulation();
    }

    printInfo();
  
  
}

void printInfo(){
  pushMatrix();
  {
    camera();
    fill(255);
    textSize(20);
    
    text("Frame rate = " + Math.round(1.0/_deltaTimeDraw*10d)/10d + " fps", width*(0.025), height*(1-0.025));
    text("Elapsed time = " + Math.round(_elapsedTime*10d)/10d + " s", width*(0.225), height*(1-0.025));
    text("Simulated time = " + Math.round(_simTime*10d)/10d + " s ", width*(0.425), height*(1-0.025));
    text("Pulsa (R) para el modelo radial, (D) para el direccional o (G) para el de Gerstner.", width*0.025, height*0.05);
    text("Cambia la amplitud con - y +.", width*0.025, height*0.075);
    text("Para resetear pulsa x.", width*0.025, height*0.1);
    text("Modelo actual: ", width*(0.645), height*(1-0.025));
    
  }
  popMatrix();
  
}
