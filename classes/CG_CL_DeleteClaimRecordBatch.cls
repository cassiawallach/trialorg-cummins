global class CG_CL_DeleteClaimRecordBatch implements Database.Batchable<sObject>
{
global Database.QueryLocator start(Database.BatchableContext BC)
{
    date d = system.today().adddays(-120);
    //String query = 'select Id,Status__c,lastmodifieddate FROM CSS_Claims__c WHERE Status__c = \'Draft\' and lastmodifieddate <=: d and SiebelClaimNumber__c != null';
    String query = 'select Id,Status__c,LastSavedDate__c FROM CSS_Claims__c WHERE Status__c = \'Draft\' and LastSavedDate__c <=: d and SiebelClaimNumber__c = null'; 
    return Database.getQueryLocator(query);
}

global void execute(Database.BatchableContext BC, List<CSS_Claims__c> claimList)
{
        try{
            system.debug('claimList '+claimList);
             if(claimList.size() > 0 ){
             delete claimList;
        }
        }catch(Exception e){
            
        }
    
}
   
   global void finish(Database.BatchableContext BC)
{
} 
}