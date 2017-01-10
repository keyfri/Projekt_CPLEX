main{
	write("Preparing model for optimal placement by path...");
	var op_by_path_source = new IloOplModelSource("optimal_placement_by_path.mod");
	var op_by_path_definition = new IloOplModelDefinition(op_by_path_source);
	var cplex_op_by_path = new IloCplex();
	var opl_op_by_path = new IloOplModel(op_by_path_definition, cplex_op_by_path);
	write("\tDone!\n");
	
	write("Preparing model for optimal placement by markets...");
	var op_by_market_source = new IloOplModelSource("optimal_placement_by_market.mod");
	var op_by_market_definition = new IloOplModelDefinition(op_by_market_source);
	var cplex_op_by_market = new IloCplex();
	write("\tDone!\n");
	
	write("Generating models...");
	var model_input_data_source = new IloOplDataSource("big_different_sources.dat");
	
	opl_op_by_path.addDataSource(model_input_data_source);
	opl_op_by_path.generate();
		
	write("\tDone!\n");

    
    for(var c=0; c<5; c++){
  		      
	    writeln("========== ITERATION NUMBER " + c, " ==========");
	
	            
	    var result;
	    if (cplex_op_by_path.solve()){
	    	writeln("Find path function value:\t\t", cplex_op_by_path.getObjValue());
	    	
	    	writeln("Solution x:")
			for(var p in opl_op_by_path.P){
	    		writeln("Purchaser no. ", p)
		    	for(var i in opl_op_by_path.x.solutionValue){
		    		for(var j in opl_op_by_path.x.solutionValue[i]){
	    				if (opl_op_by_path.x.solutionValue[i][j][p] == 1){
	    					writeln(i, "\t -> ", j);
	    				}
       				}	    				
     			}	    			    	
	    	}
	    }	
	    
		var opl_op_by_market = new IloOplModel(op_by_market_definition, cplex_op_by_market);
		var data = new IloOplDataElements(); 
		data.m = opl_op_by_path.m;
		data.p = opl_op_by_path.p;
		data.n = opl_op_by_path.n;
		data.x = opl_op_by_path.x.solutionValue;
		data.v = opl_op_by_path.v.solutionValue;
		data.costs = opl_op_by_path.costs;
		data.demands = opl_op_by_path.demands;
		data.cost_of_purchasing = opl_op_by_path.cost_of_purchasing;
		data.S_set = opl_op_by_path.S_set;
		data.S = opl_op_by_path.S;
		data.D_set = opl_op_by_path.D_set;
		data.D = opl_op_by_path.D;
		data.K = opl_op_by_path.K;
		data.O = opl_op_by_path.O;
		opl_op_by_market.addDataSource(data);
		opl_op_by_market.generate();
		
		
		if (cplex_op_by_market.solve()){
			writeln("Set markets function value:\t\t", cplex_op_by_market.getObjValue());
	    	
	    	writeln("Solution q:")
			for(var m in opl_op_by_market.M){	
				var is_market = 0;
				for(var n in opl_op_by_market.N){
					if(opl_op_by_market.q[m][n] > 0){
						if(!is_market){
							writeln("Market no. ", m)
							is_market = 1;					
						}
						writeln("Product ", n, ": \t", opl_op_by_market.q[m][n])
					}
 				}
	    	}
		}		
				
		var opl_op_by_path = new IloOplModel(op_by_path_definition, cplex_op_by_path);
		var data = new IloOplDataElements(); 
		data.m = opl_op_by_market.m;
		data.p = opl_op_by_market.p;
		data.n = opl_op_by_market.n;
		data.costs = opl_op_by_market.costs;
		data.demands = opl_op_by_market.demands;
		data.cost_of_purchasing = opl_op_by_market.cost_of_purchasing;
		data.q = opl_op_by_market.q.solutionValue;
		data.S_set = opl_op_by_market.S_set;
		data.S = opl_op_by_market.S;
		data.D_set = opl_op_by_market.D_set;
		data.D = opl_op_by_market.D;
		data.K = opl_op_by_market.K;
		data.O = opl_op_by_market.O;
		opl_op_by_path.addDataSource(data);
		opl_op_by_path.generate();
	}
}