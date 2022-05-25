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
final float FAR = 1000.0;   // Camera far distance (m)

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
float lambda = 10f;
float velprop = 4f;
PVector epicentro = new PVector(0,0,0);

//Modelos
boolean radial = true;
boolean directional = false;
boolean gerstner = false;
int mode = 0;
String type = "Radial";
int contWaves = 0;

PImage img;
boolean display = false;
String vista = "Esqueleto";
int maxwaves = 5;
boolean liberacion = false;

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
    camera.setPitchRotationMode(); // Rotate on the X axis. Para un resultado más profesional. Comentando esta línea puedes desplazarte como siempre.

    /* Escena */
    img = loadImage("w3.png");
    if(display)
        _heightMap = new HeightMap(20f, 75);
    else
        _heightMap = new HeightMap(60f, 60);
    //initSimulation(OlaType.RADIAL);
    initSimulation();
  
}

void initSimulation(){
  _simTime = 0.0;
  _elapsedTime = 0.0;
  
  //Crear la superficie para las olas
  _heightMap.init();
    
    switch(mode){
      case 0:
        _heightMap.addWave(new RadialWave(amplitud*random(0.8, 1.2), lambda*random(0.8, 1.2), velprop*random(0.8, 1.2), new PVector(random(-7f, 7f), 0f, random(-7f, 7f)), epicentro));
        break;
      case 1:
        _heightMap.addWave(new GerstnerWave(amplitud*random(0.8, 1.2), lambda*random(0.8, 1.2), velprop*random(0.8, 1.2), new PVector(random(-7f, 7f), 0f, random(-7f, 7f)), epicentro));
        break;
      case 2:
        _heightMap.addWave(new GerstnerWave(amplitud*1.5*random(0.8, 1.2), lambda*3*random(0.8, 1.2), velprop*random(0.8, 1.2), new PVector(random(-7f, 7f), 0f, random(-7f, 7f)), epicentro));
        break;
    }
}

void resetSimulation(){
  amplitud = 1f;
  lambda = 10f;
  velprop = 4f;
  epicentro = new PVector(0,0,0);
  contWaves = 0;
  _heightMap.waves.clear();
  initSimulation();
}

void updateSimulation(){
  _heightMap.update();
  _simTime += time;
}

void drawStaticEnvironment(){
    noStroke();
    fill(255);
    ellipse(0,0,0.5,0.5); //Simplemente, indica el punto (0, 0, 0) del eje de coordenadas
  
}

void drawDynamicEnvironment(){
    _heightMap.draw();
}

void draw(){
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
    text("Modelo radial [R], Direccional [D], De Gerstner [G]. (Añade más ondas Gerstner con [G])", width*0.025, height*0.05);
    text("Amplitud [- / +]:   " + Math.round(_heightMap.waves.get(0)._A*100d)/100d + "m", width*0.025, height*0.075);
    text("Velocidad de propagación [I / O]:   " + Math.round(_heightMap.waves.get(0)._vp*100d)/100d + "m/s", width*0.025, height*0.1);
    text("Longitud de onda [K / L]:   " + Math.round(_heightMap.waves.get(0)._lambda*100d)/100d + "m", width*0.025, height*0.125);
    text("Inclinación Q de la onda [, / .]:   " + Math.round(_heightMap.waves.get(0)._Q*100d)/100d, width*0.025, height*0.15);
    text("En Gerstner, añade ondas con [G] o bórralas con [B].", width*0.025, height*0.175);
    text("Reset [X].", width*0.025, height*0.2);
    text("Modelo actual: " + type, width*(0.645), height*(1-0.025));
    text("Nº ondas: " +  + _heightMap.waves.size(), width*(0.875), height*(1-0.025));
    if(!display)
        fill(240,80,80);
    else
        fill(80,210,210);
    text("Modo de vista [V]: " + vista, width*(0.025), height*(1-0.05));
    if(mode != 2)
        text("     Tamaño de la malla: " + _heightMap._size + "m     Nº nodos: "+ _heightMap._nodes, width*(0.275), height*(1-0.05));
    else
        text("     Tamaño de la malla: " + _heightMap._size + "m     Nº nodos: "+ _heightMap._nodes + "     Ondas Gerstner máximas: "+ maxwaves, width*(0.275), height*(1-0.05));
    
  }
  popMatrix();
  
}

void keyPressed(){
if(key == 'v' || key == 'V'){
    display = !display;
    if(display){
        _heightMap = new HeightMap(20f, 75);
        maxwaves = 3;
        vista = "Texturizada";
    }
    else{
        _heightMap = new HeightMap(60f, 60);
        maxwaves = 5;
        vista = "Esqueleto";
    }
    resetSimulation();
  }
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
  
  if(key == '.'){
    for(int k = 0; k < _heightMap.waves.size(); k++)
      _heightMap.waves.get(k)._Q += 0.05;
  }
  
  if(key == ','){
    for(int k = 0; k < _heightMap.waves.size(); k++)
      _heightMap.waves.get(k)._Q -= 0.05;
  }
  
  if(key == 'd' || key == 'D'){
    mode = 1;
    type = "Directional";
    resetSimulation();
  }
  if(key == 'r' || key == 'R'){
    mode = 0;
    type = "Radial";
    resetSimulation();
  }
  if(key == 'g' || key == 'G'){
    if(mode == 2){
        if(maxwaves-1 > contWaves){
            contWaves++;
            float dirx = random(-5f, 5f);
            float dirz = random(-5f, 5f);
            _heightMap.addWave(new GerstnerWave(amplitud*random(0.8, 1.4), lambda*random(1.2, 2.8), velprop*random(0.8, 1.2), new PVector(dirx, 0f, dirz), epicentro));
            /*if(liberacion == true)
                text("Una onda ha sido borrada. Ondas totales: " +  + _heightMap.waves.size(), width*(0.5), height*(1-0.225));
            else
                text("Una onda ha sido añadida. Ondas totales: " +  + _heightMap.waves.size(), width*(0.5), height*(1-0.225));*/
        }else{
            println("No se pueden añadir más ondas de Gerstner, borra ondas con (B)");
        }

        if(_deltaTimeDraw < 20.0){
            liberacion = true;
        }

    }else{
      mode = 2;
      type = "Gerstner";
      resetSimulation();
    }
  }
  if(key == 'b' || key == 'B' /*|| liberacion*/){
    if(_heightMap.waves.size()-1 > 0){

      _heightMap.waves.remove(_heightMap.waves.size()-1);
      contWaves--;
      /*if(_deltaTimeDraw > 30.0)
        liberacion = false;*/
    }
  }  
}
