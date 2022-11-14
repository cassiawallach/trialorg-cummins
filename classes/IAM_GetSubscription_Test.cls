/*
Test Class for IAM_getSubscriptionNameswithout & IAM_getSubscriptionNames
History                                                            
-------                                                            
VERSION       AUTHOR                      DATE               DETAIL                                
1.0 -      Shubhangi Sardar             05/02/2021        Added comment to push to production 
*********************************************************************************************
*/
@isTest
public class IAM_GetSubscription_Test{


 @testSetup
    static void BuildData(){
    
     Account accP=new Account();
    accP.Name='AccountPp';
    accP.Type='Distributor Account';
    accP.BillingStreet='1260 N MARR ROAD';
    accP.BillingCity='COLUMBUS';
    accP.BillingState='Indiana';
    accP.BillingCountry='United States';
    accP.BillingPostalCode='47201';
    
    insert accP;
        
        
    Account acc1=new Account(); 
    acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
    acc1.Name='Account12';
    acc1.Type='Dealer Account';
    acc1.ParentId=accP.Id;
    acc1.BillingStreet='1260 N MARR ROAD';
    acc1.BillingCity='COLUMBUS';
    acc1.BillingState='Indiana';
    acc1.BillingCountry='United States';
    acc1.BillingPostalCode='47201';
    acc1.IAM_WWSPS_Regions__c='US and Canada';
    
insert acc1;

Account acc2=new Account(); 
    acc2.Name='Account133';
    acc2.Type='Distributor Account';
    acc2.ParentId=accP.Id;
    acc2.BillingStreet='1260 N MARR ROAD';
    acc2.BillingCity='COLUMBUS';
    acc2.BillingState='Indiana';
    acc2.BillingCountry='United States';
    acc2.BillingPostalCode='47201';
    acc2.IAM_WWSPS_Regions__c='US and Canada';
    
insert acc2;

Account acc3=new Account(); 
    acc3.Name='Account133';
    acc3.Type='Individual';
    acc3.ParentId=accP.Id;
    acc3.BillingStreet='1260 N MARR ROAD';
    acc3.BillingCity='COLUMBUS';
    acc3.BillingState='Indiana';
    acc3.BillingCountry='United States';
    acc3.BillingPostalCode='47201';
   // acc3.IAM_WWSPS_Regions__c='US and Canada';
    
insert acc3;
Contact c3=new Contact();
c3.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
c3.FirstName = 'myfirstn3';
c3.LastName ='mylastn3';
c3.Email = 'myemail3@abc.com';
c3.Username__c = 'myuserid3@abc.com';
c3.AccountId = acc3.ID;
c3.IAM_from_Registration__c=true;
c3.IAM_Contact_Status__c = 'Active';
c3.CMI_Contact_Type__c = 'Primary';
c3.IAM_Internal__c=true;
    
insert c3;

Contact c2=new Contact();
c2.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
c2.FirstName = 'myfirstn';
c2.LastName ='mylastn';
c2.Email = 'myemail2@abc.com';
c2.Username__c= 'myuserid2@abc.com';
c2.AccountId = acc1.ID;
c2.IAM_from_Registration__c=true;
c2.IAM_Contact_Status__c = 'Active';
c2.CMI_Contact_Type__c = 'Primary';
    
insert c2; 

 Id profId  = [SELECT Id,Name FROM Profile Where name = 'IAM_Admin_User'].Id;
    
    User uesrSampleRecord = new User(
        LastName = 'lstTest2',
        FirstName = 'frstTest2',
        Email = 'lstTest2@test.com',
        Alias = 'lsTest',
        Username = 'lstTest2@test.com',
        CommunityNickname = 'lstest12342',
        LocaleSidKey= 'en_US',
        TimeZoneSidKey ='GMT',
        ProfileID = profId,
        LanguageLocaleKey = 'en_US',
        EmailEncodingKey = 'UTF-8'
        //,        contactId = c2.Id
    );
    
   insert uesrSampleRecord;
   
 
Contact c=new Contact();
c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
c.FirstName = 'myfirstn22';
c.LastName ='mylastn22';
c.Email = 'myemail222@abc.com';
//c.IAM_Cummins_login_ID__c = 'myuserid222@abc.com';
c.Username__c =  'myuserid222@abc.com';
c.AccountId = accP.ID;
c.IAM_from_Registration__c=true;
c.IAM_Contact_Status__c = 'Active';
c.CMI_Contact_Type__c = 'Primary';
    
insert c;

List<IAM_Application__c> app=new List<IAM_Application__c>();

IAM_Application__c app1=new IAM_Application__c();
app1.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
app1.IAM_Application_Name__c='CUMPAS 2.0';
app1.IAM_Role__c='Dealer User;Dealer Admin';
app1.IAM_Cumpas_Modularity__c='View Credit';
app1.IAM_Subscription_Count__c=1000;
app1.IAM_Account_Name__c=acc1.Id;

IAM_Application__c app5=new IAM_Application__c();
app5.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
app5.IAM_Application_Name__c='CUMPAS 2.0';
app5.IAM_Role__c='Distributor Admin;Distributor Sales Representative;';
app5.IAM_Cumpas_Modularity__c='View Credit';
app5.IAM_Subscription_Count__c=1000;
app5.IAM_Account_Name__c=acc2.Id;

IAM_Application__c app2=new IAM_Application__c();
app2.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
app2.IAM_Application_Name__c='EDS';
app2.IAM_Role__c='Technician;Workgroup Administrator';
app2.IAM_Subscription_Count__c=1000;
app2.IAM_Account_Name__c=acc1.Id;
        
IAM_Application__c app3=new IAM_Application__c();
app3.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
app3.IAM_Application_Name__c='Cummins Service Training';
app3.IAM_Role__c='Service Training User';
app3.IAM_Subscription_Count__c=1000;
app3.IAM_Account_Name__c=acc3.Id;
app3.IAM_Subscription_Name__c='CST';
app3.IAM_Free_Subscription__c = false;
app3.IAM_Subscription_Start_Date__c= System.today() ;
app3.IAM_Subscription_End_Date__c= System.today() + 15;

IAM_Application__c app4=new IAM_Application__c();
app4.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(); 
app4.IAM_Application_Name__c='Connected Solutions';
app4.IAM_Role__c='Operator';
app4.IAM_Subscription_Count__c=1000;
app4.IAM_Account_Name__c=acc1.Id;

IAM_Application__c app6=new IAM_Application__c();
app6.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
app6.IAM_Application_Name__c='QuickServe Online';
app6.IAM_Role__c='QSOL Distributor';
app6.IAM_Subscription_Count__c=1000;
app6.IAM_Account_Name__c=acc2.Id;
app6.IAM_Qsolexpiration__c='exp123';
app6.IAM_Subscription_Name__c='QuickServe Online';
app6.IAM_Status__c='Active';
 IAM_Application__c conSol = new IAM_Application__c();    
        conSol.IAM_Account_Name__c = acc3.ID;
        conSol.IAM_Application_Name__c = 'Connected Solutions';
        conSol.IAM_Role__c='PrimaryContact';
        conSol.IAM_Status__c='Active';
        conSol.IAM_Subscription_Count__c= 1000;
        conSol.IAM_Provisioned_User_Count__c=5;
        conSol.IAM_Subscription_End_Date__c= System.today() + 5;
        conSol.IAM_Subscription_Name__c='TestSubscription1';
        conSol.IAM_Free_Subscription__c= False;
        conSol.IAM_Subscription_Start_Date__c=System.today();
    

app.add(app1);
app.add(conSol);
app.add(app2);
app.add(app3);
app.add(app4);
app.add(app5);
app.add(app6);
//app.IAM_Subscription_Start_Date__c
//app.IAM_Subscription_End_Date__c
insert app;

List<IAM_Contact_Provisioning__c> conPLst=new List<IAM_Contact_Provisioning__c>();

IAM_Contact_Provisioning__c coo=new IAM_Contact_Provisioning__c();
coo.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
coo.IAM_Application_Name__c='Cummins Service Training';
coo.IAM_Account_Application__c=app3.Id;
coo.IAM_Role__c='Service Training User';
coo.IAM_Contact__c=c3.Id;
coo.IAM_Status__c ='Active';

IAM_Contact_Provisioning__c co=new IAM_Contact_Provisioning__c();
co.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(); 
co.IAM_Application_Name__c='Connected Solutions';
co.IAM_Account_Application__c=app4.Id;
co.IAM_Role__c='Operator';
co.IAM_Contact__c=c2.Id;
co.IAM_Status__c ='Active';

IAM_Contact_Provisioning__c co1=new IAM_Contact_Provisioning__c();
co1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
co1.IAM_Application_Name__c='QuickServe Online';
co1.IAM_Account_Application__c=app6.Id;
co1.IAM_Role__c='QSOL Dealer';
co1.IAM_Contact__c=c2.Id;
co1.IAM_Status__c ='Active';
co1.IAM_Qsolexpiration__c='exp123';
co1.IAM_Subscription_Name__c='QuickServe Online';

IAM_Contact_Provisioning__c conP2=new IAM_Contact_Provisioning__c();
conP2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
conP2.IAM_Application_Name__c='CUMPAS 2.0';
conP2.IAM_Account_Application__c = app5.Id;
conP2.IAM_Role__c='Dealer User';
conP2.IAM_Cumpas_Modularity__c='View Credit';
conP2.IAM_Contact__c=c2.Id;
conP2.IAM_Status__c ='Active';

IAM_Contact_Provisioning__c conP4= new IAM_Contact_Provisioning__c();
        conP4.IAM_Account_Application__c = conSol.ID;
        conP4.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
        conP4.IAM_Application_Name__c = 'Connected Solutions';
        conP4.IAM_Contact__c= c3.Id;
        conP4.IAM_End_Date__c= System.today() + 5;
        conP4.IAM_Role__c='PrimaryContact';
        conP4.IAM_Start_Date__c=System.today();
        conP4.IAM_Status__c='Active';

conPLst.add(conP4);        
//conPLst.add(conP3);
conPLst.add(conP2);
conPLst.add(co);
conPLst.add(coo);
conPLst.add(co1);

insert conPLst;

Test.StartTest();
IAM_getSubscriptionNameswithout.getApplicationNRoleNames(co1.Id);
IAM_getSubscriptionNameswithout.getApplicationNRoleNames(conP2.Id);
IAM_getSubscriptionNameswithout.getApplicationNRoleNames(conP4.Id);
Test.StopTest();
}

