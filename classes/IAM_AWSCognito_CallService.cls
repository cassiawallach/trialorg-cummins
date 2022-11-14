/*************************************************************************************
Name:  IAM_AWSCognito_CallService
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It is generic class to call respective AWS Cognito Services on trigger of 
Contact and User object
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Shubhangi Sardar      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar      10/02/2020      Added person type to identify internal employee using person type field on contact.
1.2      Shubhangi Sardar      12/03/2020      Added NPBU Diagnostic Expration in Request
1.3      Shubhangi Sardar      01/05/2021      To set IDP to OAM for Legacy User isInternal flag is set to True for Legacy User.
1.4      Karthik Golakaram     01/25/2021      Made changes for the MArket place application - INC1022619
1.5      Shubhangi Sardar      06/18/2021      Added new attribute customerCode in request
1.6      Shubhangi Sardar      09/07/2021      Added error logs to capture report
**************************************************************************************
**************************************************************************************/

public class IAM_AWSCognito_CallService {
    
    /* Send contacts to AWS Cognito service for processing on disable and change of attributes */
    public static void callService(List<Contact> contactList, Map<Id,Contact> newMap, Map<Id,Contact> oldMap) {
        Map<Id, Map<String, String>> serviceRequestMap = new Map<Id, Map<String, String>>();
        Map<Id, String> idUsernameMap = new Map<Id, String>();
        Map<Id, Boolean> internalUserMap = new Map<Id, Boolean>();
        Map<Id, String> disabledUsernameMap = new Map<Id, String>();
        Map<Id, Contact> revokeInternalUserConMap= new Map<id,Contact>();
        Map<Id, String> accountSPCodeMap = getAccountSPCodes(contactList);
        for(Contact con : contactList) {
            Boolean isInternal = isInternal(con);
            internalUserMap.put(con.Id, isInternal);
            System.debug('#### internalUserMap - ' + internalUserMap);
            if(oldMap.ContainsKey(con.Id)){//Karthik MAde Changes- 01-22-2021
                /* Values from this map is used to pass in UserId key in Update_User_Attribute API */
                idUsernameMap.put(con.Id, oldMap.get(con.Id).Username__c);
                //internalUserMap.put(con.Id, con.IAM_Internal__c);
                
                
                /* If any of the values among IAM_swregexpire__c, IAM_Work_Group_Id__c and Username__c, FirstName, LastName 
                ** are updated on Contact then add those contact Id and changed values in serviceRequestMap. */			
                if(newMap.get(con.Id).IAM_swregexpire__c != oldMap.get(con.Id).IAM_swregexpire__c) {
                    prepareServiceRequestMap(serviceRequestMap, 'custom:swregexpire', con.IAM_swregexpire__c, con);
                }
                if(newMap.get(con.Id).IAM_Work_Group_Id__c != oldMap.get(con.Id).IAM_Work_Group_Id__c) {
                    prepareServiceRequestMap(serviceRequestMap, 'custom:workgroupid', con.IAM_Work_Group_Id__c, con);
                }
                if(newMap.get(con.Id).Username__c != oldMap.get(con.Id).Username__c) {
                    prepareServiceRequestMap(serviceRequestMap, 'custom:username', con.Username__c, con);
                }
                if(newMap.get(con.Id).FirstName != oldMap.get(con.Id).FirstName) {
                    prepareServiceRequestMap(serviceRequestMap, 'given_name', con.FirstName, con);
                }
                if(newMap.get(con.Id).LastName != oldMap.get(con.Id).LastName) {
                    prepareServiceRequestMap(serviceRequestMap, 'family_name', con.LastName, con);
                }
                if(newMap.get(con.Id).IAM_Product_Group_Access__c != oldMap.get(con.Id).IAM_Product_Group_Access__c) {
                    prepareServiceRequestMap(serviceRequestMap, 'custom:PGA', con.IAM_Product_Group_Access__c, con);
                }
                /* 12/03/2020 - Added NPBU Diagnostic Expration in Request */
                if(newMap.get(con.Id).IAM_NpbuDiagExpire__c != oldMap.get(con.Id).IAM_NpbuDiagExpire__c) {
                    prepareServiceRequestMap(serviceRequestMap, 'custom:NpbuDiagExpire', con.IAM_NpbuDiagExpire__c, con);
                }
                /* 16/06/2021 - Added Customer Code in Request */
                if(newMap.get(con.Id).AccountId != oldMap.get(con.Id).AccountId) {
                    prepareServiceRequestMap(serviceRequestMap, 'custom:customerCode', accountSPCodeMap.get(con.AccountId), con);
                }
                
                /* If Contact status is changed to Inactive then add values in disabledUsernameMap */
                if(newMap.get(con.Id).IAM_Contact_Status__c != oldMap.get(con.Id).IAM_Contact_Status__c
                && con.IAM_Contact_Status__c == Label.IAM_Status_Inactive) {                
                    disabledUsernameMap.put(con.Id, con.Username__c);
                }
                
                /*If Contact Password TimeStamp got Changed for Internal User at contact level.we do this because for internal users
                * they will not change passwords in salesforce. they do it in WWIMS/OIM.*/
                if(newMap.get(con.Id).IAM_PasswordChangedTime__c != oldMap.get(con.Id).IAM_PasswordChangedTime__c){
                    revokeInternalUserConMap.put(con.Id,con);
                }
            } 
        }
        
        /* If disabledUsernameMap map is not empty then call Disable_User API */
        if(!disabledUsernameMap.isEmpty()) {
            for(Id key : disabledUsernameMap.keySet()) {
                IAM_AWSCognito_DisableUser.disableUser(disabledUsernameMap.get(key), internalUserMap.get(key));
            }
        }
        
        /* If serviceRequestMap map is not empty then call Update_User_Attribute API */
        if(!serviceRequestMap.isEmpty()) {
            for(Id key : serviceRequestMap.keySet()) {
                IAM_AWSCognito_UpdateUserAttributes.updateUserAttributes(idUsernameMap.get(key), 
                serviceRequestMap.get(key), internalUserMap.get(key));
            }
        }
        
        /*If revokeInternalUserConMap is not Empty then call revoke api for Internal user*/
        if(!revokeInternalUserConMap.isEmpty()){
            for(id key:revokeInternalUserConMap.keySet()){
               IAM_AWSCognito_RevokeToken.revokeToken(revokeInternalUserConMap.get(key).Username__c, revokeInternalUserConMap.get(key).IAM_Internal__c); 
            }
        }
    }
    
