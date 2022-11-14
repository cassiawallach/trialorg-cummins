@isTest
private class IAM_RequestAccessControllerTest {
    static testmethod void cumpasAppRequestActiveAppTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Dealer User', '');
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            //obj.requestApp();
            System.assert(obj.conAppActive);
        }
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
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            //obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            System.assert(obj.conAppPending);
        }
        Test.stopTest();
    }
    
    static testmethod void cumpasAppRequestNoAppTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            //obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
        }
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
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            //obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            System.assert(obj.conAppPending);
        }
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
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            //obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            System.assert(obj.isRSWsection);
        }
        Test.stopTest();
    }
    
    static testmethod void gmAppReqActiveAppPrimaryTest() {
        App_Mapping__c app = IAM_TestData.getGuidanzMobileApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        /*IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile User');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Guidanz Mobile User', '');*/
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            //obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
        }
        Test.stopTest();
    }
    
    static testmethod void gmAppReqActiveAppSecondaryTest() {
        App_Mapping__c app = IAM_TestData.getGuidanzMobileApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, 'Secondary', false);
        /*IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile User');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Guidanz Mobile User', '');*/
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            //obj.requestApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
        }
        Test.stopTest();
    }
    
    static testmethod void cumpasSubmitAppNoAppTest() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_RequestAccessController obj;
        System.runAs(u) {
            
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            obj = new IAM_RequestAccessController(sc);
        }
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
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
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
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
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            System.assert(!obj.isRSWsection);
        }
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
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
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
            obj.submitApp();
            System.assert(obj.errorfound);
        }
        Test.stopTest();
    }
    
    static testmethod void rswSubmitAppNoAppTest() {
        App_Mapping__c app = IAM_TestData.getRSWApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        /*IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Rapid Serve Web', 'Rapid Serve Web', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Basic', '', true);
        insert accAccessObj;
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Pendig', '', '', '', 'Admin', '');*/
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        Test.startTest();
        System.runAs(u) {
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            IAM_RequestAccessController obj = new IAM_RequestAccessController(sc);
            obj.rswReason = 'Other';
            obj.rswOtherReason = 'Test';
            Account acc1 = [SELECT IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
            obj.rswPreferCode = acc1.IAM_Service_Provider_Code__c;
            obj.submitApp();
            ApexPages.Message[] pageMessages = ApexPages.getMessages();
            System.assert(pageMessages.size() != 0);
            //System.assert(!obj.isRSWsection);
        }
        Test.stopTest();
    }
    
    static testmethod void cumpascheckApprovalsRedirectTest1() {
        Test.startTest();
        Account acc = createAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Dealer User', '');*/
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_RequestAccessController obj;
        System.runAs(u) {
            
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            obj = new IAM_RequestAccessController(sc);
        }
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.pendingappActive = true;
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
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_RequestAccessController obj;
        System.runAs(u) {
            
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            obj = new IAM_RequestAccessController(sc);
        }
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.submitApp();
        obj.checkApprovalsRedirect();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        System.assert(pageMessages.size() != 0); 
    }
    
    static testmethod void parentInternalNLocationAdminTest() {
        Test.startTest();
        Account acc = createSevenLevelAccount();
        Contact con = createContact(acc.Id, 'Primary', false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'CUMPAS 2.0', 'Dealer User');
        /*IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'CUMPAS 2.0', 'CUMPAS', Date.today(),
            Date.today()+365, 'Active', '', '', '', 'Dealer User', '');*/
        User u = [SELECT Id, Name FROM User WHERE username = :con.Username__c];
        
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        IAM_RequestAccessController obj;
        System.runAs(u) {
            
            PageReference pg = Page.IAM_Request_Access;        
            Test.setCurrentPage(pg);            
            ApexPages.currentPage().getParameters().put('appid',app.Id);
            ApexPages.StandardController sc = new ApexPages.StandardController(new IAM_Application__c());
            obj = new IAM_RequestAccessController(sc);
        }
        Test.stopTest();
        /* This is written after Test.stopTest because before excuting this method we need 
        to execute the future method updateUser */
        obj.submitApp();
        obj.checkApprovalsRedirect();
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        //System.assert(pageMessages.size() != 0); 
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
    
    private static Account createSevenLevelAccount() {
        Account acc8 = createAcc('VWX Acc 8', null);
        Account acc7 = createAcc('ABC Acc 7', acc8.Id);
        Account acc6 = createAcc('DEF Acc 6', acc7.Id);
        Account acc5 = createAcc('GHI Acc 5', acc6.Id);
        Account acc4 = createAcc('JKL Acc 4', acc5.Id);
        Account acc3 = createAcc('MNO Acc 3', acc4.Id);
        Account acc2 = createAcc('PQR Acc 2', acc3.Id);
        Account acc1 = createAcc('STU Acc 1', acc2.Id); 
        
        Contact con = new contact();
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
        
        //updateUser(con.Username__c);
               
        return acc1;
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
        
        acc.Type = 'Dealer Account';
        //acc.IAM_Service_Provider_Code__c = '123';
        insert acc;
        System.debug('#### Acc - '+acc.Id+ ' - Name - ' + acc.Name +' - parentId - ' + acc.ParentId);
        return acc;
    }
}