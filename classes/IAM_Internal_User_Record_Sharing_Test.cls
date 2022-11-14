/* Test class called on creation/updation of User */

@isTest
public class IAM_Internal_User_Record_Sharing_Test {
    
    /* Create User Test */
    static testmethod void createUserTest() { 
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = createAccount();
            Account accParent = [SELECT Id, Name FROM Account WHERE Id = :acc.ParentId];
            Contact con = createContact(accParent.Id, true, true);
            User usr = createUser(con, accParent, 'IAM_Distributor_User');
            //Contact con = IAM_TestData.createContact(accParent.Id);
            User usr1 = [SELECT Id, UserRoleName__c, User_Role__c FROM User WHERE Id = :usr.Id];
            System.debug('#### usr1 role '+ usr1.UserRoleName__c);
            System.debug('#### usr1 role '+ usr1.User_Role__c);
            //IAM_Internal_User_Record_Sharing.createAccountShareRecords(accParent.Name, usr.Id);
        }
    }
    
    /* Update User Test */
    static testmethod void updateUserTest() { 
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator'
                  AND UserRoleId != null AND IsActive = true LIMIT 1];
        System.runAs(u) {
            Account acc = createAccount();
            Account accParent = [SELECT Id, Name FROM Account WHERE Id = :acc.ParentId];
            Contact con = createContact(accParent.Id, true, true);
            User usr = createUser(con, accParent, 'IAM_Distributor_User');
            UserRole role = [SELECT Id, DeveloperName FROM UserRole WHERE DeveloperName ='DFSE_CUMMINS_EASTERN_CANADA'];
            User selUser = [SELECT UserRoleId FROM User WHERE Id =: usr.Id];
            selUser.UserRoleId = role.Id;
            update selUser;
        }
    }
    
    /* Return test account data */
    private static Account createAccount() {
        Account parentAcc = createParentAccount();
        Account acc = new account();
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        acc.name = 'Test Account';
        acc.parentid = parentAcc.Id;
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
        acc.IAM_Internal_Account__c = true;
        insert acc;        
        return [SELECT Id, Name, IAM_Service_Provider_Code__c FROM Account WHERE Id = :acc.Id];
    }
    
    /* Create test contact data */
    public static Contact createContact(Id accId, Boolean legacyUser, Boolean internal) {
        Contact con = new contact();
        con.AccountId = accId;
        con.RecordTypeId = Schema.SObjectType.contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId();
        con.FirstName = 'Fname';
        con.LastName = 'Lname';
        con.Email = 'fnamelname@test.com';
        con.Username__c = 'fnamelnameunique1@test.com';
        con.phone = '1112223335';
        con.IAM_Contact_Status__c = 'Active';
        con.IAM_Legacy_User__c = legacyUser;
        con.IAM_Internal__c = internal;
        con.CMI_Contact_Type__c = 'Primary';
        insert con;
        return con;
    }
    
    /* Create User */
    public static User createUser(Contact con, Account acc, String profileName) {
        List<profile> pf = [select Id,Name from Profile WHERE Name = :profileName limit 1];
        User newUser = new User();
        newUser.FirstName = con.FirstName;
        newUser.LastName = con.LastName;
        newUser.Email = con.Email;   
        newUser.CompanyName = acc.Name;        
        newUser.CommunityNickname = 'tts';
        newUser.Username = con.Username__c ;
        newUser.Alias = 'tts';
        newUser.TimeZoneSidKey = 'GMT';
        newUser.LocaleSidKey= 'en_US';
        newUser.EmailEncodingKey = 'UTF-8';
        newUser.LanguageLocaleKey = 'en_US';         
        newUser.ProfileId = pf[0].Id ;                                  
        //newUser.ContactId = con.Id;                   
        newUser.isActive = true;
        newUser.Street = '123 Test St';
        newUser.FederationIdentifier = '2468741';
        insert newUser;
        return newUser;
    }
}