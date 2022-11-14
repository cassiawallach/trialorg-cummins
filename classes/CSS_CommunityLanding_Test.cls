@IsTest(seealldata = true)
public class CSS_CommunityLanding_Test {
    static testMethod void CSS_Job_Detail_Test_Method1()
    {
        Test.startTest();
        CSS_CommunityLanding cl=new CSS_CommunityLanding();
        
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Technician' LIMIT 1];
        UserRole ur = [SELECT id 
                       from UserRole 
                       WHERE PortalType = 'None' LIMIT 1];
        User newUser = new User( Alias = 'standt', Email='test1@gmail.com', UserRoleId = ur.Id ,
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='test11newUser@gmail.com');
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced' LIMIT 1];
        
        User newUser2 = new User( Alias = 'standt2', Email='test2@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p2.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test21newUser@gmail.com');
      /*  
        Profile p3 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Writer' LIMIT 1];
        
        User newUser3 = new User( Alias = 'standt3', Email='test3@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p3.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test31newUser@gmail.com');  
        
        Profile p4 = [SELECT Id FROM Profile WHERE Name='CSS_Service_Supervisor' LIMIT 1];
        
        User newUser4 = new User( Alias = 'standt3', Email='test4@gmail.com', UserRoleId = ur.Id ,
                                 EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                 LocaleSidKey='en_US', ProfileId = p4.Id, 
                                 TimeZoneSidKey='America/Los_Angeles', UserName='test41newUser@gmail.com');  
        */
        //PageReference pageRef;
        System.runAs(newUser) {
            cl.redirect();
        }
        System.runAs(newUser2) {
            cl.redirect();
        }
      /*  System.runAs(newUser3) {
            cl.redirect();
        }
        System.runAs(newUser4) {
            cl.redirect();
        }*/
        Test.stopTest();
    }
}