class Particle  //<>//
{
  final float Kd = 0.1;   // Constante de rozamiento
  float crP = -0.6; //Constante de pérdida de energía bola-plano
  float crB = 0.5; //Constante de pérdida de energía bola-bola
  ParticleSystem _ps;
  int _id; //id de la partícula

  PVector _s; //pos
  PVector _v; //vel
  PVector _a; //ace
  PVector _f; //fue

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
    updateForce();
    PVector fuerza; //auxiliar para copiar el vector f
    fuerza = _f.copy();
    _a = PVector.div(fuerza, _m);
    _v.add(PVector.mult(_a, SIM_STEP));
    _s.add(PVector.mult(_v, SIM_STEP));
  }

  void updateForce()
  {  
    //Fuerza normal
    //
  }

  void planeCollision(ArrayList<PlaneSection> planes) //Colisión partícula-plano
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

  void particleCollisionVelocityModel()
  {
    ArrayList<Particle> sistema = new ArrayList<Particle>(_ps.getParticleArray());
    for (int i = 0 ; i < _ps.getNumParticles(); i++){
      if(_id != i){ //Todas las partículas menos la nuestra
        Particle p = sistema.get(i);
        PVector vcol = PVector.sub(_s, p._s);
        float distance =vcol.mag();
        float minDist = p._radius + _radius;
        
        if(distance < minDist)
        {
           PVector dist = new PVector();
           dist.set(vcol);
           dist.normalize();
           
           //Vectores Normales
           PVector n1 = PVector.mult(dist, (_v.dot(vcol) / distance));
           PVector n2 = PVector.mult(dist, (p._v.dot(vcol) / distance));
          
           //Vectores Tangenciales
           PVector t1 = PVector.sub(_v, n1);
           PVector t2 = PVector.sub(p._v, n2);
          
           float L = (_radius + p._radius) - distance;
           
           PVector res = PVector.sub(n1, n2);
           float vrel = res.mag();
          
          
           PVector multN1 = PVector.mult(n1, -L/vrel);
           _s.add(multN1);
           
           PVector multN2 = PVector.mult(n2, -L/vrel);
           p._s.add(multN2);
           
           float u1 = n1.dot(vcol)/distance;
           float u2 = n2.dot(vcol)/distance;
           
           //Velocidades de salida
           float v1 = ((_m-_m)*u1 + 2*_m*u2) / (_m+_m);
           n1 = PVector.mult(dist, v1);
           
           float v2 = ((_m - _m)*u2 + 2*_m*u1) / (_m+_m);
           n2 = PVector.mult(dist, v2);
           
           _v = PVector.add(n1.mult(crB), t1);
           p._v = PVector.add(n2.mult(crB), t2);          
        }
      }
    }
  }
  
  void particleCollisionSpringModel()
  { 
  }
  
  void display() 
  {
    /*** ¡¡Esta función se debe modificar si la simulación necesita conversión entre coordenadas del mundo y coordenadas de pantalla!! ***/
    noStroke();
    if(triggers[_id]){ //Si se ha seleccionado esa bola
      for(int u = 0; u < tam; u++)
        marca[u] = tam+1;
      marca[_id]=_id;
      fill(180, 0, 60); //píntamela de rojo
      circle(_s.x, _s.y, 2.0*_radius);
      line(this._s.x, this._s.y, this._s.x - 160, this._s.y + 160);
    }else{ //sino, de blanco
      fill(255);
      circle(_s.x, _s.y, 2.0*_radius);
    }
    fill(255);
  }
  
  
  // ...
  // ...
  // ...
}
