/************************************************************
Name:  IAM_Remove_Sub_Features_Queueable
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
1.0 -    Karthik Raj Golakaram        01/03/2021     INITIAL DEVELOPMENT
1.1 -    Ganesh K M                   19/05/2022     Commented the Subscription end date update logic.
1.2 - 	 Chetan Gaikwad				  10/08/2022	 EDS/CST deactivation if QSOL deactivated on Account
*****************************************************/
/********************************************************************************
***********************************************************************************/
Public class IAM_Remove_Sub_Features_Queueable Implements Queueable {
    
    Public Set<id> accountAccessIdsToDeactivate;
    Public Set<id> userAccessIdsToDeactivate;
    Public Set<id> contactIdsToDeactivate;
    Public Set<id> failureIds;
    Public String reason;
    
    Public IAM_Remove_Sub_Features_Queueable(set<id> accountAccessIdsToDeactivate,set<id> userAccessIdsToDeactivate,set<id> contactIdsToDeactivate, String reason){
        This.accountAccessIdsToDeactivate=accountAccessIdsToDeactivate;
        This.userAccessIdsToDeactivate=userAccessIdsToDeactivate;
        this.contactIdsToDeactivate=contactIdsToDeactivate;
        this.failureIds= new Set<id>();
        this.reason=reason;
    }
    
    Public void execute(QueueableContext context){
        List<IAM_Application__c> appsToDeactivate=[SELECT Id
                                                         , IAM_Status__c
                                                         , IAM_Reject_Reason__c
                                                         , IAM_Subscription_End_Date__c 
                                                         , IAM_Reason__c
                                                  FROM IAM_Application__c
                                                  WHERE id=:accountAccessIdsToDeactivate];
        
        List<IAM_Contact_Provisioning__c> conAppsToDeactivate=[SELECT Id
                                                                    , IAM_Status__c
                                                                    , IAM_Reject_Reason__c
                                                                    , IAM_End_Date__c
                                                                    , IAM_Reason__c
                                                              FROM IAM_Contact_Provisioning__c
                                                              WHERE Id=:userAccessIdsToDeactivate];
        
        if(!appsToDeactivate.isEmpty()){
            for(IAM_Application__c app:appsToDeactivate){
                app.IAM_Status__c=System.Label.IAM_Inactive_Label;
                app.IAM_Reason__c=reason;
                if(reason.contains('QSOL')){
                    app.IAM_Reject_Reason__c=System.Label.IAM_Subscription_Revoked;
                    app.IAM_Subscription_End_Date__c=System.today();
                }else{
                    app.IAM_Reject_Reason__c=System.Label.IAM_Subscription_Expired;
                }
               // app.IAM_Subscription_End_Date__c=System.today();
            }
            Database.SaveResult[] saveResult=Database.Update(appsToDeactivate,false);
            for(Database.SaveResult sr: saveResult){
                if(!sr.isSuccess()){
                  failureIds.add(sr.getId());  
                }
            }
            
        }
        
        if(!conAppsToDeactivate.isEmpty()){
            for(IAM_Contact_Provisioning__c cp: conAppsToDeactivate){
                cp.IAM_Status__c=System.Label.IAM_Inactive_Label;
                cp.IAM_Reason__c=reason;
                if(reason.contains('QSOL')){
                    cp.IAM_Reject_Reason__c=System.Label.IAM_Subscription_Revoked;
                    cp.IAM_End_Date__c=System.today();
                }else{
                    cp.IAM_Reject_Reason__c=System.Label.IAM_Subscription_Expired;
                }
                //cp.IAM_End_Date__c=System.today();
            }
            
            Database.SaveResult[] saveResultCP= Database.Update(conAppsToDeactivate,false);
            for(Database.SaveResult crs:saveResultCP){
                if(!crs.isSuccess()){
                    failureIds.add(crs.getId());
                }
            }
        }
        
        if(!failureIds.isEmpty()){
            //Insert a record in error Object
            IAM_ErrorHandling.IAMerrorCapture('Feature records','Expired Subscription Batch','There is a problem with remove subscription batch class');    
        }
        
        if(!contactIdsToDeactivate.isEmpty()&&!Test.isRunningTest()){
           id JobId=System.enqueueJob(new IAM_Sub_ContactUpdate_Queueable(contactIdsToDeactivate,false,true));
       }
    }
}