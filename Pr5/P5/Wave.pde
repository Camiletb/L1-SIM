abstract class Wave{
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

    PVector delta;

    Wave(float amp, float lam, PVector dir, float dis, float vel){
        _A = amp;
        _lambda = lam;
        _dist = dis;
        _vp = vel;
        //_Q = inclinacion; set/get

        _f = 1/_T;
        _w = 2 * PI/_T;
        _k = 2 * PI/_lambda;
        _vp = _w/_k;
        _phi = _vp * _w;

        _dirN = dir.normalize();
    }
    abstract PVector deltaWavePoint(); //Perturbación en la malla

    PVector getDist(){
        return this._dirN;
    }
}
