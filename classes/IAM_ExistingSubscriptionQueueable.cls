/**************************************************************************************
Name:  Iam_ExistingSubscriptionQueueable
Copyright © 2021  Cummins
**************************************************************************************
Purpose: REST Post :  This service is currently used by SWReg system to create/renew/cancel
subscriptions (Account Access Fetaure and respective Contact provisioning) in IAM.To avoid APex CPU Time Error (500)
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Lavanya Javvadi      11/24/2021      INITIAL DEVELOPMENT 

**************************************************************************************
***************************************************************************************/
public class IAM_ExistingSubscriptionQueueable implements Queueable{
    
    @testVisible
    private static boolean doChainJob = true;
    Public List<IAM_Application__c> activeSub ;
    Public String action;
    public list<Id> accFeatureIdsToUpdate;
    public boolean isRenewal;
    public boolean isRevoked;
   
    Public IAM_ExistingSubscriptionQueueable(){}
    
    Public IAM_ExistingSubscriptionQueueable(List<IAM_Application__c> activeSub,String action,List<Id> accFeatureIdsToUpdate,boolean isRenewal,boolean isRevoked){
        this.activeSub=activeSub;
        this.action=action;
        this.accFeatureIdsToUpdate =accFeatureIdsToUpdate;
        this.isRenewal =isRenewal;
        this.isRevoked=isRevoked;
    }
    
    public void execute(QueueableContext Context) {
       // Set<Id> appListIds =new Set<Id>();
       upsert activeSub;
         if(!accFeatureIdsToUpdate.isEmpty()){
                    if(isRenewal){
                        system.debug('inside Renewal if-->');
                        //IAM_ExistingLoSubInfo_Extension.updateContactProvisioningRec(accFeatureIdsToUpdate,Label.IAM_Action_Update);
                        if(doChainJob){ID jobID = System.enqueueJob(new IAM_ExistingLoSubInfo_Extension(accFeatureIdsToUpdate,Label.IAM_Action_Update));}
                        //System.debug('jobID'+jobID); 
                    }else if(isRevoked){
                        system.debug('inside Revoked if-->');
                        //IAM_ExistingLoSubInfo_Extension.updateContactProvisioningRec(accFeatureIdsToUpdate,Label.IAM_Action_Cancel);
                        if(doChainJob){ID jobID = System.enqueueJob(new IAM_ExistingLoSubInfo_Extension(accFeatureIdsToUpdate,Label.IAM_Action_Cancel));}
						//System.debug('jobID'+jobID); 
                    }
                    
                    
                }
      
        
    }

}