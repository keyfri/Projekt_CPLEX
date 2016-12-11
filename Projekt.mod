/*********************************************
 * OPL 12.6.3.0 Model
 * Author: Patryk
 * Creation Date: 17-11-2016 at 10:36:43
 *********************************************/

int m = 7;
int p = 2;
int l = 4;  //{A,B,C,D}
range i = 1..m;
range j = 1..m;
range N = 1..m;
range P = 1..p;
range edges = 1..16;

string markets[N] = ["M1", "M2", "M3", "M4", "M5", "M6", "M7"];
string products[P] = ["A", "B", "C", "D"];

tuple Edge {
  int id;
	string source;
	string destination;
	int cost;  // c
}



tuple KDO{
	string pr;  // K
	int amount;	 // D
	int order;   // O
}

tuple Purchaser {  // kupiec
  int id;
	string source;
	string destination;
	// KDOs shopping_list;
}

tuple Content {  // ilosc danego produktu w markecie i koszt jego pobrania
	string pr;   // l
	int buy;   // B
	int quantity;	 // Q

}

Content MarketContents[P] = [<"A", 5, 5>, <"B", 5, 5>, <"C", 5, 5>, <"D", 5, 5>];

Edge Edges[edges] = [
					<12, "M1", "M2", 2>,
					<21, "M2", "M1", 2>,
					<25, "M2", "M5", 2>,
					<52, "M5", "M2", 2>,
					<35, "M3", "M5", 4>,
					<53, "M5", "M3", 4>,					
					<13, "M1", "M3", 3>,
					<31, "M3", "M1", 3>,
					<14, "M1", "M4", 3>,
					<41, "M4", "M1", 3>,
					<46, "M4", "M6", 4>,
					<64, "M6", "M4", 4>,
					<67, "M6", "M7", 2>,
					<76, "M7", "M6", 2>,
					<75, "M7", "M5", 2>,
					<57, "M5", "M7", 2>];

/*						
Contents MarketContent[N]=[
		[<Product[1],2,5>, <Product[2],4,5>],
		[<Product[2],2,5>, <Product[3],2,5>, <Product[4],3,2>],
		[<Product[1],1,2>, <Product[3],2,5>],
		[<Product[3],2,2>, <Product[4],2,2>],
		[<Product[1],2,2>, <Product[2],2,2>, <Product[3],3,2>, <Product[4],3,2>],
		[<Product[3],1,2>, <Product[3],2,2>],	
		[<Product[1],3,5>, <Product[1],1,2>]
		];

KDO KDOs[1..p]=
		[
		[<Product[1],3,1>,<Product[2],3,2>,<Product[3],3,3>,<Product[4],5,4>],
		[<Product[1],4,3>,<Product[2],4,1>,<Product[3],5,3>]
		]
		;
*/
		
Purchaser Purchasers[1..p]=[
							<1, "M1","M5">, // +KDO
							<2, "M2","M6">];
							
							

dvar int x[edges][1..p];  // 0 lub 1 - ide albo nie ide
//dvar int+ x[N];
//dvar int V [ i ] [ j ][ P ];



minimize
sum(edge in edges) x[edge][p]*Edges[edge].cost; // + sum(market in N) y[market]*quantity*buy MarketContent[market];


subject to
{

forall (e in edges,p in 1..p){
(x[e][p] <= 0 && x[e][p] >= 0) ||
(x[e][p] <= 1 && x[e][p] >= 1);
}

forall (path in 1..p){
forall (e in edges){
if (
Purchasers[path].source==Edges[e].source 
||
Edges[e].destination==Purchasers[path].destination

)
x[e][p] >= 1;
}
}

 /*
  sum(edge in edges: Edges[edge].source == Purchasers[1].source) (x[edge]) - sum(edge in edges: Edges[edge].destination == Purchasers[1].destination) (x[edge]) == m-1;
	
	forall(node in 2..m){
		suma: sum(edge in edges: Edges[edge].source == Markets[node]) (x[edge]) - sum(edge in edges: Edges[edge].destination == Markets[node]) (x[edge]) == -1;
}
*/
}

