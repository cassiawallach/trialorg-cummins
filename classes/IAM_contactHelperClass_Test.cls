/************************************************************************
Purpose:                                                            
below IAM_contactHelperClass_Test class is mainly used for contact and user record updates depending upon actions performed                     
=============================================================
History                                                            
-------                                                            
VERSION     AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakram         16/04/2020       INITIAL DEVELOPMENT       
1.1 -    Chetan	Gaikwad        	  06/01/2020       Code fix - Profile update for Marketplace application
1.2 -    Karthik Golakaram        01/25/2021       Profile Correction for Market place - INC1022619
1.3 -    Shubhangi Sardar         09/08/2021      Added EVL Guidanz Permission Set Changes
1.4 -    Sandeep Vuyyuru          16/09/2021       Added for DA enhancement
1.5 -    Suresh Rathod Nanavath   03/03/2022       Added to push for deployment
1.6 -    SureshRathod Nanavath     03/16/2022        Added comment to push to prod
1.7 -    Kamini KM                 05/08/2022       Added changes to push to prod 
***********************************************************************************/
@isTest
public class IAM_contactHelperClass_Test {
  
  static testMethod void testMethod1() {
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    acc.IAM_Service_Provider_Code__c = '123';
    acc.Type = 'Distributor Account';
    acc.CSS_DistributorCode__c = '1234';
    acc.CSS_DBCode__c = '12345';
    acc.CSS_DealerCode__c = '456';
    insert acc;
    
    List<Contact> lstcon = new list<contact>();
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.firstName = 'firstContact';
    con.Email = 'testContact@test.com';
    con.IAM_Contact_Status__c = 'Active';
    con.phone = '8989898989';
    con.IAM_Applications__c = 'abcd';
    con.IAM_Qsolexpiration__c = 'testABC';
    con.IAM_swregexpire__c ='testCon';
    con.IAM_Qsolview__c = 'testCon';
    con.IAM_Final_Approver__c = 'Y';
    Con.Username__c = 'test_user_helper@eidm.com';
    insert con;
    List<Id> lstIds = new List<Id>();
    Set<Id> setIds = new Set<Id>();
    lstIds.add(con.id);
    setIds.add(con.id);
    List<Contact> lstCont = new List<Contact> ();
    lstCont.add(con);
    User us1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'lastIDMdev',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamamaunique1.com.csouat',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US',ContactId=con.id);  
    
    List<User> lstUser = new List<User>();
     lstUser.add(us1);
     //insert lstUser;  
     Map<id,String> oldWWIDS = new Map<id,String> ();
     oldWWIDS.put(con.id, 'test');
     IAM_Application__c app1 = new IAM_Application__c();
     app1.IAM_Application_Name__c = 'Guidanz';
     app1.IAM_Role__c = 'Advanced';
     app1.IAM_Status__c = 'Active';
     app1.IAM_Account_Name__c = acc.id;
     app1.IAM_Subscription_Name__c = 'test';
     app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
     insert app1;
       
     IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
     conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
     conApp1.IAM_Role__c = 'Advanced';
     conApp1.IAM_Status__c = 'Inactive';
        conApp1.Location_Change__c = true;
     conApp1.IAM_Reject_Reason__c = 'No Longer at Location';
     conApp1.IAM_Contact__c = con.id; 
     conApp1.IAM_Account_Application__c = app1.id;
     conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
     insert conApp1;
    Test.startTest(); 
      con.lastname = 'TestContactUpdate';
      update con;
      IAM_contactHelperClass.AccountChange(setIds);
      IAM_contactHelperClass.updateUserdetails(setIds,false,oldWWIDS);
      IAM_contactHelperClass.updateUserdetails(setIds,true,oldWWIDS);
      IAM_contactHelperClass.updateAppContactProStatus(lstCont);
      IAM_contactHelperClass.updateContact_User(lstCont);
      IAM_contactHelperClass.AccountEDQGLUpdate(setIds);
      IAM_contactHelperClass.AccountGLUpdate(setIds);
      IAM_contactHelperClass.getRecordtypeId('IAM','Contact');
      IAM_contactHelperClass.ChangeUserProfile(setIds);
      IAM_contactHelperClass.getContactForUser(setIds);
      
