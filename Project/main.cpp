#include <bits/stdc++.h>
using namespace std;
int v[255], nOperatii, nFisiere, codOperatie, descriptor, idInceput, idFinal;
double dimensiune;

void ADD()
{
    int j, d, countSpatiiLibere;
    cin >> nFisiere;
    for(j = 0; j < nFisiere; j++)
    {
        countSpatiiLibere = 0;
        cin >> descriptor >> dimensiune;
        dimensiune = ceil(dimensiune / 8);
        for(d = 0; d < 255; d++)
            if(v[d] == 0)
            {
                countSpatiiLibere ++;
                if(countSpatiiLibere == dimensiune)
                    break;
            }
            else
            {
                countSpatiiLibere = 0;
            }

        if(countSpatiiLibere == dimensiune)
        {
            idInceput = d + 1 - dimensiune;
            idFinal = d;
            cout << descriptor << ":  " << "(" << idInceput << "," << idFinal << ")\n";

            for(d = idInceput; d <= idFinal; d++)
                v[d] = descriptor;
        }
        else
        {
            cout << descriFinalptor << ":  (0,0)";
        }
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
    cin >> nOperatii;

    for(i = 0; i < nOperatii; i++)
    {
        cin >> codOperatie;

        if(codOperatie == 1)
            ADD();
        else if(codOperatie == 2)
            GET();
        //else if(codOperatie == 3)
           // DELETE();
       // else if(codOperatie == 4)
           // DEFRAMENTATION();
    }


    return 0;
}