/*Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_NewContactRegistration_Test class. 
NewContactRegistration for salesforce IAM users.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Keerthy Gurumurthy     23/04/2018       INITIAL DEVELOPMENT
1.1 -    Nishant Verma          04/12/2020       High Radius
1.2 -    Karthik Raj Golakaram  02/12/2021       shop Online Test.   
1.3 -    Shubhangi Sardar       09/06/2021       Added comment to push to production
1.4 -    Vineet                 05/09/2021       DN Value changes 
1.5-     Suresh Rathod 			07/02/2021       Cummins API Portal   
*****************************************************/
/********************************************************************************
***********************************************************************************/

@isTest
public class IAM_NewContactRegistration_Test {
        
 static testmethod void myUnitTest(){
               
        Account a= new Account();
        a.Name='Identity Individual Users';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        insert a;
        
        IAM_Application__c iamApp=new IAM_Application__c();
        iamApp.IAM_Application_Name__c='Box External Partners';
        iamApp.IAM_Account_Name__c=a.id;
        iamApp.IAM_Role__c='User';
        iamApp.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('BOX External Partners').getRecordTypeId();
        iamApp.IAM_Status__c='Active';
        iamApp.IAM_Free_Subscription__c=True;
        insert iamApp;
        
        
        
        IAM_Application__c iamApp1=new IAM_Application__c();
        iamApp1.IAM_Application_Name__c='Archer';
        iamApp1.IAM_Account_Name__c=a.id;
        iamApp1.IAM_Role__c='User';
        iamApp1.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Archer').getRecordTypeId();
        iamApp1.IAM_Status__c='Active';
        iamApp1.IAM_Free_Subscription__c=True;
        insert iamApp1;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.LastName = 'test852';
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
        
         App_Mapping__c app=new App_Mapping__c();
        app.name='BOX External Partners';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_Default_Role__c='User';
        app.IAM_App_Protected_By__c='SAML';
        insert app;     
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('appid', app.id);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(con);
        IAM_NewContactRegistration iam = new IAM_NewContactRegistration();
        iam.newCon=Con;
        iam.validateContact();
        iam.registerContact();
        iam.randomNumber();
        iam.getChar1();
        iam.getChar2();
        iam.getChar3();
        iam.getChar4();
        iam.getChar5();
        iam.getChar6();
        iam.getCountries();
        iam.emailcheck();
        iam.BusinessTabreset();
        
       
        iam.errordiv=false;
        iam.result='same';
        iam.errorContactemail1='';
        iam.CurrentRecordid=app.id;
        iam.input='33434';
           
        Test.stopTest();
    }
    
