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
	var cplex_op_by_path = new IloCplex();
	var opl_op_by_path = new IloOplModel(op_by_path_definition, cplex_op_by_path);
	write("\tDone!\n");
	
	write("Preparing model for optimal placement by markets...");
	var op_by_market_source = new IloOplModelSource("optimal_placement_by_market.mod");
	var op_by_market_definition = new IloOplModelDefinition(op_by_market_source);
	var cplex_op_by_market = new IloCplex();
	var opl_op_by_market = new IloOplModel(op_by_market_definition, cplex_op_by_market);
	write("\tDone!\n");
	
	write("Generating models...");
	var model_input_data_source = new IloOplDataSource("mini.dat");
	opl_op_by_path.addDataSource(model_input_data_source);
	
	opl_op_by_path.generate();
	write("\tDone!\n");

    if (cplex_op_by_path.solve()){
    	writeln("OP BY PATH solved!");
    	writeln(opl_op_by_path.x);
    	writeln(opl_op_by_path.y);
    	writeln(opl_op_by_path.v);
    }	

}