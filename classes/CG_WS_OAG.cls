/**********************************************************************
Name:CG_WS_OAG
Copyright Â© 2017  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is the Web service Class for All End points
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Krishnamoorthi      11/20/2017      INITIAL DEVELOPMENT                    
***********************************************************************/
public class CG_WS_OAG {

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

            if(!Test.isRunningTest()){
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_getConnnectionDetails.getConnection(serviceName);
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
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
            //req.setBody('grant_type=client_credentials&client_id=bcccb3b1-e95b-464a-8589-b7ed6876793d&client_secret=adca726b-0c5e-4bde-ab8b-2b44a91c2d22&scope=CSSCloud');
            system.debug('req>>>>>>>.>>>'+req.getBody());
            HttpResponse res = new HttpResponse();
            startDt = System.now();
            endDt = System.now();
            if(!Test.isRunningTest()){
                res = http.send(req);
            }else{
                // res.setBody('{"access_token":"IvQYbkL2r1vDOo0VNNpmKY1kA5zasEJRff1maIqCF2Bd86kqswWXbW","token_type":"Bearer","expires_in":24000,"refresh_token":"a2fhaPuDMa2yu1mSgAPSYIkg7RLUMdmsr3RaL4qawHXBr6","scope":"CSSCloud"}');
                res.setBody('{"access_token":"1qbB3Z5A6AWVmJe2kioYRnU4sGteyNOnn84Q15hiOijEy43Yx5BWMf","token_type":"Bearer","expires_in":1200,"refresh_token":"n3iboQhnqgCTm39vjbBcAcO9EMSRvgEUvvbLwl60QhFnga","scope":"CSSCloud"}');
                res.setStatusCode(200);
            }
            string jSONRequestBody = res.getBody();
            CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            accessToken = wo1.access_token;
            System.debug('ACCESS TOKEN BODY: '+res.getBody());  
            System.debug('ACCESS TOKEN Status: '+res.getStatus());
            System.debug('ACCESS TOKEN Status Code: '+res.getStatusCode());
            returnWrapper.accessToken = accessToken;
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;
        }catch(exception e){
            system.debug('Entered into catch of OAG token Method in CSS_WS_OAG>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
            returnWrapper.appName = 'OAGToken';
            returnWrapper.endPoint = endPoint;

        }
        return returnWrapper;        
    }

