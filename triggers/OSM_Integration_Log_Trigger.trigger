trigger OSM_Integration_Log_Trigger on OSM_Integration_Log__c (after insert) {
    
    if( Trigger.isInsert && Trigger.isAfter ) {
        
        OSM_Integration_Log_TriggerHelper.updateFieldsFromRequestJSON( Trigger.newMap );
    }

}