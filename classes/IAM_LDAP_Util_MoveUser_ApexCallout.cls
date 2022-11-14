/*************************************************************************************
Name:  IAM_LDAP_Util_MoveUser_ApexCallout
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This class called from Reclaim, calls LDAP move user API to move user from 
one branch to other
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR             DATE               DETAIL                                
1.0      Nishant Verma        01/16/2020        INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar     27/04/2021        LDAP Sync Issue Fix
**************************************************************************************
**************************************************************************************/
global without sharing class IAM_LDAP_Util_MoveUser_ApexCallout {
    
    @future(callout=true)
    public static void LDAP_reclaim_moveuser(String username, String email, String branch) {
        /* Call request parser class to get the request */
        String JSONString = IAM_LDAP_Util_ReqParser_moveuser_Reclaim.IAM_LDAP_moveuser_ReqBody_Reclaim(
        username, email, branch);
        System.debug('Printing request Body' + JSONString);        
        CSS_Integration_Details__c iamMove= IAM_getConnnectionDetails.getConnection(
        'IAM_LDAP_Move_USer_Mule');    
       
        try {
            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put('Content-Type','application/json');

            /* Get Response */
            HttpResponse res = IAM_HTTP_Callout.sendHTTPRequest(iamMove.Method_Type__c,
            iamMove.End_Point__c, headerMap, JSONString);
            if(res != null && res.getStatusCode() == 200 && String.isNotBlank(res.getBody()) 
            && res.getBody().containsIgnoreCase(Label.IAM_LDAP_Success_Messgae)) {
                List<IAM_Reclaim_Tracker__c> reclaimUserList = [
                    SELECT Name
                         , IAM_New_Username__c
                         , Assign_Permission_set__c
                         , Contact_update__c
                         , Create_User__c
                         , LDAP_Create_User__c
                         , LDAP_Group_Mapping__c
                         , LDAP_Move_User__c
                         , Promotion_Code__c 
                      FROM IAM_Reclaim_Tracker__c
                     WHERE IAM_New_Username__c = :username
                     LIMIT 1
                ];
                if(!reclaimUserList.isEmpty()) {
                    reclaimUserList[0].LDAP_Move_User__c = true;
                    update reclaimUserList;
                }
            } else if(res != null && res.getStatusCode() != 200 ){
                JSONParser parser = JSON.createParser(res.getBody());
                IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Identity_LDAP, 
                res.getBody(), IAM_LDAP_Util_MoveUser_ApexCallout.class.getName());
            }  
        } catch(Exception e) {
            System.debug('ERROR Message:-->:'+ e.getMessage());        
            IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Identity_LDAP, 
            e.getStackTraceString() + ' - ' + e.getMessage(), 
            IAM_LDAP_Util_MoveUser_ApexCallout.class.getName()); 
        }
    }
}