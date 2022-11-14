global class dbu_DeletionBatch implements Database.Batchable<sObject>
{
    
     global Database.QueryLocator start(Database.BatchableContext BC) {
        
         
        String query = 'Select Id,Name,dbu_ESNNumber__c, Number_Z__c, DBU_Parts_Response_ID__c from dbu_partsresponse__c where  DBU_Parts_Response_ID__c=null';
        system.debug('queryresult'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
        
    }
     
    global void execute(Database.BatchableContext BC, List<dbu_partsresponse__c> Partresponse) 
    {
        
        
        
        delete Partresponse;
         
        
        
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        
    }

}