@isTest
private class OSM_SW_ccServiceContact_Test {

    private static testMethod void test() {
        
        Profile ObjProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User objUser = new User(FirstName ='test', 
                                Lastname ='12345',
                                Alias = 'test123', 
                                localesidkey='en_US',
                                emailencodingkey='UTF-8',
                                languagelocalekey='en_US',
                                profileId = ObjProfile.Id,
                                Email ='test123@noemail.com',
                                username ='test01@noemail.com',
                                OSM_Storefront_User_Type__c='Regular',
                                timezonesidkey='America/Los_Angeles');
        insert objUser;
        
        PermissionSet objPS = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Distributor_Admin'];
        
        PermissionSetAssignment objPSA = new PermissionSetAssignment(AssigneeId = objUser.Id,
                                                                     PermissionSetId = objPS.Id);
        insert objPSA;
        
        System.runAs(objUser){
            
            Test.startTest();
            
            Account objAccount = new Account(Name = 'Test Account');
            insert objAccount;
            
            Contact objContact = new Contact(FirstName = 'Test', 
                                             LastName = 'Contact', 
                                             AccountId = objAccount.Id, 
                                             IAM_Contact_Owner__c = userinfo.getUserId(),
                                             Username__c = 'test776@gmail.com');
            insert objContact;
            effectiveAccount_enable_ProfileUserType__c effAccProfType = new effectiveAccount_enable_ProfileUserType__c();
            effAccProfType.Name='Regular';
            effAccProfType.Enable_Effective_Account_Selection__c = true;
            insert effAccProfType;
            OSM_SW_ccServiceContact objHand = new OSM_SW_ccServiceContact();
            objHand.getFilterMap(new Map<String, Object>());
            
            Test.stopTest();
        }
        
    }

}