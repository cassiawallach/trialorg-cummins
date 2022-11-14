global with sharing class dbu_EXTEND_ccServiceAddress extends ccrz.ccServiceAddress
{
  global virtual override Map<String, Object> getFieldsMap(Map<String,Object> inputData)
    {
        inputData = super.getFieldsMap(inputData);
        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);
        objectFields += ',Dbu_Contact__c, dbu_Default_Address__c';    
        system.debug('ObjectFields ::: ' + objectFields);
        return new Map<String,Object>{ccrz.ccService.OBJECTFIELDS => objectFields};
    }
}