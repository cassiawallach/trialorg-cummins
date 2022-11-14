/****************************************************************************************************************
Name: FSL_WS_OAG
Copyright Â© 2019  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for OAG Token generation.
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0     	SRIPRADA SESHAM			01/18/2019		Initial Development
2.0			Ravikanth Macherla		02/18/2020		Added logic for integration loggig
********************************************************************************************************************/
public class FSL_WS_OAG {
    // Here is the method for the gettoken access for the FSL Batch classes through the custom settings.
    public static String getAccessToken() {
        string accessToken;
        string endPoint;
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        try {
            //HttpRequest req = new HttpRequest();
            Http http = new Http();
            String client_id;
            String client_secret;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!Test.isRunningTest()) {
                conDetails = CSS_getConnnectionDetails.getConnection('OAGOAuth');
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c; 
                // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'WS_OAG',res.getStatus(),'code','toolid',''));
            }
            else {
                endPoint = 'https://services-stg-oauth.cummins.com/api/oauth/token/css';
                client_id ='20f56d87-8e65-46ce-9649-85d7c9335db7';
                client_secret='d95d65da-f878-489a-aa1e-20919269cc19';
            }
            req.setEndpoint(endPoint);
            system.debug('endpointurl-->'+endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
            // HttpResponse res = new HttpResponse();
            if(!Test.isRunningTest()) {
                res = http.send(req);
                //system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'WS_OAG',res.getStatus(),'code','toolid',''));
            }
            else {
                // res.setBody('{"access_token":"IvQYbkL2r1vDOo0VNNpmKY1kA5zasEJRff1maIqCF2Bd86kqswWXbW","token_type":"Bearer","expires_in":24000,"refresh_token":"a2fhaPuDMa2yu1mSgAPSYIkg7RLUMdmsr3RaL4qawHXBr6","scope":"CSSCloud"}');
                res.setBody('{"access_token":"1qbB3Z5A6AWVmJe2kioYRnU4sGteyNOnn84Q15hiOijEy43Yx5BWMf","token_type":"Bearer","expires_in":1200,"refresh_token":"n3iboQhnqgCTm39vjbBcAcO9EMSRvgEUvvbLwl60QhFnga","scope":"CSSCloud"}');
                res.setStatusCode(200);
                res.setStatus('success');
            }
            string jSONRequestBody = res.getBody();
            system.debug('jSONRequestBody**'+jSONRequestBody);
            CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            system.debug('wo1**'+wo1);
            accessToken = wo1.access_token;
            System.debug('BODY: '+res.getBody());  
            System.debug('Status: '+res.getStatus());
            System.debug('Status Code: '+res.getStatusCode());
        }
        catch(exception e) {
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +e.getLineNumber());
            // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),res.getBody(),Null,Null,'WS_OAG',res.getStatus(),'code','toolid',''));            
        }
        return accessToken;        
    }
    
    // To get the access token for CDS APIs from Custom Settings
    public static String getAccessTokenCDS(String connection) {        
        // DeserializeResponse resp2 = null;
        DateTime startTime = System.Now();
        HttpResponse resp1 = null;
        String accessToken = null;
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        CSS_Integration_Details__c intgrtnDetails ;
        if(CSS_Integration_Details__c.getall().containsKey(connection))
            intgrtnDetails = CSS_Integration_Details__c.getInstance(connection);
        if(intgrtnDetails != null) {
            if(String.isNotBlank( intgrtnDetails.End_Point__c))
                req.setEndpoint(intgrtnDetails.End_Point__c);
            if(String.isNotBlank(intgrtnDetails.Username__c))
                req.setHeader('client_id', intgrtnDetails.Username__c);
            if(String.isNotBlank(intgrtnDetails.Passcode__c))
                req.setHeader('client_secret', intgrtnDetails.Passcode__c);
        }
        else {
            req.setEndpoint('https://cdsdomain-stg.cummins.com/api/v1/GetToken');
            req.setHeader('client_id', '562e164f-f255-4eff-9c29-3ceed139c0dd');
            req.setHeader('client_secret', 'nFdnKFgXVjKg5JZTOmA2zzCaSUgh0FZi6GXvJBYFV4M=');//
        }      
        system.debug('check request'+req);
        try {
            resp1 = h.send(req);
            system.debug('RESPONSE'+resp1);
            String tokenStr;
            if(resp1.getStatusCode() == 200) {
                System.debug('JRT - Response from OAuth: '+resp1.getbody());
                tokenStr=(String)JSON.deserialize(resp1.getBody(), String.Class);
            }
            // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),resp1.getBody(),Null,Null,'WS_OAG',resp1.getStatus(),'code','toolid',''));
            return tokenStr;
        } catch(Exception e) {
            // system.enqueuejob(new FSL_ApplicationLoggerQueueable(req.getBody(),resp1.getBody(),Null,Null,'WS_OAG',resp1.getStatus(),'code','toolid',''));
            if(resp1 != null) {
                System.debug('JRT - Response from OAuth: '+resp1.getbody());
            }
            return null;
        }
    }
}