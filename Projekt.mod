/*********************************************
 * OPL 12.6.3.0 Model
 * Author: Patryk
 * Creation Date: 17-11-2016 at 10:36:43
 *********************************************/

int m = 6;
int h = 2;
range l = 1..4;
range i = 1..m;
range j = 1..m;
range M = 1..m;
range P = 1..h;

float S  [ P ] = ... ; 
float c [ i ] [ j ] = ... ;
float b [ i ] [ l ] = ... ;
float d [ l ] [ P ] = ... ;
float q [ i ] [ l ] = ... ;
float O [ l ] [ P ] = ... ;

dvar int X [ i ] [ j ][ P ];
dvar int Y [ i ] [ j ][ P ];

minimize
sum ( p in P , i in M , j in M ) c [ i ][ j ] * X [ i ][ j ][ p ] + sum ( p in P, i in M , l in N ) b [ i ][ l ] * Y [ i ][ l ][ p ];

subject to
{
 
X >= 0;
X <= 1;
Y >=0 ;
Y <= 1;
}
