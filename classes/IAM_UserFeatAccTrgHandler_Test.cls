/*************************************************************************************
Name: IAM_UserFeatAccTrgHandler_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test class for IAM_UserFeatureAndAccessTriggerHandler
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Karthik Raj Golakaram     23/04/2020     INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar          12/18/2020     Changes for CST Production defect
1.2      Shubhangi Sardar          05/02/2021     Added test cases for GM Unit Subscriptions
1.3      Shubhangi Sardar          27/04/2021     Code optimization and LDAP Sync Issue
1.4      Shubhangi Sardar          09/08/2021     Added EVL Guidanz Permission Set Changes
1.5      Sandeep Vuyyuru           16/09/2021     DA Enhancement
1.6      Suresh Rathod             08/02/2022     Cummins API Portal changes
1.7      Anupam Adhikari           24/03/2022     Added changes to push to prod
1.8      Sandeep Vuyyuru           11/04/2022     MarketPlace and Guidanz Mobile 101 soql issue on registration page
1.9      Suresh Rathod Nanavath    04/05/2022     Added comment to push to prod
2.0      Ganesh K M                19/07/2022     Made changes to Policy Resource System New App Onboarding
2.1      Chetan Gaikwad            28/07/2022     Made changes CDO App Onboarding
2.2      Souvik Lahiri             01/09/2022     Added comment to push to prod
**************************************************************************************
**************************************************************************************/

@isTest
public class IAM_UserFeatAccTrgHandler_Test {

