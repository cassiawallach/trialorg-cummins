global with sharing class dbu_EXTEND_ccServiceProduct extends ccrz.ccServiceProduct {
    global virtual override Map<string,object> getFieldsMap(Map<string,object> inputData){
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',dbu_Product_Code__c,DBU_Product_Location__c, dbu_GenuinePart__c, dbu_Non_Returnable__c,dbu_Has_Core_Child__c,dbu_Has_Core_Charge__c,dbu_Crate_Engine__c, dbu_Inventory_Status_Check__c,dbu_Pick_Up_Only__c,dbu_Available_to_ship__c,createddate';    
        system.debug('ObjectFields ::: ' + objectFields);
        return new Map<String,Object>{ccrz.ccService.OBJECTFIELDS => objectFields};        
    }
    global virtual override Map<String, Object> getFilterMap(Map<String, Object> inputData) {
        Map<String, Object> RetMap = super.getFilterMap(inputData);
        
        if(inputData.get('dBUProductLocation') != null){
            
            string ProductLocationValue = (string)inputData.get('dBUProductLocation');
            string QueryCondition = 'AND DBU_Product_Location__c INCLUDES ('+ '\''+ ProductLocationValue + '\'' + ')';
            system.debug('QueryCondition >> ' + QueryCondition);
            RetMap.put('ISPRODUCTLOCATION', QueryCondition);
        }
        
        return RetMap;
    }
}