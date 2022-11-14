@isTest 
public class CSS_scheduledShareJobsToUserBatchTest {

    static TestMethod void testScheduler() {
        CSS_scheduledShareJobsToUserBatch  schClass = new CSS_scheduledShareJobsToUserBatch ();
        String runTime = '0 0 23 * * ?';
        

      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator' LIMIT 1];
         UserRole ur = [SELECT id from UserRole WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User(Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, User_Location__c = '03742-02991',
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        insert newUser;

        Test.startTest();
        System.schedule('Test Schedule', runTime, schClass);
        Test.stopTest();
    }

}