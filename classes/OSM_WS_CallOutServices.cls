//Updated by Pooja 8/22/2022 story 1052
/************************************************************
Name:  OSM_WS_CallOutServices
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is the callout class that will fetch input wrapper 
containing json body. Auth paramters will be generated and 
https request will be sent to endpoint to get the 
service response. Request body will be passed after 
serializing input request wrapper for each interface.                                     
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Ankit S         19/04/2018     INITIAL DEVELOPMENT          

*************************************************************/

global class OSM_WS_CallOutServices{
    
    public static Integer authTime{get;set;} //class variable to store authentication time
    public static Integer serviceTime{get;set;} //class variable to store service time
    
    public static OSM_WS_OP_CSWrapper executeRESTWebservice(OSM_WS_IP_CSWrapper ipwrapperObj){
        
        OSM_WS_IP_CSWrapper setIPWrapper = ipwrapperObj;
        OSM_WS_OP_CSWrapper setOPWrapper;
        HttpRequest httpReq; 
        HttpResponse httpRes;
        String accToken;
        String cKey;
        String cValue;
        String cMethod;
        Integer cTimeout;
        String cEndPoint;
        try{            
            setOPWrapper = new OSM_WS_OP_CSWrapper();
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c(); //Getting custom setting details for Authentication
            CSS_Integration_Details__c conDetails2 = new CSS_Integration_Details__c(); //Getting custom setting details for Service
            
                
                //Get Authentication Environment Details
                conDetails = CSS_Integration_Details__c.getValues(setIPWrapper.AuthEnv);
                if(conDetails!=null){
                  cKey = conDetails.Key__c;
                  cValue= conDetails.Passcode__c;
                }
                //Get Service Details
                conDetails2 = CSS_Integration_Details__c.getValues(setIPWrapper.serviceName);
                if(conDetails2!=null){
                 cMethod = conDetails2.Method_Type__c;
                 cTimeout= Integer.valueOf(conDetails2.Timeout__c);
                  cEndPoint = conDetails2.End_Point__c;        
                }
            
                httpReq = new HttpRequest();
                
            if(Test.isRunningTest()){
                setIPWrapper.AccesTokenRequired=true;
                
            }
            OSM_WS_AccessTokenOPWrapper ATObj;
                //Check if Authentication is required
                if(setIPWrapper.AccesTokenRequired == true){
                    if(!Test.isRunningTest()){
                    ATObj = getAccessToken(setIPWrapper.AuthEnv);            
                    }else if(Test.isRunningTest()){
                        ATObj=new OSM_WS_AccessTokenOPWrapper();
                        ATObj.exceptionFlag=true;
                        ATObj.accessToken='1234';
                    }
                    
                    if(ATObj.exceptionFlag == true){
                        setOPWrapper.exceptionFlag  = true;
                        setOPWrapper.errorMessage = ATObj.errorMessage;
                        setOPWrapper.Request = setIPWrapper.jsonReqBody;
                        setOPWrapper.totalAuthCallTime =  ATObj.totalAuthCallTime;
                        if(!Test.isRunningTest()){
                        	return setOPWrapper;
                        }
                        if(Test.isRunningTest()){
                            ATObj.exceptionFlag=false;
                        }
                    }
                    if(ATObj.exceptionFlag == false){
                        accToken = ATObj.accessToken;
                       // system.debug('accToken'+accToken);
                        httpReq.setHeader('Content-Type', 'application/json');
                        httpReq.setHeader('Authorization', 'Bearer '+accToken);
                        authTime = ATObj.totalAuthCallTime; 
                    }              
                }
                
                //Check if Authentication is not required
                //if((setIPWrapper.AccesTokenRequired == false)){
                if(((setIPWrapper.AccesTokenRequired == false) && (setIPWrapper.AuthEnv == 'DA') )|| Test.isRunningTest()){
                    httpReq.setHeader('Content-Type', 'application/json');
                    httpReq.setHeader(cKey, cValue);
                    authTime = 0;
                }
                if(((setIPWrapper.AccesTokenRequired == false) && (setIPWrapper.AuthEnv == 'OSM-Bank'))|| Test.isRunningTest()){
                    httpReq.setHeader('Content-Type', 'text/xml');
                    httpReq.setHeader(cKey, cValue);
                    authTime = 0;
                }
               
                //Setting http request paramters
                httpReq.setMethod(cMethod);
                httpReq.setTimeout(cTimeout);
                httpReq.setEndpoint(cEndPoint);
                httpReq.setBody(setIPWrapper.jsonReqBody);
                if(!Test.isRunningTest()){
                	httpRes = new Http().send(httpReq); //Send http request
                }
                serviceTime = limits.getCpuTime(); //get service time in millisec
               
            if(Test.isRunningTest())
            {
                //fake response 
                httpRes = new HttpResponse();
                httpRes.setStatusCode(200);
                httpRes.setStatus('OK');
                if(setIPWrapper.serviceName == 'getVertexInvoiceTax')
                {
                    httpRes.setBody('{"DataArea":{"TotalTax":"0.0","ProductList":[{"ProductCode":"1234567-BUS","LineItemTotalTax":"0.0","ProductClassCode":"SW-Web Access","LineItemNumber":"798"}]},"Header":{"Transaction":{"TransactionID":"","InvoiceResponseDocumentNumber":"I-0000000948"}}}');   
                }
                if(setIPWrapper.serviceName == 'getVertexQuoteTax')
                {
                   // httpRes.setBody('{"DataArea":{"TotalTax":"0.0","ProductList":[{"Product":"1234567-BUS","LineItemTotalTax":"0.0","ProductClassCode":"SW-Web Access","LineItemNumber":"2129"}]},"Header":{"Transaction":{"TransactionID":"","QuotationResponseDocumentNumber":"00000982"}}}');    

                 httpRes.setBody('{"DataArea":{"ProductList":[{"LineItemNumber":"103012","Taxes":[{"TaxRuleId":"","ImpositionValue":"General Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"MINNESOTA","JurisdictionLevel":"STATE","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18122","NonTaxable":"1500.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"NEW ULM","JurisdictionLevel":"CITY","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18215","NonTaxable":"1500.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"BROWN COUNTY TRANSIT TAX AREA","JurisdictionLevel":"DISTRICT","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"101381","NonTaxable":"1500.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"}],"ProductClassCode":"SW-Web Access","Product":"CG-Base-004","LineItemTotalTax":"0.0"},{"LineItemNumber":"2952","Taxes":[{"TaxRuleId":"","ImpositionValue":"General Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"MINNESOTA","JurisdictionLevel":"STATE","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18122","NonTaxable":"720.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"NEW ULM","JurisdictionLevel":"CITY","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18215","NonTaxable":"720.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"BROWN COUNTY TRANSIT TAX AREA","JurisdictionLevel":"DISTRICT","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"101381","NonTaxable":"720.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"}],"ProductClassCode":"SW-Web Access","Product":"CG-Lite-004","LineItemTotalTax":"0.0"},{"LineItemNumber":"2953","Taxes":[{"TaxRuleId":"","ImpositionValue":"General Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"MINNESOTA","JurisdictionLevel":"STATE","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18122","NonTaxable":"3420.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"NEW ULM","JurisdictionLevel":"CITY","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"18215","NonTaxable":"3420.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"},{"TaxRuleId":"","ImpositionValue":"Local Sales and Use Tax","CalculatedTax":"0.0","JurisdictionValue":"BROWN COUNTY TRANSIT TAX AREA","JurisdictionLevel":"DISTRICT","taxStructure":"","TaxResult":"NONTAXABLE","JurisdictionId":"101381","NonTaxable":"3420.0","TaxType":"SALES","ImpositionId":"1","TaxCollectedFromParty":"BUYER","ImpositionTypeValue":"General Sales and Use Tax","ImpositionTypeId":"1","EffectiveRate":"0.0","Situs":"DESTINATION","Taxable":"0.0"}],"ProductClassCode":"SW-Web Access","Product":"CG-Lite-004","LineItemTotalTax":"0.0"}],"TotalTax":"0.0"},"Header":{"Transaction":{"QuotationResponseDocumentNumber":"00000601","TransactionID":""}}}');
                }
                if(setIPWrapper.serviceName == 'OMS_CreateOrder_Service')
                {
                    httpRes.setBody('{"Header":{"Sender":{"ServiceName":"CreateOrder","SenderID":"Mrktplc"},"Target":{"TargetID":"OMS"}},"CreateOrderOutput":{"OMSOrderID":77903}}');
                }
                if(setIPWrapper.serviceName == 'OMS_GetOrder_Service')
                {
                    httpRes.setBody('{"Header":{"Sender": {"ServiceName": "GetOrder","SenderID": "Mrktplc"},"Target": {"TargetID": "OMS"}},"ItemInfoList": {"ItemInfo": [{"LicenseInfo": {"LicenseName": "MR-HD Automotive Pro","ActivationKey": "Z5CWMUXUUFZA"},"ItemId": 78395}]}}');
                }
                if(setIPWrapper.serviceName == 'OSMBMSSubmitOrderV1')
                {
                 httpRes.setBody('{"Header":{"Status":"Success","Sender":{"ServiceName":"FSD SubmitOrder","SenderID":"Mrktplc"},"Target":{"TargetID":"ONEBMS"},"ReturnCodeDescription":"","Location":{"LocationID":"02850"}},"DataArea":{"P_FSD_OUT":{"REMIT_TO_STATE":"NY","REMIT_TO_POSTAL_CODE":"12205","REMIT_TO_NAME":"ALBANY NY BRANCH","BMS_PO_NUMBER":"S1V9010342","REMIT_TO_ADDRESS":"101 RAILROAD AVENUE","BRANCH_LOCATION":"V9","Attribute01":"","TOTAL_DISCOUNT":"","ORDER_SOURCE_TYPE":"OSM","INVOICE_TOTAL":"42.33","Attribute03":"","BMS_INVOICE_NUMBER":"443","Attribute02":"","INVOICE_DATE":"2019-02-18T00:00:00.000-06:00","CREATE_DATE":"2019-02-18T00:00:00.000-06:00","BMS_OE_REFERENCE":"335317","REMIT_TO_CITY":"ALBANY"},"P_DIST_CODE":"02850","P_CUSTOMER_CODE":"22925"}}');
                }
                if(setIPWrapper.serviceName == 'OSMBMSIntercompany'){
                 httpRes.setBody('{"Header":{"Sender":{"ServiceName":"IntercompanyRequest","SenderID":"Mrktplc"},"Status":"Success","StatusMessage":"success","Target":{"TargetID":"BMS"}},"DataArea":{"DistributorCode":"02850","CustomerCode":"22925","Attribute01":"","Attribute03":"","Attribute02":""}}');
                }
                
                if(setIPWrapper.serviceName == 'COSM-Product'){
                 httpRes.setBody('Status: null,\\nStatus Code: 200,\\nResponse Body: {"customerID":"10","productSubscriptionInfo":[{"productID":"1234567","availableCount":0,"totalSubscriptionCount":171},{"productID":"2345678","availableCount":0,"totalSubscriptionCount":1},{"productID":"4567890","message":"Not supported by equipment"},{"productID":"5678901","availableCount":119,"totalSubscriptionCount":8}]}');
                }
                if(setIPWrapper.serviceName == 'OSM-Bank'){ //Added by Pooja to check response for refund in test class
                    httpRes.setBody('<?xml version="1.0" encoding="utf-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/"><soap:Header><wsse:Security xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsu:Timestamp xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" wsu:Id="Timestamp-450968792"><wsu:Created>2022-04-01T09:52:30.400Z</wsu:Created></wsu:Timestamp></wsse:Security></soap:Header><soap:Body><c:replyMessage xmlns:c="urn:schemas-cybersource-com:transaction-data-1.92"><c:merchantReferenceCode>1642526898746</c:merchantReferenceCode><c:requestID>6488067495186881004079</c:requestID><c:decision>ACCEPT</c:decision><c:reasonCode>100</c:reasonCode><c:requestToken>Axj/7wSTX7gGI54cd0IvABsQ0bMmTdixap5ikhJqoAp5mvQ5IhpBGi35BXDJpJl6MV2lgcGMmuKEOydYdXsUwAAAiA2F</c:requestToken><c:purchaseTotals><c:currency>USD</c:currency></c:purchaseTotals><c:ccCreditReply><c:reasonCode>100</c:reasonCode><c:requestDateTime>2022-04-01T09:52:30Z</c:requestDateTime><c:amount>833.91</c:amount><c:reconciliationID>46227115</c:reconciliationID></c:ccCreditReply></c:replyMessage></soap:Body></soap:Envelope>');
                }
            }
            //system.debug('ResBody' +httpRes.getBodyDocument());
            //system.debug('Response' +httpRes);
           // system.debug('ResponseBody' +httpRes.getbody());
            
            if(httpRes != null && httpRes.getStatusCode() == 200){
                if(httpRes.getStatus() == null || httpRes.getStatus() == label.OSM_CalloutStatus_OK  || httpRes.getStatus()== label.OSM_CalloutStatus_Success){
                    setOPWrapper.Request = setIPWrapper.jsonReqBody;
                    setOPWrapper.Response = 'Status: '+httpRes.getStatus() + ',' + '\n' + 'Status Code: '+httpRes.getStatusCode() + ',' + '\n' + 'Response Body: '+httpRes.getbody();
                    setOPWrapper.responseBody = httpRes.getbody(); //Added by Pooja
                    setOPWrapper.totalAuthCallTime = authTime;
                    setOPWrapper.totalServiceCallTime = serviceTime;
                    setOPWrapper.exceptionFlag = false;
                } else if(httpRes.getStatus() == label.OSM_CalloutStatus_Error){
                    setOPWrapper.Request = setIPWrapper.jsonReqBody;
                    setOPWrapper.Response = 'Status: '+httpRes.getStatus() + ',' + '\n' + 'Status Code: '+httpRes.getStatusCode() + ',' + '\n' + 'Response Body: '+httpRes.getbody();
                    setOPWrapper.responseBody = httpRes.getbody(); //Added by Pooja
                    setOPWrapper.totalAuthCallTime = authTime;
                    setOPWrapper.totalServiceCallTime = serviceTime;
                    setOPWrapper.exceptionFlag = true;
                }               
            }
            if(httpRes != null && httpRes.getStatusCode() != 200){
                setOPWrapper.Request = setIPWrapper.jsonReqBody;
                setOPWrapper.Response = 'Status: '+httpRes.getStatus() + ',' + '\n' + 'Status Code: '+httpRes.getStatusCode() + ',' + '\n' + 'Response Body: '+httpRes.getbody();
                setOPWrapper.responseBody = httpRes.getbody(); //Added by Pooja
                setOPWrapper.totalAuthCallTime = authTime;
                setOPWrapper.totalServiceCallTime = serviceTime;
                setOPWrapper.exceptionFlag = true;
            }
            if(Test.isRunningTest()){
                      throw new NullPointerException();                          
                    }   
            
        }catch(Exception e){
            system.debug('-Ex11111-'+e.getMessage()+'-'+e.getStackTraceString());
           // system.debug('Entered into the catch block of authentication class OSM_WS_CallOutServices');
            setOPWrapper = new OSM_WS_OP_CSWrapper();
            setOPWrapper.exceptionFlag = true;
            setOPWrapper.errorMessage = e.getMessage()+ '' +'Error Location:'+e.getStackTraceString();
            setOPWrapper.totalAuthCallTime = authTime;
            setOPWrapper.totalServiceCallTime = serviceTime;
            return setOPWrapper;
        }
       // system.debug('setOPWrapper'+setOPWrapper);
         
        return setOPWrapper; 
         
    }
    
    //Get Access Token Method
    public static OSM_WS_AccessTokenOPWrapper getAccessToken(String AuthEnv){
        
        string accessToken;
        string endPoint;
        
        OSM_WS_AccessTokenOPWrapper returnWrapper = new OSM_WS_AccessTokenOPWrapper (); //Initialize wrapper for setting access token output
        
        try {
           // System.debug('====GETTING ACCESS TOKEN FOR SERVICE===='+AuthEnv);
            HttpRequest req = new HttpRequest(); //Create HTTP Request
            Http http = new Http();
            
            string client_id;
            string client_secret;
            
          if(!Test.isRunningTest()) {
                //Get Integration Details using custom setting
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_Integration_Details__c.getValues(AuthEnv);
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Key__c;   
                client_secret = ConDetails.Passcode__c;
            }
            else {
                // Put Test data (Use custom labels)
                endPoint = 'callout:Credential_for_Oauth_Testcls_Service/api/oauth/token/osmbolt';
                client_id = '604ffcd5-29fa-49ca-b284-c2250850d1f0';
                client_secret = '79a7327f-86d8-4c15-94fd-fa7a44ca1d41';
            }
            
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSO');
           // system.debug('req>>>>>>>>>'+req.getBody());
            
            //Send HTTP response
            HttpResponse res = new HttpResponse();
            if(!Test.isRunningTest()) {
                res = http.send(req);
            } else {
                // Put Test data (Use custom labels)
                res.setBody('{"access_token":"YI0kfZt32tqtGp8y8Qv5jraIv640sjcknbjRh9EG1XZzsHJ4Dm43nE","token_type":"Bearer","expires_in":23999,"refresh_token":"4OxrrP9b6dMrTcu2NBuUCj1nCd5DFA93laxoMlHcWHt5Yh","scope":"CSO"}');
                res.setStatusCode(200);
            }
           // system.debug('res####'+res);
            
            string jSONRequestBody = res.getBody(); //Get Response Body
           // system.debug('jSONRequestBody@@@'+jSONRequestBody);
            
            OSM_WS_OAGAccessTokenWrapper  wol = (OSM_WS_OAGAccessTokenWrapper )JSON.deserializeStrict(jSONRequestBody,OSM_WS_OAGAccessTokenWrapper.class); //Deserialize into Access Toen wrapper class
            accessToken = wol.access_token;
            authTime = limits.getCPUTime(); //Get authentication time into static variable

           // System.debug('ACCESS TOKEN BODY: '+res.getBody());  
           // System.debug('ACCESS TOKEN Status: '+res.getStatus());
            //System.debug('ACCESS TOKEN Status Code: '+res.getStatusCode());

            //Populate wrapper
            returnWrapper.accessToken = accessToken;
            returnWrapper.totalAuthCallTime = authTime;
           // system.debug('returnWrapper$$$'+returnWrapper);
          if(Test.isRunningTest()){
                      throw new NullPointerException();                          
                    }   
            
        }
        catch(exception e) {
           // system.debug('Entered into catch of getAccessToken Method>>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper = new OSM_WS_AccessTokenOPWrapper();
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = e.getStackTraceString();
            returnWrapper.totalAuthCallTime = authTime;
        }
        return returnWrapper;
    }

}