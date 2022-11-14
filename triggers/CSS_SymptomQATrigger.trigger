/*
 * Block comments with details of changes
 */
trigger CSS_SymptomQATrigger on CSS_SymptomQA__c (after update,after insert, before insert, before update, before delete){
    if(trigger.isAfter){
        if(trigger.isInsert){
            system.debug('insidesymptomqatrigger');
            List<CG_Claim_Audit_Log__c> claimsAuditLst = new List<CG_Claim_Audit_Log__c>();
            claimsAuditLst = [SELECT Id, isServicejob__c, Action_Type__c, Dynamic_Message__c, Field_Name__c, Message__c, Object_Name__c, Sort_Order__c, Remove_Message__c
                              FROM CG_Claim_Audit_Log__c WHERE Object_Name__c = 'CSS_SymptomQA__c' AND isServicejob__c=true ORDER BY Sort_Order__c ASC];
            system.debug('Triggernew'+Trigger.new);
            CG_CL_ClaimsAuditTrailEventHandler.onInsertSymtomQA(Trigger.new, claimsAuditLst);

        }
    }


}