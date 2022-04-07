class ParticleSystem 
{
  ArrayList<Particle> _particles;
  int _n;
  
  // ... (G, Kd, Ke, Cr, etc.)
  // ...
  // ...

  ParticleSystem(/* ¿¿¿¿arguments???? */)  
  {
    _particles = new ArrayList<Particle>();
    _n = 0;
    
    // ...
    // ...
    // ...    
  }

  void addParticle(int id, PVector initPos, PVector initVel, float mass, float radius) 
  { 
  }
  
  void restart()
  {
  }
  
  int getNumParticles()
  {
    return _n;
  }
  
  ArrayList<Particle> getParticleArray()
  {
    return _particles;
  }

  void run() 
  {
    for (int i = _n - 1; i >= 0; i--) 
    {
      Particle p = _particles.get(i);
      p.update();
    }
  }
  
  void computeCollisions(ArrayList<PlaneSection> planes, boolean computeParticleCollision) 
  { 
  }
    
  void display() 
  {
    for (int i = _n - 1; i >= 0; i--) 
    {
      Particle p = _particles.get(i);      
      p.display();
    }    
  }
  
  // ...
  // ...
  // ...
}
