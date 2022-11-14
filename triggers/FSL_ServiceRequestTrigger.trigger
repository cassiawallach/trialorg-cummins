/***************************************************************************
Name: FSL_ServiceRequestTrigger
Copyright Â© 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This trigger is used to make the Service request record read-only
===================================================================
History                                                            
-------                                                            
VERSION  AUTHOR               DATE               DETAIL
1.0      Mallika Subhashini   02/26/2020         GFSLFM-2165
2.0      Anvesh Reddy         07/27/2020            CCM 
3.0      Charan               03/02/2021          CT3-294
4.0      Rahul & Ghanshyam    18/11/2021          CCM
*****************************************************************************/
trigger FSL_ServiceRequestTrigger on Case (before insert, after insert, before update, after update) {
    
    Id IARequestRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('IA_Request').getRecordTypeId(); //MV-606
    Id dealerEvolutionRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();//MV-606

    if(Trigger.isBefore && Trigger.isUpdate && RecursiveTriggerHandler.isCallFromCaseComments == false) {
        for(case cs:Trigger.New) {
            cs.comments='';
        }
    }
    
    // Added below logic to change the SR ownerID as per story CT4-759 - START
    if(Trigger.isBefore && Trigger.isInsert) {
        if(Trigger.new[0].recordTypeId == IARequestRecTypeId || Trigger.new[0].recordTypeId == dealerEvolutionRecTypeId){ //MV-606
        FSL_CL_ServiceRequestTriggerHelper.changeOwnerSPSR(Trigger.new, Trigger.oldMap);
    }
    }
    // Added below logic to change the SR ownerID as per story CT4-759 - END
    
    if(Trigger.isAfter && Trigger.isInsert) {
        //--changes start- for copy all attachment from parent to child and chatter Post functionality- 18-11-2021--CCM Development team----//  
        Map<Id,Id> childTicketIdToParentTicketId = new Map<Id,Id>();//added
        map<Id,Id> ParentTicketIdTochildTicketId= new map<Id,Id>();//added
        //--- End here---//
        
        Set<Id> csId = new Set<Id>();
        for(case cs:Trigger.New) {
            csId.add(cs.Id);
            //--Below changes for copy all attachment from parent to child and chatter Post functionality- 18-11-2021--CCM Development team----//  
            if(cs.Related_Ticket__c != null){
                childTicketIdToParentTicketId.put(cs.Id,cs.Related_Ticket__c);  
                ParentTicketIdTochildTicketId.put(cs.Related_Ticket__c,cs.Id);
            }
        }
        if(childTicketIdToParentTicketId != null && !childTicketIdToParentTicketId.isEmpty()){
            FSL_ChildServiceRequestDataCloning.chatterPostonChildSR(childTicketIdToParentTicketId);
            FSL_ChildServiceRequestDataCloning.copyFilesToChildCase(ParentTicketIdTochildTicketId);
        }
        //-----Changes-End Here-----//        
        
        if(system.isBatch() == False && system.isFuture() == false) {
            if(Trigger.new[0].recordTypeId == IARequestRecTypeId || Trigger.new[0].recordTypeId == dealerEvolutionRecTypeId){ //MV-606
            FSL_CL_ServiceRequestTriggerHelper.AfterInsert(csId);
        }
        }
        
        // Anvesh Added Below code as part of CCM implemmentation
        List<Case> caseList = [SELECT Id, RecordTypeId, IAS_Number__c,AssetId FROM Case WHERE Id =: csId];
        
        RecordType RecTy = [SELECT Id, Name FROM RecordType WHERE Id=:caseList[0].RecordTypeId];   
        system.debug('RecTy '+ RecTy);
        Boolean CCMRecType = false;
        if(RecTy.name == 'CCM') {
            CCMRecType = true;
        }
        if(CCMRecType) {
            system.debug('Inside CCM RType');
            FSL_CaseStatusChangeTriggerHandler.OnAfterInsert(Trigger.new);
        }
        
        // added by sailaja, CT3-257 - to update WO with case hours, mileage for IA Request
        // added by Charan, CT3-294 - to update WO with assetId for IA Request
    }
    
    if(trigger.isAfter && trigger.isUpdate) {
        if(RecursiveTriggerHandler.isSRUpdate == true){
            RecursiveTriggerHandler.isSRUpdate = false;
            
            Boolean BypassSRUpdate;
            Set<Id> csId = new Set<Id>();
            for(case cs:Trigger.New) {
                csId.add(cs.Id);
                system.debug('Bypass Validation Rule--'+ cs.Bypass_Validation_Rule__c);
                BypassSRUpdate = cs.Bypass_Validation_Rule__c;
            }
            
            List<Case> caseList = [SELECT Id, RecordTypeId, IAS_Number__c,AssetId FROM Case WHERE Id =: csId];
            
            RecordType RecTy = [SELECT Id, Name FROM RecordType WHERE Id=:caseList[0].RecordTypeId];   
            system.debug('RecTy '+ RecTy);
            // Bharat - CT3-454, 101 from WO PB - Added isNotCalledfromWOPB condition
            List<Case> oldLstSR = trigger.oldMap.values();
            if(oldLstSR[0].ServiceJob__c == null) {
                RecursiveTriggerHandler.isNotCalledfromWOPB = false;
            }
            // RecordType 'EVL Guidanz Dealer Evolution' added by Sriprada for handling the Dealer Jobs
            if((RecTy.Name == 'IA Request' || RecTy.Name == 'EVL Guidanz Dealer Evolution') && RecursiveTriggerHandler.isNotCalledfromWOPB == true && !BypassSRUpdate) {
                FSL_CL_ServiceRequestTriggerHelper.afterUpdate(trigger.newMap, trigger.oldMap);
            }
            if(RecTy.name == 'CCM') {
                FSL_CaseStatusChangeTriggerHandler.OnAfterUpdate(Trigger.new, Trigger.oldMap);
            }
        }
    }
}