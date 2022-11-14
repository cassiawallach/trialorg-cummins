global class CSS_delUnitTypeSubTypeScheduler implements Schedulable {
    global void execute(SchedulableContext sc){
       String query = 'select id from CSS_JobEventTemporary__c where (Attribute1__c =\'ClaimType\' OR Attribute1__c = \'WOQTRejectionReason\' OR Attribute1__c =\'SubType\' OR Attribute1__c = \'UnitTypes\' OR Attribute1__c = \'SalesSegment\') and ExpireDateTime__c < Last_N_Days:1';
       //Defect ID : 168492 (Added claim type and WOQTRejectionReason  as part of the query to delet those records )
        if(query != null){
            CSS_delUnitTypeSubTypebatch delBatch = new CSS_delUnitTypeSubTypebatch(query);
            Id BatchProcessId = Database.ExecuteBatch(delBatch);
        }
    }
}