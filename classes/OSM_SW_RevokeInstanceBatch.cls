global class OSM_SW_RevokeInstanceBatch implements Database.Batchable<sObject>,Database.AllowsCallouts
{
   
    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        
        return Database.getQueryLocator([Select 
                                            Id, Activation_Key__c, CC_Order_Item__c, Parent_Activation_Key__c, 
                                            OMS_Item_Id__c, Tool_Instance_Key__c, Status__c
                                        From OSM_Order_Item_License__c 
                                        where Parent_Activation_Key__c <>:null 
                                         and (Status__c =: 'Revoke/ReIssue Pending' 
                                             OR Status__c =: 'Revoke Intitiated')
                                         and Tool_Instance_Key__c <>: null]);
    }
    
    global void execute(Database.BatchableContext BC, List<OSM_Order_Item_License__c> itemLicenses)
    {
           for(OSM_Order_Item_License__c itemLicense : itemLicenses){
             OSM_ReturnWrapper returnWrapper = OSM_OMS_SW_RevokeAPIUtility.revokeAPIcallSingleInstance(itemLicense.CC_Order_Item__c,itemLicense.Id);
             if(!returnWrapper.exceptionFlag){
                 if(itemLicense.Status__c == 'Revoke Intitiated'){
                    itemLicense.Status__c = 'Revoked';
                 }
                 if(itemLicense.Status__c == 'Revoke/ReIssue Pending'){
                    itemLicense.Status__c = 'Revoked/ReIssue';
                 }
                 
                }
             }
      update itemLicenses;
    }
    global void finish(Database.BatchableContext BC)
    {
        //OSM_SW_CreateGetOrder_ON_ReIssueBatch cgBatch = new OSM_SW_CreateGetOrder_ON_ReIssueBatch();
        //Database.executeBatch(cgBatch,1);
        
    }
}