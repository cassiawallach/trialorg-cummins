/************************************************************
Name:  CMI_APIAccountCreation_Test
Copyright © 2019  Cummins
=============================================================
Purpose:  Test class of CMI_APIAccountCreation                           
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                     DATE              DETAIL                                
1.0 -    Harshini Basina        20/04/2017        INITIAL DEVELOPMENT  
1.1 -    Anupam Adhikari        01/05/2021       Made changes for creating account access feature.
1.2 -    Karthik Raj Golakaram  05/21/2021       Made changes for query to include Limits
1.3 -    Shubhangi Sardar       05/26/2021       Added DN Value Changes
1.4 -    Vineet                 15/09/2021       Added changes for DN Value
*****************************************************/
/********************************************************************************
***********************************************************************************/ 

@istest
public class CMI_APIAccountCreation_Test {
 
   
    static testMethod void  TestAPIAccountCreationResponse1(){
   
   Account acc=new Account();
   acc.name='Test';
    acc.CMI_Moratorium__c = 'No';
    acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
   //acc.AccountNumber ='1232332';
   //acc.CMI_CDA_Status__c= 'Sent to Customer';
   insert acc;
   
   Account acc1=new Account();
   acc1.name='Test';
   //acc.AccountNumber='1232332';
   acc1.CMI_CDA_Status__c= 'Signed by Customer';
    acc1.CMI_Moratorium__c = 'No';
   insert acc1;
       
    Contact conObj = new Contact();
     conObj.Accountid = acc1.id;
     conObj.firstName='Test';
     conObj.lastName='Test';
       conObj.phone='2323344556677889';
       conObj.email='Test@testfinal.com';
        //conObj.Username__c='a766227Navistar@noemail.com.iamosmdev';
    insert conObj;
        String sConId = conObj.Id;

        
   System.debug('acc1========'+acc1);
   String JsonMsg = JSON.serialize('Test');
        String sStatus = 'Active';
        String sCid = 'I934605';
        String Cid = '546354';
     
   Account accobj = [select id,CMI_CId__c,CMI_Moratorium__c  from Account where id=:acc.id ];
       
   System.debug('accobj ========'+accobj ); 
   
   Account accobj1 = [select id,CMI_CId__c,CMI_Moratorium__c  from Account where id=:acc1.id ];
   System.debug('accobj ========'+accobj1 ); 
  // Test.startTest();
   
   //changes for DA Portal enhancement request - @Anupam 
   Account acc2=new Account();
        acc2.name='Test234'; 
        acc2.CMI_Moratorium__c = 'No';
        acc2.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        //acc.AccountNumber='1232332';
        //acc2.CMI_CDA_Status__c= 'Sent to Customer';
        acc2.CMI_CId__c = '546354';
            insert acc2;
        String sAccId = acc2.Id;
        //String Cid = acc2.CMI_CId__c; 
        
        CMI_TSP__c tspObj = new CMI_TSP__c();                
        tspObj.CMI_TSP_ID__c = '21321312';
        tspObj.CMI_Telematics_ID__c ='12345';
        tspObj.CMI_TSP_Name__c = 'Geotab';
        tspObj.CMI_Account_Name__c = acc2.id;
        insert tspObj;
        
        /*List<CMI_TSP__c> tsp;
        List<Account> accUpdate=[Select id,name,CMI_Account_Status__c,CMI_CDA_Status__c from Account 
                                 where CMI_CId__c=:Cid and 
                                 (Recordtypeid=:Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId() or Recordtypeid=:Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId()) LIMIT 1];
        System.debug('Accounts with the given sk is '+accUpdate);
        //Getting TSP deatils for Update
        if(!accUpdate.isEmpty()){
            tsp=[SELECT id,CMI_Account_Name__c,CMI_Telematics_ID__c,CMI_TSP_Id__c,CMI_TSP_Name__c FROM CMI_TSP__c WHERE CMI_Account_Name__c =:accUpdate[0].id];
            System.debug('Printing the datails of TSP to be Updated'+tsp);
            //check for email is registered as any other Primary contact while create only.
        } */   
    
        IAM_DA_Portal_TSP_Name__mdt tspData = [Select DeveloperName, IAM_CDA_Status__c, IAM_Contact_Status__c, IAM_App_Status__c,
                                                      IAM_Indemnified__c, IAM_Moratorium__c, IAM_User_Feature_Access_Status__c
                                                      FROM IAM_DA_Portal_TSP_Name__mdt WHERE masterLabel =: 'Navistar'];
        system.debug('tspData in test--->'+tspData);
      App_Mapping__c appMap = new App_Mapping__c();
        appMap.Name = 'Connected Solutions';
        appMap.IAM_Default_Role__c = 'PrimaryContact';
        appMap.IAM_App_Protected_By__c = 'SAML';
        insert appMap;
        
   /*DA_Portal_TSP_Name__mdt testDAPortalmtdata = new DA_Portal_TSP_Name__mdt();
        testDAPortalmtdata.MasterLabel = 'Geotab';
        testDAPortalmtdata.DeveloperName = 'Geotab';
        testDAPortalmtdata.CDA_Status__c = 'No CDA Required';
        insert testDAPortalmtdata;*/
        
   //DA_Portal_TSP_Name__mdt testDAPortalmtdata = (DA_Portal_TSP_Name__mdt)Json.deserialize('[{"MasterLabel": "Geotab","DeveloperName": "Geotab","CDA_Status__c" : "No CDA Required","Indemnified__c" : "True","Moratorium__c" : "Yes","IAM_App_Status__c" : "Pending","User_Feature_Access_Status__c" : "Pending"}]', DA_Portal_TSP_Name__mdt.class); 
     //String dnValue = IAM_Utility.getDNValue('a766227Navistar@noemail.com', false, false);
        
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();         
   req.requestURI = '/services/apexrest/Customer/';  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;
   CMI_APIAccountCreation.CustomerPayloadInfo payload = new CMI_APIAccountCreation.CustomerPayloadInfo();
    payload.AccountName= 'Test234';
    payload.CountryName= 'United States';
    payload.AddressLine1= 'kent street,coloumbus,indiana,47201';
    payload.AddressLine2= 'baker street,coloumbus,indiana,47201';
    payload.AddressLine3= 'clark street,coloumbus,indiana,47201';
    payload.City= 'coloumbus';
    payload.StateName= 'Indiana';
    payload.Zipcode= '47201';
    payload.ContactfirstName= 'ken1';
    payload.ContactlastName= 'Robert';
    payload.ContactphoneNo= '1234567';
    //payload.Contactemail='a766227Navistar@noemail.com';
    payload.Contactemail='test@testabg.com';
    payload.CumminsSupportFirstName= 'jim';
    payload.CumminsSupportLastName= 'michael';
    List<String> lstString= new List<String>{'test@test56.com','test@test53.com'};
    payload.CumminsSupportEmail= lstString;
    //payload.TelematicsServiceProvider = 'Geotab';  
    payload.Tspname= 'Geotab';//'Geotab';
    payload.Tspid= '12345';
    payload.UrgentFaultNotification= 'OnCommand';
    payload.OtherFaultNotification= 'OnCommand'; 
    payload.UrgentFaultNotificationEmail= lstString;
    payload.EmailFlag= true;
    payload.ServiceNow= '4 hours';
    payload.StopNow= '4 hours';
    payload.ServiceSoon= '4 hours';
    payload.CumminsCustomerId= 'a766227';
    payload.CareServiceLevel= 'Basic';
    payload.CustomerEquipmentGroup= ' ';
    payload.language= 'English';
    payload.region= 'US and Canada';
    payload.Tspname= 'Geotab';
    payload.tspCustRef='21321355';
    payload.CId = '';
    payload.UserNotCreated = true;
    payload.PrimaryContactPhone = '';
    payload.PrimaryContactemailaddress = '';
    payload.userId = '12345';
    test.startTest();
    CMI_APIAccountCreation.CMI_ResponseHandler response = CMI_APIAccountCreation.Post(payload);
    
    CMI_APIAccountCreation.cmiError('test');
    CMI_APIAccountCreation.sendmailToAdmin('Name','Name','Name','testgmail@gmail.com','mesg');
    CMI_APIAccountCreation.sendContactemail(acc,conobj);
    //Changes for DA Portal - @Anupam
    String AccountFeatureId = CMI_APIAccountCreation.createAccountFeature(acc2,tspData,payload);
    CMI_APIAccountCreation.createUserFeature(conObj,AccountFeatureId,tspData,acc2.id);
    test.stopTest();
   
   }
   
   
   static testMethod void  TestAPIAccountCreationResponse2(){
   
   Account acc=new Account();
   acc.name='Test';
    acc.CMI_Moratorium__c = 'No';
    acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
   //acc.AccountNumber='1232332';
   //acc.CMI_CDA_Status__c= 'Sent to Customer';
   insert acc;
   
   Account acc1=new Account();
   acc1.name='Test';
   //acc.AccountNumber='1232332';
   acc1.CMI_CDA_Status__c= 'Signed by Customer';
    acc1.CMI_Moratorium__c = 'No';
   insert acc1;
       
    Contact conObj = new Contact();
     conObj.Accountid = acc1.id;
     conObj.firstName='Test';
     conObj.lastName='Test';
       conObj.phone='2323344556677889';
       conObj.email='test@testfinal2.com';
    insert conObj;
     
    
   System.debug('acc1========'+acc1);
   String JsonMsg = JSON.serialize('Test');
     
   Account accobj = [select id,CMI_CId__c,CMI_Moratorium__c  from Account where id=:acc.id ];
       
   System.debug('accobj ========'+accobj ); 
   
   Account accobj1 = [select id,CMI_CId__c,CMI_Moratorium__c  from Account where id=:acc1.id ];
   System.debug('accobj ========'+accobj1 ); 
  // Test.startTest();
  
   //changes for DA Portal enhancement request - @Anupam 
  /* Account acc2=new Account();
   acc2.name='Test DA Portal'; 
    acc2.CMI_Moratorium__c = 'No';
    acc2.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
   //acc.AccountNumber='1232332';
   //acc.CMI_CDA_Status__c= 'Sent to Customer';
   insert acc2;
       
   IAM_DA_Portal_TSP_Name__mdt tspData = [Select DeveloperName, IAM_CDA_Status__c, IAM_Contact_Status__c, IAM_App_Status__c,
                                          IAM_Indemnified__c, IAM_Moratorium__c, IAM_User_Feature_Access_Status__c
                                          FROM IAM_DA_Portal_TSP_Name__mdt WHERE masterLabel =: 'Geotab'];*/
  
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();         
   req.requestURI = '/services/apexrest/Customer/';  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;
   CMI_APIAccountCreation.CustomerPayloadInfo payload = new CMI_APIAccountCreation.CustomerPayloadInfo();
    payload.AccountName= 'Test224';
    payload.CountryName= 'United States';
    payload.AddressLine1= 'test';
    payload.AddressLine2= 'baker street,coloumbus,indiana,47201';
    payload.AddressLine3= 'clark street,coloumbus,indiana,47201';
    payload.City= 'Columbus';
    payload.StateName= 'Indiana';
    payload.Zipcode= '47201';
    payload.ContactfirstName= 'test1';
    payload.ContactlastName= 'DA Portal';
    payload.ContactphoneNo= '1234567';
    payload.Contactemail='test@testno.com';
    payload.CumminsSupportFirstName= 'jim';
    payload.CumminsSupportLastName= 'test';
    List<String> lstString= new List<String>{'test@test56.com','test@test53.com'};
    payload.CumminsSupportEmail= lstString;
    //payload.TelematicsServiceProvider = 'Geotab';
    payload.Tspname= 'Navistar';//'PACCAR Solutions';//'Geotab';
    payload.Tspid= '12345';
    payload.UrgentFaultNotification= 'Not OnCommand';
    payload.OtherFaultNotification= '';
    payload.UrgentFaultNotificationEmail= lstString;
    payload.EmailFlag= true;
    payload.ServiceNow= '4';
    payload.StopNow= '4';
    payload.ServiceSoon= '4';
    payload.CumminsCustomerId= '766227';
    payload.CareServiceLevel= 'Basic';
    payload.CustomerEquipmentGroup= ' ';
    payload.language= 'English';
    payload.region= 'No Region';
    payload.Tspname= 'Navistar';
    payload.tspCustRef='21321364';
    payload.AccountStatus='';
       payload.CDAStatus='';
       payload.comments='';
       payload.dummyEmail=true;
    CMI_APIAccountCreation.CMI_ResponseHandler response = CMI_APIAccountCreation.Post(payload);
    
    CMI_APIAccountCreation.cmiError('test');
    CMI_APIAccountCreation.sendmailToAdmin('Name','Name','Name','testgmail@gmail.com','mesg');
    CMI_APIAccountCreation.sendContactemail(acc,conobj);   
   
   
   }

