/*
* Test class for IAM_Cummins_Redirect_Page
* Updated test class for changes
*/
@isTest
public class IAM_CumminsRedirectPage_new_test{
    
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
        insert Con1;
        
        contact Con2=new contact();
        con2.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con2.FirstName = 'test123';
        Con2.LastName = 'test85256';
        Con2.AccountId = a.Id;
        //con1.IAM_Cummins_Login_ID__c = 'Sandeep5@test.com';   
        Con2.Email = 'Sandeep5@test.com';        
        Con2.IAM_Internal__c = True;
        con2.IAM_Site_Admin__c = True;
        con2.CMI_Contact_Type__c = 'Primary';
        con2.IAM_Cummins_Login_ID__c='2468543'; 
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
        
        
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
        //User Creation
        User newUser = new User();
        
        newUser.FirstName = 'UserFirstName';
        //newUser.UserRoleId = '00E61000000QDl4EAG';
        newUser.LastName = 'test';
        newUser.Email = 'test000@eiam.com';   
        newUser.CompanyName = 'IT Test Company';        
        newUser.CommunityNickname = 'test1';
        newUser.Username = 'Sandeep@test.com' ;
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
        
        User newUser2 = new User();
        
        newUser2.FirstName = 'test123';
        newUser2.LastName = 'test567';
        newUser2.Email = 'test000@eiam.com';   
        newUser2.CompanyName = 'IT Test Company';        
        newUser2.CommunityNickname = 'test098';
        newUser2.Username = 'Sandeep5@test.com' ;
        newUser2.Alias = 'test';
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
        
        List<profile> pf2 = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
        User newUser1 = new User();
        newUser1.FirstName = 'test12';
        newUser1.LastName = 'test852';
        newUser1.Email = 'test0001@eiam.com';   
        newUser1.CompanyName = 'IT Test Company';        
        newUser1.CommunityNickname = 'test2';
        newUser1.Username = 'Sandeep1@test.com' ;
        newUser1.Alias = 'test';
        newUser1.TimeZoneSidKey = 'GMT';
        newUser1.LocaleSidKey= 'en_US';
        newUser1.EmailEncodingKey = 'UTF-8';
        newUser1.LanguageLocaleKey = 'en_US';         
        newUser1.ProfileId = pf2[0].Id ;                                  
        newUser1.ContactId =Con1.Id;                   
        newUser1.isActive = TRUE;
        newUser1.Street = '123 Test St';
        newUser1.FederationIdentifier = '2468740';
        
       // insert newUser1;
        
        IAM_Application__c iamApp = new IAM_Application__c();
        iamApp.IAM_Application_Name__c = 'Marketplace';
        iamApp.IAM_Role__c = 'CSS_DN_ADMIN';
        iamApp.IAM_Status__c = 'Active';
        iamApp.IAM_Account_Name__c = a.id;
        iamApp.IAM_Subscription_Name__c = 'test';
        insert iamApp;
        
        
        //IAM Contact Provisioning
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Identity And Access Management').getRecordTypeId();
        conApp.IAM_Role__c = 'User';        
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = Con.id; 
        conApp.IAM_Account_Application__c = iamApp.id;
        conApp.IAM_Application_Name__c=app.Name;
        insert conApp;
        
        IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
        conApp1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Identity And Access Management').getRecordTypeId();
        conApp1.IAM_Role__c = 'user';        
        conApp1.IAM_Status__c = 'Active';
        conApp1.IAM_Contact__c = Con1.id; 
        conApp1.IAM_Account_Application__c = iamApp.id;
        conApp1.IAM_Application_Name__c=app.Name;
        insert conApp1;
        
        CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
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
        insert csID;
        
