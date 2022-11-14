/************************************************************
Name:  IAM_ChangePasswordController_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is Controller class for IAM_ChangePasswordController_Test for change password page.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION   AUTHOR                   DATE              DETAIL                                
1.0 -   Keerthy Gurumurthy      23/04/2018        INITIAL DEVELOPMENT  
1.1 -   Karthik Golakaram       11/3/2020     Made changes to display language in only Change password page 
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
public class IAM_ChangePasswordController_Test{
    @testsetup
    public static void createTestData(){
        
        //App Mapping
        App_Mapping__c app1=new App_Mapping__c();
        app1.name='Connected Solutions';
        app1.Back_page__c='https://login.salesforce.com/';
        app1.Login_Url__c='https://www.facebook.com/';
        app1.CMI_External_Start_Url__c = 'https://qs-dev.cummins.com/';
        app1.IAM_OAM_Resource_URL__c = 'https://qs-dev.cummins.com/';
        app1.IAM_Default_Role__c='User';
        app1.IAM_App_Protected_By__c='SAML';
        app1.IAM_Authroization_Required__c = true;
        app1.IAM_OAM_Resource_URL_Redirection__c = true;
        app1.IAM_Request_Access__c = true;
        app1.IAM_Different_Request_Access_URL__c = false;
        insert app1;
        
        App_Mapping__c app2=new App_Mapping__c();
        app2.name='Electrification';
        app2.Back_page__c='';
        app2.Login_Url__c='';
        app2.CMI_External_Start_Url__c = 'https://qs-dev.cummins.com/';        
        app2.IAM_Default_Role__c='User';
        app2.IAM_Authroization_Required__c = true;
        app2.IAM_OAM_Resource_URL_Redirection__c = true;
        app2.IAM_App_Protected_By__c='SAML';
        app2.IAM_Request_Access__c = true;
        app2.IAM_Different_Request_Access_URL__c = true;
        insert app2;
        
        //Account
        Account acc1= new Account();       
        acc1.Name = 'Test Company';
        acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        acc1.phone = '6884382997';
        acc1.BillingCity='Columbus';
        acc1.BillingStreet='340 Brown Street';
        acc1.BillingCountry='United States';
        acc1.BillingPostalCode='47201';
        acc1.BillingState='Indiana';
        insert acc1;
        
        //Account Feature & Access
        IAM_Application__c accPro1 = new IAM_Application__c();
        accPro1.IAM_Application_Name__c = 'Connected Solutions';
        accPro1.IAM_Role__c = 'EV User';
        accPro1.IAM_Status__c = 'Active';
        accPro1.IAM_Account_Name__c = acc1.id;
        accPro1.IAM_Subscription_Name__c = 'test1';
        insert accPro1;
        
        IAM_Application__c accPro2 = new IAM_Application__c();
        accPro2.IAM_Application_Name__c = 'Marketplace';
        accPro2.IAM_Role__c = 'OSM Role';
        accPro2.IAM_Status__c = 'Active';
        accPro2.IAM_Account_Name__c = acc1.id;
        accPro2.IAM_Subscription_Name__c = 'test2';
        insert accPro2;
        
        //Contact
        contact Con1=new contact();
        Con1.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con1.FirstName = 'TestConnected';
        Con1.LastName = 'evUser';
        Con1.AccountId = acc1.Id;
        Con1.Username__c = 'TestConnectedevUser@gmail.com'; 
        Con1.Email = 'TestConnectedevUser@gmail.com';     
        Con1.IAM_Internal__c = False;
        Con1.IAM_Site_Admin__c = False;
        Con1.CMI_Contact_Type__c = 'secondary';
        Con1.IAM_AppId__c = app1.Id;
        Con1.IAM_Contact_Status__c = 'Active';
        insert Con1;
        
        //IAM Contact Provisioning
        IAM_Contact_Provisioning__c conPro1 = new IAM_Contact_Provisioning__c();  
        conPro1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        conPro1.IAM_Application_Name__c = 'Connected Solutions';     
        conPro1.IAM_Status__c = 'Active';
        conPro1.IAM_Role__c = 'EV User';
        conPro1.IAM_Contact__c = Con1.id; 
        conPro1.IAM_Account_Application__c = accPro1.id;
        insert conPro1;
    }
    
    Static testMethod void test1(){
     
      User loggedUser = [Select Id, isActive, Email,LastLoginDate, FederationIdentifier,UserName, ContactId, CompanyName,LanguageLocaleKey,IAM_Challenge_Question_1__c,IAM_Challenge_Question_2__c,IAM_Challenge_Question_3__c From User Where UserName='TestConnectedevUser@gmail.com' LIMIT 1];  
       System.runAs(loggedUser){
        App_Mapping__c appMap = [Select Id,Name,IAM_Request_Access__c,CMI_External_Start_Url__c From App_Mapping__c  LIMIT 1];   
        ApexPages.currentPage().getParameters().put('appid', appMap.id); 
        Apexpages.currentpage().getParameters().put('selectedLanguage',loggedUser.LanguageLocaleKey);
        String referUrl = 'https://www.facebook.com/';
        ApexPages.currentPage().getHeaders().put('referer',referUrl);
        IAM_ChangePasswordController objClass=new IAM_ChangePasswordController();
        objclass.questioninput = True;
        objclass.answrquestion = False;
        objClass.challangequestion1 = 'What is your name?';
        objClass.challangequestion2 = 'In which city you stay?';
        objClass.challangequestion3 = 'In which city you stay?';     
        objclass.setAnswer();
           
        objClass.challangequestion1 = 'What is your name?';
        objClass.challangequestion2 = 'What is your name?';
        objClass.challangequestion3 = 'In which city you stay?'; 
        objclass.setAnswer();
        
        objClass.challangequestion1 = 'What is your name?';
        objClass.challangequestion2 = 'In which city you stay?';
        objClass.challangequestion3 = 'What is your name?'; 
        objclass.setAnswer();
           
        objClass.newPassword = 'verifyNewPassword';
        objclass.InvalidPass = true;
        objclass.err = 'valid repeated password';
        objclass.newpassword();
        objclass.resetAnswer();
        objclass.passerrordiv = false;        
        
        objclass.Changelanguage();
        List<SelectOption> options = objclass.getselectedquestionfields();
       }  
     }
    
    Static testMethod void test2(){
        User loggedUser = [Select Id, isActive, Email,LastLoginDate, FederationIdentifier,UserName, ContactId, CompanyName,LanguageLocaleKey,IAM_Challenge_Question_1__c,IAM_Challenge_Question_2__c,IAM_Challenge_Question_3__c,IAM_Challange_Answer1__c,IAM_Challange_Answer2__c,IAM_Challange_Answer3__c From User Where UserName='TestConnectedevUser@gmail.com' LIMIT 1];  
       	System.runAs(loggedUser){
        App_Mapping__c appMap = [Select Id,Name,IAM_Request_Access__c,CMI_External_Start_Url__c From App_Mapping__c  LIMIT 1];   
        ApexPages.currentPage().getParameters().put('appid', appMap.id); 
         
        IAM_ChangePasswordController objClass=new IAM_ChangePasswordController();
        objclass.questioninput = True;
        objclass.answrquestion = False;
        objclass.challangequestion1 = 'What is your name?';
        objclass.challangequestion2 = 'In which city you stay?';
        objclass.challangequestion3 = 'What is your favorite food?';
        objclass.challangeAnswer1 = 'Test1';
        objclass.challangeAnswer2 = 'Test2';
        objclass.challangeAnswer3 = 'Test3';
        objclass.setAnswer();
    }
    }
    
    Static testMethod void test3(){
        User loggedUser = [Select Id, isActive, Email,LastLoginDate, FederationIdentifier,UserName, ContactId, CompanyName,LanguageLocaleKey,IAM_Challenge_Question_1__c,IAM_Challenge_Question_2__c,IAM_Challenge_Question_3__c,IAM_Challange_Answer1__c,IAM_Challange_Answer2__c,IAM_Challange_Answer3__c From User Where UserName='TestConnectedevUser@gmail.com' LIMIT 1];
       	System.runAs(loggedUser){
        App_Mapping__c appMap = [Select Id,Name,IAM_Request_Access__c,CMI_External_Start_Url__c From App_Mapping__c  LIMIT 1];   
        ApexPages.currentPage().getParameters().put('appid', appMap.id); 
         
        IAM_ChangePasswordController objClass=new IAM_ChangePasswordController();
        objclass.questioninput = True;
        objclass.answrquestion = False;
        objclass.challangequestion1 = 'What city were you born in?';
        objclass.challangequestion2 = 'What is the make of your first car?';
        objclass.challangequestion3 = 'What is your favorite sport?';
        objclass.challangeAnswer1 = 'Test1';
        objclass.challangeAnswer2 = 'Test2';
        objclass.challangeAnswer3 = 'Test3';
        objclass.setAnswer();
            
        objclass.questioninput = True;
        objclass.answrquestion = True;
        objclass.setAnswer();
            
        objclass.challangeAnswer3 = 'ReTest3';
        objclass.setAnswer();
        objclass.newPass='TestPass@123';
        objclass.newpassword();
    }
    }   
}