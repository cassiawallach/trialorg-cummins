global class OSM_SW_CreateGetOrder_ON_ReIssueBatch implements Database.Batchable<sObject>,Database.AllowsCallouts
{
   
    
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator([Select 
                                            Id, Activation_Key__c, CC_Order_Item__c, Parent_Activation_Key__c, 
                                            OMS_Item_Id__c, Tool_Instance_Key__c, Status__c
                                        From OSM_Order_Item_License__c 
                                        where Parent_Activation_Key__c <>:null and Status__c =: 'Revoked/ReIssue']);
    }
    
    global void execute(Database.BatchableContext BC, List<OSM_Order_Item_License__c> itemLicenses)
    {
        Set<ID> orderItemIdSet = new Set<ID>();
        List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
        for(OSM_Order_Item_License__c oil: itemLicenses){
            orderItemIdSet.add(oil.CC_Order_Item__c);
        }
        OSM_ReturnWrapper objReturn;  
        
        /*Map<Id,ccrz__E_OrderItem__c>orderItemRecordMap = new Map<Id,ccrz__E_OrderItem__c>([Select ID, OMS_Product__c, OMS_Activation_Key__c,ccrz__Quantity__c, Tool_Instance_Key__c 
         From ccrz__E_OrderItem__c where Id IN:orderItemIdSet]);
        */
        for(OSM_Order_Item_License__c itemLicense : itemLicenses){
            OSM_SW_OrderActions.call_OMS_GetAndCreateOrder(orderItemIdSet,itemLicense.CC_Order_Item__c,itemLicense.Id,false);
        }
        
        List<ccrz__E_OrderItem__c> list_OIToUpdate = new List<ccrz__E_OrderItem__c>();
        for(ccrz__E_OrderItem__c ordrItm : [Select ID, OMS_Product__c, OMS_Activation_Key__c,ccrz__Quantity__c, Tool_Instance_Key__c, Revocation_Status__c,IsRevokeLicenseSucess__c,
                                                 (SELECT Id FROM OSM_Oreder_Item_Licenses__r WHERE Status__c = 'Revoke Intitiated' OR Status__c = 'Revoked')
                                                 From ccrz__E_OrderItem__c where Id IN:orderItemIdSet])
        {
            if(ordrItm.OSM_Oreder_Item_Licenses__r.size() == 0){
                ordrItm.Revocation_Status__c = null;
                ordrItm.IsRevokeLicenseSucess__c = false;
                list_OIToUpdate.add(ordrItm);
            }
        }
        
        if(list_OIToUpdate.size() > 0){
            update list_OIToUpdate;
        }   
    }
    
    
    global void finish(Database.BatchableContext BC){
        OSM_Integration_Log__c log = new OSM_Integration_Log__c();
        log.Service_Name__c='OSM_SW_CreateGetOrder_ON_ReIssueBatch';
        log.Internal_Batch_Log__c=true;
        AsyncApexJob jobstatus = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed,TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id =:BC.getJobId()];
         log.Status__c = jobstatus.Status;
        if(jobstatus.Status=='Completed'){
            log.Status__c = 'Processed'; 
        }else if(jobstatus.Status=='Failed'){
            log.Internal_Batch_Failure__c=true;
            log.No_of_Jobs_Failed__c=jobstatus.NumberOfErrors;
        }
        insert log;
        OSM_OMS_GetTI_ON_Revoked_Batch getTIBatch =new OSM_OMS_GetTI_ON_Revoked_Batch();
        Database.executeBatch(getTIBatch,1);
        System.debug('End : OSM_OMS_GetTI_ON_Revoked_Batch');
    }
}