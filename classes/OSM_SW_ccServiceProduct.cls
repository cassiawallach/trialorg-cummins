global with sharing  class OSM_SW_ccServiceProduct extends ccrz.ccServiceProduct // <1>
{
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) // <2>
    {
        system.debug('***************************');
        system.debug(inputData); 
        system.debug('***************************');
        inputData = super.getFieldsMap(inputData); // <3>

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);  // <3>

        objectFields += ',Version_Display__c,ccrz__LongDesc__c,QSOL_Power_Generation__c,Brand__c,Group_Name__c,Package__c,OSM_DA_FreeProduct__c,OSM_Term_and_Condition__c,Stand_Alone_Product__c,GOMS_Defined_Part_number__c,GOMS_Part_Number__c ' ;  // <4>
        system.debug('***************************');
        system.debug(inputData);
        system.debug('***************************');
        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};  // <5>
    }
    
    /*
    global virtual override Map<String, Object> getDirectQueryMap(Map<String, Object> inputData) {
        inputData.put('ccrz__E_SubProdTerm__c','SELECT Id, Name, ccrz__CCProduct__c, ccrz__CCSubProdTerm__c, ccrz__Enabled__c FROM ccrz__E_SubProdTerm__c');
        inputData.put('ProductSubscPackage__c','SELECT Base__c,CC_Product__c,Id,Name,Plus__c,Pro__c,Subscription_Name__c,SystemModstamp FROM ProductSubscPackage__c');   
        system.debug('###########################');
        system.debug(inputData);
        system.debug('###############################');
        return inputData;
    }
    */
    /*
    global virtual override Map<String, Object> getSubQueryMap(Map<String, Object> inputData) {
        inputData.put('E_SubProdTerm__r','(SELECT Id, Name, CCProduct__c, CCSubProdTerm__c, Enabled__c FROM E_SubProdTerm__r');
        return inputData;
    }
    
   global virtual override Map<String, Object> getSubQueryMap(Map<String, Object> inputData) {
        inputData.put('ccrz__E_SubProdTerm__c','(SELECT Id, Name, ccrz__CCProduct__c, ccrz__CCSubProdTerm__c, ccrz__Enabled__c FROM ccrz__E_SubProdTerm__c');
        return inputData;
    }  */  
    /*private static final Map<String, Object> SUBQUERYMAP = new Map<String, Object>{
        'ccrz__E_SubProdTerm__r' =>'SELECT Id, Name, ccrz__CCProduct__c, ccrz__CCSubProdTerm__c, ccrz__Enabled__c FROM ccrz__E_SubProdTerm__r'      
    };
    */
    
   
}