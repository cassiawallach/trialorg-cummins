@IsTest(seeAllData= false)
private class Css_ShareJobsToUserBatch_Test {
    static testmethod void TestBatch() {
        String query='Select Id,User_Location__c,LastName FROM User where createdDate = TODAY';
        system.debug('**-->query<--**'+query);
        UserRole empRole = [Select Id From UserRole Where Name = 'Factory' Limit 1];
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User objUser1 = new User(Alias = 'cmi-u1', Email='Testusercss-cmi1@cummins.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId = empRole.id,isActive=true, TimeZoneSidKey='America/Los_Angeles', UserName='css-cmi1@cummins.com'+ System.currentTimeMillis(),CompanyName = 'TESTData', User_Location__c='56270-56270');
        insert objUser1;
       
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        
        User objUser2 = new User(Alias = 'cmi-u1', Email='css-cmi12@cummins.com',
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p1.Id,UserRoleId = empRole.id,isActive=true, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='testcss-cmi12@cummins.com'+ System.currentTimeMillis(),CompanyName = 'TEST',User_Location__c='56270-56270');
        insert objUser2;
        
        user user1 =[Select Id,User_Location__c FROM User  where id = : objUser2.Id ];
        user1.User_Location__c = '56270-56255';
        update user1;
        //String query='Select Id,User_Location__c,LastName FROM User  where id=:user1.id ';
        system.debug('User Location>>>'+user1.User_Location__c);
        //Test.startTest();
        System.runAs(objUser1) {
            
            CSS_Job_Order__c jobOrder=  CSS_TestData.createJobOrder(true);
            system.debug('**-->Creator_Location__c<--**'+jobOrder.Creator_Location__c);
            CSS_Job_Order__c c = [select Creator_Location__c from CSS_Job_Order__c where CSS_Job_Location_Code__c='56270-56255' limit 1];
            system.debug('**-->Creator_Location__c<--**'+c.Creator_Location__c);
            system.debug('**-->CSS_Job_Location_Code__c<--**'+jobOrder.CSS_Job_Location_Code__c);
            Test.startTest();
            Css_ShareJobsToUserBatch shareJobBatch=new Css_ShareJobsToUserBatch(query);
            ID batchprocessid = Database.executeBatch(shareJobBatch);
            Test.stopTest();
        }
        
        user1.User_Location__c = '56270-56270';
        update user1;
        system.debug('User Location>>>'+user1.User_Location__c);
        //Test.startTest();
        System.runAs(objUser1) {
            CSS_Job_Order__c jobOrder=  CSS_TestData.createJobOrder(true);
        }
    }
}