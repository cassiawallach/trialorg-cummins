/**********************************************************************
Name: FSL_CL_AuditTrail
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This class is used to define/implement methods for Audit Trail object
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            			DATE                DETAIL                                 
1.0 - 	Rajashekar Nallapati      07/01/2019     INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_CL_AuditTrail {
    
    @AuraEnabled
    public static List<FSL_Audit_Trail__c> getAuditTrailData(String strServiceOrderId){
        List<FSL_Audit_Trail__c> objAuditTrail;
        User user = new User();
        user = [SELECT Id,UserRole.Name
                FROM User
                WHERE Id=:UserInfo.getUserId() LIMIT 1];
        system.debug('*** User Role Name *****'+user.UserRole.Name);
        if(user.UserRole.Name=='Factory'){
            objAuditTrail = [SELECT Id,Name,CreatedBy.Name,CreatedDate,FSL_Description__c,
                             FSL_Diagnostic_Audit__c,Event__c,Rank__c,
                             Service_Order__r.WorkOrderNumber,Icon__C,Solution_Response__c,Symptom__c
                             FROM FSL_Audit_Trail__c
                             WHERE Service_Order__c=:strServiceOrderId
                             ORDER BY CreatedDate ASC ];
        }else{
            objAuditTrail = [SELECT Id,Name,CreatedBy.Name,CreatedDate,FSL_Description__c,
                             FSL_Diagnostic_Audit__c,Event__c,Rank__c,
                             Service_Order__r.WorkOrderNumber,Solution_Response__c,Symptom__c
                             FROM FSL_Audit_Trail__c
                             WHERE Service_Order__c=:strServiceOrderId AND FSL_Diagnostic_Audit__c=true
                             ORDER BY CreatedDate ASC];
        }
        System.debug('Diagnostic Audit Trail List'+objAuditTrail);       	 
        return objAuditTrail;
    }
}