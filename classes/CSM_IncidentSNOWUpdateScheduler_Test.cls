@isTest(SeeAllData=False)
public class CSM_IncidentSNOWUpdateScheduler_Test {
    static testMethod void CSM_IncidentSNOWUpdateScheduler_Test() {
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
        
        CSS_Integration_Details__c inte1 = new CSS_Integration_Details__c();
        inte1.Name = 'FSL_ServiceNow_Get';
        inte1.Username__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte1.Passcode__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('test')));
        inte1.Key__c = EncodingUtil.base64Encode(Crypto.encryptWithManagedIV('AES256', key, Blob.valueOf('1234')));
        inte1.ApplicationName__c = 'FSL_ServiceNow_Get';
        inte1.End_Point__c = '{INC}'+'abc.com';
        inte1.IsActive__c = true;
        inte1.Method_Type__c = 'GET';
        insert inte1;
        
        Account acc1 = new Account();
        acc1.name = 'TestAccount';
        insert acc1;
        
        Case cas = new Case( Subject = 'test1', Description = 'Test Data',AccountId=acc1.Id); 
        insert cas;
        List<Incident> inctlist = new List<Incident>();
        Incident inc = new Incident( CSM_Ticket_Incident_Number__c ='INC3547273', Status ='New',Service_Request__c=cas.id,Subject='Test Data',SNow_Last_Synched_Date__c=system.now().addDays(-1));
        inctlist.add(inc);
        insert inctlist;
        Test.startTest();
         Test.setMock(HttpCalloutMock.class, new CSM_IncidentSNOWUpdateServiceMock('Success'));
        CSM_IncidentSNOWUpdateScheduler  objScheduler= new CSM_IncidentSNOWUpdateScheduler();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, objScheduler );
        Test.stopTest();
        
        
    }
   // Missing CMP for SFDC SNOW functionality
}