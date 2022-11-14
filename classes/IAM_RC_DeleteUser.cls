/*************************************************************************************
Name:  IAM_RC_DeleteUser
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It call LDAP API to deactivate user in LDAP system
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1.0      Karthik Raj Golakaram        11/16/2018        INITIAL DEVELOPMENT
1.1      Karthik Raj Golakaram        11/16/2020        Added MULE API Endpoint
1.2      Shubhangi Sardar             27/04/2021        Get branch name from  IAM_DN_Value__c
**************************************************************************************
**************************************************************************************/

public with sharing class IAM_RC_DeleteUser {

    @future(callout=true)
    public static void basicAuthCallout(Set<Id> cpId){
        String JSON_String = '';
        String errorDescription = '';
        String accessToken;
        if(Test.isRunningTest()) {
            accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
            System.debug('#### In Test.isRunningTest - accessToken - '+accessToken);
        } else {
            /* Mule access token */
            accessToken = IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
        }     
        
        try {

            List<Contact> contactList = getContactList(cpId);
            System.debug('Print:: ' + contactList);   
            UserPayload uinfo = new UserPayload(contactList);
            System.debug('Printing request wrapper :: ' + uinfo);
            if(uinfo != null){
                JSON_String = JSON.serialize(uinfo);
                System.debug('Printing serialized string sumit'+JSON_String);
            }
            CSS_Integration_Details__c iamLDAPdel = IAM_getConnnectionDetails.getConnection(
                'IAM_LDAP_User_Delete_Mule');
                
            Map<String, String> headerMap = new Map<String, String>();
            headerMap.put('Content-Type','application/json');
            headerMap.put('resource', iamLDAPdel.Resource__c);
            headerMap.put('Authorization','Bearer '+accessToken);

            /* Get Response */
            HttpResponse res = IAM_HTTP_Callout.sendHTTPRequest(iamLDAPdel.Method_Type__c,
            iamLDAPdel.End_Point__c, headerMap, JSON_String);
            if(res != null && res.getStatusCode() == 200){
                String response = res.getBody();
                boolean errorInResopnse = false;
                List<String> msgList = Label.IAM_LDAP_Messages.split(',');
                List<IAM_LDAP_Util_Wrapper> ldapResponse = (List<IAM_LDAP_Util_Wrapper>)JSON.deserialize(
                    response, List<IAM_LDAP_Util_Wrapper>.class);
                System.debug('ldapResponse@@'+ldapResponse); 
                for(IAM_LDAP_Util_Wrapper objwrapper : ldapResponse){
                    if(!msgList.contains(objwrapper.status)){
                        errorInResopnse= true;
                    }
                }
                if(errorInResopnse){
                    IAM_ErrorHandling.IAMerrorCapture(JSON_String, Label.IAM_Identity_LDAP,
                    errorDescription + ' ' + res.getBody(), IAM_RC_DeleteUser.class.getName());
                }
            } else if(res != null && res.getStatusCode() != 200 ) {
                JSONParser parser = JSON.createParser(res.getBody());
                System.debug('response===='+res.getBody());
                while(parser.nextToken() != null) {
                    if(parser.getCurrentToken() == JSONToken.FIELD_NAME 
                    && parser.getText() == 'errorDescription') {
                        parser.nextToken();
                        errorDescription += parser.getText()+',\n';
                        System.debug('error Description==='+errorDescription);
                    }                          
                }
                IAM_ErrorHandling.IAMerrorCapture(JSON_String, Label.IAM_Identity_LDAP,
                errorDescription + ' ' + res.getBody(), IAM_RC_DeleteUser.class.getName());
            }
        } catch(Exception e) {
            System.debug('ERROR Message:-->:'+ e);
            IAM_ErrorHandling.IAMerrorCapture(JSON_String, Label.IAM_Identity_LDAP, 
            e.getMessage(), IAM_RC_DeleteUser.class.getName());
        }
    }    
    
    /* Request parser wrapper class */
    public class UserPayload{
        public List<UserApp> Userinfo {set;get;}        
        public UserPayload(List<Contact> contactList) {
            Userinfo = new List<UserApp>();            
            for(Contact c : contactList) {
                UserApp uinfo = new UserApp();                                  
                uinfo.uid = c.Username__c;
                uinfo.branch = IAM_Utility.getBranchName(c.IAM_DN_Value__c);                 
                if(c.IAM_Contact_Status__c == Label.IAM_Status_Active && c.IAM_Internal__c == true
                && c.IAM_Legacy_User__c == true) {
                    uinfo.usertype = Label.IAM_Value_Internal;
                } else if((c.IAM_Contact_Status__c == Label.IAM_Status_Active
                || c.IAM_Contact_Status__c == Label.IAM_Inactive_Label)
                && c.IAM_Internal__c == false && c.IAM_Legacy_User__c == false) {
                    //In this case user will be purly of external user.
                    //After reclaim for extenal users we need to update the legacy flag to false.
                    uinfo.usertype = Label.IAM_Value_External;
                }else if((c.IAM_Contact_Status__c == Label.IAM_Status_Active
                || c.IAM_Contact_Status__c == Label.IAM_Inactive_Label)
                && c.IAM_Internal__c == false && c.IAM_Legacy_User__c == true) {
                    //In this case user will be ready to reclaim but not yet reached their phase.
                    uinfo.usertype = Label.IAM_Value_Legacy;
                }
                if(String.isNotBlank(uinfo.uid)){
                    Userinfo.add(uinfo);
                }
            } 
            System.debug('Userinfo.... '+ Userinfo);
        }      
    }
    
    /* Request Wrapper */
    public class UserApp {
        public String uid;
        public String branch;
        public String usertype;        
    }

    /* Return Contact List */
    public static List<Contact> getContactList(Set<Id> conIdSet) {
        return [
            SELECT Username__c
                 , IAM_Contact_Status__c
                 , IAM_Internal__c
                 , IAM_Legacy_User__c
                 , IAM_DN_Value__c
              FROM Contact
             WHERE Id IN :conIdSet
          ORDER BY Username__c
        ]; 
    }
}