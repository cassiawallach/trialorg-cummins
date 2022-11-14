global class OSM_SW_CancelOIBatch implements Database.Batchable<sObject>,Database.AllowsCallouts
{
   global Set<String> recordIds; 
    
    global OSM_SW_CancelOIBatch(Set<String> paramIds){
       recordIds = paramIds;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        if(recordIds == null){
            return Database.getQueryLocator([Select 
                                            Id
                                        From ccrz__E_OrderItem__c 
                                        where Remaining_Lisences__c > 0  
                                           and Revocation_Status__c =: 'Revoke Initiated'
                                           and CancelLicenseAPICalled__c =: false]);
        }   
        return Database.getQueryLocator([Select 
                                            Id
                                        From ccrz__E_OrderItem__c 
                                        where Id IN:recordIds 
                                           and Remaining_Lisences__c > 0  
                                           and Revocation_Status__c =: 'Revoke Initiated'
                                           and CancelLicenseAPICalled__c =: false]);
    }
    
    global void execute(Database.BatchableContext BC, List<ccrz__E_OrderItem__c> itemLicenses)
    {
        Set<ID> orderItemIdSet = new Set<ID>();
        List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
        for(ccrz__E_OrderItem__c oil: itemLicenses){
            orderItemIdSet.add(oil.Id);
        }
        OSM_CancelLicenses_ServiceHandler.callCancelLicensesAPI(orderItemIdSet);
            
    }
    
    
    global void finish(Database.BatchableContext BC)
    {
        
        System.debug('End : OSM_SW_CancelOIBatch');
    }
}