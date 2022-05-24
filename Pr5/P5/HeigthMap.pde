class HeightMap{
  final float _size;
  final int _nodes;
  float _tamCel;

  //position[column][row][axis]
  float _posdefault[][][];
  float _pos[][][];

  ArrayList<Wave> waves;
  Wave listaWaves[];

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
  
    //Init
    //...
    init();
    draw();
    
    //println("_tamCel: " + _tamCel);
    //waves
    waves = new ArrayList<Wave>();
    //waveArray
    listaWaves = new Wave[0];
  }
  
  //Inicialización de la malla
  void init(){

    //posini
    //float posini = _size/-2.0;                  //Punto de inicio
    float posini = _size/-2.0;                  //Punto de inicio
    _pos = new float[_nodes][_nodes][3];        //Tamaño del vPosición de cada punto de la malla
    _posdefault = new float[_nodes][_nodes][3]; //Por defecto
    
    /* Inicialmente, los puntos de la malla tienen un valor en 
    x y en z, según su desplazamiento lateral y profundidad, 
    respectivamente. Pero la altura se establece en 0. */
    for(int i = 0; i < _nodes; i++){ // Desplazamiento lateral
      for(int j = 0; j < _nodes; j++){ // Profundidad
        _pos[i][j][idX] = posini + _tamCel/2f + j * _tamCel; //x = desplazamiento lateral
        _pos[i][j][idY] = 0;                    //y = altura
        _pos[i][j][idZ] = posini + _tamCel/2f + i * _tamCel; //z = profundidad
        //println("Pos[" + i + "][" + j + "] = " + _pos[i][j][idX]);
        //println("Pos[" + i + "][" + j + "][" + idZ + "] = " + _pos[i][j][idZ]);
      }
      _p = new PVector();
      //_p = _pos.copy();
    }
  }

  void draw(){
    //Dibujar la malla
    //...
    //Draw mesh (sin textura)
    stroke(210,80,80);
    strokeWeight(1);
    fill(255);
    for(int i=0; i<_nodes-1; i++){
      for(int j=0; j<_nodes-1; j++){
        line(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ], _pos[i+1][j][idX], _pos[i+1][j][idY], _pos[i+1][j][idZ]);
        line(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ], _pos[i][j+1][idX], _pos[i][j+1][idY], _pos[i][j+1][idZ]);
        line(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ], _pos[i+1][j+1][idX], _pos[i+1][j+1][idY], _pos[i+1][j+1][idZ]);
        //point(_pos[i][j][0], _pos[i][j][1], _pos[i][j][2]);
      }
      //Unir los puntos de la última columna de la matriz (desplazamiento lateral) (x máxima)
      line(_pos[_nodes-1][i][idX], _pos[_nodes-1][i][idY], _pos[_nodes-1][i][idZ], _pos[_nodes-1][i+1][idX], _pos[_nodes-1][i+1][idY], _pos[_nodes-1][i+1][idZ]);
      //Unir los puntos de la última fila de la matriz (z máxima)
      line(_pos[i][_nodes-1][idX], _pos[i][_nodes-1][idY], _pos[i][_nodes-1][idZ], _pos[i+1][_nodes-1][idX], _pos[i+1][_nodes-1][idY], _pos[i+1][_nodes-1][idZ]);
    }

    //con textura
    //...
  }

  void addWave(Wave wave){
    //Añadir una onda
    this.waves.add(wave);
    /*waveArray = new Wave[waves.size()];
    for(int i=0; i<waves.size(); i++){
      waveArray[i] = waves.get(i);
    }*/
  }

  /*void display()
  {
    draw();
  }*/

  void update(){
    PVector delta;
    for(int i = 0; i < _nodes; i++){
      for(int j = 0; j < _nodes; j++){
        //_pos[i][j][idY] = _posdefault[i][j][idY];
        for(int k = 0; k < listaWaves.length; k++){
          _p = new PVector(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ]);
          delta = listaWaves[k].deltaWavePoint(_p);
          _pos[i][j][idY] += delta.y;
          //_pos[i][j][idY] += waves.get(k).getHeight(_pos[i][j][idX], _pos[i][j][idZ]);
        }
      }
    }
    //waveArray = waves.toArray(waveArray);
    //draw();
  }
  
  
  void run(){
    //display();
    update();
    draw();
  }  
}
