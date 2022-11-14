@isTest(SeeAllData=True)
private class IAM_CumminsRedirectPage_new_RLS_test{


//@testSetup
    public static void createTestData(){
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
        Con.IAM_Internal__c = True;
        con.IAM_Site_Admin__c = False;
        con.CMI_Contact_Type__c = 'secondary';
        con.IAM_Contact_Status__c='Pending';
        insert Con;
        
        contact Con1=new contact();
        con1.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con1.FirstName = 'test12';
        Con1.LastName = 'test852';
        Con1.AccountId = a.Id;
        //con1.IAM_Cummins_Login_ID__c= 'Sandeep1@test.com';   
        Con1.Email = 'test0001@eiam.com';        
        Con1.IAM_Internal__c = True;
        con1.IAM_Site_Admin__c = True;
        con1.CMI_Contact_Type__c = 'Primary';
        con1.IAM_Cummins_Login_ID__c='2468740'; 
        con1.IAM_Contact_Status__c='Pending';
        insert Con1;
        
        contact Con2=new contact();
        con2.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con2.FirstName = 'test123';
        Con2.LastName = 'test85256';
        Con2.AccountId = a.Id;
        //con1.IAM_Cummins_Login_ID__c= 'Sandeep5@test.com';   
        Con2.Email = 'Sandeep5@test.com';        
        Con2.IAM_Internal__c = True;
        con2.IAM_Site_Admin__c = True;
        con2.CMI_Contact_Type__c = 'Primary';
        con2.IAM_Cummins_Login_ID__c='2468543'; 
        con2.IAM_Contact_Status__c='Pending';
        insert Con2;
        
        List<App_Mapping__c> lstAppMapping = new List<App_Mapping__c>();
        App_Mapping__c app=new App_Mapping__c();
        app.name='Identity and Access Management';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.CMI_External_Start_Url__c = 'https://qs-dev.cummins.com/';        
        app.IAM_Default_Role__c='User';
        app.IAM_Authroization_Required__c = false;
        app.IAM_OAM_Resource_URL_Redirection__c = true;
        app.IAM_App_Protected_By__c='SAML';
        app.IAM_Request_Access__c = false;
        app.IAM_Different_Request_Access_URL__c = true;
        insert app;
        
        App_Mapping__c app2=new App_Mapping__c();
        app2.name='Identity and Access Management';
        app2.Back_page__c='https://login.salesforce.com/';
        app2.Login_Url__c='https://www.facebook.com/';
        app2.CMI_External_Start_Url__c = 'https://qs-dev.cummins.com/';
        app2.IAM_OAM_Resource_URL__c = 'https://qs-dev.cummins.com/';
        app2.IAM_Default_Role__c='User';
        app2.IAM_App_Protected_By__c='SAML';
        app2.IAM_Authroization_Required__c = true;
        app2.IAM_OAM_Resource_URL_Redirection__c = true;
        app2.IAM_Request_Access__c = true;
        app2.IAM_Different_Request_Access_URL__c = false;
        insert app2;
        
        App_Mapping__c app3=new App_Mapping__c();
        app3.name='Identity and Access Management';
        app3.Back_page__c='';
        app3.Login_Url__c='';
        app3.CMI_External_Start_Url__c = 'https://qs-dev.cummins.com/';        
        app3.IAM_Default_Role__c='User';
        app3.IAM_Authroization_Required__c = true;
        app3.IAM_OAM_Resource_URL_Redirection__c = true;
        app3.IAM_App_Protected_By__c='SAML';
        app3.IAM_Request_Access__c = true;
        app3.IAM_Different_Request_Access_URL__c = true;
        insert app3;
        
        
        App_Mapping__c app4=new App_Mapping__c();
        app4.name='DBU EFSR';
        app4.Back_page__c='https://login.salesforce.com/';
        app4.CMI_External_Start_Url__c = 'https://qs-dev.cummins.com/';
        app4.Login_Url__c='https://www.facebook.com/'; 
        app4.IAM_Default_Role__c='User';
        app4.IAM_App_Protected_By__c='SAML'; 
        app4.IAM_Authroization_Required__c = false; 
        app4.IAM_OAM_Resource_URL_Redirection__c = true;
        app4.IAM_Request_Access__c = false;
        insert app4;
        
        App_Mapping__c app5=new App_Mapping__c();
        app5.name='Online Login';       
        app5.IAM_Default_Role__c='User';
        app5.IAM_App_Protected_By__c='SAML'; 
        app5.IAM_Authroization_Required__c = false; 
        app5.Registration__c = true;
        app5.IAM_OAM_Resource_URL_Redirection__c = true;
        app5.IAM_Request_Access__c = true;
        insert app5;
        
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
        
        //User Creation
        User newUser = new User();
        
        newUser.FirstName = 'UserFirstName';
        newUser.LastName = 'test';
        newUser.Email = 'test000@eiam.com';   
        newUser.CompanyName = 'IT Test Company';        
        //newUser.CommunityNickname = 'test';
        newUser.Username = 'Sandeep@test.com' ;
        newUser.Alias = 'archer1';
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
        
        User newUser2 = new User();
        
        newUser2.FirstName = 'test123';
        newUser2.LastName = 'test567';
        newUser2.Email = 'test000@eiam.com';   
        newUser2.CompanyName = 'IT Test Company';        
        //newUser2.CommunityNickname = 'test098';
        newUser2.Username = 'Sandeep5@test.com' ;
        newUser2.Alias = 'archer2';
        newUser2.TimeZoneSidKey = 'GMT';
        newUser2.LocaleSidKey= 'en_US';
        newUser2.EmailEncodingKey = 'UTF-8';
        newUser2.LanguageLocaleKey = 'en_US';         
        newUser2.ProfileId = pf[0].Id ;                                  
        newUser2.ContactId =Con2.Id;                   
        newUser2.isActive = TRUE;
        newUser2.Street = '123 Test St';
        newUser2.FederationIdentifier = '2460000';
        
        insert newUser2;
        
        List<profile> pf2 = [select Id,Name from Profile WHERE Name = 'IAM_PWC_User_Profile' limit 1];
        User newUser1 = new User();
        newUser1.FirstName = 'test12';
        newUser1.LastName = 'test852';
        newUser1.Email = 'test0001@eiam.com';   
        newUser1.CompanyName = 'IT Test Company';        
        //newUser1.CommunityNickname = 'test2';
        newUser1.Username = 'Sandeep1@testrlslogin.com' ;
        newUser1.Alias = 'archer3';
        newUser1.TimeZoneSidKey = 'GMT';
        newUser1.LocaleSidKey= 'en_US';
        newUser1.EmailEncodingKey = 'UTF-8';
        newUser1.LanguageLocaleKey = 'en_US';         
        newUser1.ProfileId = pf2[0].Id ;                                  
        //newUser1.ContactId =Con1.Id;                   
        newUser1.isActive = TRUE;
        newUser1.Street = '123 Test St';
        newUser1.FederationIdentifier = '2468740';
        
        insert newUser1;
        
        IAM_Application__c iamApp = new IAM_Application__c();
        iamApp.IAM_Application_Name__c = 'Marketplace';
        iamApp.IAM_Role__c = 'user';
        iamApp.IAM_Status__c = 'Active';
        iamApp.IAM_Account_Name__c = a.id;
        iamApp.IAM_Subscription_Name__c = 'test';
        insert iamApp;
        
        
        //IAM Contact Provisioning
        //List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        //conApp.IAM_Application_Name__c = 'Marketplace';
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Identity And Access Management').getRecordTypeId();
        conApp.IAM_Role__c = 'user';        
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = Con.id; 
        conApp.IAM_Account_Application__c = iamApp.id;
        conApp.IAM_Application_Name__c=app.Name;
        insert conApp;
        
        IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
        //conApp.IAM_Application_Name__c = 'Marketplace';
        conApp1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Identity And Access Management').getRecordTypeId();
        conApp1.IAM_Role__c = 'user';        
        conApp1.IAM_Status__c = 'Active';
        conApp1.IAM_Contact__c = Con1.id; 
        conApp1.IAM_Account_Application__c = iamApp.id;
        conApp1.IAM_Application_Name__c=app.Name;
        insert conApp1;
        
       /* CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_LDAP_oAuth';
        csID.ApplicationName__c ='IAM_LDAP_oAuth';
        csID.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        csId.IsActive__c = true;
        csID.Key__c='jb6sFHd/KsMjdprFnsnLjPgCf+19v/kh49PHL/bjYO7DmigbFZdIaXN7gVS0/fg06Fx9fPolnF3guPkOncLwHA==';
        csID.Passcode__c = 'lhBxWDMxDkfiIXb2hsMD/sC0HJUv4CRi4HlvvXUtopNctqUHq07R8MVrFKNqGJELb2meudGeoTKfD7yjHDdUJA==';
        csId.Username__c = 'SHnBSQhHEqF+DQgb+tSI6K6+EqIKGt/1yWj/4tG4KG4=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'OAGoAuth';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
        insert csID;*/
        
    }     
    
