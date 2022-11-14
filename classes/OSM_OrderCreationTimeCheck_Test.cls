//Updated Test Class as part of MAR-1604
@isTest
private class OSM_OrderCreationTimeCheck_Test {

  private static testMethod void test() {
      
    ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true,ccrz__Storefront__c='SoftwareStore');
        insert order;
        
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c       = order.id;
        orderItem.ccrz__Price__c       = 500;
        orderItem.ccrz__Quantity__c    = 55;
        orderItem.ccrz__SubAmount__c   = 250;
        orderItem.ccrz__OriginalQuantity__c = 100;
        orderItem.isRenew__c = false;
        insert orderItem;
        DateTime currentTime = System.now().addMinutes(-15);
        
        Test.setCreatedDate(order.Id, currentTime); 
        test.startTest();
        dataBase.executeBatch(new OSM_OrderCreationTimeCheck());
        String CRON_EXP = '0 2 * * * ?'; 
        System.schedule('OSM_OrderCreationTimeCheckTest', CRON_EXP, new OSM_OrderCreationTimeCheck_Schedular());
        test.stopTest();
    }  
}