    @testSetup
    static void BuildData() {
    
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
    
        insert acc1;
        List<contact> cons=new List<contact>();
        Contact c=new Contact();
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        c.FirstName = 'myfirstn';
        c.LastName ='mylastn';
        c.Email = 'myemail2@abc.com';
        c.Username__c = 'myuserid2@abc.com';
        c.AccountId = acc1.ID;
        c.IAM_from_Registration__c=true;
        c.IAM_Contact_Status__c = 'Active';
        c.CMI_Contact_Type__c = 'Primary';
   
        Contact ct=new Contact();
        ct.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        ct.FirstName = 'myfirssstn';
        ct.LastName ='mylassstn';
        ct.Email = 'myemails2@abct.com';
        ct.Username__c = 'myuserissd2@abct.com';
        ct.AccountId = acc1.ID;
        ct.IAM_from_Registration__c=true;
        ct.IAM_Contact_Status__c = 'Active';
        ct.CMI_Contact_Type__c = 'Primary'; 

        cons.add(c);
        cons.add(ct);
        insert cons; 

        List<IAM_Application__c> app=new List<IAM_Application__c>();
        IAM_Application__c app1=new IAM_Application__c();
        app1.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
        app1.IAM_Application_Name__c='CUMPAS 2.0';
        app1.IAM_Role__c='Dealer User;Dealer Admin';
        app1.IAM_Cumpas_Modularity__c='View Credit';
        app1.IAM_Subscription_Count__c=99;
        app1.IAM_Account_Name__c=acc1.Id;
        
        IAM_Application__c app4=new IAM_Application__c();
        app4.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(); 
        app4.IAM_Application_Name__c=system.Label.IAM_AppName_ConnectedSolutions;
        app4.IAM_Subscription_Start_Date__c=system.today();
        app4.IAM_Role__c='User';
        app4.IAM_Account_Name__c=acc1.Id;

        IAM_Application__c app2=new IAM_Application__c();
        app2.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
        app2.IAM_Application_Name__c='EDS';
        app2.IAM_Free_Subscription__c=false;
        app2.IAM_Subscription_Start_Date__c=system.today();
        app2.IAM_Subscription_End_Date__c=system.today()+365;
        app2.IAM_Role__c='Technician;Workgroup Administrator';
        app2.IAM_Subscription_Count__c=99;
        app2.IAM_Account_Name__c=acc1.Id;
        app2.IAM_Subscription_Name__c='QSOL cpg';
        
        IAM_Application__c app3=new IAM_Application__c();
        app3.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
        app3.IAM_Application_Name__c='Cummins Service Training';
        app3.IAM_Free_Subscription__c=false;
        app3.IAM_Subscription_Start_Date__c=system.today();
        app3.IAM_Subscription_End_Date__c=system.today()+365;
        app3.IAM_Role__c='Service Training User';
        app3.IAM_Subscription_Count__c=99;
        app3.IAM_Account_Name__c=acc1.Id;
        app3.IAM_Subscription_Name__c='QSOL cpg';

        IAM_Application__c appGuidanz=new IAM_Application__c();
        appGuidanz.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId(); 
        appGuidanz.IAM_Application_Name__c='Guidanz';
        appGuidanz.IAM_Free_Subscription__c=false;
        appGuidanz.IAM_Subscription_Start_Date__c=system.today();
        appGuidanz.IAM_Subscription_End_Date__c=system.today()+365;
        appGuidanz.IAM_Role__c='Advanced;Technician';
        appGuidanz.IAM_Subscription_Count__c=99;
        appGuidanz.IAM_Account_Name__c=acc1.Id;
        appGuidanz.IAM_Status__c='Active';

        IAM_Application__c appRSW=new IAM_Application__c();
        appRSW.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Rapid Serve Web').getRecordTypeId(); 
        appRSW.IAM_Application_Name__c='Rapid Serve Web';
        appRSW.IAM_Role__c='BASIC';
        appRSW.IAM_Subscription_Count__c=99;
        appRSW.IAM_Account_Name__c=acc1.Id;
        appRSW.IAM_Status__c='Active';

        app.add(app1);
        app.add(app2);
        app.add(app3);
        app.add(appGuidanz);
        app.add(appRSW);
        app.add(app4);
        insert app;

        List<IAM_Contact_Provisioning__c> conPLst=new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conP2=new IAM_Contact_Provisioning__c();
        conP2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('CUMPAS 2.0').getRecordTypeId(); 
        conP2.IAM_Application_Name__c='CUMPAS 2.0';
        conP2.IAM_Role__c='Dealer User';
        conP2.IAM_Cumpas_Modularity__c='View Credit';
        conP2.IAM_Account_Application__c=app1.Id;
        conP2.IAM_Contact__c=c.Id;
        conP2.IAM_Status__c ='Active';

        IAM_Contact_Provisioning__c conAppGuidanz=new IAM_Contact_Provisioning__c();
        conAppGuidanz.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId(); 
        conAppGuidanz.IAM_Application_Name__c='Guidanz';
        conAppGuidanz.IAM_Role__c='Advanced';
        conAppGuidanz.IAM_Account_Application__c=appGuidanz.Id;
        conAppGuidanz.IAM_Contact__c=c.Id;
        conAppGuidanz.IAM_Status__c ='Active';


        IAM_Contact_Provisioning__c conP1=new IAM_Contact_Provisioning__c();
        conP1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        conP1.IAM_Application_Name__c='QuickServe Online';
        conP1.IAM_Role__c='QSOL Dealer';
        conP1.IAM_Qsolexpiration__c='testExp';
        conP1.IAM_Account_Application__c=app1.Id;
        conP1.IAM_Subscription_Name__c='QSOL cpg';
        conP1.IAM_Contact__c=c.Id;
        conP1.IAM_Status__c ='Active';

        IAM_Contact_Provisioning__c conP=new IAM_Contact_Provisioning__c();
        conP.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
        conP.IAM_Application_Name__c='EDS';
        conP.IAM_Role__c='Technician;Workgroup Administrator';
        conP.IAM_Contact__c=c.Id;
        conP.IAM_Account_Application__c=app2.Id;

        IAM_Contact_Provisioning__c conP3=new IAM_Contact_Provisioning__c();
        conP3.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
        conP3.IAM_Application_Name__c='EDS';
        conP3.IAM_Role__c='Technician;Workgroup Administrator';
        conP3.IAM_Contact__c=ct.Id;
        conP3.IAM_Account_Application__c=app2.Id;
        IAM_Contact_Provisioning__c conP6=new IAM_Contact_Provisioning__c();
        conP6.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Archer').getRecordTypeId(); 
        conP6.IAM_Application_Name__c='Archer';
        conP6.IAM_Role__c='Technician;Workgroup Administrator';
        conP6.IAM_Contact__c=ct.Id;

        IAM_Contact_Provisioning__c conP11=new IAM_Contact_Provisioning__c();
        conP11.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('QuickServe Online').getRecordTypeId(); 
        conP11.IAM_Application_Name__c='QuickServe Online';
        conP11.IAM_Role__c='QSOL Dealer';
        conP11.IAM_Qsolexpiration__c='testExp';
        conP11.IAM_Account_Application__c=app1.Id;
        conP11.IAM_Subscription_Name__c='QSOL cpg';
        conP11.IAM_Contact__c=ct.Id;
        conP11.IAM_Status__c ='Active';
        
        IAM_Contact_Provisioning__c coo=new IAM_Contact_Provisioning__c();
        coo.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
        coo.IAM_Application_Name__c='Cummins Service Training';
        coo.IAM_Role__c='Service Training User';
        coo.IAM_Contact__c=c.Id;
        coo.IAM_Status__c ='Active';
        coo.IAM_Account_Application__c=app3.Id;
        coo.IAM_Promotion__c='12345';

        IAM_Contact_Provisioning__c co=new IAM_Contact_Provisioning__c();
        co.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
        co.IAM_Application_Name__c='Cummins Service Training';
        co.IAM_Role__c='Service Training User';
        co.IAM_Contact__c=ct.Id;
        co.IAM_Status__c ='Active';
        co.IAM_Account_Application__c=app3.Id;
        co.IAM_Promotion__c='12345';

        IAM_Contact_Provisioning__c co1=new IAM_Contact_Provisioning__c();
        co1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId(); 
        co1.IAM_Application_Name__c='Guidanz Mobile';
        co1.IAM_Role__c='Guidanz Mobile Campaign Employee';
        co1.IAM_Guidanz_Mobile_Roles__c='Guidanz Mobile Campaign Employee';
        co1.IAM_Contact__c=c.Id;
        co1.IAM_Status__c ='Active';
        co1.IAM_swregExpire__c='SRV0-02/14/2019';
        co1.IAM_Account_Application__c=app3.Id;

        IAM_Contact_Provisioning__c rswApp = new IAM_Contact_Provisioning__c();
        rswApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Rapid Serve Web').getRecordTypeId(); 
        rswApp.IAM_Application_Name__c='Rapid Serve Web';
        rswApp.IAM_Role__c='BASIC';
        rswApp.IAM_Contact__c=c.Id;
        rswApp.IAM_Status__c ='Pending';
        rswApp.IAM_Account_Application__c=appRSW.Id;
        
        IAM_Contact_Provisioning__c CSApp = new IAM_Contact_Provisioning__c();
        CSApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Connected Solutions').getRecordTypeId(); 
        CSApp.IAM_Application_Name__c=system.Label.IAM_AppName_ConnectedSolutions;
        CSApp.IAM_Role__c='User';
        CSApp.IAM_Contact__c=c.Id;
        CSApp.IAM_Status__c ='Active';
        CSApp.IAM_DA_Customer_List__c='ALL';
        CSApp.IAM_From_CDO__c=false;
        CSApp.IAM_Account_Application__c=app4.Id;

        try {
            insert conP;
        } catch(Exception e) {
            System.assert(String.isNotBlank(e.getMessage()));
        }
        try {
            insert co;
        } catch(Exception e) {
            System.assert(String.isNotBlank(e.getMessage()));
        }

        conPLst.add(conP1);
        conPLst.add(conP11);
        conPLst.add(conP2);
        conPLst.add(coo);
        conPLst.add(conP3);
        conPLst.add(co1);
        conPLst.add(rswApp);
        conPLst.add(conAppGuidanz);
        conPLst.add(CSApp);
        insert conPLst;

        CSS_Integration_Details__c css_intg = new CSS_Integration_Details__c();
        css_intg.Name = 'IAM_LDAP_oAuth';
        css_intg.ApplicationName__c = 'IAM_LDAP_oAuth';
        css_intg.IsActive__c = true;
        css_intg.End_Point__c = 'https://services-dev-oauth.cummins.com/api/oauth/token/ldaputil';
        css_intg.Key__c = 'thAQWe/AIgUevs8IGTdk4Ddx50z3F9xiqm2Hl/QMu/MuVcRJFcWzFgYxxXvpN2LZEs43hkxTJ3t67B0nx7a1qg==';
        css_intg.Username__c = 'Z7xm9X6ImVl6ND7zTJ2j/jScb740y2NP/TOoSV9vC+U=';
        css_intg.Passcode__c = 'Il3eUr1gk32ejCbujtRoFDgyeVhp+MdwlVe5n/L2Tlk3uQejsj9shK0YOC5Dy/k5HFxa4Ac6EexF+dRmHCEl8Q==';
        css_intg.AuthEnv__c = 'OAGoAuth';
        css_intg.Logging__c = 'LDAPUtil';
        css_intg.Method_Type__c = 'POST';
        css_intg.Timeout__c = 120000;
        insert css_intg;       
    }
    
