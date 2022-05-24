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
    PVector _epi;
    Wave(float amp, float lam, float vel, PVector dir, PVector centro){
        _A = amp;
        _lambda = lam;
        _vp = vel;
        _epi = centro;
        //_Q = inclinacion; set/get

        _f = 1/_T;
        _w = 2 * PI/_T;
        _k = 2 * PI/_lambda;
        //_vp = _w/_k;
        _phi = _vp * _w;

        _dirN = dir.copy().normalize();
        _dist = db(dir.copy(), _epi);
        delta = new PVector();
        //_epi = new PVector(0, 0);
        println("A: " + _A + " lambda: " + _lambda + " vp: " + _vp + " Módulo dist: " + _dist + " dir normalizada: " + _dirN);
    }
    /*La siguiente función modifica el desplazamiento de un punto 
    de la malla en función del tipo de onda y el valor de sus parámetros*/
    abstract PVector deltaWavePoint(PVector p); //Perturbación en la malla

    float getDist(){
        return this._dist;
    }
    float getA(){
        return this._A;
    }
    float getLambda(){
        return this._lambda;
    }
    float getVp(){
        return this._vp;
    }
    PVector getDirN(){
        return this._dirN;
    }

    void setEpi(PVector epi){
        this._epi = epi;
    }

    float db(PVector v, PVector centro){
        PVector aux = v.copy().sub(centro);
        return sqrt(aux.x * aux.x + aux.z * aux.z);
    }
}
