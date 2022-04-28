final float SIM_STEP = 0.05;   // Simulation time-step (s)
float _simTime = 0.0;   // Simulated time (s)
int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;
float _elapsedTime = 0.0;
float t1, t2, t_colisiones;

ParticleSystem _system;   // Particle system
ArrayList<PlaneSection> _planes;    // Planes representing the limits

int DISPLAY_SIZE_X = 1500;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1200;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {10, 10, 25};

boolean puerta = false;
float Kd = -4; //Constante de rozamiento
float crP = 0.6; //Perdida de energia sufrida
float Ke = 0.1;
float m_bola=40.0;//Masa
float r_bola=5.0;//Radio de la particula
float dp = r_bola + 2;//Distancia entre las 2 particulas
int _n = 1000;
PVector G = new PVector(0, 9.8); //Fuerza de la gravedad

enum Estructura
{
  NO,
  GRID,
  HASH
}

Estructura estructuraini = Estructura.NO;

Grid grid;
HashTable hash;

int filas = 25;
int columnas = 25;

PrintWriter _output;
final String FILE_NAME = "datos.txt";

void settings()
{
  size(DISPLAY_SIZE_X, DISPLAY_SIZE_Y);
}

void setup()
{
  initSimulation();
  _output = createWriter("data.txt");
  _output.println("NumParticulas;TiempoReal;TiempoSimulado;TiempoMedio;Frames;TiempoComputo");
}

void initSimulation()
{
  _system = new ParticleSystem();
  _planes = new ArrayList<PlaneSection>();

  _planes.add(new PlaneSection(1450, 30, 50, 30, true));
  _planes.add(new PlaneSection(50, 30, 200, 400, false));
  _planes.add(new PlaneSection(1250, 400, 1450, 30, false));
  _planes.add(new PlaneSection(200, 400, 700, 650, false));
  _planes.add(new PlaneSection(800, 650, 1250, 400, false));
  _planes.add(new PlaneSection(700, 650, 800, 650, false));

  grid = new Grid(filas, columnas);
  hash = new HashTable(_system.getNumParticles()*2, width/filas);
}

void drawStaticEnvironment()
{
  fill(0);
  textSize(20);

  for (PlaneSection p : _planes)
    p.draw();
}

void printInfo() {
}


void draw()
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;
  
  String np = nf(_n,0,0);
  String tr = nf(_elapsedTime,0,3); //tiempo real
  String ts = nf(_simTime,0,3);
  String tm = nf(_deltaTimeDraw,0,3); //tiempo medio
  String fr = nf(1.0/_deltaTimeDraw,0,3);
  String tc = nf(t_colisiones);
  
  _output.println(np + ";" + tr + ";" + ts + ";" + tm + ";" + fr + ";" + tc);
  t1 = millis();
  _system.computeCollisions(_planes);
  t2 = millis();
  t_colisiones = (t2-t1)/1000.0;
  
  background(255, 255, 255);
  drawStaticEnvironment();
  _system.run();

  switch (estructuraini) {
  case GRID:
    _system.updateGrid();
    break;
  case HASH:
    _system.updateHash();
    break;
  }
  _system.display();

  _simTime += SIM_STEP;
}

void mouseClicked(){
  _system.anyadirParticula();
}

void keyPressed()
{
  if(key == 'P' || key == 'p'){
    if(puerta==false){
      puerta = true;
      _planes.remove(5);
    }
    else{
      puerta = false;
      _planes.add(new PlaneSection(700, 650, 800, 650, false));
    }
  }
  if(key == 'N' || key == 'n'){
    estructuraini = Estructura.NO;
  }
  if(key == 'G' || key == 'g'){
    estructuraini = Estructura.GRID;
  }
  if(key == 'H' || key == 'h'){
    estructuraini = Estructura.HASH;
  }
  if(key == 'M' || key == 'm'){
    _output.flush();
    _output.close();
  }
}
