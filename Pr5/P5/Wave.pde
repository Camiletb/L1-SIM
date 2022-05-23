class Wave{
    //Parámetros de la onda
    /*Radial + Direccional + Gerstner*/
    float _A;      //amplitud
    float _lambda; //longitud de onda
    float _dist;   //distancia del frente de onda al epicentro
    float _vp;     //velocidad de propagación
    PVector _dirN; //dirección normalizada de la onda
    float _Q;      //factor de inclinación de la cresta de la onda
    float _phi;    //fase de la onda

    /*Otros parámetros*/
    float _T;  //periodo
    float _f;  //frecuencia
    float _w;  //frecuencia angular
    float _k;  //número de onda

    Wave(float amplitud, float longitud, float distancia, float velocidad, PVector direccion, float inclinacion){
        _A = amplitud;
        _lambda = longitud;
        _dist = distancia;
        _vp = velocidad;
        _Q = inclinacion;

        _f = 1/_T;            //frecuencia
        _w = 2 * PI/_T;       //frecuencia angular
        _k = 2 * PI/_lambda;  //número de onda
        _vp = _w/_k;
        _phi = _vp * _w;
    }
  
}
