/**********************************************************************
Name: CSS_WS_OAG
Copyright © 2016  Cummins
======================================================
======================================================
Purpose: Class contains Prepare Token and Execute Rest Webservice Methods 
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE          DETAIL                                 
1.0     Anirudh Pesari    04-11-2017      Initial Development    
***********************************************************************/
public class CSS_WS_OAG
{
public static string getAccessToken(){
        string accessToken;
        string endPoint;
        try{
            HttpRequest req = new HttpRequest();
        Http http = new Http();
        string client_id;
        string client_secret;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('OAGOAuth');
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c;
            }
            else{
                endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
                client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
            }
        req.setEndpoint(endPoint);
        system.debug('endpointurl-->'+endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){
            res = http.send(req);
        }
            else{
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
            //accessToken = 'LQmTmbn1tl9K68K5U8Qd87HoMtmImCqNICPy4dcVo04h8gTm0Nw8oS'; //Hardcoding: Kalpana
        }
        catch(exception e){
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +e.getLineNumber());
        }
        return accessToken;        
    }
    
    //Method used for getting test accesstoken
    public static string getAccessTokenTest(){
        string accessToken;
        string endPoint;
        try{
            HttpRequest req = new HttpRequest();
        Http http = new Http();
        string client_id;
        string client_secret;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('OAGOAuthDev');
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c;
            }
            else{
                endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
                client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
            }
        req.setEndpoint(endPoint);
        system.debug('endpointurl-->'+endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
        HttpResponse res = new HttpResponse();
        if(!Test.isRunningTest()){
            res = http.send(req);
        }
            else{
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
            //accessToken = 'LQmTmbn1tl9K68K5U8Qd87HoMtmImCqNICPy4dcVo04h8gTm0Nw8oS'; //Hardcoding: Kalpana
        }
        catch(exception e){
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +e.getLineNumber());
        }
        return accessToken;        
    }
    
        
    //This method is used for executing REST webservices
    public static HttpResponse executeRESTWebservice(String jSONReqBody, String endPointURL, String accessToken){
        System.debug('Entered into Execute Rest Webservice');
         HttpRequest httpReq; 
         HttpResponse httpRes;
        try{
            System.debug('endPointURL>>>>>'+endPointURL+' jSONReqBody>>>'+jSONReqBody);
            httpReq = new HttpRequest();
            httpReq.setHeader('Authorization', 'Bearer '+accessToken);
            httpReq.setHeader('Content-Type', 'application/json');
            httpReq.setMethod('POST');
            httpReq.setTimeout(120000);
            httpReq.setEndpoint(endPointURL);
            httpReq.setBody(jSONReqBody);
            httpRes = new Http().send(httpReq);
            system.debug('HEADER>>>>>>>'+httpReq.getHeader('Authorization'));
            system.debug('RESPONSE_BODY>>>>>>>>>'+httpRes.getbody()+' httpRes getStatusCode>>>>> '+httpRes.getStatusCode());
        }catch(Exception e){
            System.debug('in catch of executeRESTWebservice of CSS_WS_OAG >>>>>getLineNumber is ::'+e.getLineNumber()+' Exception Message>>>'+e.getMessage());
        }
        return httpRes;
    }
}