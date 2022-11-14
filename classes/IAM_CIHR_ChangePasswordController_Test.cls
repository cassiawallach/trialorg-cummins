/*********************************************************************************
Author       :   Chetan Gaikwad
Created Date :   6th Feb,2020
Description  :   Unit test class for  IAM_CIHR_ChangePasswordController.
*********************************************************************************/
@isTest(seeAllData=True)
public class IAM_CIHR_ChangePasswordController_Test{
    
    
     Static testMethod void test1(){
    Account a= new Account();       
        a.Name = 'Test Company';
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        a.phone = '6884382997';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        a.CMI_Account_Status__c='Active';
        insert a;
    
    contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = 'Change';
        Con.LastName = 'Password';
        Con.AccountId = a.Id;
        con.Username__c='testChangepassowrd@eiam.com';   
        Con.Email = 'testChangepassowrd@eiam.com';     
        Con.IAM_Internal__c = False;
        Con.IAM_Legacy_User__c=false;
        con.CMI_Contact_Type__c = 'secondary';
        Con.IAM_Contact_Status__c='Active';
        insert Con;
        
        App_Mapping__c app=new App_Mapping__c();
        app.name='test app';
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
        
        
 
    
    
   
        // App_Mapping__c appMap = [Select Id,Name,IAM_Request_Access__c From App_Mapping__c Where Name='test app' LIMIT 1];
    Contact c=[Select id from Contact where email='testChangepassowrd@eiam.com']; 
    User loggedUser = [Select Id, isActive, Email,LastLoginDate, FederationIdentifier,UserName, ContactId, CompanyName,LanguageLocaleKey,IAM_Challenge_Question_1__c,IAM_Challenge_Question_2__c,IAM_Challenge_Question_3__c,IAM_External_User_Num__c From User Where isActive = true AND Contactid=:c.id LIMIT 1];  
     System.debug('external user number'+loggedUser.IAM_External_User_Num__c);
       System.runAs(loggedUser){
              
        
        Apexpages.currentpage().getParameters().put('selectedLanguage',loggedUser.LanguageLocaleKey);
        String startUrl = '';
        ApexPages.currentPage().getParameters().put('starturl',startUrl );
        String referUrl = 'https://www.facebook.com/';
         ApexPages.currentPage().getHeaders().put('referer',referUrl);
        //ApexPages.currentPage().getParameters().put('appid','a1a6C0000001pm0' ); //appMap.id
        ApexPages.currentPage().getParameters().put('uNumber',loggedUser.IAM_External_User_Num__c);
        IAM_CIHR_ChangePasswordController objClass=new IAM_CIHR_ChangePasswordController();
        
        
        //objClass.oldPassword = 'test123';
        //objClass.newPassword = 'test123';
        objclass.questioninput = True;
        objclass.answrquestion = False;
        objClass.challangequestion1 = 'What is your name?';
        objClass.challangequestion2 = 'In which city you stay?';
        objClass.challangequestion3 = 'What city were you born in?'; 
        ObjClass.challangeAnswer1='test';
        ObjClass.challangeAnswer2='test1';
        ObjClass.challangeAnswer3='test2';
               
        objclass.setAnswer();
        objClass.newPassword = 'verifyNewPassword';
        objclass.InvalidPass = true;
       // objclass.challangeAnswer = 'testing12';
        objclass.newpassword();
        objclass.reclaimUserCheck();
        objclass.resetAnswer();
        objclass.passerrordiv = false;        
        
        objclass.Changelanguage();
        List<SelectOption> options = objclass.getselectedquestionfields();
       }  
     }
     
     
    
