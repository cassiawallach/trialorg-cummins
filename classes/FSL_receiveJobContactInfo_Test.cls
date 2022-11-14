// Vijay - CT4-593 Pushing Test Class.
@isTest
public class FSL_receiveJobContactInfo_Test {
    
    @isTest
    static void testContactRequest()
    {
        //String myJSON =  '{"Header" :{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" }]}';
        String myJSON = '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "BMS"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "4","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS Trol""EmailNotification":"Y","TextNotification":"Y","LanguagePreference":"EN","NightlyCommunication":"N","MobilePhoneNumber":"7890123458","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"Update" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "46","ContactName": "TRAVIS","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00",,"EventFlag":"Add" }]}';
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        //Test User
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '1310102';
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        acc.Type = 'Customer';
        //added by Harsha
        acc.FSL_Source_ERP__c = 'BMS';
        insert acc;
        
        

        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '40';
        con.Phone = '0429883045';
        con.Email = 'test@test.com';
        con.IAM_Contact_Status__c = 'Inactive';
        //con.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='1234567890';
        con.RecordTypeId = recTypeId;
        //con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        // con.IAM_Contact_source__c = 'BMS';
        insert con;
        
        
        
        acc.FSL_Source_ERP__c = 'BMS';
        update acc;
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/contact/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        FSL_receiveJobContactInfo.doPostOperation();
    }
    
    @isTest
    static void testContactRequestinact()
    {
        //String myJSON =  '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" }]}';
        String myJSON = '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "BMS"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "4","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD", "EmailNotification": "Y", "NightlyCommunication": "N", "TextNotification": "N", "LanguagePreference": "EN"},{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS Trol","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"Update", "EmailNotification": "N", "NightlyCommunication": "N", "TextNotification": "Y", "LanguagePreference": "FR" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "46","ContactName": "TRAVIS","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"Add", "EmailNotification": "Y", "NightlyCommunication": "Y", "TextNotification":"Y", "LanguagePreference": "FR" }]}';
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '1310102';
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        acc.Type = 'Customer';
        //added by Harsha
        acc.FSL_Source_ERP__c = 'BMS';
        insert acc;
        
        
/*
        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '40';
        con.Phone = '(042) 988-3045';
        con.Email = 'test@test.com';
        con.IAM_Contact_Status__c = 'Inactive';
        con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        // con.IAM_Contact_source__c = 'BMS';
        insert con;
        
        
  */      
        acc.FSL_Source_ERP__c = 'BMS';
        update acc;
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/contact/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        FSL_receiveJobContactInfo.doPostOperation();
    }
    
    @isTest
    static void testUpdateContactRequest()
    {
        //String myJSON = '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "40","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" }]}';
        String myJSON = '{"Header":{"Status": " ","Sender":{"ServiceName": "GetJobContactInfo","SenderID": "Movex"},"Target": "CSS","Location": " "},"DataArea": [{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "42","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "test@tescom","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"ADD" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "41","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"Delete" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "","ContactID": "42","ContactName": "TRAVIS GRIGG","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"Update" },{"DistributorCode": " ","BranchCode": " ","CustomerCode": "1310102","ContactID": "","ContactName": "TRAVIS","ContactPhoneNo": "(042) 988-3045","EmailAddress": "","LastUpdatedDate":"2019-03-29T13:40:00","EventFlag":"Update" }]}';
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '1310102';
        acc.Name = 'Test Acc';
        acc.Cmi_account_status__c = 'Active';
        //added by Harsha
        acc.FSL_Source_ERP__c = 'BMS';
        acc.Type = 'Customer';
        insert acc;
        
        Contact con = new Contact();
        con.FirstName = 'Travis';
        con.LastName = 'Grigg';
        con.AccountId = acc.Id;
        con.FSL_Contact_Id__c = '42';
        con.Phone = '0429883045';
        con.Email = 'test@test.com';
        con.IAM_Contact_Status__c = 'Inactive';
        //con.Mobile_Phone__c='1237890456'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con.MobilePhone ='1237890456';
        con.RecordTypeId = recTypeId;
       
        //con.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert con;
        
        Contact con1 = new Contact();
        con1.FirstName = 'Travis';
        con1.LastName = 'Grigg';
        con1.AccountId = acc.Id;
        con1.FSL_Contact_Id__c = '41';
        con1.Phone = '(042) 988-3045';
        con1.Email = 'test@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        //con1.Mobile_Phone__c='1234567890'; // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
        con1.MobilePhone ='1234567890';
        //con1.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        con1.RecordTypeId = recTypeId;
        insert con1;
        
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/contact/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        
        FSL_receiveJobContactInfo.doPostOperation();
        FSL_JobContactWrapper.DataArea obj = new FSL_JobContactWrapper.DataArea();
    }
}