@isTest
public class IAM_CustomLoginController_RLS_Test {
  @testSetup        
  public static void createTestData(){
        
      /*Account a1= new Account();
        a1.Name = 'Test Company';          
        a1.phone = '6884382997';
        insert a1;*/
            
        Account a= new Account();
        a.Name='Identity Individual Users';
        //a.ParentId = a1.Id;
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        a.phone = '6884382997';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        a.IAM_Service_Provider_Code__c = '54699';
        a.CSS_DBCode__c = 'tesC';
        a.CSS_DistributorCode__c = 'tesD'; 
        a.CSS_Locale__c  = 'English(United States)';
        a.CSS_Language__c  = 'English(United States)'; 
        a.CSS_Timezone__c  = '(GMT+00:00) Greenwich Mean Time (GMT)';
        a.CSS_DealerCode__c = 'testD';
        a.IAM_Movex_Customer_Code__c = 'testMov';
        a.IAM_WWSPS_Regions__c = 'US and Canada';
        insert a;
        
        IAM_Application__c iamApp=new IAM_Application__c();
        iamApp.IAM_Application_Name__c='Box External Partners';
        iamApp.IAM_Account_Name__c=a.id;
        iamApp.IAM_Role__c='User';
        iamApp.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('BOX External Partners').getRecordTypeId();
        iamApp.IAM_Status__c='Active';
        iamApp.IAM_Free_Subscription__c=True;
        insert iamApp;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.LastName = 'test852';
        con.IAM_Cummins_Login_ID__c='testReclaim@eiam.com';
        con.Username__c='testReclaimm@eiam.com';
        Con.Email = 'test000@eiam.com';
        Con.phone = '1112223335';
        con.Accountid=a.id;
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Active';
        Con.iam_Internal__c=true;
        Con.IAM_Individual_Company_Name__c = 'testI';
        Con.IAM_from_Registration__c=True;   
        Con.IAM_Contact_Status__c = 'Active';
        Con.phone = '8989898989';  
        Con.IAM_Final_Approver__c = 'N';
        Con.IAM_Qsolexpiration__c = 'testABC';
        Con.IAM_swregexpire__c ='testCon';
        Con.IAM_Internal__c = true;
        Con.IAM_Applications__c = 'css_dn_tech';
        Con.CMI_Contact_Type__c = 'Primary';
        Con.IAM_is_Member_of__c = 'testMemeber';
        Con.IAM_Legacy_User__c = True;        
        con.IAM_Challange_Question__c = 'What is your Birth Place?';
        con.IAM_Challange_Answer__c = 'test2';
        insert Con;
      
      contact Con2=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con2.FirstName = 'test12';
        Con2.LastName = 'test8523';
        con2.IAM_Cummins_Login_ID__c='test00012@eiam.com';
        con2.Username__c='testReclaiem@eiam.com';
        Con2.Email = 'test00012@eiam.com';
        Con2.phone = '1112224445';
        con2.Accountid=a.id;
        Con2.MailingStreet = 'Test Street';
        Con2.MailingCity = 'Test City';
        Con2.MailingPostalCode = '11111';
        Con2.MailingCountryCode = 'US';
        Con2.MailingStateCode = 'IN';
        Con2.iam_Internal__c=true;
        Con2.IAM_Individual_Company_Name__c = 'testI';
        Con2.IAM_from_Registration__c=True;
        Con2.IAM_Contact_Status__c = 'Pending';     
        Con2.phone = '8989898989';  
        Con2.IAM_Final_Approver__c = 'N';
        Con2.IAM_Qsolexpiration__c = 'testABC';
        Con2.IAM_swregexpire__c ='testCon';
        Con2.IAM_Internal__c = true;
        Con2.IAM_Applications__c = 'css_dn_tech';
        Con2.CMI_Contact_Type__c = 'Primary';
        Con2.IAM_is_Member_of__c = 'testMemeber';
        Con2.IAM_Legacy_User__c = False;        
        con2.IAM_Challange_Answer__c = 'test';
        con2.IAM_Challange_Question__c = 'What is your Birth Place?';
        insert Con2;
        
        App_Mapping__c app=new App_Mapping__c();
        app.name='BOX External Partners';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_OAM_Resource_URL__c = 'https://csouat-cumminscss.cs3.force.com/cw/idp/login?app=0spQ0000000CaZk&resource_url=https://rsweb-stg-ac.cummins.com/RSW/home.action';
        app.IAM_Default_Role__c='User';
        app.IAM_App_Protected_By__c='SAML';
        insert app; 
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_Site_Admin_Community' limit 1];
        
        
        //User Creation
        User newUser = new User();
        
        newUser.FirstName = 'UserFirstName';
                    newUser.LastName = 'test';
                    newUser.Email = 'test000@eiam.com';  
                    //newUser.UserRoleId = 
                    newUser.CompanyName = 'IT Test Company';        
                    //newUser.CommunityNickname = 'test';
                    newUser.Username = 'sushma.rajput@test.com' ;
                    newUser.Alias = 'login2';
                    newUser.TimeZoneSidKey = 'GMT';
                    newUser.LocaleSidKey= 'en_US';
                    newUser.EmailEncodingKey = 'UTF-8';
                    newUser.LanguageLocaleKey = 'en_US';         
                    newUser.ProfileId = pf[0].Id ;                                  
                    newUser.ContactId =Con.Id;                   
                    newUser.isActive = TRUE;
                    newUser.Street = '123 Test St';
                    newUser.FederationIdentifier = 'testReclaim@eiam.com';
                    
        insert newUser;
        
        
        User newUser2 = new User();
        
        newUser2.FirstName = 'UserFirstName';
                    newUser2.LastName = 'san';
                    newUser2.Email = 'sandy@eiam.com';  
                    //newUser.UserRoleId = 
                    newUser2.CompanyName = 'IT Test Company';        
                    //newUser2.CommunityNickname = 'testsa';
                    newUser2.Username = 'test00012@eiam.com';
                    newUser2.Alias = 'login1';
                    newUser2.TimeZoneSidKey = 'GMT';
                    newUser2.LocaleSidKey= 'en_US';
                    newUser2.EmailEncodingKey = 'UTF-8';
                    newUser2.LanguageLocaleKey = 'en_US';         
                    newUser2.ProfileId = pf[0].Id ;                                  
                    newUser2.ContactId =Con2.Id;                   
                    newUser2.isActive = TRUE;
                    newUser2.Street = '123 Test St';
                    newUser2.FederationIdentifier = 'test00012@eiam.com';
                    
        insert newUser2;

        
  }
  
  
 Static testMethod void testCumminsRedirect(){    

 //createTestData();
 
   User loggedUser = [Select Id, isActive, Email, FederationIdentifier,UserName, ContactId, CompanyName From User Where Username = 'sushma.rajput@test.com' LIMIT 1];  
   
   // List<Contact> con = [select id, AccountId, Email, IAM_Cummins_login_ID__c,IAM_Legacy_User__c,IAM_Contact_Status__c, IAM_Challange_Question__c, IAM_Challange_Answer__c from contact where IAM_Cummins_login_ID__c =: loggedUser.FederationIdentifier];
    
    App_Mapping__c app = [select AppId__c, Name, IAM_Approval_Needed__c,IAM_Registration_Type__c, IAM_Default_Role__c,IAM_Approver_Email_Contact_Field__c,IAM_Approver_Email_Account_Feature_Field__c,IAM_approver_queue_name__c,Internal_Employee_link__c ,IAM_Paid_Subscription__c,IAM_OSM_Enabled__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where name = 'BOX External Partners' LIMIT 1];
        
   
        Test.startTest();
        Id usrId = ApexPages.currentPage().getParameters().put('userId', loggedUser.id);
      List<Contact> con = [select id, AccountId, Email,IAM_Internal__c,IAM_Cummins_login_ID__c,Username__c,IAM_Legacy_User__c,IAM_Contact_Status__c, IAM_Challange_Question__c, IAM_Challange_Answer__c from contact where Username__c =: usrId];
      
        ApexPages.currentPage().getParameters().put('appid', app.id);
        String startUrl = 'https://csouat-cumminscss.cs3.force.com/cw/idp/login?app=0spQ0000000CaZk&resource_url=https://rsweb-stg-ac.cummins.com/RSW/home.action';
        ApexPages.currentPage().getParameters().put('starturl',startUrl );
         //ApexPages.currentPage().getParameters().put('referer','');
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(loggedUser);
        IAM_CustomLoginController_RLS iam = new IAM_CustomLoginController_RLS();
        iam.redirectBackpage();
        iam.redirectRegistartionpage();
        iam.redirectinternalpage();
        iam.redirectforgotpassword();
        iam.cookieredirect();
        iam.approvedclosePopup();     
        //iam.doLogin();
        //iam.Changelanguage();
        iam.checkIsInternal();
        
       
       // IAM_Relay_Values.GetValueFromParam(startUrl);
        iam.c = con;
        //iam.userconAnswer = con[0].IAM_Challange_Answer__c;
        iam.username = loggedUser.Username;
        iam.reclaim = TRUE;
        iam.password = 'TEST';
        iam.userNotexist = true;
        iam.errordiv = true;
        iam.cookievalue = 'test';
        iam.selectedLanguage = 'testLang';
        iam.en = 'test';
        iam.Skuid = 'test';
        iam.r = 'test';
        //iam.FederationIdentifier = 'Test123';
        
}  
   Static testMethod void testCumminsRedirect2(){    

 //createTestData();
 
   User loggedUser = [Select Id, isActive, Email, FederationIdentifier,UserName, ContactId, CompanyName,LanguageLocaleKey From User Where Username = 'sushma.rajput@test.com' LIMIT 1];  
   
    List<Contact> con = [select id, AccountId, Email, IAM_Cummins_login_ID__c,Username__c,IAM_Legacy_User__c,IAM_Contact_Status__c, IAM_Challange_Question__c, IAM_Challange_Answer__c from contact where Username__c =: loggedUser.FederationIdentifier];
    
    App_Mapping__c app = [select AppId__c, Name, IAM_Approval_Needed__c,IAM_Registration_Type__c, IAM_Default_Role__c,IAM_Approver_Email_Contact_Field__c,IAM_Approver_Email_Account_Feature_Field__c,IAM_approver_queue_name__c,Internal_Employee_link__c ,IAM_Paid_Subscription__c,IAM_OSM_Enabled__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where name = 'BOX External Partners' LIMIT 1];
        
   
        Test.startTest();
        ApexPages.currentPage().getParameters().put('userId', loggedUser.id);
        ApexPages.currentPage().getParameters().put('appid', app.id);
         Apexpages.currentpage().getParameters().put('selectedLanguage',loggedUser.LanguageLocaleKey);
         //ApexPages.currentPage().getParameters().put('referer','');
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(loggedUser);
        IAM_CustomLoginController_RLS iam = new IAM_CustomLoginController_RLS();
        iam.redirectBackpage();
        iam.redirectRegistartionpage();
        iam.redirectinternalpage();
        iam.redirectforgotpassword();
        iam.cookieredirect();
        iam.approvedclosePopup();     
        //iam.doLogin();        
        //iam.Changelanguage();
        iam.checkIsInternal();
        
        String startUrl = 'http://my.company.salesforce.com';
        IAM_Relay_Values.GetValueFromParam(startUrl);
        iam.c = con;
       // iam.userconAnswer = con[0].IAM_Challange_Answer__c;
        iam.username = loggedUser.Username;
        iam.reclaim = False;
        iam.password = 'TEST';
        iam.userNotexist = False;
        iam.errordiv = false;
        iam.cookievalue = 'test';
        iam.selectedLanguage = 'testLang';
        iam.en = 'test';
        iam.Skuid = 'test';
        iam.r = 'test';
        iam.FederationIdentifier = 'Test123';
        
        
}  
    
