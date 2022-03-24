enum RocketType 
{
  // Introducir aquí los tipos de palmera que se implementarán
  CIRCULO,
  ESPIRAL,
  CORAZON;
}

final int NUM_ROCKET_TYPES = RocketType.values().length;

enum ParticleType 
{
  CASING,
  REGULAR_PARTICLE 
}

// Particle control:

FireWorks _fw;   // Main object of the program
int _numParticles = 0;   // Number of particles of the simulation

// Problem variables:

final float Gc = 9.801;   // Gravity constant (m/(s*s))
final PVector G = new PVector(0.0, Gc);   // Acceleration due to gravity (m/(s*s))
PVector _windVelocity = new PVector(0.0, 0.0);   // Wind velocity (m/s)
final float WIND_CONSTANT = 1.0;   // Constant to convert apparent wind speed into wind force (Kg/s)

// Display values:

final boolean FULL_SCREEN = false;
final int DRAW_FREQ = 50;   // Draw frequency (Hz or Frame-per-second)
int DISPLAY_SIZE_X = 1000;   // Display width (pixels)
int DISPLAY_SIZE_Y = 1000;   // Display height (pixels)
final int [] BACKGROUND_COLOR = {10, 10, 25};

// Time control:

int _lastTimeDraw = 0;   // Last measure of time in draw() function (ms)
float _deltaTimeDraw = 0.0;   // Time between draw() calls (s)
float _simTime = 0.0;   // Simulated time (s)
float _elapsedTime = 0.0;   // Elapsed (real) time (s)
final float SIM_STEP = 0.02;   // Simulation step (s)

//Fichero
PrintWriter _output;
final String FILE_NAME = "data.csv";

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

  _fw = new FireWorks();
  _numParticles = 0;
  
  _output = createWriter(FILE_NAME);
  _output.println("Numero de partículas;Tiempo medio");
}

void printInfo()
{
  fill(255);
  text("Number of particles : " + _numParticles, width*0.025, height*0.05);
  text("Frame rate = " + 1.0/_deltaTimeDraw + " fps", width*0.025, height*0.075);
  text("Elapsed time = " + _elapsedTime + " s", width*0.025 , height*0.1);
  text("Simulated time = " + _simTime + " s ", width*0.025, height*0.125);
  text("Flecha arriba abajo para modificar velocidad en y." , width*0.025, height*0.15);
  text("Flecha derecha izquierda para modificar velocidad en x." , width*0.025, height*0.175);
  
  text("Para parar la simulación presiona la x", width*0.025, height*0.225);
  
  String frames = nf(1.0 / _deltaTimeDraw, 0, 3);
  _output.println(_numParticles + ";" + frames);
}

void drawWind()
{
  // Código para dibujar el vector que representa el viento
  fill(255);
  text("Velocidad viento: x = "+ _windVelocity.x + ", y = " + -1*_windVelocity.y, width*0.025, height*0.2);
  //stroke(126);
  PVector velocidad = new PVector();
  velocidad = _windVelocity.copy();
  velocidad.normalize();
  velocidad.mult(30);
  
  PVector centroBrujula = new PVector(width/2, height*0.8);
  //PVector punta = new PVector(centroBrujula.x + velocidad.x, centroBrujula.y + velocidad.y);
  stroke(255);
  line(centroBrujula.x, centroBrujula.y,_windVelocity.x+centroBrujula.x, _windVelocity.y+centroBrujula.y);
  //line(centroBrujula.x, centroBrujula.y, punta.x, punta.y);
  noStroke();
}

void draw()
{
  int now = millis();
  _deltaTimeDraw = (now - _lastTimeDraw)/1000.0;
  _elapsedTime += _deltaTimeDraw;
  _lastTimeDraw = now;

  background(BACKGROUND_COLOR[0], BACKGROUND_COLOR[1], BACKGROUND_COLOR[2]);
  
  _fw.run();
  printInfo();  
  drawWind();
}

void mousePressed()
{
  PVector pos = new PVector(mouseX, mouseY);
  PVector vel = new PVector((pos.x - width/2), (pos.y - height));
  color c = color(random(255),random(255),random(255));

  int type = (int)(random(NUM_ROCKET_TYPES)); 
  _fw.addRocket(RocketType.values()[type], new PVector(width/2, height), vel, c);
}

void keyPressed()
{
  // Código para manejar la interfaz de teclado
  if (key == CODED) {
    if (keyCode == UP) {
      _windVelocity = new PVector (_windVelocity.x, _windVelocity.y - 1.0);
    }
    else if (keyCode == DOWN) {
      _windVelocity = new PVector (_windVelocity.x, _windVelocity.y + 1.0);
    }
    else if (keyCode == RIGHT) {
      _windVelocity = new PVector (_windVelocity.x + 1.0, _windVelocity.y);
    }
    else if (keyCode == LEFT) {
      _windVelocity = new PVector (_windVelocity.x - 1.0, _windVelocity.y);
    }
    if (key == 'x' || key == 'X') {
      stop();
    }
  }
}
void stop()
{
  _output.flush();
  _output.close();
}
