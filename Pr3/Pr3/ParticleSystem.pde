class ParticleSystem 
{
  ArrayList<Particle> _particles;
  int _n;
  
  // ... (G, Kd, Ke, Cr, etc.)
  // ...
  // ...
  float m_bola=0.21;
  float r_bola=worldToPixels(0.0305);

  ParticleSystem(/* ¿¿¿¿arguments???? */)  
  {
    _particles = new ArrayList<Particle>();
    _n = 5;
    
    for(int  i=0 ; i < _n;i++)
    {
      PVector initVel =new PVector(random(-200,300),random(-200,300));
      PVector posicion_inicial = new PVector(random(320, worldToPixels(2.85)), random(250, worldToPixels(1.42)));
      addParticle(i,posicion_inicial,initVel,m_bola,r_bola);
      println(i);
    }   
  }

  void addParticle(int id, PVector initPos, PVector initVel, float mass, float radius) 
  { 
    _particles.add(new Particle( this, id,  initPos,  initVel,  mass,  radius));
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
