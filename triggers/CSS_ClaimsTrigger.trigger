/**********************************************************************
Name:CSS_ClaimsTrigger
Copyright Â© 2018  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
We are using this trigger for calling getServiceProviderDataClaims after update of claims location.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL  
1.0 -   Arpita Sarangee    4/2/2018      Added code as part of user story 137880
***********************************************************************/
trigger CSS_ClaimsTrigger on CSS_Claims__c (after insert,after update, before delete) {
    
    if(Trigger.isAfter){
        
        if(Trigger.isUpdate){
            system.debug('in trigger isUpdate***');   
            CG_CL_ClaimsTriggerHandler.onAfterUpdate(Trigger.new,trigger.oldmap);
            
            if(RecursiveTriggerHandler.isFirstTimeClaimsTriggerAfterUpdate == true){  //101 SOQL issue fix
                RecursiveTriggerHandler.isFirstTimeClaimsTriggerAfterUpdate = false; //101 SOQL issue fix
                List<CG_Claim_Audit_Log__c> claimsAuditLst = [SELECT Id, Name, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Edit_Message__c,
                                                        Remove_Message__c FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Claims__c' ORDER BY Sort_Order__c ASC]; 
                CG_CL_ClaimsAuditTrailEventHandler.onUpdateClaim(Trigger.new, trigger.oldmap, claimsAuditLst);
            }
        }
    }
    
     if(Trigger.isAfter){
        
        if(Trigger.isInsert){
            system.debug('in trigger isInsert***'); 
            List<CG_Claim_Audit_Log__c> claimsAuditLst = [SELECT Id, Name, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Edit_Message__c,
                                                        Remove_Message__c FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Claims__c' ORDER BY Sort_Order__c ASC]; 
            CG_CL_ClaimsAuditTrailEventHandler.onInsertClaim(Trigger.new, claimsAuditLst);
            List<CSS_Claims__c> claimsRecords = new List<CSS_Claims__c>();
            for(CSS_Claims__c CR : Trigger.new){
               claimsRecords.add(CR);
            }
            
            if(claimsRecords!=null && claimsRecords.size()>0){
               CG_CL_ClaimsTriggerHandler.changeOwnerInfo(claimsRecords);
 //calling below method for creating a record into CSS_JobHistory__c object claim is created as per story #180130 14th May 2019.
               CG_CL_ClaimsTriggerHandler.creatingJobHistoryRecord(claimsRecords);
 //End
            }
        }
    }
 //calling below method for creating a record into CSS_JobHistory__c object when claim is deleted as per story #180130 14th May 2019.
           if(Trigger.isBefore && Trigger.isDelete){
               List<CSS_Claims__c> claimsRecords = new List<CSS_Claims__c>();
                for(CSS_Claims__c CR : Trigger.old){
                   claimsRecords.add(CR);
                }  
               if(claimsRecords!=null && claimsRecords.size()>0)
               CG_CL_ClaimsTriggerHandler.deletingJobHistoryRecord(claimsRecords);
           }
//End
}