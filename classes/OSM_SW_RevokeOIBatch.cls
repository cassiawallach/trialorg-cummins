global class OSM_SW_RevokeOIBatch implements Database.Batchable<sObject>,Database.AllowsCallouts
{
   global Set<String> recordIds;
    
    global OSM_SW_RevokeOIBatch(Set<String> paramIds){
       recordIds = paramIds;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(recordIds == null){
            return Database.getQueryLocator([Select 
                                            Id
                                        From ccrz__E_OrderItem__c 
                                        where Tool_Instance_Count__c > 0  
                                           and Revocation_Status__c =: 'Revoke Initiated'
                                           and Is_Revoked__c =: false]);
        }
        return Database.getQueryLocator([Select 
                                            Id
                                        From ccrz__E_OrderItem__c 
                                        where Id IN:recordIds 
                                           and Tool_Instance_Count__c > 0  
                                           and Revocation_Status__c =: 'Revoke Initiated'
                                           and Is_Revoked__c =: false]);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_OrderItem__c> itemLicenses)
    {
        Set<ID> orderItemIdSet = new Set<ID>();
        List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
        for(ccrz__E_OrderItem__c oil: itemLicenses){
            orderItemIdSet.add(oil.Id);
        }
        OSM_OMS_SW_RevokeAPIUtility.revokeAPIcall(orderItemIdSet);
            
    }
    
    
    global void finish(Database.BatchableContext BC)
    {
        
        System.debug('End : OSM_SW_RevokeOIBatch');
    }
}