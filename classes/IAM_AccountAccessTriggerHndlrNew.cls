/************************************************************
Name:  IAM_AccountAccessTriggerHndlrNew
Copyright © 2019  Cummins
=============================================================
Purpose:                                                            
Handler for trigger implementation   for Account Access Feature.DO NOT CHANGE THE CLASS NAME                       
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Karthik Golakaram         05/19/2021        INITIAL DEVELOPMENT  
*********************************************************************************
*********************************************************************************/ 
public class IAM_AccountAccessTriggerHndlrNew extends TriggerHandler{

 public List<IAM_Application__c> TriggerNew;//added by sandeep for Guidanz Mobile
public IAM_AccountAccessTriggerHndlrNew() {
    this.setMaxLoopCount((Integer)TriggerHandler.triggerSettings[0].IAM_Loop_Count__c); 
    TriggerNew= new List<IAM_Application__c>();
    
    if(Trigger.New!=null&&!Trigger.New.isEmpty()){
            TriggerNew= getAccList((List<IAM_Application__c>)Trigger.New);
        }    
}

public override void beforeInsert(){
    System.debug('Printing before insert scenario');
    IAM_AccountAccessTriggerHandler.onBeforeInsertAndUpdate((List<IAM_Application__c>)trigger.new,(List<IAM_Application__c>)trigger.old,(Map<id,IAM_Application__c>)trigger.oldMap,(Map<id,IAM_Application__c>)trigger.newMap,Trigger.isBefore,Trigger.isInsert);
}

//IAM Triggers are getting exected only on after insert
public override void afterInsert(){
    System.debug('Printing after insert scenario');
    IAM_AccountAccessTriggerHandler.AccountUpdateFields((List<IAM_Application__c>)Trigger.new);
     /* AutorenewSubscriptio   ns method commented by Lavanya, As New Schedule class implemented for AutorenewSubscriptions */
   // IAM_AccountAccessTriggerHandler.AutorenewSubscriptions(trigger.new);//QSOL,EDS,CST
    //added to auto create User Feature records when subscription is added for FT-Guidanz mobile and Guidanz mobile - @Anupam
    IAM_AccountAccessTriggerHandler.autoCreateUserFeatureForGuidanz(TriggerNew);//modified by sandeep
}

public override void beforeUpdate(){
    System.debug('Printing before Update Scenario');
    IAM_AccountAccessTriggerHandler.onBeforeInsertAndUpdate((List<IAM_Application__c>)trigger.new,(List<IAM_Application__c>)trigger.old,(Map<id,IAM_Application__c>)trigger.oldMap,(Map<id,IAM_Application__c>)trigger.newMap,Trigger.isBefore,Trigger.isInsert);
}

//IAM Triggers are getting exected only on  after insert
public override void afterUpdate(){
    System.debug('Printing after Update Scenario');
    IAM_AccountAccessTriggerHandler.onAfterUpdate((List<IAM_Application__c>)trigger.new,(List<IAM_Application__c>)trigger.old,(Map<id,IAM_Application__c>)trigger.oldMap,(Map<id,IAM_Application__c>)trigger.newMap);
    OSM_SW_ContactAccessRoleUpdate.updateUserProvionsed((Map<id,IAM_Application__c>)Trigger.oldMap, (Map<id,IAM_Application__c>)Trigger.newMap);
}

public List<IAM_Application__c> getAccList(List<IAM_Application__c> accountList){
    List<IAM_Application__c> apiAccountList = new List<IAM_Application__c>();
    for(IAM_Application__c accRec : accountList){
        if(accRec.IAM_Application_Name__c == 'Guidanz Mobile' || accRec.IAM_Application_Name__c == 'Field Test Guidanz Mobile'){
            apiAccountList.add(accRec); 
        }
    }
    return apiAccountList;
}

}