@isTest
private class CMI_userregpage_Test{

    static testMethod void myUnitTest() 
    {
        Account a=new account();
        contact c=new contact();
        a.name='test';
        insert a;
        List<IAM_Application__c> lstApp= new List<IAM_Application__c>();
        IAM_Application__c app = new IAM_Application__c();
        app.IAM_Application_Name__c = 'Connected Solutions';
        app.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
        app.IAM_Role__c = 'AccountManager';
        app.IAM_Status__c = 'Active';
        app.IAM_Account_Name__c = a.id;
        app.IAM_Subscription_Name__c = 'test';
        lstApp.add(app);
        
        IAM_Application__c app1 = new IAM_Application__c();
        app1.IAM_Application_Name__c = 'Marketplace';
        app1.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(Label.IAM_OSM_App_Name).getRecordTypeId();
        app1.IAM_Role__c = 'OSM Fleet Admin';
        app1.IAM_Status__c = 'Active';
        app1.IAM_Account_Name__c = a.id;
        app1.IAM_Subscription_Name__c = 'test';
        lstApp.add(app1);
        insert lstApp;
        ApexPages.StandardController sc = new ApexPages.StandardController(a);
        ApexPages.currentPage().getParameters().put('aid', a.id);
        CMI_userregpage obj=new CMI_userregpage(sc);
        PageReference pageRef = Page.CMI_userreg;
        Test.setCurrentPage(pageRef);
        c.email='test';
        obj.contact=c;
        //..obj.send();
        Id RecIdpro = [Select Id, Name,sobjecttype from RecordType where name = 'Connected Solutions' and sobjecttype = 'IAM_Contact_Provisioning__c'].Id; 
        c.email='test@gmail.com';
        c.firstName='fName';
        c.lastName='Lname';
        c.phone='9876543210';
        c.Username__c='testdass@gmail.com';
        obj.contact=c;
        //obj.send();
        c.CMI_Contact_Type__c='Primary';
        c.phone='9876543210ytgbjmnb';
        obj.contact=c;
        obj.selectedRole ='AccountManager';
        obj.send();
        obj.reset();
        
        
        
        
    }
    
    
    Static testMethod void myUnitTest2()
    {
     Account acc = new Account();
    acc.Name = 'TestAccount';
    acc.CMI_CId__c = 'testCid';
    insert acc;
    
    //all the settings for contact type is Primary..
    List<Contact> lstCon = new List<Contact>();
    Contact con = new contact();
    con.FirstName='fnamecon';
    con.lastName = 'TestContact';
    con.AccountId = acc.id;
    
    con.IAM_Contact_Status__c = 'Active';    
    con.CMI_Contact_type__c='Secondary';
    con.Username__c='testcumminsemail@cummins.com';
    con.email='testemail@cummins.com';
    con.IAM_Cummins_login_ID__c = 'testemail@cummins.com';
    insert con;
    //lstCon.Add(con);
    
    Contact con2 = new contact();
    con2.FirstName='fnamecon';
    con2.lastName = 'TestContact';
    con2.AccountId = acc.id;
    con2.IAM_Contact_Status__c = 'Active';    
    con2.CMI_Contact_type__c='Secondary';
    con2.Username__c='testcumminsemailcummins.com';
    con2.email='';
    con2.IAM_Cummins_login_ID__c = 'testemail1@cummins.com';
    //insert con2;
    
    lstCon.Add(con2);
    insert lstCon;
    
    CMI_userregpage.insertNewUser(lstCon[0].Id);
    
    List<IAM_Application__c> lstApp= new List<IAM_Application__c>();
    IAM_Application__c app = new IAM_Application__c();
    app.IAM_Application_Name__c = 'Connected Solutions';
    app.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(label.IAM_AppName_ConnectedSolutions).getRecordTypeId();
    app.IAM_Role__c = 'AccountManager';
    app.IAM_Status__c = 'Active';
    app.IAM_Account_Name__c = acc.id;
    app.IAM_Subscription_Name__c = 'test';
    lstApp.add(app);
    
    IAM_Application__c app1 = new IAM_Application__c();
    app1.IAM_Application_Name__c = 'Marketplace';
    app1.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(Label.IAM_OSM_App_Name).getRecordTypeId();
    app1.IAM_Role__c = 'OSM Fleet Admin';
    app1.IAM_Status__c = 'Active';
    app1.IAM_Account_Name__c = acc.id;
    app1.IAM_Subscription_Name__c = 'test';
    lstApp.add(app1);
    insert lstApp;
    
    List<IAM_Contact_Provisioning__c> lstConApp = new List<IAM_Contact_Provisioning__c>();
    /*IAM_Contact_Provisioning__c conApp = new IAM_Contact_Provisioning__c();
    conApp.IAM_Application_Name__c ='Market Place';
    conApp.IAM_Role__c = 'Account Manager';
    conApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Market Place').getRecordTypeId();
   // conApp.IAM_Start_Date__c = system.now();
    conApp.IAM_Status__c = 'Active';
    conApp.IAM_Contact__c = con.id; 
    conApp.IAM_Account_Application__c = app.id;
    lstConApp.add(conApp);*/
    
    
    IAM_Contact_Provisioning__c conApp1 = new IAM_Contact_Provisioning__c();
    conApp1.IAM_Application_Name__c ='Connected Solutions';
    
    conApp1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId();
    conApp1.IAM_Role__c = 'AccountManager';
   // conApp1.IAM_Start_Date__c = system.now();
    conApp1.IAM_Status__c = 'Active';
    conApp1.IAM_Contact__c = lstCon[0].id; 
    conApp1.IAM_Account_Application__c = app.id;
    lstConApp.add(conApp1);
    
    insert lstconApp;
    
    
    ApexPages.StandardController sc = new ApexPages.StandardController(acc);
        ApexPages.currentPage().getParameters().put('aid', acc.id);
        CMI_userregpage obj=new CMI_userregpage(sc);
        PageReference pageRef = Page.CMI_userreg;
        Test.setCurrentPage(pageRef);
 
        obj.contact=con;
      //  obj.selectedRole='AccountManager';
        obj.send();
        
        //second time
        
    Contact con1 = new contact();
    con1.FirstName='';
    con1.lastName = 'TestContact';
    con1.AccountId = acc.id;
    con1.IAM_Contact_Status__c = 'Active';    
    con1.CMI_Contact_type__c='Secondary';
    con1.Username__c='testcumminsemailusenamecummins.com';
    con1.email='';
    
    obj.contact=con1;
   //obj.selectedRole='AccountManager';
    obj.send();
    obj.getRoleOptions();  
    }
}