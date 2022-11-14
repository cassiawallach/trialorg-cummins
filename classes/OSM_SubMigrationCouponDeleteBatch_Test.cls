/************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          03/01/2021      Test Class Fixes
 */
@isTest
private class OSM_SubMigrationCouponDeleteBatch_Test {

	private static testMethod void test() {
	    
	    Account objAccount = new Account(Name = 'Test Account');
	    insert objAccount;
	    
	    OSM_Existing_Subscription__c objES = new OSM_Existing_Subscription__c(Product_Name__c = 'Test',
	                                                                          Account__c = objAccount.Id,
	                                                                          Dealer_Coupon_Code__c = 'test',
	                                                                          Distributor_Coupon_Code__c = 'test');
	    insert objES;
	    
	    Test.startTest();
	    OSM_SubMigrationCouponDeleteBatch objSMCDB = new OSM_SubMigrationCouponDeleteBatch();
	    Database.executeBatch(objSMCDB);
	    Test.stopTest();

	}

}