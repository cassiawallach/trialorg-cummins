/************************************************************
Name:  IAM_UserAccessTriggerHandlerNew
Copyright © 2019  Cummins
=============================================================
Purpose:                                                            
Handler for trigger implementation   for User Access Feature.DO NOT CHANGE THE CLASS NAME                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Karthik Golakaram         05/19/2021        INITIAL DEVELOPMENT  
********************************************************************************
********************************************************************************/ 
public class IAM_UserAccessTriggerHandlerNew extends TriggerHandler{
    
    public IAM_UserAccessTriggerHandlerNew() {
        this.setMaxLoopCount((Integer)TriggerHandler.triggerSettings[0].IAM_Loop_Count__c); 
    }


    public override void beforeInsert(){
        System.debug('Printing before insert scenario');
        IAM_UserFeatureAndAccessTriggerHandler.validateApplicationAccess((List<IAM_Contact_Provisioning__c>)Trigger.new,Trigger.isInsert, Trigger.isUpdate);
        IAM_UserFeatureAndAccessTriggerHandler.populateFieldValues((List<IAM_Contact_Provisioning__c>)Trigger.new,(Map<Id,IAM_Contact_Provisioning__c>) Trigger.oldMap,Trigger.isInsert, Trigger.isUpdate);
    }

    //IAM Triggers are getting exected only on after insert
    public override void afterInsert(){
        System.debug('Printing after insert scenario');
        IAM_UserFeatureAndAccessTriggerHandler.onAfterInsert((List<IAM_Contact_Provisioning__c>)Trigger.new, (Map<Id,IAM_Contact_Provisioning__c>)Trigger.newMap, (Map<Id,IAM_Contact_Provisioning__c>)Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);
       
    }

    public override void beforeUpdate(){
        System.debug('Printing before Update Scenario');
        IAM_UserFeatureAndAccessTriggerHandler.validateApplicationAccess((List<IAM_Contact_Provisioning__c>)Trigger.new,Trigger.isInsert, Trigger.isUpdate);
        IAM_UserFeatureAndAccessTriggerHandler.populateFieldValues((List<IAM_Contact_Provisioning__c>)Trigger.new, (Map<Id,IAM_Contact_Provisioning__c>)Trigger.oldMap,Trigger.isInsert, Trigger.isUpdate);
    }

    //IAM Triggers are getting exected only on after insert
    public override void afterUpdate(){
        System.debug('Printing after Update Scenario');
        IAM_UserFeatureAndAccessTriggerHandler.onAfterUpdate((List<IAM_Contact_Provisioning__c>)Trigger.new, (Map<Id,IAM_Contact_Provisioning__c>)Trigger.newMap,(Map<Id,IAM_Contact_Provisioning__c>)Trigger.oldMap, Trigger.isInsert, Trigger.isUpdate);
    }
}