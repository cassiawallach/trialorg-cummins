/*****************************************************************
Name:  OSM_SW_ccServiceAddress
Copyright © 2018  Cummins
==================================================================
==================================================================
Purpose:                                                \
==================================================================
==================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE              DETAIL                                
1.0 -   Sharad Sahu         08/09/2018     INITIAL DEVELOPMENT          

******************************************************************/

global with sharing  class OSM_SW_ccServiceAddress extends ccrz.ccServiceAddress // <1>
{
    global virtual override Map<String, Object> getFieldsMap(Map<String, Object> inputData) // <2>
    {
    
        
        system.debug('---------------');
        system.debug(inputData); 
        system.debug('***************************');
        inputData = super.getFieldsMap(inputData); // <3>
        
        
        
        

        String objectFields = (String)inputData.get(ccrz.ccService.OBJECTFIELDS);  // <3>

        objectFields += ',Bolt_Site__c,Site_Use_Status__c,BMS_Site__c,Bolt_Active__c' ;  // <4>
        system.debug('***************************');
        system.debug(inputData);
        system.debug('***************************');
        return new Map <String,Object> {ccrz.ccService.OBJECTFIELDS => objectFields};  // <5>
    }
    

}