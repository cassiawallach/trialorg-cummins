global with sharing class dbu_EXTEND_ccServiceCartItem extends ccrz.ccServiceCartItem{
    global virtual override Map<String, Object> getFieldsMap(Map<String,Object> inputData){
        inputData = super.getFieldsMap(inputData);
        system.debug('inputData ::: ' + inputData);
        
        //setting up the object fields below. adding custom fields in the query string
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',dbu_Make__c, dbu_Model__c, dbu_isShipTo__c , dbu_isInStock__c,dbu_Estimated_Delivery__c, dbu_Estimated_PickUp__c, dbu_VIN__c, dbu_Year__c, dbu_EmissionAgreement__c, dbu_ExportAgreement__c, dbu_ShippingAgreement__c, dbu_TncAgreement__c, dbu_UnloadingAgreement__c, dbu_WarrentyAggrement__c';
        system.debug('ObjectFields ::: ' + objectFields);
        
        //returning the modified query for dynamic querying.
        return new Map<String,Object>{ccrz.ccService.OBJECTFIELDS => objectFields};
    }
}