    /* Send users to AWS Cognito service for processing on change of password */
    public static void callService(List<User> userList, Map<Id,User> newMap, Map<Id,User> oldMap) {
        Map<Id, String> revokedUsernameMap = new Map<Id, String>();
        Map<Id, String> revokedUsernameMapContact = new Map<Id, String>();
        Map<Id, Id> userContactMap = new Map<Id, Id>();
        Map<Id, Boolean> internalUserCheckMap = new Map<Id, Boolean>();
        /* If user password is changed then add values to revokedUsernameMap */
        for(User u : userList) {
            if(newMap.get(u.Id).IAM_Lastpassword__c != oldMap.get(u.Id).IAM_Lastpassword__c) {                
                revokedUsernameMap.put(u.Id, u.Username);
                userContactMap.put(u.Id, u.ContactId);
            }
        }
        List<Contact> conList;
        if(!userContactMap.isEmpty()) {
            conList = [
                SELECT Id
                     , IAM_Internal__c
                     , Username__c
                     , IAM_Person_Type__c
                     , IAM_Legacy_User__c
                  FROM Contact
                 WHERE Id IN :userContactMap.values()
            ];
            System.debug('##### conList '+conList);
        }
        if(conList != null && !conList.isEmpty()) {
            for(Contact con : conList) {
                //internalUserCheckMap.put(con.Id, con.IAM_Internal__c);
                Boolean isInternal = isInternal(con);
                internalUserCheckMap.put(con.Id, isInternal);
                system.debug('#### internalUserCheckMap - '+internalUserCheckMap);
                revokedUsernameMapContact.put(con.Id, con.Username__c);
            }            
        }
        /* If revokedUsernameMap map is not empty then call Revoke_Token API */
        if(!revokedUsernameMap.isEmpty()) {
            for(Id key : revokedUsernameMap.keySet()) {
                Boolean isInternal;
                if(internalUserCheckMap.containsKey(userContactMap.get(key))) {
                    isInternal = internalUserCheckMap.get(userContactMap.get(key));
                } else {
                    isInternal = true;
                }
                String username;
                if(revokedUsernameMapContact.containsKey(userContactMap.get(key))) {
                    username = revokedUsernameMapContact.get(userContactMap.get(key));
                } else {
                    username = revokedUsernameMap.get(key);
                }
                IAM_AWSCognito_RevokeToken.revokeToken(username, isInternal);
            }
        }
    }
    
    private static void prepareServiceRequestMap(Map<Id, Map<String, String>> serviceRequestMap, String attrName,
    String attrValue, Contact con) {
        String val = attrValue;
        if(val == null) {
            val = '';
        }
        if(serviceRequestMap.containsKey(con.Id)) {
            serviceRequestMap.get(con.Id).put(attrName, val);
        } else {
            serviceRequestMap.put(con.Id, new Map<String, String>{attrName => val});
        }
    }
    
    /* Return boolean value if contact is internal or external */
    private static Boolean isInternal(Contact con) {
        Boolean isInternal;
        if(String.isBlank(con.IAM_Person_Type__c)) {
            if(con.IAM_Internal__c || con.IAM_Legacy_User__c) {
                isInternal = true;
            } else {
                isInternal = false;
            }            
        } else if(String.isNotBlank(con.IAM_Person_Type__c)) {
            if(con.IAM_Person_Type__c.equalsIgnoreCase('Contractor') || con.IAM_Person_Type__c.equalsIgnoreCase('CWK')
               || con.IAM_Person_Type__c.equalsIgnoreCase('Distributor') || con.IAM_Person_Type__c.equalsIgnoreCase('Employee')
               || con.IAM_Person_Type__c.equalsIgnoreCase('Joint Venture') || con.IAM_Person_Type__c.equalsIgnoreCase('Supplier')
               || con.IAM_Person_Type__c.equalsIgnoreCase('Non-North America Distributor')
               || con.IAM_Person_Type__c.equalsIgnoreCase('Non-Person') || con.IAM_Person_Type__c.equalsIgnoreCase('Ex-employee')
               || con.IAM_Internal__c || con.IAM_Legacy_User__c) {
            	isInternal = true;    
            } else {
                isInternal = false;
            }            
        }
        return isInternal;
    }

    /* Return Map of Account Id Vs its Service Provider Code */
    private static Map<Id, String> getAccountSPCodes(List<Contact> contactList) {
        Map<Id, String> accountSPCodeMap = new Map<Id, String>();
        for(Contact con : [SELECT AccountId, Account.IAM_Service_Provider_Code__c FROM Contact WHERE Id IN: contactList]) {
            if(!accountSPCodeMap.containsKey(con.AccountId)) {
                accountSPCodeMap.put(con.AccountId, con.Account.IAM_Service_Provider_Code__c);
            }
        }
        System.debug('#### accountSPCodeMap - ' + accountSPCodeMap);
        return accountSPCodeMap;
    }
}