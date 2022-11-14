/*
@Class Name    :  FSL_ServiceHIstoryController
@JIRA Story    :  CT4 - 
@Created By    :  Mani Kumar Kaki
@Created Date  :  14 - Jan - 2021
@Description   :  This controller gets called from LWC Component (fSL_ServiceHistoryLWC) to get the Service History. 
@Modified By   :  		
*/

public with sharing class FSL_ServiceHIstoryController {
    @AuraEnabled(Cacheable = true)
    public static serviceOrderWrapper getWorkOrders(){
        serviceOrderWrapper wrap = new serviceOrderWrapper();
        string strAccountId = '';	//UserInfo.getUserId(); 
        User us = [select Id, Name, contactId, contact.AccountId from user Where Id =:UserInfo.getUserId()];
        system.debug('accId====='+us.contact.AccountId);
        strAccountId = us.contact.AccountId;
        
        List<WorkOrder> ClosedList = [SELECT Id,WorkOrderNumber,Repair_Location__c, 
                                      Status,FSL_Sub_Status__c, Sub_Status__c, CaseId, Case.CaseNumber, 
                                      Case.Unit_Number__c, Make__c, Model__c, Asset.Registration__c,AssetId,Asset.AccountId,  
                                      Asset.Name, CreatedDate, Type_of_Repair__c, 
                                      Repair_Site_Name__c, Repair_Site_Name__r.Name, WorkTypeId, FSL_Service_Location__c
                                      FROM WorkOrder 
                                      WHERE Status =:'Closed' ORDER BY createddate DESC Limit 49999]; //AND Accountid=:strAccountId AND Asset.AccountId=:strAccountId  //Removed AccountID condition as per CT4-759
        
        List<WorkOrder> CanceledList = [SELECT Id,WorkOrderNumber,Repair_Location__c, 
                                        Status,FSL_Sub_Status__c, Sub_Status__c, CaseId, Case.CaseNumber, 
                                        Case.Unit_Number__c, Make__c, Model__c, Asset.Registration__c,AssetId, Asset.AccountId, 
                                        Asset.Name, CreatedDate, Type_of_Repair__c,
                                        Repair_Site_Name__c, Repair_Site_Name__r.Name, WorkTypeId, FSL_Service_Location__c
                                        FROM WorkOrder 
                                        WHERE Status=:'Canceled' OR (Status =:'Intake' AND Sub_Status__c = 'Cancel') ORDER BY createddate DESC Limit 49999]; //AND Accountid=:strAccountId AND Asset.AccountId=:strAccountId  //Removed AccountID condition as per CT4-759
        
        wrap.workNotStarted = ClosedList;
        wrap.workInProgress = CanceledList;
        
        return wrap;
    }
    public class serviceOrderWrapper{
        @AuraEnabled
        public List<WorkOrder> workNotStarted {get;set;}
        @AuraEnabled
        public List<WorkOrder> workInProgress {get;set;}
    }
}