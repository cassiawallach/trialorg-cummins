global with sharing  class OSM_SW_ccServiceSubscription extends ccrz.ccServiceSubscription// <1>
{
    
    
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) // <2>
    {
    
        for(String key:inputData.keySet())
        {
           ccrz.ccLog.log('************Order Service *KEY********** '+key);
            ccrz.ccLog.log('************Order Service *VALUE********** '+inputData.get(key));
        } 
        system.debug('***************************');
        system.debug(inputData); 
        system.debug('***************************');
        inputData = super.getFieldsMap(inputData); // <3>

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);  // <3>

        objectFields += ',OSM_Free_Trial__c ' ;  // <4>
        system.debug('***************************');
        system.debug(inputData);
        system.debug('***************************');
        //return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};  // <5>
        return inputData;
    }
    
     
    
    
}