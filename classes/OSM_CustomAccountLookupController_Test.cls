@isTest
private class OSM_CustomAccountLookupController_Test {

	private static testMethod void test() {
	    
	    Account objAccount = new Account(Name = 'Test Account',
	                                     CSS_Language__c = 'English',
	                                     CMI_Region__c = 'North America',
	                                     CMI_Account_Status__c = 'Active',
	                                     CMI_CDA_Status__c = 'New Customer Request');
        insert objAccount;
        
        Test.startTest();
        
        OSM_CustomAccountLookupController objCtrl = new OSM_CustomAccountLookupController();
        objCtrl.searchString = 'test';
        objCtrl.search();
        objCtrl.account.Name = 'Test Account - 02';
        objCtrl.saveAccount();
        objCtrl.getFormTag();
        objCtrl.getTextBox();
        
        Test.stopTest();
	}

}