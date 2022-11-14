global class OSM_OMS_GetTI_ON_Revoked_Batch implements Database.Batchable<sObject>,Database.AllowsCallouts
{
   
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator([Select 
                                            Id, Activation_Key__c, CC_Order_Item__c, Parent_Activation_Key__c, 
                                            OMS_Item_Id__c, Tool_Instance_Key__c, Status__c
                                        From OSM_Order_Item_License__c 
                                        where Revoked_ReIssue_Lisence__c <>:null and Status__c =: 'Create And Get Done']);
    }
    
    global void execute(Database.BatchableContext BC, List<OSM_Order_Item_License__c> itemLicenses)
    {
        Set<ID> orderItemIdSet = new Set<ID>();
        List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
        for(OSM_Order_Item_License__c oil: itemLicenses){
            orderItemIdSet.add(oil.CC_Order_Item__c);
        }
        OSM_ReturnWrapper objReturn;  
        
        Map<Id,ccrz__E_OrderItem__c>orderItemRecordMap = new Map<Id,ccrz__E_OrderItem__c>([Select ID, OMS_Product__c, OMS_Activation_Key__c,ccrz__Quantity__c,ccrz__Order__r.ccrz__Account__c, Tool_Instance_Key__c 
         From ccrz__E_OrderItem__c where Id IN:orderItemIdSet]);
           for(OSM_Order_Item_License__c itemLicense : itemLicenses){
                    objReturn=OSM_GetTI_BusinessHandler.updateOMSToolInstance(itemLicense.CC_Order_Item__c,orderItemRecordMap,itemLicense, itemLicense.Id);
                    objReturnList.add(objReturn);
              itemLicense.Status__c = 'New';
         }
         
         OSM_OMS_GetTI_Batch_Helper.updateOrderItemRecords(objReturnList,orderItemIdSet);
        Database.upsert(itemLicenses,false);
       
    }
    
    
    global void finish(Database.BatchableContext BC)
    {
        System.debug('End : OSM_OMS_GetTI_ON_Revoked_Batch');
    }
}