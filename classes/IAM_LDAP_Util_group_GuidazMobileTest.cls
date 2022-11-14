/* Test class for IAM_LDAP_Util_group_GuidazMobile. Currently not in use */
@isTest
public class IAM_LDAP_Util_group_GuidazMobileTest {
    static testmethod void invokeApexCalloutTest1() {
        Test.startTest();
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(new List<IAM_Contact_Provisioning__c>());
        Test.stopTest();
    }
    
    /*
    static testmethod void invokeApexCalloutTest11() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, false, false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile Service Dealer');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
        Date.today()+200, 'Active', 'SwReg', 'IAM/11/09/2020', '', 'Guidanz Mobile Service Dealer', '');
        List<IAM_Contact_Provisioning__c> conProList = [SELECT Id, Name, IAM_Contact__r.IAM_Contact_Status__c, IAM_Contact__r.IAM_Legacy_User__c, IAM_Contact__r.IAM_Internal__c, IAM_Status__c FROM IAM_Contact_Provisioning__c
                                                       WHERE IAM_Application_Name__c = 'Guidanz Mobile'];
        
        Test.startTest();
        updateUser(con.Username__c);        
        Test.stopTest();
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(conProList);
        }
    }
    
    static testmethod void invokeApexCalloutTest2() {
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, true, false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile Service Dealer');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
        Date.today()+200, 'Active', 'SwReg', 'IAM/11/09/2020', '', 'Guidanz Mobile Service Dealer', '');
        List<IAM_Contact_Provisioning__c> conProList = [SELECT Id, Name, IAM_Contact__r.IAM_Contact_Status__c, IAM_Contact__r.IAM_Legacy_User__c, IAM_Contact__r.IAM_Internal__c, IAM_Status__c FROM IAM_Contact_Provisioning__c
                                                       WHERE IAM_Application_Name__c = 'Guidanz Mobile'];
        Test.startTest();
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(conProList);
        Test.stopTest();
    }
    
    static testmethod void invokeApexCalloutTest21() {
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, true, true);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile Service Dealer');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
        Date.today()+200, 'Active', 'SwReg', 'IAM/11/09/2020', '', 'Guidanz Mobile Service Dealer', '');
        List<IAM_Contact_Provisioning__c> conProList = [SELECT Id, Name, IAM_Contact__r.IAM_Contact_Status__c, IAM_Contact__r.IAM_Legacy_User__c, IAM_Contact__r.IAM_Internal__c, IAM_Status__c FROM IAM_Contact_Provisioning__c
                                                       WHERE IAM_Application_Name__c = 'Guidanz Mobile'];
        Test.startTest();
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(conProList);
        Test.stopTest();
    }
    
    static testmethod void invokeApexCalloutTest4() {
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, false, false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile Service Dealer');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
        Date.today()+200, 'Inactive', 'SwReg', 'IAM/11/09/2020', '', 'Guidanz Mobile Service Dealer', '');
        List<IAM_Contact_Provisioning__c> conProList = [SELECT Id, Name, IAM_Contact__r.IAM_Contact_Status__c, IAM_Contact__r.IAM_Legacy_User__c, IAM_Contact__r.IAM_Internal__c, IAM_Status__c FROM IAM_Contact_Provisioning__c
                                                       WHERE IAM_Application_Name__c = 'Guidanz Mobile'];
        Test.startTest();
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(conProList);
        Test.stopTest();
    }
    
    static testmethod void invokeApexCalloutTest41() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, false, false);        
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile Service Dealer');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
        Date.today()+200, 'Inactive', 'SwReg', 'IAM/11/09/2020', '', 'Guidanz Mobile Service Dealer', '');
        List<IAM_Contact_Provisioning__c> conProList = [SELECT Id, Name, IAM_Contact__r.IAM_Contact_Status__c, IAM_Contact__r.IAM_Legacy_User__c, IAM_Contact__r.IAM_Internal__c, IAM_Status__c FROM IAM_Contact_Provisioning__c
                                                       WHERE IAM_Application_Name__c = 'Guidanz Mobile'];
        Test.startTest();
        updateUser(con.Username__c);        
        Test.stopTest();
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(conProList);
        }
    }
    
    static testmethod void invokeApexCalloutTest5() {
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, true, false);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile Service Dealer');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
        Date.today()+200, 'Inactive', 'SwReg', 'IAM/11/09/2020', '', 'Guidanz Mobile Service Dealer', '');
        List<IAM_Contact_Provisioning__c> conProList = [SELECT Id, Name, IAM_Contact__r.IAM_Contact_Status__c, IAM_Contact__r.IAM_Legacy_User__c, IAM_Contact__r.IAM_Internal__c, IAM_Status__c FROM IAM_Contact_Provisioning__c
                                                       WHERE IAM_Application_Name__c = 'Guidanz Mobile'];
        Test.startTest();
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(conProList);
        Test.stopTest();
    }
    
    static testmethod void invokeApexCalloutTest6() {
        Account acc = IAM_TestData.createAccount();
        Contact con = createContact(acc.Id, true, true);
        IAM_Application__c accAccessObj = IAM_TestData.createAccountSubscription(acc.Id, 'Guidanz Mobile', 'Guidanz Mobile Service Dealer');
        IAM_TestData.createUserSubscription(con.Id, accAccessObj.Id, 'Guidanz Mobile', 'Guidanz Mobile', Date.today(),
        Date.today()+200, 'Inactive', 'SwReg', 'IAM/11/09/2020', '', 'Guidanz Mobile Service Dealer', '');
        List<IAM_Contact_Provisioning__c> conProList = [SELECT Id, Name, IAM_Contact__r.IAM_Contact_Status__c, IAM_Contact__r.IAM_Legacy_User__c, IAM_Contact__r.IAM_Internal__c, IAM_Status__c FROM IAM_Contact_Provisioning__c
                                                       WHERE IAM_Application_Name__c = 'Guidanz Mobile'];
        Test.startTest();
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(conProList);
        Test.stopTest();
    }
    
    static testMethod void failureTest() {
        List<IAM_Contact_Provisioning__c> conProList;
        IAM_LDAP_Util_group_GuidazMobile.invokeapexcallout_GM(conProList);
    }

     Create test contact data 
    public static Contact createContact(Id accId, Boolean legacyUser, Boolean internal) {
        Contact con = new contact();
        con.AccountId = accId;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelname@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.IAM_Legacy_User__c = legacyUser;
        con.IAM_Internal__c = internal;
        insert con;
        return con;
    }
    
    @future
    private static void updateUser(String username) {
        List<User> u = [SELECT Id, IAM_UID__c FROM User WHERE Username = :username];
        if(!u.isEmpty()) {
            u[0].IAM_UID__c = 'uidfnamelname@test.com';
            update u[0];
        }
    }*/
}