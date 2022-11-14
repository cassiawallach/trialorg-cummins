@isTest
private class OSM_ccLogicUserGetProfileDataCustom_Test {

    private static testMethod void contactData() {
        
        Profile ObjProfile = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        User objUser = new User(FirstName ='test0', 
                                Lastname ='123450',
                                Alias = 'test120', 
                                localesidkey='en_US',
                                emailencodingkey='UTF-8',
                                languagelocalekey='en_US',
                                profileId = ObjProfile.Id,
                                Email ='test120@noemail.com',
                                username ='test001@noemail.com',
                                timezonesidkey='America/Los_Angeles',
                               OSM_Storefront_User_Type__c='Distributor Admin');
        insert objUser;
        
        PermissionSet objPS = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Distributor_Admin'];
        
        PermissionSetAssignment objPSA = new PermissionSetAssignment(AssigneeId = objUser.Id,
                                                                     PermissionSetId = objPS.Id);
        insert objPSA;
        
        System.runAs(objUser){
            effectiveAccount_enable_ProfileUserType__c eff = new effectiveAccount_enable_ProfileUserType__c();
            eff.Name='Distributor Admin';
            eff.Enable_Effective_Account_Selection__c = true;
            insert eff;
            
            Account objAccount = new Account(Name = 'Test Account');
            insert objAccount;
            
            Contact objContact = new Contact(FirstName = 'Test', 
                                             LastName = 'Contact', 
                                             AccountId = objAccount.Id, 
                                             IAM_Contact_Owner__c = userinfo.getUserId(),
                                             Username__c ='testusernamerunning@gmail.com' );
            insert objContact;
            
            Test.startTest();
            
            OSM_ccLogicUserGetProfileDataCustom objHand = new OSM_ccLogicUserGetProfileDataCustom();
            objHand.getAccountData(new Map<String, Object>{'usrDataMap' => new Map<String, Object>{'accountId' => null}, 'version' => 1} );
            objHand.getContactData(new Map<String, Object>{'usrDataMap' => new Map<String, Object>{'contactId' => null}, 'version' => 1} );
            objHand.decorateContactData(new Map<String, Object>{'usrContact' => new Map<String, Object>{'contactId' => objContact}} );
            
            Test.stopTest();
        }
    }

}