   Static testMethod void testCumminsRedirect(){
        createTestData();
        User loggedUser = [Select Id,Name,ContactId From User WHERE Username = 'Sandeep@test.com'];
        System.runAs(loggedUser){
            List<Contact> con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid FROM Contact WHERE Id =: loggedUser.ContactId LIMIT 1]; 
              
            List<IAM_Application__c> lstAppMap = [Select Id,Name From IAM_Application__c WHERE Name = 'Marketplace' LIMIT 1];
            
            App_Mapping__c appMap = [Select Id,Name From App_Mapping__c WHERE Name = 'Identity and Access Management' AND IAM_Authroization_Required__c= false LIMIT 1];
            
           /* List<IAM_Contact_Provisioning__c> contactProv = [select id,IAM_Account_Application__c,IAM_Application_Name__c,IAM_Contact__c,IAM_Role__c,IAM_Status__c,IAM_User__c from IAM_Contact_Provisioning__c
                       where IAM_Contact__r.id =:con[0].id and IAM_Application_Name__c =:appMap.Name and IAM_Status__c='Active'];*/
            
            ApexPages.currentPage().getParameters().put('appid', appMap.id); 
            ApexPages.currentPage().getParameters().put('resource_url','https://repairlogistics-stg.cummins.com'); 
            
            
            IAM_CumminsRedirectPage_new_RLS objClass=new IAM_CumminsRedirectPage_new_RLS();
            objclass.Redirect();
            objclass.resourceurl='https://test.cummins.com';
            objclass.r='https://test.cummins.com';
             objclass.en='https://repairlogistics-stg.cummins.com';
            
            
         
            
        }
    }

 Static testMethod void myUnitest2(){
 
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
        Con.IAM_Internal__c = True;
        con.IAM_Site_Admin__c = False;
        con.CMI_Contact_Type__c = 'secondary';
        con.IAM_Contact_Status__c='Pending';
        insert Con;
 
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
        
        //User Creation
        User newUser = new User();
        
        newUser.FirstName = 'UserFirstName';
        newUser.LastName = 'test';
        newUser.Email = 'test000@eiam.com';   
        newUser.CompanyName = 'IT Test Company';        
        //newUser.CommunityNickname = 'test';
        newUser.Username = 'Sandeep@test.com' ;
        newUser.Alias = 'archer1';
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
        IAM_CumminsRedirectPage_new_RLS objClass=new IAM_CumminsRedirectPage_new_RLS();
        string strlabelOS=System.Label.IAM_OSM_AppMapping_ID;
        ApexPages.currentPage().getParameters().put('appid',strlabelOS);
        ApexPages.currentPage().getParameters().put('resource_url','https://repairlogistics-stg.cummins.com'); 
       objclass.en='https://repairlogistics-stg.cummins.com';
        objclass.Redirect();
       }
        
    }
    
    
    static testMethod void myUnitTest() 
    {
        App_Mapping__c app=new App_Mapping__c();
        app.Back_page__c='ww.cummins.com';
        app.contact_email__c='oh611@cummins.com';
        app.CMI_External_Start_Url__c='ww.cummins.com';
        app.Footer_text__c='testfooter';
        app.Internal_Employee_link__c='ww.cummins.com';
        app.internal_Employee_Redirection__c=True;
        app.IAM_Default_Role__c='User';
        app.Login_Url__c='www.Cummins.com';
    app.IAM_App_Protected_By__c='SAML';
    app.Name='Marketplace';
        insert app;
       
        IAM_CumminsRedirectPage_new_RLS objClass=new IAM_CumminsRedirectPage_new_RLS();
        string strlabel=app.id;
        string strlabelOS=System.Label.IAM_OSM_AppMapping_ID;
        String RLSid=system.Label.RLS_AppID;
        String aboid=system.Label.ABO_appID;
        ApexPages.currentPage().getParameters().put('appid',strlabel);
        ApexPages.currentPage().getParameters().put('appid',strlabelOS);
        ApexPages.currentPage().getParameters().put('appid',RLSid);
        ApexPages.currentPage().getParameters().put('appid',aboid);
           
        ApexPages.currentPage().getParameters().put('resource_url','https://repairlogistics-stg.cummins.com'); 
        
        Account a=new Account();
        a.Name='New Account';
        insert a;
        
        Contact con=new Contact();
        Con.Accountid=a.id;
        con.Firstname='fname';
        con.LastName='Lname';
        con.email='oh611@cummins.com';
        con.IAM_Contact_Status__c='Active';
        con.IAM_Cummins_Login_ID__c='oh611@cumiinsemail@cummins.com';
        insert con;    
        
        User u = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'RLS Web'].Id,
     LastName = 'last',
     Contactid=con.id,
     Email = 'puser000@amamama.com',
     Username = 'pusessssr000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US' 
    );
     System.runAs(u){
     objclass.Redirect();
      objclass.en='https://repairlogistics-stg.cummins.com';
     }   
     
     
     
      Contact con1=new Contact();
        Con1.Accountid=a.id;
        con1.Firstname='fname';
        con1.LastName='Lname';
        con1.email='oh611@cummins.com';
        con1.IAM_Contact_Status__c='Active';
        con1.IAM_Cummins_Login_ID__c='oh61132@cumiinsemail@cummins.com';
        insert con1;    
        
        User u1 = new User(
     ProfileId = [SELECT Id FROM Profile WHERE Name = 'EIDM_Community'].Id,
     LastName = 'last',
     Contactid=con1.id,
     Email = 'puser000@amamama.com',
     Username = 'pusessssr000@amamama.com' + System.currentTimeMillis(),
     CompanyName = 'TEST',
     Title = 'title',
     Alias = 'alias',
     TimeZoneSidKey = 'America/Los_Angeles',
     EmailEncodingKey = 'UTF-8',
     LanguageLocaleKey = 'en_US',
     LocaleSidKey = 'en_US' 
    );
     System.runAs(u1){
     objclass.Redirect();
     objclass.u=u1;
     objclass.en='https://repairlogistics-stg.cummins.com';
     }   
     
        
    }
    
    
    
    static testMethod void myUnitTest4() 
    {
       
       ApexPages.currentPage().getParameters().put('resource_url','https://repairlogistics-stg.cummins.com'); 
        IAM_CumminsRedirectPage_new_RLS objClass=new IAM_CumminsRedirectPage_new_RLS();
     objclass.Redirect();
      objclass.en='https://repairlogistics-stg.cummins.com';
        
     
        
    }
    
    
   }