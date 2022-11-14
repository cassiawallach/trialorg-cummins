@isTest
private class OSM_SW_BoltInformation_Helper_Test {

	private static testMethod void test() {
	    
	    Account objAccount = new Account(Name = 'Test Account',
	                                     Type = 'Distributor Branch',
	                                     CSS_DistributorCode__c = '123456');
        insert objAccount;
        
        Account objAccount2 = new Account(Name = 'Test Account - 02',
	                                      Bolt_Credit_Hold__c = true,
	                                      Bolt_BC_Code__c = '123456',
	                                      Type = 'Distributor Account',
	                                      CSS_DistributorCode__c = '123456',
	                                      BOLT_Account_Number__c = '123456',
	                                      IAM_Service_Provider_Code__c = '123456',
	                                      Bolt_Customer_Account_Status__c = 'Active');
        insert objAccount2;
        
        Test.startTest();
        
        OSM_SW_BoltInformation_Helper.updateBoltInfo(new List<Account> {objAccount});
        
        Test.stopTest();
	}

}