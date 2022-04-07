class Grid 
{
  ArrayList<ArrayList<Particle>> _cells;
  
  int _nRows; 
  int _nCols; 
  int _numCells;
  float _cellSize;
  color[] _colors;
  
  Grid(int rows, int cols) 
  {
    _cells = new ArrayList<ArrayList<Particle>>();
    
    _nRows = rows;
    _nCols = cols;
    _numCells = _nRows*_nCols;
    _cellSize = width/_nRows;
    
    _colors = new color[_numCells];
    
    for (int i = 0; i < _numCells; i++) 
    {
      ArrayList<Particle> cell = new ArrayList<Particle>();
      _cells.add(cell);
      _colors[i] = color(int(random(0,256)), int(random(0,256)), int(random(0,256)), 150);
    }
  }

  // ...
  // ...
  // ...
}