   Test.stopTest();
   
   }
   
   
   static testMethod void testMethod2() {
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    acc.IAM_Service_Provider_Code__c = '123';
    acc.Type = 'Distributor Branch Account';
    acc.CSS_DistributorCode__c = '1234';
    acc.CSS_DBCode__c = '12345';
    acc.CSS_DealerCode__c = '456';
    insert acc;
    
    List<Contact> lstcon = new list<contact>();
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.firstName = 'fi';
    con.Email = 'testContact@test.com';
    con.IAM_Contact_Status__c = 'Active';
    con.phone = '8989898989';
    con.IAM_Applications__c = 'abcd';
    con.IAM_Qsolexpiration__c = 'testABC';
    con.IAM_swregexpire__c ='testCon';
    con.IAM_Qsolview__c = 'testCon';
    con.IAM_Final_Approver__c = 'Y';
    Con.Username__c = 'test_user_helper1@eidm.com';
    insert con;
    List<Contact> lstCont = new List<Contact> ();
    lstCont.add(con);
    User us1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'TEST',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamamaunique3.com.csouat',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 isActive = false,
                 LocaleSidKey = 'en_US',ContactId=con.id);  
    
    List<User> lstUser = new List<User>();
     lstUser.add(us1);
     //insert lstUser;  
    Test.startTest(); 
      con.lastname = 'ST';
      update con;
      IAM_contactHelperClass.updateContact_User(lstCont);
       
   Test.stopTest();
   
   }
   
   
   static testMethod void testMethod555() {
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    acc.BillingStreet = '323 brown street';
    acc.BillingCity = 'Columbus';
    acc.BillingPostalCode = '47033';
    acc.BillingCountryCode = 'US';
    insert acc;
    Set<Id> setIds = new Set<Id>();
    setIds.add(acc.id);
    List<Contact> lstCon = new List<Contact>();
    Contact con = new contact();
    con.FirstName='Testfirstname';
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.IAM_Contact_Status__c = 'Active';
    Con.Username__c = 'test_user_helper2@eidm.com';
    insert con;
    lstCon.Add(con);
    
    IAM_Application__c app = new IAM_Application__c();
    app.IAM_Application_Name__c = 'Marketplace';
    app.IAM_Role__c = 'OSM Fleet Admin';
    app.IAM_Status__c = 'Active';
    app.IAM_Account_Name__c = acc.id;
    app.IAM_Subscription_Name__c = 'test';
    app.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
    insert app;
    
    List<IAM_Contact_Provisioning__c> lstConApp = new List<IAM_Contact_Provisioning__c>();
    IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
    conApp.IAM_Application_Name__c = app.IAM_Application_Name__c;
    conApp.IAM_Role__c = 'OSM Storefront Admin';
    //conApp.IAM_Start_Date__c = system.now();
    conApp.IAM_Status__c = 'Active';
    conApp.IAM_Contact__c = con.id; 
    conApp.IAM_Account_Application__c = app.id;
    conApp.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Marketplace').getRecordTypeId();
    insert conApp;
    lstConApp.add(conApp);
    Test.startTest();
        IAM_contactHelperClass.updateRejectReason(app.id,'reject comments', 'my comments');
        IAM_contactHelperClass.updateRejectReason(conApp.id,'reject comments', 'my comments');
        IAM_contactHelperClass.updateRejectReason(con.id,'reject comments', 'my comments');
        IAM_contactHelperClass.getConProvRecord(con.id);
        IAM_contactHelperClass.AccountGLUpdate(setIds);
        IAM_contactHelperClass.AccountEDQGLUpdate(setIds);
        IAM_contactHelperClass.updateAppContactProStatus(lstCon);
    Test.stopTest();
   }
   
  static testMethod void testMethod999() {
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    insert acc;
    
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.IAM_Contact_Status__c = 'Pending';
    Con.firstname='TestFirstname';
    Con.Email='test_user_helper4@eidm.com';
    Con.Username__c = 'test_user_helper4@eidm.com';
    Con.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    Con.CMI_Contact_Type__c='Secondary';
    insert con;
    
    User us1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'TEST',
                 Email = 'puser555@amamama.com',
                 Username = 'puser555@amamama.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US',ContactId=con.id);  
    insert us1;
    
    IAM_Application__c app1 = new IAM_Application__c();
    app1.IAM_Application_Name__c = 'Guidanz';
    app1.IAM_Role__c = 'Advanced';
    app1.IAM_Status__c = 'Active';
    app1.IAM_Account_Name__c = acc.id;
    app1.IAM_Subscription_Name__c = 'test';
    app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert app1;
    
        
    IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
    conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
    conApp1.IAM_Role__c = 'Advanced';
    //conApp1.IAM_Start_Date__c = system.now();
    conApp1.IAM_Status__c = 'Active';
    conApp1.IAM_Contact__c = con.id; 
    conApp1.IAM_Account_Application__c = app1.id;
    conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert conApp1;
    Set<Id> setContIds = new Set<Id>();
    setContIds.add(con.id);
    Map<id,String> oldWWIDS = new Map<id,String> ();
    oldWWIDS.put(con.id, 'test');
     User usr1=[select id from user where Contact.id=:con.id];
     set<id> setuserid = new set<id>();
    setuserid.add(usr1.id);
   
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    System.RunAs(usr){
        Test.startTest(); 
             IAM_contactHelperClass.revokeOauthTokens(setuserid);
             IAM_contactHelperClass.updateUserdetails(setContIds,false,oldWWIDS);
             IAM_contactHelperClass.updateUserdetails(setContIds,true,oldWWIDS);
        Test.stopTest();
    }
   }
   
   static testMethod void testMethod1000() {
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    insert acc;
    
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.IAM_Contact_Status__c = 'Pending';
    Con.firstname='TestFirstname';
    Con.Email='test_user_helper4@eidm.com';
    Con.Username__c = 'test_user_helper4@eidm.com';
    Con.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    Con.CMI_Contact_Type__c='Secondary';
    insert con;
    
    User us1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'TEST',
                 Email = 'puser555@amamama.com',
                 Username = 'puser555@amamama.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US',ContactId=con.id);  
    insert us1;
    
    IAM_Application__c app1 = new IAM_Application__c();
    app1.IAM_Application_Name__c = 'Guidanz';
    app1.IAM_Role__c = 'Technician;Advanced';
    app1.IAM_Status__c = 'Active';
    app1.IAM_Account_Name__c = acc.id;
    app1.IAM_Subscription_Name__c = 'test';
    app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert app1;
    
        
    IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
    conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
    conApp1.IAM_Role__c = 'Technician;Advanced';
    //conApp1.IAM_Start_Date__c = system.now();
    conApp1.IAM_Status__c = 'Active';
    conApp1.IAM_Contact__c = con.id; 
    conApp1.IAM_Account_Application__c = app1.id;
    conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert conApp1;
    Set<Id> setContIds = new Set<Id>();
    setContIds.add(con.id);
    Map<id,String> oldWWIDS = new Map<id,String> ();
    oldWWIDS.put(con.id, 'test');
     User usr1=[select id from user where Contact.id=:con.id];
     set<id> setuserid = new set<id>();
    setuserid.add(usr1.id);
   
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    System.RunAs(usr){
        Test.startTest(); 
             IAM_contactHelperClass.revokeOauthTokens(setuserid);
             IAM_contactHelperClass.updateUserdetails(setContIds,false,oldWWIDS);
             IAM_contactHelperClass.updateUserdetails(setContIds,true,oldWWIDS);
        Test.stopTest();
    }
   }
    
   static testMethod void testMethod1001() {
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    insert acc;
    
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.IAM_Contact_Status__c = 'Pending';
    Con.firstname='TestFirstname';
    Con.Email='test_user_helper4@eidm.com';
    Con.Username__c = 'test_user_helper4@eidm.com';
    Con.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    Con.CMI_Contact_Type__c='Secondary';
    insert con;
    
    User us1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'TEST',
                 Email = 'puser555@amamama.com',
                 Username = 'puser555@amamama.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US',ContactId=con.id);  
    insert us1;
    
    IAM_Application__c app1 = new IAM_Application__c();
    app1.IAM_Application_Name__c = 'Guidanz';
    app1.IAM_Role__c = 'Technician';
    app1.IAM_Status__c = 'Active';
    app1.IAM_Account_Name__c = acc.id;
    app1.IAM_Subscription_Name__c = 'test';
    app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert app1;
    
        
    IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
    conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
    conApp1.IAM_Role__c = 'Technician';
    //conApp1.IAM_Start_Date__c = system.now();
    conApp1.IAM_Status__c = 'Active';
    conApp1.IAM_Contact__c = con.id; 
    conApp1.IAM_Account_Application__c = app1.id;
    conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert conApp1;
    Set<Id> setContIds = new Set<Id>();
    setContIds.add(con.id);
    Map<id,String> oldWWIDS = new Map<id,String> ();
    oldWWIDS.put(con.id, 'test');
     User usr1=[select id from user where Contact.id=:con.id];
     set<id> setuserid = new set<id>();
    setuserid.add(usr1.id);
   
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    System.RunAs(usr){
        Test.startTest(); 
             IAM_contactHelperClass.revokeOauthTokens(setuserid);
             IAM_contactHelperClass.updateUserdetails(setContIds,false,oldWWIDS);
             IAM_contactHelperClass.updateUserdetails(setContIds,true,oldWWIDS);
        Test.stopTest();
    }
   }
    /*
     static testMethod void testMethod1002() {
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    insert acc;
    
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.IAM_Contact_Status__c = 'Pending';
    Con.firstname='TestFirstname';
    Con.Email='test_user_helper4@eidm.com';
    Con.Username__c = 'test_user_helper4@eidm.com';
    Con.recordtypeid= Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    Con.CMI_Contact_Type__c='Secondary';
    insert con;
    
    User us1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'TEST',
                 Email = 'puser555@amamama.com',
                 Username = 'puser555@amamama.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US',ContactId=con.id);  
    insert us1;
    
    IAM_Application__c app1 = new IAM_Application__c();
    app1.IAM_Application_Name__c = 'Guidanz';
    app1.IAM_Role__c = 'Read Only';
    app1.IAM_Status__c = 'Active';
    app1.IAM_Account_Name__c = acc.id;
    app1.IAM_Subscription_Name__c = 'test';
    app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert app1;
    
        
    IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
    conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
    conApp1.IAM_Role__c = 'Read Only';
    //conApp1.IAM_Start_Date__c = system.now();
    conApp1.IAM_Status__c = 'Active';
    conApp1.IAM_Contact__c = con.id; 
    conApp1.IAM_Account_Application__c = app1.id;
    conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert conApp1;
    Set<Id> setContIds = new Set<Id>();
    setContIds.add(con.id);
    Map<id,String> oldWWIDS = new Map<id,String> ();
    oldWWIDS.put(con.id, 'test');
     User usr1=[select id from user where Contact.id=:con.id];
     set<id> setuserid = new set<id>();
    setuserid.add(usr1.id);
   
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    System.RunAs(usr){
        Test.startTest(); 
             IAM_contactHelperClass.revokeOauthTokens(setuserid);
             IAM_contactHelperClass.updateUserdetails(setContIds,false,oldWWIDS);
             IAM_contactHelperClass.updateUserdetails(setContIds,true,oldWWIDS);
        Test.stopTest();
    }
   }*/
   static testMethod void testMethod111() {
    
    Account accParent = new Account();
    accParent.Name = 'ParentAcc';
    accParent.Type = 'Distributor Account';
    insert accParent;
    
    Account acc = new Account();
    acc.Name = 'TestAccount';
    acc.IAM_Service_Provider_Code__c = '123';
    acc.Type = 'Dealer Account';
    acc.CSS_DistributorCode__c = '1234';
    acc.CSS_DBCode__c = '12345';
    acc.CSS_DealerCode__c = '456';
    acc.ParentId = accParent.id;
    insert acc;
    
    List<Contact> lstcon = new list<contact>();
    Contact con = new contact();
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    con.firstName = 'f';
    con.Email = 'testContact@test.com';
    con.IAM_Contact_Status__c = 'Active';
    con.phone = '8989898989';
    con.IAM_Applications__c = 'abcd';
    con.IAM_Qsolexpiration__c = 'testABC';
    con.IAM_swregexpire__c ='testCon';
    con.IAM_Qsolview__c = 'testCon';
    con.IAM_Final_Approver__c = 'Y';
    Con.Username__c = 'test_user_helper5@eidm.com';
    insert con;
    
     
    Contact con1 = new contact();
    con1.lastName = 'TestContact';
    con1.AccountId = acc.id;
    con1.firstName = 'f';
    con1.Email = 'testContact@test.com';
    con1.IAM_Contact_Status__c = 'Active';
    con1.phone = '8989898989';
    con1.IAM_Applications__c = 'abcd';
    con1.IAM_Qsolexpiration__c = 'testABC';
    con1.IAM_swregexpire__c ='testCon';
    con1.IAM_Qsolview__c = 'testCon';
    con1.IAM_Final_Approver__c = 'Y';
    Con1.Username__c = 'test_user_helper55@eidm.com';
    insert con1;
    
    User us1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'lastIDMdev',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@ama90.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US',ContactId=con.id); 

     User us2 = new User(
                 ProfileId = System.label.IAM_CSS_Dealer_Advanced_Profile_ID,
                 LastName = 'lastIDMdev',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama23u85.com.csouat',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 LocaleSidKey = 'en_US',ContactId=con1.id);
    
     List<User> lstUser = new List<User>();
     lstUser.add(us1);
     lstUser.add(us2);
     //insert lstUser;  
     
    IAM_Application__c app1 = new IAM_Application__c();
    app1.IAM_Application_Name__c = System.Label.IAM_AppName_guidanzmobile;
    app1.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
    app1.IAM_Status__c = 'Active';
    app1.IAM_Account_Name__c = acc.id;
    app1.IAM_Subscription_Name__c = 'test';
    app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_guidanzmobile).getRecordTypeId();
    insert app1;
    
        
    IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
    conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
    conApp1.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
    //conApp1.IAM_Start_Date__c = system.now();
    conApp1.IAM_Status__c = 'Active';
    conApp1.IAM_Contact__c = con.id; 
    conApp1.IAM_Account_Application__c = app1.id;
    conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_guidanzmobile).getRecordTypeId();
    insert conApp1;
    Set<Id> setContIds = new Set<Id>();
    setContIds.add(con.id);
    Map<id,String> oldWWIDS = new Map<id,String> ();
    oldWWIDS.put(con.id, 'test');
    User usr = [Select id from User where Id = :UserInfo.getUserId()];
    
    
    System.RunAs(usr){
        Test.startTest(); 
          con.lastname = 'T';
          update con;
        
         IAM_contactHelperClass.updateUserdetails(setContIds,false,oldWWIDS);
         IAM_contactHelperClass.updateUserdetails(setContIds,true,oldWWIDS);
         setContIds = new Set<Id>();
         setContIds.add(con1.id);
         IAM_contactHelperClass.updateUserdetails(setContIds,false,oldWWIDS);
         IAM_contactHelperClass.updateUserdetails(setContIds,true,oldWWIDS);
        Test.stopTest();
    }
   
   }
   
   static testMethod void testMethod112() {
    
        Account accParent = new Account();
        accParent.Name = 'ParentAcc';
        accParent.Type = 'Distributor Account';
        insert accParent;
        
        Account accParent1 = new Account();
        accParent1.Name = 'ParentAcc1';
        accParent1.Type = 'Distributor Account';
        insert accParent1;
        
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        acc.ParentId = accParent.id;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1233456';
        acc1.IAM_Service_Provider_Code__c = '33456';
        acc1.Type = 'Dealer Account';
        acc1.CSS_DistributorCode__c = '23423';
        acc1.CSS_DBCode__c = '34521';
        acc1.CSS_DealerCode__c = '34521';
        acc1.ParentId = accParent1.id;
        insert acc1;
        
        List<Contact> lstcon = new list<contact>();
        Contact con = new contact();
        con.lastName = 'Te';
        con.AccountId = acc.id;
        con.firstName = 'fi';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.phone = '8989898989';
        con.IAM_Applications__c = 'abcd';
        con.IAM_Qsolexpiration__c = 'testABC';
        con.IAM_swregexpire__c ='testCon';
        con.IAM_Qsolview__c = 'testCon';
        con.IAM_Final_Approver__c = 'Y';
        Con.Username__c = 'test_user_helper6@eidm.com';
        insert con;
        
        
        Contact con1 = new contact();
        con1.lastName = 'Te';
        con1.AccountId = acc1.id;
        con1.firstName = 'fi';
        Con1.CMI_Contact_Type__c='Secondary';
        con1.Email = 'testContact1@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        con1.phone = '8989898989';
        con1.IAM_Applications__c = 'abcd';
        con1.IAM_Qsolexpiration__c = 'testABC';
        con1.IAM_swregexpire__c ='testCon';
        con1.IAM_Qsolview__c = 'testCon';
        con1.IAM_Final_Approver__c = 'Y';
        Con1.Username__c = 'test_user_helper7@eidm.com';
        insert con1;
        
        User us1 = new User(
                     ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                     LastName = 'lastIDMdev',
                     Email = 'puser000@amamama.com',
                     Username = 'puser000@amamama.com.eidmdev',
                     CompanyName = 'TESTIDMDEV',
                     Title = 'title',
                     Alias = 'alias',
                     TimeZoneSidKey = 'America/Los_Angeles',
                     EmailEncodingKey = 'UTF-8',
                     LanguageLocaleKey = 'en_US',
                     LocaleSidKey = 'en_US',ContactId=con.id);  
                     
                     
        User us2 = new User(
                     ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                     LastName = 'lastIDMdev',
                     Email = 'puser000@amamama.com',
                     Username = 'puser000@amamama1.com.eidmdev',
                     CompanyName = 'TESTIDMDEV',
                     Title = 'title',
                     Alias = 'alias',
                     TimeZoneSidKey = 'America/Los_Angeles',
                     EmailEncodingKey = 'UTF-8',
                     LanguageLocaleKey = 'en_US',
                     LocaleSidKey = 'en_US',ContactId=con1.id);
        
         
       //  insert us2;  
         
        IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        app4.IAM_Role__c = 'Operator';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = acc.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test expire';
        app4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        insert app4;
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        app5.IAM_Role__c = 'Operator';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc1.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test expire';
        app5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        insert app5;
        
        IAM_Contact_Provisioning__c conApp4 = new IAM_Contact_Provisioning__c();
        conApp4.IAM_Application_Name__c = app4.IAM_Application_Name__c;
        conApp4.IAM_Role__c = 'Operator';
        //conApp2.IAM_Start_Date__c = system.now();
        conApp4.IAM_Status__c = 'Active';
        conApp4.IAM_Contact__c = con.id; 
        conApp4.IAM_Account_Application__c = app4.id;
        conApp4.IAM_Qsolexpiration__c = 'test expire';
        conApp4.IAM_DA_Customer_List__c = '123456';
        conApp4.IAM_User_Type__c = 'Internal';
        conApp4.IAM_User__c = us1.id;
        conApp4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        insert conApp4;
        
        IAM_Contact_Provisioning__c conApp5 = new IAM_Contact_Provisioning__c();
        conApp5.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp5.IAM_Role__c = 'Operator';
        conApp5.IAM_Status__c = 'Active';
        conApp5.IAM_Contact__c = con.id; 
        conApp5.IAM_Account_Application__c = app5.id;
        conApp5.IAM_Qsolexpiration__c = 'test expire';
        conApp5.IAM_DA_Customer_List__c = '123456';
        conApp5.IAM_User_Type__c = 'Internal';
       // conApp5.IAM_User__c = us2.id;
        conApp5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        //insert conApp5;
        
        set<Id> setContIds = new Set<Id>();
        setContIds.add(con.id);
        Map<id,String> oldWWIDS = new Map<id,String> ();
        oldWWIDS.put(con.id, 'test');
        List<IAM_Contact_Provisioning__c> lstContPro = new List<IAM_Contact_Provisioning__c>();
        lstContPro.add(conApp4);
        List<User> usr = new List<User>();
        if(Limits.getQueries()<Limits.getLimitQueries()){
        usr = [Select id from User where ContactId = :Con1.id];
        }
        if(!usr.isEmpty()){
            //System.RunAs(usr[0]){
                Test.startTest(); 
                  con.lastname = 'TestContactUpdate';
                  update con;
                  IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                  IAM_contactHelperClass.userAttributeUpdate(false,setContIds,false,oldWWIDS);
                  setContIds = new Set<Id>();
                  setContIds.add(con1.id);
                  IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                  IAM_contactHelperClass.userAttributeUpdate(false,setContIds,false,oldWWIDS);
                 
                Test.stopTest();
            //}
        }
    } 
   
    
    static testMethod void testMethod222() {
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        //acc.ParentId = accParent.id;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1233456';
        acc1.IAM_Service_Provider_Code__c = '33456';
        acc1.Type = 'Dealer Account';
        acc1.CSS_DistributorCode__c = '23423';
        acc1.CSS_DBCode__c = '34521';
        acc1.CSS_DealerCode__c = '34521';
        //acc1.ParentId = accParent1.id;
        insert acc1;
        
        Contact con = new contact();
        con.lastName = 'Te';
        con.AccountId = acc.id;
        con.firstName = 'fi';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.phone = '8989898989';
        con.IAM_Applications__c = 'abcd';
        con.IAM_Qsolexpiration__c = 'testABC';
        con.IAM_swregexpire__c ='testCon';
        con.IAM_Qsolview__c = 'testCon';
        con.IAM_Final_Approver__c = 'Y';
        Con.Username__c = 'test_user_helper67@eidm.com';
        insert con;
        
        User us1 = new User(
                     ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                     LastName = 'lastIDMdev',
                     Email = 'puser000@amamama.com',
                     Username = 'puser000@amamama45.com.eidmdev',
                     CompanyName = 'TESTIDMDEV',
                     Title = 'title',
                     Alias = 'alias',
                     TimeZoneSidKey = 'America/Los_Angeles',
                     EmailEncodingKey = 'UTF-8',
                     LanguageLocaleKey = 'en_US',
                     isActive = true,
                     LocaleSidKey = 'en_US',ContactId=con.id); 
                     
        Contact con1 = new contact();
        con1.lastName = 'Te';
        con1.AccountId = acc1.id;
        con1.firstName = 'fi';
        con1.Email = 'testContact1@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        con1.phone = '8989898989';
        con1.IAM_Applications__c = 'abcd';
        con1.IAM_Qsolexpiration__c = 'testABC';
        con1.IAM_swregexpire__c ='testCon';
        con1.IAM_Qsolview__c = 'testCon';
        con1.IAM_Final_Approver__c = 'Y';
        con1.IAM_Internal__c = true;
        Con1.Username__c = 'test_user_helper78@eidm.com';
        insert con1;            

            User us2 = new User(
                     ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                     LastName = 'lastIDMdev',
                     Email = 'puser000@amamama.com',
                     Username = 'puser000@amamama156.com.eidmdev',
                     CompanyName = 'TESTIDMDEV',
                     Title = 'title',
                     Alias = 'alias',
                     TimeZoneSidKey = 'America/Los_Angeles',
                     EmailEncodingKey = 'UTF-8',
                     LanguageLocaleKey = 'en_US',
                     isActive = true,
                     LocaleSidKey = 'en_US',ContactId=con1.id);
        
         
         //insert us2; 
        
        IAM_Application__c app6 = new IAM_Application__c();
        app6.IAM_Application_Name__c = System.Label.IAM_AppName_guidanzmobile;
        app6.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
        app6.IAM_Status__c = 'Active';
        app6.IAM_Account_Name__c = acc.id;
        app6.IAM_Subscription_Name__c = 'test';
        app6.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_guidanzmobile).getRecordTypeId();
        insert app6;
        
            
        IAM_Contact_Provisioning__c conApp6 = new IAM_Contact_Provisioning__c();
        conApp6.IAM_Application_Name__c = app6.IAM_Application_Name__c;
        conApp6.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
        conApp6.IAM_Status__c = 'Inactive';
        conApp6.IAM_Contact__c = con.id; 
        conApp6.IAM_Account_Application__c = app6.id;
        conApp6.IAM_swregexpire__c = 'test';
        conApp6.IAM_User__c = us2.id;
        conApp6.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_guidanzmobile).getRecordTypeId();
        insert conApp6;
        
        
        
        IAM_Contact_Provisioning__c conApp7 = new IAM_Contact_Provisioning__c();
        conApp7.IAM_Application_Name__c = app6.IAM_Application_Name__c;
        conApp7.IAM_Role__c = 'Guidanz Mobile Campaign Dealer';
        conApp7.IAM_Status__c = 'Inactive';
        conApp7.IAM_Contact__c = con.id; 
        conApp7.IAM_Account_Application__c = app6.id;
        conApp7.IAM_swregexpire__c = 'test';
        conApp7.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_guidanzmobile).getRecordTypeId();
        insert conApp7;
        
        
        //QSOL application
        IAM_Application__c appQSOL = new IAM_Application__c();
        appQSOL.IAM_Application_Name__c = 'QuickServe Online';
        appQSOL.IAM_Role__c = 'QSOL Dealer';
        appQSOL.IAM_Status__c = 'Active';
        appQSOL.IAM_Account_Name__c = acc.id;
        appQSOL.IAM_Subscription_Name__c = 'QuickServe Online EBU';
        appQSOL.IAM_qsolexpiration__c='123455';
        appQSOL.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        insert appQSOL;
        
        IAM_Contact_Provisioning__c conAppQSOL = new IAM_Contact_Provisioning__c();
        conAppQSOl.IAM_Application_Name__c = appQSOL.IAM_Application_Name__c;
        conAppQSOL.IAM_Role__c = 'QSOL Dealer';
        conAppQSOL.IAM_Status__c = 'Inactive';
        conAppQSOL.IAM_Contact__c = con.id; 
        conAppQSOL.IAM_Account_Application__c = appQSOL.id;
        conAppQSOL.IAM_qsolexpiration__c = '123455';
        conAppQSOL.IAM_Subscription_Name__c='QuickServe Online EBU';
        conAppQSOL.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
        insert conAppQSOL;
        

        
        IAM_Application__c app8 = new IAM_Application__c();
        app8.IAM_Application_Name__c = System.Label.IAM_AppName_Cumpas;
        app8.IAM_Role__c = 'Dealer User';
        app8.IAM_Status__c = 'Inactive';
        app8.IAM_Account_Name__c = acc.id;
        app8.IAM_Cumpas_Modularity__c='View Credit';
       
        app8.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_Cumpas).getRecordTypeId();
       // insert app8;
        
        
               
        IAM_Application_Groups__c iamAppGrp = new IAM_Application_Groups__c ();
        iamAppGrp.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        iamAppGrp.IAM_Role_Name__c = 'Operator';
        iamAppGrp.IAM_DN_value__c = 'cn=Operator,ou=Connected Solutions,ou=application,dc=cummins,dc=com';
        iamAppGrp.Name = System.Label.IAM_AppName_ConnectedSolutions;
        iamAppGrp.IAM_Group_Type__c = 'static';
        insert iamAppGrp;
        
        IAM_Application_Groups__c iamAppGrp1 = new IAM_Application_Groups__c ();
        iamAppGrp1.IAM_Application_Name__c = System.Label.IAM_AppName_guidanzmobile;
        iamAppGrp1.IAM_Role_Name__c = 'Guidanz Mobile Campaign Dealer';
        iamAppGrp1.IAM_DN_value__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        iamAppGrp1.Name = System.Label.IAM_AppName_guidanzmobile;
        iamAppGrp1.IAM_Group_Type__c = 'static';
        insert iamAppGrp1;
        
        IAM_Application_Groups__c iamAppGrp2 = new IAM_Application_Groups__c ();
        iamAppGrp2.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Role_Name__c = 'QSOL Dealer';
        iamAppGrp2.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        iamAppGrp2.Name = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Group_Type__c = 'static';
        insert iamAppGrp2;
        
        IAM_Application_Groups__c iamAppGrp3 = new IAM_Application_Groups__c ();
        iamAppGrp3.IAM_Application_Name__c = System.Label.IAM_Cummins_Service_Training;
        iamAppGrp3.IAM_Role_Name__c = 'Service Training User';
        iamAppGrp3.IAM_DN_value__c = 'cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
        iamAppGrp3.Name = System.Label.IAM_Cummins_Service_Training;
        iamAppGrp3.IAM_Group_Type__c = 'static';
        insert iamAppGrp3;
        
        IAM_Application_Groups__c iamAppGrp4 = new IAM_Application_Groups__c ();
        iamAppGrp4.IAM_Application_Name__c = System.Label.IAM_AppName_Cumpas;
        iamAppGrp4.IAM_Role_Name__c = 'Dealer User';
        iamAppGrp4.IAM_DN_value__c = 'cn=DBU_DN_DEALER_USERS,ou=App_DBU_Commerce,ou=application,dc=cummins,dc=com';
        iamAppGrp4.Name = System.Label.IAM_AppName_Cumpas;
        iamAppGrp4.IAM_Group_Type__c = 'static';
        insert iamAppGrp4;
        
        List<IAM_Contact_Provisioning__c> lstContPro = new List<IAM_Contact_Provisioning__c>();
        List<User> usr= new List<User>();
        if(Limits.getQueries()<Limits.getLimitQueries()){
        usr = [Select id from User where Id = :UserInfo.getUserId()];
        }
        if(!usr.isEmpty()){
            System.RunAs(usr[0]){
                Test.startTest(); 
                  
                  IAM_contactHelperClass.updateApplicationContact(lstContPro);
                  lstContPro = new List<IAM_Contact_Provisioning__c>();
                  lstContPro.add(conApp6);
                  IAM_contactHelperClass.updateApplicationContact(lstContPro);
                  lstContPro = new List<IAM_Contact_Provisioning__c>();
                  lstContPro.add(conApp7);
                  IAM_contactHelperClass.updateApplicationContact(lstContPro);
                  lstContPro = new List<IAM_Contact_Provisioning__c>();
                  //lstContPro.add(conApp8);
                  IAM_contactHelperClass.updateApplicationContact(lstContPro);
                  lstContPro = new List<IAM_Contact_Provisioning__c>();
                 // lstContPro.add(conApp9);
                  IAM_contactHelperClass.updateApplicationContact(lstContPro);
                Test.stopTest();
            } 
        } 
   }
   
   static testMethod void testMethod333(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.IAM_Service_Provider_Code__c = '123';
        acc.Type = 'Dealer Account';
        acc.CSS_DistributorCode__c = '1234';
        acc.CSS_DBCode__c = '12345';
        acc.CSS_DealerCode__c = '456';
        //acc.ParentId = accParent.id;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'TestAccount1233456';
        acc1.IAM_Service_Provider_Code__c = '33456';
        acc1.Type = 'Dealer Account';
        acc1.CSS_DistributorCode__c = '23423';
        acc1.CSS_DBCode__c = '34521';
        acc1.CSS_DealerCode__c = '34521';
        //acc1.ParentId = accParent1.id;
        insert acc1;
        
        Contact con = new contact();
        con.lastName = 'Te';
        con.AccountId = acc.id;
        con.firstName = 'fi';
        con.Email = 'testContact@test.com';
        con.IAM_Contact_Status__c = 'Active';
        con.phone = '8989898989';
        con.IAM_Applications__c = 'abcd';
        con.IAM_Qsolexpiration__c = 'testABC';
        con.IAM_swregexpire__c ='testCon';
        con.IAM_Qsolview__c = 'testCon';
        con.IAM_Final_Approver__c = 'Y';
        Con.Username__c = 'test_user_helper67@eidm.com';
        insert con;
        
        Contact con1 = new contact();
        con1.lastName = 'Te';
        con1.AccountId = acc1.id;
        con1.firstName = 'fi';
        con1.Email = 'testContact1@test.com';
        con1.IAM_Contact_Status__c = 'Active';
        con1.phone = '8989898989';
        con1.IAM_Applications__c = 'abcd';
        con1.IAM_Qsolexpiration__c = 'testABC';
        con1.IAM_swregexpire__c ='testCon';
        con1.IAM_Qsolview__c = 'testCon';
        con1.IAM_Final_Approver__c = 'Y';
        con1.IAM_Internal__c = true;
        Con1.Username__c = 'test_user_helper78@eidm.com';
        insert con1;
        
        User us1 = new User(
                     ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                     LastName = 'lastIDMdev',
                     Email = 'puser000@amamama.com',
                     Username = 'puser000@amamama45.com.eidmdev',
                     CompanyName = 'TESTIDMDEV',
                     Title = 'title',
                     Alias = 'alias',
                     TimeZoneSidKey = 'America/Los_Angeles',
                     EmailEncodingKey = 'UTF-8',
                     LanguageLocaleKey = 'en_US',
                     isActive = true,
                     LocaleSidKey = 'en_US',ContactId=con.id);  
                     
                     
        User us2 = new User(
                     ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                     LastName = 'lastIDMdev',
                     Email = 'puser000@amamama.com',
                     Username = 'puser000@amamama156.com.eidmdev',
                     CompanyName = 'TESTIDMDEV',
                     Title = 'title',
                     Alias = 'alias',
                     TimeZoneSidKey = 'America/Los_Angeles',
                     EmailEncodingKey = 'UTF-8',
                     LanguageLocaleKey = 'en_US',
                     isActive = true,
                     LocaleSidKey = 'en_US',ContactId=con1.id);
        
         
         //insert us2;  
         
         IAM_Application__c app4 = new IAM_Application__c();
        app4.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        app4.IAM_Role__c = 'Operator';
        app4.IAM_Status__c = 'Active';
        app4.IAM_Account_Name__c = acc.id;
        app4.IAM_Subscription_Name__c = 'test';
        app4.IAM_Qsolexpiration__c = 'test expire';
        app4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        insert app4;
        
        IAM_Application__c app5 = new IAM_Application__c();
        app5.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        app5.IAM_Role__c = 'QSOL Dealer';
        app5.IAM_Status__c = 'Active';
        app5.IAM_Account_Name__c = acc1.id;
        app5.IAM_Subscription_Name__c = 'test';
        app5.IAM_Qsolexpiration__c = 'test expire';
        app5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        insert app5;
        
        IAM_Contact_Provisioning__c conApp4 = new IAM_Contact_Provisioning__c();
        conApp4.IAM_Application_Name__c = app4.IAM_Application_Name__c;
        conApp4.IAM_Role__c = 'Operator';
        //conApp2.IAM_Start_Date__c = system.now();
        conApp4.IAM_Status__c = 'Active';
        conApp4.IAM_Contact__c = con.id; 
        conApp4.IAM_Account_Application__c = app4.id;
        conApp4.IAM_Qsolexpiration__c = 'test expire';
        conApp4.IAM_DA_Customer_List__c = '123456';
        conApp4.IAM_User_Type__c = 'Internal';
        conApp4.IAM_User__c = us1.id;
        conApp4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        insert conApp4;
        
        IAM_Contact_Provisioning__c conApp5 = new IAM_Contact_Provisioning__c();
        conApp5.IAM_Application_Name__c = app5.IAM_Application_Name__c;
        conApp5.IAM_Role__c = 'QSOL Dealer';
        conApp5.IAM_Status__c = 'Active';
        conApp5.IAM_Contact__c = con1.id; 
        conApp5.IAM_Account_Application__c = app4.id;
        conApp5.IAM_Qsolexpiration__c = 'test expire';
        conApp5.IAM_DA_Customer_List__c = '123456';
        conApp5.IAM_Subscription_Name__c='QuickServe Online EBU';
        conApp5.IAM_User__c = us2.id;
        conApp5.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get(System.Label.IAM_AppName_QSOL).getRecordTypeId();
        insert conApp5;
        
        IAM_Application_Groups__c iamAppGrp = new IAM_Application_Groups__c ();
        iamAppGrp.IAM_Application_Name__c = System.Label.IAM_AppName_ConnectedSolutions;
        iamAppGrp.IAM_Role_Name__c = 'Operator';
        iamAppGrp.IAM_DN_value__c = 'cn=Operator,ou=Connected Solutions,ou=application,dc=cummins,dc=com';
        iamAppGrp.Name = System.Label.IAM_AppName_ConnectedSolutions;
        iamAppGrp.IAM_Group_Type__c = 'static';
        insert iamAppGrp;
        
        IAM_Application_Groups__c iamAppGrp1 = new IAM_Application_Groups__c ();
        iamAppGrp1.IAM_Application_Name__c = System.Label.IAM_AppName_guidanzmobile;
        iamAppGrp1.IAM_Role_Name__c = 'Guidanz Mobile Campaign Dealer';
        iamAppGrp1.IAM_DN_value__c = 'cn=ATLAS_Universal_CAMPAIGN_DEALER,ou=APP_ATLAS_UNIVERSAL,ou=application,dc=cummins,dc=com';
        iamAppGrp1.Name = System.Label.IAM_AppName_guidanzmobile;
        iamAppGrp1.IAM_Group_Type__c = 'static';
        insert iamAppGrp1;
        
        IAM_Application_Groups__c iamAppGrp2 = new IAM_Application_Groups__c ();
        iamAppGrp2.IAM_Application_Name__c = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Role_Name__c = 'QSOL Dealer';
        iamAppGrp2.IAM_DN_value__c = 'cn=QuickServe_Dealers,ou=APP_QuickServe,ou=application,dc=cummins,dc=com';
        iamAppGrp2.Name = System.Label.IAM_AppName_QSOL;
        iamAppGrp2.IAM_Group_Type__c = 'static';
        insert iamAppGrp2;
        
        IAM_Application_Groups__c iamAppGrp3 = new IAM_Application_Groups__c ();
        iamAppGrp3.IAM_Application_Name__c = System.Label.IAM_Cummins_Service_Training;
        iamAppGrp3.IAM_Role_Name__c = 'Service Training User';
        iamAppGrp3.IAM_DN_value__c = 'cn=SERVICE_TRAINING_DN_USERS,ou=APP_SERVICE_TRAINING,ou=application,dc=cummins,dc=com';
        iamAppGrp3.Name = System.Label.IAM_Cummins_Service_Training;
        iamAppGrp3.IAM_Group_Type__c = 'static';
        insert iamAppGrp3;
        
            
        List<IAM_Contact_Provisioning__c> lstContPro = new List<IAM_Contact_Provisioning__c>();
        lstContPro.add(conApp4);
        List<User> usr = new List<User>();
        if(Limits.getQueries()<Limits.getLimitQueries()){
            usr = [Select id from User where Id = :UserInfo.getUserId()];
        }
        if(!usr.isEmpty()){
            System.RunAs(usr[0]){
                Test.startTest(); 
                  IAM_contactHelperClass.updateApplicationContact(lstContPro);
                  lstContPro = new List<IAM_Contact_Provisioning__c>();
                  lstContPro.add(conApp5);
                  IAM_contactHelperClass.updateApplicationContact(lstContPro);
                 
                Test.stopTest();
            } 
        }
        
   }
   
    static testMethod void testMethod444() {
    
    Account acc1 = new Account();
    acc1.Name = 'TestAccount1';
    acc1.type = 'Distributor Account';
    insert acc1;
    
    Account acc2 = new Account();
    acc2.Name = 'TestAccount2';
    acc2.CSS_DistributorCode__c = '12345';
    acc2.CSS_DBCode__c = '12345';
    acc2.type = 'Distributor Branch Account';
    insert acc2;
    
    Account acc4 = new Account();
    acc4.Name = 'TestAccount2';
    acc4.CSS_DistributorCode__c = '12345';
    acc4.CSS_DBCode__c = '12345';
    acc4.type = 'Fleet';
    acc4.parentid = acc1.id;
    acc4.IAM_Movex_Customer_Code__c = '12345';
    insert acc4;
    
    Contact con1 = new contact();
    con1.FirstName = 'my contact1';
    con1.lastName = 'TestContact1';
    con1.Email = 'puser000@amamama1.com';
    con1.AccountId = acc1.id;
    con1.IAM_Promotion__c = '12345';
    con1.IAM_Contact_Status__c = 'Pending';
    Con1.Username__c = 'test_user_helper31@eidm.com';
    Con1.Location_Change__c = true;
    Con1.IAM_Internal__c = true;
    insert con1;
    
    Contact con2 = new contact();
    con2.FirstName = 'my contact2';
    con2.lastName = 'TestContact2';
    con2.Email = 'puser000@amamama1.com';
    con2.AccountId = acc2.id;
    con2.IAM_Promotion__c = '12345';
    con2.IAM_Contact_Status__c = 'pending';
    Con2.Username__c = 'test_user_helper312@eidm.com';
    Con2.Location_Change__c = true;
    insert con2;
    
    Contact con4 = new contact();
    con4.FirstName = 'my contact4';
    con4.lastName = 'TestContact4';
    con4.Email = 'puser000@amamama1.com';
    con4.AccountId = acc4.id;
    con4.IAM_Promotion__c = '12345';
    con4.IAM_Contact_Status__c = 'pending';
    Con4.Username__c = 'test_user_helper314@eidm.com';
    Con4.IAM_Application_Roles__c = 'QSOL Dealer';
    Con4.Location_Change__c = true;
    Con4.IAM_Work_Group_Id__c = '56330-18654-P';
    Con4.IAM_Product_Group_Access__c = '12345';
    insert con4;
    
    List<Contact> lstCon = new List<Contact>();
   
    Set<Id> setContIds = new Set<Id>();
    
    
    User u1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name =: System.label.dealer_advanced].Id,
                 LastName = 'TEST',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama1.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 isActive = false,
                 LocaleSidKey = 'en_US',ContactId=con1.id); 
    insert u1;  
    User u2 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'TEST',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama2.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 isActive = false,
                 LocaleSidKey = 'en_US',ContactId=con2.id); 
    insert u2;  
    
    
    User u4 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name =: System.label.dealer_advanced].Id,
                 LastName = 'TEST',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama4.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 isActive = false,
                 LocaleSidKey = 'en_US',ContactId=con4.id); 
    insert u4;
    
  
    
    IAM_Application__c app1 = new IAM_Application__c();
    app1.IAM_Application_Name__c = 'Guidanz';
    app1.IAM_Role__c = 'Advanced';
    app1.IAM_Status__c = 'Active';
    app1.IAM_Account_Name__c = acc1.id;
    app1.IAM_Subscription_Name__c = 'test';
    app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert app1;
    
        
    IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
    conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
    conApp1.IAM_Role__c = 'Advanced';
    //conApp1.IAM_Start_Date__c = system.now();
    conApp1.IAM_Status__c = 'Active';
    conApp1.IAM_Contact__c = con1.id; 
    conApp1.IAM_Account_Application__c = app1.id;
    conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    List<IAM_Contact_Provisioning__c> lstConApp = new List<IAM_Contact_Provisioning__c>();
    lstConApp.add(conApp1);
    insert lstConApp;
    
    IAM_Application__c app2 = new IAM_Application__c();
    app2.IAM_Application_Name__c = 'CUMPAS 2.0';
    app2.IAM_Role__c = 'Distributor Admin';
    app2.IAM_Status__c = 'Active';
    app2.IAM_Account_Name__c = acc2.id;
    app2.IAM_Subscription_Name__c = 'test';
    app2.IAM_Cumpas_Distributor_Sales_Rep__c = con1.id;
    app2.IAM_Cumpas_Dist_CS_Rep__c = con1.id;
    app2.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
    insert app2;
    
  
    
    IAM_Application__c app4 = new IAM_Application__c();
    app4.IAM_Application_Name__c = 'QuickServe Online';
    app4.IAM_Role__c = 'QSOL Dealer';
    app4.IAM_Status__c = 'Active';
    app4.IAM_Account_Name__c = acc4.id;
    app4.IAM_Subscription_Name__c = 'test';
    app4.IAM_Qsolexpiration__c = 'test expire';
    app4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
    insert app4;
    
    Map<id,String> oldWWIDS = new Map<id,String> ();
    oldWWIDS.put(con1.id,'test');
    List<User> usr= new List<User>();
    if(Limits.getQueries()<Limits.getLimitQueries()){
         usr = [Select id from User where Contact.id=:con4.id];
    }
    if(!usr.isEmpty()){
       // System.RunAs(usr[0]){
            Test.startTest();
               // IAM_contactHelperClass.AccountChange(setContIds);
                
                setContIds.add(con1.id);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,false,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,false,oldWWIDS);
                
                IAM_Contact_Provisioning__c conApp3 = new IAM_Contact_Provisioning__c();
                conApp3.IAM_Application_Name__c = app4.IAM_Application_Name__c;
                conApp3.IAM_Role__c = 'QSOL Dealer';
                //conApp2.IAM_Start_Date__c = system.now();
                conApp3.IAM_Status__c = 'Active';
                conApp3.IAM_Contact__c = con2.id; 
                conApp3.IAM_Account_Application__c = app4.id;
                conApp3.IAM_Qsolexpiration__c = 'test expire';
                conApp3.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
                insert conApp3;
                
                setContIds.add(con2.id);
                //acc.parentid = acc.id;
                //update acc;
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,false,oldWWIDS);
                
                IAM_Contact_Provisioning__c conApp4 = new IAM_Contact_Provisioning__c();
                conApp4.IAM_Application_Name__c = app4.IAM_Application_Name__c;
                conApp4.IAM_Role__c = 'QSOL Dealer';
                //conApp2.IAM_Start_Date__c = system.now();
                conApp4.IAM_Status__c = 'Active';
                conApp4.IAM_Contact__c = con4.id; 
                conApp4.IAM_Account_Application__c = app4.id;
                conApp4.IAM_Qsolexpiration__c = 'test expire';
                conApp4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
                insert conApp4;
                setContIds = new Set<Id>();
                setContIds.add(con4.id);
                IAM_contactHelperClass.updateUserdetails(setContIds,false,oldWWIDS);
                IAM_contactHelperClass.updateUserdetails(setContIds,true,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,false,oldWWIDS);
                
            Test.stopTest();
        //}
    }
   }

   static testMethod void testMethod2202() {
    
    Account acc1 = new Account();
    acc1.Name = 'TestAccount1';
    acc1.type = 'Distributor Account';
    insert acc1;
    
    Account acc2 = new Account();
    acc2.Name = 'TestAccount2';
    acc2.CSS_DistributorCode__c = '12345';
    acc2.CSS_DBCode__c = '12345';
    acc2.type = 'Distributor Branch Account';
    insert acc2;
    
    Account acc4 = new Account();
    acc4.Name = 'TestAccount2';
    acc4.CSS_DistributorCode__c = '12345';
    acc4.CSS_DBCode__c = '12345';
    acc4.CSS_DealerCode__c='123455';
    acc4.type = 'Dealer Account';
    acc4.parentid = acc1.id;
    acc4.IAM_Movex_Customer_Code__c = '12345';
    insert acc4;
    
    Contact con1 = new contact();
    con1.FirstName = 'my contact1';
    con1.lastName = 'TestContact1';
    con1.Email = 'puser000@amamama1.com';
    con1.AccountId = acc1.id;
    con1.IAM_Promotion__c = '12345';
    con1.IAM_Contact_Status__c = 'Pending';
    Con1.Username__c = 'test_user_helper31@eidm.com';
    Con1.Location_Change__c = true;
    insert con1;
    
         Contact con2 = new contact();
    con2.FirstName = 'my contact2';
    con2.lastName = 'TestContact2';
    con2.Email = 'puser000@amamama1.com';
    con2.AccountId = acc4.id;
    con2.IAM_Promotion__c = '12345';
    con2.IAM_Contact_Status__c = 'pending';
    Con2.Username__c = 'test_user_helper312@eidm.com';
    Con2.Location_Change__c = true;
    insert con2;
        
    List<Contact> lstCon = new List<Contact>();
    Set<Id> setContIds = new Set<Id>();
    User u1 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name =: System.label.dealer_advanced].Id,
                 LastName = 'TEST',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama1.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 isActive = false,
                 LocaleSidKey = 'en_US',ContactId=con1.id); 
    insert u1;  
       User u2 = new User(
                 ProfileId = [SELECT Id FROM Profile WHERE Name = 'CSS_Dealer_Technician'].Id,
                 LastName = 'TEST',
                 Email = 'puser000@amamama.com',
                 Username = 'puser000@amamama2.com.eidmdev',
                 CompanyName = 'TESTIDMDEV',
                 Title = 'title',
                 Alias = 'alias',
                 TimeZoneSidKey = 'America/Los_Angeles',
                 EmailEncodingKey = 'UTF-8',
                 LanguageLocaleKey = 'en_US',
                 isActive = false,
                 LocaleSidKey = 'en_US',ContactId=con2.id); 
    insert u2;  
    
        con1.FirstName='baa';
        con1.LastName='abc';
        update con1;

    IAM_Application__c app1 = new IAM_Application__c();
    app1.IAM_Application_Name__c = 'Guidanz';
    app1.IAM_Role__c = 'Advanced';
    app1.IAM_Status__c = 'Active';
    app1.IAM_Account_Name__c = acc1.id;
    app1.IAM_Subscription_Name__c = 'test';
    app1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    insert app1;
    
        
    IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
    conApp1.IAM_Application_Name__c = app1.IAM_Application_Name__c;
    conApp1.IAM_Role__c = 'Advanced';
    //conApp1.IAM_Start_Date__c = system.now();
    conApp1.IAM_Status__c = 'Active';
    conApp1.IAM_Contact__c = con1.id; 
    conApp1.IAM_Account_Application__c = app1.id;
    conApp1.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
    List<IAM_Contact_Provisioning__c> lstConApp = new List<IAM_Contact_Provisioning__c>();
    lstConApp.add(conApp1);
    insert lstConApp;
    
    IAM_Application__c app2 = new IAM_Application__c();
    app2.IAM_Application_Name__c = 'CUMPAS 2.0';
    app2.IAM_Role__c = 'Distributor Admin';
    app2.IAM_Status__c = 'Active';
    app2.IAM_Account_Name__c = acc2.id;
    app2.IAM_Subscription_Name__c = 'test';
    app2.IAM_Cumpas_Distributor_Sales_Rep__c = con1.id;
    app2.IAM_Cumpas_Dist_CS_Rep__c = con1.id;
    app2.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId();
    insert app2;
    
  
    
    IAM_Application__c app4 = new IAM_Application__c();
    app4.IAM_Application_Name__c = 'QuickServe Online';
    app4.IAM_Role__c = 'QSOL Dealer';
    app4.IAM_Status__c = 'Active';
    app4.IAM_Account_Name__c = acc4.id;
    app4.IAM_Subscription_Name__c = 'test';
    app4.IAM_Qsolexpiration__c = 'test expire';
    app4.recordtypeid = Schema.getGlobalDescribe().get('IAM_Application__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
    insert app4;
    
    Map<id,String> oldWWIDS = new Map<id,String> ();
    oldWWIDS.put(con1.id,'test');
    List<User> usr= new List<User>();
    if(Limits.getQueries()<Limits.getLimitQueries()){
         usr = [Select id from User where Contact.id=:con1.id];
    }
    if(!usr.isEmpty()){
       // System.RunAs(usr[0]){
            Test.startTest();
               // IAM_contactHelperClass.AccountChange(setContIds);
                
                setContIds.add(con1.id);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,false,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,false,oldWWIDS);  
          
                IAM_Contact_Provisioning__c conApp3 = new IAM_Contact_Provisioning__c();
                conApp3.IAM_Application_Name__c = app4.IAM_Application_Name__c;
                conApp3.IAM_Role__c = 'QSOL Dealer';
                //conApp2.IAM_Start_Date__c = system.now();
                conApp3.IAM_Status__c = 'Active';
                conApp3.IAM_Contact__c = con2.id; 
                conApp3.IAM_Account_Application__c = app4.id;
                conApp3.IAM_Qsolexpiration__c = 'test expire';
                conApp3.recordtypeid = Schema.getGlobalDescribe().get('IAM_Contact_Provisioning__c').getDescribe().getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId();
                insert conApp3;
                 con2.FirstName ='a';
        		con2.LastName ='a';
        		update con2;
                setContIds.add(con2.id);

                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,true,oldWWIDS);
                IAM_contactHelperClass.userAttributeUpdate(true,setContIds,false,oldWWIDS);
                
              
            Test.stopTest();
    }
   }
 
    /* Return GL service response body */
    private static String getGLResBody(String hqcode, String spcode) {
        return '{"getSPSearchResultsReturn":{"cumminsLocationDTO":{"branchDTO":{"zipCode":"E3C 2E7","durationText":"1 hour 11 mins","spName":"Eastern Canada - Fredericton","countyDistrict":{"nil":true},"hqCode":"'+hqcode+'","tollFreePhone":{"nil":true},"tollFreeFax":{"nil":true},"latitude":45.9072283,"city Name":"Fredericton","stateName":"New Brunswick","distanceText":"69.8 mi","marketProgram":{"nil":true},"spcode":"'+spcode+'","fax":"506 451-1927","spLocType":101,"email":{"nil":true},"longitude":-66.62141839999998,"address3":{"nil":true},"address2":{"nil":true},"address1":"321  Doak Road","webAddress":{"nil":true},"custServicePhone":{"nil":true},"amenityComments":{"nil":true},"distanceValue":0,"countryName":"Canada","busi nessPhone":"506 451-1929","emergencyPhone":{"nil":true}},"hqDTO":{"nil":true}},"errorCode":{"nil":true},"spDTO":{"nil":true},"paginationDTO":{"nil":true},"la ngId":1,"omrResultFlag":{"nil":true}}}';
    }
    
    /* Return EDQ service response body*/
    private static String getEDQResBody(String verifiedFlag) {
        return '{ "AddressCleanse": { "ResponseNotifications": { "Status": "Success", "ReturnCodeDescription": "" }, "Location": [ { "Locator": { "LongitudeMeas": "", "LatitudeMeas": "" }, "GeographicalArea": { "GeographicalAreaName": "", "StreetAddress": { "FullAddress": "351 MCALLISTER DR&#124;SAINT JOHN NB  E2J 2S8", "AddressLine1txt": "351 MCALLISTER DR", "AddressLine4txt": "", "StreetAddressID": "", "AddressLine2txt": "", "AddressLine3txt": "", "StateProvinceTypeind": "P", "AddressType": "R" }, "AddressValidation": { "VerificationDescription": "Verified; 4 - Premise; Identified and parsed; Primary postal code verified; Score 100", "VerificationCode": "V44-I44-P6-100", "VerifiedFlag": "'+verifiedFlag+'", "GeoAccuracyCodeDescription": "Unable to geocode; 0 - None", "GeoAccuracyCode": "U0", "GeoDistance": "" }, "AddressError": { "ErrorDescription": "", "ErrorFlag": "N" }, "GeographicalAreaSubName": "", "Country": { "CountryID": "CA", "CountryName": "CA", "CountryNameDescription": "CANADA" }, "PostalCode": { "PostalCodeNum": "E2J 2S8" }, "City": { "TerritoryID": "NB", "CityID": "SAINT JOHN" }, "County": { "CountyID": "" }, "CountryGroup": { "CountryGroupID": "AMERICAS", "SubRegion": "NORTHERN AMERICA" } } }, { "Locator": { "LongitudeMeas": "", "LatitudeMeas": "" }, "GeographicalArea": { "GeographicalAreaName": "", "StreetAddress": { "FullAddress": "351 MCALLISTER DR&#124;&#124;&#124;&#124;&#124;&#124;SAINT JOHN&#124;&#124;NB&#124;E2J 2S8", "AddressLine1txt": "351 MCALLISTER DR", "AddressLine4txt": "", "StreetAddressID": "", "AddressLine2txt": "", "AddressLine3txt": "", "StateProvinceTypeind": "", "AddressType": "S" }, "AddressValidation": { "VerificationDescription": "", "VerificationCode": "", "VerifiedFlag": "", "GeoAccuracyCodeDescription": "", "GeoAccuracyCode": "", "GeoDistance": "" }, "AddressError": { "ErrorDescription": "", "ErrorFlag": "N" }, "GeographicalAreaSubName": "", "Country": { "CountryID": "CA", "CountryName": "CA", "CountryNameDescription": "CANADA" }, "PostalCode": { "PostalCodeNum": "E2J 2S8" }, "City": { "TerritoryID": "NB", "CityID": "SAINT JOHN" }, "County": { "CountyID": "" }, "CountryGroup": { "CountryGroupID": "", "SubRegion": "" } } } ] } }';
    }
    
    static testmethod void glWebServiceCallTest() {
        try {
            Account parentAcc = createParentAccount();
            create_IAM_GL_Service_CS();
            Account acc = createDealerAccount();
            String responseBodyGLService = getGLResBody(parentAcc.IAM_Service_Provider_Code__c, parentAcc.IAM_Service_Provider_Code__c);
            Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyGLService, null));
            Test.startTest();
                IAM_contactHelperClass.getPaidAndFreeCount(Label.IAM_GuidanzMobileZapitOEMCount,'1',new List<String>(), new List<String>());
                IAM_contactHelperClass.getPaidAndFreeCount(Label.IAM_FieldTestZapitOEMCountGM,'1',new List<String>(), new List<String>());
                IAM_contactHelperClass.AccountGLUpdate(new Set<Id>{acc.Id});       
            Test.stopTest();
        } catch(Exception e) {
            System.debug('#### Exception - '+e.getMessage());
        }
    }
    
    static testmethod void edqCallTestPositive() {
        try {
            create_IAM_EDQ_oAuth_CS();
            Account acc = createDealerAccount();     
                    
            //String responseBodyEdqInfo = getEDQResBody('Y');
            //Test.setMock(HttpCalloutMock.class, new IAM_SingleRequestMock(200, 'Success', responseBodyEdqInfo, null));       
            Test.startTest();
                IAM_contactHelperClass.AccountEDQGLUpdate(new Set<Id>{acc.Id});             
            Test.stopTest();
        } catch(Exception e) {
            System.debug('#### Exception Message - '+e.getMessage());
        }
    }
    
    /* Create and return parent account*/
    private static Account createParentAccount() {
        Account acc = new Account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account Test Class';
        acc.IAM_Service_Provider_Code__c = '1234';
        acc.BillingCountryCode = 'CA';
        acc.CMI_Address2__c = '';
        acc.BillingStreet = '351 MCALLISTER DR'; 
        acc.BillingCity = 'Fredericton';
        acc.BillingCountry='Canada';
        acc.BillingStateCode = 'NB';
        acc.BillingPostalCode = 'E3C 2E7';
        acc.BillingState='New Brunswick';
        acc.CSS_DistributorCode__c='1234';
        acc.Type = 'Distributor Account';
        insert acc;
        
        return [SELECT Id, Name, IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
    }
    
    private static Account createDealerAccount() {
        Account acc = new account();
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

        acc.CSS_DistributorCode__c='1234';
        acc.CSS_DealerCode__c='test';
        
        acc.Type = 'Dealer Account';
        acc.IAM_Service_Provider_Code__c = '2345';
        
        acc.CSS_Locale__c = 'English(United States)';
        acc.CSS_Language__c = 'English';
        acc.CSS_Timezone__c = '(GMT-05:00) Eastern Standard Time (America/Panama)';
        insert acc;
        return acc;
    }

    /* Create Custom Setting CSS_Integration_Details__c */
    public static void createCSSIntegrationDetails(String name, String appName, String authEnv, String endpoint, 
        String grantType, Boolean isActive, String key, String logging, String methodType, String passcode, 
        Integer timeout, String username) {
        CSS_Integration_Details__c obj = new CSS_Integration_Details__c();
        obj.Name = name;
        obj.ApplicationName__c = appName;
        obj.AuthEnv__c = authEnv;
        obj.End_Point__c = endpoint;
        obj.grant_type__c = grantType;
        obj.IsActive__c = isActive;
        obj.Key__c = key;
        obj.Logging__c = logging;
        obj.Method_Type__c = methodType;
        obj.Passcode__c = passcode;
        obj.Timeout__c = timeout;
        obj.Username__c = username;
        obj.Resource__c = endpoint;
        insert obj;
    }
   
    /* Create - CSS_Integration_Details__c - IAM_Global_Locator_Mule */
    public static void create_IAM_GL_Service_CS() {
        createCSSIntegrationDetails('IAM_Global_Locator_Mule', 'IAM_Global_Locator_Mule', null, 'https://services-stg.cummins.com/iamgl/getspsearchresults',
        null, true, 'rZAd55IuOWyWUkvYaYqixRv2DPXOGc9QQP5XssF8cH6O3aCoePMrMK/dZ50jN5F6aqI/LFOVVKtE4QzlUKDxWA==', null, 'POST', 'wOXXcO0IDYfpb8RvkBN6ut8UaHhHdLM0IcvcQLR/NhsVRBgClv0XJvjJorIhNsMsu60kbGmqrvDXZAfr8vzVSw==', null, 'mNMF0ONaExTlp94fe62/6lKzyrlOf3VZTodR6iqsGXU=');
    }

    /* Create - CSS_Integration_Details__c - IAM_GL_Service */
    public static void create_IAM_EDQ_oAuth_CS() {
        createCSSIntegrationDetails('IAM_EDQ_Mule_Address_Validation', 'IAM_EDQ_Mule_Address_Validation', 'OAGoAuth', 'https://services-stg-oauth.cummins.com/api/oauth/token/cdh',
        'client_credentials', true, 'rZAd55IuOWyWUkvYaYqixRv2DPXOGc9QQP5XssF8cH6O3aCoePMrMK/dZ50jN5F6aqI/LFOVVKtE4QzlUKDxWA==', 'CDH', 'POST', 'wOXXcO0IDYfpb8RvkBN6ut8UaHhHdLM0IcvcQLR/NhsVRBgClv0XJvjJorIhNsMsu60kbGmqrvDXZAfr8vzVSw==', 120000, 'mNMF0ONaExTlp94fe62/6lKzyrlOf3VZTodR6iqsGXU=');
    }
}