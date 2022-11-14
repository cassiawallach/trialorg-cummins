/*************************************************************************************
Name:  IAM_Sub_ContactUpdate_Queueable
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It is queueable class to update Contact records
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     01/16/2020        INITIAL DEVELOPMENT 
1.1      Karthik Raj Golakaram     01/03/2021     Made changes to make sure that we are 
                                                  calling LDAP API to remove changes, 
                                                  changed to update Contact and User record.
**************************************************************************************
**************************************************************************************/
public class IAM_Sub_ContactUpdate_Queueable implements Queueable{
    
    Public Set<id> conIdsToUpdate;
    Public Boolean fromLocationSubscriptionAdditionAPIClass;
    Public Boolean fromSubscriptionRemovalBatchClass;
    Public IAM_Sub_ContactUpdate_Queueable(Set<id> conIdsToUpdate){
        this.conIdsToUpdate=conIdsToUpdate;
        this.fromLocationSubscriptionAdditionAPIClass=True;
        this.fromSubscriptionRemovalBatchClass=False;
    }
    
    Public IAM_Sub_ContactUpdate_Queueable(Set<id> conIdsToUpdate,Boolean fromLocationSubscriptionAdditionAPIClass,Boolean fromSubscriptionRemovalBatchClass){
        this.conIdsToUpdate=conIdsToUpdate;
        this.fromLocationSubscriptionAdditionAPIClass=fromLocationSubscriptionAdditionAPIClass;
        this.fromSubscriptionRemovalBatchClass=fromSubscriptionRemovalBatchClass;
    }
    
      public void execute(QueueableContext context) {
        List<Contact> ContactsToUpdate= IAM_Utility.processedContacts(conIdsToUpdate);
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
            ID jobID;
            if(!Test.isRunningTest()&&fromLocationSubscriptionAdditionAPIClass&&!fromSubscriptionRemovalBatchClass){
                System.debug('Class getting Called from Subscription addition Class');
                jobID = System.enqueueJob(new IAM_Sub_UserUpdate_Queueable(conIdsToUpdate));
                System.debug('jobID'+jobID);
            }else if(!Test.isRunningTest()&&!fromLocationSubscriptionAdditionAPIClass&&fromSubscriptionRemovalBatchClass){
            System.debug('Class getting Called from Subscription Removal Class');
                jobID = System.enqueueJob(new IAM_Sub_UserUpdate_Queueable(conIdsToUpdate,fromLocationSubscriptionAdditionAPIClass,fromSubscriptionRemovalBatchClass));
                System.debug('jobID'+jobID);
            }
        }
    }
}