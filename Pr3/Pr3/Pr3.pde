// ...
// ...
// ...

final float SIM_STEP = 0.01;   // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)
int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)

ParticleSystem _system;   // Particle system
//ParticleSystem _s2;
Particle p1;
ArrayList<PlaneSection> _planes;    // Planes representing the limits
boolean _computePlaneCollisions = true;

final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1200;   // Display width (pixels)
int DISPLAY_SIZE_Y = 700;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {10, 10, 25};


final float PIXELS_PER_METER = 300;   // Display length that corresponds with 1 meter (pixels)
final PVector DISPLAY_CENTER = new PVector(0.0, 0.0);   // World position that corresponds with the center of the display (m
int tam = 5;
Boolean randMov;
Boolean[] triggers = new Boolean[tam];
int[] marca = new int[tam];

//taco
PVector initaco;
PVector fintaco;

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
  randMov=false;
  //initSimulation();
  
  initSimulation(false);
}

void initSimulation(Boolean m)
{
  for (int u = 0; u < tam; u++){
    triggers[u] = false;
    marca[u] = tam + 1;
  }
  
  //Modo de movimiento
  
  
  //Sistema
  _system = new ParticleSystem(m);
  _planes = new ArrayList<PlaneSection>();
  p1 = new Particle(_system, 1, new PVector(200, 200), new PVector(0, 0), 1, 5);
  _system.addParticle(1, new PVector(200, 200), new PVector(0, 0), 1.0, 5.0);

  //planes
  _planes.add(new PlaneSection(50, 50, 1150, 50, true)); //N
  _planes.add(new PlaneSection(1150, 50, 1150, 650, true)); //E
  _planes.add(new PlaneSection(50, 650, 1150, 650, false)); //S
  _planes.add(new PlaneSection(50, 50, 50, 650, false)); //W

  //Taco
  initaco = new PVector(mouseX, mouseY);
  
  
  // ...
  // ...
  // ...
}

void drawStaticEnvironment()
{
  fill(0);
  textSize(20);
  
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

void printInfo(){
  fill(0);
  textSize(18);
  textAlign(LEFT);
  text("Reiniciar (R)  -  Movimiento aleatorio (M)", width*0.05, height*0.87);
  text("Seleccionar bola (Click izquierdo)  -  Disparar (Seleccionar bola + Click y arrastre)", width*0.05, height*0.90);
}

void draw() 
{
  // ...
  // ...
  // ...
  
  drawStaticEnvironment();
  printInfo();
  
  _system.run();
  _system.computeCollisions(_planes, _computePlaneCollisions);  
  _system.display();
  
  _simTime += SIM_STEP;
  if(mousePressed){
    Boolean aux=false;
    for(int u = 0; u < tam; u++)
      aux ^= triggers[u];
    if(aux){
      for(int i = 0; i < _system.getNumParticles(); i++){
        Particle p = _system._particles.get(i);
        if(triggers[p._id]){
          initaco = new PVector(p._s.x, p._s.y);
          strokeWeight(4);
          stroke(255, 80, 80, abs(mouseX+mouseY));
          line(initaco.x, initaco.y, mouseX, mouseY);
        }
      }
    }
  }
  // ...
  // ...
  // ...
}

void mouseClicked() 
{
  //se selecciona la bola
  //si mouseX, mouse Y coincide con el área de esa bola
  for(int i = 0; i < _system.getNumParticles(); i++){
    
    Particle p = _system._particles.get(i);
    
    //PVector vsum = new PVector(1, 1); //Para mover la partícula en caso de v = 0
    //PVector newVel = PVector.mult(PVector.add(p._v, vsum), 3);
    if(clicada(p)){
      
        //taco
        initaco = new PVector(p._s.x, p._s.y);
        
        //trigger de la bola clicada
        for (int u = 0; u < tam; u++)
          triggers[u] = false;
        triggers[i] = true;
        printArray(triggers);
        printArray(marca);
        p.display();
        
        
        
      }
   }
}
Boolean clicada(Particle p){
  Boolean aux = false;
    if(mouseX >= p._s.x - p._radius && mouseX <= p._s.x + p._radius){ //El puntero coincide con la bola en el eje x
      if(mouseY>= p._s.y - p._radius && mouseY <= p._s.y + p._radius){ //El puntero coincide con la bola en el eje y
        aux = true;
      }
    }
  return aux;
}

void mousePressed(){
  initaco = new PVector(mouseX, mouseY);
}

void keyPressed()
{
  if(key=='M' || key=='m'){
    randMov = !randMov;
    print(randMov);
    if(!randMov)
      initSimulation(false);
    
    if(randMov){
      initSimulation(true);
      //randMov=false;
    }
    
    
  }
  if(key=='R' || key=='r'){
    _system._particles.clear();
    setup();
    
  }
}
  
void stop()
{
}
