/*********************************************************************************

Author       :   Sandeep Vuyyuru

Created Date :   21st May,2019

Description  :   Unit test class for  IAM_Fleetguard_ChangePassword.
*********************************************************************************/

@isTest
public class IAM_Fleetguard_ChangePassword_Testclass{

@testSetup
public static void createTestData(){
      Account accRecord = new Account();
        accRecord.Name = 'Test Company';
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        accRecord.phone = '6884382997';
        insert accRecord ;
        
        //Contact
        Contact conNew = new Contact();
        conNew.accountID = accRecord.id;
        conNew.RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(); 
        conNew.Email= 'test1234@test12345.com'; 
        conNew.FirstName = 'test12345@test12345';
        conNew.LastName = 'test12345@testlastname';  
       conNew.IAM_Cummins_login_ID__c =  'test12345unique1@test12345.com'; 
        insert conNew;
        
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'System administrator' limit 1];
     
        //User Creation
       User newUser = new User();
     
        newUser.FirstName = 'UserFirstName';
                    newUser.LastName = 'test';
                    newUser.Email = 'test@test1con.com';   
                    newUser.CompanyName = 'IT Test Company';        
                    newUser.CommunityNickname = 'testtest12345';
                    newUser.Username = 'test12345unique1@test12345.com' ;
                    newUser.Alias = 'testsan';
                    newUser.TimeZoneSidKey = 'GMT';
                    newUser.LocaleSidKey= 'en_US';
                    newUser.EmailEncodingKey = 'UTF-8';
                    newUser.LanguageLocaleKey = 'en_US';         
                    newUser.ProfileId = pf[0].Id ;                                  
                    //newUser.ContactId =conNew.Id;                   
                    newUser.isActive = TRUE;
                    newUser.Street = '123 Test St';
                    newUser.FederationIdentifier = '2468741'+system.now();
                    
        insert newUser;

}
 
    
    static testMethod void test1(){
    
   //user u = [select id,username from User limit 1];
     
    Test.startTest();

   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/IAM_Fleetguard_ChangePassword';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type
    //req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    IAM_Fleetgaurd_ChangePassword.doPost('test12345unique1@test12345.com','newpassword');
   //update TestOpp;
    Test.stopTest();
    
    }
    static testMethod void test2(){
    Test.startTest();

   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/IAM_Fleetguard_ChangePassword';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type   
    RestContext.request = req;
    RestContext.response= res;
    IAM_Fleetgaurd_ChangePassword.doPost('test','');  
    Test.stopTest();
    }
    static testMethod void test3(){
    Test.startTest();

   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();

    req.requestURI = '/services/apexrest/IAM_Fleetguard_ChangePassword';  //Request URL
    req.httpMethod = 'POST';//HTTP Request Type   
    RestContext.request = req;
    RestContext.response= res;
    IAM_Fleetgaurd_ChangePassword.doPost('','newPassword');  
    Test.stopTest();
    }
    
    }