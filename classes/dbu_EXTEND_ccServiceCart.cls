global with sharing class dbu_EXTEND_ccServiceCart extends ccrz.ccServiceCart 
{
  global virtual override Map<String, Object> getFieldsMap(Map<String,Object> inputData)
    {
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',dbu_optEmailNotification__c,dbu_Cart_StoreCountry__c,dbu_StoreCode__c,dbu_Company_Name__c,dbu_storeLanguage__c,dbu_Pick_Up_From_Store__c, Total_Cart_Discount__c,Total_Cart_Tax__c,Original_Cart_Total__c';    
        system.debug('ObjectFields ::: ' + objectFields);
        return new Map<String,Object>{ccrz.ccService.OBJECTFIELDS => objectFields};
    }
    
    
    global virtual override Map<string, Object> transformIn (Map<string,object> InputData){
        system.debug('TRAVNIK >>>>> ');
		/*
        for(string eachip : InputData.keyset()){
            system.debug('IP key > ' + eachip + 'IP VALUE > ' + InputData.get(eachip));
        }*/
        
        map<string,object> returnMap = super.transformIn(InputData);		
        returnMap.put('dbuCompanyName' , 'dbu_Company_Name__c');
                
        /*
        for(string eachOp : returnMap.keyset()){
            system.debug('OP key > ' + eachOp + 'OP VALUE > ' + returnMap.get(eachOp));
        }*/
        
        return returnMap;       
    }
}