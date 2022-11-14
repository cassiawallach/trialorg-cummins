@isTest
private class IAM_User_Trigger_Helper_Test {
    //Vamsi - 02/23 - Added comment for test class execution
    @isTest static void myTest() {
        Account a = new Account();
        a.Name='Test User';
        a.IAM_Service_Provider_code__c='123421';
        a.Recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        a.Type='Fleet';
        insert a;
         
        Contact c= new contact();
        c.Accountid=a.id;
        c.FirstName='Fname';
        c.LastName='Lname';
        c.Email='oh611@cummins.com';
        c.Username__c='testusertriggerhelper@cmiuser.com';
        c.Recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c.IAM_Contact_Status__c='Active';
        c.CMI_Contact_Type__c='Secondary';
        Insert c; 
        
       Test.StartTest();
       c.lastName='USer';
       c.email='oh611@cummins2.com';
       Update c;
       
       Test.StopTest();
    }
    
    
    @isTest static void myTest2() {
        
         Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standardusertrigger@testorg.com');
        
       
         insert u;
       
       u.LAstName='email';
       Update u;
       
    }
}