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
    int d, descriptor;
    idInceput = idFinal = 1025;
    cin >> descriptor;
    for(d = 0; d < 255; d++)
    {
        if(v[d] == descriptor)
        {
            if(idInceput == 1025) idInceput = d;
            idFinal = d;
        }
        if(v[d] != descriptor && idFinal != 1025)
            break;
    }
    if(idInceput == 1025) // Dacă nu am găsit niciun descriptor
        cout << "(0,0)" << endl;
    else
        cout << "(" << idInceput << "," << idFinal << ")\n";
}

void DELETE():
{
    cin >> descriptor;
    for(int i = 0; i < 255; i++)
        if(v[i] == descriptor) w[i] = 0;
        else w[i] = v[i]
    
    for(int i = 0; i < 255; i++)
           { 
            v[i] = w[i];
            w[i] = 0;
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
    for(int i = 0; i <= 1024; i++)
        if(descriptor == 0)
        {
            if(v[i] != 0)
            {
                descriptor = v[i];
                idInceput = i;
            }
        }
        else if(descriptor != 0)
        {
            if(v[i] == descriptor)
                idFinal = i;
            else
            {
                cout << descriptor << ":  (" << idInceput << "," << idFinal << ")\n";
                descriptor = v[i];
                idInceput = i;
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