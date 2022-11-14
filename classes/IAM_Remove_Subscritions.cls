/************************************************************
Name:  IAM_Remove_Subscritions
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is a queable class to update the Contact record Updates.                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION         AUTHOR                   DATE              DETAIL                                
1.0 -        Amarnath Mishra          05/27/2019        INITIAL DEVELOPMENT 
1.1 -    Karthik Raj Golakaram        01/03/2021      Made changes to make sure that we are calling LDAP API to remove changes
                                                        Also made changes to update Contact and User record.changes
1.2 -      Ganesh K M                 16/05/2022      Made changes to pull only records having subscription end date less than today's date.
1.3 -	 Chetan Gaikwad				  10/08/2022	  EDS/CST deactivation if QSOL Deactivated
*****************************************************/
/********************************************************************************
***********************************************************************************/


global class IAM_Remove_Subscritions implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful {
    global integer numberofConProvProcessed = 0;
 
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Date todayDate =  date.today();
        //string Inactive = System.label.IAM_Inactive_Label;
        string sActive = 'Active';
        String appGM = Label.IAM_AppName_guidanzmobile;
        String appFieldTestGM = Label.IAM_App_GuidanzMobileFieldTest;
        string query;
        
         if(Test.isRunningTest()){
            query = 'SELECT Id,IAM_Account_Name__r.Name,IAM_Account_Name__r.IAM_Service_Provider_Code__c,IAM_Application_Name__c,IAM_Status__c,IAM_Subscription_End_Date__c,IAM_Account_Name__c,Account_Type__c,IAM_Role__c FROM IAM_Application__c LIMIT 10';
        }
        else{
              query = 'Select Id,IAM_Account_Name__r.Name,IAM_Account_Name__r.IAM_Service_Provider_Code__c,IAM_Application_Name__c,IAM_Status__c,IAM_Subscription_End_Date__c,IAM_Account_Name__c,Account_Type__c,IAM_Role__c From IAM_Application__c WHERE IAM_Status__c =: sActive AND IAM_Subscription_End_Date__c <: todayDate';
        }    
        system.debug('query--->'+query);
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<IAM_Application__c> appAccess) {
        system.debug('appAccess--->'+appAccess);
        Set<id> idsToDeactivate= new Set<id>();
        Set<id> idsACCDeactivate= new Set<id>();//QSOL EDS CST deactivation
        Set<id> idsEDSCSTDeactivate= new Set<id>();//QSOL EDS CST deactivation
        Map<id,String> rolesToDelete=new Map<id,String>();
        Set<id> conIds = new Set<Id>();
        Set<id> deactiatedConProvs= new Set<id>();
        string Inactive = System.label.IAM_Inactive_Label;
        for(IAM_Application__c a:appAccess){
            idsToDeactivate.add(a.id);
            //QSOL EDS CST deactivation
            if(a.IAM_Application_Name__c == system.label.IAM_AppName_QSOL && a.Account_Type__c !='LOP Customer' && a.Account_Type__c !='SIR' && a.IAM_Role__c != 'QSOL LOP' && a.IAM_Role__c != 'QSOL SIR Customer'){
                idsACCDeactivate.add(a.IAM_Account_Name__c);
            }
            //QSOL EDS CST deactivation
        }
        system.debug('### idsToDeactivate'+idsToDeactivate);
        //QSOL EDS CST deactivation
        system.debug('### idsACCDeactivate'+idsACCDeactivate);
        if(!idsACCDeactivate.isEmpty()){
            for(IAM_Application__c app:[Select Id,IAM_Account_Name__r.Name,IAM_Account_Name__r.IAM_Service_Provider_Code__c,IAM_Application_Name__c,IAM_Status__c,IAM_Subscription_End_Date__c, IAM_Account_Name__c From IAM_Application__c WHERE IAM_Account_Name__c=:idsACCDeactivate and Id!=:idsToDeactivate and IAM_Status__c = 'Active' and IAM_Application_Name__c IN ('QuickServe Online')]){
            	idsACCDeactivate.remove(app.IAM_Account_Name__c);
            }
        }
        
        if(!idsACCDeactivate.isEmpty()){
            for(IAM_Application__c app:[Select Id,IAM_Account_Name__r.Name,IAM_Account_Name__r.IAM_Service_Provider_Code__c,IAM_Application_Name__c,IAM_Status__c,IAM_Subscription_End_Date__c, IAM_Account_Name__c From IAM_Application__c WHERE IAM_Account_Name__c=:idsACCDeactivate and IAM_Status__c = 'Active' and IAM_Application_Name__c IN ('Cummins Service Training','EDS')]){
            	idsEDSCSTDeactivate.add(app.Id);
            }
        }
        
        system.debug('### idsEDSCSTDeactivate'+idsEDSCSTDeactivate);
        if(!idsEDSCSTDeactivate.isEmpty()){
            idsToDeactivate.addAll(idsEDSCSTDeactivate);
        }
        system.debug('### idsToDeactivate'+idsToDeactivate);
        //QSOL EDS CST deactivation
        
        Set<id> conProvIdsToDeactive= new Set<id>();
        for(IAM_Contact_Provisioning__c c:[select id,IAM_Status__c,IAM_Reject_Reason__c,IAM_Contact__c from IAM_Contact_Provisioning__c  where IAM_Account_Application__c=:idsToDeactivate AND IAM_Status__c =: 'Active']){
            deactiatedConProvs.add(c.id);
            conIds.add(c.IAM_Contact__c);
            
        }
        system.debug('### deactiatedConProvs'+deactiatedConProvs);
        System.debug('numberofConProvProcessed.....'+numberofConProvProcessed);
        
        
        if(!deactiatedConProvs.isEmpty() || !idsToDeactivate.isEmpty() ){
            System.debug('### Inside If.....');
             IAM_RC_DeleteUserFromGroup.basicAuthCalloutExtention(deactiatedConProvs,rolesToDelete,false);
             if(Limits.getLimitQueueableJobs()>Limits.getQueueableJobs()){
                 System.debug('### Inside If 1.....');
                 id jobId= System.enqueueJob(new IAM_Remove_Sub_Features_Queueable(idsToDeactivate,deactiatedConProvs,conIds,'Since Subscription got inactive, changed Status to Inactive'));
             }
        }  
    }
     
    global void finish(Database.BatchableContext BC) {
      
      System.debug('Printing total number of records'+numberofConProvProcessed);
      
      AsyncApexJob job=[SELECT id,Status,NumberOfErrors,JobItemsProcessed,TotalJobItems FROM AsyncApexJob WHERE id=:BC.getJobId()];
      
      System.debug('Prinitng all the Job '+ job.JobItemsProcessed);
      //Insert records into Identity and Access Error Object;
      
      
        
    }
}