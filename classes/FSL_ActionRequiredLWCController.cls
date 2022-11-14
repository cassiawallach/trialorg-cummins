public with sharing class FSL_ActionRequiredLWCController {
    
	
    @AuraEnabled(Cacheable = true)
    public static serviceOrderWrapper getWorkOrders(){
        serviceOrderWrapper wrap = new serviceOrderWrapper();
        List<String> waitingOnCustomer = new List<String>{'Waiting on Customer', 'Waiting on Unit/Vehicle'};
        List<String> waitingForCustomerApprvl = new List<String>{'Waiting for Customer Approval'};
        string strAccountId = '';	//UserInfo.getUserId(); 
        User us = [select Id, Name, contactId, contact.AccountId from user Where Id =:UserInfo.getUserId()];
        system.debug('accId====='+us.contact.AccountId);
        strAccountId = us.contact.AccountId;
        
        List<WorkOrder> waitingOnCustmrList = [SELECT Id,WorkOrderNumber,Repair_Location__c, 
                                                Status,Sub_Status__c, CaseId, Case.CaseNumber, 
                                                Case.Unit_Number__c, Make__c, Model__c,Asset.Registration__c, AssetId,Asset.AccountId, 
                                                Asset.Name, CreatedDate, Type_of_Repair__c, FSL_Service_Location__c, FSL_Sub_Status__c,
                                                Repair_Site_Name__c, Repair_Site_Name__r.Name, WorkTypeId 
                                            FROM WorkOrder 
                                            WHERE Sub_Status__c IN:waitingOnCustomer ORDER BY createddate DESC Limit 49999]; //AND Accountid=:strAccountId AND Asset.AccountId=:strAccountId  //Removed AccountID condition as per CT4-759
        
        List<WorkOrder> waitingForCustmrAprvlList = [SELECT Id,WorkOrderNumber,Repair_Location__c, 
                                                Status,Sub_Status__c, CaseId, Case.CaseNumber, 
                                                Case.Unit_Number__c, Make__c, Model__c,Asset.Registration__c, AssetId, Asset.AccountId,
                                                Asset.Name, CreatedDate, Type_of_Repair__c, FSL_Service_Location__c, FSL_Sub_Status__c,
                                                Repair_Site_Name__c, Repair_Site_Name__r.Name, WorkTypeId 
                                            FROM WorkOrder 
                                            WHERE Sub_Status__c IN:waitingForCustomerApprvl ORDER BY createddate DESC Limit 49999]; //AND Accountid=:strAccountId AND Asset.AccountId=:strAccountId  //Removed AccountID condition as per CT4-759

        wrap.waitingOnCustmr = waitingOnCustmrList;
        wrap.waitingForCustmrAprvl = waitingForCustmrAprvlList;
        
        return wrap;
    }
    public class serviceOrderWrapper{
        @AuraEnabled
        public List<WorkOrder> waitingOnCustmr {get;set;}
        @AuraEnabled
        public List<WorkOrder> waitingForCustmrAprvl {get;set;}
    }
}