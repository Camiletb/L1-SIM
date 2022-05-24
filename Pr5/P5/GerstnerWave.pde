class GerstnerWave extends Wave{

  GerstnerWave(float amp, float lam, float vel, PVector dir, PVector centro){
    super(amp, lam, vel, dir, centro);
    //println("vel: " + vel);
    //epi = centro.get();
    //setEpi(epi);
  }

  public PVector deltaWavePoint(PVector p){
    //float dist = getDist();
    //float _distN = sqrt(pow(p.x, 2) + pow(p.z, 2));
    //PVector d = PVector.sub(epi, p);
    //s = d.mag();
    //Sacar el vector normalizado de propagación
    delta.x = _Q * _A * getDirN().x * cos(2*PI/getLambda() * (getDirN().dot(p) + (getVp() * _simTime)));
    delta.y = _A * sin(2*PI/getLambda() * (getDirN().dot(p) + (getVp() * _simTime)));
    delta.z = _Q * _A * getDirN().z *  cos(2*PI/getLambda() * (getDirN().dot(p) + (getVp() * _simTime)));

    return delta;
  }
}