    Static testMethod void testCumminsRedirect3(){    

 //createTestData();
 
   User loggedUser = [Select Id, isActive, Email, FederationIdentifier,UserName, ContactId, CompanyName From User Where Username = 'test00012@eiam.com' LIMIT 1];  
      
    List<Contact> con = [select id, AccountId, Email, IAM_Cummins_login_ID__c,Username__c,IAM_Legacy_User__c,IAM_Contact_Status__c, IAM_Challange_Question__c, IAM_Challange_Answer__c from contact where Username__c =: loggedUser.FederationIdentifier LIMIT 1];
    
    App_Mapping__c app = [select AppId__c, Name, IAM_Approval_Needed__c,IAM_Registration_Type__c, IAM_Default_Role__c,IAM_Approver_Email_Contact_Field__c,IAM_Approver_Email_Account_Feature_Field__c,IAM_approver_queue_name__c,Internal_Employee_link__c ,IAM_Paid_Subscription__c,IAM_OSM_Enabled__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where name = 'BOX External Partners' LIMIT 1];
        
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('userId', loggedUser.id);
        ApexPages.currentPage().getParameters().put('appid', app.id);
        String startUrl = '';
        ApexPages.currentPage().getParameters().put('starturl',startUrl );
        String referUrl = 'https://www.facebook.com/';
         ApexPages.currentPage().getHeaders().put('referer',referUrl);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(loggedUser);
        IAM_CustomLoginController_RLS iam = new IAM_CustomLoginController_RLS();
         iam.FederationIdentifier = 'test123';
        iam.redirectBackpage();
        iam.redirectRegistartionpage();
        iam.redirectinternalpage();
        iam.redirectforgotpassword();
        iam.cookieredirect();
        iam.approvedclosePopup();     
        iam.doLogin();
        iam.Changelanguage();
        iam.checkIsInternal();
        iam.CorrectAnswer = true;
        //iam.redirectToRegistration();
       
      
        iam.c = con;
        //iam.userconAnswer = con[0].IAM_Challange_Answer__c;
        iam.username = loggedUser.Username;
        iam.reclaim = TRUE;
        iam.password = 'TEST';
        iam.userNotexist = true;
        iam.errordiv = true;
        iam.cookievalue = 'test';
        iam.en = 'test';
        iam.Skuid = 'test';
        iam.r = 'test';
       
    }  
Static testMethod void testCumminsRedirect4(){    

 //createTestData();
 
   User loggedUser = [Select Id, isActive, Email, FederationIdentifier,UserName, ContactId, CompanyName From User Where Username = 'test00012@eiam.com' LIMIT 1];  
      
    List<Contact> con = [select id, AccountId, Email, IAM_Cummins_login_ID__c,Username__c,IAM_Legacy_User__c,IAM_Contact_Status__c, IAM_Challange_Question__c, IAM_Challange_Answer__c from contact where Username__c =: loggedUser.FederationIdentifier LIMIT 1];
    
    App_Mapping__c app = [select AppId__c, Name, IAM_Approval_Needed__c,IAM_Registration_Type__c, IAM_Default_Role__c,IAM_Approver_Email_Contact_Field__c,IAM_Approver_Email_Account_Feature_Field__c,IAM_approver_queue_name__c,Internal_Employee_link__c ,IAM_Paid_Subscription__c,IAM_OSM_Enabled__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where name = 'BOX External Partners' LIMIT 1];
        
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('userId', loggedUser.id);
        ApexPages.currentPage().getParameters().put('appid', app.id);
        String startUrl = '';
        ApexPages.currentPage().getParameters().put('starturl',startUrl );
        String referUrl = 'https://www.facebook.com/';
         ApexPages.currentPage().getHeaders().put('referer',referUrl);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(loggedUser);
        IAM_CustomLoginController_RLS iam = new IAM_CustomLoginController_RLS();
         iam.FederationIdentifier = 'test00012@eiam.com';
         iam.reclaim = TRUE;
        iam.redirectBackpage();
        iam.redirectRegistartionpage();
        iam.redirectinternalpage();
        iam.redirectforgotpassword();
        iam.cookieredirect();
        iam.approvedclosePopup();     
        iam.doLogin();
        iam.Changelanguage();
        iam.checkIsInternal();
        iam.CorrectAnswer = true;
        //iam.redirectToRegistration();
       
      
        iam.c = con;
        //iam.userconAnswer = con[0].IAM_Challange_Answer__c;
        iam.username = loggedUser.Username;
        
        iam.password = 'TEST';
        iam.userNotexist = true;
        iam.errordiv = true;
        iam.cookievalue = 'test';
        iam.en = 'test';
        iam.Skuid = 'test';
        iam.r = 'test';
       
    }    
    
