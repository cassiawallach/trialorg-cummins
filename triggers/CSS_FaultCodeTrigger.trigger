trigger CSS_FaultCodeTrigger on CSS_Fault_Code__c(after Insert) {
 //****************** This is for GUIDANZ*******************/
    boolean guidanzFlag = false;
    for(CSS_Fault_Code__c fc : Trigger.New) {
        if(fc.Job_Order__c != null) {
            guidanzFlag = true;
            break;
        }
    }  
    //****************** This is for GUIDANZ*******************/
    if(guidanzFlag == true){
     if(trigger.isAfter){
        if(trigger.isInsert){
            //
        system.debug('insidesymptomqatrigger');
        List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
        claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                          FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_Fault_Code__c' AND isServicejob__c=true ORDER BY Sort_Order__c ASC];
        system.debug('Triggernew'+Trigger.new);
        CG_CL_ClaimsAuditTrailEventHandler.onInsertFaultcode(Trigger.new, claimsAuditLst);

        }
    }
    }
}