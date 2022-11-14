@isTest
private class OSM_SW_RevokeOIBatch_Test {

	private static testMethod void test() {
	    
	    ccrz__E_Order__c objOrder = new ccrz__E_Order__c(ByPassFlow__c = true);
        insert objOrder;
        
        ccrz__E_OrderItem__c objorderItem = new ccrz__E_OrderItem__c(ccrz__Price__c = 500,
                                                                     Is_Revoked__c = false,
                                                                     ccrz__Quantity__c = 55,
                                                                     ccrz__SubAmount__c = 250,
                                                                     ccrz__Order__c = objOrder.id,
                                                                     Revocation_Status__c = 'Revoke Initiated' );
        insert objorderItem;
        
        OSM_Order_Item_License__c objOIL = new OSM_Order_Item_License__c(Status__c = 'New',
                                                                         type__c = 'Functional',
                                                                         OMS_Item_Id__c = '1234',
                                                                         Tool_Instance_Key__c = '12345',
                                                                         CC_Order_Item__c = objorderItem.id,
                                                                         Activation_Key__c = 'testActivationKey');
        insert objOIL;
        
        Test.startTest();
        
        dataBase.executeBatch(new OSM_SW_RevokeOIBatch(null));
        dataBase.executeBatch(new OSM_SW_RevokeOIBatch(new set<String> {objorderItem.Id}));
        
        Test.stopTest();

	}

}