    Static testMethod void testCumminsRedirect5(){    

 //createTestData();
 
   User loggedUser = [Select Id, isActive, Email, FederationIdentifier,UserName, ContactId, CompanyName From User Where Username = 'test00012@eiam.com' LIMIT 1];  
      
    List<Contact> con = [select id, AccountId, Email, IAM_Cummins_login_ID__c,Username__c,IAM_Legacy_User__c,IAM_Contact_Status__c, IAM_Challange_Question__c, IAM_Challange_Answer__c from contact where Username__c =: loggedUser.FederationIdentifier LIMIT 1];
    
    App_Mapping__c app = [select AppId__c, Name, IAM_Approval_Needed__c,IAM_Registration_Type__c, IAM_Default_Role__c,IAM_Approver_Email_Contact_Field__c,IAM_Approver_Email_Account_Feature_Field__c,IAM_approver_queue_name__c,Internal_Employee_link__c ,IAM_Paid_Subscription__c,IAM_OSM_Enabled__c, Registration_Link__c, Back_page__c, contact_email__c, Footer_text__c from App_Mapping__c where name = 'BOX External Partners' LIMIT 1];
        
        
        Test.startTest();
        
        ApexPages.currentPage().getParameters().put('appid', app.id);
        String startUrl = '';
        ApexPages.currentPage().getParameters().put('starturl',startUrl );
         ApexPages.currentPage().getParameters().put('oamerrorcode','OAM-2' );
        String referUrl = 'https://www.facebook.com/';
         ApexPages.currentPage().getHeaders().put('referer',referUrl);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(loggedUser);
        IAM_CustomLoginController_RLS iam = new IAM_CustomLoginController_RLS();
        
       
    }    
   
}