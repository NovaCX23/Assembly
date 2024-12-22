#include <bits/stdc++.h>
using namespace std;
int v[255][255], nrOp, nrFis, tipOp, descriptor, idInceput, idFinal;
double dimensiune;

void ADD()
{
    int j, d, ctSLib;
    cin >> nrFis;
    for(j = 0; j < nrFis; j++)
    {
        cin >> descriptor >> dimensiune;
        dimensiune = ceil(dimensiune / 8);
        
        for(k = 0; k < 255; k++)
        {
            ctSLib = 0;
            for(d = 0; d < 255; d++)
            {
                if(v[k][d] == 0)
                {
                    ctSLib ++;
                    if(ctSLib == dimensiune)
                        {
                            idInceput = d + 1 - dimensiune;
                            idFinal = d;
                            cout << descriptor << ":  " << "(" << idInceput << "," << idFinal << ")\n";
                            
                            for(d = idInceput; d <= idFinal; d++)
                                v[d] = descriptor;
                            break;
                        }
                }
                else ctSLib = 0;
            }
        }
        if(ctSLib != dimensiune)
        cout << descriptor << ":  (0,0)";
    }
}



void GET()
{
    int i, j, descriptor;
    idInceput = idFinal = 1025;
    cin >> descriptor;
    for(i = 0; i < 255; i++)
        for(j = 0; j < 255; j++)
        {
            
            if(v[i][j] == descriptor)
            {
                if(idInceput == 1025) idInceput = d;
                idFinal = d;
            }
            if(v[i][j] != descriptor && idFinal != 1025)
                break;
        }
    if(idInceput == 1025) // Dacă nu am găsit niciun descriptor
        cout << "(0,0)" << endl;
    else
        cout << "(" << idInceput << "," << idFinal << ")\n";
}

void DELETE():
{
    int i, j;
    cin >> descriptor;
    for(i = 0; i < 255; i++)
    {
        for(j = 0; j < 255; j++)
            if(v[i][j] == descriptor) w[i][j] = 0;
            else w[i][j] = v[i][j]
    }
    for(int i = 0; i < 255; i++)
        for(int j = 0; j < 255; j++)
           { 
                v[i][j] = w[i][j];
                w[i][j] = 0;
           }
    
}   


void DEFRAG():
{
        int w[256] = {0}, counter_w = 0;

        for(int i = 0; i < 255; i++)
            if(v[i] != 0)w[counter_w++] = v[i];

        for(int i = 0; i < 255; i++)
           { 
            v[i] = w[i];
            w[i] = 0;
           }
}




void afisare():
{
    int lines = 8, columns = 8;
    
    int i = 0, j = 0;
    for(i = 0; i <= lines; i++)
    {
        for(j = 0; j <= columns; j++)
        {   
            if(descriptor == 0)
            {
                if(v[i][j] != 0)
                {
                    descriptor = v[i][j];
                    idInceput = j;
                }
            }
            else if(descriptor != 0)
            {
                if(v[i][j] == descriptor) idFinal = j;
                else
                {
                    cout << descriptor << ":  (" << indexLine << "," << idInceput << ")" << "," << " (" << indexLine << "," << idFinal << ")\n";
                    descriptor = v[i][j];
                    idInceput = j;
                }
            }
        }
    }

}






int main()
{
    int i;
    cin >> nrOp;
    for(i = 0; i < nrOp; i++)
    {
        cin >> tipOp;
        if(tipOp == 1)
            ADD();
        else if(tipOp == 2)
            GET();
        else if(codOperatie == 3)
            DELETE();
        else if(codOperatie == 4)
            DEFRAMENTATION();
    }
    return 0;
}