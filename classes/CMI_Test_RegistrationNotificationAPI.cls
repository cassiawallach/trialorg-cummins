/************************************************************
Name:  CMI_Test_RegistrationNotificationAPI
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
Apex class is test class for CMI_RegistrationNotificationAPI                      
=============================================================
=============================================================
***********************************************************************************/
@istest
public class CMI_Test_RegistrationNotificationAPI {
 
   static testMethod void  TestCMIResponse(){
   
   Account acc=new Account();
   acc.name='Test';
   //acc.AccountNumber='1232332';
   //acc.CMI_CDA_Status__c= 'Sent to Customer';
   insert acc;
   
   Account acc1=new Account();
   acc1.name='Test';
   //acc.AccountNumber='1232332';
   acc1.CMI_CDA_Status__c= 'Signed by Customer';
   insert acc1;
   System.debug('acc1========'+acc1);
   String JsonMsg = JSON.serialize('Test');
     
   Account accobj = [select id,CMI_CId__c  from Account where id=:acc.id ];
   System.debug('accobj ========'+accobj ); 
   
   Account accobj1 = [select id,CMI_CId__c  from Account where id=:acc1.id ];
   System.debug('accobj ========'+accobj1 ); 
  // Test.startTest();
   
   IAM_Application__c appIAM= new IAM_Application__c();   
        appIAM.IAM_Account_Name__c = accobj .ID;
        appIAM.IAM_Application_Name__c = 'Connected Solutions';
        appIAM.IAM_Role__c='PrimaryContact';
        appIAM.IAM_Status__c='Pending';
        appIAM.IAM_Subscription_Count__c= 10;
        appIAM.IAM_Provisioned_User_Count__c=5;
        appIAM.IAM_Subscription_End_Date__c= System.today() + 5;
        appIAM.IAM_Subscription_Name__c='TestSubscription1';
        appIAM.IAM_Free_Subscription__c= False;
        appIAM.IAM_Subscription_Start_Date__c=System.today();
        appIAM.recordtypeid=Schema.SObjectType.IAM_application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        insert appIAM;
  
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();         
   req.requestURI = '/services/apexrest/CMI_RegistrationNotificationAPI/'+ acc.CMI_CId__c;  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;   
   CMI_RegistrationNotificationAPI.CMI_ResponseHandler response = CMI_RegistrationNotificationAPI.Post('','','','');
   
   req.requestURI = '/services/apexrest/CMI_RegistrationNotificationAPI/'+ accobj1.CMI_CId__c;  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;   
   CMI_RegistrationNotificationAPI.CMI_ResponseHandler response2 = CMI_RegistrationNotificationAPI.Post('','','','');
   
   
   req.requestURI = '/services/apexrest/CMI_RegistrationNotificationAPI/'+ accobj.CMI_CId__c;  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;   
   CMI_RegistrationNotificationAPI.CMI_ResponseHandler response1 = CMI_RegistrationNotificationAPI.Post('Test','MR','test@test.com','09/13/2016 12:00 PM');
   
   
  
   //Test.stopTest();
   
   }
 }