    static testMethod void test2() {   
        test.startTest();
        List<IAM_Contact_Provisioning__c> cc=new list<IAM_Contact_Provisioning__c>();    
        IAM_Contact_Provisioning__c c3=[Select  id, Iam_role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c ='Cummins Service Training' LIMIT 1];
        c3.IAM_Status__c ='Inactive';

        IAM_Contact_Provisioning__c c4=[Select  id, Iam_role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Application_Name__c='Guidanz Mobile' LIMIT 1];
        c4.IAM_swregExpire__c='SRV0-02/14/2020';
        c4.IAM_Status__c ='Active';
        cc.add(c3);
        cc.add(c4);
        update cc;
        test.stopTest();
    }

    static testMethod void test4() {
        Contact con=[select id , name from contact where FirstName = 'myfirstn' LIMIT 1];
        List<IAM_Contact_Provisioning__c> clst=[SELECT id,IAM_Application_Name__c,IAM_Username__c,
        IAM_End_Date__c, Iam_role__c,IAM_Status__c,IAM_Contact__c FROM IAM_Contact_Provisioning__c 
        WHERE IAM_Contact__c=:con.Id];
        Set<Id> sid = new Set<Id>();
        for(IAM_Contact_Provisioning__c cp:clst) {
            sid.add(cp.id);
        }
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    }

    static testMethod void test5() {
        Set<Id> sid = new Set<Id>();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
    }

