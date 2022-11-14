@IsTest(SeeAllData=false)
public class CSM_IncidentSNOWUpdateController_Test {
    
    public static testmethod void Testmethod_Positivemethod()
    {
        
        Account acc3 = new Account();
        acc3.name = 'Test Account1';
        insert acc3;
        
        Case caseRec1 = new Case();
        caseRec1.Origin = 'Email';
        caseRec1.Subject = 'Test';
        caseRec1.Description = 'testing Data';
        caseRec1.AccountId=acc3.Id;
        insert caseRec1;
        List<Incident> inctlist = new List<Incident>();
        //Incident inc1 = new Incident(CSM_Ticket_Incident_Number__c ='INC3547273', Subject='Test',Status ='In Queue',SNow_Last_Synched_Date__c=System.today(),Service_Request__c=caseRec.id);
        // inctlist.add(inc1);
        Incident incidentRec = new Incident();
        incidentRec.CSM_Ticket_Config_Item__c = 'Middleware';
        incidentRec.Impact = '3';
        incidentRec.Urgency = '3';
        incidentRec.Description = 'Testing';
        incidentRec.CSM_Ticket_Incident_Number__c = 'INC3547273';
        incidentRec.Service_Request__c=caseRec1.id;
        incidentRec.Status='New';
        incidentRec.Subject='Test Data';
        incidentRec.SNow_Last_Synched_Date__c=System.today();
        inctlist.add(incidentRec);
        Insert inctlist;
        
        
        CSM_SNow_Initiator_wwid__mdt metaFile = new CSM_SNow_Initiator_wwid__mdt();
        metaFile.Service_Request_Origin__c = 'Email';
        metaFile.Initiator_wwid__c = 'OY876';
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
        integrationDetails.Method_Type__c = 'POST';
        insert integrationDetails;
        
        CSS_Integration_Details__c integrationDetails2 = new CSS_Integration_Details__c();
        integrationDetails2.Name = 'FSL_ServiceNow_Get';
        integrationDetails2.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails2.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails2.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        integrationDetails2.ApplicationName__c = 'FSL_ServiceNow_Get';
        integrationDetails2.End_Point__c = 'abc.com';
        integrationDetails2.IsActive__c = true;
        integrationDetails2.Method_Type__c = 'GET';
        insert integrationDetails2;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSM_IncidentSNOWUpdateServiceMock('Success'));
        CSM_IncidentSNOWUpdateController.getIncidentStatus(caseRec1.Id);
        Test.stopTest();
        
    }
        public static testmethod void Testmethod_NegativeMethod()
    {
        
        Account acc3 = new Account();
        acc3.name = 'Test Account1';
        insert acc3;
        
        Case caseRec1 = new Case();
        caseRec1.Origin = 'Email';
        caseRec1.Subject = 'Test';
        caseRec1.Description = 'testing Data';
        caseRec1.AccountId=acc3.Id;
        insert caseRec1;
        List<Incident> inctlist = new List<Incident>();
        //Incident inc1 = new Incident(CSM_Ticket_Incident_Number__c ='INC3547273', Subject='Test',Status ='In Queue',SNow_Last_Synched_Date__c=System.today(),Service_Request__c=caseRec.id);
        // inctlist.add(inc1);
        Incident incidentRec = new Incident();
        incidentRec.CSM_Ticket_Config_Item__c = 'Middleware';
        incidentRec.Impact = '3';
        incidentRec.Urgency = '3';
        incidentRec.Description = 'Testing';
        incidentRec.CSM_Ticket_Incident_Number__c = 'INC3547273';
        incidentRec.Service_Request__c=caseRec1.id;
        incidentRec.Status='New';
        incidentRec.Subject='Test Data';
        incidentRec.SNow_Last_Synched_Date__c=System.today();
        inctlist.add(incidentRec);
        Insert inctlist;
        
        
        CSM_SNow_Initiator_wwid__mdt metaFile = new CSM_SNow_Initiator_wwid__mdt();
        metaFile.Service_Request_Origin__c = 'Email';
        metaFile.Initiator_wwid__c = 'OY876';
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
        integrationDetails.Method_Type__c = 'POST';
        insert integrationDetails;
        
        CSS_Integration_Details__c integrationDetails2 = new CSS_Integration_Details__c();
        integrationDetails2.Name = 'FSL_ServiceNow_Get';
        integrationDetails2.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails2.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails2.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        integrationDetails2.ApplicationName__c = 'FSL_ServiceNow_Get';
        integrationDetails2.End_Point__c = 'abc.com';
        integrationDetails2.IsActive__c = true;
        integrationDetails2.Method_Type__c = 'GET';
        insert integrationDetails2;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSM_IncidentSNOWUpdateServiceMock('failure'));
        CSM_IncidentSNOWUpdateController.getIncidentStatus(caseRec1.Id);
        Test.stopTest();
        
    }
     public static testmethod void Testmethod_ExceptionMethod()
    {
        
        Account acc3 = new Account();
        acc3.name = 'Test Account1';
        insert acc3;
        
        Case caseRec1 = new Case();
        caseRec1.Origin = 'Email';
        caseRec1.Subject = 'Test';
        caseRec1.Description = 'testing Data';
        caseRec1.AccountId=acc3.Id;
        insert caseRec1;
        List<Incident> inctlist = new List<Incident>();
        //Incident inc1 = new Incident(CSM_Ticket_Incident_Number__c ='INC3547273', Subject='Test',Status ='In Queue',SNow_Last_Synched_Date__c=System.today(),Service_Request__c=caseRec.id);
        // inctlist.add(inc1);
        Incident incidentRec = new Incident();
        incidentRec.CSM_Ticket_Config_Item__c = 'Middleware';
        incidentRec.Impact = '3';
        incidentRec.Urgency = '3';
        incidentRec.Description = 'Testing';
        incidentRec.CSM_Ticket_Incident_Number__c = 'INC3547273';
        incidentRec.Service_Request__c=caseRec1.id;
        incidentRec.Status='New';
        incidentRec.Subject='Test Data';
        incidentRec.SNow_Last_Synched_Date__c=System.today();
        inctlist.add(incidentRec);
        Insert inctlist;
        
        
        CSM_SNow_Initiator_wwid__mdt metaFile = new CSM_SNow_Initiator_wwid__mdt();
        metaFile.Service_Request_Origin__c = 'Email';
        metaFile.Initiator_wwid__c = 'OY876';
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
        integrationDetails.Method_Type__c = 'POST';
        insert integrationDetails;
        
        CSS_Integration_Details__c integrationDetails2 = new CSS_Integration_Details__c();
        integrationDetails2.Name = 'FSL_ServiceNow_Get';
        integrationDetails2.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails2.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        integrationDetails2.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        integrationDetails2.ApplicationName__c = 'FSL_ServiceNow_Get';
        integrationDetails2.End_Point__c = 'abc.com';
        integrationDetails2.IsActive__c = true;
        integrationDetails2.Method_Type__c = 'GET';
        insert integrationDetails2;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new CSM_IncidentSNOWUpdateServiceMock(''));
        CSM_IncidentSNOWUpdateController.getIncidentStatus(caseRec1.Id);
        Test.stopTest();
        
    }
    //this comments use for deployment purpose Misisng cmp  
}