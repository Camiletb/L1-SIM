public class Rocket 
{
  RocketType _type;

  Particle _casing;
  ArrayList<Particle> _particles;
  
  PVector _launchPoint;
  PVector _launchVel;  
  PVector _explosionPoint;
  
  color _color;
  boolean _hasExploded;

  Rocket(RocketType type, PVector pos, PVector vel, color c) 
  {
    _type = type;
    _particles = new ArrayList<Particle>();
    
    _launchPoint = pos.copy();
    _launchVel = vel.copy();
    _explosionPoint = new PVector(0.0, 0.0, 0.0);
    
    _color = c;
    _hasExploded = false;
    
    createCasing();
  }
  
  void createCasing()
  {
    // Codigo para crear la carcasa
    // ...
    // ...
    // ...
  }

  void explosion() 
  {
    // Codigo para utilizar el vector de partículas, creando particulas en él con diferentes velocidades para recrear distintos tipos de palmeras
    // ...
    // ...
    // ...

    switch (_type)
    {
      // ...
      // ...
      // ...
    }
  }

  void run() 
  {
    // Codigo con la lógica de funcionamiento del cohete. En principio no hay que modificarlo.
    // Si la carcasa no ha explotado, se simula su ascenso.
    // Si la carcasa ha explotado, se genera su explosión y se simulan después las partículas creadas.
    // Cuando una partícula agota su tiempo de vida, es eliminada.
    
    if (!_casing.isDead())
      _casing.run();
    else if (_casing.isDead() && !_hasExploded)
    {
      _numParticles--;
      _hasExploded = true;

      _explosionPoint = _casing.getPosition().copy();
      explosion();
    }
    else
    {
      for (int i = _particles.size() - 1; i >= 0; i--) 
      {
        Particle p = _particles.get(i);
        p.run();
        
        if (p.isDead()) 
        {
          _numParticles--;
          _particles.remove(i);
        }
      }
    }
  }
}
