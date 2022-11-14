@IsTest(SeeAllData=false)
public class FSL_SendServiceOrderToServiceNow_Test {
    public static testmethod void createSNOWIncidentMethod(){
       // List <RecordType> RT = [SELECT Id, Name, DeveloperName FROM RecordType where DeveloperName = 'CCM'];
      
        Account acc1 = new Account();
        acc1.name = 'Test Account';
        insert acc1;
        Case caseRec = new Case();
       // caseRec.FSL_Report_a_problem_comment__c = 'Testing SNOW Incident Record';
       //  caseRec.CSM_Jira_Config_Item__c = 'Middleware';
       // caseRec.CSM_Jira_Impact__c = '2';
       // caseRec.CSM_Jira_Urgency__c = '1 - Critical';
       //caseRec.CSM_Jira_Description__c = 'Testing';
       //caseRec.CSM_Jira_Work_Notes__c = 'Testing';
       //caseRec.CSM_SNow_Incident_Number__c = '';
        //caseRec.RecordTypeId = RT.get(0).Id;
        caseRec.Origin = 'Email';
        caseRec.Subject = 'test';
        caseRec.Description = 'test2';
        //caseRec.Status = 'Work in Progress';
        insert caseRec;
        
        Incident incidentRec = new Incident();
        incidentRec.CSM_Ticket_Config_Item__c = 'Middleware';
        incidentRec.Impact = '2';
        incidentRec.Urgency = '1';
        incidentRec.Description = 'Testing';
       // incidentRec.CSM_Ticket_Work_Notes__c = 'Testing';
        incidentRec.CSM_Ticket_Incident_Number__c = 'INC3547273';
        incidentRec.Service_Request__c=caseRec.id;
        incidentRec.Status='New';
        incidentRec.Subject='Test Data';
        insert incidentRec;
        
        ContentVersion cv = new ContentVersion();
        cv.versionData = Blob.valueof('Test');
        cv.title = 'TestContentVersion';
        cv.pathOnClient = 'Test';
        cv.FirstPublishLocationId = caseRec.Id;
        insert cv;
        
        CSM_SNow_Initiator_wwid__mdt metaFile = new CSM_SNow_Initiator_wwid__mdt();
        metaFile.Service_Request_Origin__c = 'Email';
        metaFile.Initiator_wwid__c = 'OY876';
        metaFile.SNOW_Assignment_Group__c = 'Corporate IT - Cummins Service System (CSS) Support';
        Blob key = Blob.valueOf('12345678901234567890123456789012');
        string algo = 'AES256';
        
        CSS_Integration_Details__c inte = new CSS_Integration_Details__c();
        inte.Name = 'FSL_ServiceNow';
        inte.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte.ApplicationName__c = 'FSL_ServiceNow';
        inte.End_Point__c = 'abc.com';
        inte.IsActive__c = true;
        inte.Method_Type__c = 'POST';
        insert inte;
        
        CSS_Integration_Details__c integrationDetails = new CSS_Integration_Details__c();
        integrationDetails.Name = 'FSL_ServiceNowUpdate';
        integrationDetails.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        integrationDetails.ApplicationName__c = 'FSL_ServiceNowUpdate';
        integrationDetails.End_Point__c = 'abc.com';
        integrationDetails.IsActive__c = true;
        integrationDetails.Method_Type__c = 'PUT';
        insert integrationDetails;
        
        CSS_Integration_Details__c integrationDetails2 = new CSS_Integration_Details__c();
        integrationDetails2.Name = 'FSL_ServiceNowAttachmentId';
        integrationDetails2.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails2.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails2.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        integrationDetails2.ApplicationName__c = 'FSL_ServiceNowAttachmentId';
        integrationDetails2.End_Point__c = 'abc.com';
        integrationDetails2.IsActive__c = true;
        integrationDetails2.Method_Type__c = 'POST';
        insert integrationDetails2;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
         System.Test.startTest(); 
        FSL_SendServiceOrderToServiceNow.sendCaseToServicenNowmethod(caseRec.Id,false,true);
        FSL_SendServiceOrderToServiceNow.sendCaseToServicenNowmethod(caseRec.Id,false,false);
        incidentRec.CSM_Ticket_Incident_Number__c ='INC3547273';
        update incidentRec;
        FSL_SendServiceOrderToServiceNow.sendCaseToServicenNowmethod(caseRec.Id,true,false);
        FSL_SendServiceOrderToServiceNow.checkIncidentRecord(caseRec.Id);
        FSL_SendServiceOrderToServiceNow.populateIncidentFiled(caseRec.Id);
        FSL_SendServiceOrderToServiceNow.checkAttachment(caseRec.Id);
        FSL_SendServiceOrderToServiceNow.incidentRecords(incidentRec.Id);
        FSL_SendServiceOrderToServiceNow.checkIncidentNo(caseRec.Id);
        System.Test.stopTest();
       
    
    }
    //this comments use for Test Production Deployment Purpose
}