/*********************************************
 * OPL 12.6.3.0 Model
 * Author: Patryk
 * Creation Date: 17-11-2016 at 10:36:43
 *********************************************/

int m = 7;
int p = 2;
int n = 4;  //{A,B,C,D}

range M = 1..m;
range P = 1..p;
range N = 1..n;

{int} S_set = {1, 2};
int S[P] = [1, 2];

{int} D_set = {5,6};
int D[P] = [5, 6];

int costs[M][M] = [
	[0, 2, 3, 3, 0, 0, 0],
	[2, 0, 0, 0, 2, 0, 0],
	[3, 0, 0, 0, 4, 0, 0],
	[3, 0, 0, 0, 0, 4, 0],
	[0, 2, 4, 0, 0, 0, 2],
	[0, 0, 0, 4, 0, 0, 2],
	[0, 0, 0, 0, 2, 2, 0]
];

int cost_of_purchasing[M][N] = [
	[2, 4, 0, 0],
	[0, 2, 2, 3],
	[1, 0, 2, 0],
	[0, 0, 2, 2],
	[2, 2, 3, 3],
	[0, 0, 1, 2],
	[3, 0, 0, 1]
];


int demands[N][P] = [
	[3, 4],
	[3, 4],
	[3, 5],
	[5, 0]
];

int q[M][N] = [
	[5, 5, 0, 0],
	[0, 5, 5, 2],
	[2, 0, 5, 0],
	[0, 0, 2, 2],
	[2, 2, 2, 2],
	[0, 0, 2, 2],
	[5, 0, 0, 2]
];

{int} K[P] = [
	{1, 2, 3, 4},
	{1, 2, 3}
];

int O[N][P] = [
	[1, 2],
	[2, 1],
	[3, 5],
	[4, 0]
];

dvar int+ x[M][M][P] in 0..1;
dvar int+ y[M][N][P] in 0..1;
dvar int+ v[M][M][P];

minimize
  // 1
  sum(p in P, i in M, j in M)(costs[i][j]*x[i][j][p]) + sum(p in P, i in M, l in N)(cost_of_purchasing[i][l] * y[i][l][p]);


subject to
{
	// 2 ???
	sum(j in M, i in M, p in P)(x[j][i][p]) + sum(j in M, i in M, p in P: i == S[p])(1) == 
	sum(i in M, r in M, p in P)(x[i][r][p]) + sum(i in M, r in M, p in P: i == D[p])(1);
	
	// 3
	forall(l in N, p in P){
		con3: sum(i in M)(y[i][l][p]) == demands[l][p];
    }
    
    // 4
    forall(i in M, l in N){
    	con4: sum(p in P)(y[i][l][p]) - q[i][l] <= 0;
    }
    
    // 5
    forall(i in M: i not in S_set, l in N, p in P){
    	con5: sum(j in M)(x[i][j][p]) - y[i][l][p] >= 0;    
    }
    
    // 6
    forall(i in M, p in P){
    	con6: sum(j in M)(x[j][j][p]) <= 1;    
    }
    
    // 7
    forall(i in M, j in M, p in P){
    	con7: v[j][i][p] <= m*x[i][j][p];    
    } 
    
    // 8
    forall(i in M: i not in D_set, p in P){
    	con8: sum(j in M)(v[j][i][p]) + sum(j in M: i==S[p])(m) == sum(j in M)(v[i][j][p] + x[i][j][p]);
    }
    
    // 9
    forall(p in P, i in M, j in M: j not in D_set && i != j, l in K[p], k in K[p] : l != k && O[l][p] == O[k][p] - 1){
    	m* sum(a in M)(x[a][i][p] - y[i][k][p]) - sum(r in M)(v[r][i][p]) + m >= m*y[j][l][p] - sum(r in M)(v[r][j][p]);    
    }
}    

