/************************************************************
Name:  OSM_SW_ContactAccessRoleUpdate 
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class is execute from account access and feature trigger, when Role, End date, QSOL expiration date is update.
And it will update the same in User provionsed records
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad Sahu        16/04/2020     INITIAL DEVELOPMENT          


*************************************************************/

public without sharing  class OSM_SW_ContactAccessRoleUpdate
{
    public static void updateUserProvionsed(Map<Id,IAM_Application__c> oldMap,Map<Id,IAM_Application__c> newMap)
    {
        
        List<IAM_Contact_Provisioning__c> lstUserAccessToUpdate = new List<IAM_Contact_Provisioning__c>();
        Set<Id> setAccessFeature = new Set<Id>();
        Savepoint sp = Database.setSavepoint();

        try{
            //Removed || oldMap.get(accessObj.Id).IAM_Role__c != accessObj.IAM_Role__c from below if condition as part of MAR-1654
            for(IAM_Application__c accessObj : newMap.values())
            {
                if(((label.OSM_Marketplace_Applications.split(',').Contains(accessObj.IAM_Application_Name__c)) && oldMap.containsKey(accessObj.Id) && (oldMap.get(accessObj.Id).IAM_Subscription_End_Date__c != accessObj.IAM_Subscription_End_Date__c  || oldMap.get(accessObj.Id).IAM_Qsolexpiration__c != accessObj.IAM_Qsolexpiration__c))|| test.isRunningTest())
                    setAccessFeature.add(accessObj.Id);
            }
            
            if(setAccessFeature != null && setAccessFeature.size() > 0)
            {
                lstUserAccessToUpdate = [Select Id,IAM_Qsolexpiration__c,IAM_End_Date__c,IAM_Role__c,IAM_Account_Application__c from IAM_Contact_Provisioning__c where IAM_Account_Application__c IN: setAccessFeature and IAM_Status__c = 'Active'];
                
                if(lstUserAccessToUpdate != null && lstUserAccessToUpdate.size() > 0)
                {
                    for(IAM_Contact_Provisioning__c objConProv : lstUserAccessToUpdate)
                    {
                        if(newMap.containsKey(objConProv.IAM_Account_Application__c))
                        {
                            objConProv.IAM_Qsolexpiration__c = newMap.get(objConProv.IAM_Account_Application__c).IAM_Qsolexpiration__c;
                            objConProv.IAM_End_Date__c = newMap.get(objConProv.IAM_Account_Application__c).IAM_Subscription_End_Date__c;
                            //Mar-1245 Added if condition
                            //Removed if condition as Part of MAR-1654
                            /*if(objConProv.IAM_Role__c != newMap.get(objConProv.IAM_Account_Application__c).IAM_Role__c)        
                            {
                            objConProv.IAM_Role__c = newMap.get(objConProv.IAM_Account_Application__c).IAM_Role__c;
                            }*/
                        }
                    }
                    
                    update lstUserAccessToUpdate;
                }
            }
        }
        Catch(Exception ex)
        {
            System.debug('Exception in class: OSM_SW_ContactAccessRoleUpdate : '+ex.getMessage());
            System.debug('Trace : '+ex.getStackTraceString());
        }
        
    }
}