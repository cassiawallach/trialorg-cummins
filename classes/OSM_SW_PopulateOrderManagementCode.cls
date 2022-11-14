global class OSM_SW_PopulateOrderManagementCode implements Database.Batchable<sObject>,Schedulable {
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        string query ='Select id,IAM_Movex_Customer_Code__c,BMS_Customer_ID_Junction__c from account where Customer_BMS_number__c = NUll and IAM_Movex_Customer_Code__c!=Null';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<account> scope){
        for(account acc :scope)
        acc.BMS_Customer_ID_Junction__c=acc.IAM_Movex_Customer_Code__c;
        update scope; 
    }
    
    public void finish(Database.BatchableContext BC){
    }
    public void execute(SchedulableContext SC) {
        Database.executeBatch(new OSM_SW_PopulateOrderManagementCode(),2000);
    }
    
    
}