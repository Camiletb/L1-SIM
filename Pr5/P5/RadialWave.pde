class RadialWave extends Wave{

  PVector epi;
  float s;
  RadialWave(float amp, float lam, float vel, PVector dir, PVector centro){
    super(amp, lam, vel, dir, centro);
    //println("vel: " + vel);
    epi = centro;
    setEpi(epi);
  }

  public PVector deltaWavePoint(PVector p){
    //float dist = getDist();
    //float _distN = sqrt(pow(p.x, 2) + pow(p.z, 2));
    PVector d = PVector.sub(epi, p);
    s = d.mag();
    delta.x = 0;
    delta.y = _A * cos(2*PI/getLambda() * (s - getVp() * _simTime));
    delta.z = 0;

    return delta;
  }
}
