class GerstnerWave extends Wave{

  GerstnerWave(float amp, float lam, float vel, PVector dir, PVector centro){
    super(amp, lam, vel, dir, centro);
  }

  public PVector deltaWavePoint(PVector p){

    delta.x = _Q * _A * getDirN().x * cos(2*PI/getLambda() * (getDirN().dot(p) + (getVp() * _simTime)));
    //delta.x = 0;
    delta.y = _A * sin(2*PI/getLambda() * (getDirN().dot(p) + (getVp() * _simTime)));
    //delta.z = 0;
    delta.z = _Q * _A * getDirN().z *  cos(2*PI/getLambda() * (getDirN().dot(p) + (getVp() * _simTime)));

    return delta;
  }
}
