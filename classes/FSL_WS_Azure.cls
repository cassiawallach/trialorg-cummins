public class FSL_WS_Azure {
    public static FSL_OP_OAGWrapper getAccessToken(String serviceName){
        string accessToken;
        string endPoint;
        Datetime startDt;
        Datetime endDt;
        FSL_OP_OAGWrapper returnWrapper = new FSL_OP_OAGWrapper(); 
        HttpResponse res = new HttpResponse();
        try{
            System.debug('=====GETTING ACCESS TOKEN FOR SERVICE===='+serviceName);
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            string client_id;
            string client_secret;
            string key;
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            if(!test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection(serviceName);
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c;
                key = ConDetails.Key__c; 
            }else{
                endPoint = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
                client_id = 'wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO5QlGuxTVNg/ly+0Sy1nWe57U01ngfRWq9ogg3q6LfncwdAZmBg==';   
                client_secret ='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8LSTQCRvGn7Qroo3CkG7RRlFe9Bw==';  
            }
            req.setEndpoint(endPoint);
            req.setMethod('GET');
            req.setHeader('Content-Type','application/json');
            req.setHeader('client_secret',client_secret);
            req.setHeader('client_id',client_id);
            //req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+key+'"}');
            System.debug(':::endPoint>>>>>>>.>>>'+endPoint);
            res = new HttpResponse();
            startDt = System.now();
            endDt = System.now();
            res = http.send(req);
            string jSONResponseBody = res.getBody();
            system.debug(':::jSONResponseBody>:'+jSONResponseBody);
            system.debug(':::res>:'+res);
            FSL_WPR_MuleTokenResJSON wprObj = (FSL_WPR_MuleTokenResJSON)JSON.deserializeStrict(jSONResponseBody,FSL_WPR_MuleTokenResJSON.class); 
            accessToken = wprObj.access_token;  //accessToken = jSONResponseBody; //no string response
            System.debug(':::ACCESS TOKEN BODY: '+res.getBody());  
            System.debug(':::ACCESS TOKEN Status: '+res.getStatus());
            System.debug(':::ACCESS TOKEN Status Code: '+res.getStatusCode());
            returnWrapper.accessToken = accessToken;
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;
        }catch(exception e){
            system.debug(':::Entered into catch of Azure token Method in FSL_WS_Azure>>>:'+e.getMessage() +' LineNo:'+e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.exceptionMessage = 'Some error in getting Azure:'+e.getMessage();
            returnWrapper.errorMessage = 'Some error in getting Azure:'+e.getMessage();
            returnWrapper.appName = 'OAGToken';
            returnWrapper.endPoint = endPoint;
            returnWrapper.response = res;
        }
        return returnWrapper;        
    }
    
    public static FSL_OP_OAGWrapper calloutGeneric(FSL_IP_OAGWrapper reqWrapper) {
        system.debug(':::in calloutGeneric method...');
        FSL_OP_OAGWrapper returnWrapper = new FSL_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        HttpResponse httpRes = new HttpResponse();
        try {
            system.debug(':::reqWrapper>>>>:'+reqWrapper);
            system.debug(':::reqWrapper.serviceName>>>>:'+reqWrapper.serviceName);
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
            //system.debug(':::AuthEnv:'+conDetails.AuthEnv__c+' conDetails>>>:'+conDetails);
            FSL_OP_OAGWrapper accessTokenOPWrap = getAccessToken(conDetails.AuthEnv__c);
            
            //In case of no access token return wrapper
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper = accessTokenOPWrap;
                //returnWrapper.exceptionFlag = true;
                //returnWrapper.exceptionMessage = accessTokenOPWrap.exceptionMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;
            
            
            String fileName = reqWrapper.jsonReqBody;  //Getting InsiteImage Azure FileName here
            Map<String,String> params = (Map<String,String>)JSON.deserialize(reqWrapper.jsonReqBody, Map<String,String>.class);
            system.debug(':::params**'+params);
            //String endPoint = conDetails.End_Point__c+fileName; //forming FileName as query param
            String endpoint = conDetails.End_Point__c+params.get('FileName'); //forming FileName as query param
            System.debug(':::=======> 1 endPoint>>:'+endPoint); //endPoint = 'https://fetchecmimages-dev.cummins.com/api/ECMimage?FileName=I-20190421-111230101-EB2C1D72.eif';
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPoint);
            //req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +accessToken);
            req.setMethod(conDetails.Method_Type__c);
            system.debug('Method_Type__c>>>:'+conDetails.Method_Type__c);
            System.debug(':::===reqWrapper.jsonReqBody====' + reqWrapper.jsonReqBody);
            System.debug(':::=======> endPoint>>:'+endPoint);
            Integer timeOut = conDetails.Timeout__c.intValue();
            req.setTimeout(timeOut);    
            //req.setTimeout(120000);
            Http http = new Http();
            startDt = System.now();
            httpRes = new HttpResponse();
            httpRes = http.send(req);
            System.debug(':::in FSL_WS_Azure #####httpRes:'+httpRes+'  ######httpRes.getBody:'+httpRes.getBody());
            if (httpRes.getStatusCode() == 200) {
                System.debug(':::########### successfully executed ################');
                endDt = System.now();
                Long totalTime = endDt.getTime() - startDt.getTime();
                returnWrapper.totalServiceCallTime = totalTime;
                returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
                returnWrapper.request = req;
                returnWrapper.response = httpRes; //adding httpRes to the return OP wrapper
            }else{
                returnWrapper.exceptionFlag = true;
                String body = httpRes.getBody();
                Integer statusCode = httpRes.getStatusCode();
                String msg = statusCode + '---' + body;
                returnWrapper.exceptionMessage = msg;
                returnWrapper.serviceName = reqWrapper.serviceName;
                returnWrapper.endPoint = conDetails.End_Point__c;
                returnWrapper.response = httpRes; //adding httpRes to the return OP wrapper
            }
            return returnWrapper;
            
        }catch(Exception ex){
            //MANDATORY: In case of exception Set the exceptionFlag=true always
            System.debug(':::===Exception whie making callout getStackTraceString===:' + ex.getStackTraceString());
            system.debug(':::EXCEPTION of FSL_WS_Azure - calloutGeneric Method ErrorMessage>>>>:'+ex.getMessage() + ' LineNumber>>:' + ex.getLineNumber() + ' Rootcause>>:' +ex.getCause());
            String stackTrace = ex.getStackTraceString();
            String msg = ex.getMessage();
            returnWrapper.exceptionMessage += msg;
            returnWrapper.exceptionMessage += stackTrace;
            returnWrapper.exceptionFlag = true;
            returnWrapper.response = httpRes; //adding httpRes to the return OP wrapper
            return returnWrapper;
        }
    }
}