        IAM_Application_Groups__c iamAppGrp = new IAM_Application_Groups__c ();
        iamAppGrp.IAM_Application_Name__c = 'PowerSpec';
        iamAppGrp.IAM_Role_Name__c = 'PowerSpec_Basic';
        iamAppGrp.IAM_DN_value__c = 'cn=PowerSpec_Basic,ou=APP_PowerSpec,ou=application,dc=cummins,dc=com';
        iamAppGrp.Name = 'Power Spec 1.6';
        iamAppGrp.IAM_Group_Type__c = 'static';
        insert iamAppGrp;
        
        
        
        Contact c3 = new Contact();
        c3.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c3.FirstName = 'myfirsbh';
        c3.LastName ='mylasth';
        c3.Email = 'myemail3@abc.com';
        c3.Username__c = 'myuserid3@abc.com';
        c3.AccountId = a.id;
        c3.IAM_Contact_Status__c = 'Active';
        c3.CMI_Contact_Type__c = 'secondary'; 
        c3.IAM_Applications__c = iamAppGrp.IAM_DN_value__c;
        c3.IAM_Application_Roles__c = iamAppGrp.IAM_Role_Name__c;
        insert c3;
        
        User newUser10 = new User();
        
        newUser10.FirstName = 'test1234';
        newUser10.LastName = 'test5678';
        newUser10.Email = 'test0001@eiam.com';   
        newUser10.CompanyName = 'IT Test Company';        
        newUser10.CommunityNickname = 'kondap98';
        newUser10.Username = 'Sandeep57@test.com' ;
        newUser10.Alias = 'kondapP';
        newUser10.TimeZoneSidKey = 'GMT';
        newUser10.LocaleSidKey= 'en_US';
        newUser10.EmailEncodingKey = 'UTF-8';
        newUser10.LanguageLocaleKey = 'en_US';         
        newUser10.ProfileId = pf[0].Id ;                                  
        newUser10.ContactId =c3.Id;                   
        newUser10.isActive = TRUE;
        newUser10.Street = '123 Test St';
        newUser10.FederationIdentifier = '246999';
        insert newUser10;
        
        IAM_Application__c app10 = new IAM_Application__c();
        app10.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('PowerSpec').getRecordTypeId(); 
        app10.IAM_Application_Name__c = 'PowerSpec';
        app10.IAM_Role__c = 'PowerSpec_Basic';        
        app10.IAM_Subscription_Count__c = 99;
        app10.IAM_Account_Name__c = a.Id;
        app10.IAM_Status__c = 'Active';
        insert app10;
        
