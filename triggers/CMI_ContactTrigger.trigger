/************************************************************
Name:  IAM_Utility
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This class provides logic for inbound just-in-time provisioning of single sign-on users in your Salesforce organization.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Keerthy Gurumurthy         1/16/2020          INITIAL DEVELOPMENT 
1.1 -    Karthik Golakaram          03/21/2021      Added changes to skip trigger execution when contact 
                                                    is getting created or getting updated from JIT partner
1.2 -    Karthik Raj Golakaram      05/23/2021      Make changes for trigger frame work changes.
/********************************************************************************
***********************************************************************************/
/* Contact trigger to hanlde user creation. making Ldap call outs and creation of users when a contact get created */

trigger CMI_ContactTrigger on Contact (before insert,After insert,After Update,before update) { 
    System.debug('Prinitng Contact trigger context is before'+Trigger.isBefore);
    System.debug('Prinitng Contact trigger context is After'+Trigger.isAfter);
    System.debug('Prinitng Contact trigger context is insert'+Trigger.isInsert);
    System.debug('Prinitng Contact trigger context is Update'+Trigger.isUpdate);
    new IAM_ContactTriggerHandlerNew().run();
    
   /* Boolean fromJITNew=false;
    Boolean fromJITOld=false;
    if(Trigger.New[0].IAM_From_JIT_Execution__c){
        fromJITNew=True;
    }

   if(Trigger.isUpdate){
        if(!Trigger.old.isEmpty()){
            if(Trigger.old[0].IAM_From_JIT_Execution__c){
                fromJITOld=True;
            }
        }
   }

    //Query Metadata to get the switch details and trigger should fire onlt when switch is Active.
    List<IAM_Trigger_Switches__mdt> triggerSwitch=[select id,IAM_Active__c,Label from IAM_Trigger_Switches__mdt where Label='IAM_Contact_Switch'];   
    
    if(triggerSwitch[0].IAM_Active__c&&!(fromJITNew||fromJITOld)){
        if(Trigger.isInsert){
            
            List<Contact> TriggerNewInsert = new List<Contact>();
            for(Contact c:Trigger.New){
                if(c.RecordTypeID==Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||c.RecordTypeID==Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId()){
                    TriggerNewInsert.add(c);
                }
            }
            if(!TriggerNewInsert.isEmpty()&&!System.isBatch()&&!System.isFuture()&&!System.isQueueable()){
                if(Trigger.isBefore){
                    IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(TriggerNewInsert,Trigger.isBefore,Trigger.isAfter);
                }
                
                if(Trigger.isAfter){
                    IAM_Contact_Trigger_Helper.onBeforeInsertandAfterInsert(TriggerNewInsert,Trigger.isBefore,Trigger.isAfter);
                }
            }
        }
        
        if(Trigger.isUpdate){
            List<Contact> TriggerNewUpdate = new List<Contact>();
            List<Contact> TriggerOldUpdate = new List<Contact>();
            Map<id,Contact> TriggerNewMapUpdate = new Map<id,Contact>();
            Map<id,Contact> TriggerOldMapUpdate = new Map<id,Contact>();
            
            //looping through Trigger.New Contact//
            for(Contact c:Trigger.New){
                if(c.RecordTypeID==Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||c.RecordTypeID==Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId()){
                    TriggerNewUpdate.add(c);
                    TriggerNewMapUpdate.put(c.id,c);
                }
            }
            
            
            for(Contact conOld:Trigger.Old){
                if(conOld.RecordTypeID==Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()||conOld.RecordTypeID==Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId()){
                    TriggerOldUpdate.add(conOld);
                    TriggerOldMapUpdate.put(conOld.id,conOld);
                }
            }
            if(!TriggerNewUpdate.isEmpty()&&!System.isBatch()&&!System.isFuture()&&!System.isQueueable()){
                if(Trigger.isAfter){
                    IAM_Contact_Trigger_Helper.onAfterUpdate(TriggernewUpdate,TriggerOldUpdate,TriggerNewMapUpdate,TriggerOldMapUpdate);
                }
                
                if(Trigger.isBefore){
                    IAM_Contact_Trigger_Helper.onBeforeUpdate(TriggernewUpdate,TriggeroldUpdate,TriggerNewMapUpdate,TriggerOldMapUpdate);
                }
            }
        }
    }*/
    
}