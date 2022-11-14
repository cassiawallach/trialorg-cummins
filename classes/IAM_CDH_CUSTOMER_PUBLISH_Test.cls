/*********************************************************************************

Author       :   Sushma Rajput
Created Date :   1st July,2019
Description  :   Unit test class for  IAM_CDH_CUSTOMER_PUBLISH.

*********************************************************************************/

@isTest
public class IAM_CDH_CUSTOMER_PUBLISH_Test{
public static void createTestData(){
        Account accRecord = new Account();
        accRecord.Name = 'Send LDAP Test Company';
        accRecord.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM Global').getRecordTypeId();  
        accRecord.phone = '6884382997';   
        accRecord.BillingStreet = 'Test Street';
        accRecord.BillingCountry = 'United States';
        accRecord.BillingCity = 'NewYork';
        accRecord.BillingState = 'Florida';
        accRecord.BillingPostalCode = '99999';
        accRecord.IAM_Service_Provider_Code__c ='CusCode';                              
        insert accRecord ;
        
        
         IAM_CDH_Cross_References__c crossReff = new IAM_CDH_Cross_References__c();
          crossReff.IAM_Account__c = accRecord.id;
          crossReff.IAM_Customer_ID__c = 'test';
          crossReff.IAM_Party_Site_ID__c = 'test';
          crossReff.IAM_Source_System__c = 'test';
          insert crossReff;
   
        //Contact
        List<Contact> listConNew = new List<Contact>();
        Contact conNew = new Contact();
        Contact conNew1 = new Contact();
        conNew.accountID = accRecord.id;        
        conNew.Email= 'sendLdap@test.com'; 
        conNew.FirstName = 'Send';
        conNew.LastName = 'Send LDAP';  
        conNew.IAM_Cummins_login_ID__c =  'sendLdap@test.com'; 
        listConNew.add(conNew);
        
        conNew1.accountID = accRecord.id;        
        conNew1.Email= 'sendLdap2@test.com'; 
        conNew1.FirstName = 'Send';
        conNew1.LastName = 'Send LDAP test';  
        conNew1.IAM_Cummins_login_ID__c =  'sendLdap2@test.com';
        listConNew.add(conNew1);        
        insert listConNew;
        
         List<profile> pf = [select Id,Name from Profile WHERE Name = 'IAM_FleetguardUser' limit 1];
        
         User newUser = new User();
     
                    newUser.FirstName = 'xUserFirstName';
                    newUser.LastName = 'xtest';
                    newUser.Email = 'test@test.com';   
                    newUser.CompanyName = 'IT Test Company';        
                    newUser.CommunityNickname = 'xtest';
                    newUser.Username = 'Sandeep@test.com' ;
                    newUser.Alias = 'test';
                    newUser.TimeZoneSidKey = 'GMT';
                    newUser.LocaleSidKey= 'en_US';
                    newUser.EmailEncodingKey = 'UTF-8';
                    newUser.LanguageLocaleKey = 'en_US';         
                    newUser.ProfileId = pf[0].Id ;                                  
                    newUser.ContactId =listConNew[0].Id;                   
                    newUser.isActive = TRUE;
                    newUser.Street = '123 Test St';
                    newUser.FederationIdentifier = '2468741';
                    
        insert newUser;

        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Marketplace';
        app.IAM_Role__c = 'CSS_DN_ADMIN';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = accRecord.id;
        app.IAM_Subscription_Name__c = 'test';
        insert app;
          
        
        //IAM Contact Provisioning
                
     /*   IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        //conApp.IAM_Application_Name__c='Cummins Service Training';
        conApp.IAM_Role__c = 'Supervisor';      
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = listConNew[0].id; 
        conApp.IAM_User__c = newUser.Id;        
        conApp.IAM_Account_Application__c = app.id;       
        insert conApp;
     
     IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
       //conApp.IAM_Application_Name__c = 'Marketplace';
        conApp1.IAM_Role__c = 'Supervisor';      
        conApp1.IAM_Status__c = 'Inactive';
        conApp1.IAM_Contact__c = listConNew[1].id; 
        conApp1.IAM_User__c = newUser.Id;       
        conApp1.IAM_Account_Application__c = app.id;
        insert conApp1;
        
        */
        
    CSS_Integration_Details__c csID = new CSS_Integration_Details__c();
        csID.NAme='IAM_GL_oAuth';
        csID.ApplicationName__c ='IAM_GL_oAuth'; //Application Name
        csID.End_Point__c = 'https://guidanzu-dev.cummins.com/ServiceTraining/public/WS/sfim/update_service_training_user_status.php';
        csId.IsActive__c = true;
        csID.Key__c='jb6sFHd/KsMjdprFnsnLjPgCf+19v/kh49PHL/bjYO7DmigbFZdIaXN7gVS0/fg06Fx9fPolnF3guPkOncLwHA==';
        csID.Passcode__c = 'lhBxWDMxDkfiIXb2hsMD/sC0HJUv4CRi4HlvvXUtopNctqUHq07R8MVrFKNqGJELb2meudGeoTKfD7yjHDdUJA==';
        csId.Username__c = 'SHnBSQhHEqF+DQgb+tSI6K6+EqIKGt/1yWj/4tG4KG4=';
        csId.Logging__c ='LADAPUtil';
        csId.AuthEnv__c = 'OAGoAuth';
        csId.Method_Type__c = 'POST';
        csId.grant_type__c = 'client_credentials';
       insert csID;
       
       
       }
  static testMethod void myUnitTest() {
  createTestData();
       
       Contact con = [SELECT Id,IAM_Cummins_login_ID__c,CMI_User_Id__c,IAM_Ext_Legacy_Uid__c,Email FROM Contact WHERE IAM_Cummins_login_ID__c = 'sendLdap@test.com']; 
       User u=[Select id,Name FROM User WHERE Contactid =: con.Id];
      
       Set<Id> contactIds = new SEt<Id>();
       contactIds.add(con.Id);
       
       Account CumminsAcnt=[select id,Name ,Type from Account limit 1];
       CSS_Integration_Details__c csVal = [select NAme,ApplicationName__c ,End_Point__c ,Key__c,Username__c ,Logging__c From CSS_Integration_Details__c limit 1]; 
        
       Test.setMock(HttpCalloutMock.class, new IAM_LDAP_Util_ApexCallout_Mock());
       
      IAM_CDH_CUSTOMER_PUBLISH.cmiError('Success');
      
       /*  RestRequest req = new RestRequest(); 
         RestResponse res = new RestResponse();

         req.addHeader('httpMethod', 'POST');
         req.requestUri = '/services/apexrest/sfdcCallingContact/';       
         
         String postData = 'Your actual request which covers both scenario in JSON format';
         String JsonMsg=JSON.serialize(postData);
         req.requestBody = Blob.valueof(JsonMsg);
         RestContext.request = req; 
         RestContext.response= res; */
         Test.startTest();
        
        IAM_CDH_CUSTOMER_PUBLISH.ListOfCrossRef lc =new IAM_CDH_CUSTOMER_PUBLISH.ListOfCrossRef();
        IAM_CDH_CUSTOMER_PUBLISH.CrossRef cr =new IAM_CDH_CUSTOMER_PUBLISH.CrossRef();
      cr.Attribute3='IAM';
      cr.Attribute1='CusCode';
        IAM_CDH_CUSTOMER_PUBLISH.CrossRef[] crl= new IAM_CDH_CUSTOMER_PUBLISH.CrossRef[]{cr};
        lc.CrossRef=crl;
        
        IAM_CDH_CUSTOMER_PUBLISH.ListOfAddresses lca =new IAM_CDH_CUSTOMER_PUBLISH.ListOfAddresses();
        IAM_CDH_CUSTOMER_PUBLISH.Address ad =new IAM_CDH_CUSTOMER_PUBLISH.Address();
        IAM_CDH_CUSTOMER_PUBLISH.Address[] adl =new IAM_CDH_CUSTOMER_PUBLISH.Address[]{ad};
        lca.Address=adl;

         IAM_CDH_CUSTOMER_PUBLISH.Customer c = new IAM_CDH_CUSTOMER_PUBLISH.Customer();
         IAM_CDH_CUSTOMER_PUBLISH.ListOfCustomers cus=new IAM_CDH_CUSTOMER_PUBLISH.ListOfCustomers();
         IAM_CDH_CUSTOMER_PUBLISH.DataArea da = new IAM_CDH_CUSTOMER_PUBLISH.DataArea();
         
        c.CDHCreationDate ='Test';  
        c.CustomerSystemCode = 'Test';   
        c.DomesticUltimateDUNSNumber = 'Test';   
        c.EnterpriseCustomerNumber = 'Test'; 
        c.SPCode = 'Test';   
        c.RowID = 'Test';  
        c.ListOfAddresses=lca;
        c.ListOfCrossRef=lc;
        IAM_CDH_CUSTOMER_PUBLISH.Customer[] cc =new IAM_CDH_CUSTOMER_PUBLISH.Customer[]{c};
        cus.Customer=cc;
        da.ListOfCustomers=cus;
        
                
        //cus.Customer[] cc=cus.Customer[da];
        IAM_CDH_CUSTOMER_PUBLISH.Post(da);
         Test.stopTest();
   }

}