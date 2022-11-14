/**********************************************************************
Name: FSL_SetupResourceTriggerHelper
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:
These Class is used for the Admin Portal setup Resuorce
assiging and revoking the access for the Users.
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                
1.0 - Vinod Yelala      03/20/2019      INITIAL DEVELOPMENT                    
***********************************************************************/
public class FSL_SetupResourceTriggerHelper {
    public static Boolean isTestNull;
    public static void afterTrigger(Boolean isInsert, Boolean isUpdate, List<Setup_Resource__c> newList, Map<Id, SObject> oldMap)
    {
        List<PermissionSetAssignment> pss = new List<PermissionSetAssignment>();
        Map<Id, List<String>> assigneeIds = new Map<Id, List<String>>();
        List<Id> srIds = new List<Id>();
        List<Setup_Resource__c> auditsr = new List<Setup_Resource__c>(); // Added By vinod Audit Logic (story - 1888)
        Map<Id,Setup_Resource__c> auditoldsr = new Map<Id,Setup_Resource__c>(); // Added By vinod Audit Logic  
        Set<String> removedAccess = new Set<String>();
        Set<Id> removeAgentPermSetUserIds = new Set<ID>();

       
        if(isInsert)
        {
            for(Setup_Resource__c sr : newList)
            {
                if(String.isNotBlank(sr.Access__c) || String.isNotBlank(sr.Resource_Type__c)) {
                   
                    auditsr.add(sr);
                }
                //added for tool and bay
                if(String.isNotBlank(sr.Access__c) || (String.isNotBlank(sr.Resource_Type__c) &&
                                                       (sr.Resource_Type__c=='Tool' || sr.Resource_Type__c == 'Bay')))
                {
                    srIds.add(sr.id);                
                }            
            }
            if(!auditSr.isEmpty())
                FSL_SetupResourceTriggerHandler.logAuditHistory(auditSR, null);
        }
        else if(isUpdate)
        {
            Setup_Resource__c oldSr;
           
            List<String> oldValues;
            List<String> newValues;
            String key;
            for(Setup_Resource__c sr : newList)
            {
                oldSr = (Setup_Resource__c)oldMap.get(sr.id);
                if((String.isNotBlank(sr.Access__c) && oldSr.Access__c != sr.Access__c) ||
                   (oldSR.Resource_Type__c <> sr.Resource_Type__c) || (isTestNull <> null && isTestNull))
                {
                    if(oldSR.Access__c != null)
                        oldValues = oldSR.access__c.split(';');
                    if(sr.Access__c != null && sr.Access__c <> '')
                        newValues = sr.Access__c.split(';');
                    system.debug('newValues::'+newValues);
                    system.debug('oldValues::'+oldValues);
                    if(oldValues != null)
                    {
                        if(newValues != null)
                        {
                            for(String s : oldValues)
                            {                                
                                if(!newValues.contains(s) || (oldSR.Resource_Type__c <> sr.Resource_Type__c))
                                {
                                    if((oldSR.Resource_Type__c == sr.Resource_Type__c) && (sr.Resource_Type__c == 'Advanced' || sr.Resource_Type__c == 'Technician'))
                                    {
                                        if(sr.Resource_Type__c == 'Technician')
                                            key = 'Technician' + s;
                                        else
                                            key = sr.Resource_Type__c + s;
                                    }
                                    else if(oldSR.Resource_Type__c <> sr.Resource_Type__c)
                                    {
                                        if(oldSR.Resource_Type__c == 'Technician') {
                                            key = 'Technician' + s;
                                        }
                                        else {
                                            key = oldSR.Resource_Type__c + s;
                                        }
                                    }
                                    else {
                                        key = s;
                                    }
                                    removedAccess.add(sr.User__c + ':' + key);
                                }
                            }
                        }
                        else
                        {
                            for(String s : oldValues)
                            {                                
                                {
                                    if((oldSR.Resource_Type__c == sr.Resource_Type__c) && (sr.Resource_Type__c == 'Advanced' || sr.Resource_Type__c == 'Technician'))
                                    {
                                        if(sr.Resource_Type__c == 'Technician')
                                            key = 'Technician' + s;
                                        else
                                            key = sr.Resource_Type__c + s;
                                    }
                                   
                                    else if(oldSR.Resource_Type__c <> sr.Resource_Type__c)
                                    {
                                        if(oldSR.Resource_Type__c == 'Technician')
                                            key = 'Technician' + s;
                                        else
                                            key = oldSR.Resource_Type__c + s;
                                    }
                                    else
                                        key = s;
                                    removedAccess.add(sr.User__c+':'+key);
                                }
                            }
                        }
                    }
                    srIds.add(sr.id);

                    //For CT2-449 
                    if(String.isNotBlank(sr.Access__c) && oldSr.Access__c != sr.Access__c){
                        if( (!oldSr.Access__c.containsIgnoreCase('BASIC') || !oldSr.Access__c.containsIgnoreCase('DISPATCHER')) 
                            && (sr.Access__c.containsIgnoreCase('BASIC') && sr.Access__c.containsIgnoreCase('DISPATCHER')) ){
                                removeAgentPermSetUserIds.add(sr.User__c);    
                            }
                    }

                }
                if((sr.Access__c != oldSr.Access__c ) || sr.Resource_Type__c != oldSr.Resource_Type__c)
                {                
                    auditoldsr.put(sr.Id,oldsr);
                    auditsr.add(sr);
                }
            }        
        }
        if(!srIds.isEmpty())
            FSL_SetupResourceTriggerHandler.assignAccessPermissions(srIds, removedAccess);
        if(!auditSr.isEmpty())
            FSL_SetupResourceTriggerHandler.logAuditHistory(auditSR, auditoldsr);
        if(!removeAgentPermSetUserIds.isEmpty())
            removeAgentPermissions(removeAgentPermSetUserIds);
    }

    /*
    * Ticket: CT2-449 
    * DESC: Method to delete Agent License and Agent Permission when the User has both BASIC and DISPATCHER access
    */
    @future
    private static void removeAgentPermissions(Set<Id> userIds){
                
        List<FSL_Setup_Resource_Accesses__mdt> accessMdt = [SELECT FSL_Permission_Set_ID__c 
                                                            FROM FSL_Setup_Resource_Accesses__mdt
                                                            WHERE MasterLabel = 'Agent License' OR MasterLabel = 'Agent Permission'];
        Set<Id> permSetIds = new Set<Id>();
        for(FSL_Setup_Resource_Accesses__mdt fsr:accessMdt){
            permSetIds.add(fsr.FSL_Permission_Set_ID__c);
        }
        List<PermissionSetAssignment> pssToDelete = [select id from PermissionSetAssignment where PermissionSetId  in :permSetIds and assigneeId in :userIds AND PermissionSet.IsOwnedByProfile = false];
        if(!pssToDelete.isEmpty()) 
            delete pssToDelete;
    }
}