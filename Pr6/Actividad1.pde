// Muy importante añadir la librería Fisica a processing Herramientas/Añadir Herramienta...
import fisica.*;    

final int NUM_OBJETOS = 50;
final int TAM_OBJETO_X = 60;
final int TAM_OBJETO_Y = 60;

FWorld _world;           
ArrayList<FBox> _objetos;

void setup()
{
  size(1000, 1000);
  smooth();
  
  _objetos = new ArrayList<FBox>(0);
  
  Fisica.init(this);
  _world = new FWorld();
  _world.setEdges();
   
  // Creación de los objetos que componen la escena
  for (int i = 0; i < NUM_OBJETOS; i++)
  {     
     int posX = (int)random(0, width);     
     int posY = (int)random(0, height);     
     
     FBox objeto = new FBox(TAM_OBJETO_X, TAM_OBJETO_Y);
     objeto.setPosition(posX, posY);
     objeto.setDensity(1.0f);
     
     _world.add(objeto);
     _objetos.add(objeto);
     
     // Ajuste de las propiedades físicas del material de los objetos
     objeto.setDamping(0.0);
     objeto.setAngularDamping(0.0);     
     objeto.setFriction(0.0);
     objeto.setRestitution(1.0);
  }
}

void draw() 
{
  background(225, 225, 255);

  // Simulación de los objetos del mundo físico
  _world.step();
  
  // Cambio de color de los objetos en función de su estado
  for (int i = 0; i < _objetos.size(); i++)
  {
     FBox objeto = _objetos.get(i);
     
     if (objeto.isSleeping())
        objeto.setFillColor(color(#FF0000));
     else
        objeto.setFillColor(color(#FFFF00));
  }

  // Dibujado de los objetos del mundo físico
  _world.draw();
}
