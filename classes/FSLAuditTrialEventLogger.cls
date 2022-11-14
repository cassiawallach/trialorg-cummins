public class FSLAuditTrialEventLogger {
    public Boolean logFCOverviewEvent(Audit_Trail_Event__mdt auditEvent, String woId)
    {
        try
        {
            FSL_Audit_Trail__c objAuditTrail = new FSL_Audit_Trail__c();
        objAuditTrail.Event__c = auditEvent.Event_Type__c;
        objAuditTrail.FSL_Diagnostic_Audit__c = auditEvent.Diagnostic_Audit_Trail__c;            
        objAuditTrail.FSL_Description__c =  auditEvent.Event_Description__c;
        objAuditTrail.Service_Order__c = woId;
        insert objAuditTrail;
        return true;
        }
        catch(System.Exception ex)
        {
            return false;
        }
    }
    public Boolean logAccessSRTEvent(Audit_Trail_Event__mdt auditEvent, String woId, CSS_Solutions__c cssSol)
    {
        try
        {
            FSL_Audit_Trail__c objAuditTrail = new FSL_Audit_Trail__c();
            objAuditTrail.Event__c = auditEvent.Event_Type__c;
            objAuditTrail.FSL_Diagnostic_Audit__c = auditEvent.Diagnostic_Audit_Trail__c;            
            objAuditTrail.FSL_Description__c =  auditEvent.Event_Description__c + ' for Solution: '+cssSol.Name+'-'+cssSol.Solution_Title__c;
            objAuditTrail.Service_Order__c = woId;
            objAuditTrail.Rank__c = String.valueOf(cssSol.Rank__c);
            objAuditTrail.Service_Order__c = woId;
            objAuditTrail.Solution_Response__c = cssSol.Diagnostic_Response__c;
            objAuditTrail.Symptom__c = cssSol.Fault_Codes__c;
            insert objAuditTrail;
            return true;
        }
        catch(System.Exception ex)
        {
            return false;
        }
    }
}