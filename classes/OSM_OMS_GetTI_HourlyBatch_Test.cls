/** 
     * @author   Nandigam Sasi
     *  Added as part of  MAR-1482
     *  Updated As part of MAR-1662
     */
/*************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          02/08/2021      Test Class Fixes
 2.0        Ashish          02/08/2021      Test Class Fixes
 3.0        Sangeeta        05/10/2021      Test Class Fixes
 **/
@isTest
private class OSM_OMS_GetTI_HourlyBatch_Test {

	private static testMethod void test() {
	    
	    ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true);
        insert order;
        ccrz__E_OrderItem__c orderItem = new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c       = order.id;
        orderItem.ccrz__Price__c       = 500;
        orderItem.ccrz__Quantity__c    = 55;
        orderItem.ccrz__SubAmount__c   = 250;
        orderItem.ccrz__OriginalQuantity__c = 100;
        orderItem.OMS_Product__c             = true;
        orderItem.isRenew__c = false;
        orderItem.ccrz__orderitemstatus__c = 'Order Submitted';
        orderItem.Tool_Instance_Key_Count__c = 2;
        orderItem.Tool_Instance_Key__c       = '';
        insert orderItem;
        test.startTest();
        dataBase.executeBatch(new OSM_OMS_GetTI_HourlyBatch());
        String CRON_EXP = '0 0 * * * ?'; 
        System.schedule('GETTILicenseIntTest', CRON_EXP, new OSM_RetryGETTILicenseIntSchedular());
         System.schedule('GETTILicenseIntTest12345', CRON_EXP, new OSM_OMS_GetTI_HourlyBatch());
        test.stopTest();
    }  
}