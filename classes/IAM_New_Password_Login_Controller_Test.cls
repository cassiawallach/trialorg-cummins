/*
*create by :yash gupta
*/
@isTest
public class IAM_New_Password_Login_Controller_Test {
    static testMethod void Test1(){
        String appid;
        
        User u=[Select id,isActive from user where profile.name='System Administrator' AND isActive=true Limit 1];
         
             System.runAs(u) {
            //Create account
            Account portalAccount1 = new Account(
            Name = 'TestAccount',
            OwnerId = u.Id,
            RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
            );
            Database.insert(portalAccount1);
        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = portalAccount1.Id,
            RecordTypeId=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId(),
            Email ='test@test.com',
            IAM_Cummins_login_ID__c =  'testReclaim123@mail.com',
            IAM_Final_Approver__c = 'N',
            IAM_Qsolexpiration__c = 'testABC',
            IAM_swregexpire__c ='testCon',
            IAM_Internal__c = true,
            IAM_Applications__c = 'CSS_DN_Advanced',
            CMI_Contact_Type__c = 'Primary',
            IAM_is_Member_of__c = 'testMemeber'   
            );
            Database.insert(contact1);
        
        Profile portalProfile = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
        user u1= new user(
        Username ='your.user@gmail1234.com.iamdev',
            ContactId = contact1.Id,
            ProfileId = portalProfile.Id,
            Alias = 'test123',
            Email = 'test12345@test.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'McTesty',
            CommunityNickname = 'test12345',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            LanguageLocaleKey = 'en_US',
            IAM_Random_Number__c='123456',
            IAM_UID__c=contact1.IAM_Cummins_login_ID__c);
         
                 
         insert u1;
        
        App_Mapping__c app= new App_Mapping__c(
        Name='Marketplace',
        IAM_Default_Role__c='Admin',
        IAM_App_Protected_By__c='SAML',    
        Internal_Employee_link__c='',
        Registration__c=true,
        internal_Employee_Redirection__c=false
          
          );
       
        insert app;
                 
          appid=app.id;
            }
        Test.startTest(); 
        
        Test.setCurrentPageReference(new PageReference('Page.IAM_New_Password_Login')); 
        System.currentPageReference().getParameters().put('appid',appid);
        
        IAM_New_Password_Login_Controller iam=new IAM_New_Password_Login_Controller();
        
        PageReference pppp= iam.doLogin();     
        Test.stopTest();
    }

}