global with sharing class dbu_EXTEND_ccServiceOrder extends ccrz.ccServiceOrder{

    global virtual override Map<String, Object> getFieldsMap(Map<String,Object> inputData){
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',dbu_PickUp_From__c,dbu_pickupAddress__c,dbu_OrderPaymentMethod__c,Dbu_Original_Order_Total__c,dbu_Days_Since_Order_Date__c,dbu_New_Original_Order_Total__c, dbu_PickUpStore_OpenHrs__c';    
        system.debug('ObjectFields ::: ' + objectFields);
        return new Map<String,Object>{ccrz.ccService.OBJECTFIELDS => objectFields};
    }
      
}