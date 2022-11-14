global class CSS_deleteSolSympScheduled implements Schedulable{

    global void execute(SchedulableContext sc){
        //Date dtToday = system.today()-1;
        String query = 'select id from CSS_Solutions__c where CreatedDate <= Last_N_Days:1 and User_Name__c != null';
        CSS_deleteCSSSolutions delBatch = new CSS_deleteCSSSolutions(query );
        Id BatchProcessId = Database.ExecuteBatch(delBatch);

        String query1 = 'select id from CSS_SymptomQA__c where CreatedDate <= Last_N_Days:1 and User_Name__c != null';                
        CSS_deleteSymptomsQA  delBatch1 = new CSS_deleteSymptomsQA (query1);
        Id BatchProcessId1 = Database.ExecuteBatch(delBatch1);
    }
}