/************************************************************
Name:  IAM_Utility_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is handler class of IAM_Utility_Test .                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -    Karthik Raj Golakaram          23/04/2020        INITIAL DEVELOPMENT 
1.2 -    Karthik Raj Golakaram          10/23/2020     Changes to TEC Locations for CST
1.3 -    Karthik Raj Golakaram          01/25/2021     Changes for OSM Prod defect - INC1022619
1.3 -    Karthik Raj Golakaram          03/25/2021     Changes for OSM Bulk user provisioning
1.4 -    Shubhangi Sardar               09/06/2021      LDAP Changes
1.5      Shubhangi Sardar               09/23/2021     Assign Subscription Count From Label
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest(SeeAllData=True)
Public class IAM_Utility_Test{

    static testMethod void Method1(){
    
    
    App_Mapping__c app=IAM_Utility.getAppMapping('Connected Solutions');
    
    Account acc= new Account();
    
     acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = 'new1123';
        insert acc;
        
   Set<id> conids= new Set<id>();
    
     Contact con = new contact();
        con.AccountId = acc.Id;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = '34343fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        insert con;
    conids.add(con.id);
    
    Map<Id,String> mapAPP = new Map<Id,String>();
     List<Id> lstApp = new List<Id>();
        IAM_Application__c apps = new IAM_Application__c();
        apps.IAM_Application_Name__c = 'Guidanz';
        apps.IAM_Role__c = 'Advanced';
        apps.IAM_Status__c = 'Active';
        apps.IAM_Account_Name__c = acc.id;
        apps.IAM_Subscription_Name__c = 'test';
        //app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        insert apps;
        lstApp.add(apps.Id);
        mapAPP.put(apps.Id,'test');
         List<IAM_Contact_Provisioning__c> lstconApp = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
        conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Repair logistics and Service').getRecordTypeId();
        conApp.IAM_Role__c = 'RLS Admin';
                
        conApp.IAM_Status__c = 'Active';
        conApp.IAM_Contact__c = con.id; 
        conApp.IAM_Account_Application__c = apps.id;    
        insert conApp;
    
    IAM_Utility.updateAppIdOnContact(conids);
    IAM_Utility.updateContacts(conids);
    IAM_Utility.callLDAPUtilConUpdate(lstApp);
    IAM_Utility.groupLDAPCall(mapAPP,'Insert');
    IAM_Contact_Provisioning__c conAppDn = [SELECT IAM_Contact__r.IAM_Contact_Status__c, IAM_Contact__r.IAM_Internal__c,
    IAM_Contact__r.IAM_Legacy_User__c FROM IAM_Contact_Provisioning__c WHERE Id = :conApp.Id];
    IAM_Utility.getUserType(conAppDn);
    String branchName = IAM_Utility.getBranchName('uid=test123,ou=external,ou=people,dc=cummins,dc=com');
        IAM_Utility.getTriggerSwitch('Contact');
}

static testMethod void Method2(){
    
    
    App_Mapping__c app=IAM_Utility.getAppMapping('Connected Solutions');
    
    Account acc= new Account();
    
     acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'SAINT JOHN';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E2J 2S8';
        acc.BillingState='New Brunswick';        

        acc.CSS_DistributorCode__c='56330';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = 'new1123';
        insert acc;
        
   Set<id> conids= new Set<id>();
    
    Contact con = new contact();
        con.AccountId = acc.Id;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = '34343fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Legacy_USer__c=True;
        con.IAM_Contact_Status__c = 'Active';
        insert con;
        
        Contact con1= new Contact();
        con1.AccountId = acc.Id;
        con1.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        con1.FirstName = 'Fname';
        con1.LastName = 'Lname';
        con1.Email = 'fnamelnamereclaim@test.com';
        con1.Username__c = '34343fnamelnamereclaim@test.com';
        con1.phone = '1112223335';
        con1.IAM_Contact_Status__c = 'Active';
        insert con1;
        
        Profile p = [SELECT Id FROM Profile WHERE Name='IAM User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id,contactid=con1.id,isActive=True, 
            TimeZoneSidKey='America/Los_Angeles', UserName='34343fnamelnamereclaim@test.com',FederationIdentifier='34343fnamelname@test.com');
        insert u;
        System.debug('Printing User details u'+u);
    conids.add(con.id);
    conids.add(con1.id);//added by vineet
 
    System.debug('PRinintng contact id 1==='+con.id+' AND Contact id 2==='+con1.id);
    Map<id,id> idMap= new Map<id,id>{con1.id=>con.id};
    System.debug('Printing the value of map'+idMap);
    Set<id> accIds = new Set<id>();
    accIds.add(acc.id);
    IAM_Utility.updateUserAttribute(conids);
    IAM_Utility.CreateCSTSubscription(accIds);
    IAM_Utility.copyContacts(idMap);
    new IAM_Utility(new Map<Id, Id>());
    }   
}