int m = ...;
int p = ...;
int n = ...;  // {A,B,C,D}


range M = 1..m;
range P = 1..p;
range N = 1..n;


int x[M][M][P] = ...;
int v[M][M][P] = ...;

int costs[M][M] = ...;
int demands[N][P] = ...;

int cost_of_purchasing[M][N] = ...;

{int} S_set[P] = ...;
int S[P] = ...;

{int} D_set[P] = ...;
int D[P] = ...;

{int} K[P] = ...;
int O[N][P] = ...;

dvar int+ q[M][N];
dvar int+ y[M][N][P] in 0..1;

minimize
  // 1
  sum(p in P, i in M, j in M)(costs[i][j]*x[i][j][p]) + sum(p in P, i in M, l in N)(cost_of_purchasing[i][l] * y[i][l][p]);

subject to
{
	// exact amount of products given in the demand list shouldbe purchased
	forall(l in N, p in P){
		con3: sum(i in M)(y[i][l][p]) == demands[l][p];
    }
    
        // product can only be purchased at a given market if it is actually available at that market
    forall(i in M, l in N){
    	con4: sum(p in P)(y[i][l][p]) - q[i][l] <= 0;
    }
    
    
    // the node should be included in the solution
    forall(i in M: i not in S_set[p], l in N, p in P){
    	con5: sum(j in M)(x[i][j][p]) - y[i][l][p] >= 0;    
    }
    
    
        // instructs that all products should be purchased in the order it has been requested
        // tutaj wywalem d_seta - pewnie trzeba poprawic
    forall(p in P, i in M, j in M: j not in D_set[p] && i not in D_set[p] && i != j, l in K[p], k in K[p] : l != k && O[l][p] == O[k][p] - 1){
    	m*(sum(a in M)(x[a][i][p]) - y[i][k][p]) - sum(r in M)(v[r][i][p]) + m >= m*y[j][l][p] - sum(r in M)(v[r][j][p]);    
    }
    
    
}


