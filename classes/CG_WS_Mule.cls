/**********************************************************************
Name:CG_WS_Mule
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is the Web service Class for Mule Services
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Surender M      06/21/2019      INITIAL DEVELOPMENT                    
**************************************************************************/
public class CG_WS_Mule {
    
    public static CG_OP_OAGWrapper getAccessToken(String serviceName, String mainService){ //Added mainService parameter as part of the story # GSSC-155
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
            string keyMain; //GSSC-155
            if(!Test.isRunningTest()){
                CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
                conDetails = CSS_getConnnectionDetails.getConnection(serviceName);
                system.debug('serviceName ' + serviceName);                
                endPoint = conDetails.End_Point__c;
                system.debug('endPoint'+endPoint);
                client_id = conDetails.Username__c; 
                client_secret = ConDetails.Passcode__c;
                //MuleSoft Migration: Needs to take the key from the respective Service
                CSS_Integration_Details__c conDetailsMain = new CSS_Integration_Details__c();
                conDetailsMain = CSS_getConnnectionDetails.getConnection(mainService);
                key = conDetails.Key__c + conDetailsMain.Key__c;
                //GSSC-155 - Start
                /*CSS_Integration_Details__c conDetailsMain = new CSS_Integration_Details__c();
conDetailsMain = CSS_getConnnectionDetails.getConnection(mainService);

keyMain = conDetailsMain.Key__c; //new body param as resource
//GSSC-155 - End*/
                system.debug('Key**'+key);
            }
            else{
                endPoint = 'https://api-ue-devnf-aw-ex.cummins.com/api/core-security-api/v1/auth/token';
                client_id = 'ad724392-5594-4e85-b9eb-b0fc19c2fabe';
                client_secret = 'ocj8yiMYSDH39gPJpEZTNQo9cCXdgOW5olQ2s1Y3siA=';
                key = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-sp';
            }
            //Added as part of the story # GSSC-155 - START
            if(mainService == 'CG_GetDiagTargetTime'){
                List<String> tempStr = key.split('/');
                String keyTemp = '';
                for(integer i = 0; i < tempStr.size(); i++){
                    if(i == 0){
                        keyTemp = tempStr[i];
                    }
                    else if(i != 0 && i != tempStr.size() - 1){
                        keyTemp = keyTemp + '/' + tempStr[i];
                    }
                    else{
                        keyTemp = keyTemp + '/cmi-engine';
                    }
                }
                key = keyTemp;
            }
            //Added as part of the story # GSSC-155 - END
            req.setEndpoint(endPoint);
            
            req.setMethod('POST');
            req.setHeader('Content-Type','application/json');
            req.setBody('{"client_id":"'+client_id+'","client_secret":"'+client_secret+'","resource":"'+key+'"}');
            system.debug('req>>>>>>>.>>>'+req.getBody());
            
            HttpResponse res = new HttpResponse();
           
            startDt = System.now();
            endDt = System.now();
            System.debug('Connectionsystem time '+endDt);
          //res = http.send(req);
            if(!Test.isRunningTest()){
                System.debug('res1>>>'+res);
                res = http.send(req);
                 System.debug('res after send >>>'+res);
            }else{
                res.setBody('{"token_type":"Bearer","expires_in":"3600","ext_expires_in":"3600","expires_on":"1561063243","not_before":"1561059343","resource":"https://api-ue-devnf-aw-ex.cummins.com/cmi-sp","access_token":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyIsImtpZCI6IkN0ZlFDOExlLThOc0M3b0MyelFrWnBjcmZPYyJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9jbWktc3AiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwiaWF0IjoxNTYxMDU5MzQzLCJuYmYiOjE1NjEwNTkzNDMsImV4cCI6MTU2MTA2MzI0MywiYWlvIjoiNDJaZ1lIamxzbWozejROTnpnWXQ2aTcrVVp2aUFRPT0iLCJhcHBpZCI6ImFkNzI0MzkyLTU1OTQtNGU4NS1iOWViLWIwZmMxOWMyZmFiZSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJvaWQiOiJiYmJmMzU0Mi1iZjY1LTRiMzktYWIzOC0zMDAzNjZjZmJiMGQiLCJzdWIiOiJiYmJmMzU0Mi1iZjY1LTRiMzktYWIzOC0zMDAzNjZjZmJiMGQiLCJ0aWQiOiJiMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QiLCJ1dGkiOiJ5aXlZYkdoUzNVcVRWWjVtQzhOZUFBIiwidmVyIjoiMS4wIn0.PrbkWrRFJSojdTqZ5yP-JeanRHQgOrTUuEf5KNQCT0ejR52VJqGpZp4KpGwo4cBMjiPMSVZlizTANROSaghwpx29iNNWgEDrVRE8VM7_eeBolRYuub6fkk0Ie9VmuqWVomlsDFuk24IQT1q_dxdXZBRGPaSZGRq-xcxGblmdg6zGF_NrUYfGPzDdJk6ccFrcYOWSKJHBzYa12dQFiZ_oaf50EK6WG_FB13tcCVQnhqBqU0vYpOzsKobF96v-2CH1bM1GVMCAq_kez00Drvt2qdJCMCEctrt_7lu8qkBQ1OXHBSj9sSy0EnptN7DQ3L6HSxTrRZuoQftTwMsSMzfR8g"}');
                res.setStatusCode(200);
            }
            System.debug('res2>>>'+res);
            string jSONRequestBody = res.getBody();
            system.debug('@@@ jSONRequestBody'+jSONRequestBody);
            // CG_WPR_MuleTokenResJSON wprObj = (CG_WPR_MuleTokenResJSON)JSON.deserializeStrict(jSONRequestBody,CSS_J2AToken_SRT.class); 
            //Modified as part of observation.-Gopal
            CG_WPR_MuleTokenResJSON wprObj = (CG_WPR_MuleTokenResJSON)JSON.deserializeStrict(jSONRequestBody,CG_WPR_MuleTokenResJSON.class); 
            accessToken = wprObj.access_token;
            returnWrapper.accessToken = accessToken;
            Long totalTime = endDt.getTime() - startDt.getTime();
            returnWrapper.totalAuthCallTime = totalTime;
            
        }
        catch(exception e){
            system.debug('Entered into catch of Mule token Method in CG_WS_Mule>>>'+e.getMessage() +e.getLineNumber());
            returnWrapper.exceptionFlag = true;
            returnWrapper.errorMessage = 'Some error in getting OAG : '+e.getMessage();
            returnWrapper.appName = 'MuleToken';
            returnWrapper.endPoint = endPoint;
            
        }
        return returnWrapper;        
    }
    
    public static CG_OP_OAGWrapper calloutGeneric(CG_IP_OAGWrapper reqWrapper) {
        system.debug('in calloutGeneric method...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
            system.debug('reqWrapper>>>>:'+reqWrapper);
            system.debug('reqWrapper.serviceName>>>>:'+reqWrapper.serviceName);
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection(reqWrapper.serviceName);
            //Added above two lines for adding remote connection using VF page rather than adding cusom settings.
            //CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
            system.debug('Service conDetails>>>:'+conDetails);
            if (conDetails == null){
                conDetails = new CSS_Integration_Details__c();
                conDetails.AuthEnv__c = 'MuleAuth'; //since it is null in PROD
                system.debug('inside conDetails>>>:'+conDetails);
            }
            CG_OP_OAGWrapper accessTokenOPWrap = getAccessToken(conDetails.AuthEnv__c, reqWrapper.serviceName);
            
            //In case of no access token return wrapper
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = accessTokenOPWrap.exceptionMessage;
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;
            
            HttpRequest req = new HttpRequest();
            //List<string> caseNum = new List<string>{'K87481914'};
            req.setEndpoint(conDetails.End_Point__c);
            
            System.debug('=======> ConDetails>>:'+conDetails.End_Point__c);
            req.setHeader('client-id', conDetails.Username__c); //new header param //271bf3f9be404e4b9a3a85559a2cecb3
            
            req.setHeader('client-secret', conDetails.Passcode__c); //new header param //74A587c3C7Ff45A38B87A6C49ec29299
            
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' +accessToken);
            
            
            req.setBody(reqWrapper.jsonReqBody);
            //String reqBodyHardCode = '{"Header":{"Sender":{"MessageID":"unique message ID at SF","SenderID":"SF","ServiceName":"GetDiagnosticTargetTime"},"Target":{"TargetID":"SRT"}},"DataArea":{"SolutionIds":["S00005779","S00001271"],"EquipmentId":"EQ6780","ServiceModelName":"N14 CELECT","EngineFamily":"09","EffectiveDateTime":"2020-07-29T03:33:07","LanguageCode":"en"}}';
            //req.setBody(reqBodyHardCode);
            conDetails.Method_Type__c = 'POST';//Added New
            conDetails.Timeout__c = 120000;//Added New
            system.debug('Method_Type__c>>>:'+conDetails.Method_Type__c);
            System.debug('===reqWrapper.jsonReqBody====' + reqWrapper.jsonReqBody);
            req.setMethod(conDetails.Method_Type__c);
            Integer timeOut = conDetails.Timeout__c.intValue();
            req.setTimeout(timeOut);    
            //req.setTimeout(120000);
            system.debug('client-id>>'+conDetails.Username__c);
            
            Http http = new Http();
            startDt = System.now();
            HttpResponse httpRes = new HttpResponse();
            
            if(!Test.isRunningTest()) {
                httpres = http.send(req);
                
            }else{
                httpres.setStatusCode(200);
                
            }
            
            //System.debug('#####httpResupdate1#####'+httpRes+'  ######httpRes.getBody:'+httpRes.getBody());
            if (httpRes.getStatusCode() == 200 ) {
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
                else{
                    httpres.setStatus('OK');
                    httpres.setStatusCode(200);
                    system.debug('StatusCode***'+httpres.getStatusCode());
                    returnWrapper.response = httpRes;    
                    system.debug('returnWrapper.response**'+returnWrapper.response);
                }
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
    
    public static CG_OP_OAGWrapper calloutGenericMule(CG_IP_OAGWrapper reqWrapper) {
        system.debug('in calloutGeneric method for CreateUpdate Incident Record Into ServiceNow...');
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        String jSONReqBody;
        Datetime startDt;
        Datetime endDt;
        try {
            system.debug('reqWrapper>>>>:'+reqWrapper);
            system.debug('reqWrapper.serviceName>>>>:'+reqWrapper.serviceName);
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails = CSS_getConnnectionDetails.getConnection(reqWrapper.serviceName);
            //Added above two lines for adding remote connection using VF page rather than adding cusom settings.
            //CSS_Integration_Details__c conDetails = CSS_Integration_Details__c.getValues(reqWrapper.serviceName);
            system.debug('conDetails>>>:'+conDetails);
            //conDetails.AuthEnv__c = 'MuleAuth'; //since it is null in PROD
            String authEnv = conDetails != null ? conDetails.AuthEnv__c : ''; //CT2-388 : null check added
            String serviceName = reqWrapper != null ? reqWrapper.serviceName : ''; //CT2-388 : null check added
            CG_OP_OAGWrapper accessTokenOPWrap = getAccessToken(authEnv, serviceName);
            
            //In case of no access token return wrapper
            if (accessTokenOPWrap != null && accessTokenOPWrap.exceptionFlag == true) {
                returnWrapper.exceptionFlag = true;
                returnWrapper.exceptionMessage = accessTokenOPWrap.exceptionMessage;
                   
                return returnWrapper;
            }
            String accessToken = accessTokenOPWrap.accessToken;
            
            HttpRequest req = new HttpRequest();
            //req.setEndpoint(conDetails.End_Point__c);
            req.setEndpoint(reqWrapper.endPoint);
            system.debug('reqWrapper.endPoint'+reqWrapper.endPoint);
            if(conDetails != null){
                System.debug('=======> ConDetails>>:'+conDetails.End_Point__c);
                if(reqWrapper.serviceName == 'FSL_TextNotification'){
                    req.setHeader('client_id', conDetails.Username__c); //new header param    
                    req.setHeader('client_secret', conDetails.Passcode__c); //new header param
                }else{
                    req.setHeader('client-id', conDetails.Username__c); //new header param //271bf3f9be404e4b9a3a85559a2cecb3
                    
                    req.setHeader('client-secret', conDetails.Passcode__c); //new header param //74A587c3C7Ff45A38B87A6C49ec29299
                }
                req.setHeader('Content-Type', 'application/json');
                req.setHeader('Authorization', 'Bearer ' +accessToken);
                
                //if(conDetails.Method_Type__c == 'POST'){//-- Commented  by Case managemnet develpment Team--//
                //Below code added by case management development team for Update Service now Incident details-- Start Here--//
                if(reqWrapper.methodType == 'POST' || reqWrapper.methodType == 'PUT' ){
                    req.setBody(reqWrapper.jsonReqBody);
                }
                //--- End here------//
                //conDetails.Method_Type__c = 'POST';//Added New
                conDetails.Timeout__c = 120000;//Added New
                system.debug('Method_Type__c>>>:'+conDetails.Method_Type__c);
                System.debug('===reqWrapper.jsonReqBody====' + reqWrapper.jsonReqBody);
                //req.setMethod(conDetails.Method_Type__c);
                req.setMethod(reqWrapper.methodType);
                Integer timeOut = conDetails.Timeout__c.intValue();
                req.setTimeout(timeOut);    
                //req.setTimeout(120000);
                system.debug('client-id>>'+conDetails.Username__c);
                
            }
            Http http = new Http();
            startDt = System.now();
            HttpResponse httpRes = new HttpResponse();
            
            if(!Test.isRunningTest()) {
                system.debug('req'+req);
                system.debug('reqBody'+req.getBody());
                httpres = http.send(req);
                system.debug('httpres>>>'+httpres);
            }else{
                system.debug('Calling from Test class');
                httpres.setStatusCode(200);
                Test.setMock(HttpCalloutMock.class , new CG_CL_GetClaimDetails_Mock());
                system.debug('Calling from Test class 2');
                
            }
            
            System.debug('#####httpRes:'+httpRes+'  ######httpRes.getBody:'+httpRes.getBody());
            if (httpRes.getStatusCode() == 200 || httpRes.getStatusCode() == 201 ) {//ADDED 201 by CSM Team
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
                else{
                    httpres.setStatus('OK');
                    httpres.setStatusCode(200);
                    string json='{ "Response": {"claim": {"CG_ODM_ResJSONParser.messages": [{"messageID":"sfdsfsd","description": "oh559","code": "ODM-HE-WAR-205","type": "oh559"}]}},"Header": { "ReturnCodeDescription": "<Message from Siebel>", "Status": "Success", "ReturnCode": "<MessageCode from Siebel>", "MessageIdentifier": "<Identifier from MW>" }, "DataArea": [ { "Notes": [ { "Note": "TestComplaint", "NoteType": "Complaint", "CreatedDate":"01/5/2013" }, { "Note": "TestComplaint1", "NoteType": "Complaint", "CreatedDate":"01/5/2013" }, { "Note": "TestCause", "NoteType": "Cause", "CreatedDate":"01/5/2013"}, { "Note": "TestCause1", "NoteType": "Cause", "CreatedDate":"01/5/2013"} ], "ServiceProviderCode": "34234", "DistributorCode": "42333", "DistributorName": "Cummins Distributor Name", "PSN": "2342335", "WorkOrderNumber": "ABC45233", "WarrantyStartDate": "2012-06-06", "EngineApplicationCode": "130", "Manufacturer": "KENWORTH", "ModelSeries": "T300", "Contact": "FirstName LastName", "BISFlag": "N", "FailureDate": "2012-06-06", "FailurePoint": 2323, "FailureMeasure": "Miles", "DISDNumber": "23423", "CustomerName": "ABZ Tavels", "EngineVIN": "234msdflo303jfp3ed", "TSRNumber": "234434", "UnitNumber": "D234", "DealerClaimNumber": "C453453245", "ClaimSource": "MX", "ClaimFiledDate": "2017-06-06", "ECMCalibAfter": "23423", "ECMCalibBefore": "234234", "ECMRevBfr": "34234", "ECMRevAfter": "23423", "FailureList": [ { "SystemCode": "BS", "ComponentCode": "HS", "FailMode": "BR", "Failurename": "Turbo Charger", "CampaignNumber": "C24523", "FaultCode": "125", "AccountCode": "67", "PayCode": "I", "PartsList": [ { "PartNumber": "345345", "PartDescription": "PartName1", "ClaimedQty": "2", "AdjustedQty": "1", "TrackingNumber": "23456232346", "RID": "34234", "AdjustmentReason": "Quantity used as not covered" }, { "PartNumber": "77886", "PartDescription": "PartName2", "ClaimedQty": "1", "AdjustedQty": "1", "TrackingNumber": "3245345345", "RID": "34534", "AdjustmentReason": "Reason Description" } ], "OtherClaimablesList": [ { "Item": "", "ItemDescription": "", "ClaimedAmount": 1, "AdjustedAmount": 2, "AdjustmentReason": "" }, { "Item": "", "ItemDescription": "", "ClaimedAmount": 1, "AdjustedAmount": 2, "AdjustmentReason": "" } ], "SRTList": [ { "SRTCode": "", "SRTDescription": "", "SRTHours": 1, "ClaimedQty": 1, "ClaimedPercent": 1, "ClaimedHours": 1, "AdjustedQty": 1, "AdjustedPercent": 1, "AdjustedHours": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "" }, { "SRTCode": "", "SRTDescription": "", "SRTHours": 1, "ClaimedQty": 1, "ClaimedPercent": 1, "ClaimedHours": 1, "AdjustedQty": 1, "AdjustedPercent": 1, "AdjustedHours": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "" } ], "TravelList": [ { "TravelType": "Commercial", "ClaimedDistance": 1, "ClaimedHours": 1, "ClaimedAmount": 1, "AdjustedDistance": 2, "AdjustedHours": 1, "AdjustedAmount": 1, "LodgingAmount": 1, "MealsAmount": 1, "TowingAmount": 1, "LaborAmount": 1, "TravelAmount": 1, "TotalTravel": 1, "BaseFare": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "", "AdjustedPercent": 1 }, { "TravelType": "Meals", "ClaimedDistance": 1, "ClaimedHours": 1, "ClaimedAmount": 1, "AdjustedDistance": 2, "AdjustedHours": 1, "AdjustedAmount": 1, "LodgingAmount": 1, "MealsAmount": 1, "TowingAmount": 1, "LaborAmount": 1, "TravelAmount": 1, "TotalTravel": 1, "BaseFare": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "", "AdjustedPercent": 1 } ] }, { "SystemCode": "CR", "ComponentCode": "JH", "FailMode": "UH", "Failurename": "Aftermarket assembly", "CampaignNumber": "C86666", "FaultCode": "563", "AccountCode": "51", "PayCode": "D", "PartsList": [ { "PartNumber": "", "PartDescription": "", "ClaimedQty": "", "AdjustedQty": "", "TrackingNumber": "", "RID": "", "AdjustmentReason": "" }, { "PartNumber": "", "PartDescription": "", "ClaimedQty": "", "AdjustedQty": "", "TrackingNumber": "", "RID": "", "AdjustmentReason": "" } ], "OtherClaimablesList": [ { "Item": "", "ItemDescription": "", "ClaimedAmount": 1, "AdjustedAmount": 2, "AdjustmentReason": "" }, { "Item": "", "ItemDescription": "", "ClaimedAmount": 1, "AdjustedAmount": 2, "AdjustmentReason": "" } ], "SRTList": [ { "SRTCode": "", "SRTDescription": "", "SRTHours": 1, "ClaimedQty": 1, "ClaimedPercent": 1, "ClaimedHours": 1, "AdjustedQty": 1, "AdjustedPercent": 1, "AdjustedHours": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "" }, { "SRTCode": "", "SRTDescription": "", "SRTHours": 1, "ClaimedQty": 1, "ClaimedPercent": 1, "ClaimedHours": 1, "AdjustedQty": 1, "AdjustedPercent": 1, "AdjustedHours": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "" } ], "TravelList": [ { "TravelType": "Meals", "ClaimedDistance": 1, "ClaimedHours": 1, "ClaimedAmount": 1, "AdjustedDistance": 2, "AdjustedHours": 1, "AdjustedAmount": 1, "LodgingAmount": 1, "MealsAmount": 1, "TowingAmount": 1, "LaborAmount": 1, "TravelAmount": 1, "TotalTravel": 1, "BaseFare": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "", "AdjustedPercent": 1 }, { "TravelType": "Commercial", "ClaimedDistance": 1, "ClaimedHours": 1, "ClaimedAmount": 1, "AdjustedDistance": 2, "AdjustedHours": 1, "AdjustedAmount": 1, "LodgingAmount": 1, "MealsAmount": 1, "TowingAmount": 1, "LaborAmount": 1, "TravelAmount": 1, "TotalTravel": 1, "BaseFare": 1, "AdjustmentReason": "", "PenaltyAppliedFlag": "", "AdjustedPercent": 1 } ] } ], "AdditionalESNs": [ { "PSN": "", "WarrantyStartDate": "2012-06-06", "BISFlag": "", "FailurePoint": 12, "FailureMeasure": "", "VIN": "", "ECMCalibAfter": "", "ECMCalibBefore": "", "ECMRevBfr": "", "ECMRevAfter": "" }, { "PSN": "", "WarrantyStartDate": "2012-06-06", "BISFlag": "", "FailurePoint": 12, "FailureMeasure": "", "VIN": "", "ECMCalibAfter": "", "ECMCalibBefore": "", "ECMRevBfr": "", "ECMRevAfter": "" } ], "ComplaintCodes": [ { "ComplaintCode": "", "ComplaintText": "" }, { "ComplaintCode": "", "ComplaintText": "" } ] } ] }';
                    httpres.setbody(json);
                    system.debug('StatusCode***'+httpres.getStatusCode());
                    returnWrapper.response = httpRes;    
                    system.debug('returnWrapper.response**'+returnWrapper.response);
                }
            } 
            //added by CSM Dev Team
            else if(httpRes.getStatusCode() == 400){
                returnWrapper.response = httpRes;
                returnWrapper.exceptionFlag = true; //Phoen-142, Send To Assign Issues Fix.   
                returnWrapper.errorResponse=(CG_OP_OAGWrapper.errorResponse)JSON.deserializeStrict(httpRes.getBody(), CG_OP_OAGWrapper.errorResponse.class);
            }
            //ended
            else{
                returnWrapper.response = httpRes;//Added this line by CSM Team
                returnWrapper.exceptionFlag = true;
                String body = httpRes.getBody();
                Integer statusCode = httpRes.getStatusCode();
                String msg = statusCode + '---' + body;
                
                returnWrapper.exceptionMessage = msg;
                returnWrapper.serviceName = reqWrapper.serviceName;
                returnWrapper.endPoint = conDetails.End_Point__c;
                returnWrapper.errorResponse=(CG_OP_OAGWrapper.errorResponse)JSON.deserializeStrict(httpRes.getBody(), CG_OP_OAGWrapper.errorResponse.class);

            }
            system.debug('returnWrapper==='+returnWrapper);
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