   static testMethod void  TestAPIAccountCreationResponse3(){
   
    Account acc=new Account();
    acc.name='Test';
     acc.CMI_Moratorium__c = 'No';
     acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
    //acc.AccountNumber='1232332';
    //acc.CMI_CDA_Status__c= 'Sent to Customer';
    insert acc;
    
    Account acc1=new Account();
    acc1.name='Test';
    //acc.AccountNumber='1232332';
    acc1.CMI_CDA_Status__c= 'Signed by Customer';
     acc1.CMI_Moratorium__c = 'No';
    insert acc1;
        
     Contact conObj = new Contact();
      conObj.Accountid = acc1.id;
      conObj.firstName='Test';
      conObj.lastName='Test';
        conObj.phone='2323344556677889';
        conObj.email='test@test.com';
     insert conObj;
      
     
    System.debug('acc1========'+acc1);
    String JsonMsg = JSON.serialize('Test');
      
    Account accobj = [select id,CMI_CId__c,CMI_Moratorium__c  from Account where id=:acc.id ];
        
    System.debug('accobj ========'+accobj ); 
    
    Account accobj1 = [select id,CMI_CId__c,CMI_Moratorium__c  from Account where id=:acc1.id ];
    System.debug('accobj ========'+accobj1 ); 
   // Test.startTest();
    
   
    RestRequest req = new RestRequest(); 
    RestResponse res = new RestResponse();         
    req.requestURI = '/services/apexrest/Customer/';  //Request URL
    req.httpMethod = 'POST';
    req.requestBody = Blob.valueof(JsonMsg);
    RestContext.request = req;
    RestContext.response= res;
    CMI_APIAccountCreation.CustomerPayloadInfo payload = new CMI_APIAccountCreation.CustomerPayloadInfo();
     payload.AccountName= 'Test12345678901234567890123456789012345678901234567890';
     payload.CountryName= 'TestCon';
     payload.AddressLine1= '';
     payload.AddressLine2= 'baker street,coloumbus,indiana,47201';
     payload.AddressLine3= 'clark street,coloumbus,indiana,47201';
     payload.City= 'Test1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
     payload.StateName= 'TestState';
     payload.Zipcode= 'Test1234567890123456789012345678901234567890';
     payload.ContactfirstName= 'Test1234567890Test1234567890Test1234567890Test1234567890';
     payload.ContactlastName= 'Test123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890';
     payload.ContactphoneNo= '123456789012345678901234567890123456789012345678901234567890';
     payload.Contactemail='Test1234567890Test12345678901234567890123456789012345678901234567890@1234567890123456789012345678901234567890';
     payload.CumminsSupportFirstName= 'Test123456789012345678901234567890';
     payload.CumminsSupportLastName= 'Test123456789012345678901234567890';
     List<String> lstString= new List<String>{'test@test56.com','test@test53.com'};
     payload.CumminsSupportEmail= lstString;
     //payload.TelematicsServiceProvider = 'Geotab';
     payload.Tspname= 'Navistar';//'Geotab';
     payload.Tspid= '12345';
     payload.UrgentFaultNotification= 'Not OnCommand';
     payload.OtherFaultNotification= '';
     payload.UrgentFaultNotificationEmail= lstString;
     payload.EmailFlag= true;
     payload.ServiceNow= '4';
     payload.StopNow= '4';
     payload.ServiceSoon= '4';
     payload.CumminsCustomerId= '123456789012345678901234567890';
     payload.CareServiceLevel= '';
     payload.CustomerEquipmentGroup= '';
     payload.language= 'English';
     payload.region= 'No Region';
     payload.Tspname= 'Navistar';
     payload.tspCustRef='';
     CMI_APIAccountCreation.CMI_ResponseHandler response = CMI_APIAccountCreation.Post(payload);
     
     CMI_APIAccountCreation.cmiError('test');
     CMI_APIAccountCreation.sendmailToAdmin('Name','Name','Name','testgmail@gmail.com','mesg');
     CMI_APIAccountCreation.sendContactemail(acc,conobj);   
    
    
    }
    
