/*************************************************************
Name:  IAM_RequestAccessControllerTest
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_RequestAccessController_Test class. 
Request access for salesforce IAM users.                         
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Keerthy Gurumurthy     23/04/2018       INITIAL DEVELOPMENT  
1.1-     Nishant/ Shubhangi     04/12/2020       HighRadius 
1.2      Anupam Adhikari        10/29/2021       GDP changes...       
1.3		 Chetan Gaikwad			03/30/2022		 RSW SP code validation
1.4 -    Suresh Rathod          04/05/2022       Guidanz Service Portal Enhancement and breakfix
*****************************************************/
/********************************************************************************
***********************************************************************************/
@isTest
private class IAM_RequestAccessController_Test {
    
    public IAM_Contact_Provisioning__c conAppInsert;
    
    static testmethod void highRadAppRequestActiveAppTest() {
        App_Mapping__c app = IAM_TestData.getHighRadiusApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        
        Test.startTest();        
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
        obj.HighradiusFlag = true;
        obj.requestApp();
        Test.stopTest();
    }
    
    static testmethod void highRadSubmitAppNoAppTest() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        App_Mapping__c app = IAM_TestData.getHighRadiusApp();
        IAM_RequestAccessController obj;            
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        obj = new IAM_RequestAccessController(sc);
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.HighradiusFlag = true;
        obj.HighRadiuslanguage = 'English';
        obj.submitApp();      
    }
    
    static testmethod void highRadSubmitAppNoAppTest1() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        App_Mapping__c app = IAM_TestData.getHighRadiusApp();
        IAM_RequestAccessController obj;            
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        obj = new IAM_RequestAccessController(sc);
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.HighradiusFlag = true;
        obj.HighRadiuslanguage = 'Canadian French';
        obj.submitApp();      
    }
    
    static testmethod void highRadSubmitAppNoAppTest2() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'HighRadius', 'Customer View Only');
        App_Mapping__c app = IAM_TestData.getHighRadiusApp();
        IAM_RequestAccessController obj;            
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        obj = new IAM_RequestAccessController(sc);
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.HighradiusFlag = true;
        obj.HighRadiuslanguage = 'English';
        obj.submitApp();      
    }
    
    static testmethod void cumpasAppRequestActiveAppTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Dealer User', '');
        /*User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];*/
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.HighradiusFlag = false;
            obj.requestApp();        
            System.assert(obj.conAppActive);
        //}
        Test.stopTest();
    }
    
    static testmethod void cumpasAppRequestNewTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        
        Test.startTest();        
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
        IAM_Application__c appFetched = [SELECT Id, IAM_Application_Name__c, IAM_Role__c 
                                         FROM IAM_Application__c 
                                         WHERE Id = :accAccessObj.Id];
        obj.createContactProvisionigs(appFetched, Label.IAM_Status_Active);
        //added @Anupam RSW
        //obj.determineChannelAdmin();
        Test.stopTest();
    }
    
    static testmethod void cumpasAppRequestPendingAppTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Pending', '', '', '', 'Dealer User', '', true);
        insert accAccessObj;
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Pending', '', '', '', 'Dealer User', '');
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.HighradiusFlag = false;
            obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            System.assert(obj.conAppPending);
        //}
        Test.stopTest();
    }
    
    static testmethod void cumpasAppRequestNoAppTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.HighradiusFlag = false;
            obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
        //}
        Test.stopTest();
    }
    
    static testmethod void rswAppRequestPendingAppTest() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Pending', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Pending', '', '', '', 'Basic', '');
            
            
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            ApexPages.CurrentPage().getParameters().put('uid',con.Username__c);
            obj.HighradiusFlag = false;
            obj.requestApp();            
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            System.assert(obj.conAppPending);
        //}
        Test.stopTest();
    }
    
    static testmethod void rswAppRequestActiveAppTest() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Pendig', '', '', '', 'Admin', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.HighradiusFlag = false;
            obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            System.assert(obj.isRSWsection);
        //}
        Test.stopTest();
    }
    
    static testmethod void gmAppReqActiveAppPrimaryTest() {
        App_Mapping__c app = IAM_TestData.getGuidanzMobileApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        /*IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile User');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Guidanz Mobile User', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.HighradiusFlag = false;
            obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
        //}
        Test.stopTest();
    }
    
    static testmethod void gmAppReqActiveAppSecondaryTest() {
        App_Mapping__c app = IAM_TestData.getGuidanzMobileApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, 'Secondary', false);
        /*IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile User');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Guidanz Mobile User', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.HighradiusFlag = false;
            obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
        //}
        Test.stopTest();
    }
    
    static testmethod void cumpasSubmitAppNoAppTest() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_RequestAccessController obj;
        //System.runAs(u) {
            
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            obj = new IAM_RequestAccessController(sc);
        //}
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.HighradiusFlag = false;
        obj.submitApp();
        obj.checkApprovalsRedirect();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assert(pageMessages.size() != 0);        
    }
    
    static testmethod void rswSubmitAppActiveAppTest() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Pendig', '', '', '', 'Admin', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.rswReason = 'Other';
            obj.rswOtherReason = 'Test';
            Account acc1 = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
            obj.rswPreferCode = acc1.IAM_Service_Provider_Code__c;
            obj.rswAdditionalCode = '123';
            obj.rswAdditionalCode1 = '123';
            obj.rswAdditionalCode2 = '123';
            obj.rswAdditionalCode3 = '123';
            obj.rswAdditionalCode4 = '123';
            obj.HighradiusFlag = false;
        	obj.validateDuplicateRSWSPCode(obj.rswPreferCode, obj.rswAdditionalCode, obj.rswAdditionalCode1, 
                                              obj.rswAdditionalCode2, obj.rswAdditionalCode3, obj.rswAdditionalCode4, system.label.IAM_ErrorMsg_Duplicate_SP_Code);
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            //System.assert(!obj.isRSWsection);
        //}
        Test.stopTest();
    }
    
    static testmethod void rswSubmitAppActiveAppTest1() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc1 = IAM_RequestAccessController_Test.createAccountRSW1('84531');
        Account acc2 = IAM_RequestAccessController_Test.createAccountRSW1('84931');
        Account acc3 = IAM_RequestAccessController_Test.createAccountRSW1('84631');
        Account acc4 = IAM_RequestAccessController_Test.createAccountRSW1('94731');
        Account acc5 = IAM_RequestAccessController_Test.createAccountRSW1('90731');
        Account acc6 = IAM_RequestAccessController_Test.createAccountRSW1('94701');
        Contact con = createContact(acc1.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc1.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.rswReason = 'Other';
            obj.rswOtherReason = 'Test';
            
            obj.rswPreferCode = acc1.IAM_Service_Provider_Code__c;
        	obj.rswAdditionalCode = acc2.IAM_Service_Provider_Code__c;
            obj.rswAdditionalCode1 = acc3.IAM_Service_Provider_Code__c;
            obj.rswAdditionalCode2 = acc4.IAM_Service_Provider_Code__c;
            obj.rswAdditionalCode3 = acc5.IAM_Service_Provider_Code__c;
            obj.rswAdditionalCode4 = acc6.IAM_Service_Provider_Code__c;
            obj.HighradiusFlag = false;
        	obj.validateDuplicateRSWSPCode(obj.rswPreferCode, obj.rswAdditionalCode, obj.rswAdditionalCode1, 
                                              obj.rswAdditionalCode2, obj.rswAdditionalCode3, obj.rswAdditionalCode4, system.label.IAM_ErrorMsg_Duplicate_SP_Code);
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            //System.assert(!obj.isRSWsection);
        //}
        Test.stopTest();
    }
    
    static testmethod void rswSubmitAppInvalidDataTest() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Pendig', '', '', '', 'Admin', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.rswReason = '';
            obj.rswOtherReason = 'Test';
            obj.rswPreferCode = '456';
            obj.rswAdditionalCode = '456';
            obj.rswAdditionalCode1 = '456';
            obj.rswAdditionalCode2 = '456';
            obj.rswAdditionalCode3 = '456';
            obj.rswAdditionalCode4 = '456';
            obj.HighradiusFlag = false;
            obj.submitApp();
            System.assert(obj.errorfound);
        //}
        Test.stopTest();
    }
    
    static testmethod void rswSubmitAppNoAppTest() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc = createAccountRSW();
        Contact con = createContact(acc.Id, 'Primary', false);
        /*IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Pending', '', '', '', 'Basic', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.rswReason = 'Other';
            obj.rswOtherReason = 'Test';
            Account acc1 = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
            obj.rswPreferCode = acc1.IAM_Service_Provider_Code__c;
            obj.HighradiusFlag = false;
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            //System.assert(!obj.isRSWsection);
        //}
        Test.stopTest();
    }
    
    static testmethod void rswSubmitAppNoAppTest1() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc = createAccountRSW();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = createAccountSubscription(acc.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Inactive', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Pending', '', '', '', 'Basic', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.rswReason = 'Other';
            obj.rswOtherReason = 'Test';
            Account acc1 = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
            obj.rswPreferCode = acc1.IAM_Service_Provider_Code__c;
            obj.HighradiusFlag = false;
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            //System.assert(!obj.isRSWsection);
        //}
        Test.stopTest();
    }
    
    static testmethod void rswSubmitAppNoAppTest2() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc = createAccountRSW();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = createAccountSubscription(acc.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Inactive', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Pending', '', '', '', 'Basic', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.rswReason = 'Other';
            obj.rswOtherReason = 'Test';
            Account acc1 = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
            obj.rswPreferCode = '';
            obj.HighradiusFlag = false;
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            //System.assert(!obj.isRSWsection);
        //}
        Test.stopTest();
    }
    
    static testmethod void cumpascheckApprovalsRedirectTest1() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Dealer User', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_RequestAccessController obj;
        //System.runAs(u) {
            
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            obj = new IAM_RequestAccessController(sc);
        //}
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.pendingappActive = true;
        obj.HighradiusFlag = false;
        obj.submitApp();
        obj.checkApprovalsRedirect();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        //System.assert(pageMessages.size() != 0); 
    }
    
    static testmethod void cumpascheckApprovalsRedirectTest2() {
        Test.startTest();
        Account acc = createAccount();
        createParContact(acc.Id, 'Primary', false);
        Contact con = createContact(acc.Id, 'Secondary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Dealer User', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_RequestAccessController obj;
        //System.runAs(u) {
            
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            obj = new IAM_RequestAccessController(sc);
        //}
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.HighradiusFlag = false;
        obj.submitApp();
        obj.checkApprovalsRedirect();
        obj.getlanguages();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        //System.assert(pageMessages.size() != 0); 
    }
    
    /* Initialization test */
    static testmethod void initializationTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = createAccount();
        createParContact(acc.Id, 'Primary', false);
        Contact con = createContact(acc.Id, 'Secondary', false);
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
        Test.startTest();
        obj.currentloginUser = new User();
        obj.con = new Contact();
        obj.acc = new Account();
        obj.lstContactApps = new List<IAM_Contact_Provisioning__c>();
        obj.lstAccApps = new List<IAM_Application__c>();
        obj.pendingappInactive = false;
        obj.pendingappactive = false;
        obj.pendingapp = false;
        obj.appToFinal = new IAM_Application__c();
        obj.conAppInsert = new IAM_Contact_Provisioning__c();
        obj.approverLocationadmin = '0031F00000T5EOtQAN';
        obj.approverInternalAdmin = '0031F00000T5EOtQAN';
        obj.pageRef = new PageReference('');
        obj.errorPostalcode = '';
        obj.HighRadiuscustomerNumber = '';
        obj.HighRadiuslanguage = '';
        obj.highRadiusInvoiceNo = '';
        obj.Language = '';        
        Test.stopTest();
    }
    
    /*static testmethod void parentInternalNLocationAdminTest() {
        Test.startTest();
        Account acc = createSevenLevelAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Dealer User', '');
        
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_RequestAccessController obj;            
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        obj = new IAM_RequestAccessController(sc);
        obj.submitApp();
        obj.checkApprovalsRedirect();       
        Test.stopTest();
    }*/
    
    /* Create and return IAM_Application__c record for given Account */
    public static IAM_Application__c createAccountSubscription(Id accId, String appName, String subName, Date stDate, 
        Date edDate, String subType, String source, String swExpire, String qsolExpire, String role, String licenseType, Boolean free) {
        IAM_Application__c obj = new IAM_Application__c();
        obj.IAM_Account_Name__c = accId;                
        obj.IAM_Subscription_Start_Date__c = stDate;
        obj.IAM_Subscription_End_Date__c = edDate;
        obj.IAM_Subscription_Count__c = 9999;
        obj.IAM_Application_Name__c = appName;
        obj.IAM_Role__c = role;
        if(appName == Label.IAM_Guidanz_Mobile_App_Name){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Guidanz_Mobile_Roles__c = role;
            obj.IAM_swregExpire__c = swExpire;
        }
        if(appName == Label.IAM_AppName_QSOL){
            System.debug('Printing Role Name for Guidanz mobile application');
            obj.IAM_Qsolexpiration__c = qsolExpire;
        }
        obj.IAM_Status__c = subType;
        obj.IAM_Subscription_Name__c = subName;
        obj.RecordtypeId = Schema.SObjectType.IAM_Application__c.getRecordTypeInfosByName().get(appName).getRecordTypeId();
        System.debug('#### Account access obj '+obj);
        //insert obj;
        return obj;
    }
    
    
    public static Account createAccount() {
        Account parAcc = createParentAccount();
        Account acc = new account();
        acc.ParentId = parAcc.Id;
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
        acc.IAM_Service_Provider_Code__c = '123';
        insert acc;
        return acc;
    }
    
    public static Account createParentAccount() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Parent Test Account';
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
        
        acc.Type = 'Distributor Account';
        acc.IAM_Service_Provider_Code__c = '234';
        insert acc;
        
        Contact con = new contact();
        con.AccountId = acc.Id;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'PFname';
        con.LastName = 'PLname';
        con.Email = 'pfnameplname@test.com';
        con.Username__c = 'pfnameplname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.IAM_Internal__c = true;
        insert con; 
        
        //updateUser(con.Username__c);
        return acc;
    }
    
    @future
    private static void updateUser(String username) {
        User u = [SELECT Id, IAM_Final_Approver__c FROM User WHERE Username = :username];
        u.IAM_Final_Approver__c = 'Y';
        update u;
    }
    
    /* Create test contact data */
    public static Contact createContact(Id accId, string contactType, Boolean isInternal) {
        Contact con = new contact();
        con.AccountId = accId;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = contactType;
        con.IAM_Internal__c = isInternal;
        insert con;
        return con;
    }
    
    /* Create test contact data */
    public static Contact createParContact(Id accId, string contactType, Boolean isInternal) {
        Contact con = new contact();
        con.AccountId = accId;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'FnamePar';
        con.LastName = 'LnamePar';
        con.Email = 'parfnamelname@test.com';
        con.Username__c = 'parfnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = contactType;
        con.IAM_Internal__c = isInternal;
        insert con;
        return con;
    }
    
    public static Account createAccountRSW() {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
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
        acc.IAM_Service_Provider_Code__c = '123';
        insert acc;
        return acc;
    }
    
        public static Account createAccountRSW1(String customerCode) {
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.CMI_Account_Status__c = 'Active';
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
        acc.IAM_Service_Provider_Code__c = customerCode;
        insert acc;
        return acc;
    }
    
    private static Account createSevenLevelAccount() {
        Account acc8 = createAcc('VWX Acc 8', null);
        Account acc7 = createAcc('ABC Acc 7', acc8.Id);
        Account acc6 = createAcc('DEF Acc 6', acc8.Id);
        Account acc5 = createAcc('GHI Acc 5', acc8.Id);
        Account acc4 = createAcc('JKL Acc 4', acc8.Id);
        Account acc3 = createAcc('MNO Acc 3', acc8.Id);
        Account acc2 = createAcc('PQR Acc 2', acc8.Id);
        //Account acc1 = createAcc('STU Acc 1', acc8.Id); 
        
        /*Contact con = new contact();
        con.AccountId = acc8.Id;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'PFname';
        con.LastName = 'PLname';
        con.Email = 'pfnameplname@test.com';
        con.Username__c = 'pfnameplname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.CMI_Contact_Type__c = 'Primary';
        con.IAM_Internal__c = true;
        insert con; 
        
        updateUser(con.Username__c);*/
               
        return acc2;
    }
    
    private static Account createAcc(String accName, Id parentId) {
        Account acc = new Account();
        acc.ParentId = parentId;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = accName;
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
        if(parentID!=null){
            acc.Type = 'Dealer Account';
        }else{
            acc.Type = 'Distributor Account';
        }
        //acc.IAM_Service_Provider_Code__c = '12398';
        insert acc;
        System.debug('#### Acc - '+acc.Id+ ' - Name - ' + acc.Name +' - parentId - ' + acc.ParentId);
        return acc;
    }
    
    //added @Anupam RSW change
    static testmethod void rswSubmitAppNotAppTest() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        //Account acc = createAccountRSW();
        Account acc = createAcc('Test Parent Acc', null);
        Account accParent = createAcc('Test Parent Acc', acc.Id);
        accParent.IAM_Service_Provider_Code__c = '12398';
        update accParent;
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(accParent.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Pendig', '', '', '', 'Admin', '');*/
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.rswReason = 'Other';
            obj.rswOtherReason = 'Test';
            Account acc1 = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :accParent.Id];
            obj.rswPreferCode = acc1.IAM_Service_Provider_Code__c;
            obj.HighradiusFlag = false;
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            //System.assert(!obj.isRSWsection);
        //}
        Test.stopTest();
    }

    //added @Anupam GDP change
    static testmethod void gdpSubmitAppTest() {
        App_Mapping__c app = IAM_TestData.getGDPApp();
        app.IAM_Skip_Contact_Type_Check__c = true;
        update app;
        //Account acc = createAccountRSW();
        Account acc = createAcc('Test Parent Acc', null);
        Contact con = createContact(acc.Id, 'Primary', false);
        
        Test.startTest();
        //System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            //obj.rswReason = 'Other';
            //obj.rswOtherReason = 'Test';
            //Account acc1 = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :accParent.Id];
            //obj.rswPreferCode = acc1.IAM_Service_Provider_Code__c;
            obj.HighradiusFlag = false;
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            System.assert(!obj.isRSWsection);
        //}
        Test.stopTest();
    }
    /* Guidanz Service Portal Test Case With FSL Customer Code Account Available */
    static testmethod void guidanzServicePortalTest1() {
        App_Mapping__c app = IAM_TestData.getGuiServicePortalApp();
        Account accGuidanz = IAM_TestData.createAccountWithFSLCustomerCode();
        Contact con = IAM_TestData.createContact(accGuidanz.Id);
        
        Test.startTest();
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            Account acc = new Account();
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
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
            acc.FSL_ERP_Customer_Code__c = '123456';
            Account acc1 = [SELECT FSL_ERP_Customer_Code__c FROM Account WHERE Id = :accGuidanz.Id];
            obj.erpCustomerCode = '123456';
        	
        	obj.acc=acc;
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Test.stopTest();
    }

    /* Guidanz Service Portal Test Case Where FSL Customer Code Account Not Available */
    static testmethod void guidanzServicePortalTest2() {
        App_Mapping__c app = IAM_TestData.getGuiServicePortalApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);        
        Test.startTest();
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Test.stopTest();
    }

    /* Guidanz Service Portal Test Case With FSL Customer Code Account Available & Account
    Provisioning Present For GSP app */
    static testmethod void guidanzServicePortalTest3() {
        App_Mapping__c app = IAM_TestData.getGuiServicePortalApp();
        Account acc = IAM_TestData.createAccountWithFSLCustomerCode();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accApp = IAM_TestData.createAccountSubscription(acc.Id, Label.IAM_AppName_GuidanzServicePortal,
        'General User', con);
        Test.startTest();
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            Account acc1 = [SELECT FSL_ERP_Customer_Code__c FROM Account WHERE Id = :acc.Id];
            obj.erpCustomerCode = acc1.FSL_ERP_Customer_Code__c;
            obj.acc=acc1;
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Test.stopTest();
    }
    
     static testmethod void powerSpecSubmitAppNoAppTest() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
         IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'PowerSpec', 'PowerSpec', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'PowerSpec_Basic', '', true);
            insert accAccessObj;
        App_Mapping__c app = IAM_TestData.getPoweSpecApp();
        IAM_RequestAccessController obj;            
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        obj = new IAM_RequestAccessController(sc);
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.isPowerSpecFlag = true;
        obj.errorfound = false;
        obj.occList = 'Cummins Distributor';
        obj.companyName = 'Test Company';
        obj.submitApp();  
        obj.determineChannelAdmin();    
    }
    static testmethod void powerSpecSubmitAppNoAppTest2() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Secondary', false);
        App_Mapping__c app = IAM_TestData.getPoweSpecApp();
        IAM_RequestAccessController obj;            
        PageReference pg = Page.IAM_Request_Access;        
        Test.setCurrentPage(pg);            
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
        ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
        obj = new IAM_RequestAccessController(sc);
        //Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.isPowerSpecFlag = true;
        obj.occList = '';
        obj.companyName = 'Test Company';
        obj.submitApp();
        obj.determineChannelAdmin();
        
        Test.stopTest();
    }    
    
    static testmethod void powerspecRequestAppTest() {
        App_Mapping__c app = IAM_TestData.getPoweSpecApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'PowerSpec', 'PowerSpec', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'PowerSpec_Basic', '', true);
        insert accAccessObj;
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'PowerSpec', 'PowerSpec', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'PowerSpec_Basic', '');
        //User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            ApexPages.CurrentPage().getParameters().put('uid',con.Username__c);
            obj.HighradiusFlag = false;
            obj.isPowerSpecFlag = true;
            obj.errorfound = false;
            obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Test.stopTest();
    }   
     
    static testmethod void powerspecRequestAppTestWithoutAccountFeatureAccess() {
        App_Mapping__c app = IAM_TestData.getPoweSpecApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        Test.startTest();
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPAges.CurrentPage().getParameters().put('uid',con.Username__c);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            ApexPages.CurrentPage().getParameters().put('uid',con.Username__c);
            obj.HighradiusFlag = false;
            obj.isPowerSpecFlag = true;
            obj.errorfound = false;
			obj.occList='Cummins Distributor';
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
        Test.stopTest();
    }
}