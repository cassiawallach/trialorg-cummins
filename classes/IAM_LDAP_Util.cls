/*************************************************************************************
Name:  IAM_LDAP_Util
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It call LDAP API to create or update user details in LDAP system
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1.0      Keerthy Gurumurthy            05/04/2018     INITIAL DEVELOPMENT
1.0      Shubhangi Sardar              27/04/2021     Code Optimization
**************************************************************************************
**************************************************************************************/

public class IAM_LDAP_Util {
    public static boolean isIAMLDAPUtil_Processed = false;
    public static void invokeapexcallout(List<Contact> con, String action) {
        System.debug('invoking future method');
        Set<Id> conIds = new Set<Id>();
        Set<Id> delconIds = new Set<Id>();     
        try {
            for(contact c : con) {
                if(c.IAM_Contact_Status__c == 'Inactive' && action == 'Update'){
                    delconIds.add(c.id);
                } else if(c.IAM_Contact_Status__c == 'Active' || c.IAM_Contact_Status__c == 'Reclaim') {
                    conIds.add(c.id);
                }
            }
            if(!System.isFuture() && !Test.isRunningTest() && !conIds.isEmpty()){
                System.debug('before making LDAP call conIds.... '+ conIds);
                IAM_LDAP_Util_ApexCallout.sendToLDAP(conIds, action);  
            }
            if(!System.isFuture() && !Test.isRunningTest() && !delconIds.isEmpty()){
                System.debug('before making LDAP call delconIds.... '+ delconIds);
                IAM_RC_DeleteUser.basicAuthCallout(delconIds);  
            }        
        } catch(exception ex){
            System.debug('Printing exception Ldap Util'+ex);
            String processedData = 'Users To Add - ' + conIds + ' Users to Delete - ' + delconIds;
            IAM_ErrorHandling.IAMerrorCapture(processedData, Label.IAM_Identity_LDAP,
            ex.getStackTraceString() + ' - ' + ex.getMessage(), IAM_LDAP_Util.class.getName());
        }        
    }
}