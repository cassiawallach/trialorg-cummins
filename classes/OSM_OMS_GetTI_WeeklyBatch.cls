global class OSM_OMS_GetTI_WeeklyBatch implements Database.Batchable<sObject>,Database.AllowsCallouts
{
    global OSM_OMS_GetTI_WeeklyBatch()
    {
        
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String emptyStr = '';
        
        String query = 'Select ID, OMS_Product__c, OMS_Activation_Key__c,ccrz__Quantity__c,Tool_Instance_Key_Count__c, Tool_Instance_Key__c From ccrz__E_OrderItem__c Where OMS_Activation_Key__c != :emptyStr AND Tool_Instance_Key__c = :emptyStr AND OMS_Product__c = true';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_OrderItem__c> scope)
    {
        Set<ID> orderItemIdSet = new Set<ID>();
        
        for(ccrz__E_OrderItem__c orderItem :scope)
        {
            if(orderItem.ccrz__Quantity__c!=orderItem.Tool_Instance_Key_Count__c){
                orderItemIdSet.add(orderItem.ID);
             }
        }
        
       OSM_OMS_GetTI_Batch_Helper.callGetTILicensesAPI(orderItemIdSet);
    }
    
    
    global void finish(Database.BatchableContext BC)
    {
        System.debug('End : OSM_OMS_GetTI_Batch');
    }
}