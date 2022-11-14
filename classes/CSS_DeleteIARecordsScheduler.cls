global class CSS_DeleteIARecordsScheduler implements Schedulable{
    
	global void execute(SchedulableContext sc){
       String query = 'Select Id, MDC_Status__c from CSS_DataExchange_Parent__c where MDC_Status__c=true and CreatedDate < Last_N_Days:7';
        if(query != null){
        	CSS_IARecordsDelBatch delBatch = new CSS_IARecordsDelBatch(query);
        	Id batchProcessId = Database.ExecuteBatch(delBatch);
        }
    }
    
}