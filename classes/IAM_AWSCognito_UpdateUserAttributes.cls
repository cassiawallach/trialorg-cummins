/*************************************************************************************
Name:  IAM_AWSCognito_UpdateUserAttributes
Copyright © 2019  Cummins
**************************************************************************************
Purpose: This class calls AWS Cognito Update_User_Attributes API service if fields 
username, swregexpire date, workgroupid, uniqueId are changed in Salesforce
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Shubhangi Sardar      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar      09/07/2021      Added error logs to capture report
**************************************************************************************
**************************************************************************************/

global class IAM_AWSCognito_UpdateUserAttributes {
    
	@future(Callout=true)
    global static void updateUserAttributes(String username, Map<String, String> attributeMapCon, Boolean isInternalUser) {                                            
        HTTPResponse res;
        String body;
        try {
            String accessToken;
            if(Test.isRunningTest()) {
                accessToken = 'lm6KXDoEgwYudGtKDBoSIxq6kxAG6L5LfUhtdWSpNyehpRiaqby5Cz';
            } else {
                accessToken = IAM_AWSCognito_GetAuthToken.getAccessToken('IAM_AWSCognito_Auth');
            }
            /* Get update user service (Integration) details */
            CSS_Integration_Details__c serviceDetails = new CSS_Integration_Details__c();
            serviceDetails = IAM_AWSCognito_ConnectionDetails.getConnection('IAM_AWSCognito_UserAction');
            System.debug('#### connection details '+serviceDetails);
            Map<String, String> attributeMap = new Map<String, String>();
            attributeMap = attributeMapCon;
            if(isInternalUser) {
                body = IAM_AWSCognito_Parser.getUpdateUserRequestBody('Update_User_Attributes', username, attributeMap, 
            		Label.IAM_AWSCognito_Source_System, Label.IAM_AWSCognito_IDP_Internal);
            } else {
            	body = IAM_AWSCognito_Parser.getUpdateUserRequestBody('Update_User_Attributes', username, attributeMap, 
            		Label.IAM_AWSCognito_Source_System, Label.IAM_AWSCognito_IDP);
            }
            System.debug('#### body '+body);
            HttpRequest req = new httpRequest();
			req.SetMethod('POST');  
            req.setEndpoint(serviceDetails.End_Point__c);
            req.setBody(body);
            req.setHeader('client-id', serviceDetails.Passcode__c);
            req.setHeader('client-secret', serviceDetails.Key__c);
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization','Bearer '+accessToken); 
            req.setTimeout(12000);
           	System.debug('#### httpRequest '+req.toString());
            /* Send Request */
        	res = new HTTP().send(req);
            if(res != null && res.getStatusCode() == 200) {
                System.debug('### response body - '+res.getBody());
                String responseBody= res.getBody();
                IAM_AWSCognito_Parser.Response_UserAction obj = 
                new IAM_AWSCognito_Parser.Response_UserAction();
                obj = IAM_AWSCognito_Parser.getResponse_UserAction(responseBody);            
                System.debug('### Response obj - '+obj);
                if(obj.Status.equalsIgnoreCase('Error')) {
                    System.debug('### Response obj msg - '+obj.Message);
                    IAM_ErrorHandling.IAMerrorCapture(body, Label.IAM_AWSCognito,
                    res.getBody(), IAM_AWSCognito_UpdateUserAttributes.class.getName(),
                    username);
                }
            } else if(res != null && res.getStatusCode() != 200) {
                IAM_ErrorHandling.IAMerrorCapture(body, Label.IAM_AWSCognito, res.getBody(),
                IAM_AWSCognito_UpdateUserAttributes.class.getName(), username);
            }
        } catch(Exception e) {
            System.debug('#### Exception '+ e.getMessage());
            IAM_ErrorHandling.IAMerrorCapture(body, Label.IAM_AWSCognito,
            e.getStackTraceString() + ' : ' + e.getMessage(),
            IAM_AWSCognito_UpdateUserAttributes.class.getName(), username);
        }        
    }
}