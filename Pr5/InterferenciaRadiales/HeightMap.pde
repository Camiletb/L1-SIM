class HeightMap{
  final float _size;
  final int _nodes;
  float _tamCel;

  //position[column][row][axis]
  float _posdefault[][][];
  float _pos[][][];
  float posini;

  ArrayList<Wave> waves;
  Wave listaWaves[];

  float _tex[][][];

  PVector _p;
  /* Las siguientes variables sólo sirven para hacer
  el código más legible. */
  int idX = 0;
  int idY = 1;
  int idZ = 2;
  HeightMap(float size, int nodes){
    _size = size;
    _nodes = nodes;
    _tamCel = _size/_nodes;
    posini = _size/-2.0;

    init();
    draw();
    

    //waves
    waves = new ArrayList<Wave>();
  }
  
  //Inicialización de la malla
  void init(){
    _pos = new float[_nodes][_nodes][3];        //Tamaño del vPosición de cada punto de la malla
    _posdefault = new float[_nodes][_nodes][3]; //Por defecto
    
    _tex = new float[_nodes][_nodes][2];
    /* Inicialmente, los puntos de la malla tienen un valor en 
    x y en z, según su desplazamiento lateral y profundidad, 
    respectivamente. Pero la altura se establece en 0. */
    for(int i = 0; i < _nodes; i++){ // Desplazamiento lateral
      for(int j = 0; j < _nodes; j++){ // Profundidad
        _pos[i][j][idX] = posini + _tamCel/2f + j * _tamCel; //x = desplazamiento lateral
        _pos[i][j][idY] = 0;                    //y = altura
        _pos[i][j][idZ] = posini + _tamCel/2f + i * _tamCel; //z = profundidad

        _tex[i][j][0] =  (float)((j * _tamCel) /_size )* img.width;
        _tex[i][j][1] =  (float)((i * _tamCel) /_size )* img.height;
      }
      _p = new PVector();
    }
    _posdefault = _pos;
  }

  void draw(){
    if(display){
      //Dibujar la malla (con textura)
      noStroke();
      for(int i=0; i<_nodes-1; i++){
        beginShape(QUAD_STRIP);
        texture(img);
        for(int j=0; j<_nodes-1; j++){
          
          PVector posactual = new PVector(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ]);
          PVector posnext = new PVector(_pos[i+1][j][idX], _pos[i+1][j][idY], _pos[i+1][j][idZ]);
          vertex(posactual.x, posactual.y, posactual.z, _tex[i][j][0], _tex[i][j][1]);
          vertex(posnext.x, posnext.y, posnext.z, _tex[i+1][j][0], _tex[i][j][1]);
        }
        endShape();
      }
    }else {
      //Draw mesh (sin textura)
      stroke(210,80,80);
      strokeWeight(1);
      fill(255);
      for(int i=0; i<_nodes-1; i++){
        for(int j=0; j<_nodes-1; j++){
          line(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ], _pos[i+1][j][idX], _pos[i+1][j][idY], _pos[i+1][j][idZ]);
          line(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ], _pos[i][j+1][idX], _pos[i][j+1][idY], _pos[i][j+1][idZ]);
          line(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ], _pos[i+1][j+1][idX], _pos[i+1][j+1][idY], _pos[i+1][j+1][idZ]);
        }
        //Unir los puntos de la última columna de la matriz (desplazamiento lateral) (x máxima)
        line(_pos[_nodes-1][i][idX], _pos[_nodes-1][i][idY], _pos[_nodes-1][i][idZ], _pos[_nodes-1][i+1][idX], _pos[_nodes-1][i+1][idY], _pos[_nodes-1][i+1][idZ]);
        //Unir los puntos de la última fila de la matriz (z máxima)
        line(_pos[i][_nodes-1][idX], _pos[i][_nodes-1][idY], _pos[i][_nodes-1][idZ], _pos[i+1][_nodes-1][idX], _pos[i+1][_nodes-1][idY], _pos[i+1][_nodes-1][idZ]);
      }
    }
  }

  void addWave(Wave wave){
    this.waves.add(wave); //Añadir una onda
  }

  void update(){
    PVector delta;
    for(int i = 0; i < _nodes; i++){
      for(int j = 0; j < _nodes; j++){
        
        _p = new PVector(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ]);
         _posdefault[i][j][idX] = posini + _tamCel/2f + j * _tamCel; //x = desplazamiento lateral
         _posdefault[i][j][idY] = 0;                    //y = altura
         _posdefault[i][j][idZ] = posini + _tamCel/2f + i * _tamCel; //z = profundidad
         delta = new PVector(0, 0, 0);
        for(int k = 0; k < waves.size(); k++){
          delta.add(waves.get(k).deltaWavePoint(_p));
        
          _pos[i][j][idY] = delta.y;

          /*Para Gerstner*/
          PVector aux = new PVector(_posdefault[i][j][idX], _posdefault[i][j][idY], _posdefault[i][j][idZ]);
          if(mode ==2 ){
            _pos[i][j][idX] = aux.copy().x + delta.x;
            _pos[i][j][idZ] = aux.copy().z + delta.z;
            
          }
        }
      }
    }
  }
}
