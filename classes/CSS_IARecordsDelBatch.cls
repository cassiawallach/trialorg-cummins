global class CSS_IARecordsDelBatch implements Database.Batchable<sObject>{
    global final String query;
    global CSS_IARecordsDelBatch(String q){
        if(q != null){
        	query=q;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_DataExchange_Parent__c> scope){
        delete scope;
    }
 
   global void finish(Database.BatchableContext BC){}

}