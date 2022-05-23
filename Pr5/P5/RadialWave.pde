class RadialWave extends Wave{
  RadialWave(float amp, float lam, PVector dir, float dis, float vel){
    //super(amp, direc, dist, vp);
    super(amp, lam, dir, dis, vel);
    
  }

  PVector deltaWavePoint(){
    delta.x = 0;
    delta.y = 0;
    PVector dist = getDist();
    float _distN = dist.mag();
    delta.z = _A * sin(_w * _distN - _phi * SIM_STEP);

    return delta;
  }
}
