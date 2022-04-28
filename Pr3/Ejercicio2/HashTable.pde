class HashTable 
{
  ArrayList<ArrayList<Particle>> _table;
  
  int _numCells;
  float _cellSize;
  color[] _colors;
  
  HashTable(int numCells, float cellSize) 
  {
    _table = new ArrayList<ArrayList<Particle>>();
    
    _numCells = numCells; 
    _cellSize = cellSize;

    _colors = new color[_numCells];
    
    for (int i = 0; i < _numCells; i++)
    {
      ArrayList<Particle> cell = new ArrayList<Particle>();
      _table.add(cell);
      _colors[i] = color(int(random(0,256)), int(random(0,256)), int(random(0,256)), 150);
    }
  }
  
  void insertarParticula(Particle p, int celda){
    _table.get(celda).add(p);
  }
  
  //Funcion para conseguir la celda en la que se encuentra la particula a partir de su posicion.
  int getCelda(PVector pos){
    long x = int(floor(pos.x / _cellSize));
    long y = int(floor(pos.y / _cellSize));
    long z = int(floor(pos.z / _cellSize));
    
    //Informacion extraida de https://code-examples.net/es/q/5a7715
    long suma = 73856093 * x + 19349663 * y + 83492791 * z;
    
    int celda = int(suma % _table.size());
    return celda;
  }
  
  void limpiar(){
    for(int i = 0; i < _table.size(); i++){
      _table.get(i).clear();
    } //<>//
  }
}
