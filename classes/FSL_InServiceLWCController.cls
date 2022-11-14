public with sharing class FSL_InServiceLWCController {
    
    
    @AuraEnabled(Cacheable = true)
    public static serviceOrderWrapper getWorkOrders(){
        
        serviceOrderWrapper wrap = new serviceOrderWrapper();
        List<String> workStartedStatus = new List<String>{'Intake','Scheduled'};
            List<String> workInProgressStatus = new List<String>{'Triage & Diagnosis','Job Plan','Repair'};
                string strAccountId = '';	//UserInfo.getUserId(); 
        User us = [select Id, Name, contactId, contact.AccountId from user Where Id =:UserInfo.getUserId()];
        system.debug('accId====='+us.contact.AccountId);
        strAccountId = us.contact.AccountId;
        
        List<WorkOrder> workNotStartedList = [SELECT Id,WorkOrderNumber,Repair_Location__c, 
                                              Status,Sub_Status__c, CaseId, Case.CaseNumber, 
                                              Case.Unit_Number__c, Make__c, Model__c,Asset.Registration__c, AssetId,Asset.AccountId, 
                                              Asset.Name, CreatedDate, Type_of_Repair__c,FSL_Service_Location__c, FSL_Sub_Status__c,
                                              Repair_Site_Name__c, Repair_Site_Name__r.Name, WorkTypeId 
                                              FROM WorkOrder 
                                              WHERE Status IN:workStartedStatus AND Sub_Status__c !='Cancel' ORDER BY createddate DESC LIMIT 49999];// AND Accountid=:strAccountId //AND Asset.AccountId=:strAccountId //Removed AccountID condition as per CT4-759
        
        List<WorkOrder> workInProgressList = [SELECT Id,WorkOrderNumber,Repair_Location__c, 
                                              Status,Sub_Status__c, CaseId, Case.CaseNumber, 
                                              Case.Unit_Number__c, Make__c, Model__c, Asset.Registration__c,AssetId, Asset.AccountId,
                                              Asset.Name, CreatedDate, Type_of_Repair__c,FSL_Service_Location__c, FSL_Sub_Status__c, 
                                              Repair_Site_Name__c, Repair_Site_Name__r.Name, WorkTypeId 
                                              FROM WorkOrder 
                                              WHERE Status IN:workInProgressStatus AND Sub_Status__c !='Cancel' ORDER BY createddate DESC LIMIT 49999];// AND Accountid=:strAccountId //AND Asset.AccountId=:strAccountId //Removed AccountID condition as per CT4-759
        
        wrap.workNotStarted = workNotStartedList;
        wrap.workInProgress = workInProgressList;
        
        return wrap;
        
    }  
    public class serviceOrderWrapper{
        @AuraEnabled
        public List<WorkOrder> workNotStarted {get;set;}
        @AuraEnabled
        public List<WorkOrder> workInProgress {get;set;}
    }
}