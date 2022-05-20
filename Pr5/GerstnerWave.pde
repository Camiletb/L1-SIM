class GerstnerWave{
     float  _a, _lambda, _vp, _q;  
     PVector _centro; 
  public DirectionalWave(float A,float l, float vp, PVector centro){
    _a = A;
    _lambda = l;
    _vp = vp;
    _centro = new PVector().add(centro);
    _q= PI*A*W; 
  }
  
  public update(float x, float y, float z, float time){
    x = _q * _a * _centro.x*cos((2*(PI)/_lambda) + _vp*time);
    y = _a * sin(2*(PI)/_lambda) + _vp*time);
    z = _q * _a * _centro.z*cos((2*(PI)/_lambda) + _vp*time);
  }
}
