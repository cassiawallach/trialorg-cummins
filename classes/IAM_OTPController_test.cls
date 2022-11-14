@isTest(SeeAllData=True)
private class IAM_OTPController_test{
    
   Static testMethod void testForgetPassword(){
   
        Account a= new Account();       
       a.Name = 'Test Company';
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        a.phone = '6884382997';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        insert a;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.LastName = 'test852';
        Con.AccountId = a.Id;
        con.IAM_Cummins_Login_ID__c='test000@eiam.com';
        Con.Email = 'test000@eiam.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Active';
        Con.iam_Internal__c=false;
        Con.IAM_from_Registration__c=True;
        insert Con;
   
         App_Mapping__c app=new App_Mapping__c();
            app.name='TestApp';
            app.Back_page__c='https://login.salesforce.com/';
            app.Login_Url__c='https://www.facebook.com/';
            app.IAM_Default_Role__c='User';
            app.IAM_App_Protected_By__c='SAML';
            insert app;
            
            List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_Site_Admin_Community' limit 1];
            
           //User Creation
        User newUser = new User();
        
        newUser.FirstName = 'UserFirstName';
                    newUser.LastName = 'test';
                    newUser.Email = 'test@test.com';   
                    newUser.CompanyName = 'IT Test Company';        
                    //newUser.CommunityNickname = 'test';
                    newUser.Username = 'Sandeep89@test.com' ;
                    newUser.Alias = 'test';
                    newUser.TimeZoneSidKey = 'GMT';
                    newUser.LocaleSidKey= 'en_US';
                    newUser.EmailEncodingKey = 'UTF-8';
                    newUser.LanguageLocaleKey = 'en_US';         
                    newUser.ProfileId = pf[0].Id ;                                  
                    newUser.ContactId =Con.Id;                   
                    newUser.isActive = TRUE;
                    newUser.Street = '123 Test St';
                    newUser.FederationIdentifier = '2468741';
                    
        insert newUser;
         System.runAs(newUser){
        ApexPages.currentPage().getParameters().put('appid', app.id);      
        ApexPages.currentPage().getParameters().put('username','Sandeep89@test.com');  
        IAM_OTPPageController OTP = new IAM_OTPPageController();
        OTP.redirectRegistartionpage();
       OTP.SendOTPToUser();
       }
    
 }
 }