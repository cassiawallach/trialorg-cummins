global with sharing class dbu_EXTEND_ccLogicWLCreate extends ccrz.ccLogicWLCreate {   
    global virtual override Map<String, Object> createWishList(Map<String, Object> inputData) {
        
        system.debug('inp keyset() > ' + inputData.keyset());
        for(string eachkey : inputData.keyset()){
            system.debug('IP key > '+ eachkey + ' value > ' + inputData.get(eachkey));
        }
                
        ((Map<string,object>)inputData.get('transformIndex')).put('dbuCartStoreCountry', 'dbu_Cart_StoreCountry__c');
        ((Map<string,object>)inputData.get('transformIndex')).put('dbustoreLanguage', 'dbu_storeLanguage__c');
        system.debug('TransformationIndex > ' + (Map<string,object>)inputData.get('transformIndex'));
        
        Map<string,object> retMap = super.createWishList(inputData);
        
        system.debug('Op keyset() > ' + retMap.keyset());
        for(string eachkey : retMap.keyset()){
            system.debug('OP key > '+ eachkey + ' value > ' + retMap.get(eachkey));
        }        
        
        return retMap;
    }    
}