    static testmethod void myUnitTest2(){
        
        
        Account a= new Account();
        a.Name='Identity Individual Users';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        insert a;
        
      
        
        
        IAM_Application__c iamApp1=new IAM_Application__c();
        iamApp1.IAM_Application_Name__c='Archer';
        iamApp1.IAM_Account_Name__c=a.id;
        iamApp1.IAM_Role__c='User';
        iamApp1.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Archer').getRecordTypeId();
        iamApp1.IAM_Status__c='Active';
        iamApp1.IAM_Free_Subscription__c=True;
        insert iamApp1;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'test1';
        Con.LastName = 'test852';
        con.IAM_Cummins_Login_ID__c='test000@eiamarcher.com';
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
        
         App_Mapping__c app=new App_Mapping__c();
        app.name='Archer';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_Default_Role__c='User';
        app.IAM_App_Protected_By__c='SAML';
        insert app;     
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('appid', app.id);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(con);
        IAM_NewContactRegistration iam = new IAM_NewContactRegistration();
        iam.newCon=Con;
        iam.validateContact();
        iam.registerContact();
        iam.randomNumber();
        iam.getChar1();
        iam.getChar2();
        iam.getChar3();
        iam.getChar4();
        iam.getChar5();
        iam.getChar6();
        iam.getCountries();
        iam.emailcheck();
        iam.BusinessTabreset();
        
       
        iam.errordiv=false;
        iam.result='same';
        iam.errorContactemail1='';
        iam.CurrentRecordid=app.id;
        iam.input='33434';
           
        Test.stopTest();
    }
    static testmethod void myUnitTest3(){
        
        
        Account a= new Account();
        a.Name='Identity Individual Users';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        insert a;
        
      
        
        
        IAM_Application__c iamApp1=new IAM_Application__c();
        iamApp1.IAM_Application_Name__c='HighRadius';
        iamApp1.IAM_Account_Name__c=a.id;
        iamApp1.IAM_Role__c='Customer View and Pay';
        iamApp1.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('HighRadius').getRecordTypeId();
        iamApp1.IAM_Status__c='Active';
        iamApp1.IAM_Free_Subscription__c=True;
        insert iamApp1;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'testHR';
        Con.LastName = 'test852HR';
        con.IAM_Cummins_Login_ID__c='test000@eiamarcher.com';
        Con.Email = 'test000HR@eiam.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Active';
        Con.iam_Internal__c=false;
        Con.IAM_from_Registration__c=True;
        
         App_Mapping__c app=new App_Mapping__c();
        app.name='HighRadius';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_Default_Role__c='Customer View and Pay';
        app.IAM_App_Protected_By__c='SAML';
        app.IAM_Approval_Needed__c=false;
        insert app;     
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('appid', app.id);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(con);
        IAM_NewContactRegistration iam = new IAM_NewContactRegistration();
        iam.newCon=Con;
        iam.validateContact();
        iam.registerContact();
        iam.randomNumber();
        iam.getChar1();
        iam.getChar2();
        iam.getChar3();
        iam.getChar4();
        iam.getChar5();
        iam.getChar6();
        iam.getCountries();
        iam.emailcheck();
        iam.BusinessTabreset();
        iam.getlanguages();
        
       
        iam.errordiv=false;
        iam.result='same';
        iam.errorContactemail1='';
        iam.CurrentRecordid=app.id;
        iam.input='33434';
        Test.stopTest();
    }
    static testmethod void myUnitTest4(){
        
        
        Account a= new Account();
        a.Name='Identity Individual Users';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        a.FSL_ERP_Customer_Code__c='48931-USA';
        insert a;
        
      
        
        
        IAM_Application__c iamApp1=new IAM_Application__c();
        iamApp1.IAM_Application_Name__c='HighRadius';
        iamApp1.IAM_Account_Name__c=a.id;
        iamApp1.IAM_Role__c='Customer View and Pay';
        iamApp1.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('HighRadius').getRecordTypeId();
        iamApp1.IAM_Status__c='Active';
        iamApp1.IAM_Free_Subscription__c=True;
        insert iamApp1;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'testHR';
        Con.LastName = 'test852HR';
        con.IAM_Cummins_Login_ID__c='test000@eiamarcher.com';
        Con.Email = 'test000HR@eiam.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Active';
        Con.iam_Internal__c=false;
        Con.IAM_from_Registration__c=True;
        
         App_Mapping__c app=new App_Mapping__c();
        app.name='HighRadius';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_Default_Role__c='Customer View and Pay';
        app.IAM_App_Protected_By__c='SAML';
        insert app;     
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('appid', app.id);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(con);
        IAM_NewContactRegistration iam = new IAM_NewContactRegistration();
       String responseBody = '{"status":"Error","message":"Error Message","instance":"ONEBMS","erpCustomerCode":"48931-USA"}';
        Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBody, null));
        IAM_HighRadius_GetBMSInstance.getBMSInstance('561251', '75-28162');
        iam.newCon=Con;
        iam.validateContact();
        iam.registerContact();
        iam.randomNumber();
        iam.getChar1();
        iam.getChar2();
        iam.getChar3();
        iam.getChar4();
        iam.getChar5();
        iam.getChar6();
        iam.getCountries();
        iam.emailcheck();
        iam.BusinessTabreset();
        iam.getlanguages();
        
       
        iam.errordiv=false;
        iam.result='same';
        iam.errorContactemail1='';
        iam.CurrentRecordid=app.id;
        iam.input='33434';
        Test.stopTest();
    }
    static testmethod void myUnitTest5(){
        
        
        Account a= new Account();
        a.Name='Identity Individual Users';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        //a.FSL_ERP_Customer_Code__c='48931-USA';
        insert a;
        
      
        
        
        IAM_Application__c iamApp1=new IAM_Application__c();
        iamApp1.IAM_Application_Name__c='HighRadius';
        iamApp1.IAM_Account_Name__c=a.id;
        iamApp1.IAM_Role__c='Customer View and Pay';
        iamApp1.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('HighRadius').getRecordTypeId();
        iamApp1.IAM_Status__c='Active';
        iamApp1.IAM_Free_Subscription__c=True;
        insert iamApp1;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'testHR';
        Con.LastName = 'test852HR';
        con.IAM_Cummins_Login_ID__c='test000@eiamarcher.com';
        Con.Email = 'test000HR@eiam.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Active';
        Con.iam_Internal__c=false;
        Con.IAM_from_Registration__c=True;
        
         App_Mapping__c app=new App_Mapping__c();
        app.name='HighRadius';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_Default_Role__c='Customer View and Pay';
        app.IAM_App_Protected_By__c='SAML';
        
        insert app;     
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('appid', app.id);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(con);
        IAM_NewContactRegistration iam = new IAM_NewContactRegistration();
        iam.newCon.IAM_Individual_Company_Name__c =a.Name;
        iam.validateContact();
        iam.registerContact();
        iam.randomNumber();
        iam.getChar1();
        iam.getChar2();
        iam.getChar3();
        iam.getChar4();
        iam.getChar5();
        iam.getChar6();
        iam.getCountries();
        iam.emailcheck();
        iam.BusinessTabreset();
        iam.getlanguages();
        
       
        iam.errordiv=false;
        iam.result='same';
        iam.errorContactemail1='';
        iam.CurrentRecordid=app.id;
        iam.input='33434';
        Test.stopTest();
    }
   static testmethod void myUnitTest6(){
        
        
        Account a= new Account();
        a.Name='Identity Individual Users';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        a.FSL_ERP_Customer_Code__c='48931-USA';
        insert a;
        
      
        
        
        IAM_Application__c iamApp1=new IAM_Application__c();
        iamApp1.IAM_Application_Name__c='HighRadius';
        iamApp1.IAM_Account_Name__c=a.id;
        iamApp1.IAM_Role__c='Customer View and Pay';
        iamApp1.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('HighRadius').getRecordTypeId();
        iamApp1.IAM_Status__c='Active';
        iamApp1.IAM_Free_Subscription__c=True;
        insert iamApp1;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Con.FirstName = 'testHR';
        Con.LastName = 'test852HR';
        Con.Accountid=a.id;
        //con.IAM_Cummins_Login_ID__c='test000@eiamarcher.com';
        Con.Email = 'test000HR11@eiam.com';
        /*Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Active';
        Con.iam_Internal__c=false;
        Con.IAM_from_Registration__c=True;*/
        insert con;
        list<Contact> conl = new list<Contact>();
        conl.add(con);
        
         App_Mapping__c app=new App_Mapping__c();
        app.name='HighRadius';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_Default_Role__c='Customer View and Pay';
        app.IAM_App_Protected_By__c='SAML';
        
        insert app;     
        
        Test.startTest();
        try {
        ApexPages.currentPage().getParameters().put('appid', app.id);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(con);
        IAM_NewContactRegistration iam = new IAM_NewContactRegistration();
         iam.newCon= con;
        iam.UpdateexistingcontactHR(conl);
        
        iam.newCon.FirstName =con.FirstName;
        iam.newCon.LastName =con.LastName;
        iam.newCon.Email =con.Email;
        iam.validateContact();
        iam.registerContact();
        iam.randomNumber();
        iam.getChar1();
        iam.getChar2();
        iam.getChar3();
        iam.getChar4();
        iam.getChar5();
        iam.getChar6();
        iam.getCountries();
        iam.emailcheck();
        iam.BusinessTabreset();
        iam.getlanguages();
        
       
        iam.errordiv=false;
        iam.result='same';
        iam.errorContactemail1='';
        iam.CurrentRecordid=app.id;
        iam.input='33434';
        iam.getlanguagesQSO();
        } catch(Exception e) {
            System.debug('#### - '+e.getMessage());
        }
       
        Test.stopTest();
    }

    //Added Test method for Cummins API Changes- @Suresh
    static testmethod void myUnitTestCumminsAPIPortal(){
        
        
        Account a= new Account();
        a.Name='Identity Individual Users';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        insert a;
        
      
        
        
        IAM_Application__c iamApp1=new IAM_Application__c();
        iamApp1.IAM_Application_Name__c='Cummins API Portal';
        iamApp1.IAM_Account_Name__c=a.id;
        iamApp1.IAM_Role__c='API Owner';
        iamApp1.RecordTypeid=Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins API Portal').getRecordTypeId();
        iamApp1.IAM_Status__c='Active';
        iamApp1.IAM_Free_Subscription__c=True;
        insert iamApp1;
        
        contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'testCummins';
        Con.LastName = 'testAPIPortal';
        con.IAM_Cummins_Login_ID__c='testcumminsapiportal@test.com';
        Con.Email = 'testcumminsapiportal@apitest.com';
        Con.phone = '1112223335';
        Con.MailingStreet = 'Test Street';
        Con.MailingCity = 'Test City';
        Con.MailingPostalCode = '11111';
        Con.MailingCountryCode = 'US';
        Con.MailingStateCode = 'IN';
        Con.iam_Contact_Status__c = 'Pending';
        Con.iam_Internal__c=false;
        Con.IAM_from_Registration__c=True;
        
         App_Mapping__c app=new App_Mapping__c();
        app.name='Cummins API Portal';
        app.Back_page__c='https://login.salesforce.com/';
        app.Login_Url__c='https://www.facebook.com/';
        app.IAM_Default_Role__c='API Owner';
        app.IAM_App_Protected_By__c='SAML';
		app.IAM_Approval_Needed__c=true;
        insert app;     
        
        Test.startTest();
        ApexPages.currentPage().getParameters().put('appid', app.id);
        ApexPages.standardController stdCon12 = new  ApexPages.standardController(con);
        IAM_NewContactRegistration iam = new IAM_NewContactRegistration();
        iam.newCon=Con;
        iam.validateContact();
        iam.registerContact();
        iam.randomNumber();
        iam.getChar1();
        iam.getChar2();
        iam.getChar3();
        iam.getChar4();
        iam.getChar5();
        iam.getChar6();
        iam.getCountries();
        iam.emailcheck();
        iam.BusinessTabreset();
        //iam.getDependentPicklistValues(app.name);
        
       
        iam.errordiv=false;
        iam.result='same';
        iam.errorContactemail1='';
        iam.CurrentRecordid=app.id;
        iam.input='33434';
           
        Test.stopTest();
    }
    
}