    public static CG_OP_OAGWrapper calloutTSRService(CG_TSRReqJSONParser reqWrapper)
    {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;

        try{

            //CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('CG_GETDiagnosticSRT');
            //CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues('TSR');commented as part of Mule Integration
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c ();
            conDetails = CSS_getConnnectionDetails.getConnection('TSR');
            system.debug('conDetails>>>:'+conDetails);
            //CG_OP_OAGWrapper accessTokenOPWrap =  getAccessToken(conDetails.AuthEnv__c);Commented as part of Mule Integration
            CG_OP_OAGWrapper accessTokenOPWrap =  CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('TSR').AuthEnv__c,'TSR');
            system.debug('accessTokenOPWrap.exceptionFlag'+accessTokenOPWrap.exceptionFlag);
            //In case of no access token
            if(accessTokenOPWrap!=null && accessTokenOPWrap.exceptionFlag==true)
            {
                returnWrapper.exceptionFlag=true;
                returnWrapper.errorMessage = accessTokenOPWrap.errorMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;



            HttpRequest req = new HttpRequest();
            //List<string> caseNum = new List<string>{'K87481914'};
            string JSONReq =  JSON.serialize(reqWrapper);  
            system.debug('JSONReq>>>>>>>'+ reqWrapper);
            system.debug('JSONReq>>>>>>>after serialize'+JSONReq);
            req.setEndpoint(conDetails.End_Point__c);
            req.setHeader('Content-Type','application/json');
            req.setHeader('Authorization', 'Bearer '+accessToken);
            req.setHeader('client-id', conDetails.Username__c); //Added as part of Mule Integration
            req.setHeader('client-secret', conDetails.Passcode__c); //Added as part of Mule Integration
            req.setBody(JSONReq);
            system.debug('conDetails.Method_Type__c>>>>>>>>>>>>>'+conDetails.Method_Type__c + '  '+ conDetails.Timeout__c);
            req.setMethod(conDetails.Method_Type__c);

            req.setTimeout(120000); // Sai: 14/03/2017. Added for SRT Read timed out issue.
            //req.setTimeout(Integer.valueOf(conDetails.Timeout__c));
            system.debug('req>>>>>>>>'+req.getBody());
            Http http = new Http();  
            startDt = System.now();
            HttpResponse httpRes = http.send(req);
            endDt = System.now();
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalServiceCallTime = totalTime;
            returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
            returnWrapper.request = req;
            returnWrapper.response = httpRes;
            returnWrapper.accessToken = accessTokenOPWrap.accessToken;
            returnWrapper.endPoint = conDetails.End_Point__c;
            system.debug('httpRes>>>>>>>>>>>'+httpRes.getbody());
            return returnWrapper;

        }catch(Exception e)
        {
            system.debug('Entered into catch block of calloutGeneric method in CG_WS_OAG class' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        } 
    }

    ///////////////////////////////// START BMS SERVICE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    //Calling BMS Web services.
    public static CG_OP_OAGWrapper calloutBMSCustomerService(CG_IP_OAGWrapper reqWrapper) {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        String endPointURL;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        try {
            HttpResponse respose;
            Http h1 = new Http();
            HttpRequest request = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
                endPointURL = conDetails.End_Point__c+'bmscustomer';
            } else {
                endPointURL = 'https://services-dev.cummins.com/css/bmscustomer';
            }
            system.debug('conDetails >>>> ' + conDetails);
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            CG_OP_OAGWrapper accessTokenOPWrap =  getAccessToken(conDetails.AuthEnv__c);
            system.debug('accessTokenOPWrap.exceptionFlag'+accessTokenOPWrap.exceptionFlag);
            //In case of no access token
            if(accessTokenOPWrap!=null && accessTokenOPWrap.exceptionFlag==true) {
                returnWrapper.exceptionFlag=true;
                returnWrapper.errorMessage = accessTokenOPWrap.errorMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;

            //String access_token = splreceiveToken(Label.CSS_AltOAuth);
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+accessToken);                
            request.setHeader('Authorization','Bearer '+accessToken);

            request.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
            //request.setTimeout(Integer.valueOf(conDetails.Timeout__c));
            request.setHeader('Content-Type','application/json');
            request.setMethod('POST');
            //request.setMethod(conDetails.Method_Type__c);
            request.setEndpoint(endPointURL);
            request.setBody(reqWrapper.jsonReqBody);              
            System.debug('req1.getBody======'+request.getBody());
            //Sending request and mapping the response 
            startDt = System.now();
            respose = h1.send(request);
            endDt = System.now();
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalServiceCallTime = totalTime;
            returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
            returnWrapper.request = request;
            returnWrapper.response = respose;
            system.debug('httpRes>>>>>>>>>>>'+respose.getbody());
            return returnWrapper;        
        } catch(Exception e) {
            system.debug('Entered into catch block of CLASS - CG_WS_OAG-calloutBMSCustomerService  Method' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        } 
    }

    //Create BMS Account.
    public static CG_OP_OAGWrapper createBMSAccount(CG_IP_OAGWrapper reqWrapper) {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        string jsonResponse;
        Datetime startDt;
        Datetime endDt;
        String endPointURL;
        HttpResponse respose;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        try {           
            Http h1 = new Http();
            HttpRequest request = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
                endPointURL = conDetails.End_Point__c+'bmscustomer';
            } else {
                endPointURL = 'https://services-dev.cummins.com/css/bmscustomer';
            }
            system.debug('conDetails >>>> ' + conDetails);
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            CG_OP_OAGWrapper accessTokenOPWrap =  getAccessToken(conDetails.AuthEnv__c);
            system.debug('accessTokenOPWrap.exceptionFlag'+accessTokenOPWrap.exceptionFlag);
            //In case of no access token
            if(accessTokenOPWrap!=null && accessTokenOPWrap.exceptionFlag==true) {
                returnWrapper.exceptionFlag=true;
                returnWrapper.errorMessage = accessTokenOPWrap.errorMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;

            //String access_token = splreceiveToken(Label.CSS_AltOAuth);
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+accessToken);                
            request.setHeader('Authorization','Bearer '+accessToken);

            request.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
            //request.setTimeout(Integer.valueOf(conDetails.Timeout__c));
            request.setHeader('Content-Type','application/json');
            request.setMethod('PUT');
            //request.setMethod(conDetails.Method_Type__c);
            request.setEndpoint(endPointURL);
            request.setBody(reqWrapper.jsonReqBody);              
            System.debug('req1.getBody======'+request.getBody());
            //Sending request and mapping the response 
            startDt = System.now();
            respose = h1.send(request);
            System.debug('%%%%-----OAutAuthURL :: '+endPointURL );
            System.debug('%%%%%%%%%%%res1 getStatusCode is :: '+respose.getStatusCode());
            system.debug('######################################RESPONSE_BODY:'+respose.getbody());
            endDt = System.now();
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalServiceCallTime = totalTime;
            returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
            returnWrapper.request = request;
            returnWrapper.response = respose;
            system.debug('httpRes>>>>>>>>>>>'+respose);

            if(respose.getStatusCode()!=200 && respose.getStatusCode()!=201) {
                returnWrapper.exceptionFlag=true;
                returnWrapper.errorMessage = 'System is Down' + respose.getStatusCode();
                return returnWrapper;
            }
            return returnWrapper;        
        } catch(Exception e) {
            string message;
            jsonResponse = '{"Header\": { "ReturnCodeDescription\": \"'+ system.label.CSS_BMSAccount_Errormsg+ '\", \"Status\": \"SYSTEM\",\"Sender\":    { \"ServiceName\": \"CreateCustomer\",      \"MessageID\": \"856733ee-b73d-4125-9ad9-e0d52b68be71\",  \"SenderID\": \"CSS\"   }, \"Target\": {\"TargetID\": \"BMS\"},  \"Location\": {\"LocationID\": \"56270-56251\"}}}';
            System.debug('getLineNumber*********************is :: '+e.getLineNumber());
            System.debug('getLineNumber*********************is :: '+e.getMessage());
            if(!Test.isRunningTest()) {
                message = e.getMessage();
                if(message.contains('timed out')) {
                    css_utility.LogOutIntError(endPointURL,e.getMessage()+'-BMSCust InboundService', 'RESPONSE IS NULL', 'BMS');
                } else {
                    css_utility.LogOutIntError(endPointURL,e.getMessage()+'-BMSCust InboundService', respose==null?'RESPONSE IS NULL':respose.getBody(), 'BMS');
                }
            }

            system.debug('Entered into catch block of CLASS - CG_WS_OAG-createBMSAccount Method' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        } 
    }

    //Get Misc Charge LOV's Details.
    public static CG_OP_OAGWrapper getMISCChargeLOVs(CG_IP_OAGWrapper reqWrapper) {
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        String endPointURL;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        try {
            HttpResponse respose;
            Http h1 = new Http();
            HttpRequest request = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
                endPointURL = conDetails.End_Point__c;
            } else {
                endPointURL = 'https://services-dev.cummins.com/css/bmscustomer';
            }
            system.debug('conDetails >>>> ' + conDetails);
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            CG_OP_OAGWrapper accessTokenOPWrap =  getAccessToken(conDetails.AuthEnv__c);
            system.debug('accessTokenOPWrap.exceptionFlag'+accessTokenOPWrap.exceptionFlag);
            //In case of no access token
            if(accessTokenOPWrap!=null && accessTokenOPWrap.exceptionFlag==true) {
                returnWrapper.exceptionFlag=true;
                returnWrapper.errorMessage = accessTokenOPWrap.errorMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;

            //String access_token = splreceiveToken(Label.CSS_AltOAuth);
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+accessToken);                
            request.setHeader('Authorization','Bearer '+accessToken);

            request.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
            //request.setTimeout(Integer.valueOf(conDetails.Timeout__c));
            request.setHeader('Content-Type','application/json');
            request.setMethod('POST');
            //request.setMethod(conDetails.Method_Type__c);
            request.setEndpoint(endPointURL);
            request.setBody(reqWrapper.jsonReqBody); 
            System.debug('endPointURL======'+endPointURL);
            System.debug('req1.getBody======'+request.getBody());
            //Sending request and mapping the response 
            startDt = System.now();
            /*
            if(!Test.isRunningTest()){

            } else {
                String json = '{\"DataArea\": [{'+'\"MiscName\": \"Misc Name\",'+'\"MiscDescription\": \"\",\"Multiplier\": 5723046,'+ '\"FlatAmount\": 3454,\"Maximum\": 24534,\"AutoCharage\": \"Y\",\"CreditType\": \"BOX 129\"}],'+
'\"Header\": {\"Status\": \"SUCCESS\",\"Sender\": {\"ServiceName\": \"getMISCChargeLOVs\",\"SenderID\": \"BMS\"},'+'\"Target\": {\"TargetID\": \"CSS\"},'+ '\"Location\": {\"LocationID\": \"56270-56255\"}}}';
                respose.setBody(json);
            }*/
            respose = h1.send(request);
            endDt = System.now();
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalServiceCallTime = totalTime;
            returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
            returnWrapper.request = request;
            returnWrapper.response = respose;
            system.debug('response>>>>>>>>>>>'+respose);
            system.debug('respose.getbody()>>>>>>>>>>>'+respose.getbody());
            return returnWrapper;        
        } catch(Exception e) {
            system.debug('Entered into catch block of CLASS - CG_WS_OAG-getMISCChargeLOVs  Method' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        } 
    }


    ///////////////////////////////// END BMS SERVICE \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

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
            // if (conDetails == null) {conDetails = 'OAGOAuth';}
            CG_OP_OAGWrapper accessTokenOPWrap = getAccessToken(conDetails.AuthEnv__c);
            system.debug('**accessTokenOPWrap**'+accessTokenOPWrap);
            //In case of no access token return wrapper
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = accessTokenOPWrap.exceptionMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;
            system.debug('accessTokenOPWrap>>>:'+accessTokenOPWrap);
            HttpRequest req = new HttpRequest();
            //List<string> caseNum = new List<string>{'K87481914'};
            req.setEndpoint(conDetails.End_Point__c);
            System.debug('=======> ConDetails>>:'+conDetails.End_Point__c);
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + accessToken);
            req.setBody(reqWrapper.jsonReqBody);
            system.debug('Method_Type__c>>>:'+conDetails.Method_Type__c);
            System.debug('===reqWrapper.jsonReqBody====' + reqWrapper.jsonReqBody);
            req.setMethod(conDetails.Method_Type__c);
            Integer timeOut = conDetails.Timeout__c.intValue();
            req.setTimeout(timeOut);
            //req.setTimeout(120000); // Sai: 14/03/2017. Added for SRT Read timed out issue.

