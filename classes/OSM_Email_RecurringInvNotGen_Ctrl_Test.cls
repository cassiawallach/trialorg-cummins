@isTest
private class OSM_Email_RecurringInvNotGen_Ctrl_Test {

	private static testMethod void test() {
	    
	    ccrz__E_Product__c objProduct = new ccrz__E_Product__c(ccrz__SKU__c = '15458776',
	                                                           Name = 'Connected Advisor',
	                                                           ccrz__ShortDesc__c = 'testing',
	                                                           ccrz__Quantityperunit__c = 3343,
	                                                           ccrz__StartDate__c = system.today(),
	                                                           ccrz__EndDate__c = system.today()+1);
        insert objProduct;
	    
	    ccrz__E_Subscription__c objSub = new ccrz__E_Subscription__c(ccrz__Quantity__c = 10,
	                                                                 ccrz__Sequence__c = 2,
	                                                                 ccrz__Storefront__c = 'SoftwareStore',
	                                                                 ccrz__SubscriptionStatus__c = 'Active',
	                                                                 OSM_Display_Product__c = objProduct.Id,
	                                                                 ccrz__SubscriptionStartDate__c = system.today());
	    insert objSub;
	    
	    ccrz__E_ProductMedia__c objPM = new ccrz__E_ProductMedia__c(ccrz__Product__c = objProduct.Id,
	                                                                ccrz__MediaType__c = 'Product Image Thumbnail');
	    insert objPM;
	    
	    Map<String,Object> requestData = new Map<String,Object>{'quantity'=> 10,
                                                                'price'=> 100,
                                                                'subscription' => objSub.Id} ;
	    
	    OSM_Integration_Log__c objIL = new OSM_Integration_Log__c(Subscription__c = objSub.Id,
	                                                              Request__c = JSON.serialize(new List<Object> {requestData}));
	    insert objIL;
	    
	    Test.startTest();
	    
	    OSM_Email_RecurringInvNotGenerated_Ctrl objCtrl = new OSM_Email_RecurringInvNotGenerated_Ctrl();
	    objCtrl.setLogId(objIL.Id);
	    
	    Test.stopTest();

	}

}