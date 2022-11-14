@isTest
public class FSL_UserToolsSHGetProfile_Test {
 // karthik Test
    public static testMethod void getuserprofiles () {
         test.startTest();
        FSL_UserToolsSHGetProfile.getProfileInfo();
         test.stoptest();
    }
    public static testMethod void getuserprofiles1 () {
        Profile p = [SELECT Id FROM Profile WHERE Name='CSS_Service_Advanced']; 
        User u = new User(Alias = 'standt', Email='standarduser3@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='UtilityTestUser3@testorg.com');
        insert u;
        test.startTest();
        system.runas(u){
        	FSL_UserToolsSHGetProfile.getProfileInfo();
        }
        test.stoptest();
    }
    public static testMethod void startRequestTest () {
        Asset aset = FSL_TestDataUtility.createAsset();
        test.startTest();
        
        FSL_UserToolsSHGetProfile.startRequest(aset.Name);
        
        test.stoptest();
    }
}