    static testMethod void test55() {
        Test.startTest();
        Contact con=[select id ,AccountId, name from contact where FirstName = 'myfirstn' LIMIT 1];
        con.IAM_From_Registration__c=false;
        update con;
        List<IAM_Contact_Provisioning__c> clst=[Select id,IAM_Application_Name__c,IAM_From_Registration__c,IAM_Username__c,IAM_End_Date__c, Iam_role__c,IAM_Status__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:con.Id];
        system.debug('@@@@@@@@'+clst);       
        IAM_Application__c aa=[select id from IAM_Application__c where IAM_Application_Name__c='EDS'];
        IAM_Application__c bb=[select id from IAM_Application__c where IAM_Application_Name__c='EDS'];
        
        IAM_Application__c appGM=new IAM_Application__c();
            appGM.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Field Test Guidanz Mobile').getRecordTypeId(); 
            appGM.IAM_Application_Name__c='Field Test Guidanz Mobile';
            appGM.IAM_Role__c='Field Test Power Plus Lite Guidanz Mobile';
            appGM.IAM_Guidanz_Mobile_Roles__c = 'Beta Testing Guidanz Mobile';
            appGM.IAM_Subscription_Count__c=99;
            appGM.IAM_Account_Name__c=con.AccountId;
            appGM.IAM_Status__c='Active';
            appGM.IAM_swregExpire__c = 'CMPF-02/14/2019';
            insert appGM;
        
        List<IAM_Contact_Provisioning__c> conProList = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conP1=new IAM_Contact_Provisioning__c();
        conP1.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Field Test Guidanz Mobile').getRecordTypeId(); 
        conP1.IAM_Application_Name__c='Field Test Guidanz Mobile';
        conP1.IAM_Role__c='Field Test Power Plus Lite Guidanz Mobile';
        conP1.IAM_Contact__c=con.Id;
        //conP.IAM_Subscription_Name__c='QSOL CPG';
        conP1.IAM_Account_Application__c=appGM.Id;
        conProList.add(conP1);        
        
        IAM_Application__c appGSP=new IAM_Application__c();
            appGSP.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz Service Portal').getRecordTypeId(); 
            appGSP.IAM_Application_Name__c='Guidanz Service Portal';
            appGSP.IAM_Role__c='General User';
            //appGM.IAM_Guidanz_Mobile_Roles__c = 'Beta Testing Guidanz Mobile';
            appGSP.IAM_Subscription_Count__c=99;
            appGSP.IAM_Account_Name__c=con.AccountId;
            appGSP.IAM_Status__c='Active';
            //appGM.IAM_swregExpire__c = 'CMPF-02/14/2019';
            insert appGSP;
        
        IAM_Contact_Provisioning__c conP2=new IAM_Contact_Provisioning__c();
        conP2.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz Service Portal').getRecordTypeId(); 
        conP2.IAM_Application_Name__c='Guidanz Service Portal';
        conP2.IAM_Role__c='General User';
        conP2.IAM_Contact__c=con.Id;
        conP2.IAM_User__c = con.Id;
        conP2.IAM_Status__c = 'Active';
        //conP2.IAM_Subscription_Name__c='QSOL CPG';
        conP2.IAM_Account_Application__c=appGSP.Id;
        conProList.add(conP2);

        //List<IAM_Contact_Provisioning__c> conProList = new List<IAM_Contact_Provisioning__c>();
        IAM_Contact_Provisioning__c conP=new IAM_Contact_Provisioning__c();
        conP.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('EDS').getRecordTypeId(); 
        conP.IAM_Application_Name__c='EDS';
        conP.IAM_Role__c='Technician;Workgroup Administrator';
        conP.IAM_Contact__c=con.Id;
        conP.IAM_Subscription_Name__c='QSOL CPG';
        conP.IAM_Account_Application__c=aa.Id;
        conProList.add(conP);

        IAM_Contact_Provisioning__c co=new IAM_Contact_Provisioning__c();
        co.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins Service Training').getRecordTypeId(); 
        co.IAM_Application_Name__c='Cummins Service Training';
        co.IAM_Role__c='Service Training User';
        co.IAM_Contact__c=con.Id;
        co.IAM_Status__c ='Active';
        co.IAM_Account_Application__c=bb.Id;
        co.IAM_Promotion__c='12345';
        conProList.add(co);
        try {
            insert conProList;
        } catch(Exception e) {
            System.assert(String.isNotBlank(e.getMessage()));
        }
        Test.stopTest();
        /*try {
            insert co;
        } catch(Exception e) {
            System.assert(String.isNotBlank(e.getMessage()));
        }*/
    }
    
