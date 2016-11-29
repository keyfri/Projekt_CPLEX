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

tuple Market{
	int number;
	string name;
	// Contents content;
}

tuple Edge {
  int id;
	Market source;
	Market destination;
	int cost;  // c
}


tuple Product{  // l
	int id;
	string name;
}


tuple KDO{
	Product pr;  // K
	int amount;	 // D
	int order;   // O
}

tuple Purchaser {  // kupiec
  int id;
	Market source;
	Market destination;
	// KDOs shopping_list;
}

tuple Content {  // ilosc danego produktu w markecie i koszt jego pobrania
	Product pr;   // l
	int buy;   // B
	int quantity;	 // Q

}

tuple MarketContent {  // wartosci dla danego marketu
	Content content;
}

Market Markets[N] = [<1, "M1">, <2, "M2">, <3, "M3">, <4, "M4">, <5, "M5">, <6, "M6">, <7, "M7">]; // do Marktetow trzeba dorzucic co tam mozna kupic = MarketContent

Edge Edges[edges] = [
					<12, Markets[1], Markets[2], 2>,
					<21, Markets[2], Markets[1], 2>,
					<25, Markets[2], Markets[5], 2>,
					<52, Markets[5], Markets[2], 2>,
					<35, Markets[3], Markets[5], 4>,
					<53, Markets[5], Markets[3], 4>,					
					<13, Markets[1], Markets[3], 3>,
					<31, Markets[3], Markets[1], 3>,
					<14, Markets[1], Markets[4], 3>,
					<41, Markets[4], Markets[1], 3>,
					<46, Markets[4], Markets[6], 4>,
					<64, Markets[6], Markets[4], 4>,
					<67, Markets[6], Markets[7], 2>,
					<76, Markets[7], Markets[6], 2>,
					<75, Markets[7], Markets[5], 2>,
					<57, Markets[5], Markets[7], 2>];


Product Products[1..l] = [<1, "A">, <2, "B">, <3, "C">, <4, "D">];

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
							<1, Markets[1],Markets[5]>, // +KDO
							<2, Markets[2],Markets[6]>];
							
							

dvar int+ x[edges];  // 0 lub 1 - ide albo nie ide
//dvar int+ x[N];
//dvar int V [ i ] [ j ][ P ];



minimize
sum(edge in edges) x[edge]*Edges[edge].cost; // + sum(market in N) y[market]*quantity*buy MarketContent[market];


subject to
{
 
  sum(edge in edges: Edges[edge].source == Purchasers[1].source) (x[edge]) - sum(edge in edges: Edges[edge].destination == Purchasers[1].destination) (x[edge]) == m-1;
	
	forall(node in 2..m){
		suma: sum(edge in edges: Edges[edge].source == Markets[node]) (x[edge]) - sum(edge in edges: Edges[edge].destination == Markets[node]) (x[edge]) == -1;
}
}

