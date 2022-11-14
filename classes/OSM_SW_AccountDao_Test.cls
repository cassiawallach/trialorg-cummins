@isTest
private class OSM_SW_AccountDao_Test {

    private static testMethod void test() {
        
    
    
        Profile ObjProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Profile objPortalProf = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1];
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        
        User objUser = new User(FirstName ='test12', 
                                Lastname ='12345',
                                Alias = '0test12', 
                                localesidkey='en_US',
                                emailencodingkey='UTF-8',
                                languagelocalekey='en_US',
                                profileId = ObjProfile.Id,
                                UserRoleId = portalRole.Id,
                                Email ='test123@noemail.com',
                                username ='test012345@noemail.com',
                                timezonesidkey='America/Los_Angeles');
        insert objUser;
        
        Account objAccount = new Account(Name = 'Test Account', Type = 'Distributor Account');
        
        System.runAs(objUser){
            insert objAccount;
        }
        
        Contact objContact = new Contact(FirstName = 'Test', 
                                         LastName = 'Contact', 
                                         AccountId = objAccount.Id, 
                                         IAM_Contact_Owner__c = userinfo.getUserId(),
                                         Username__c='jsawpuzzle@gmail.com.stg',
                                         IAM_Cummins_login_ID__c = userinfo.getName());
                                         //IAM_Cummins_login_ID__c = 'Rupesh Ranjan');
        
        System.runAs(objUser){
            insert objContact;
        }
        
        User portalUser = new User(isActive = true,
                                   Alias = 'batman',
                                   LastName = 'lasttt',
                                   FirstName = 'Testttt',
                                   LocaleSidKey = 'en_US',
                                   ContactId = objContact.Id,
                                   UserName = 'test2@test.com',
                                   LanguageLocaleKey = 'en_US',
                                   ProfileId = objPortalProf.Id,
                                   EmailEncodingKey = 'ISO-8859-1',
                                   CommunityNickname = 'test12345Q',
                                   TimeZoneSidKey = 'America/Los_Angeles',
                                   Email = 'bruce.wayne@wayneenterprises.com');
    
        System.runAs(objUser) {
            insert portalUser;
        }
        
        System.runAs(portalUser) {
            
            Test.startTest();
            
            OSM_SW_AccountDao.getAccountsHierarchy(objAccount.Id);
            OSM_SW_AccountDao.getAListOfAccount(new Set<String> {objAccount.Id});
            OSM_SW_AccountDao.getDistributorAccountsHierarchy(objAccount.Id);
            OSM_SW_AccountDao.getDistributorAdminAccountRelateData(objAccount.Id);
			OSM_SW_AccountDao.getParentAccount(objAccount.Id);            
            Test.stopTest();
            
        }
    }

}