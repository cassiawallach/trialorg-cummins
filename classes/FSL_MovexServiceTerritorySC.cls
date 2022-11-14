global class FSL_MovexServiceTerritorySC implements Schedulable {
    global void execute(SchedulableContext sc) {        
          FSL_MovexServiceTerritoryBatchProcess ST= new FSL_MovexServiceTerritoryBatchProcess();
          Database.executeBatch(ST, 10);
    }    
}