 //@Istest
    /*static void testGetSubscription()
    { 
    Contact con=[select id , name from contact where FirstName = 'myfirstn'];
    IAM_getSubscriptionNames.SubscriptionNames(con.Id,'appName');
    IAM_getSubscriptionNames.SubscriptionNames(con.Id,'subName');
    IAM_getSubscriptionNames.getwrkGrpRegions(con.Id);
    
    if(Limits.getQueries()<Limits.getLimitQueries()){  
    IAM_Contact_Provisioning__c cp=[select id from IAM_Contact_Provisioning__c where IAM_Application_Name__c ='QuickServe Online'];
    IAM_getSubscriptionNames.getApplicationNRoleNames(cp.Id);
    }
    if(Limits.getQueries()<Limits.getLimitQueries()){  
    Account a=[select id from Account where Name='AccountPp'];
    String i=a.Id;
    IAM_getSubscriptionNames.getLocationType(con.Id,i);
    IAM_getSubscriptionNames.getLocationByType(con.Id,i,'Dealer Account');
    }
    
    }
    
    
    @Istest
    static void testGetSubscriptionConnectedSolutions()
    { 
    Contact con=[select id , name from contact where FirstName = 'myfirstn'];
    IAM_getSubscriptionNames.SubscriptionNames(con.Id,'appName');
    IAM_getSubscriptionNames.SubscriptionNames(con.Id,'subName');
    IAM_getSubscriptionNames.getwrkGrpRegions(con.Id);
    
    if(Limits.getQueries()<Limits.getLimitQueries()){  
    IAM_Contact_Provisioning__c cp=[select id from IAM_Contact_Provisioning__c where IAM_Application_Name__c ='Connected Solutions' LIMIT 1];
    IAM_getSubscriptionNames.getApplicationNRoleNames(cp.Id);
    }
    
    if(Limits.getQueries()<Limits.getLimitQueries()){  
    Account a=[select id from Account where Name='AccountPp'];
    String i=a.Id;
    IAM_getSubscriptionNames.getLocationType(con.Id,i);
    IAM_getSubscriptionNames.getLocationByType(con.Id,i,'Dealer Account');
    }
    
    }*/
    

