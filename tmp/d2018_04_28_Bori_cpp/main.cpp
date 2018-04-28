#include <iostream>

using namespace std;

// REGI MODSZER:
//
// int minfv (int nap[], int meret)
// {
//     int minert=nap[0];
//     for (int i=1; i<meret; i++)
//     {
//         if (nap[i]<minert)
//         {
//             minert=nap[i];
//         }
//     }
//     return minert;
// }

int minind (int nap[], int meret)
{
    int index = 0;
    for (int i=1; i<meret; i++)
    {
        if (nap[i]<nap[index])
        {
            index=i;
        }
    }
    return index;
}

int sum (bool tomb[], int meret)
{
    int S=0;
    for (int i=0; i<meret; i++)
    {
        S=S+tomb[i];
    }
    return S;
}

// Bemenet
// 3 5
// 10 15 12 10 10  - elso telepules
// 11 11 11 11 20  - masodik telepules
// 12 16 16 16 20  - harmadik telepules
//
// Kimenet
// 2 1 2

// 3 5 10 15 12 10 10 11 11 11 11 20 12 16 16 16 20

int main()
{
    // valtozok beolvasasa N M
    int N, M;
    cin >> N >> M;
    // matrix letrehozasa
    int adat[M][N];
    // adatok beolvasasa
    for (int j=0; j<N; j++)
    {
        for (int i=0; i<M; i++)
        {
            cin >> adat[i][j];
        }
    }
    // Min. fuggveny keszitese
    // minden oszlopra Min. + tombbe: adott varosban van-e min
    bool mine[N] = {false};
    for (int i=0; i<M; i++)
    {
        // min lekerese
        int index=minind(adat[i],N);
        mine[index]=true;
        // vegig a tombon: ahol min,, ott a min-et  atrakni true-ra
    }

    // REGI MODSZER (egy for ciklussal tobb van benne)
    // --
    // bool mine[N] = {false};
    // for (int i=0; i<M; i++)
    // {
    //     // min lekerese
    //     int minimum=minfv(adat[i],N);
    //     for (int j=0; j<N; j++)
    //     {
    //         if (adat[i][j]==minimum)
    //         {
    //             mine[j]=true;
    //         }
    //     }
    //     // vegig a tombon: ahol min,, ott a min-et  atrakni true-ra
    // }

    //kimenet kiirasa
    cout << sum(mine,N);

    for (int i=0; i<N; i++)
    {
        if (mine[i])
        {
            cout << ' ' << i+1;
        }
    }

    return 0;
}
