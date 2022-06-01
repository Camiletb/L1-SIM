class DirectionalWave extends Wave{

  DirectionalWave(float amp, float lam, float vel, PVector dir, PVector centro){
    super(amp, lam, vel, dir, centro);
  }

  public PVector deltaWavePoint(PVector p){
    //Sacar el vector normalizado de propagación
    delta.x = 0;
    delta.y = _A * sin(2*PI/getLambda() * (getDirN().dot(p) + (getVp() * _simTime)));
    delta.z = 0;

    return delta;
  }
}