    Static testMethod void test2(){
    Account a= new Account();       
        a.Name = 'Test Company1';
        a.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();  
        a.phone = '6884382997';
        a.BillingCity='Columbus';
        a.BillingStreet='340 Brown Street';
        a.BillingCountry='United States';
        a.BillingPostalCode='47201';
        a.BillingState='Indiana';
        a.CMI_Account_Status__c='Active';
        insert a;
    
    contact Con=new contact();
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        Con.FirstName = '1Change';
        Con.LastName = '2Password';
        Con.AccountId = a.Id;
        con.Username__c='testChangepassowrd12@eiam.com';   
        Con.Email = 'testChangepassowrd12@eiam.com';     
        Con.IAM_Internal__c = False;
        Con.IAM_Legacy_User__c=false;
        con.CMI_Contact_Type__c = 'secondary';
        Con.IAM_Contact_Status__c='Active';
        insert Con;
        
        App_Mapping__c app=new App_Mapping__c();
        app.name='test app';
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
        
        
 
    
    
   
        // App_Mapping__c appMap = [Select Id,Name,IAM_Request_Access__c From App_Mapping__c Where Name='test app' LIMIT 1];
    Contact c=[Select id from Contact where email='testChangepassowrd12@eiam.com']; 
    User loggedUser = [Select Id, isActive, Email,LastLoginDate,IAM_Challange_Answer1__c, FederationIdentifier,UserName, ContactId, CompanyName,LanguageLocaleKey,IAM_Challenge_Question_1__c,IAM_Challenge_Question_2__c,IAM_Challenge_Question_3__c,IAM_External_User_Num__c From User Where isActive = true AND Contactid=:c.id LIMIT 1];  
     System.debug('external user number'+loggedUser.IAM_External_User_Num__c);
      
       System.runAs(loggedUser){
              
        
        Apexpages.currentpage().getParameters().put('selectedLanguage',loggedUser.LanguageLocaleKey);
        String startUrl = '';
        ApexPages.currentPage().getParameters().put('starturl',startUrl );
        String referUrl = 'https://www.facebook.com/';
         ApexPages.currentPage().getHeaders().put('referer',referUrl);
        //ApexPages.currentPage().getParameters().put('appid','a1a6C0000001pm0' ); //appMap.id
        ApexPages.currentPage().getParameters().put('uNumber',loggedUser.IAM_External_User_Num__c);
        ApexPages.currentPage().getParameters().put('randomNumber','123456');
        IAM_CIHR_ChangePasswordController objClass=new IAM_CIHR_ChangePasswordController();
        
        
        //objClass.oldPassword = 'test123';
        //objClass.newPassword = 'test123';
        objclass.questioninput = True;
        objclass.answrquestion = False;
        objClass.challangequestion1 = 'In which city you stay?';
        objClass.challangequestion2 = 'In which city you stay?';
        objClass.challangequestion3 = 'In which city you stay?'; 
        ObjClass.challangeAnswer1='';
        ObjClass.challangeAnswer2='';
        ObjClass.challangeAnswer3='';
               
        ObjClass.setAnswer();
        ObjClass.reclaimUserCheck();
        ObjClass.oldPassword='Test_123';
        ObjClass.verifyNewPassword='Test_123';
        ObjClass.challangeAnswer='Test_!23';
        ObjClass.randomNumber='1231213';
       
       }  
     }
     
     
     Static testMethod void test3(){
     
     
     
        IAM_CIHR_ChangePasswordController objClass=new IAM_CIHR_ChangePasswordController();
        
        
        //objClass.oldPassword = 'test123';
        //objClass.newPassword = 'test123';
        
        objclass.questioninput = True;
        objclass.answrquestion = False;
        objClass.challangequestion1 = 'In which city you stay?';
        objClass.challangequestion2 = '';
        objClass.challangequestion3 = 'In which city you stay?'; 
        
        
               
        ObjClass.setAnswer();
        
       
     }
    
    
     Static testMethod void test4(){
     
     
     
        IAM_CIHR_ChangePasswordController objClass=new IAM_CIHR_ChangePasswordController();
        
        
        //objClass.oldPassword = 'test123';
        //objClass.newPassword = 'test123';
        
        objclass.questioninput = True;
        objclass.answrquestion = False;
        objClass.challangequestion2 = 'In which city you stay?';
        objClass.challangequestion1 = '';
        objClass.challangequestion3 = 'In which city you stay?'; 
        
        
               
        ObjClass.setAnswer();
        
       
     }
}