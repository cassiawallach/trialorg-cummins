@isTest
private class IAM_forgotpasswordController_test {
    /* Redirect forget username test */
    static testmethod void redirectForgetUsernameTest() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = IAM_TestData.createContact(acc.Id);
        //User u = IAM_TestData.createUser(con, acc, 'IAM_Admin_User');
        System.debug('#### USER - '+[SELECT Name FROM User WHERE Username = :con.Username__c]);
        Test.startTest();
        
        PageReference pg = Page.IAM_forgotpassword;        
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('username', con.Username__c);
        IAM_forgotpasswordController obj = new IAM_forgotpasswordController();
        PageReference pgRef = obj.redirectForgorUsernamepage();
        System.assert(String.isBlank(obj.errorContactEmail));
        System.assert(pgRef != null);  
        Test.stopTest();
            }
    }
    
    /* Invalid username test 1 without @ */
    static testmethod void invalidUsernameTest1() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        PageReference pg = Page.IAM_forgotpassword;        
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('username', 'abacabc');
        IAM_forgotpasswordController obj = new IAM_forgotpasswordController();
        PageReference pgRef = obj.redirectForgorUsernamepage();
        //System.assert(String.isBlank(obj.errorContactEmail));
        //System.assert(pgRef != null);
        Test.stopTest();
    }
    
    /* Invalid username test 2 with @ */
    static testmethod void invalidUsernameTest2() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        PageReference pg = Page.IAM_forgotpassword;        
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('username', 'abac@abc');
        IAM_forgotpasswordController obj = new IAM_forgotpasswordController();
        PageReference pgRef = obj.redirectForgorUsernamepage();
        System.assert(String.isNotBlank(obj.errorContactEmail));
        System.assert(pgRef == null);
        Test.stopTest();
    }
    
    /* Blank username test */
    static testmethod void blankUsernameTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        PageReference pg = Page.IAM_forgotpassword;        
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('username', '');
        IAM_forgotpasswordController obj = new IAM_forgotpasswordController();
        PageReference pgRef = obj.redirectForgorUsernamepage();
        //System.assert(String.isNotBlank(obj.errorContactEmail));
        //System.assert(pgRef != null);
        Test.stopTest();
    }
    
    /* User does not exist test */
    static testmethod void userDoesNotExistTest() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id);
        Test.startTest();
        PageReference pg = Page.IAM_forgotpassword;        
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('username', con.Username__c);
        IAM_forgotpasswordController obj = new IAM_forgotpasswordController();
        PageReference pgRef = obj.redirectForgorUsernamepage();
        System.assert(String.isNotBlank(obj.errorContactEmail));
        System.assert(pgRef == null);
        Test.stopTest();
    }
    
    /* Cancel redirect test - lang != null */
    static testmethod void redirectCancelTest1() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();        
        Test.startTest();
        PageReference pg = Page.IAM_forgotpassword;        
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('lang', 'en');
        IAM_forgotpasswordController obj = new IAM_forgotpasswordController();
        PageReference pgRef = obj.redirectCancelpage();
        System.assert(pgRef != null);
        Test.stopTest();
    } 
    
    /* Cancel redirect test - lang = null */
    static testmethod void redirectCancelTest2() {
        App_Mapping__c app = IAM_TestData.getCumpasApp();        
        Test.startTest();
        PageReference pg = Page.IAM_forgotpassword;        
        Test.setCurrentPage(pg);
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('lang', null);
        IAM_forgotpasswordController obj = new IAM_forgotpasswordController();
        obj.resourceurl = '';
        obj.en = '';
        PageReference pgRef = obj.redirectCancelpage();
        System.assert(pgRef != null);
        Test.stopTest();
    }
    
    /* Create test contact data */
    public static Contact createContact(Id accId) {
        Contact con = new contact();
        con.AccountId = accId;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Pending';
        insert con;
        return con;
    }
}