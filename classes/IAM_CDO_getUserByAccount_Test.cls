@isTest
public class IAM_CDO_getUserByAccount_Test {
public static String createTestData(){
        
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
        
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Connected Solutions';
        app.IAM_Role__c = 'AccountExecutive';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        app.IAM_Subscription_Start_Date__c = System.today();
        app.IAM_Subscription_End_Date__c = System.today()+365;
        insert app;
        
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(); 
        conNew.Email= 'testing@test.com'; 
        conNew.FirstName = 'test';
        conNew.LastName = 'test';  
        conNew.Username__c = 'testing@test.com'; 
        insert conNew;
        
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= conNew.id; 
        obj.IAM_Start_Date__c = System.today();
        obj.IAM_End_Date__c = System.today()+1;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Status__c = 'Active';
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();   
        obj.IAM_Account_Application__c = app.Id;
        obj.IAM_Role__c = 'AccountExecutive';
        insert obj;
        
        return accRecord.Id;
    }
    
    public static testMethod void test1(){
        String accId = createTestData();
        Account acc = [SELECT Id, CMI_CId__c FROM Account WHERE Id =: accId];
        
        IAM_CDO_getUserByAccount.getUserInfo wrap = new IAM_CDO_getUserByAccount.getUserInfo();
        String JsonMsg=JSON.serialize(wrap);
        wrap.accountNumber = acc.CMI_CId__c;
        wrap.emailAddress = 'testing@test.com';
        wrap.userName = 'testing@test.com';
        wrap.firstName = 'testabc';
        wrap.lastName = 'abctest';
        wrap.roleType = 'Internal';
        wrap.role = 'AccountExecutive';
        wrap.userStatus = 'Active';
        wrap.subscriptionStatus = 'Active';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        //req.requestURI = '/services/apexrest/IAM_CDO_getUserByAccount';
         req.requestUri = URL.getSalesforceBaseUrl().toExternalForm()
            + '/services/apexrest/IAM_CDO_getUserByAccount/'
            + acc.CMI_CId__c;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        IAM_CDO_getUserByAccount.doGet();
        Test.stopTest();
    }
}