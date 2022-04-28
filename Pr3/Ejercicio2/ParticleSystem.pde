class ParticleSystem 
{
  ArrayList<Particle> _particles;
 
  int id = 0;//Variable para ir asignando id a cada particula

  ParticleSystem()  
  {
    _particles = new ArrayList<Particle>();
    
    int col = 100;
    int fil = _n  / col;
    
    for (int i = 0; i < fil; i++){
      for (int j = 0; j < col; j++){
        PVector initVel = new PVector(0,0);//Velocidad inicial de la particula
        PVector posicion_inicial = new PVector(random(300,1200), random(100,400)); //Posicion inicial de la particula
        addParticle(id, posicion_inicial, initVel, m_bola, r_bola);//Añade la particula
        id++;
      }
    }
  }
  
  void anyadirParticula(){
    for (int i = 0; i < 200; i++){
      PVector initVel = new PVector(0,0);//Velocidad inicial de la particula
      PVector posicion_inicial = new PVector(random(300,1200), random(100,400)); //Posicion inicial de la particula
      addParticle(id, posicion_inicial, initVel, m_bola, r_bola);//Añade la particula
      id++;
    }
    _n += 200;
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
    for (int i = 0; i < _n; i++) 
    {
      Particle p = _particles.get(i);
      p.update();
    }
  }
  
  void updateGrid(){
    grid.limpiar();
    for(int i = 0; i < _n; i++){
      Particle p = _particles.get(i);
      p.updateGrid();
    }
  }
  
  void updateHash(){
    hash.limpiar();
    for(int i = 0; i < _n; i++){
      Particle p = _particles.get(i);
      p.updateHash();
    }
  }
  
  void computeCollisions(ArrayList<PlaneSection> planes) 
  { 
    for(Particle p : _particles){
      p.planeCollision(planes);
      p.particleCollisionSpringModel();
    }
  }
    
  void display() 
  {
    for (int i = _n - 1; i >= 0; i--) 
    {
      Particle p = _particles.get(i);
      color colorparticula = color(15, 95, 222);
      int celda;
      
      switch(estructuraini){
      case NO:
        colorparticula = color(15, 95, 222);
      break;
      case GRID:
        celda = grid.getCelda(p._s);
        colorparticula = grid._colors[celda];
      break;
      case HASH:
        celda = hash.getCelda(p._s);
        colorparticula = hash._colors[celda];
      break;
      }
      p.display(colorparticula);
    }
  }
}
