/*********************************************************************************

Author       :   Sandeep Vuyyuru

Created Date :   23rd May,2022

Description  :   Unit test class for  IAM_CDO_UserRegistration.

*********************************************************************************/ 

@isTest
public class IAM_CDO_UserRegistration_Test{
    
    
    public static String createTestData(){
        
        Account accRecord = new Account();
        accRecord.Name = 'S360 Portal';        
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        accRecord.phone = '6884382997';
        accRecord.BillingCity='Columbus';
        accRecord.BillingStreet='340 Brown Street';
        accRecord.BillingCountry='United States';
        accRecord.BillingPostalCode='47201';
        accRecord.BillingState='Indiana'; 
        accRecord.CHANNEL_OF_DISTRIBUTION__c = 'SIR';
        accRecord.IAM_Primary_Market_Segment__c = 'Automotive';  
        accRecord.CMI_CId__c = '1087860';   
        insert accRecord ;
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Connected Solutions';
        app.IAM_Role__c = 'AccountExecutive';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        app.IAM_Subscription_Start_Date__c = System.today();
        app.IAM_Subscription_End_Date__c = System.today()+365;
        insert app;
        
        IAM_Application__c app2 = new IAM_Application__c();
        app2.IAM_Application_Name__c = 'S360 Portal';
        app2.IAM_Role__c = 'User';
        app2.IAM_Status__c = 'Active';
        app2.IAM_Account_Name__c = accRecord.id;
        app2.IAM_Subscription_Name__c = 'test';
        app2.IAM_Subscription_Start_Date__c = System.today();
        app2.IAM_Subscription_End_Date__c = System.today()+365;
        insert app2;
        
        return accRecord.Id;
    }
    
    static testMethod void test1(){
        String accId = createTestData();
        Account acc = [SELECT Id, CMI_CId__c FROM Account WHERE Id =: accId];
        
        //Contact
        Contact conNew = new Contact();
        conNew.accountID = acc.id;
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(); 
        conNew.Email= 'testing@test.com'; 
        conNew.FirstName = 'test';
        conNew.LastName = 'test';  
        conNew.Username__c = 'testing@test.com'; 
        insert conNew;
        
        IAM_CDO_UserRegistration.userInfo wrap = new IAM_CDO_UserRegistration.userInfo();
        
        
        String JsonMsg=JSON.serialize(wrap);
        wrap.appName = 'CDO';
        wrap.accountNumber = acc.CMI_CId__c;
        wrap.emailAddress = 'testing@test.com';
        wrap.userName = 'testing@test.com';
        wrap.firstName = 'testabc';
        wrap.lastName = 'abctest';
        wrap.isInternal = false;
        wrap.phoneNumber = '1234567890';
        wrap.role = 'AccountExecutive';
        wrap.roleType = 'external';
        wrap.accountAccess = 'abctest';
        
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_CDO_UserRegistration';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_CDO_UserRegistration.doPost(wrap);
        
        Test.stopTest();
        
    }
    
    static testMethod void test2(){
        String accId = createTestData();
        Account acc = [SELECT Id, CMI_CId__c FROM Account WHERE Id =: accId];
        IAM_CDO_UserRegistration.userInfo wrap = new IAM_CDO_UserRegistration.userInfo();
        
        
        String JsonMsg=JSON.serialize(wrap);
        wrap.appName = 'CDO';
        wrap.accountNumber = acc.CMI_CId__c;
        wrap.emailAddress = 'testing@test.com';
        wrap.userName = 'testing@test.com';
        wrap.firstName = 'testabc';
        wrap.lastName = 'abctest';
        wrap.isInternal = false;
        wrap.phoneNumber = '1234567890';
        wrap.role = 'AccountExecutive';
        wrap.roleType = 'external';
        wrap.accountAccess = 'abctest';
        
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_CDO_UserRegistration';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_CDO_UserRegistration.doPost(wrap);
        
        Test.stopTest();
        
    }
    