            Http http = new Http();
            startDt = System.now();
            HttpResponse httpRes = new HttpResponse();
            if(!Test.isRunningTest()) {
                httpres = http.send(req);
                //if(reqWrapper.serviceName == 'CSS_SBL_CSSDetails')
                //httpRes.setBody('{"DataArea":{"DetailSRTs":[{"SRTHours":0.4,"SRTQty":1,"PercentageAdjustment":100,"AdjustmentReason":"","AccessCode":"R","SRTCode":"00-901-00"},{"SRTHours":0.2,"SRTQty":1,"PercentageAdjustment":100,"AdjustmentReason":"","AccessCode":"B","SRTCode":"TS-051-01"}],"DetailOtherClaimables":[{"Item":"","Description":"1","ApprovedAmount":2452,"AdjustmentReason":""}],"DetailParts":[{"AdjustmentPartsPercent":100,"PartQty":1,"PartNumber":"408998500RX","AdjustmentReason":""}],"DetailTravel":[{"TravelType":"","AdjustmentReason":"","Distance":2452,"Hours":2.3,"LodgingAmount":345,"MealsAmount":46,"TowingDetails":234}]},"Header":{"ReturnCodeDescription":"","Status":"Success"}}');
            }
            else{
                httpres.setStatusCode(200);
                //system.debug('StatusCode***'+httpres.getStatusCode());
                system.debug(reqWrapper.serviceName);
                if(reqWrapper.serviceName == 'CSS_SBL_FailCodes')
                    httpRes.setBody('{"Header":{"MessageIdentifier":"Identifier from MW","ReturnCode":"<MessageCode from Siebel>","ReturnCodeDescription":"<Message from Siebel>","Status":"Success"},"DataArea":[{"SystemCode":"WS","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"},{"SystemCode":"WS1","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"},{"SystemCode":"WS2","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"}]}');

                if(reqWrapper.serviceName == 'CSS_SBL_GetClaimDetails')
                    httpRes.setBody('{ "Header": { "ReturnCodeDescription": "<Message from Siebel>", "Status": "Success", "ReturnCode": "<MessageCode from Siebel>", "MessageIdentifier": "<Identifier from MW>" }, "DataArea": [ { "Notes": [ { "Note": "TestComplaint", "NoteType": "Complaint", "CreatedDate": "2012-06-06 00:00:00" }, { "Note": "TestComplaint1", "NoteType": "Complaint", "CreatedDate": "2012-06-07 00:00:00" }, { "Note": "TestCause", "NoteType": "Cause", "CreatedDate": "2012-06-10 00:00:00" }, { "Note": "TestCause1", "NoteType": "Cause", "CreatedDate": "2012-06-09 00:00:00" } ], "ServiceProviderCode": "34234", "DistributorCode": "42333", "DistributorName": "Cummins Distributor Name", "PSN": "2342335", "WorkOrderNumber": "ABC45233", "WarrantyStartDate": "2012-06-06", "EngineApplicationCode": "130", "Manufacturer": "KENWORTH", "ModelSeries": "T300", "Contact": "FirstName LastName", "BISFlag": "N", "FailureDate": "2012-06-06", "FailurePoint": 2323, "FailureMeasure": "Miles", "DISDNumber": "23423", "CustomerName": "ABZ Tavels", "EngineVIN": "234msdflo303jfp3ed", "TSRNumber": "234434", "UnitNumber": "D234", "DealerClaimNumber": "C453453245", "ClaimSource": "MX", "ClaimFiledDate": "2017-06-06", "ECMCalibAfter": "23423", "ECMCalibBefore": "234234", "ECMRevBfr": "34234", "ECMRevAfter": "23423", "FailureList": [ { "SystemCode": "BS", "ComponentCode": "HS", "FailMode": "BR", "Failurename": "Turbo Charger", "CampaignNumber": "C24523", "FaultCode": "125", "AccountCode": "67", "PayCode": "I", "PartsList": [ { "PartNumber": "345345", "PartDescription": "PartName1", "ClaimedQty": "2", "AdjustedQty": "1", "TrackingNumber": "23456232346", "RID": "34234", "AdjustmentReason": "Quantity used as not covered" }, { "PartNumber": "77886", "PartDescription": "PartName2", "ClaimedQty": "1", "AdjustedQty": "1", "TrackingNumber": "3245345345", "RID": "34534", "AdjustmentReason": "Reason Description" } ], "OtherClaimablesList": [ { "Item": "", "ItemDescription": "", "ClaimedAmount": 1, "AdjustedAmount": 2, "AdjustmentReason": "" }, { "Item": "", "ItemDescription": "", "ClaimedAmount": 1, "AdjustedAmount": 2, "AdjustmentReason": "" } ], "SRTList": [ { "SRTCode": "", "SRTDescription": "", "SRTHours": 1, "ClaimedQty": 1, "ClaimedPercent": 1, "ClaimedHours": 1, "AdjustedQty": 1, "AdjustedPercent": 1, "AdjustedHours": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "" }, { "SRTCode": "", "SRTDescription": "", "SRTHours": 1, "ClaimedQty": 1, "ClaimedPercent": 1, "ClaimedHours": 1, "AdjustedQty": 1, "AdjustedPercent": 1, "AdjustedHours": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "" } ], "TravelList": [ { "TravelType": "Commercial", "ClaimedDistance": 1, "ClaimedHours": 1, "ClaimedAmount": 1, "AdjustedDistance": 2, "AdjustedHours": 1, "AdjustedAmount": 1, "LodgingAmount": 1, "MealsAmount": 1, "TowingAmount": 1, "LaborAmount": 1, "TravelAmount": 1, "TotalTravel": 1, "BaseFare": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "", "AdjustedPercent": 1 }, { "TravelType": "Meals", "ClaimedDistance": 1, "ClaimedHours": 1, "ClaimedAmount": 1, "AdjustedDistance": 2, "AdjustedHours": 1, "AdjustedAmount": 1, "LodgingAmount": 1, "MealsAmount": 1, "TowingAmount": 1, "LaborAmount": 1, "TravelAmount": 1, "TotalTravel": 1, "BaseFare": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "", "AdjustedPercent": 1 } ] }, { "SystemCode": "CR", "ComponentCode": "JH", "FailMode": "UH", "Failurename": "Aftermarket assembly", "CampaignNumber": "C86666", "FaultCode": "563", "AccountCode": "51", "PayCode": "D", "PartsList": [ { "PartNumber": "", "PartDescription": "", "ClaimedQty": "", "AdjustedQty": "", "TrackingNumber": "", "RID": "", "AdjustmentReason": "" }, { "PartNumber": "", "PartDescription": "", "ClaimedQty": "", "AdjustedQty": "", "TrackingNumber": "", "RID": "", "AdjustmentReason": "" } ], "OtherClaimablesList": [ { "Item": "", "ItemDescription": "", "ClaimedAmount": 1, "AdjustedAmount": 2, "AdjustmentReason": "" }, { "Item": "", "ItemDescription": "", "ClaimedAmount": 1, "AdjustedAmount": 2, "AdjustmentReason": "" } ], "SRTList": [ { "SRTCode": "", "SRTDescription": "", "SRTHours": 1, "ClaimedQty": 1, "ClaimedPercent": 1, "ClaimedHours": 1, "AdjustedQty": 1, "AdjustedPercent": 1, "AdjustedHours": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "" }, { "SRTCode": "", "SRTDescription": "", "SRTHours": 1, "ClaimedQty": 1, "ClaimedPercent": 1, "ClaimedHours": 1, "AdjustedQty": 1, "AdjustedPercent": 1, "AdjustedHours": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "" } ], "TravelList": [ { "TravelType": "Meals", "ClaimedDistance": 1, "ClaimedHours": 1, "ClaimedAmount": 1, "AdjustedDistance": 2, "AdjustedHours": 1, "AdjustedAmount": 1, "LodgingAmount": 1, "MealsAmount": 1, "TowingAmount": 1, "LaborAmount": 1, "TravelAmount": 1, "TotalTravel": 1, "BaseFare": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "", "AdjustedPercent": 1 }, { "TravelType": "Commercial", "ClaimedDistance": 1, "ClaimedHours": 1, "ClaimedAmount": 1, "AdjustedDistance": 2, "AdjustedHours": 1, "AdjustedAmount": 1, "LodgingAmount": 1, "MealsAmount": 1, "TowingAmount": 1, "LaborAmount": 1, "TravelAmount": 1, "TotalTravel": 1, "BaseFare": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "", "AdjustedPercent": 1 } ] } ], "AdditionalESNs": [ { "PSN": "", "WarrantyStartDate": "2012-06-06", "BISFlag": "", "FailurePoint": 12, "FailureMeasure": "", "VIN": "", "ECMCalibAfter": "", "ECMCalibBefore": "", "ECMRevBfr": "", "ECMRevAfter": "" }, { "PSN": "", "WarrantyStartDate": "2012-06-06", "BISFlag": "", "FailurePoint": 12, "FailureMeasure": "", "VIN": "", "ECMCalibAfter": "", "ECMCalibBefore": "", "ECMRevBfr": "", "ECMRevAfter": "" } ], "ComplaintCodes": [ { "ComplaintCode": "", "ComplaintText": "" }, { "ComplaintCode": "", "ComplaintText": "" } ] } ] }');


                if(reqwrapper.serviceName == 'SiebelClaimHistory'){
                    String json = '{\"DataArea\":{\"Details\":[{\"FailureDate\":\"2012-01-24T00:00:00.000-06:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"WAT-S150\",\"ClaimNumber\":\"04530-2047112-0\",\"FailCode\":\"WEQP\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"449\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2011-03-25T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2012-01-24T00:00:00.000-06:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"WAT-S150\",\"ClaimNumber\":\"04530-2047112-0\",\"FailCode\":\"WEQP\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"449\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2011-03-25T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0001714-0\",\"FailCode\":\"WEQP\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0001714-0\",\"FailCode\":\"WEQP\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0001814-0\",\"FailCode\":\"HYBD\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0001814-0\",\"FailCode\":\"IRCL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0001814-0\",\"FailCode\":\"HYBD\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0001814-0\",\"FailCode\":\"IRCL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0015414-0\",\"FailCode\":\"HYBD\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0015414-0\",\"FailCode\":\"IRCL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0015414-0\",\"FailCode\":\"HYBD\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0015414-0\",\"FailCode\":\"IRCL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0005614-0\",\"FailCode\":\"HYBD\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2011-03-16T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0005614-0\",\"FailCode\":\"IRCL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2011-03-16T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0005614-0\",\"FailCode\":\"HYBD\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2011-03-16T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2013-12-20T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"84301\",\"ClaimNumber\":\"04970-0005614-0\",\"FailCode\":\"IRCL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"48003\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2011-03-16T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2015-02-16T00:00:00.000-06:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"FTW0468\",\"ClaimNumber\":\"04530-2137015-0\",\"FailCode\":\"IRVB\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"291426\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2015-02-16T00:00:00.000-06:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"FTW0468\",\"ClaimNumber\":\"04530-2137015-0\",\"FailCode\":\"IRVB\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"291426\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2015-04-02T00:00:00.000-05:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"ORL3982\",\"ClaimNumber\":\"04530-2141115-0\",\"FailCode\":\"LCEL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"311425\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2015-04-02T00:00:00.000-05:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"ORL3982\",\"ClaimNumber\":\"04530-2141115-0\",\"FailCode\":\"LCEL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"311425\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2015-10-26T00:00:00.000-05:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"157949\",\"ClaimNumber\":\"02932-0233915-0\",\"FailCode\":\"BPCR\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"399618\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"SHIM (LOWER)\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2015-10-26T00:00:00.000-05:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"157949\",\"ClaimNumber\":\"02932-0233915-0\",\"FailCode\":\"BPCR\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"399618\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"SHIM (LOWER)\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2015-11-10T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"158309\",\"ClaimNumber\":\"02932-0241815-0\",\"FailCode\":\"XXIP\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"405878\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2015-11-10T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"158309\",\"ClaimNumber\":\"02932-0241815-0\",\"FailCode\":\"XXIP\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"405878\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Denied\"},{\"FailureDate\":\"2015-11-10T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"158309\",\"ClaimNumber\":\"02932-0012616-0\",\"FailCode\":\"XXIP\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"405878\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2015-11-10T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"158309\",\"ClaimNumber\":\"02932-0012616-0\",\"FailCode\":\"XXIP\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"405878\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2016-01-22T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"159684\",\"ClaimNumber\":\"02932-0034716-0\",\"FailCode\":\"BKCL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"446800\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2016-01-22T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"159684\",\"ClaimNumber\":\"02932-0034716-0\",\"FailCode\":\"BPCR\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"446800\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"SHIM (LOWER)\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2016-01-22T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"159684\",\"ClaimNumber\":\"02932-0034716-0\",\"FailCode\":\"CHSE\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"446800\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2016-01-22T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"159684\",\"ClaimNumber\":\"02932-0034716-0\",\"FailCode\":\"BKCL\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"446800\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2016-01-22T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"159684\",\"ClaimNumber\":\"02932-0034716-0\",\"FailCode\":\"BPCR\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"446800\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"SHIM (LOWER)\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2016-01-22T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"159684\",\"ClaimNumber\":\"02932-0034716-0\",\"FailCode\":\"CHSE\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"446800\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2016-01-22T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"159684\",\"ClaimNumber\":\"02932-0034816-0\",\"FailCode\":\"WLCV\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"446800\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2016-01-22T00:00:00.000-06:00\",\"SPName\":\"\",\"SPCode\":\"\",\"WorkOrderNumber\":\"159684\",\"ClaimNumber\":\"02932-0034816-0\",\"FailCode\":\"WLCV\",\"SMN\":\"ISX15 CM2250\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"446800\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"2013-10-14T00:00:00.000-05:00\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-10-02T00:00:00.000-05:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"CM45A21A\",\"ClaimNumber\":\"04530-2091713-0\",\"FailCode\":\"WEQP\",\"SMN\":\"\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"0\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-10-02T00:00:00.000-05:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"CM45A21A\",\"ClaimNumber\":\"04530-2091713-0\",\"FailCode\":\"WEQP\",\"SMN\":\"\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"0\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-10-02T00:00:00.000-05:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"CM45A21A\",\"ClaimNumber\":\"04530-2091713-0\",\"FailCode\":\"WEQP\",\"SMN\":\"\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"0\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"},{\"FailureDate\":\"2013-10-02T00:00:00.000-05:00\",\"SPName\":\"SOUTHEASTERN FREIGHT LINES\",\"SPCode\":\"30468\",\"WorkOrderNumber\":\"CM45A21A\",\"ClaimNumber\":\"04530-2091713-0\",\"FailCode\":\"WEQP\",\"SMN\":\"\",\"CreditStatementNumber\":\"\",\"FailurePoint\":\"0\",\"UnitOfMeasure\":\"Miles\",\"WarrantyStartDate\":\"\",\"FailureName\":\"\",\"ClaimStatus\":\"Paid\"}]},\"Header\":{\"ReturnCodeDescription\":\"\",\"Status\":\"Success\"}}';

                    httpRes.setBody(json);    
                }
                if(reqwrapper.serviceName == 'GetCampaign'){
                    httpres.setBody('{"DataArea":{"Details":[{"BusinessUnit":"CMI", "CampaignDesc":"ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST", "CampaignEndDate":"2020-12-31", "CampaignNumber":1609, "CampaignStartDate":"2015-02-27", "CampaignType":"TRP", "CompleteIndicator":"N", "FailCode":"WEQP", "FailMode":"EZ", "InShopSrtLimitFlag":"N", "MultipleTimes":"N", "PartList":[{"PartDescription":"6.2 CALIBRATION FLT REG.", "PartNumber":"388639600", "PartQuantity":"1"}],"SrtList":[{"SrtCode":"00-901-00", "SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"}],  "Status":"Approved"}]},"Header":{"ReturnCodeDescription":"Success","Status":"SUCCESS"}}');
                }
                if(reqwrapper.serviceName == 'DeleteBMSJob'){
                    httpres.setBody('{"DataArea":{"Details":[{"BusinessUnit":"CMI", "CampaignDesc":"ISX15 CM2350 - TRP FOR CALIBRATION FLEET COUNT COSTS WHEN CHANGING ECM BASE CODE POST", "CampaignEndDate":"2020-12-31", "CampaignNumber":1609, "CampaignStartDate":"2015-02-27", "CampaignType":"TRP", "CompleteIndicator":"N", "FailCode":"WEQP", "FailMode":"EZ", "InShopSrtLimitFlag":"N", "MultipleTimes":"N", "PartList":[{"PartDescription":"6.2 CALIBRATION FLT REG.", "PartNumber":"388639600", "PartQuantity":"1"}],"SrtList":[{"SrtCode":"00-901-00", "SrtDescription":"Administrative Time - Open and Close Repair Order (Shop Repairs)"}],  "Status":"Approved"}]},"Header":{"ReturnCodeDescription":"Error","Status":"Error"}}');
                }

                if(reqwrapper.serviceName == 'BMSPrivateSRTs'){
                    httpres.setBody('{"DataArea":[{"Special":"N","SRTProcedure":"850","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"00","Flexible":"Y","AccessCode":"B","Title":"PM FULL SERVICE","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"},{"Special":"N","SRTProcedure":"850","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"00","Flexible":"Y","AccessCode":"C","Title":"PM FULL SERVICE","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"},{"Special":"N","SRTProcedure":"TRN","Hours":"0","EngineFamily":"10","SRTStep":"","SRTGroup":"99","Flexible":"Y","AccessCode":"B","Title":"TECHNICIAN TRAINING","RegionCode":"CENTRAL","Troubleshoot":"N","Private":"Y"}],"Header":{"Status":"SUCCESS","Sender":{"ServiceName":"GetBMSPrivateSRTs","MessageID":"72497242-d5fe-4d73-904a-cee23845a929","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"03520-04892"}}}');
                }
                if(reqwrapper.serviceName == 'CG_FieldActionSRT'){  
                    httpres.setBody('{ "Header":{ "MessageIdentifier": "Identifier from FieldAcionSRTResponse", "ReturnCode":"MessageCode from FieldAcionSRTResponse", "ReturnCodeDescription":"Message from FieldAcionSRTResponse", "Status":"Success"}, "DataArea": { "FieldAction": [ { "FieldActionNumber":"12345", "FieldActionType":"xyz", "FieldActionSRTTime": [ { "SRTDetails":"SRTDetails", "SRTTitle":"SRTTitle", "StepID":"123", "StepDescription":"StepDescription", "RTIME":"3.43", "ATIME":"3.43", "BTIME":"3.43", "CTIME":"3.43", "DTIME":"3.43", "S1TIME":"3.43", "S1DESCRIPTION":"S1DESCRIPTION", "S2TIME":"3.43", "S2DESCRIPTION":"S2DESCRIPTION", "S3TIME":"3.43", "S3DESCRIPTION":"test", "S4TIME":"3.43", "S4DESCRIPTION":"S4DESCRIPTION", "S5TIME":"3.43", "S5DESCRIPTION":"S5DESCRIPTION", "S6TIME":"3.43", "S6DESCRIPTION":"S6DESCRIPTION", "S7TIME":"3.43", "S7DESCRIPTION":"S7DESCRIPTION", "S8TIME":"3.43", "S8DESCRIPTION":"S8DESCRIPTION", "S9TIME":"3.43", "S9DESCRIPTION":"S9DESCRIPTION", "SRTQuantity":"1234", "SRTMessage":"SRTMessage", "Assignment":"Assignment", "SRTAccessCode":"SRTAccessCode", "SRTTime":"3.43", "QuoteID":"12334" } ] } ]} }');
                }
                if(reqwrapper.serviceName == 'CG_ODMHeaderValidation'){  
                    httpres.setBody('{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh558", "ServiceName": "ServiceName" } }, "Response": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "messages": [ { "description": "oh559", "code": "oh559", "type": "oh559" } ], "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": { "code": "oh559" }, "Parts": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "a1129000002lEV2AAM", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559" } ], "Failure": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "acctCodeInfo": { "accountCodeType": "ERROR", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "a0r2900000156ogAAA", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "Otherables": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "a0r2900000156ogAAA", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "a0r2900000156ogAAA", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ { "lineNumber": "a0r2900000156ogAAA", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "Number": "oh559", "Status": "oh559", "Source": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "CreatedDate": "oh559", "SubmittedDate": "oh559", "ReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "ownerName": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "SubSource": "oh559" }, "DecisionID": "DecisionID" } }');
                }
                if(reqwrapper.serviceName == 'CG_FailureValidation'){  
                    httpres.setBody('{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh558", "ServiceName": "ServiceName" } }, "Response": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "messages": [ { "description": "oh559", "code": "oh559", "type": "oh559" } ], "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": { "code": "oh559" }, "Parts": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "a1129000002lEV4AAM", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559" } ], "Failure": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "ERROR" }], "acctCodeInfo": { "accountCodeType": "oh559", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "a0r2900000156ogAAA", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "Otherables": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "a0r2900000156ogAAA", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "a0r2900000156ogAAA", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ { "lineNumber": "a0r2900000156ogAAA", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "Number": "oh559", "Status": "oh559", "Source": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "CreatedDate": "oh559", "SubmittedDate": "oh559", "ReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "ownerName": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "SubSource": "oh559" }, "DecisionID": "DecisionID" } }');
                }
                if(reqwrapper.serviceName == 'CG_ODMPartsService'){  
                    httpres.setBody('{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh558", "ServiceName": "ServiceName" } }, "Response": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "messages": [ { "description": "oh559", "code": "oh559", "type": "oh559" } ], "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": { "code": "oh559" }, "Parts": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "a1129000002lFPKAA2", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559" } ], "Failure": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "ERROR" }], "acctCodeInfo": { "accountCodeType": "oh559", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "a0r2900000156ogAAA", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "Otherables": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "a0r2900000156ogAAA", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "a0r2900000156ogAAA", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ { "lineNumber": "a0r2900000156ogAAA", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "Number": "oh559", "Status": "oh559", "Source": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "CreatedDate": "oh559", "SubmittedDate": "oh559", "ReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "ownerName": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "SubSource": "oh559" }, "DecisionID": "DecisionID" } }');
                }
                if(reqwrapper.serviceName == 'CG_OtherClaimablesValidation'){  
                    httpres.setBody('{ "Header": { "Target": { "TargetID": "TargetID" }, "Sender": { "SenderID": "oh558", "ServiceName": "ServiceName" } }, "Response": { "claim": { "Engine": { "billToCode": "oh559", "warrantyIndicatorFlag": "oh559", "marineFlag": "oh559", "buildDate": "oh559", "productApplicationDesp": "oh559", "oemCode": "oh559", "designPhaseCode": "oh559", "engineFamilyCode": "oh559", "serviceModel": "oh559", "etoConversionDate": "oh559" }, "messages": [ { "description": "oh559", "code": "oh559", "type": "oh559" } ], "ServiceProvider": { "channelOfDistribution": "oh559", "region": "oh559", "claimAllowedDays": "oh559", "territory": "oh559", "outfileAllClaimsFlag": "oh559", "regionCode": "oh559", "inactiveDate": "oh559", "status": "oh559", "groupName": "oh559", "channelDescription": "oh559", "paccarChecked": "oh559", "ltaChecked": "oh559", "engineEffectiveDate": "oh559", "engineExpirationdate": "oh559", "serviceModelName": "oh559", "oemCode": "oh559", "spState": "oh559", "spCountry": "oh559", "spServiceLevel": "oh559", "spWarrantyTrainingStatus": "oh559", "spCertificationEndDate": "oh559", "spSCMDollarAmt": "oh559", "spSCMDeductiblePct": "oh559" }, "AdditionalESN": [ { "ESN": "oh559" } ], "ComplaintCode": { "code": "oh559" }, "Parts": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "a1129000002lFPKAA2", "partId": "oh559", "partPrice": "oh559", "partName": "oh559", "reconPartFlag": "oh559", "priceBook": "oh559", "exceptionPriceBook": "oh559", "channelCode": "oh559", "standardPriceBook": "oh559", "pricingRegion": "oh559", "partAllowedFlag": "oh559", "partReturnFlag": "oh559", "qtyApproved": "oh559", "adjPartPercentage": "oh559" } ], "Failure": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "ERROR" }], "acctCodeInfo": { "accountCodeType": "oh559", "chryslerFlag": "oh559", "multiESNFlag": "oh559", "accountCodeWarrantyFlag": "oh559" }, "campaign": { "accountCode": "oh559", "campaignId": "oh559", "campaignType": "oh559", "completeIndicator": "oh559", "effectiveDate": "oh559", "engineComponentCode": "oh559", "expiryDateIntl": "oh559", "expiryDateNA": "oh559", "failMode": "oh559", "multiFlag": "oh559", "status": "oh559", "systemCode": "oh559", "cmpEngineStatusCode": "oh559" }, "lineNumber": "a0r2900000156ogAAA", "failCode": "oh559", "failMode": "oh559", "accountCode": "oh559", "payCode": "oh559", "status": "oh559", "authorizationNumber": "oh559", "approvalCode": "oh559", "campaignId": "oh559", "coverageType": "oh559", "totalLaborAmt": "oh559", "totalSRTHours": "oh559", "totalTowingAmt": "oh559", "accountCodeDesp": "oh559", "policyFlag": "oh559", "programID": "oh559", "overrideFlag": "oh559", "inShopCampaignFlag": "oh559", "travelCoveredFlag": "oh559", "GSQID": "oh559" } ], "Otherables": [ { "messages": { "description": "oh559", "code": "oh559", "type": "oh559" }, "lineNumber": "a0r2900000156ogAAA", "Item": "oh559", "details": "oh559", "amount": "oh559" } ], "Travels": [ { "messages": [{ "description": "oh559", "code": "oh559", "type": "oh559" }], "lineNumber": "a0r2900000156ogAAA", "hours": "oh559", "mealsCharges": "oh559", "towingCharges": "oh559", "travelDistance": "oh559" } ], "SrtList": [ { "lineNumber": "a0r2900000156ogAAA", "code": "oh559", "hours": "oh559", "offsiteCheck": "oh559", "description": "oh559", "quantity": "oh559", "srtAllowedFlag": "oh559" } ], "Number": "oh559", "Status": "oh559", "Source": "oh559", "cmiServiceProviderCode": "oh559", "serviceModelName": "oh559", "cmiEngineSerialNumber": "oh559", "productApplicationCode": "oh559", "warrantyStartDate": "oh559", "failureDate": "oh559", "CreatedDate": "oh559", "SubmittedDate": "oh559", "ReceivedDate": "oh559", "engineFamily": "oh559", "failurePoint": "oh559", "bisFlag": "oh559", "multiESNFlag": "oh559", "failureMeasure": "oh559", "reconPartsWarrantyFlag": "oh559", "manualAdjudicationFlag": "oh559", "roNumber": "oh559", "engineApplicationCode": "oh559", "serviceProviderName": "oh559", "distributorCode": "oh559", "totalAmt": "oh559", "groupName": "oh559", "thresholdAmount": "oh559", "thresholdHrs": "oh559", "approverName": "oh559", "level": "oh559", "button": "oh559", "newPartsWarrantyFlag": "oh559", "possessionFlag": "oh559", "ecmCalibBefore": "oh559", "ecmCalibAfter": "oh559", "manufacturer": "oh559", "paccarFlag": "oh559", "paccarCertifiedLocationFlag": "oh559", "paccarPaymentRoutingFlag": "oh559", "countryCode": "oh559", "ownerName": "oh559", "penalty": "oh559", "certificationFlag": "oh559", "roadRelayWarrantyFlag": "oh559", "headerCampaignId": "oh559", "modelSeries": "oh559", "applicationName": "oh559", "SubSource": "oh559" }, "DecisionID": "DecisionID" } }');
                }
                if(reqwrapper.serviceName == 'CSS_SBL_GetPartsData'){  
                    httpres.setBody('{"DataArea": {" SupersededPartNumber": "1-127827968"," PartNumberLong": "1-127827968"," PartDescription": "1-127827968"," PartInService": "1-127827968"," KitPartFlag": "1-127827968"},"Header": {"ReturnCodeDescription": "","Status": "Success"}}');
                }
            }

