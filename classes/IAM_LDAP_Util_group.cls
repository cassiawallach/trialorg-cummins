/*************************************************************************************
Name:  IAM_LDAP_Util_group
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This class is used to seperate the users whose user group needs to be deleted
and whose user group needs to be updated in LDAP. This class calls the respective classes
either to add user to a group or delete an user to a group 
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                  DATE               DETAIL                                
1.0      Keerthy Gutumurthy        11/16/2018        INITIAL DEVELOPMENT
1.1      Shubhangi Sardar          27/04/2021        LDAP Sync Issue Fix
**************************************************************************************
**************************************************************************************/
public without sharing class IAM_LDAP_Util_group {

    @InvocableMethod
    public static void invokeapexcallout(List<IAM_Contact_Provisioning__c> c) {   
        try{
            system.debug('invoking future method');
            Set<Id> UserGroupSet = new Set<Id>();
            Set<Id> DeleteUserGroupSet = new Set<Id>();
            Map<Id,String> dummyMap = new Map<Id,String>();

            for(IAM_Contact_Provisioning__c conProObj : c) {
                if(String.isNotBlank(conProObj.IAM_Status__c)) {
                    System.debug('#### Contact Status - ' + conProObj.IAM_Contact__r.IAM_Contact_Status__c);
                    if(conProObj.IAM_Status__c =='Active'
                    && (conProObj.IAM_Contact__r.IAM_Contact_Status__c == 'Active'
                    || conProObj.IAM_Contact__r.IAM_Contact_Status__c == 'Reclaim')) {
                        System.debug('UserGroupSet Id :: '+ conProObj.Id);
                        UserGroupSet.add(conProObj.Id);
                    } else if(conProObj.IAM_Status__c =='Inactive'
                    && (conProObj.IAM_Contact__r.IAM_Contact_Status__c == 'Active'
                    || conProObj.IAM_Contact__r.IAM_Contact_Status__c == 'Reclaim')) {
                        System.debug('DeleteUserGroupSet Id :: '+ conProObj.Id);
                        DeleteUserGroupSet.add(conProObj.Id);
                    }
                }                    
            }       
            System.debug('UserGroupSet size :: '+ UserGroupSet.size() 
            + 'DeleteUserGroupSet :: ' + DeleteUserGroupSet.size());
            
            if(!System.isFuture() && !System.isBatch()){
                if(!UserGroupSet.isEmpty()) {
                    /* Add user in application group */
                    IAM_RC_UserGroupMapping.basicAuthCallout(UserGroupSet, dummyMap, false);
                }
                if(!DeleteUserGroupSet.isEmpty()) {
                    /* Delete user from application group */
                    IAM_RC_DeleteUserFromGroup.basicAuthCallout(DeleteUserGroupSet, dummyMap, false);
                }
            }        
        } catch(Exception e){
            System.debug('Printing Exception message'+e.getMessage());
            IAM_ErrorHandling.IAMerrorCapture('Processed Contact Procisioning List - ' + c,
            Label.IAM_Identity_LDAP, e.getStackTraceString() + ' - ' + e.getMessage(),
            IAM_LDAP_Util_group.class.getName());
        }       
    }
}