/*
@Class Name    :  FSL_ServiceRequestsLWCController
@JIRA Story    :  CT4 - 255
@Created By    :  Madhavi P
@Created Date  :  14 - Jan - 2021
@Description   :  This controller gets called from LWC Component (FSL_ServiceRequestsLWC) to get the Service requests related to Account 
for which do not have a Service Order # generated.
@Modified By   :  		
*/
public with sharing class FSL_ServiceRequestsLWCController {
    
    @AuraEnabled(Cacheable = true)
    public static ServiceRequestWrapper getServiceRequests(){
        ServiceRequestWrapper wrap = new ServiceRequestWrapper();
        Set<String> statusvalues = new Set<String>{'Rejected', 'Closed - No Response', 'Closed'};
        string NewStatus = 'New';
        string RejectedStatus = 'Rejected';
        string strAccountId = '';	//UserInfo.getUserId(); 
        User us = [select Id, Name, contactId, contact.AccountId from user Where Id =:UserInfo.getUserId()];
        system.debug('accId====='+us.contact.AccountId);
        strAccountId = us.contact.AccountId;
       
        List<Case> NewServiceRequestsList = [SELECT Id, AccountId, CaseNumber, ServiceJob__c, Unit_Number__c, Make__c, Model__c,Asset.Registration__c, AssetId, Asset.Name, Status, CreatedDate, Service_location__c, Service_Territory__c, Service_Territory__r.Name,Asset.AccountId
                                             FROM Case 
                                             WHERE (ServiceJob__c = null AND Is_Created_From_Portal__c = true) AND (RecordType.Name = 'IA Request' OR RecordType.Name ='FSL IA Rejected')
                                             AND status NOT IN :statusvalues ORDER BY createddate DESC Limit 49999];// AND Accountid=:strAccountId AND (Asset.AccountId=:strAccountId OR AssetId='') //Added asset blank condition to display logged in user account related SR Details as per Story# CT4-718
        																																															 //Removed AccountID condition as per CT4-759
        																																															 //Added Query filter OR RecordType.Name ='FSL IA Rejected' for getting Rejected request data as per CT4-905
        
        List<Case> RejectedServiceRequestsList = [SELECT Id, CaseNumber, ServiceJob__c, Unit_Number__c, Make__c, Model__c,Asset.Registration__c, AssetId, Asset.Name, Status, CreatedDate, Service_location__c, Service_Territory__c, Service_Territory__r.Name, Asset.AccountId 
                                                  FROM Case 
                                                  WHERE (ServiceJob__c = null AND Is_Created_From_Portal__c = true) AND (RecordType.Name = 'IA Request' OR RecordType.Name ='FSL IA Rejected')
                                                  AND status IN :statusvalues ORDER BY createddate DESC Limit 49999];// AND  Accountid=:strAccountId AND (Asset.AccountId=:strAccountId OR AssetId='') //Added asset blank condition to display logged in user account related SR Details as per Story# CT4-718
        																																															   //Removed AccountID condition as per CT4-759
        																																															   //Added Query filter OR RecordType.Name ='FSL IA Rejected' for getting Rejected request data as per CT4-905
        
        wrap.NewServiceRequests = NewServiceRequestsList;
        wrap.RejectedServiceRequests = RejectedServiceRequestsList;
        
        return wrap;
    }
    
    public class ServiceRequestWrapper{
        @AuraEnabled
        public List<Case> NewServiceRequests {get;set;}
        @AuraEnabled
        public List<Case> RejectedServiceRequests {get;set;}
    }
    
}