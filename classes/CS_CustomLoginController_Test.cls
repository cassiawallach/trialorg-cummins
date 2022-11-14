@isTest
private class CS_CustomLoginController_Test {

    static testMethod void dologin() 
    {     
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
            User testUser = new User(Alias = 'kal2', Email='standarduser11@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='kal12', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='kal10@testorg.com', user_Location__c = '56270-56270');
            insert(testUser);
       CS_CustomLoginController controller = new CS_CustomLoginController();     
       
       controller.username = 'swift@gmail.com';
       controller.password = 'test4567';

       controller.dologin();
       controller.redirect();
         controller.u = testUser;
        
       
    }
}