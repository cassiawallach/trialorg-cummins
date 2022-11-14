/*************************************************************
Name:  IAM_ContactTriggerHandlerNew
Copyright © 2019  Cummins
=============================================================
Purpose:                                                            
Contact trigger Handler for trigger implementation. Make sure that we are executing this trigger only for IAM record types and Internal recordt types.                       
// All Methods need to be filtered though record type since only IAM and WWSPS related record types need to trigger these flows.
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Karthik Golakaram         05/19/2021        INITIAL DEVELOPMENT
1.1 -    Suresh Rathod             05/29/2022        Added guidanzAutomationBypassRun to bypass intialization of values for Guidanz Automation  
********************************************************************************
*********************************************************************************/ 
public class IAM_ContactTriggerHandlerNew extends TriggerHandler{
    
    public List<Contact> TriggerNew;
    public Map<id,Contact> TriggerNewMap;
    public List<Contact> TriggerOld;
    public Map<id,Contact> TriggerOldMap;
    public static List<String> recordtypeNamesList= new List<String>();
    public static boolean guidanzAutomationBypassRun=false;

    public IAM_ContactTriggerHandlerNew() {
        if(checkAsyncronusProcess()||guidanzAutomationBypassRun==true){
            return;
        }
        this.setMaxLoopCount((Integer)TriggerHandler.triggerSettings[0].IAM_Loop_Count__c);
        //this.setMaxLoopCount(1);
        TriggerNew= new List<Contact>();
        TriggerNewMap= new Map<id,Contact>();
        TriggerOld= new List<Contact>();
        TriggerOldMap= new Map<id,Contact>();
        if(String.isNotBlank(TriggerHandler.triggerSettings[0].IAM_Record_Types_Names__c)){
            recordtypeNamesList=TriggerHandler.triggerSettings[0].IAM_Record_Types_Names__c.split(';');
        }else{
            //Default the values to IAM and WWSPS.
            recordtypeNamesList.add('01261000000X6tHAAS');
            recordtypeNamesList.add('0124N000000SgoLQAS');
        }

        if(Trigger.New!=null&&!Trigger.New.isEmpty()){
            TriggerNew= getListOfContacts((List<Contact>)Trigger.New);
        }

        if(Trigger.NewMap!=null&&!Trigger.NewMap.isEmpty()){
            TriggerNewMap=getMapOfContacts((Map<id,Contact>)Trigger.NewMap);
        }

        if(Trigger.Old!=null&&!Trigger.Old.isEmpty()){
            TriggerOld=getListOfContacts((List<Contact>)Trigger.Old);
        }

        if(Trigger.OldMap!=null&&!Trigger.OldMap.isEmpty()){
            TriggerOldMap=getMapOfContacts((Map<id,Contact>)Trigger.OldMap);
        }
    }


    //Methods for trigger execution.

    //IAM Triggers are getting exected only on before insert
    public override void beforeInsert(){
        System.debug('Printing before insert scenario');
        if(!TriggerNew.isEmpty()){
            IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(triggerNew, Trigger.isBefore, Trigger.isAfter);
        }
    }

    //IAM Triggers are getting exected only on after insert
    public override void afterInsert(){
        System.debug('Printing after insert scenario');
        if(!TriggerNew.isEmpty()){
            IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(triggerNew, Trigger.isBefore, Trigger.isAfter);
            IAM_Contact_Trigger_Helper.createUserFeature(triggerNew, Trigger.isAfter);
        }
    }

    //IAM Triggers are getting exected only on before update
    public override void beforeUpdate(){
        System.debug('Printing before Update Scenario');
        if(!TriggerNew.isEmpty()&&!TriggerNewMap.isEmpty()&&!TriggerOld.isEmpty()&&!TriggerOldMap.isEmpty()){
            IAM_Contact_Trigger_Helper.onBeforeUpdate(TriggerNew,TriggerOld,TriggerNewMap,TriggerOldMap);
        }    
    }

    //IAM Triggers are getting exected only on after update
    public override void afterUpdate(){
        System.debug('Printing after Update Scenario');
        if(!TriggerNew.isEmpty()&&!TriggerNewMap.isEmpty()&&!TriggerOld.isEmpty()&&!TriggerOldMap.isEmpty()){
            IAM_Contact_Trigger_Helper.onAfterUpdate(TriggerNew,TriggerOld,TriggerNewMap,TriggerOldMap);
        }
    }




    // Methods to get the filtered contact records.
    public List<Contact> getListOfContacts(List<Contact> contactsList){
        List<Contact> contactsListToReturn = new List<Contact>();
        for(Contact record: contactsList){
            if(recordtypeNamesList.Contains(record.RecordTypeId)){
                if(!contactsListToReturn.Contains(record)){
                    contactsListToReturn.add(record);
                }
            }
        }
        System.debug('Printing return list of values'+contactsListToReturn);
        return contactsListToReturn;  
    }

    public Map<id,Contact> getMapOfContacts(Map<id,Contact> contactsMap){
        Map<id,Contact> contatsMapToReturn = new Map<id,Contact>();
        for(id contactId: contactsMap.keySet()){
            if(recordtypeNamesList.Contains(contactsMap.get(contactId).RecordTypeId)){
                if(!contatsMapToReturn.ContainsKey(contactId)){
                    contatsMapToReturn.put(contactId,contactsMap.get(contactId));
                }
            }
        } 
        System.debug('Prinitng return map'+contatsMapToReturn);
        return contatsMapToReturn;
    }

    private Boolean checkAsyncronusProcess(){
 

        boolean isAsynchronusProcuss=false;
        if(System.isBatch()&&triggerSettings[0].IAM_Skip_for_isBatchable_execution__c){
            isAsynchronusProcuss=True;
        }
      
        if(System.isFuture()&&triggerSettings[0].IAM_Skip_for_isFuture_execution__c){
          isAsynchronusProcuss=True;
        }
      
        if(System.isQueueable()&&triggerSettings[0].IAM_Skip_for_isQueueable_Execution__c){
          isAsynchronusProcuss=True;
        }
      
        return isAsynchronusProcuss;
    }
}