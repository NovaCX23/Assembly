#include <bits/stdc++.h>
using namespace std;
int v[255], nrOp, nrFis, tipOp, descriptor, idInceput, idFinal;
double dimensiune;

void ADD()
{
    int j, d, ctSLib;
    cin >> nrFis;
    for(j = 0; j < nrFis; j++)
    {
        ctSLib = 0;
        cin >> descriptor >> dimensiune;
        dimensiune = ceil(dimensiune / 8);
        for(d = 0; d < 255; d++)
        {
            if(v[d] == 0)
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
        if(ctSLib != dimensiune)
        cout << descriptor << ":  (0,0)";
    }
}


void GET()
{
    int d, getDescriptor;
    idInceput = idFinal = 0;
    cin >> getDescriptor;
    for(d = 0; d < 255; d++)
        if(v[d] == getDescriptor)
        {
            if(idInceput == 0)idInceput = d;
            if(idInceput != 0)idFinal = d;
        }
    cout << "(" << idInceput << "," << idFinal << ")\n";
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