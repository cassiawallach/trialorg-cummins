@isTest	
public class IAM_CDO_updateUserInformation_Test {
    
    @isTest
    public static void testDoPost1(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/IAM_CDO_updateUserInformation/*';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        IAM_CDO_updateUserInformation.userInfo classObj = new IAM_CDO_updateUserInformation.userInfo();
        classObj.firstName = 'testFirst';
        classObj.lastName = 'testLast';
        classObj.emailAddress = 'test@test.com';
        classObj.languagePreference = 'English';
        classObj.role = 'Service Training User';
        classObj.subscriptionStatus = 'Inactive';
        
        Test.startTest();
        IAM_CDO_updateUserInformation.doPost(classObj);
        Test.stopTest();        
    }
    
    @isTest
    public static void testDoPost2(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/IAM_CDO_updateUserInformation/*';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        
        IAM_CDO_updateUserInformation.userInfo classObj = new IAM_CDO_updateUserInformation.userInfo();
        classObj.firstName = con.FirstName;
        classObj.lastName = con.LastName;
        classObj.emailAddress = con.Email;
        classObj.languagePreference = con.Language_Preferences__c;
        classObj.role = 'AccountManager';
        classObj.subscriptionStatus = 'Active';
        classObj.userName = con.Username__c;
        classObj.accountNumber = [SELECT Id, CMI_CId__c FROM Account WHERE Id =: acc.Id].CMI_CId__c;
        
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'Connected Solutions';
        app1.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        app1.IAM_Role__c = 'AccountManager';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.IAM_Subscription_Start_Date__c=System.today();
        app1.IAM_Subscription_End_Date__c= System.today() + 3;
        app1.IAM_Subscription_Count__c = 10;
        app1.IAM_Free_Subscription__c= true;
        app1.IAM_License_Type__c = 'test';
        app1.IAM_Qsolexpiration__c = 'test';
        app1.IAM_Source__c = 'Marketplace';
        insert app1;
        
        List<IAM_Contact_Provisioning__c> icp= new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= con.id; 
        obj.IAM_Start_Date__c = System.today();
        obj.IAM_End_Date__c = System.today()+1;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_License_Type__c = 'test';
        obj.IAM_Status__c = 'Active';
        obj.IAM_Account_Application__c = app1.Id;
        obj.IAM_Subscription_Name__c = 'test'; 
        obj.IAM_Qsolexpiration__c = 'test';
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();   
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        
        Test.startTest();
        IAM_CDO_updateUserInformation.doPost(classObj);
        Test.stopTest();        
    }
    
    @isTest
    public static void testDoPost3(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/IAM_CDO_updateUserInformation/*';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        
        IAM_CDO_updateUserInformation.userInfo classObj = new IAM_CDO_updateUserInformation.userInfo();
        classObj.firstName = con.FirstName;
        classObj.lastName = con.LastName;
        classObj.emailAddress = con.Email;
        classObj.languagePreference = con.Language_Preferences__c;
        classObj.role = 'AccountManager';
        classObj.subscriptionStatus = 'Active';
        classObj.userName = con.Username__c;
        classObj.accountNumber = [SELECT Id, CMI_CId__c FROM Account WHERE Id =: acc.Id].CMI_CId__c;
        
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'Connected Solutions';
        app1.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        app1.IAM_Role__c = 'AccountManager';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.IAM_Subscription_Start_Date__c=System.today();
        app1.IAM_Subscription_End_Date__c= System.today() + 3;
        app1.IAM_Subscription_Count__c = 10;
        app1.IAM_Free_Subscription__c= true;
        app1.IAM_License_Type__c = 'test';
        app1.IAM_Qsolexpiration__c = 'test';
        app1.IAM_Source__c = 'Marketplace';
        insert app1;
        
        List<IAM_Contact_Provisioning__c> icp= new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= con.id; 
        obj.IAM_Start_Date__c = System.today();
        obj.IAM_End_Date__c = System.today()+1;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_License_Type__c = 'test';
        obj.IAM_Status__c = 'Inactive';
        obj.IAM_Account_Application__c = app1.Id;
        obj.IAM_Subscription_Name__c = 'test'; 
        obj.IAM_Qsolexpiration__c = 'test';
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();   
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        
        Test.startTest();
        IAM_CDO_updateUserInformation.doPost(classObj);
        Test.stopTest();        
    }
    
    @isTest
    public static void testDoPost4(){
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/IAM_CDO_updateUserInformation/*';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        
        IAM_CDO_updateUserInformation.userInfo classObj = new IAM_CDO_updateUserInformation.userInfo();
        classObj.firstName = con.FirstName;
        classObj.lastName = con.LastName;
        classObj.emailAddress = con.Email;
        classObj.languagePreference = con.Language_Preferences__c;
        classObj.role = 'AccountManager';
        classObj.subscriptionStatus = 'Active';
        classObj.userName = con.Username__c;
        classObj.accountNumber = [SELECT Id, CMI_CId__c FROM Account WHERE Id =: acc.Id].CMI_CId__c;
        
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'Connected Solutions';
        app1.RecordTypeId=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        app1.IAM_Role__c = 'AccountManager';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = acc.id;
        app1.IAM_Subscription_Name__c = 'test';
        app1.IAM_Subscription_Start_Date__c=System.today();
        app1.IAM_Subscription_End_Date__c= System.today() + 3;
        app1.IAM_Subscription_Count__c = 10;
        app1.IAM_Free_Subscription__c= true;
        app1.IAM_License_Type__c = 'test';
        app1.IAM_Qsolexpiration__c = 'test';
        app1.IAM_Source__c = 'Marketplace';
        insert app1;
        
        List<IAM_Contact_Provisioning__c> icp= new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= con.id; 
        obj.IAM_Start_Date__c = System.today();
        obj.IAM_End_Date__c = System.today()+1;
        obj.IAM_Application_Name__c = 'Connected Solutions';
        obj.IAM_Role__c = 'AccountManager';
        obj.IAM_License_Type__c = 'test';
        obj.IAM_Status__c = 'Pending';
        obj.IAM_Account_Application__c = app1.Id;
        obj.IAM_Subscription_Name__c = 'test'; 
        obj.IAM_Qsolexpiration__c = 'test';
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();   
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        
        Test.startTest();
        IAM_CDO_updateUserInformation.doPost(classObj);
        Test.stopTest();        
    }
}