        IAM_Contact_Provisioning__c conP3 = new IAM_Contact_Provisioning__c();
        conP3.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('PowerSpec').getRecordTypeId(); 
        conP3.IAM_Application_Name__c = 'PowerSpec';
        conP3.IAM_Account_Application__c = app10.Id;
        conP3.IAM_Role__c = 'PowerSpec_Basic';        
        conP3.IAM_Contact__c = c3.Id;
        conP3.IAM_User__c= newUser10.Id;
        conP3.IAM_Status__c = 'Active';
        insert conP3;
        
        
    }     
    
    Static testMethod void testCumminsRedirect(){
        createTestData();
        User loggedUser = [Select Id,Name,ContactId From User WHERE Username = 'Sandeep@test.com'];
        System.runAs(loggedUser){
            List<Contact> con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid FROM Contact WHERE Id =: loggedUser.ContactId LIMIT 1]; 
            List<IAM_Application__c> lstAppMap = [Select Id,Name From IAM_Application__c WHERE Name = 'Marketplace' LIMIT 1];
            App_Mapping__c appMap = [Select Id,Name From App_Mapping__c WHERE Name = 'Identity and Access Management' AND IAM_Authroization_Required__c= false LIMIT 1];            
            ApexPages.currentPage().getParameters().put('appid', appMap.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        }
    }
    
    Static testMethod void testCumminsRedirect2(){
        
        createTestData();
        User loggedUser = [Select Id,Name,ContactId From User WHERE Username = 'Sandeep@test.com'];
        System.runAs(loggedUser){
            List<Contact> con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid FROM Contact WHERE Id =: loggedUser.ContactId LIMIT 1]; 
            List<IAM_Application__c> lstAppMap = [Select Id,Name From IAM_Application__c WHERE Name = 'Marketplace' LIMIT 1];
            
            App_Mapping__c appMap = [Select Id,Name From App_Mapping__c WHERE Name = 'Identity and Access Management' AND IAM_Request_Access__c = False LIMIT 1];
            
            List<IAM_Contact_Provisioning__c> contactProv = [select id,IAM_Account_Application__c,IAM_Application_Name__c,IAM_Contact__c,IAM_Role__c,IAM_Status__c,IAM_User__c from IAM_Contact_Provisioning__c
                                                             where IAM_Contact__r.id =:con[0].id and IAM_Application_Name__c =:appMap.Name and IAM_Status__c='Active'];
            
            
            ApexPages.currentPage().getParameters().put('resource_url','https://qs-dev.cummins.com'); 
            
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        }
        
    }
    Static testMethod void testCumminsRedirect3(){
        
        createTestData();
        
        User loggedUser = [Select Id,Name,FederationIdentifier,ContactId, Contact.IAM_Site_Admin__c From User WHERE Username = 'Sandeep5@test.com'];
        system.debug('logged use'+ loggedUSer.Contact.IAM_Site_Admin__c);
        System.runAs(loggedUser){
            List<Contact> con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid FROM Contact WHERE Id =: loggedUser.ContactId AND IAM_Site_Admin__c = True LIMIT 1]; 
            App_Mapping__c appMap = [Select Id,Name From App_Mapping__c WHERE Name = 'Identity and Access Management' LIMIT 1];
            appMap.name='DBU EFSR';
            update appMap;
            ApexPages.currentPage().getParameters().put('appid', appMap.id);
            
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        } 
        
    }
    Static testMethod void testCumminsRedirect4(){
        
        createTestData();
        
        User loggedUser = [Select Id,Name,FederationIdentifier From User WHERE Username = 'Sandeep5@test.com'];
        
        System.runAs(loggedUser){
            List<Contact> con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid FROM Contact WHERE CMI_Contact_Type__c ='Secondary' AND IAM_Site_Admin__c = True LIMIT 1]; 
            App_Mapping__c appMap = [Select Id,Name From App_Mapping__c WHERE Name = 'Identity and Access Management' LIMIT 1];
            ApexPages.currentPage().getParameters().put('appid', appMap.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        } 
    }
    
    Static testMethod void testCumminsRedirect5(){
        
        createTestData();
        
        User loggedUser = [Select Id,Name,FederationIdentifier From User WHERE Username = 'Sandeep5@test.com'];
        
        System.runAs(loggedUser){
            List<Contact> con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid FROM Contact WHERE CMI_Contact_Type__c ='Secondary' AND IAM_Site_Admin__c = True LIMIT 1]; 
            App_Mapping__c appMap = [Select Id,Name,IAM_Request_Access__c From App_Mapping__c  LIMIT 1];
            appMap.IAM_Request_Access__c = False;
            update appMap;
            ApexPages.currentPage().getParameters().put('appid', appMap.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        } 
    }
    Static testMethod void testCumminsRedirect6(){
        
        createTestData();
        
        User loggedUser = [Select Id,Name,FederationIdentifier From User WHERE Username = 'Sandeep5@test.com'];
        
        System.runAs(loggedUser){
            List<Contact> con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid FROM Contact WHERE CMI_Contact_Type__c ='Secondary' AND IAM_Site_Admin__c = True LIMIT 1]; 
            App_Mapping__c appMap = [Select Id,Name,IAM_Request_Access__c From App_Mapping__c WHERE Name = 'Online Login' LIMIT 1];
            appMap.IAM_Request_Access__c = False;
            update appMap;
            ApexPages.currentPage().getParameters().put('appid', appMap.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        } 
    }
    Static testMethod void testCumminsRedirect7(){
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
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
        insert Con;
        
        App_Mapping__c app5=new App_Mapping__c();
        app5.name='Online Login';       
        app5.IAM_Default_Role__c='User';
        app5.IAM_App_Protected_By__c='SAML'; 
        app5.IAM_Authroization_Required__c = false; 
        app5.Registration__c = true;
        app5.IAM_OAM_Resource_URL_Redirection__c = true;
        app5.IAM_Request_Access__c = true;
        app5.IAM_Different_Request_Access_URL__c=true;
        insert app5;
        
        User newUser2 = new User();      
        newUser2.FirstName = 'test123';
        newUser2.LastName = 'test567';
        newUser2.Email = 'test000@eiam.com';   
        newUser2.CompanyName = 'IT Test Company';        
        newUser2.CommunityNickname = 'test098';
        newUser2.Username = 'Sandeep5@test.com' ;
        newUser2.Alias = 'test';
        newUser2.TimeZoneSidKey = 'GMT';
        newUser2.LocaleSidKey= 'en_US';
        newUser2.EmailEncodingKey = 'UTF-8';
        newUser2.LanguageLocaleKey = 'en_US';         
        newUser2.ProfileId = pf[0].Id ;                                  
        newUser2.ContactId =Con.Id;                   
        newUser2.isActive = TRUE;
        newUser2.Street = '123 Test St';
        newUser2.FederationIdentifier = '2460000'; 
        insert newUser2;
        
        System.runAs(newUser2){
            ApexPages.currentPage().getParameters().put('appid', app5.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        } 
    }
    Static testMethod void testCumminsRedirect8(){
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
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
        insert Con;
        
        App_Mapping__c app5=new App_Mapping__c();
        app5.name='Online Login';       
        app5.IAM_Default_Role__c='User';
        app5.IAM_App_Protected_By__c='SAML'; 
        app5.IAM_Authroization_Required__c = false; 
        app5.Registration__c = true;
        app5.IAM_OAM_Resource_URL_Redirection__c = true;
        app5.IAM_Request_Access__c = true;
        app5.IAM_Different_Request_Access_URL__c=false;
        insert app5;
        
        User newUser2 = new User();      
        newUser2.FirstName = 'test123';
        newUser2.LastName = 'test567';
        newUser2.Email = 'test000@eiam.com';   
        newUser2.CompanyName = 'IT Test Company';        
        newUser2.CommunityNickname = 'test098';
        newUser2.Username = 'Sandeep5@test.com' ;
        newUser2.Alias = 'test';
        newUser2.TimeZoneSidKey = 'GMT';
        newUser2.LocaleSidKey= 'en_US';
        newUser2.EmailEncodingKey = 'UTF-8';
        newUser2.LanguageLocaleKey = 'en_US';         
        newUser2.ProfileId = pf[0].Id ;                                  
        newUser2.ContactId =Con.Id;                   
        newUser2.isActive = TRUE;
        newUser2.Street = '123 Test St';
        newUser2.FederationIdentifier = '2460000'; 
        insert newUser2;
        
        System.runAs(newUser2){
            ApexPages.currentPage().getParameters().put('appid', app5.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        } 
    }
    Static testMethod void testCumminsRedirect9(){
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
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
        insert Con;
        
        App_Mapping__c app5=new App_Mapping__c();
        app5.name='Online Login';       
        app5.IAM_Default_Role__c='User';
        app5.IAM_App_Protected_By__c='SAML'; 
        app5.IAM_Authroization_Required__c = false; 
        app5.Registration__c = true;
        app5.IAM_OAM_Resource_URL_Redirection__c = true;
        app5.IAM_Request_Access__c = false;
        insert app5;
        
        User newUser2 = new User();      
        newUser2.FirstName = 'test123';
        newUser2.LastName = 'test567';
        newUser2.Email = 'test000@eiam.com';   
        newUser2.CompanyName = 'IT Test Company';        
        newUser2.CommunityNickname = 'test098';
        newUser2.Username = 'Sandeep5@test.com' ;
        newUser2.Alias = 'test';
        newUser2.TimeZoneSidKey = 'GMT';
        newUser2.LocaleSidKey= 'en_US';
        newUser2.EmailEncodingKey = 'UTF-8';
        newUser2.LanguageLocaleKey = 'en_US';         
        newUser2.ProfileId = pf[0].Id ;                                  
        newUser2.ContactId =Con.Id;                   
        newUser2.isActive = TRUE;
        newUser2.Street = '123 Test St';
        newUser2.FederationIdentifier = '2460000'; 
        insert newUser2;
        
        System.runAs(newUser2){
            ApexPages.currentPage().getParameters().put('appid', app5.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        } 
    }
    Static testMethod void testCumminsRedirect10(){
    createTestData();
        List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
        
        IAM_Application_Groups__c iamAppGroup = [Select id,Name,IAM_Application_Name__c,IAM_Role_Name__c,IAM_DN_value__c FROM IAM_Application_Groups__c WHERE IAM_Application_Name__c = 'PowerSpec' LIMIT 1];
        
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
       // con.IAM_Cummins_Login_ID__c='test000@eiam.com';   
        Con.Email = 'test000@eiam.com';     
        Con.IAM_Internal__c = True;
        con.IAM_Site_Admin__c = False;
        con.CMI_Contact_Type__c = 'secondary';
        con.Username__c='test000@eiam.com';
        insert Con;
        
       
        
        IAM_Application__c iamApp = new IAM_Application__c();
        iamApp.IAM_Application_Name__c = 'Marketplace';
        iamApp.IAM_Role__c = 'CSS_DN_ADMIN';
        iamApp.IAM_Status__c = 'Active';
        iamApp.IAM_Account_Name__c = a.id;
        iamApp.IAM_Subscription_Name__c = 'test';
        insert iamApp;
            
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
        
        
        //IAM Contact Provisioning
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Identity And Access Management').getRecordTypeId();
        conApp.IAM_Role__c = 'User';        
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = Con.id; 
        conApp.IAM_Account_Application__c = iamApp.id;
        conApp.IAM_Application_Name__c=app.Name;
        insert conApp;
        
        User newUser2 = new User();      
        newUser2.FirstName = 'test123';
        newUser2.LastName = 'test567';
        newUser2.Email = 'test000@eiam.com';   
        newUser2.CompanyName = 'IT Test Company';        
        newUser2.CommunityNickname = 'test098';
        newUser2.Username = 'Sandeep5@test.com' ;
        newUser2.Alias = 'test';
        newUser2.TimeZoneSidKey = 'GMT';
        newUser2.LocaleSidKey= 'en_US';
        newUser2.EmailEncodingKey = 'UTF-8';
        newUser2.LanguageLocaleKey = 'en_US';         
        newUser2.ProfileId = pf[0].Id ;                                  
        newUser2.ContactId =Con.Id;                   
        newUser2.isActive = TRUE;
        newUser2.Street = '123 Test St';
        newUser2.FederationIdentifier = '2460000'; 
        //insert newUser2;
        
        IAM_Application_Groups__c iamAppGrp = new IAM_Application_Groups__c ();
        iamAppGrp.IAM_Application_Name__c = 'PowerSpec';
        iamAppGrp.IAM_Role_Name__c = 'PowerSpec_Basic';
        iamAppGrp.IAM_DN_value__c = 'cn=PowerSpec_Basic,ou=APP_PowerSpec,ou=application,dc=cummins,dc=com';
        iamAppGrp.Name = 'Power Spec 1.6';
        iamAppGrp.IAM_Group_Type__c = 'static';
        insert iamAppGrp;
        
        //set<Id> conIds = new set<Id>();
        List<Contact> newconList2 = new List<Contact>();
        Contact conUpsate = new Contact();
        conUpsate.AccountId = a.Id;
        conUpsate.FirstName = 'tevsv';
        conUpsate.LastName = 'secbhd';
        conUpsate.Username__c = 'tevsvsecbhd@gmail.com';
        conUpsate.IAM_Contact_Status__c = 'Active';
        conUpsate.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        conUpsate.IAM_Applications__c = iamAppGrp.IAM_DN_value__c;
        conUpsate.IAM_Application_Roles__c = iamAppGrp.IAM_Role_Name__c;
        
        newconList2.add(conUpsate);
        insert newconList2;  
        //conIds.add(newconList[0].Id);
        
        //newUser2=[select id,name from user where Contact.id=:Con.ID];
       // System.runAs(newUser2){
            ApexPages.currentPage().getParameters().put('appid', app.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            objclass.Redirect();
        //} 
    }
    
    
    
    
   Static testMethod void testCumminsRedirect11(){
        
        App_Mapping__c app=new App_Mapping__c();
        app.name='CUMPAS 2.0';
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
        
        Account acnt= new Account();
        acnt.Name='Test PWC flow';
        acnt.type='Internal';
        insert acnt;
        
        Contact con=new Contact();
        Con.FirstName='Fname';
        Con.LastName='LName';
        Con.Email='oh611@cummins.com';
        Con.Username__c='pwcflowuser@gmail.com';
        con.IAM_Internal__c=True;
        Con.IAM_Legacy_User__c=True;
        insert Con;
        
        
        IAM_Application__c qsol=new IAM_Application__c();
        qsol.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        qsol.IAM_Application_Name__c='QuickServe Online';
        qsol.IAM_Role__c='QSOL Dealer';
        qsol.IAM_Qsolexpiration__c='testExp';
        qsol.IAM_Account_NAme__c=acnt.id;
        qsol.IAM_Status__c ='Active';
        qsol.IAM_Subscription_Name__c='QuickServe Online EBU';
        insert qsol;
        
        
        
        IAM_Contact_Provisioning__c conP1=new IAM_Contact_Provisioning__c();
        conP1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        conP1.IAM_Application_Name__c='QuickServe Online';
        conP1.IAM_Role__c='QSOL Dealer';
        conP1.IAM_Qsolexpiration__c='testExp';
        conP1.IAM_Account_Application__c=qsol.Id;
        conP1.IAM_Contact__c=Con.Id;
        conP1.IAM_Status__c ='Active';
        conP1.IAM_Subscription_Name__c='QuickServe Online EBU';
        insert conP1;
        
        
        List<Profile> PWC= [select id from profile where Name='IAM_PWC_User_Profile'];
        
        User newUser2 = new User();      
        newUser2.FirstName = 'test123';
        newUser2.LastName = 'test567';
        newUser2.Email = 'test000@eiam.com';   
        newUser2.CompanyName = 'IT Test Company';        
        newUser2.CommunityNickname = 'test098';
        newUser2.Username = 'pwcflowuser@gmail.com' ;
        newUser2.Alias = 'test';
        newUser2.TimeZoneSidKey = 'GMT';
        newUser2.LocaleSidKey= 'en_US';
        newUser2.EmailEncodingKey = 'UTF-8';
        newUser2.LanguageLocaleKey = 'en_US';         
        newUser2.ProfileId = pwc[0].id ;                                  
        //newUser2.ContactId =Con.Id;                   
        newUser2.isActive = TRUE;
        newUser2.Street = '123 Test St';
        newUser2.FederationIdentifier = 'pwcflowuser@gmail.com';
        newUser2.IAM_UID__c = 'pwcflowuser@gmail.com'; 
        insert newUSer2;
        
        
        System.runAs(newUser2){
            ApexPages.currentPage().getParameters().put('appid', app.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            IAM_CumminsRedirectPage_new.getSegmentSku('testing');
            objclass.Redirect();
        } 
    }
    
    
    
    Static testMethod void testCumminsRedirect12(){
    List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM User' limit 1];
        
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
       // con.IAM_Cummins_Login_ID__c='test000@eiam.com';   
        Con.Email = 'test000@eiam.com';     
        Con.IAM_Internal__c = True;
        con.IAM_Site_Admin__c = False;
        con.CMI_Contact_Type__c = 'secondary';
        con.Username__c='test000uniq@eiam.com';
        insert Con;
        
       
        
       
            
        App_Mapping__c app=new App_Mapping__c();
        app.name='Marketplace';
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
        
        
        //IAM Contact Provisioning
       
        
        User newUser2 = new User();      
        newUser2.FirstName = 'test123';
        newUser2.LastName = 'test567';
        newUser2.Email = 'test000@eiam.com';   
        newUser2.CompanyName = 'IT Test Company';        
        newUser2.CommunityNickname = 'test098';
        newUser2.Username = 'Sandeep5@test.com' ;
        newUser2.Alias = 'test';
        newUser2.TimeZoneSidKey = 'GMT';
        newUser2.LocaleSidKey= 'en_US';
        newUser2.EmailEncodingKey = 'UTF-8';
        newUser2.LanguageLocaleKey = 'en_US';         
        newUser2.ProfileId = pf[0].Id ;                                  
        newUser2.ContactId =Con.Id;                   
        newUser2.isActive = TRUE;
        newUser2.Street = '123 Test St';
        newUser2.FederationIdentifier = '2460000'; 
        //insert newUser2;
        
        USer newUserPWC=[select id,name,profile.Name from user where Profile.Name='IAM_PWC_User_Profile' LIMIT 1];
        System.runAs(newUserPWC){
            ApexPages.currentPage().getParameters().put('appid', app.id); 
            ApexPages.currentPage().getParameters().put('returl','marketplace');
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            IAM_CumminsRedirectPage_new.getSegmentSku('testing');
            objclass.Redirect();
            objclass.u=newUserPWC;
            objclass.en='test.salesforce.com';
        }
    }
    
    //market place internal user.
    
    Static testMethod void testCumminsRedirect13(){
        
         App_Mapping__c app=new App_Mapping__c();
        app.name='Marketplace';
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
        
        User loggedUser = [Select Id,Name,FederationIdentifier From User WHERE id =: UserInfo.getUserId()];
        
        System.runAs(loggedUser){
            List<Contact> con = [select id,IAM_Internal__c,IAM_Site_Admin__c,CMI_Contact_Type__c,Accountid FROM Contact WHERE CMI_Contact_Type__c ='Secondary' AND IAM_Site_Admin__c = True LIMIT 1]; 
           // App_Mapping__c appMap = [Select Id,Name,IAM_Request_Access__c From App_Mapping__c WHERE Name = 'Online Login' LIMIT 1];
            
            ApexPages.currentPage().getParameters().put('appid', app.id); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            ApexPages.currentPage().getParameters().put('returl','marketplace');
            IAM_CumminsRedirectPage_new.getSegmentSku('testing');
            
            objclass.Redirect();
        } 
    }
    
    static testMethod void testNegativeCase(){
        User loggedUser = [Select Id,Name,FederationIdentifier From User WHERE id =: UserInfo.getUserId()];
        App_Mapping__c app=new App_Mapping__c();
        app.name=Label.IAM_Default_Appmap;
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
        
        System.runAs(loggedUser){
            ApexPages.currentPage().getParameters().put('appid', ''); 
            IAM_CumminsRedirectPage_new objClass=new IAM_CumminsRedirectPage_new();
            ApexPages.currentPage().getParameters().put('returl','');
            objclass.Redirect();
        } 
    }
}