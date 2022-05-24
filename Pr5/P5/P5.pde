import peasy.*;

/* GLOBALES */
// Cámara y display
PeasyCam camera;
final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;
int DISPLAY_SIZE_X = 1000;
int DISPLAY_SIZE_Y = 1000;
final float FOV = 60;   // Field of view (º)
final float NEAR = 0.001;   // Camera near distance (m)
final float FAR = 100000.0;   // Camera far distance (m)

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
float amplitud = 1f;
float lambda = 5f;
float velprop = 2f;
PVector epicentro = new PVector(0,0,0);

//Modelos
boolean radial = true;
boolean directional = false;
boolean gerstner = false;
int mode = 0;
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
    _heightMap = new HeightMap(60f, 60);
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
    
    switch(mode){
      case 0:
        
        _heightMap.addWave(new RadialWave(amplitud, lambda, velprop, new PVector(7f, 0f, 5f), epicentro));
        break;
      case 1:
        //_heightMap.waves.clean();
        _heightMap.addWave(new DirectionalWave(amplitud, lambda, velprop, new PVector(7f, 0f, 5f), epicentro));
        break;
    }
}

void resetSimulation(){
  amplitud = 1f;
  lambda = 5f;
  velprop = 2f;
  epicentro = new PVector(0,0,0);
  _heightMap.waves.clear();
  initSimulation();
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
    //println("Llegamos a P5.draw");
    int now = millis();
    _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
    _elapsedTime += _deltaTimeDraw;
    _lastTimeDraw = now;

    background(BACKGROUND_COLOR);
    drawStaticEnvironment();    
    drawDynamicEnvironment();
    if (REAL_TIME){
        float expectedSimulatedTime = TIME_ACCEL*_deltaTimeDraw;
        float expectedIterations = expectedSimulatedTime/time;
        int iterations = 0; 

        for (; iterations < floor(expectedIterations); iterations++){
          updateSimulation();
        }

        if ((expectedIterations - iterations) > random(0.0, 1.0)){
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
    text("Amplitud [-/+]:   " + Math.round(_heightMap.waves.get(0)._A*100d)/100d + "m", width*0.025, height*0.075);
    text("Velocidad de propagación [I/O]:   " + Math.round(_heightMap.waves.get(0)._vp*100d)/100d + "m/s", width*0.025, height*0.1);
    text("Longitud de onda [K/L]:   " + Math.round(_heightMap.waves.get(0)._lambda*100d)/100d + "m", width*0.025, height*0.125);
    text("Reset [X].", width*0.025, height*0.15);
    text("Modelo actual: ", width*(0.645), height*(1-0.025));
    
  }
  popMatrix();
  
}

void keyPressed(){
  if(key == 'x' || key == 'X'){
    resetSimulation();
  }
  
  if(key == '+'){
    for(int k = 0; k < _heightMap.waves.size(); k++)
      _heightMap.waves.get(k)._A += 0.2;
  }
  if(key == '-'){
    for(int k = 0; k < _heightMap.waves.size(); k++)
      _heightMap.waves.get(k)._A -= 0.2;
  }
  
  if(key == 'o' || key == 'O'){
    for(int k = 0; k < _heightMap.waves.size(); k++)
      _heightMap.waves.get(k)._vp += 0.2;
  }
  if(key == 'i' || key == 'I'){
    for(int k = 0; k < _heightMap.waves.size(); k++)
      _heightMap.waves.get(k)._vp -= 0.2;
  }
  
  if(key == 'l' || key == 'L'){
    for(int k = 0; k < _heightMap.waves.size(); k++)
      _heightMap.waves.get(k)._lambda += 0.2;
  }
  if(key == 'k' || key == 'K'){
    for(int k = 0; k < _heightMap.waves.size(); k++)
      _heightMap.waves.get(k)._lambda -= 0.2;
  }
  
  if(key == 'd' || key == 'D'){
    //directional = true;
    mode = 1;
    resetSimulation();
  }
  if(key == 'r' || key == 'R'){
    //directional = true;
    mode = 0;
    resetSimulation();
  }
  
}
