global class CSS_TG_IARecordsStoreBatch implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful{
    global final String query;
    global CSS_TG_IARecordsStoreBatch(String q){
        System.debug('############################### in controller #################### query>>>:'+q);
        if(q != null){
        	query=q;
        }
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
 
    global void execute(Database.BatchableContext BC,List<CSS_DataExchange_Parent__c> scope){
        System.debug('############################### started batch...#################### Batch records size>>>:'+scope.size());
        CSS_FN_Triage_V2.storeIASRecordsInMDC(scope);
        System.debug('############################### completed batch...####################');
    }
 
   global void finish(Database.BatchableContext BC){}

}