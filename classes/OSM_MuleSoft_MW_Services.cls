public class OSM_MuleSoft_MW_Services {
    public static OSM_WS_AccessTokenOPWrapper getAccessToken(String serviceName, String mainService){ 
        string accessToken;
        string endPoint;
        Integer totalTime;
        OSM_WS_AccessTokenOPWrapper returnWrapper = new OSM_WS_AccessTokenOPWrapper();
        try{
            HttpRequest req = new HttpRequest();
            Http http = new Http();
            string client_id;
            string client_secret;
            string key;
            
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(serviceName);

            endPoint = conDetails.End_Point__c;
            client_id = conDetails.Username__c;   
            client_secret = ConDetails.Passcode__c;
            key=conDetails.Resource__c;
                
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+key+'"}');
            HttpResponse res = new HttpResponse();
            if(!Test.isRunningTest()) {
                res = http.send(req);
            } else {
                // Put Test data (Use custom labels)
                res.setBody('{"access_token":"YI0kfZt32tqtGp8y8Qv5jraIv640sjcknbjRh9EG1XZzsHJ4Dm43nE","token_type":"Bearer","expires_in":23999,"refresh_token":"4OxrrP9b6dMrTcu2NBuUCj1nCd5DFA93laxoMlHcWHt5Yh","scope":"CSO"}');
                res.setStatusCode(200);
            }

            string jSONRequestBody = res.getBody();
            OSM_WS_OAGAccessTokenWrapper wprObj = (OSM_WS_OAGAccessTokenWrapper)JSON.deserializeStrict(jSONRequestBody,OSM_WS_OAGAccessTokenWrapper.class); 
            accessToken = wprObj.access_token;
            returnWrapper.accessToken = accessToken;
            totalTime = limits.getCPUTime();
            returnWrapper.totalAuthCallTime = totalTime;
        }
        catch(exception e){
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
            returnWrapper.totalAuthCallTime = totalTime;
        }
        return returnWrapper;        
    }

    public static OSM_WS_OP_CSWrapper calloutGeneric(OSM_WS_IP_CSWrapper reqWrapper) {
        system.debug('in calloutGeneric method...');
        OSM_WS_OP_CSWrapper returnWrapper = new OSM_WS_OP_CSWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
            CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
            OSM_WS_AccessTokenOPWrapper accessTokenOPWrap = getAccessToken(conDetails.AuthEnv__c, reqWrapper.serviceName);        
            
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper.exceptionFlag = true;
                returnWrapper.errorMessage = accessTokenOPWrap.errorMessage;
                returnWrapper.Request = reqWrapper.jsonReqBody;
                returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
                return returnWrapper;
            }
            
            String accessToken = accessTokenOPWrap.accessToken;
            String endPointUrl = conDetails.End_Point__c;
            if(reqWrapper.serviceName == Label.OSM_Order_Get){
                endPointUrl = endPointUrl + '&OMSOrderID=' + reqWrapper.cmsOrderId;
                endPointUrl = endPointUrl + '&ToolName=' + reqWrapper.ToolName;
            }
            if(reqWrapper.serviceName == Label.CSO_Getlicensekey){
                endPointUrl = endPointUrl + '&ActivationKey=' + reqWrapper.ActivationKey;
                endPointUrl = endPointUrl + '&Timestamp=' + reqWrapper.Timestamp;
                endPointUrl = endPointUrl + '&MessageID=' + reqWrapper.MessageID;
                endPointUrl = endPointUrl + '&ToolName=' + reqWrapper.ToolName;
            }
            if(reqWrapper.serviceName == Label.BMS_CustomerGetAPI){
                endPointUrl = endPointUrl + '?sender=' + reqWrapper.SenderID;
                endPointUrl = endPointUrl + '&target=' + reqWrapper.TargetID;
                endPointUrl = endPointUrl + '&locationId=' + reqWrapper.LocationID;
                endPointUrl = endPointUrl + '&customerName=' + reqWrapper.CustomerName;
                endPointUrl = endPointUrl + '&customerCode=' + reqWrapper.CustomerCode;
                endPointUrl = endPointUrl + '&dealerCode=' + reqWrapper.DealerCode;
                
            }
            returnWrapper.APIURL=endPointUrl;
            System.debug('===endPointUrl====> ConDetails>>:  '+endPointUrl);
            
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endPointUrl);
            req.setHeader('client_id', conDetails.Username__c); 
            req.setHeader('client_secret', conDetails.Passcode__c);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +accessToken);
            
            if(reqWrapper.serviceName != Label.OSM_Order_Get && reqWrapper.serviceName != Label.CSO_Getlicensekey && reqWrapper.serviceName != Label.BMS_CustomerGetAPI){
                req.setBody(reqWrapper.jsonReqBody);                
            }
            
            conDetails.Timeout__c = 120000;
            system.debug('Method_Type__c>>>:'+conDetails.Method_Type__c);
            System.debug('===reqWrapper.jsonReqBody====' + reqWrapper.jsonReqBody);
            req.setMethod(conDetails.Method_Type__c);
            Integer timeOut = conDetails.Timeout__c.intValue();
            req.setTimeout(timeOut);
            returnWrapper.requestTime = (system.now()).format('yyyyMMddhhmmss');
            
            Http http = new Http();
            HttpResponse httpRes = new HttpResponse();
            httpres = http.send(req);
            returnWrapper.responseTime = (system.now()).format('yyyyMMddhhmmss');

            System.debug('#####httpRes:'+httpRes+'  ######httpRes.getBody:'+httpRes.getBody());
            if (httpRes.getStatusCode() == 200) {
                System.debug('########### successfully executed ################');
                endDt = System.now();
                Integer totalTime = limits.getCpuTime();
                returnWrapper.totalServiceCallTime = totalTime;
                returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
                returnWrapper.request = reqWrapper.jsonReqBody;
                returnWrapper.response = httpRes.getBody();
                system.debug('httpRes----res Body--'+httpRes.getBody());
                
            }else{
                returnWrapper.exceptionFlag = true;
                String msg = httpRes.getStatusCode() + '---' + httpRes.getBody();

                returnWrapper.errorMessage = msg;
            }
            return returnWrapper;

        }catch(Exception ex){
            //MANDATORY: In case of exception Set the exceptionFlag=true always
            System.debug('===Exception whie making callout getStackTraceString===:' + ex.getStackTraceString());
            system.debug('EXCEPTION of CG_WS_OAG - calloutGeneric Method ErrorMessage>>>>:'+ex.getMessage() + ' LineNumber>>:' + ex.getLineNumber() + ' Rootcause>>:' +ex.getCause());
            returnWrapper.errorMessage += ex.getMessage() + ' ' +ex.getStackTraceString();
            returnWrapper.exceptionFlag = true;
            returnWrapper.responseTime = (system.now()).format('yyyyMMddhhmmss');
            return returnWrapper;
        }
    }
}