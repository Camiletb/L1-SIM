class Particle  //<>//
{
  final float Kd = -0.1; //Constante de rozamiento
  float crP = 0.3; //Perdida de energia sufrida
  float Ke = 0.6;
  ParticleSystem _ps;
  int _id;

  PVector _s;
  PVector _v;
  PVector _a;
  PVector _f;

  float _m;
  float _radius;
  color _color;
  
  PVector G = new PVector(0, 9.8); //Fuerza de la gravedad
  
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
    updateForce();
    PVector fuerza; //auxiliar para copiar el vector f
    fuerza = _f.copy();
    _a = PVector.div(fuerza, _m);
    _v.add(PVector.mult(_a, SIM_STEP));
    _s.add(PVector.mult(_v, SIM_STEP));
  }

  void updateForce()
  {
    PVector Fr = PVector.mult(_v,Kd);
    PVector Fg = PVector.mult(G, SIM_STEP);
    PVector Ftotal = PVector.add(Fr, Fg);
    
    _f = Ftotal.copy();
  }

  void planeCollision(ArrayList<PlaneSection> planes)
  {
        //Comprobación
    for(PlaneSection pl : planes){
      float dist = pl.getDistance(_s); //Calculamos a cuánto está la partícula del plano
      
      if (dist < _radius){ //La distancia es menor que el radio de la partícula
        //Corrección de pos
        PVector normal; //Vector normal
        PVector delta; //Nueva posición
        float resti; //distancia de restitución
        
        normal = pl.getNormal();
        resti = _radius - dist;
        delta = normal.copy().mult(resti); //Posición nueva para quedar sobre el plano
        _s.add(delta);//Restitución
        
        //Correción de vel
        float nv; //nueva velocidad: la velocidad de colisión, redireccionada con la normal
        PVector vtan; //velocidad paralela al plano (tangencial) de la nv
        PVector vnorm; //velocidad perpendicular al plano (normal) de la nv
        
        nv = _v.dot(normal); //que descomponemos en:
        vnorm = normal.copy().mult(nv);
        vtan = PVector.sub(_v, vnorm);
        _v = PVector.add(vtan, vnorm.mult(crP));
      }
    }
  } 

  void particleCollisionSpringModel()
  {
    ArrayList<Particle> sistema = new ArrayList<Particle>();
    int nump = 0;
    
    nump = _ps.getNumParticles();
    sistema = _ps.getParticleArray();
    
    for (int i = 0; i<nump; i++){
      Particle p = sistema.get(i);
           
      float dx = p._s.x - this._s.x;
      float dy = p._s.y - this._s.y;
      float d = sqrt(sq(dx) + sq(dy));
      float dm = 0.8 * (p._radius + _radius);
      
      if(d < dm){
        float angulo = atan2(dy, dx);
        
        float dirX = this._s.x + cos(angulo) * dm;
        float dirY = this._s.y + cos(angulo) * dm;
        
        float Fx = (dirX - p._s.x) *Ke;
        float Fy = (dirY - p._s.y) *Ke;
        
        this._v.x -=Fx;
        this._v.y -=Fy;
        p._v.x +=Fx;
        p._v.y +=Fy;
      }
    }
    
  }
  
  void display(color c) 
  {
    /*** ¡¡Esta función se debe modificar si la simulación necesita conversión entre coordenadas del mundo y coordenadas de pantalla!! ***/
    fill(c);
    noStroke();
    circle(_s.x, _s.y, 2.0*_radius);
  }
  
  // ...
  // ...
  // ...
}
