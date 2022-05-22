class HeightMap{
  private final int _size;
  private final int _nodes;
  private final int _tamCel;
  
  //position[column][row][axis]
  private float _posdefault[][][];
  private float _pos[][][];
  
  protected ArrayList<Wave> waves;
  private Wave waveArray[];
  
  /* Las siguientes variables sólo sirven para hacer
  el código más legible. */
  int idX = 0;
  int idY = 1;
  int idZ = 2;
  HeightMap(int size, int nodes){
    _size = size;
    _nodes = nodes;
    _tamCel = _size/_nodes;
    
    //Init
    //...
    init();
    
    //waves
    //waveArray
  }
  
  //Inicialización de la malla
  void init(){

    //posini
    float posini = _size/-2.0;                  //Punto de inicio
    _pos = new float[_nodes][_nodes][3];        //Posición de cada punto de la malla
    _posdefault = new float[_nodes][_nodes][3]; //Por defecto
    
    /* Inicialmente, los puntos de la malla tienen un valor en 
    x y en z, según su desplazamiento lateral y profundidad, 
    respectivamente. Pero la altura se establece en 0. */
    for(int i = 0; i < _nodes-1; i++){ // Desplazamiento lateral
      for(int j = 0; j < _nodes-1; j++){ // Profundidad
        _pos[i][j][idX] = posini + j * _tamCel; //x = desplazamiento lateral
        _pos[i][j][idY] = 0;                    //y = altura
        _pos[i][j][idZ] = posini + i * _tamCel; //z = profundidad

      }
    }
    //Clonamos pos para tener una posición por defecto
    _posdefault = _pos;
  }

  void draw(){
    //Dibujar la malla
    //...
    stroke(255);
    strokeWeight(1);
    for(int i=0; i<_nodes-1; i++){
      for(int j=0; j<_nodes-1; j++){
        line(_pos[i][j][idX], _pos[i][j][idY], _pos[i][j][idZ], _pos[i+1][j][idX], _pos[i+1][j][idY], _pos[i+1][j][idZ]);
        //point(_pos[i][j][0], _pos[i][j][1], _pos[i][j][2]);
      }
    }
  }
}
