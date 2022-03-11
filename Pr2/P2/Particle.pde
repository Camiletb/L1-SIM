public class Particle 
{
  ParticleType _type;

  PVector _s;   // Position (m)
  PVector _v;   // Velocity (m/s)
  PVector _a;   // Acceleration (m/(s*s))
  PVector _F;   // Force (N)
  float _m;   // Mass (kg)

  int _ttl;   // Time to live (iterations)
  color _color;   // Color (RGB)
  
  final static int _particleSize = 2;   // Size (pixels)
  final static int _casingLength = 25;   // Length (pixels)

  Particle(ParticleType type, PVector s, PVector v, float m, int ttl, color c) 
  {
    _type = type;
    
    _s = s.copy();
    _v = v.copy();
    _m = m;

    _a = new PVector(0.0 ,0.0, 0.0);
    _F = new PVector(0.0, 0.0, 0.0);
   
    _ttl = ttl;
    _color = c;
  }

  void run() 
  {
    update();
    display();
  }

  void update() 
  {
    if (isDead())
      return;
      
    updateForce();
   
    // Codigo con la implementación de las ecuaciones diferenciales para actualizar el movimiento de la partícula
    // ...
    // ...
    // ...
    
    _ttl--;
  }
  
  void updateForce()
  {
    // Código para calcular la fuerza que actua sobre la partícula
    // ...
    // ...
    // ...
  }
  
  PVector getPosition()
  {
    return _s;
  }

  void display() 
  {
    // Codigo para dibujar la partícula. Se debe dibujar de forma diferente según si es la carcasa o una partícula normal
    // ...
    // ...
    // ...
  }
  
  boolean isDead() 
  {
    if (_ttl < 0.0) 
      return true;
    else
      return false;
  }
}
