global class OSM_OrderCreationTimeCheck implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    global OSM_OrderCreationTimeCheck(){
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        Integer Startminute = Integer.valueOf(System.Label.OSM_Order_Checking_Time);
        String query = 'Select ID,OSM_Order_Time_Elapsed__c,createddate,OSM_SW_Is_InterCompany_Order__c,OSM_2_mins_completed__c from ccrz__E_Order__c where OSM_2_mins_completed__c=false And OSM_SW_Is_InterCompany_Order__c=false And FW_Product_Count__c=0 And OSM_Order_Time_Elapsed__c >:Startminute And OrderConfirmationMailSent__c=false and ccrz__Storefront__c=\'SoftwareStore\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<ccrz__E_Order__c > scope){
        for(ccrz__E_Order__c orderRec :scope)
            orderRec.OSM_2_mins_completed__c=true;
        update scope;
    }
    global void finish(Database.BatchableContext BC){
        
    }
}