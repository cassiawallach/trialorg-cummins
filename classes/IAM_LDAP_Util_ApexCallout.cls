/*************************************************************************************
Name:  IAM_LDAP_Util_ApexCallout
Copyright © 2019  Cummins
**************************************************************************************
Purpose: It call LDAP API to create or update user details in LDAP system
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1.0      Keerthy Gutumurthy        11/16/2018        INITIAL DEVELOPMENT
1.1      Karthik Raj Golakaram     11/16/2020        Made changes for Mule API 
1.2      Chetan Gaikwad            01/07/2021        Update to avoid storing success 
                                                     records in IAM_ErrorHandling class
**************************************************************************************
**************************************************************************************/
global without sharing class IAM_LDAP_Util_ApexCallout {

    @future(Callout=true)
    public static void sendToLDAP(Set<Id> id, String action) {
        callLDAPCreateOrUpdateUserAPI(id, action);
    }

    public static void callLDAPCreateOrUpdateUserAPI(Set<Id> id, String action) { 
        //calling request parser class to get the request
        System.debug('Printing Contact ids'+id);
        String JSONString = IAM_LDAP_Util_ReqParser.IAM_LDAP_Util_ReqBody(Id);
        System.debug('Printing request Body'+JSONString);
        HttpResponse res;
        String accessToken;
        if(Test.isRunningTest()) {
            accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
            System.debug('#### In Test.isRunningTest - accessToken - '+accessToken);
        } else {
            // Mule Access token
            accessToken = IAM_Mule_oAuth_Access_Token.generateAccessToken('IAM_Mule_oAuth');
        }
        CSS_Integration_Details__c iamLDAP = new CSS_Integration_Details__c();            
        if(action == 'Insert') {
            iamLDAP = IAM_getConnnectionDetails.getConnection('IAM_LDAP_Create_Mule');
        } else if(action=='Update') {
            iamLDAP = IAM_getConnnectionDetails.getConnection('IAM_LDAP_Update_Mule');
        }       
        if(String.isNotBlank(JSONString)) {
            try{
                Map<String, String> headerMap = new Map<String, String>();
                headerMap.put('Content-Type','application/json');
                headerMap.put('Authorization','Bearer '+accessToken);
                headerMap.put('resourse',iamLDAP.Resource__c);

                /* Get Response */
                res = IAM_HTTP_Callout.sendHTTPRequest(iamLDAP.Method_Type__c, iamLDAP.End_Point__c,
                headerMap, JSONString);             
                
                if(res.getStatusCode() == 200){
                    String response = res.getBody();
                    Boolean errorInResopnse = false;
                    //code start - updated below code to avoid tracking of suceess records - Chetan Gaikwad - 01/07/2021
                    if(String.isNotBlank(response)) {
                        List<IAM_LDAP_Util_Wrapper> ldapResponse = (List<IAM_LDAP_Util_Wrapper>) JSON.deserialize(response, 
                        List<IAM_LDAP_Util_Wrapper>.class);
                        System.debug('ldapResponse@@'+ldapResponse); 
                        for(IAM_LDAP_Util_Wrapper objwrapper : ldapResponse) {
                            String reqStatus = objwrapper.status;
                            System.debug('@reqStatus :'+reqStatus);
                            if(!reqStatus.contains('success')) {
                                errorInResopnse= true;
                                break;
                            }
                        }
                    }
                    if(errorInResopnse){
                        System.debug('Error occurred');
                        IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Identity_LDAP,
                        res.getBody(), IAM_LDAP_Util_ApexCallout.class.getName());
                    }
                    //code end - updated below code to avoid tracking of suceess records - Chetan Gaikwad - 01/07/2021
                } else if(res.getStatusCode() != 200 ) {
                    IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Identity_LDAP,
                    res.getBody(), IAM_LDAP_Util_ApexCallout.class.getName());
                }               
            } catch(Exception ex) {                
                IAM_ErrorHandling.IAMerrorCapture(JSONString, Label.IAM_Identity_LDAP, 
                ex.getStackTraceString() + ' - ' + ex.getMessage(), IAM_LDAP_Util_ApexCallout.class.getName());
                System.debug('ERROR Message:-->:'+ ex);              
            }
        }
    }      
}