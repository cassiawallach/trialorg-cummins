@isTest(SeeallData=true)
private class CMI_clsGenerateUserIdOnAccount_test
{
 
   static testMethod void ValidateTest0()
  {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
        string TestclsGenerateUserIdOnAccount;
        Account acct = new Account();
        
        acct.Name = 'Test1001';
        acct.CMI_Account_Status__c='Active-Indemnified';
        acct.CMI_Moratorium__c = 'test1001';
        acct.CMI_CDA_Status__c='Signed by Customer';
        acct.CMI_Region__c=    'North America and Caribbean';
        acct.CSS_Timezone__c='(GMT+11:00) Solomon Is. Time (Pacific/Guadalcanal)';
        acct.CSS_Language__c='English';
        acct.CSS_Locale__c='English(United States)';
        acct.RecordTypeId=devRecordTypeId;
        acct.CMI_Moratorium_End_Date__c =Date.today().addDays(10);
        acct.CMI_Request_withdrawn__c = false;
        insert acct;
        
        Contact objCon = new Contact();
        objCon.FirstName= 'FNAME';
        objCon.LastName='LNAME';
        objCon.Email='test@gmail.com';
        objCon.Phone='8989898989';
        objCon.Created_User_Id__c =false;
        objCon.AccountId=acct.Id;
        insert objCon;
     Profile p = [SELECT Id FROM Profile WHERE Name='CS_Community_User'];
        User objUser=new User(Alias = 'test', Email='test@gmail.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Pacific/Guadalcanal', UserName='test@gmail.com',isActive=true,ContactId =objCon.id);
        insert objUser; 
        
        if(acct.Id != null)
        {
            CMI_clsGenerateUserIdOnAccount.generateUserId(acct.Id, 'CMI_clsGenerateUserIdOnAccount');
        }
        
        
  }
    static testMethod void ValidateTest1()
  {
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
        string TestclsGenerateUserIdOnAccount;
        Account acct = new Account();
        acct.Name = 'Test1001';
        acct.CMI_Account_Status__c='Active-Indemnified';
        acct.CMI_Moratorium__c = 'test1001';
        acct.CMI_CDA_Status__c='Signed by Customer';
        acct.CMI_Region__c=    'North America and Caribbean';
        acct.CSS_Timezone__c='(GMT+11:00) Solomon Is. Time (Pacific/Guadalcanal)';
        acct.CSS_Language__c='English';
        acct.CSS_Locale__c='English(United States)';
        acct.RecordTypeId=devRecordTypeId;
        acct.CMI_Moratorium_End_Date__c =Date.today().addDays(10);
        acct.CMI_Request_withdrawn__c = false;
       // acct.IsCustomerPortal = True;
        acct.CMI_Customer_SK__c = 'abc';
        insert acct;
        
        Contact objCon = new Contact();
        objCon.FirstName= 'FNAME';
        objCon.LastName='LNAME';
        objCon.Email='test1@gmail.com';
        objCon.Phone='8989898989';
        objCon.Created_User_Id__c =false;
        objCon.AccountId=acct.Id;
        insert objCon;
        
        if(acct.Id != null)
        {
            CMI_clsGenerateUserIdOnAccount.generateUserId(acct.Id, 'CMI_clsGenerateUserIdOnAccount');
        }
        
        
       
  }
  
  static testMethod void ValidateTest4()
    {
       string ClassName='CMI_APIAccountCreation';
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
        string TestclsGenerateUserIdOnAccount;
        Account acct = new Account();
        acct.Name = 'CMI_APIAccountCreation';
        
        acct.CMI_Account_Status__c='Active-Indemnified';
        acct.CMI_Moratorium__c = 'test1001';
        acct.CMI_CDA_Status__c='Signed by Customer';
        acct.CMI_Region__c=    'North America and Caribbean';
        acct.CSS_Timezone__c='(GMT+11:00) Solomon Is. Time (Pacific/Guadalcanal)';
        acct.CSS_Language__c='English';
        acct.CSS_Locale__c='English(United States)';
        acct.RecordTypeId=devRecordTypeId;
        acct.CMI_Moratorium_End_Date__c =Date.today().addDays(10);
        acct.CMI_Request_withdrawn__c = false;
        insert acct;
        
        
        
        Contact objCon = new Contact();
        objCon.FirstName= 'FNAME5';
        objCon.LastName='LNAME5';
        objCon.Email='test5@gmail.com';
        objCon.Phone='89898989895';
        objCon.Created_User_Id__c =true;
        objCon.AccountId=acct.Id;
        insert objCon;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CS_Community_User'];
        User objUser=new User(Alias = 'test5', Email='test5@gmail.com', 
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
        LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='Pacific/Guadalcanal', UserName='test5@gmail.com',IsActive=false,ContactId =objCon.id);
        insert objUser;
        
        
        if(acct.Id != null)
        {
            CMI_clsGenerateUserIdOnAccount.generateUserId(acct.Id, 'CMI_clsGenerateUserIdOnAccount');
        }
    }
}