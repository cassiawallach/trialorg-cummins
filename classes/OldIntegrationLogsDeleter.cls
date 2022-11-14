/* Class name: OldIntegrationLogsDeleter
 * Author: Shirisha
 * Dated:11/17/2021
 * Description: This class will trigger the batch job to delete the records 
 * */
Global class OldIntegrationLogsDeleter Implements Database.batchable<sobject>{
    global Database.QueryLocator start(Database.BatchableContext BC){
        String numberOfMonths = System.Label.OSM_Integration_Created_Month;
        Integer i=integer.valueof(numberOfMonths);
        Date today = System.today();
        Date last_n_month = today.addMonths(-i); 
       
        return Database.getQueryLocator('SELECT Id, CreatedDate FROM OSM_Integration_Log__c where CreatedDate <: last_n_month');
    }
   
    global  void execute(Database.BatchableContext BC,List<OSM_Integration_Log__c> scope){
        list<OSM_Integration_Log__c> lstDeleteRecords = new list<OSM_Integration_Log__c>();
        if(scope.size()>0){
            for(OSM_Integration_Log__c oc:scope){
                lstDeleteRecords.add(oc);
            }
            delete lstDeleteRecords;
        }        
    }
   
    global void finish(Database.BatchableContext BC){
       
    }
   
}