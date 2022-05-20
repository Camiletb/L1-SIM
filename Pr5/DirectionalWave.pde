class DirectionalWave{
     float  _a, _lambda, _vp, _s,  
     PVector _centro; 
  public DirectionalWave(float A,float l, float vp, PVector centro){
    _a = A;
    _lambda = l;
    _vp = vp;
    _centro = new PVector().add(centro);
  }
  
  public update(float x, float y, float z){
    x = 0;
    z = 0;
    y = _a * sin((2*(PI)/_lambda)*()
  }
}