 @Istest
    static void test_getSubscriptionNameswithout()
    {     
    
    Contact co=[select id , name from contact where FirstName = 'myfirstn22'];
    Account a=[select id from Account where Name='AccountPp'];
    String i=a.Id;
    Contact con=[select id , name from contact where FirstName = 'myfirstn'];
    IAM_getSubscriptionNameswithout.getwrkGrpRegions(co.Id);
    
    
    
    
    /*if(Limits.getQueries()<Limits.getLimitQueries()) {  
    Contact c1=[select id , name from contact where FirstName = 'myfirstn3'];
    IAM_getSubscriptionNameswithout.SubscriptionNames(c1.Id,'appName');
    IAM_getSubscriptionNameswithout.SubscriptionNames(c1.Id,'subName');
    }   
    
    if(Limits.getQueries()<Limits.getLimitQueries()) {  
    Contact c2=[select id , name from contact where FirstName = 'myfirstn22'];
    IAM_getSubscriptionNameswithout.SubscriptionNames(c2.Id,'appName');
    IAM_getSubscriptionNameswithout.SubscriptionNames(c2.Id,'subName');
    }*/
    }
    
  
  Static TestMethod Void getSubscription_Test(){
     
    Account a=[select id from Account where Name='AccountPp'];
    String i=a.Id;
    Contact con=[select id , name from contact where FirstName = 'myfirstn']; 
    IAM_getSubscriptionNameswithout.getLocationType('US and Canada');
    IAM_getSubscriptionNameswithout.getLocationByType(con.Id,i);
    IAM_getSubscriptionNameswithout.getLocations('Dealer Account');
  }
  
  
  Static TestMethod Void getSubcription_Test2(){
     
    Contact con=[select id , name from contact where FirstName = 'myfirstn']; 
    IAM_getSubscriptionNameswithout.SubscriptionNames(con.Id,'subName');
  }
  
  Static TestMethod Void getSubcription_Test3(){
     
    Contact con=[select id , name from contact where FirstName = 'myfirstn']; 
    IAM_getSubscriptionNameswithout.SubscriptionNames(con.Id,'appName');
  }
    
}