public class CG_WS_QSOL {
    public static String responseMsg;
    public static CG_OP_OAGWrapper getAccessToken(String serviceName){
        string accessToken;
        string endPoint;
        Datetime startDt;
        Datetime endDt;
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
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
            }else{
              endPoint = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
              client_id = 'wQPYUk3iFjCz7sofEcwrXu+voqsIza/dbcO5QlGuxTVNg/ly+0Sy1nWe57U01ngfRWq9ogg3q6LfncwdAZmBg==';   
              client_secret ='7r7F6tyJlMmmC6JHSUMqK6dEUPvhL172LYrK6URZB3zKLO45503MD61NA8LSTQCRvGn7Qroo3CkG7RRlFe9Bw==';  
            }
            
            //key = ConDetails.Key__c; 
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            //req.setBody('{apiKey='+client_secret+'&client_id='+client_id+'}');
            req.setBody('{"apiKey":"'+client_secret+'","clientId":"'+client_id+'"}');
            //req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+key+'"}');
            //req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
            system.debug('req>>>>>>>.>>>'+req.getBody());
            HttpResponse res = new HttpResponse();
            startDt = System.now();
            endDt = System.now();
            res = http.send(req);
            string jSONRequestBody = res.getBody();
            system.debug('jSONRequestBody'+jSONRequestBody);
            // CG_WPR_MuleTokenResJSON wprObj = (CG_WPR_MuleTokenResJSON)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            //Modified as part of observation.-Gopal
            CG_J2AQsolToken wprObj = (CG_J2AQsolToken)JSON.deserializeStrict(jSONRequestBody,CG_J2AQsolToken.class); 
            accessToken = wprObj.apiToken;
            System.debug('ACCESS TOKEN BODY: '+res.getBody());  
            System.debug('ACCESS TOKEN Status: '+res.getStatus());
            System.debug('ACCESS TOKEN Status Code: '+res.getStatusCode());
            returnWrapper.accessToken = accessToken;
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;
            
        }
        catch(exception e){
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +'----------->>>>'+e.getLineNumber());
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>we'+e.getCause());
            
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
            returnWrapper.appName = 'OAGToken';
            returnWrapper.endPoint = endPoint;
            
        }
        
        system.debug('returnWrapper'+returnWrapper);
        return returnWrapper;        
    } 
    /*public static CG_CL_GetEngineDataPlateRespWrapper callGetEngineDataPlateQSOLService(String ESN){
CG_CL_GetEngineDataPlateRespWrapper DataPlateRespWrapper;
String endPointURL;
string message;
HttpResponse res1;
String bmsUsername;
String bmsPassword;
string jsonResponse;
CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();

try{
Http h1 = new Http();
HttpRequest req1 = new HttpRequest();
if(!Test.isRunningTest()){
conDetails = CSS_getConnnectionDetails.getConnection('GetEngineDataPlateQSOLREST');          
bmsUsername = conDetails.Username__c; 
bmsPassword = conDetails.Passcode__c;     
//Setting Endpint URL 
endPointURL = conDetails.End_Point__c+'?SerialNumber='+ESN+'';
}
else
endPointURL = 'https://quickserve.cummins.com/integrationservices/api/dataplate?serialNumber=79462241';
//getting Access Token 
//String access_token = CSS_SRT.receiveToken();
String access_token = getAccessToken('QsolToken');
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
//Building Request 
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setEndpoint(endPointURL);

//Sending request and mapping the response 
res1 = h1.send(req1);
System.debug('Status Code >>> :: '+res1.getStatusCode());
system.debug('Response Body >>>'+res1.getbody());
//Setting response to the string
jsonResponse = res1.getBody();

/*if(res1!=null && res1.getStatusCode()!=200 && res1.getStatusCode()!=201){
//CSS_PageErrorHandlingUtility.showError('CSS is unable to establish integration services at this time.  No Data returned.  Please capture customer information.');
throw new CSS_CustomException('System is Down' + res1.getStatusCode());
}*/
    /* }catch(Exception ex){
System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
System.debug('getLineNumber*********************is :: '+ex.getMessage());
jsonResponse = '{"Header":{"Status":"SYSTEM","Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"02400-02394"}},"DataArea": []}';
system.debug('jsonResponse>>>'+jsonResponse);
if(!Test.isRunningTest()){
message = ex.getMessage();

}
}
DataPlateRespWrapper = (CG_CL_GetEngineDataPlateRespWrapper)JSON.deserializeStrict(jsonResponse,CG_CL_GetEngineDataPlateRespWrapper.class);
system.debug('DataPlateRespWrapper in ws bms>>>'+DataPlateRespWrapper);
return DataPlateRespWrapper;
}*/
    public static CG_OP_OAGWrapper calloutGeneric(CG_IP_OAGWrapper reqWrapper) {
        system.debug('in calloutGeneric method...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
            system.debug('reqWrapper>>>>:'+reqWrapper);
            system.debug('reqWrapper.serviceName>>>>:'+reqWrapper.serviceName);
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
            system.debug('conDetails>>>:'+conDetails);
            system.debug('conDetails.AuthEnv__c>>>:'+conDetails.AuthEnv__c);
            
            CG_OP_OAGWrapper accessTokenOPWrap = getAccessToken(conDetails.AuthEnv__c);
            system.debug('**accessTokenOPWrap**'+accessTokenOPWrap);
            
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = accessTokenOPWrap.exceptionMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;
            system.debug('accessTokenOPWrap>>>:'+accessTokenOPWrap);
            map<string,string> Params = (map<string,string>)JSON.deserialize(reqWrapper.jsonReqBody, map<string,string>.class);
            system.debug('Params**'+Params);
            HttpRequest req = new HttpRequest();
            
            string endPoint;
            if(reqWrapper.serviceName == 'GetEngineDataPlateQSOLREST' || reqWrapper.serviceName == 'GetOptionsforQsolREST')
                endpoint = conDetails.End_Point__c+Params.get('ESN');
            else if(reqWrapper.serviceName == 'GetWattantyDocsforQsolREST')
                endPoint = conDetails.End_Point__c+Params.get('ESN')+'&documentType='+Params.get('faType')+'&language='+Params.get('qsolLang');
            else if(reqWrapper.serviceName == 'GetFaultCodeOverviewQsolREST')
            endpoint = conDetails.End_Point__c+Params.get('ESN')+'&faultCode='+Params.get('faultCode');
            else if(reqWrapper.serviceName == 'GetLinkMgmtQsolREST')
                endPoint = conDetails.End_Point__c+Params.get('ESN')+'&businessUnit='+Params.get('businessUnit')+'&language='+Params.get('qsolLang')+'&documentType='+Params.get('documentType')+'&documentId='+Params.get('documentId');
            system.debug('endpoint**'+endpoint);
            req.setEndpoint(endpoint);
            System.debug('=======> ConDetails>>:'+conDetails.End_Point__c);
            req.setHeader('client-id', conDetails.Username__c); //new header param //271bf3f9be404e4b9a3a85559a2cecb3
            req.setHeader('client-secret', conDetails.Passcode__c); //new header param //74A587c3C7Ff45A38B87A6C49ec29299
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +accessToken);
            // req.setBody(reqWrapper.jsonReqBody);
            system.debug('Method_Type__c>>>:'+conDetails.Method_Type__c);
            // System.debug('===reqWrapper.jsonReqBody====' + reqWrapper.jsonReqBody);
            req.setMethod(conDetails.Method_Type__c);
            Integer timeOut = conDetails.Timeout__c.intValue();
            req.setTimeout(timeOut);    
            //req.setTimeout(120000);
            system.debug('client-id>>'+conDetails.Username__c);
            system.debug('client-secret>>'+conDetails.Passcode__c);
            Http http = new Http();
            startDt = System.now();
            HttpResponse httpRes = new HttpResponse();
            system.debug('req***'+req);
            httpres = http.send(req);
            System.debug('in CG_WS_QSOL #####httpRes:'+httpRes+'  ######httpRes.getBody:'+httpRes.getBody());
            if (httpRes.getStatusCode() == 200) {
                System.debug('########### successfully executed ################');
                endDt = System.now();
                Long totalTime = endDt.getTime() - startDt.getTime();
                returnWrapper.totalServiceCallTime = totalTime;
                returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
                returnWrapper.request = req;
                returnWrapper.response = httpRes;
            }else{
                returnWrapper.exceptionFlag = true;
                String body = httpRes.getBody();
                Integer statusCode = httpRes.getStatusCode();
                String msg = statusCode + '---' + body;
                returnWrapper.exceptionMessage = msg;
                returnWrapper.serviceName = reqWrapper.serviceName;
                returnWrapper.endPoint = conDetails.End_Point__c;
            }
            return returnWrapper;
            
        }catch(Exception ex){
            //MANDATORY: In case of exception Set the exceptionFlag=true always
            System.debug('===Exception whie making callout getStackTraceString===:' + ex.getStackTraceString());
            system.debug('EXCEPTION of CG_WS_OAG - calloutGeneric Method ErrorMessage>>>>:'+ex.getMessage() + ' LineNumber>>:' + ex.getLineNumber() + ' Rootcause>>:' +ex.getCause());
            String stackTrace = ex.getStackTraceString();
            String msg = ex.getMessage();
            returnWrapper.exceptionMessage += msg;
            returnWrapper.exceptionMessage += stackTrace;
            returnWrapper.exceptionFlag = true;
            return returnWrapper;
        }
    }
   
}