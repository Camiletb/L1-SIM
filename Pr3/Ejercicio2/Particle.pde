class Particle //<>//
{
  ParticleSystem _ps;
  int _id;
  int nuevaCelda;

  PVector _s;
  PVector _v;
  PVector _a;
  PVector _f;

  float _m;
  float _radius;
  color _color;

  ArrayList vecindario;

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

    vecindario = new ArrayList<Particle>();
  }

  void update()
  {
    updateForce();
    _a = PVector.div(_f, _m);
    _v.add(PVector.mult(_a, SIM_STEP));
    _s.add(PVector.mult(_v, SIM_STEP));
  }

  void updateForce()
  {
    PVector Fr = PVector.mult(_v, Kd);
    PVector Fg = PVector.mult(G, _m);
    PVector Ftotal = PVector.add(Fr, Fg);

    _f = Ftotal.copy();
  }

  void updateGrid() {
    int celda = grid.getCelda(_s);
    if (celda >= 0 && celda < grid._cells.size()) {
      nuevaCelda = celda;
    }
    grid.insertarParticula(this, nuevaCelda);
  }

  void updateHash() {
    int celda = hash.getCelda(_s);
    if (celda >= 0 && celda < hash._table.size()) {
      nuevaCelda = celda;
    }
    hash.insertarParticula(this, nuevaCelda);
  }

  void vecindarioGrid() {
    PVector a, b, c, d;
    int Ca, Cb, Cc, Cd;
    vecindario.clear();

    //Los cuatros vecinos de nuestra particula.
    a = new PVector(_s.x + _radius, _s.y);//Este
    b = new PVector(_s.x - _radius, _s.y);//Oeste
    c = new PVector(_s.x, _s.y + _radius);//Norte
    d = new PVector(_s.x, _s.y - _radius);//Sur

    //Teniendo las posiciones de los vecinos sacamos las celdas.
    Ca = grid.getCelda(a);
    Cb = grid.getCelda(b);
    Cc = grid.getCelda(a);
    Cd = grid.getCelda(a);

    if (Ca >= 0 && Cb >= 0 && Cc >= 0 && Cd >= 0) {
      for (int i = 0; i < grid._cells.get(Ca).size(); i++) {
        Particle p = grid._cells.get(Ca).get(i);
        vecindario.add(p);
      }
      if (Cb != Ca) {
        for (int i = 0; i < grid._cells.get(Cb).size(); i++) {
          Particle p = grid._cells.get(Cb).get(i);
          vecindario.add(p);
        }
      }
      if (Cc != Cb && Cc != Ca) {
        for (int i = 0; i < grid._cells.get(Cc).size(); i++) {
          Particle p = grid._cells.get(Cc).get(i);
          vecindario.add(p);
        }
      }
      if (Cd != Cc && Cd != Cb && Cd != Ca) {
        for (int i = 0; i < grid._cells.get(Cd).size(); i++) {
          Particle p = grid._cells.get(Cd).get(i);
          vecindario.add(p);
        }
      }
    }
  }

  void vecindarioHash() {
    PVector a, b, c, d;
    int Ca, Cb, Cc, Cd;
    vecindario.clear();

    //Los cuatros vecinos de nuestra particula.
    a = new PVector(_s.x + _radius, _s.y);//Este
    b = new PVector(_s.x - _radius, _s.y);//Oeste
    c = new PVector(_s.x, _s.y + _radius);//Norte
    d = new PVector(_s.x, _s.y - _radius);//Sur

    //Teniendo las posiciones de los vecinos sacamos las celdas.
    Ca = hash.getCelda(a);
    Cb = hash.getCelda(b);
    Cc = hash.getCelda(a);
    Cd = hash.getCelda(a);

    if (Ca >= 0 && Cb >= 0 && Cc >= 0 && Cd >= 0) {
      for (int i = 0; i < hash._table.get(Ca).size(); i++) {
        Particle p = hash._table.get(Ca).get(i);
        vecindario.add(p);
      }
      if (Cb != Ca) {
        for (int i = 0; i < hash._table.get(Cb).size(); i++) {
          Particle p = hash._table.get(Cb).get(i);
          vecindario.add(p);
        }
      }
      if (Cc != Cb && Cc != Ca) {
        for (int i = 0; i < hash._table.get(Cc).size(); i++) {
          Particle p = hash._table.get(Cc).get(i);
          vecindario.add(p);
        }
      }
      if (Cd != Cc && Cd != Cb && Cd != Ca) {
        for (int i = 0; i < hash._table.get(Cd).size(); i++) {
          Particle p = hash._table.get(Cd).get(i);
          vecindario.add(p);
        }
      }
    }
  }

  void planeCollision(ArrayList<PlaneSection> planes)
  {
    //Comprobación
    if (_s.y < 650) {
      for(int i = 0; i < planes.size();i++){
      PlaneSection p = planes.get(i);
      
      PVector n; 

      if(p.inside(_s))
      {
        n = p.getNormal();
        
        PVector pp = PVector.sub (p.getPoint1(), _s);
        float dcol = pp.dot(n);
    
        if (abs(dcol) < _radius)
        {
          float drestitucion = _radius -abs(dcol);
          PVector delta_pos = n.copy().mult(drestitucion);
          _s.add(delta_pos);//Restitución hecha
          
          float vn = _v.dot(n); //Obtenemos la velocidad normal
          
          //Descomponemos en tangencial y normal
          PVector Vn = n.copy().mult(vn);
          PVector Vt = PVector.sub(_v, Vn);
          _v = PVector.add (Vt, Vn.mult(-crP));
        }
       
      }
    }
    }
  }

  void particleCollisionSpringModel()
  {
    ArrayList<Particle> sistema = _ps.getParticleArray();
    int nump = _ps.getNumParticles();

    switch(estructuraini) {
    case NO:
      nump = _ps.getNumParticles();
      sistema = _ps.getParticleArray();
    break;
    case GRID:
      vecindarioGrid();
      nump = vecindario.size();
      sistema = vecindario;
    break;
    case HASH:
      vecindarioHash();
      nump = vecindario.size();
      sistema = vecindario;
    break;
    }
    

    for (int i = 0; i<nump; i++) {
      if (_id != i) {
        Particle p = sistema.get(i);

        float dx = p._s.x - this._s.x;
        float dy = p._s.y - this._s.y;
        float d = sqrt(dx * dx + dy * dy);
        float dm = 0.7 * (p._radius + _radius);

        if (d < dm) {
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
  }

  void display(color c)
  {
    /*** ¡¡Esta función se debe modificar si la simulación necesita conversión entre coordenadas del mundo y coordenadas de pantalla!! ***/
    fill(c);
    noStroke();
    circle(_s.x, _s.y, 2.0*_radius);
  }
}