            //system.debug(reqWrapper.serviceName);
            //if(reqWrapper.serviceName == 'CSS_SBL_FailCodes')
            //httpRes.setBody('{"Header":{"MessageIdentifier":"Identifier from MW","ReturnCode":"<MessageCode from Siebel>","ReturnCodeDescription":"<Message from Siebel>","Status":"Success"},"DataArea":[{"SystemCode":"WS","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"},{"SystemCode":"WS1","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"},{"SystemCode":"WS2","SystemName":"Broken Filter shell1","ComponentCode":"EF","ComponentName":"Electrical","FailureName":"","ServiceGroupCode":"345","Created":"2010-03-19T16:18:59.000-05:00","Active":"Y","UpdatedDate":"2010-03-19T16:18:59.000-05:00","BusinesUnit":"EBU"}]}');

            System.debug('#####httpRes:'+httpRes+'  ######httpRes.getBody:'+httpRes.getBody());
            if (httpRes.getStatusCode() == 200) {
                System.debug('########### successfully executed ################');
                endDt = System.now();
                Long totalTime = endDt.getTime() - startDt.getTime();
                returnWrapper.totalServiceCallTime = totalTime;
                returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
                returnWrapper.request = req;
                if(!Test.isRunningTest()){
                    system.debug('httpRes----'+httpRes+'res Body--'+httpRes.getBody());
                    returnWrapper.response = httpRes;
                    system.debug('InsideREsponse***'+returnWrapper.response);}
                /*httpres.setStatus('OK');
                    httpres.setStatusCode(200);
                    httpRes.setBody('{"DataArea": {"FieldAction": [{"FieldActionNumber": "1479","FieldActionType": "TRP","FieldActionSRTTime": [{"SRTDetails": "19-601-00","SRTTitle": "Electronic Control Module","StepID": 2134,"StepDescription": "ECM","RTIME": 6.1,"ATIME": 0.1,"BTIME": 2.3,"CTIME": 0.4,"DTIME": 0.0,"S1TIME": 0.0,"S1DESCRIPTION": "All transit busses unless listed elsewhere ","S2TIME": 0.0,"S2DESCRIPTION": "Bombardier Rail Car Power Pack","S3TIME": 0.0,"S3DESCRIPTION": "","S4TIME": 0.0,"S4DESCRIPTION": "","S5TIME": 0.0,"S5DESCRIPTION": "","S6TIME": 0.0,"S6DESCRIPTION": "","S7TIME": 0.0,"S7DESCRIPTION": "","S8TIME": 0.0,"S8DESCRIPTION": "","S9TIME": 0.0,"S9DESCRIPTION": "","SRTQuantity": 4,"SRTMessage": "","Assignment": "Primary","SRTAccessCode": "A","SRTTime": 6.0,"QuoteID": 876876},{"SRTDetails": "19-645-00","SRTTitle": "Electronic Module","StepID": 2134,"StepDescription": "ECM","RTIME": 6.1,"ATIME": 0.1,"BTIME": 2.3,"CTIME": 0.4,"DTIME": 0.0,"S1TIME": 0.0,"S1DESCRIPTION": "","S2TIME": 0.0,"S2DESCRIPTION": "","S3TIME": 0.0,"S3DESCRIPTION": "","S4TIME": 0.0,"S4DESCRIPTION": "","S5TIME": 0.0,"S5DESCRIPTION": "","S6TIME": 0.0,"S6DESCRIPTION": "","S7TIME": 0.0,"S7DESCRIPTION": "","S8TIME": 0.0,"S8DESCRIPTION": "","S9TIME": 0.0,"S9DESCRIPTION": "","SRTQuantity": 4,"SRTMessage": "","Assignment": "Primary","SRTAccessCode": "A","SRTTime": 6.0,"QuoteID": 281597}]},{"FieldActionNumber": "1603","FieldActionType": "TRP","FieldActionSRTTime": [{"SRTDetails": "19-601-00","SRTTitle": "Electronic Control Module","StepID": 2134,"StepDescription": "ECM","RTIME": 6.1,"ATIME": 0.1,"BTIME": 2.3,"CTIME": 0.4,"DTIME": 0.0,"S1TIME": 0.0,"S1DESCRIPTION": "","S2TIME": 0.0,"S2DESCRIPTION": "","S3TIME": 0.0,"S3DESCRIPTION": "","S4TIME": 0.0,"S4DESCRIPTION": "","S5TIME": 0.0,"S5DESCRIPTION": "","S6TIME": 0.0,"S6DESCRIPTION": "","S7TIME": 0.0,"S7DESCRIPTION": "","S8TIME": 0.0,"S8DESCRIPTION": "","S9TIME": 0.0,"S9DESCRIPTION": "","SRTQuantity": 4,"SRTMessage": "","Assignment": "Primary","SRTAccessCode": "A","SRTTime": 6.0,"QuoteID": 876876},{"SRTDetails": "19-645-00","SRTTitle": "Electronic Module","StepID": 2134,"StepDescription": "ECM","RTIME": 6.1,"ATIME": 0.1,"BTIME": 2.3,"CTIME": 0.4,"DTIME": 0.0,"S1TIME": 0.0,"S1DESCRIPTION": "","S2TIME": 0.0,"S2DESCRIPTION": "","S3TIME": 0.0,"S3DESCRIPTION": "","S4TIME": 0.0,"S4DESCRIPTION": "","S5TIME": 0.0,"S5DESCRIPTION": "","S6TIME": 0.0,"S6DESCRIPTION": "","S7TIME": 0.0,"S7DESCRIPTION": "","S8TIME": 0.0,"S8DESCRIPTION": "","S9TIME": 0.0,"S9DESCRIPTION": "","SRTQuantity": 4,"SRTMessage": "","Assignment": "Primary","SRTAccessCode": "A","SRTTime": 6.0,"QuoteID": 876876}]}]},"Header": {"ReturnCodeDescription": "Normal,Successful completion.","Status": "Success","ReturnCode": "ORA-00000","MessageIdentifier": "S"}}');
                    returnWrapper.response = httpRes;*/
                else{
                    httpres.setStatus('OK');
                    httpres.setStatusCode(200);
                    system.debug('StatusCode***'+httpres.getStatusCode());
                    returnWrapper.response = httpRes;    
                    system.debug('returnWrapper.response**'+returnWrapper.response);

                }

            } else {
                returnWrapper.exceptionFlag = true;
                String body = httpRes.getBody();
                String reqBody = Req.getBody();
                Integer statusCode = httpRes.getStatusCode();
                String msg = statusCode + '---' + body+ '---'+reqBody;
                system.debug('***msg***'+msg);
                returnWrapper.exceptionMessage = msg;
                returnWrapper.serviceName = reqWrapper.serviceName;
                returnWrapper.endPoint = conDetails.End_Point__c;
            }
            return returnWrapper;

        } catch (Exception ex) {
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

    // Karthik added
    /* public static CG_OP_OAGWrapper getFailModes(CG_IP_OAGWrapper reqWrapper){
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        String endPointURL;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        try {
            HttpResponse respose;
            Http h1 = new Http();
            HttpRequest request = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
                endPointURL = conDetails.End_Point__c+'FailModes';
            } else {
                endPointURL = 'https://services-dev.cummins.com/css/bmscustomer';
            }
            CG_OP_OAGWrapper accessTokenOPWrap =  getAccessToken(conDetails.AuthEnv__c);
            system.debug('accessTokenOPWrap.exceptionFlag'+accessTokenOPWrap.exceptionFlag);
            //In case of no access token
            if(accessTokenOPWrap!=null && accessTokenOPWrap.exceptionFlag==true) {
                returnWrapper.exceptionFlag=true;
                returnWrapper.errorMessage = accessTokenOPWrap.errorMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;          
            request.setHeader('Authorization','Bearer '+accessToken);

            request.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices)); // need to change
            request.setHeader('Content-Type','application/json');
            request.setMethod('POST');
            request.setEndpoint(endPointURL);
            request.setBody(reqWrapper.jsonReqBody);              
            //Sending request and mapping the response 
            startDt = System.now();
            respose = h1.send(request);
            endDt = System.now();
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalServiceCallTime = totalTime;
            returnWrapper.totalAuthCallTime = accessTokenOPWrap.totalAuthCallTime;
            returnWrapper.request = request;
            returnWrapper.response = respose;
            return returnWrapper;        
        } catch(Exception e) {
            system.debug('Entered into catch block of CLASS - CG_WS_OAG-GetFailModes Method' + e.getMessage() + ' ' + e.getLineNumber());
            returnWrapper.exceptionFlag=true;
            returnWrapper.errorMessage = e.getMessage();
            return returnWrapper;
        } 
    }*/
}