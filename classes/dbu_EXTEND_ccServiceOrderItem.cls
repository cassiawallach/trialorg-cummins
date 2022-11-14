global with sharing class dbu_EXTEND_ccServiceOrderItem extends ccrz.ccServiceOrderItem{

    global virtual override Map<String, Object> getFieldsMap(Map<String,Object> inputData){
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',dbu_Reason_for_Return__c,dbu_Estimated_PickUp__c,dbu_Invoice_Generated__c,dbu_BuyerEmailAddress__c,dbu_Estimated_Delivery__c,dbu_isShipTo__c,dbu_isInStock__c,dbu_Estimated_Return_Amount__c,ccrz__OrderItemId__c,dbu_Dropoff_Location__c,dbu_Return_Additional_Information__c,dbu_Selected_Return_Items__c,Vertex_Tax__c,dbu_Is_Returned__c';    
        system.debug('ObjectFields ::: ' + objectFields);
        return new Map<String,Object>{ccrz.ccService.OBJECTFIELDS => objectFields};
    }
}