    static testMethod void  TestAPIAccountCreationResponse4(){
   
   Account acc=new Account();
   acc.name='Test';
    acc.CMI_Moratorium__c = 'No';
    acc.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('PC_API').getRecordTypeId();
   //acc.AccountNumber='1232332';
   //acc.CMI_CDA_Status__c= 'Sent to Customer';
   insert acc;
   
   Account acc1=new Account();
   acc1.name='Test7';
   //acc.AccountNumber='1232332';
   acc1.CMI_CDA_Status__c= 'Signed by Customer';
    acc1.CMI_Moratorium__c = 'No';
   insert acc1;
       
    Contact conObj = new Contact();
     conObj.Accountid = acc1.id;
     conObj.firstName='Test';
     conObj.lastName='Test';
       conObj.phone='2323344556677889';
       conObj.email='Test@testfinal2.com';
       conObj.Username__c='a766227Navistar@noemail.com.iamosmdev';
    insert conObj;
        String sConId = conObj.Id;

        
   System.debug('acc1========'+acc1);
   String JsonMsg = JSON.serialize('Test');
        String sStatus = 'Active';
        String sCid = 'I934605';
        String Cid = '546354';
     
   Account accobj = [select id,CMI_CId__c,CMI_Moratorium__c  from Account where id=:acc.id ];
       
   System.debug('accobj ========'+accobj ); 
   
   Account accobj1 = [select id,CMI_CId__c,CMI_Moratorium__c  from Account where id=:acc1.id ];
   System.debug('accobj ========'+accobj1 ); 
  // Test.startTest();
   
   //changes for DA Portal enhancement request - @Anupam 
   Account acc2=new Account();
        acc2.name='Test234'; 
        acc2.CMI_Moratorium__c = 'No';
        acc2.recordtypeid=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        //acc.AccountNumber='1232332';
        //acc2.CMI_CDA_Status__c= 'Sent to Customer';
        acc2.CMI_CId__c = '546354';
            insert acc2;
        String sAccId = acc2.Id;
        //String Cid = acc2.CMI_CId__c; 
        
        CMI_TSP__c tspObj = new CMI_TSP__c();                
        tspObj.CMI_TSP_ID__c = '21321312';
        tspObj.CMI_Telematics_ID__c ='12345';
        tspObj.CMI_TSP_Name__c = 'Geotab';
        tspObj.CMI_Account_Name__c = acc2.id;
        insert tspObj;
        
    
        IAM_DA_Portal_TSP_Name__mdt tspData = [Select DeveloperName, IAM_CDA_Status__c, IAM_Contact_Status__c, IAM_App_Status__c,
                                                      IAM_Indemnified__c, IAM_Moratorium__c, IAM_User_Feature_Access_Status__c
                                                      FROM IAM_DA_Portal_TSP_Name__mdt WHERE masterLabel =: 'Navistar'];
        system.debug('tspData in test--->'+tspData);
      App_Mapping__c appMap = new App_Mapping__c();
        appMap.Name = 'Connected Solutions';
        appMap.IAM_Default_Role__c = 'PrimaryContact';
        appMap.IAM_App_Protected_By__c = 'SAML';
        insert appMap;
        
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();         
   req.requestURI = '/services/apexrest/Customer/';  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;
   CMI_APIAccountCreation.CustomerPayloadInfo payload = new CMI_APIAccountCreation.CustomerPayloadInfo();
    payload.AccountName= 'Test234';
    payload.CountryName= 'United States';
    payload.AddressLine1= 'kent street,coloumbus,indiana,47201';
    payload.AddressLine2= 'baker street,coloumbus,indiana,47201';
    payload.AddressLine3= 'clark street,coloumbus,indiana,47201';
    payload.City= 'coloumbus';
    payload.StateName= 'Indiana';
    payload.Zipcode= '47201';
    payload.ContactfirstName= 'ken1';
    payload.ContactlastName= 'Robert';
    payload.ContactphoneNo= '1234567';
    payload.Contactemail='a766227Navistar@noemail.com';
    //payload.Contactemail='test@testabg.com';
    payload.CumminsSupportFirstName= 'jim';
    payload.CumminsSupportLastName= 'michael';
    List<String> lstString= new List<String>{'test@test56.com','test@test53.com'};
    payload.CumminsSupportEmail= lstString;
    //payload.TelematicsServiceProvider = 'Geotab';  
    payload.Tspname= 'Navistar';//'Geotab';
    payload.Tspid= '12345';
    payload.UrgentFaultNotification= 'OnCommand';
    payload.OtherFaultNotification= 'OnCommand'; 
    payload.UrgentFaultNotificationEmail= lstString;
    payload.EmailFlag= true;
    payload.ServiceNow= '4 hours';
    payload.StopNow= '4 hours';
    payload.ServiceSoon= '4 hours';
    payload.CumminsCustomerId= 'a766227';
    payload.CareServiceLevel= 'Basic';
    payload.CustomerEquipmentGroup= ' ';
    payload.language= 'English';
    payload.region= 'US and Canada';
    payload.Tspname= 'Navistar';
    payload.tspCustRef='11421355';
    payload.CId = '';
    payload.UserNotCreated = true;
    payload.PrimaryContactPhone = '';
    payload.PrimaryContactemailaddress = '';
    payload.userId = '12345';
    test.startTest();
    CMI_APIAccountCreation.CMI_ResponseHandler response = CMI_APIAccountCreation.Post(payload);
    
    CMI_APIAccountCreation.cmiError('test');
    CMI_APIAccountCreation.sendmailToAdmin('Name','Name','Name','testgmail@gmail.com','mesg');
    CMI_APIAccountCreation.sendContactemail(acc,conobj);
    //Changes for DA Portal - @Anupam
    //String AccountFeatureId = CMI_APIAccountCreation.createAccountFeature(acc2,tspData,payload);
    //CMI_APIAccountCreation.createUserFeature(conObj,AccountFeatureId,tspData,acc2.id);
    test.stopTest();
   
   }
   
 }