@isTest
public class dbu_LoggedInUserinfo_Test {
    static testMethod void testfetchNoficationsDetails() { 
    Profile cpprofile = [select id, name from Profile where name='System Administrator'];
        User userrecord = new User(); 
    		userrecord.Username  = 'sfdc-testclass@cmiuser.com';
            userrecord.LastName  = 'Liu';
            userrecord.Email     = 'dvdkliu+sfdc99@gmail.com';
            userrecord.Alias     = 'fatty';
            userrecord.TimeZoneSidKey    = 'America/Denver';
            userrecord.LocaleSidKey      = 'en_US';
            userrecord.EmailEncodingKey  = 'UTF-8';  
            userrecord.ProfileId = cpprofile.Id;   
    		userrecord.FirstName = 'David';
            userrecord.LanguageLocaleKey = 'en_US';
        Insert userrecord;
    	 System.runAs(userrecord) {
              // The following code runs as user 'u'
              System.debug('Current User: ' + UserInfo.getUserName());
              System.debug('Current Profile: ' + UserInfo.getProfileId());
             dbu_LoggedInUserinfo.getLoggedInUserInfo(); 
          }
        //Test.startTest();  
			//dbu_LoggedInUserinfo.getLoggedInUserInfo();  
        //System.assertEquals(testAcc.CreatedDate, yesterday);  
        //Test.stopTest();  
    }
}