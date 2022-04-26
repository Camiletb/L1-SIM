class ParticleSystem 
{
  ArrayList<Particle> _particles;
  int _n;
  
  // ... (G, Kd, Ke, Cr, etc.)
  // ...
  // ...
  float m_bola=0.21;
  float r_bola=worldToPixels(0.0305);

  ParticleSystem(Boolean m)  
  {
    _particles = new ArrayList<Particle>();
    _n = tam;
    PVector initVel;
    PVector posicion_inicial;
    
    if(!m){
      for(int  i=0 ; i < _n;i++)
      {
        initVel =new PVector(0, 0);
        posicion_inicial = new PVector(random(320, worldToPixels(2.85)), random(250, worldToPixels(1.42)));
        addParticle(i,posicion_inicial,initVel,m_bola,r_bola);
      }
    }else{
      for(int  i=0 ; i < _n;i++)
      {
        initVel =new PVector(random(-200,300),random(-200,300));
        posicion_inicial = new PVector(random(320, worldToPixels(2.85)), random(250, worldToPixels(1.42)));
        addParticle(i,posicion_inicial,initVel,m_bola,r_bola);
      }
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
    for(Particle p : _particles){
      p.planeCollision(planes);

      if (computeParticleCollision)
        p.particleCollisionVelocityModel();
    }
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
