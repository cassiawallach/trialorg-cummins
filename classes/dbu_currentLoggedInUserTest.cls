@isTest
public class dbu_currentLoggedInUserTest {static testMethod void testfetchNoficationsDetails() {  
        Profile cpprofile = [select id, name from Profile where name='System Administrator'];
        User userrecord = new User(); 
    		userrecord.Username  = 'sfdc-dreamer@gmail.com';
            userrecord.LastName  = 'Liu';
            userrecord.Email     = 'dvdkliu+sfdc99@gmail.com';
            userrecord.Alias     = 'fatty';
            userrecord.TimeZoneSidKey    = 'America/Denver';
            userrecord.LocaleSidKey      = 'en_US';
            userrecord.EmailEncodingKey  = 'UTF-8';  
            userrecord.ProfileId = cpprofile.Id;   
    		//userrecord.dbu_All_Notification__c=true;
            //userrecord.dbu_Email_communications__c=true;
            //userrecord.dbu_Product_stock_notifications__c=true;
            //userrecord.dbu_Special_promotions__c =true;
            //userrecord.dbu_Wishlist_notifications__c= true;
            
    		userrecord.FirstName = 'David';
            userrecord.LanguageLocaleKey = 'en_US';
        Insert userrecord;
    
        Test.startTest();  
			dbu_currentLoggedInUser.getUserDetails(userrecord.Id);  
        //System.assertEquals(testAcc.CreatedDate, yesterday);  
        Test.stopTest();  
    }
}