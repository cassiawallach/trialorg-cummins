public with sharing class FSL_ServiceRequestsController {
    
    @invocableMethod
    public static List<ServiceRequestWrapperResponse> getServiceRequests(){
        ServiceRequestWrapperResponse wrap = new ServiceRequestWrapperResponse();
        Set<String> statusvalues = new Set<String>{'Rejected', 'Closed - No Response', 'Closed'};
        string NewStatus = 'New';
        string RejectedStatus = 'Rejected';
        string strAccountId = '';	//UserInfo.getUserId(); 
        User us = [select Id, Name, contactId, contact.AccountId from user Where Id =:UserInfo.getUserId()];
        system.debug('accId====='+us.contact.AccountId);
        strAccountId = us.contact.AccountId;
       
        List<Case> newServiceRequestsList = [SELECT Id, AccountId, CaseNumber, ServiceJob__c, Unit_Number__c, Make__c, Model__c,Asset.Registration__c, AssetId, Asset.Name, Status, CreatedDate, Service_location__c, Service_Territory__c, Service_Territory__r.Name,Asset.AccountId
                                             FROM Case 
                                             WHERE Is_Created_From_Portal__c = true AND RecordType.Name = 'IA Request' 
                                             AND status = 'New'] ; //AND Accountid=:strAccountId AND Asset.AccountId=:strAccountId
        
        List<Case> rejectedServiceRequestsList = [SELECT Id, CaseNumber, ServiceJob__c, Unit_Number__c, Make__c, Model__c,Asset.Registration__c, AssetId, Asset.Name, Status, CreatedDate, Service_location__c, Service_Territory__c, Service_Territory__r.Name, Asset.AccountId 
                                                  FROM Case 
                                                  WHERE Is_Created_From_Portal__c = true AND RecordType.Name = 'IA Request' 
                                                  AND status IN :statusvalues ];
        
        wrap.newServiceRequests = newServiceRequestsList;
        wrap.rejectedServiceRequests = rejectedServiceRequestsList;
        wrap.newServiceRequestsCount = newServiceRequestsList.size();
        wrap.rejectedServiceRequestsCount = rejectedServiceRequestsList.size();
        
        //return wrap;
        return new List<ServiceRequestWrapperResponse>{wrap};
    }
    
    public class ServiceRequestWrapperInput {
        @InvocableVariable
        public String userId;
    }
    
    public class ServiceRequestWrapperResponse {
        @InvocableVariable
        public List<Case> newServiceRequests;
        @InvocableVariable
        public List<Case> rejectedServiceRequests;
        @InvocableVariable
        public Integer rejectedServiceRequestsCount;
        @InvocableVariable
        public Integer newServiceRequestsCount;
    }
}