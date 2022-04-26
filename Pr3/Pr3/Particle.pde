class Particle  //<>//
{
  ParticleSystem _ps;
  int _id;

  PVector _s;
  PVector _v;
  PVector _a;
  PVector _f;

  float _m;
  float _radius;
  color _color;
  
  // ...
  // ...
  // ...
  
  Particle(ParticleSystem ps, int id, PVector initPos, PVector initVel, float mass, float radius) 
  {
    _ps = ps;
    _id = id;

    _s = initPos.copy();
    _v = initVel.copy();
    _a = new PVector(0.0, 0.0);
    _f = new PVector(0.0, 0.0);

    _m = mass;
    _radius = radius;
    _color = color(0, 100, 255, 150);
  }

  void update() 
  {  
  }

  void updateForce()
  {  
  }

  void planeCollision(ArrayList<PlaneSection> planes)
  { 
  } 

  void particleCollisionVelocityModel()
  {
  }
  
  void particleCollisionSpringModel()
  { 
  }
  
  void display() 
  {
    /*** ¡¡Esta función se debe modificar si la simulación necesita conversión entre coordenadas del mundo y coordenadas de pantalla!! ***/
    
    noStroke();
    circle(_s.x, _s.y, 2.0*_radius);
  }
  
  // ...
  // ...
  // ...
}