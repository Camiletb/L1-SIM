class RadialWave{
     float  _a, _lambda, _vp;  
     PVector _centro; 
  public DirectionalWave(float A,float l, float vp, PVector centro){
    _a = A;
    _lambda = l;
    _vp = vp;
    _centro = new PVector().add(centro);
  }
  
  public update(float x, float y, float z, float time){
    float dist = sqrt((x - _centro.x) * (x - _centro.x) + ((z - _centro.z) * z - _centro.z));
    
    x = 0;
    z = 0;
    y = _a * cos((2*(PI)/_lambda)*(dist - (_vp * time));
  }
}
