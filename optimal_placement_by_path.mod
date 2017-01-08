/*********************************************
 * OPL 12.6.3.0 Model
 * Author: Patryk
 * Creation Date: 17-11-2016 at 10:36:43
 *********************************************/

int m = ...;
int p = ...;
int n = ...;  // {A,B,C,D}

range M = 1..m;
range P = 1..p;
range N = 1..n;

{int} S_set[P] = ...;
int S[P] = ...;

{int} D_set[P] = ...;
int D[P] = ...;

int costs[M][M] = ...;

int cost_of_purchasing[M][N] = ...;


int demands[N][P] = ...;

int q[M][N] = ...;

{int} K[P] = ...;

int O[N][P] = ...;

dvar int+ x[M][M][P] in 0..1;
dvar int+ y[M][N][P] in 0..1;
dvar int+ v[M][M][P];

minimize
  // 1
  sum(p in P, i in M, j in M)(costs[i][j]*x[i][j][p]) + sum(p in P, i in M, l in N)(cost_of_purchasing[i][l] * y[i][l][p]);


subject to
{
	// 2 flow conservation - for any node i, the sum of in-degree edges is equal to
    //the sum of out-degree edges, which should be 1
	forall(i in M, p in P){
		con2: sum(j in M)(x[j][i][p]) + sum(a in {1}: i in S_set[p])(1) == 
		      sum(r in M: r not in S_set[p])(x[i][r][p]) + sum(a in {1}: i in D_set[p])(1);
	}	
	
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
    
    // avoids forming cycles in the solution path
    forall(i in M, p in P){
    	con6: sum(j in M)(x[i][j][p]) <= 1;
    }
    
    forall(i in M, p in P, j in M){
    	con6_2: x[i][j][p] + x[j][i][p] <= 1;
    }
    
    // states that each value of v i,j,p should be less then m if x i,j,p = 1 or equal zero otherwise
    forall(i in M, j in M, p in P){
    	con7: v[i][j][p] <= m*x[i][j][p];    
    } 
    
    // is used to calculate the values of v i,j,p along the path formed by the solution
    forall(i in M: i not in D_set[p], p in P){
    	con8: sum(j in M)(v[j][i][p]) + sum(a in {1}: i in S_set[p])(m) == sum(j in M)(v[i][j][p] + x[i][j][p]);
    }

    // instructs that all products should be purchased in the order it has been requested
    forall(p in P, i in M, j in M: j not in D_set[p] && i not in D_set[p] && i != j, l in K[p], k in K[p] : l != k && O[l][p] == O[k][p] - 1){
    	m*(sum(a in M)(x[a][i][p]) - y[i][k][p]) - sum(r in M)(v[r][i][p]) + m >= m*y[j][l][p] - sum(r in M)(v[r][j][p]);    
    }
    
    
    // wymuszenie poprawnego liczenia
    forall(i in M, j in M, p in P){
    	v[i][j][p] <= m-1;
    }
    
    // blokada sciezek w przypadku uzycia
    forall(i in M, j in M: costs[i][j] == 0){
    	    sum(p in P)(x[i][j][p]) == 0;
    }
}    


execute {
for (p in P){ 
	for (i in M){
		for(j in M){	
			writeln(i, j, p, x[i][j][p], " ", x[i][j][p]*costs[i][j]);
			}
 		}			
	}
}
