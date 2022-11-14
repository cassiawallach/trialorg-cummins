// Trupthi - Created Date 2/25/2022 - for Story NIN-47
@isTest
public class FSL_CL_UserTools_Test {
    
   /* public static void createData() {
        Cache.Session.put('local.CSSPartition.SessionSoPSN', 79635341);
        Profile p = [SELECT Id FROM Profile WHERE Name='EVL_Dealer_Advanced'];
        User usr = new User(ProfileId = p.Id);
        Insert usr;
    }*/ 
    
    
    public static testMethod void psnValuetop() {
		//CreateData();
        Test.startTest();
        string PSNFromSoCache = FSL_CL_UserTools.getSessionPSN();
    	Test.stopTest();
     } 
}