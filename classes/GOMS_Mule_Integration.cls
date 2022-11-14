public class GOMS_Mule_Integration {

    public static GOMS_OP_Wrapper getAccessToken(String serviceName, String mainService){ 
        string accessToken;
        string endPoint;
        Datetime startDt;
        Datetime endDt;
        GOMS_OP_Wrapper returnWrapper = new GOMS_OP_Wrapper();
        try{
            //system.debug('=====GETTING ACCESS TOKEN FOR SERVICE===='+serviceName);
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            string client_id;
            string client_secret;
            string key;
            string keyMain;
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(serviceName); //new CSS_Integration_Details__c();
            //conDetails = CSS_getConnnectionDetails.getConnection(serviceName);

            endPoint = conDetails.End_Point__c;
            client_id = conDetails.Username__c;   
            client_secret = ConDetails.Passcode__c;
            //key = ConDetails.Key__c;
            key=conDetails.Resource__c;
        
            
                
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+key+'"}');
            HttpResponse res = new HttpResponse();
            startDt = System.now();
            endDt = System.now();
            
            if(!Test.isRunningTest()) {
                res = http.send(req);
            } else {
                // Put Test data (Use custom labels)
                res.setBody('{"access_token":"YI0kfZt32tqtGp8y8Qv5jraIv640sjcknbjRh9EG1XZzsHJ4Dm43nE","token_type":"Bearer","expires_in":23999}');
                res.setStatusCode(200);
            }

            string jSONRequestBody = res.getBody();
            CG_WPR_MuleTokenResJSON wprObj = (CG_WPR_MuleTokenResJSON)JSON.deserializeStrict(jSONRequestBody,CG_WPR_MuleTokenResJSON.class); 
            accessToken = wprObj.access_token;
            //system.debug('accesstoken>>>>>'+accessToken);
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;
            returnWrapper.accessToken=accessToken;
        }
        catch(exception e){
            //system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
        }
        return returnWrapper;        
    }

    public static GOMS_OP_Wrapper calloutGeneric(GOMS_IP_IntegrationRequestWrapper reqWrapper) {
        //system.debug('in calloutGeneric method...');
        GOMS_OP_Wrapper returnWrapper = new GOMS_OP_Wrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
       startDt = System.now();
        try {
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName); //new CSS_Integration_Details__c();
            //conDetails = CSS_getConnnectionDetails.getConnection(reqWrapper.serviceName);
            //conDetails.AuthEnv__c = 'MuleAuth'; //since it is null in PROD
            GOMS_OP_Wrapper accessTokenOPWrap = getAccessToken(conDetails.AuthEnv__c, reqWrapper.serviceName);        
            
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = accessTokenOPWrap.errorMessage;
                return returnWrapper;
            }
            
            String accessToken = accessTokenOPWrap.accessToken;
            HttpRequest req = new HttpRequest();
            req.setEndpoint(conDetails.End_Point__c);

            //system.debug('=======> ConDetails>>:'+conDetails.End_Point__c);
            req.setHeader('client_id', conDetails.Username__c); 
            req.setHeader('client_secret', conDetails.Passcode__c);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +accessToken);
            
            //system.debug('client_id>>>>'+conDetails.Username__c);
            
           /* req.setHeader('client_id','88f68e16c0b94c07a56fadd03f560f23'); 
            req.setHeader('client_secret', 'c8C77c2f08274fc6a1C1e74C989B488F');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +accessToken);*/
            //req.setMethod('POST');
            //system.debug('header>>>>'+req);
            req.setBody(reqWrapper.jsonReqBody);
            conDetails.Method_Type__c = 'POST';//Added New
            conDetails.Timeout__c = 120000;//Added New
            //system.debug('Method_Type__c>>>:'+conDetails.Method_Type__c);
            //system.debug('===reqWrapper.jsonReqBody====' + reqWrapper.jsonReqBody);
            req.setMethod(conDetails.Method_Type__c);
            Integer timeOut = conDetails.Timeout__c.intValue();
            req.setTimeout(timeOut);    
            //system.debug('id>>>>>>>' + req.getHeader('client_id'));
            //system.debug('secret>>>>>>>' + req.getHeader('client_secret'));
            //system.debug('Authorization' + req.getHeader('Authorization'));
            Http http = new Http();
            HttpResponse httpRes = new HttpResponse();
            httpRes = http.send(req);
            //system.debug('#####httpRes:'+httpRes+'  ######httpRes.getBody:'+httpRes.getBody());
            if (httpRes.getStatusCode() == 200) {
                //system.debug('########### successfully executed ################');
                endDt = System.now();
                
                Long totalTime = endDt.getTime() - startDt.getTime();
                returnWrapper.totalServiceCallTime = totalTime;
                returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
                returnWrapper.request = req;
                returnWrapper.response = httpRes;
                //system.debug('httpRes----res Body--'+httpRes.getBody());
                
            }else{
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = httpRes.getStatusCode() + '---' + httpRes.getBody();
            }
            return returnWrapper;

        }catch(Exception ex){
            //MANDATORY: In case of exception Set the exceptionFlag=true always
            //system.debug('===Exception whie making callout getStackTraceString===:' + ex.getStackTraceString());
            //system.debug('EXCEPTION of CG_WS_OAG - calloutGeneric Method ErrorMessage>>>>:'+ex.getMessage() + ' LineNumber>>:' + ex.getLineNumber() + ' Rootcause>>:' +ex.getCause());
            returnWrapper.exceptionMessage += ex.getMessage() + ' ' + ex.getStackTraceString();
            returnWrapper.exceptionFlag = true;
            return returnWrapper;
        }
    }
}