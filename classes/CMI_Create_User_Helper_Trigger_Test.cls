@isTest
private class CMI_Create_User_Helper_Trigger_Test{

    static testMethod void myUnitTest() {
   List<Account> acc=new List<Account>(); 
    Account a=new account();
    a.name='testtrigger';
    a.CMI_Cummins_Support_Email__c='test@gmail.com';
    a.CMI_Account_Status__c='Inactive';
    //a.CMI_Tableau_Id__c='customer123';
    acc.add(a);
    insert acc;
    
    List<contact> objcon=new List<contact>();
    contact c=new contact();
    c.firstname='fname';
    c.lastname='lname';
    c.accountid=a.id;
    c.phone='8181818181';
    c.email='testtrigger@gmail.com';
    c.IAM_Cummins_Login_ID__c='testtrigger@gmail.com';
    c.CMI_Contact_Type__c='Primary';
    objcon.add(c);
   insert objcon;
   Profile p = [SELECT Id FROM Profile WHERE Name='CS_Community_User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, contactId=objcon[0].id,
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com'); 
        //Starts the scope of test
        a.CMI_Account_Status__c= 'Active';
        update acc;
        contact tc=new contact();
        tc.firstname='fn';
        tc.lastname='ln';
        tc.accountid=a.id;
        tc.phone='8181818181';
        tc.email='testtrigger@gmail.com';
        tc.CMI_Contact_Type__c='Secondary';
        insert tc;
        
        contact con1=new contact();
        con1.firstname='firstName';
        con1.lastname='l';
        con1.accountid=a.id;
        con1.phone='8181818181';
        con1.email='testtrigger@gmail.com';
        con1.IAM_Cummins_Login_ID__c='testtrigger213@gmail.com';
        con1.CMI_Contact_Type__c='Secondary';
        insert con1;
    }
    
    
    
    static testMethod void myUnitTest1() {
    List<Account> acc=new List<Account>(); 
    Account a=new account();
    a.name='testtrigger';
    a.CMI_Cummins_Support_Email__c='test@gmail.com';
    a.CMI_Account_Status__c='Active';
    //a.CMI_Tableau_Id__c='customer123';
    acc.add(a);
    insert acc;
    
    List<contact> objcon=new List<contact>();
    contact c=new contact();
    c.firstname='fname';
    c.lastname='lname';
    c.accountid=a.id;
    c.phone='8181818181';
    c.email='testtrigger@gmail.com';
    c.IAM_Cummins_Login_ID__c='testtrigger@gmail.com';
    c.CMI_Contact_Type__c='Primary';
    objcon.add(c);
   insert objcon;
    
        //Starts the scope of test
        a.CMI_Cummins_Support_Email__c='';
        a.CMI_Account_Status__c= 'Inactive';
        update acc;
        contact tc=new contact();
        tc.firstname='firstname';
        tc.lastname='lastname';
        tc.accountid=a.id;
        tc.phone='8181818181';
        tc.email='testtrigger@gmail.com';
        tc.IAM_Cummins_Login_ID__c='testtrigger32@gmail.com';
        tc.CMI_Contact_Type__c='Secondary';
        insert tc;
     }
     
   }