    static testMethod void test3(){
        String accId = createTestData();
        Account acc = [SELECT Id, CMI_CId__c FROM Account WHERE Id =: accId];
        
        Account accRecord = new Account();
        accRecord.Name = 'IT Test Company';        
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        accRecord.phone = '6884382997';
        accRecord.BillingCity='Columbus';
        accRecord.BillingStreet='340 Brown Street';
        accRecord.BillingCountry='United States';
        accRecord.BillingPostalCode='47201';
        accRecord.BillingState='Indiana'; 
        accRecord.CHANNEL_OF_DISTRIBUTION__c = 'SIR';
        accRecord.IAM_Primary_Market_Segment__c = 'Automotive';  
        accRecord.CMI_CId__c = '1087860';   
        insert accRecord ;
        
        //Contact
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(); 
        conNew.Email= 'testing@test.com'; 
        conNew.FirstName = 'test';
        conNew.LastName = 'test';  
        conNew.Username__c = 'testing@test.com'; 
        insert conNew;
        
        IAM_CDO_UserRegistration.userInfo wrap = new IAM_CDO_UserRegistration.userInfo();
        
        
        String JsonMsg=JSON.serialize(wrap);
        wrap.appName = 'CDO';
        wrap.accountNumber = acc.CMI_CId__c;
        wrap.emailAddress = 'testing@test.com';
        wrap.userName = 'testing@test.com';
        wrap.firstName = 'testabc';
        wrap.lastName = 'abctest';
        wrap.isInternal = false;
        wrap.phoneNumber = '1234567890';
        wrap.role = 'AccountExecutive';
        wrap.roleType = 'external';
        wrap.accountAccess = 'abctest';
        
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_CDO_UserRegistration';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_CDO_UserRegistration.doPost(wrap);
        
        Test.stopTest();
        
    }
    
    static testMethod void test4(){
        String accId = createTestData();
        
        IAM_CDO_UserRegistration.userInfo wrap = new IAM_CDO_UserRegistration.userInfo();
        String JsonMsg=JSON.serialize(wrap);
        wrap.appName = 'CDO';
        wrap.accountNumber = '123456789';
        wrap.emailAddress = 'testing@test.com';
        wrap.userName = 'testing@test.com';
        wrap.firstName = 'testabc';
        wrap.lastName = 'abctest';
        wrap.isInternal = false;
        wrap.phoneNumber = '1234567890';
        wrap.role = 'AccountExecutive';
        wrap.roleType = 'external';
        wrap.accountAccess = 'abctest';
        
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_CDO_UserRegistration';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_CDO_UserRegistration.doPost(wrap);
        
        Test.stopTest();
        
    }
    
    static testMethod void test5(){
        String accId = createTestData();
        
        IAM_CDO_UserRegistration.userInfo wrap = new IAM_CDO_UserRegistration.userInfo();
        String JsonMsg=JSON.serialize(wrap);
        wrap.appName = 'S360 Portal';
        wrap.accountNumber = '123456789';
        wrap.emailAddress = 'testing@test.com';
        wrap.userName = 'testing@test.com';
        wrap.firstName = 'testabc';
        wrap.lastName = 'abctest';        
        wrap.phoneNumber = '1234567890';
        wrap.role = 'User';        
        
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_CDO_UserRegistration';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_CDO_UserRegistration.createSupplier360(wrap);
        
        Test.stopTest();
        
    }
    static testMethod void test6(){
        String accId = createTestData();
        
        IAM_CDO_UserRegistration.userInfo wrap = new IAM_CDO_UserRegistration.userInfo();
        String JsonMsg=JSON.serialize(wrap);
        wrap.appName = 'S360 Portal';
        wrap.accountNumber = '123456789';
        wrap.emailAddress = 'testingtest.com';
        wrap.userName = 'testing@test.com';
        wrap.firstName = 'testabc';
        wrap.lastName = 'abctest';        
        wrap.phoneNumber = '1234567890';
        wrap.role = 'User';        
        
        
        Test.startTest();
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/IAM_CDO_UserRegistration';  //Request URL
        req.httpMethod = 'POST';//HTTP Request Type
        req.requestBody = Blob.valueof(JsonMsg);
        RestContext.request = req;
        RestContext.response= res;
        IAM_CDO_UserRegistration.createSupplier360(wrap);
        
        Test.stopTest();
        
    }
}