    static testmethod void test66() {
        test.startTest();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact();
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];
       // IAM_Application__c appAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        //Test.startTest();        
        System.runAs(u) {
            try {
                insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
                IAM_Application__c appAccessObj = createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User', 'Active');
                IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(), 
                Date.today()+365, 'Active', '', '', '', 'Dealer User', '');
            } catch(Exception e) {
                System.assert(String.isNotBlank(e.getMessage()));
            }
        }
        test.stopTest();
    }
    
    static testMethod Void roleChange(){      
        Contact con= [Select id,email from contact where username__c='myuserid2@abc.com'];
        IAM_Contact_Provisioning__c iamConProv=[Select id,IAM_Role__c from IAM_Contact_Provisioning__c where IAM_Contact__c=:con.id and IAM_Application_Name__c='Guidanz'];
        iamConProv.IAM_Role__c='Technician';
        Update iamConProv;   
    }
    
    public static IAM_Contact_Provisioning__c createContactSubscription(id conID,String AppName,
    String appRole, String Status,id appAccountId){
        IAM_Contact_Provisioning__c iam= new IAM_Contact_Provisioning__c();
        iam.IAM_Application_Name__c=AppName;
        iam.IAM_Role__c=appRole;
        iam.IAM_Status__c=Status;
        iam.IAM_Start_Date__c=Date.today();
        iam.IAM_End_Date__c= Date.today() + 365;
        iam.IAM_contact__c=conID;
        iam.RecordtypeID=Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        iam.IAM_Account_Application__c=appAccountId;
        insert iam;        
        return iam;        
    }
    
    public static IAM_Application__c createAccountSubscription(Id accId, String appName, String appRole, 
    String Status) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accId;                
        obj.IAM_Subscription_Start_Date__c = Date.today();
        obj.IAM_Subscription_End_Date__c = Date.today() + 365;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = appRole;
        if(appName == Label.IAM_Guidanz_Mobile_App_Name){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Guidanz_Mobile_Roles__c = appRole;
            obj.IAM_swregExpire__c = 'IAM-2020';
        }
        if(appName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = 'IAM-2020';
        }
        if(appName == 'CUMPAS 2.0') {
            obj.IAM_Cumpas_Modularity__c = 'View Credit;Core Returns';
        }
        obj.IAM_Status__c = status;
        obj.IAM_Subscription_Name__c = appName;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        return obj;
    }

    public static Contact getContact() {
        Contact con = new contact();
        con.FirstName = 'LogInFname';
        con.LastName = 'LonInLname';
        con.Email = 'LogInFname@test.com';
        con.Username__c = 'LogInFname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        return con;
    }

    static testmethod void guidanzMobileNFT() {
        Test.startTest();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c appGM = createGMUnitAppSub(acc.Id, 'Guidanz Mobile',
                                                            'Guidanz Mobile Intapp Units');
        IAM_Application__c appGMFT = createGMUnitAppSub(acc.Id, Label.IAM_App_GuidanzMobileFieldTest,
                                                            'Field Test Intapp Units Guidanz Mobile');
        createGMUnitUserSub(con.Id, appGMFT.Id, Label.IAM_App_GuidanzMobileFieldTest,
                            'Field Test Intapp Units Guidanz Mobile');        
        List<IAM_Contact_Provisioning__c> conPro = [
            SELECT IAM_Assigned_Units__c FROM IAM_Contact_Provisioning__c 
            WHERE IAM_Account_Application__c = :appGMFT.Id];
        System.debug('#### app -'+conPro);
        conPro[0].IAM_Assigned_Units__c = 3;
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){        
            update conPro[0];
        }
        Test.stopTest();
        List<IAM_Contact_Provisioning__c> conProFetched = [
            SELECT IAM_Assigned_Units__c FROM IAM_Contact_Provisioning__c];
        System.debug('#### app -'+conProFetched);
    }
  
    static IAM_Application__c createGMUnitAppSub(Id accId, String appName, String appRole) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accId;                
        obj.IAM_Subscription_Start_Date__c = Date.today();
        obj.IAM_Subscription_End_Date__c = Date.today() + 365;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = appRole;
        obj.IAM_Guidanz_Mobile_Roles__c = appRole;
        obj.IAM_Total_Units__c = 10;
        obj.IAM_Status__c = 'Active';
        obj.IAM_Subscription_Name__c = appRole;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        return obj;
    }

  /* Create IAM_Contact_Provisioning__c object record  */
    public static void createGMUnitUserSub(Id conId, Id accAccFeatureId, String appName, String role) {
        IAM_Contact_Provisioning__c obj = new IAM_Contact_Provisioning__c();
        obj.IAM_Contact__c= conId; 
        obj.IAM_Start_Date__c = Date.today();
        obj.IAM_End_Date__c = Date.today() + 365;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = role;
        obj.IAM_Guidanz_Mobile_Roles__c = role;
        obj.IAM_Assigned_Units__c = 2;
        obj.IAM_Status__c = 'Active';
        obj.IAM_Account_Application__c = accAccFeatureId;
        obj.IAM_Subscription_Name__c = role;        
        obj.RecordtypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();                 
        User u = [select id, Name, ProfileId, isActive  from User where Profile.Name = 'System Administrator' and isActive=true limit 1];
        System.runAs(u){
            insert obj;
        }
        System.debug('#### User access obj '+obj);
    }
    
    static testMethod void checkAccess() {
        test.startTest();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Contact loginUserCon = getContact();
        User u = IAM_TestData.createUser(loginUserCon, acc, Label.IAM_Profile_Admin_User);
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'IAM_Cumpas_Business_Admin_Permission_Set_SF'];
        User adminUser = [SELECT Id FROM User WHERE IsActive = True AND Profile.Name = :Label.IAM_Profile_Admin_User Limit 1];             
        System.runAs(adminUser) {
            try {
                IAM_UserFeatureAndAccessTriggerHandler.getExpirationStr('test', Date.today());
                IAM_Application__c appAccessObj = createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User', 'Active');
                IAM_TestData.createUserSubscription(con.Id, appAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(), 
                Date.today()+365, 'Active', '', '', '', 'Dealer User', '');
                List<IAM_Contact_Provisioning__c> appList = [SELECT Id, IAM_Assigned_Units__c, IAM_Remaining_Units__c, IAM_Application_Name__c FROM IAM_Contact_Provisioning__c LIMIT 1];
                Map<Id, IAM_Contact_Provisioning__c> appMap = new Map<Id, IAM_Contact_Provisioning__c>();
                if(!appList.isEmpty()) {
                    IAM_UserFeatureAndAccessTriggerHandler.updateUserAppAttrForRLSAndPC(new Set<Id>{appList[0].Id}, true, false);
                    IAM_UserFeatureAndAccessTriggerHandler.updateUserAppAttrForRLSAndPC(null, true, false);
                    appList[0].IAM_Assigned_Units__c = 4;
                    appList[0].IAM_Remaining_Units__c = 4;
                    appMap.put(appList[0].Id, appList[0]);
                    IAM_UserFeatureAndAccessTriggerHandler.populateRemainingCountField(appList, appMap);
                    IAM_UserFeatureAndAccessTriggerHandler.checkIfUserHasAppAccess(appList);
                }
                System.debug('#### created subscription');
            } catch(Exception e) {
                System.debug('#### Test Exception -' + e.getMessage());
                System.assert(String.isNotBlank(e.getMessage()));
            }
        }
        test.stopTest();
    }
    
    static testMethod void callMethod1() {
        Test.startTest();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Map<String, String> testMap1 = new Map<String, String>();
        Set<Id> testSet = new Set<Id>();
        testMap1.put(con.Id, 'Active');
        testSet.add(con.Id);
        IAM_UserFeatureAndAccessTriggerHandler.updateRSWFieldOnContact(testMap1);
        //IAM_UserFeatureAndAccessTriggerHandler.callRSWAPI(testSet,'Rapid Serve Web');
        IAM_UserFeatureAndAccessTriggerHandler.callRSWAPI(testSet);
        Test.stopTest();
    }

    static testMethod void callMethodRSW() {
        try {  
            Test.startTest();          
            Account acc = [SELECT Id FROM Account WHERE Name = 'Account12'];
            Contact con = [SELECT Id FROM Contact WHERE Username__c = 'myuserid2@abc.com'];
            
            IAM_Application__c appGM=new IAM_Application__c();
            appGM.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Rapid Serve Web').getRecordTypeId(); 
            appGM.IAM_Application_Name__c='Rapid Serve Web';
            appGM.IAM_Role__c='BASIC';
            //appGM.IAM_Guidanz_Mobile_Roles__c = 'Guidanz Mobile Campaign Employee';
            appGM.IAM_Subscription_Count__c=99;
            appGM.IAM_Account_Name__c=acc.Id;
            appGM.IAM_Status__c='Active';
            //appGM.IAM_swregExpire__c = 'CMP0-02/14/2019';
            insert appGM;
            
            IAM_Contact_Provisioning__c userAppGM=new IAM_Contact_Provisioning__c();
            userAppGM.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Rapid Serve Web').getRecordTypeId(); 
            userAppGM.IAM_Application_Name__c='Rapid Serve Web';
            userAppGM.IAM_Role__c='BASIC';
            //userAppGM.IAM_Guidanz_Mobile_Roles__c='Guidanz Mobile Campaign Employee';
            userAppGM.IAM_Contact__c = con.Id;
            userAppGM.IAM_Status__c ='Pending';
            //userAppGM.IAM_swregExpire__c='CMP0-02/14/2019';
            userAppGM.IAM_Account_Application__c=appGM.Id;
            insert userAppGM;  
            Test.stopTest();  
        } catch(Exception e) {
            System.debug('#### Exception - ' + e.getMessage());
        }
    }
    
    static testMethod void callMethodPRS() {
        try {  
            Test.startTest();          
            Account acc = [SELECT Id FROM Account WHERE Name = 'Account12'];
            Contact con = [SELECT Id FROM Contact WHERE Username__c = 'myuserid2@abc.com'];
            
            IAM_Application__c appGM=new IAM_Application__c();
            appGM.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Policy Resource System').getRecordTypeId(); 
            appGM.IAM_Application_Name__c='Policy Resource System';
            appGM.IAM_Role__c='Dealer';
            //appGM.IAM_Guidanz_Mobile_Roles__c = 'Guidanz Mobile Campaign Employee';
            appGM.IAM_Subscription_Count__c=99;
            appGM.IAM_Account_Name__c=acc.Id;
            appGM.IAM_Status__c='Active';
            //appGM.IAM_swregExpire__c = 'CMP0-02/14/2019';
            insert appGM;
            
            IAM_Contact_Provisioning__c userAppGM=new IAM_Contact_Provisioning__c();
            userAppGM.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Policy Resource System').getRecordTypeId(); 
            userAppGM.IAM_Application_Name__c='Policy Resource System';
            userAppGM.IAM_Role__c='Dealer';
            //userAppGM.IAM_Guidanz_Mobile_Roles__c='Guidanz Mobile Campaign Employee';
            userAppGM.IAM_Contact__c = con.Id;
            userAppGM.IAM_Status__c ='Pending';
            //userAppGM.IAM_swregExpire__c='CMP0-02/14/2019';
            userAppGM.IAM_Account_Application__c=appGM.Id;
            insert userAppGM;  
            Test.stopTest();  
        } catch(Exception e) {
            System.debug('#### Exception - ' + e.getMessage());
        }
    }

    static testMethod void callMethod2() {
        Test.startTest();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Map<String, String> testMap2 = new Map<String, String>();
        testMap2.put(con.Id, 'Inactive');
        IAM_UserFeatureAndAccessTriggerHandler.updateRSWFieldOnContact(testMap2);
        Test.stopTest();
    }

    static testMethod void callMethod3() {
       IAM_UserFeatureAndAccessTriggerHandler.updateRSWFieldOnContact(null);
    }

    static testMethod void callMethod4() {
        try {
            Test.startTest();    
            Account acc = [SELECT Id FROM Account WHERE Name = 'Account12'];
            Contact con = [SELECT Id FROM Contact WHERE Username__c = 'myuserid2@abc.com'];
            IAM_Application__c appGuidanz = [
                SELECT Id FROM IAM_Application__c WHERE IAM_Application_Name__c = 'Guidanz' 
                AND IAM_Account_Name__c = :acc.Id];
            IAM_Contact_Provisioning__c conAppGuidanzAdvanced = [
                SELECT Id, IAM_Role__c, IAM_User__c FROM IAM_Contact_Provisioning__c
            	WHERE IAM_Account_Application__c = :appGuidanz.Id AND IAM_Contact__c = :con.Id];
            
            IAM_Contact_Provisioning__c conAppGuidanz=new IAM_Contact_Provisioning__c();
            conAppGuidanz.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId(); 
            conAppGuidanz.IAM_Application_Name__c='Guidanz';
            conAppGuidanz.IAM_Role__c='Technician';
            conAppGuidanz.IAM_Account_Application__c=appGuidanz.Id;
            conAppGuidanz.IAM_Contact__c=con.Id;
            conAppGuidanz.IAM_Status__c ='Active';
            conAppGuidanz.IAM_User__c = null;
            insert conAppGuidanz;
        
            Map<Id,IAM_Contact_Provisioning__c> conMap = new Map<Id,IAM_Contact_Provisioning__c>();
            conMap.put(conAppGuidanz.Id, conAppGuidanz);
            conMap.put(conAppGuidanzAdvanced.Id, conAppGuidanzAdvanced);
            List<IAM_Contact_Provisioning__c> conProList = new List<IAM_Contact_Provisioning__c>();
            conProList.add(conAppGuidanz);
            conProList.add(conAppGuidanzAdvanced);
            
            IAM_UserFeatureAndAccessTriggerHandler.deleteOldGuidanzPermissionSet(conProList, conMap, false, true);
            Test.stopTest();            
        } catch(Exception e) {
            System.debug('#### Exception - ' + e.getMessage());
        }
    }
      
    static testMethod void callMethod5() {
        try {  
            Test.startTest();          
            Account acc = [SELECT Id FROM Account WHERE Name = 'Account12'];
            Contact con = [SELECT Id FROM Contact WHERE Username__c = 'myuserid2@abc.com'];
            
            IAM_Application__c appGM=new IAM_Application__c();
            appGM.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId(); 
            appGM.IAM_Application_Name__c='Guidanz Mobile';
            appGM.IAM_Role__c='Guidanz Mobile Campaign Employee';
            appGM.IAM_Guidanz_Mobile_Roles__c = 'Guidanz Mobile Campaign Employee';
            appGM.IAM_Subscription_Count__c=99;
            appGM.IAM_Account_Name__c=acc.Id;
            appGM.IAM_Status__c='Active';
            appGM.IAM_swregExpire__c = 'CMP0-02/14/2019';
            insert appGM;
            
            IAM_Contact_Provisioning__c userAppGM=new IAM_Contact_Provisioning__c();
            userAppGM.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Guidanz Mobile').getRecordTypeId(); 
            userAppGM.IAM_Application_Name__c='Guidanz Mobile';
            userAppGM.IAM_Role__c='Guidanz Mobile Campaign Employee';
            userAppGM.IAM_Guidanz_Mobile_Roles__c='Guidanz Mobile Campaign Employee';
            userAppGM.IAM_Contact__c = con.Id;
            userAppGM.IAM_Status__c ='Active';
            userAppGM.IAM_swregExpire__c='CMP0-02/14/2019';
            userAppGM.IAM_Account_Application__c=appGM.Id;
            insert userAppGM;  
            Test.stopTest();  
        } catch(Exception e) {
            System.debug('#### Exception - ' + e.getMessage());
        }
    }
        
    static testMethod void callMethod6() {
        try {            
            Account acc = [SELECT Id FROM Account WHERE Name = 'Account12'];
            Contact con = [SELECT Id FROM Contact WHERE Username__c = 'myuserid2@abc.com'];
            
            IAM_Application__c appGM=new IAM_Application__c();
            appGM.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Field Test Guidanz Mobile').getRecordTypeId(); 
            appGM.IAM_Application_Name__c='Field Test Guidanz Mobile';
            appGM.IAM_Role__c='Field Test Guidanz Mobile Campaign';
            appGM.IAM_Guidanz_Mobile_Roles__c = 'Field Test Guidanz Mobile Campaign';
            appGM.IAM_Subscription_Count__c=99;
            appGM.IAM_Account_Name__c=acc.Id;
            appGM.IAM_Status__c='Active';
            appGM.IAM_swregExpire__c = 'CMPF-02/14/2019';
            insert appGM;
            
            IAM_Contact_Provisioning__c userAppGM=new IAM_Contact_Provisioning__c();
            userAppGM.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Field Test Guidanz Mobile').getRecordTypeId(); 
            userAppGM.IAM_Application_Name__c='Field Test Guidanz Mobile';
            userAppGM.IAM_Role__c='Field Test Guidanz Mobile Campaign';
            userAppGM.IAM_Guidanz_Mobile_Roles__c='Field Test Guidanz Mobile Campaign';
            userAppGM.IAM_Contact__c = con.Id;
            userAppGM.IAM_Status__c ='Active';
            userAppGM.IAM_swregExpire__c='CMPF-02/14/2019';
            userAppGM.IAM_Account_Application__c=appGM.Id;
            insert userAppGM;
            
            Test.startTest();
            IAM_Contact_Provisioning__c conApp = [SELECT Id, IAM_End_Date__c 
                                                  FROM IAM_Contact_Provisioning__c
                                                  WHERE Id =: userAppGM.Id];
            conApp.IAM_End_Date__c = Date.today() + 20;
            update conApp;
            Test.stopTest();
            
        } catch(Exception e) {
            System.debug('#### Exception - ' + e.getMessage());
        }
    }

    /* Guidanz Service Portal Test Case With FSL Customer Code Account Available & Account
    Provisioning Present For GSP app */
    static testmethod void guidanzServicePortalTestUFA() {
        Test.startTest();
            App_Mapping__c app = IAM_TestData.getGuiServicePortalApp();
            Account acc = IAM_TestData.createAccountWithFSLCustomerCode();
            Contact con = IAM_TestData.createContact(acc.Id);
            IAM_Application__c accApp = IAM_TestData.createAccountSubscription(acc.Id, Label.IAM_AppName_GuidanzServicePortal,
            'General User', con);
            IAM_TestData.createUserSubscription(con.Id, accApp.Id, Label.IAM_AppName_GuidanzServicePortal,
            Label.IAM_AppName_GuidanzServicePortal, Date.today(), Date.today() + 365, 'Active', 'Web',
            '', '', 'General User', '');
        Test.stopTest();
    }

    static testmethod void guidanzServicePortalTestUFA1() {
        try {
        User loggedUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId()];
        Test.startTest();
            IAM_UserFeatureAndAccessTriggerHandler.updateProfileAndPSGuiSerPortalUser(new set<Id>{loggedUser.Id});
        Test.stopTest();
        } catch(Exception e) {

        }
    }
     //Start-Test method to cover Cummins API Portal changes-@Suresh
     static testMethod void cumminsAPIPortalTest1() {
        try {   
               Account accSampleRecord = new Account(name='CumminsAPITest7',Type = 'Dealer Account',
                                    CMI_Account_Status__c = 'Active',
                                    CMI_CDA_Status__c='New Customer Request',
                                    //ParentId = accSampleRecord4.id,
                                    //CMI_Region__c = 'East Asia',
                                    CMI_Cummins_Support_Email__c = 'abcxyz123@gmail.com'
                                    );
    
    insert accSampleRecord;
    Account acc = [SELECT Id,Name FROM Account WHERE name ='CumminsAPITest7'];
        Contact con = new Contact(
        FirstName = 'Cummins API',
        LastName ='User Test class',
        Email = 'lstTest12cap@test.com',
        AccountId = acc.ID,
        IAM_Contact_Status__c = 'Pending',
        CMI_Contact_Type__c = 'Secondary',
        Username__c = 'lstTest12defeduniqueecap@test.com',
        Phone = '9743800309'
    );
    insert con;
            
            IAM_Application__c appCAP=new IAM_Application__c();
            appCAP.RecordTypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get('Cummins API Portal').getRecordTypeId(); 
            appCAP.IAM_Application_Name__c='Cummins API Portal';
            appCAP.IAM_Role__c='API Owner';
            appCAP.IAM_Account_Name__c=acc.Id;
            appCAP.IAM_Status__c='Active';
            insert appCAP;
            
            IAM_Contact_Provisioning__c userApp=new IAM_Contact_Provisioning__c();
            userApp.RecordTypeId = Schema.SObjectType.IAM_Contact_Provisioning__c.getRecordTypeInfosByName().get('Cummins API Portal').getRecordTypeId(); 
            userApp.IAM_Application_Name__c='Cummins API Portal';
            userApp.IAM_Role__c='API Owner';
            userApp.IAM_Contact__c = con.Id;
            userApp.IAM_Status__c ='Pending';
            userApp.IAM_Account_Application__c=appCAP.Id;
            insert userApp;
            
            Test.startTest();
            IAM_Contact_Provisioning__c conApp = [SELECT Id, IAM_End_Date__c 
                                                  FROM IAM_Contact_Provisioning__c
                                                  WHERE Id =: userApp.Id];
            conApp.IAM_Status__c = 'Active';
            update conApp;
            Test.stopTest();
            
        } catch(Exception e) {
            System.debug('#### Exception - ' + e.getMessage());
        }
    }
    //End-Test method to cover Cummins API Portal changes-@Suresh
}