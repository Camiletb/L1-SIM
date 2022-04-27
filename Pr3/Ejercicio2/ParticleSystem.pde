class ParticleSystem 
{
  ArrayList<Particle> _particles;
  int _n;
  
  float m_bola=40;//Masa
  float r_bola=3;//Radio de la particula
  float dp = r_bola + 2;//Distancia entre las 2 particulas
  int id = 0;//Variable para ir asignando id a cada particula

  ParticleSystem()  
  {
    _particles = new ArrayList<Particle>();
    _n = tam;
    
    int col = 100;
    int fil = _n  / col;
    
    for (int i = 0; i < fil; i++){
      for (int j = 0; j < col; j++){
        PVector initVel = new PVector(0,0);//Velocidad inicial de la particula
        PVector posicion_inicial = new PVector((r_bola + dp)*j+150, (r_bola + dp)*i + 100); //Posicion inicial de la particula
        addParticle(id, posicion_inicial, initVel, m_bola, r_bola);//Añade la particula
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
        p.particleCollisionSpringModel();
    }
  }
    
  void display() 
  {
    for (int i = _n - 1; i >= 0; i--) 
    {
      Particle p = _particles.get(i);
      color colorparticula = color(15, 95, 222);
      p.display(colorparticula);
    }    
  }
  
  // ...
  // ...
  // ...
}
