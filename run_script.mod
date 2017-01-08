main{

thisOplModel.generate();

	//helper functions
	function prepareData(source){
		write("Preparing data for node: ", source);
		
		thisOplModel.sources.clear();
		thisOplModel.sources.add(source);
		
		var data = new IloOplDataElements();
		data.Source = thisOplModel.sources;
		
		write("\tDone!\n");
		return data;
	};
	
	
	
	write("Preparing model for optimal placement by path...");
	var op_by_path_source = new IloOplModelSource("optimal_placement_by_path.mod");
	var op_by_path_definition = new IloOplModelDefinition(op_by_path_source);
	var cplex_op_by_path_model = new IloCplex();
	var op_by_path_model = new IloOplModel(op_by_path_definition, cplex_op_by_path_model);
	write("\tDone!\n");
	
	write("Preparing model for optimal placement by markets...");
	var op_by_market_source = new IloOplModelSource("optimal_placement_by_market.mod");
	var op_by_market_definition = new IloOplModelDefinition(op_by_market_source);
	var cplex_op_by_market_model = new IloCplex();
	var op_by_market_model = new IloOplModel(op_by_market_definition, cplex_op_by_market_model);
	write("\tDone!\n");
	
	
	


}