/************************************************************
Name:  IAM_Remove_Subscriptions_Swift
Copyright © 2022  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is a async class to deactivate EDS and CST subscriptions if QSOL access is removed.                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                   DATE              DETAIL                                
1.0 -        Chetan Gaikwad          10/08/2022        INITIAL DEVELOPMENT 
***********************************************************************************/
public class IAM_Remove_Subscriptions_Swift {
    
    @future
    public static void deactivateConProvisionings(set<id> setACCIds) {
        Set<id> idsEDSCSTDeactivate= new Set<id>();
        Set<id> conIds = new Set<Id>();
        Set<id> deactivatedConProvs= new Set<id>();
        Map<id,String> rolesToDelete=new Map<id,String>();
        
        if(!setACCIds.isEmpty()){
            for(IAM_Application__c app:[Select Id,IAM_Account_Name__r.Name,IAM_Account_Name__r.IAM_Service_Provider_Code__c,IAM_Application_Name__c,IAM_Status__c,IAM_Subscription_End_Date__c, IAM_Account_Name__c From IAM_Application__c WHERE IAM_Account_Name__c=:setACCIds and IAM_Status__c = 'Active' and IAM_Application_Name__c IN ('QuickServe Online')]){
            	setACCIds.remove(app.IAM_Account_Name__c);
            }
        }
        
        system.debug('### idsACCDeactivate'+setACCIds);
        
        if(!setACCIds.isEmpty()){
            for(IAM_Application__c app:[Select Id,IAM_Account_Name__r.Name,IAM_Account_Name__r.IAM_Service_Provider_Code__c,IAM_Application_Name__c,IAM_Status__c,IAM_Subscription_End_Date__c, IAM_Account_Name__c From IAM_Application__c WHERE IAM_Account_Name__c=:setACCIds and IAM_Status__c = 'Active' and IAM_Application_Name__c IN ('Cummins Service Training','EDS')]){
            	idsEDSCSTDeactivate.add(app.Id);
            }
        }
        
        system.debug('### idsEDSCSTDeactivate'+idsEDSCSTDeactivate);
        
        Set<id> conProvIdsToDeactive= new Set<id>();
        for(IAM_Contact_Provisioning__c c:[select id,IAM_Status__c,IAM_Reject_Reason__c,IAM_Contact__c from IAM_Contact_Provisioning__c  where IAM_Account_Application__c=:idsEDSCSTDeactivate AND IAM_Status__c =: 'Active']){
            deactivatedConProvs.add(c.id);
            conIds.add(c.IAM_Contact__c);            
        }
        
        system.debug('### deactivatedConProvs'+deactivatedConProvs);
        
        if(!deactivatedConProvs.isEmpty() || !idsEDSCSTDeactivate.isEmpty() ){
            System.debug('### Inside If.....');
             IAM_RC_DeleteUserFromGroup.basicAuthCalloutExtention(deactivatedConProvs,rolesToDelete,false);
             if(Limits.getLimitQueueableJobs()>Limits.getQueueableJobs()){
                 System.debug('### Inside If 1.....');
                 id jobId= System.enqueueJob(new IAM_Remove_Sub_Features_Queueable(idsEDSCSTDeactivate,deactivatedConProvs,conIds,'Subscription revoked since it should be expired with the QSOL'));
             }
        }
	
}
}