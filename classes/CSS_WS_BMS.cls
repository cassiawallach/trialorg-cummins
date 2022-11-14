/**********************************************************************
Name: CSS_WS_BMS
Copyright © 2016  Cummins
======================================================
======================================================
Purpose: Class contains methods to consume various
BMS Inbound and Outbound Webservices 
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE          DETAIL                                 
1.0     Rakesh Kumar        01-Sep-2016    INITIAL DEVELOPMENT  
1.1     Kalpana Vemula      06-Sep-2016    callBMSWOQTOutboundService    
1.2     Kalpana Vemula      06-Sep-2016    callBMSWOQTInboundService
1.3     Nisha Mendiratta    06-Sep-2016    Call callServiceHistoryOutboundService and callWOCommentInboundService
1.4     Rakesh Kumar        15-Sep-2016    Updated the param of callBMSWOQTInboundService
1.5     Nisha               20-Sep-2016    Added methodcallJobPlanInboundService 
1.6Gyan Pany07-Dec-2016Modified Comments and Added splreceiveToken method
***********************************************************************/
public class CSS_WS_BMS {
    //Special receive Token Method to enable switch between BMS Instances without impacting other Integrations
    
    public static CG_OP_OAGWrapper returnWrapperglobal = new CG_OP_OAGWrapper();
    public static String responseMsg;
    public static string splreceiveToken(string sConn) {
        string accessToken;
        string endPoint;
        HttpResponse res = new HttpResponse();
        
        try {
            HttpRequest req = new HttpRequest();
            Http oagHTTP = new Http();
            string client_id;
            string client_secret; 
            string sConnection;
            //system.debug('splreceiveToken before sConnection, the sConn value is: ' + sConn);
            if (sConn == null) {sConnection = 'OAGOAuth';} else {sConnection = sConn;}
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            //system.debug('splreceiveToken before Endpoint fetch connection value is: ' + sConnection);
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection(sConnection);
                endPoint = conDetails.End_Point__c;
                client_id = conDetails.Username__c;   
                client_secret = ConDetails.Passcode__c; 
            }
            else{
                //if(Test.isRunningTest()){
                endPoint = 'https://services-dev-oauth.cummins.com/api/oauth/token/css';
                client_id = 'd65101fd-601d-410a-9b12-8a72a6d98fae';
                client_secret = '7b398614-6612-4d52-9687-04fa654083bd';
            }
            //system.debug('splreceiveToken after Endpoint fetch Endpoint value is: ' + endPoint);
            req.setEndpoint(endPoint);
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            req.setBody('grant_type=client_credentials&client_id='+client_id+'&client_secret='+client_secret+'&scope=CSSCloud');
            if(!Test.isRunningTest()){
                res = oagHTTP.send(req);
            }else{
                res.setBody('{"access_token":"94pPkrL0Yt2guPTJJxM9PYTxZZ8it2YYy2twpGN8q7EN313l1GU6sX","token_type":"Bearer","expires_in":24000,"refresh_token":"VGaPh5uivMb7vtGUoT7aXeN9pyaa0QiYH7Im1qE7g7WNLZ","scope":"CSSCloud"}');
                res.setStatusCode(200);
            }
            //system.debug('splreceiveToken after request, response value is: ' + res.getBody());
            string jSONResponseBody = res.getBody();
            CSS_J2AToken_SRT wo1 = (CSS_J2AToken_SRT)JSON.deserializeStrict(jSONResponseBody,CSS_J2AToken_SRT.class); 
            accessToken = wo1.access_token;
            //system.debug('splreceiveToken after parsing request, accessToken value is: ' + accessToken);
        }
        catch (exception e) {
            System.debug('accessToken Error in splreceiveToken method for '+ sConn +' is: ' + e.getLineNumber() + e.getMessage());
            accessToken = 'ERROR';
            if(!Test.isRunningTest()){
                css_utility.LogOutIntError(endPoint,e.getMessage()+'- OAG Token', res==null?'RESPONSE IS NULL':res.getBody(), 'BMSLOGIN');
            }
        }
        System.debug('accessToken Value in splreceiveToken method for '+ sConn +' set to: ' + accessToken );
        return accessToken;
    }    
    //Method to call Customer Lookup Outbound Bms Webservice
    public static CSS_customerOutboundJSON2Apex callCustOutboundService(String custName,String custCode,String Location){
        CSS_customerOutboundJSON2Apex customerDetail;
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
            //if(!Test.isRunningTest()){
            conDetails = CSS_getConnnectionDetails.getConnection('BMSCustomer');          
            bmsUsername = conDetails.Username__c;
            bmsPassword = conDetails.Passcode__c;
            //Setting Endpint URL 
            //endPointURL = conDetails.End_Point__c+'bmscustomer';
            endPointURL = conDetails.End_Point__c;
            //}
            //else
            if(Test.isRunningTest())
            {
                //endPointURL = 'https://services-dev.cummins.com/css/bmscustomer';
                endPointURL = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/customer';
            }
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            //String access_token = splreceiveToken(Label.CSS_AltOAuth);
            /*CG_OP_OAGWrapper accessTokenOPWrap = CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('BMSCustomer').AuthEnv__c,'BMSCustomer');
String access_token = accessTokenOPWrap.accesstoken;*/ //Not required,as we are calling it in calloutgenericMule below
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //reqWrapper.endPoint = endPointURL+'?sender=CSS&target=BMS&locationId=03520-04892&customerName=Fabiano&customerCode=&dealerCode=';
            reqWrapper.endPoint = endPointURL+'?sender=CSS&target=BMS&locationId='+location+'&customerName='+custName+'&customerCode='+custCode+'&dealerCode=';
            reqWrapper.methodType = 'GET';
            reqWrapper.serviceName='BMSCustomer';
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            
            /*system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setHeader('Content-Type','application/json');
req1.setMethod('GET');
req1.setEndpoint(endPointURL+'?sender=CSS&target=BMS&locationId=03520-04892&customerName=Fabiano&customerCode=&dealerCode=');*/
            //Building Request Body or request String 
            //String requeststring = '{"Header": {"Sender": { "ServiceName": "GetCustomer", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "02400-02394" } }, "DataArea": { "CustomerName": "NYFD", "CustomerCode": "C100002045" }}';
            //Commenting belowblock as per Mule Integration Migration 20/05/2020
            /*if(custName == null)
custName = '';
if(custCode == null)
custCode = '';            
String requeststring = '{"Header": {"Sender": { "ServiceName": "GetCustomer", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "CustomerName": "'+custName+'", "CustomerCode": "'+custCode+'", "DealerCode": "" }}';
req1.setBody(requestString);              
System.debug('req1.getBody======'+req1.getBody());
system.debug('req.getendpoint***'+req1.getEndpoint());
//Sending request and mapping the response 
res1 = h1.send(req1);
System.debug('Status Code >>> :: '+res1.getStatusCode());
system.debug('Response Body >>>'+res1.getbody());*/
            //Setting response to the string 
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                jsonResponse = returnWrapper.response.getBody();
            
            //Condition to check when the Server is down or we get response code other than 200 or 201.
            if(returnWrapper!=null && returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201){
                //CSS_PageErrorHandlingUtility.showError('CSS is unable to establish integration services at this time.  No Data returned.  Please capture customer information.');
                throw new CSS_CustomException('System is Down' + returnWrapper.response.getStatusCode());
            }
            
        }catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            //Setting the response for the system outage customerDetail.
            jsonResponse = '{"Header":{"ReturnCodeDescription":"'+system.label.CSS_Cust_Service_Down+'","Status":"ERROR","Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"56270-56270"}},"DataArea": []}';
            
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS Customer Lookup Outbound Service', 'RESPONSE IS NULL', 'BMS');
                    //Setting the error Message when the server time out happens server not able to establish proper connection 
                    //CSS_PageErrorHandlingUtility.showError('CSS is unable to establish integration services at this time.  No Data returned.  Please capture customer information.');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS Customer Lookup Outbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
                }
            }
        }
        //Deserialize the response from Bms web service  to the Wrapper Class
        if(Test.isRunningTest())
            jsonResponse='{"DataArea":[{"LocationAddressline3":"","RequirePO":"Y","AmountDue":"0","CustomerCode":"1347277","CreditLimit":"","QuoteCustomer":"N","City":"BURBANK","AvailableCredit":"0","State":"IL","Country":"US","AreaCode":"708","PhoneNumber":"5990422","PaymentType":"CCARD","CustomerName":"CHUCK FABIANO","Postalcode1":"60459","LocationAddressline1":"7760 NEWLAND AVE","LocationAddressline2":"","Postalcode2":""},{"LocationAddressline3":"","RequirePO":"N","AmountDue":"0","CustomerCode":"1379283","CreditLimit":"20000","QuoteCustomer":"N","City":"SCHOFIELD","AvailableCredit":"20000","State":"WI","Country":"US","AreaCode":"715","PhoneNumber":"3590448","PaymentType":"CHARGE","CustomerName":"FABIANO BROTHERS","Postalcode1":"54476","LocationAddressline1":"7205 ZINSAR ST","LocationAddressline2":"","Postalcode2":""},{"LocationAddressline3":"","RequirePO":"Y","AmountDue":"0","CustomerCode":"1379372","CreditLimit":"0","QuoteCustomer":"N","City":"SCHOFIELD","AvailableCredit":"0","State":"WI","Country":"US","AreaCode":"715","PhoneNumber":"3590448","PaymentType":"CCARD","CustomerName":"FABIANO BROTHERS","Postalcode1":"54476","LocationAddressline1":"USE CN 1379283","LocationAddressline2":"","Postalcode2":""}],"Header":{"Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Status":"SUCCESS","Target":{"TargetID":"BMS"},"Location":{"LocationID":"03520-04892"}}}';
        customerDetail = (CSS_customerOutboundJSON2Apex)JSON.deserializeStrict(jsonResponse,CSS_customerOutboundJSON2Apex.class);
        system.debug('customerDetail >>>'+customerDetail); 
        return customerDetail;
    } 
    /*public static CSS_customerOutboundJSON2Apex callCustOutboundService_Existing(String custName,String custCode,String Location){
CSS_customerOutboundJSON2Apex customerDetail;
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
conDetails = CSS_getConnnectionDetails.getConnection('BMS');          
bmsUsername = conDetails.Username__c;
bmsPassword = conDetails.Passcode__c;
//Setting Endpint URL 
endPointURL = conDetails.End_Point__c+'bmscustomer';
}
else
{
endPointURL = 'https://services-dev.cummins.com/css/bmscustomer';
}
//getting Access Token 
//String access_token = CSS_SRT.receiveToken();
String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setEndpoint(endPointURL);
//Building Request Body or request String 
//String requeststring = '{"Header": {"Sender": { "ServiceName": "GetCustomer", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "02400-02394" } }, "DataArea": { "CustomerName": "NYFD", "CustomerCode": "C100002045" }}';
if(custName == null)
custName = '';
if(custCode == null)
custCode = '';            
String requeststring = '{"Header": {"Sender": { "ServiceName": "GetCustomer", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "CustomerName": "'+custName+'", "CustomerCode": "'+custCode+'", "DealerCode": "" }}';
req1.setBody(requestString);              
System.debug('req1.getBody======'+req1.getBody());
//Sending request and mapping the response 
res1 = h1.send(req1);
System.debug('Status Code >>> :: '+res1.getStatusCode());
system.debug('Response Body >>>'+res1.getbody());
//Setting response to the string 
jsonResponse = res1.getBody();

//Condition to check when the Server is down or we get response code other than 200 or 201.
if(res1!=null && res1.getStatusCode()!=200 && res1.getStatusCode()!=201){
//CSS_PageErrorHandlingUtility.showError('CSS is unable to establish integration services at this time.  No Data returned.  Please capture customer information.');
throw new CSS_CustomException('System is Down' + res1.getStatusCode());
}

}catch(Exception ex){
System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
System.debug('getLineNumber*********************is :: '+ex.getMessage());
//Setting the response for the system outage customerDetail.
jsonResponse = '{"Header":{"ReturnCodeDescription":"'+system.label.CSS_Cust_Service_Down+'","Status":"ERROR","Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"56270-56270"}},"DataArea": []}';

if(!Test.isRunningTest()){
message = ex.getMessage();

if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS Customer Lookup Outbound Service', 'RESPONSE IS NULL', 'BMS');
//Setting the error Message when the server time out happens server not able to establish proper connection 
//CSS_PageErrorHandlingUtility.showError('CSS is unable to establish integration services at this time.  No Data returned.  Please capture customer information.');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS Customer Lookup Outbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
}
}
}
//Deserialize the response from Bms web service  to the Wrapper Class 
customerDetail = (CSS_customerOutboundJSON2Apex)JSON.deserializeStrict(jsonResponse,CSS_customerOutboundJSON2Apex.class);
system.debug('customerDetail >>>'+customerDetail); 
return customerDetail;
} */
    
    // Method to Call Unit lookup Outbound
    public static CSS_UnitOutboundJSON2Apex callUnitOutboundService(String ESN,String custCode,String Location){
        CSS_UnitOutboundJSON2Apex UnitOutboundDetails;
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
                conDetails = CSS_getConnnectionDetails.getConnection('BMSUnitService');          
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;     
                //Setting Endpint URL 
                endPointURL = conDetails.End_Point__c;
            }
            else
                endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/unit?sender=CSS&target=BMS&locationId=02860-40830&esn=&customerCode=197531&&unitNumber=177604&registration=&vin=';
            //endPointURL = 'https://services-dev.cummins.com/css/bmsunit';
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            /*String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
//Building Request 
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setEndpoint(endPointURL);
//Building Request Body or request String
// string JSONReq = '{ "Header":  {"Sender":  { "ServiceName": "GetUnitInfo", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "02400-02394" } }, "DataArea":  {   "ESN": "79464646" , "CustomerCode": "C100002045" } }';             
string JSONReq = '{ "Header":  {"Sender":  { "ServiceName": "GetUnitInfo", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea":  {   "ESN": "'+ESN+'" , "CustomerCode": "'+custCode+'" } }';             
req1.setBody(JSONReq);
System.debug('req1.getBody======'+req1.getBody());
//Sending request and mapping the response 
res1 = h1.send(req1);
System.debug('Status Code >>> :: '+res1.getStatusCode());
system.debug('Response Body >>>'+res1.getbody());*/
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            //reqWrapper.endPoint = endPointURL+'?sender=CSS&target=BMS&locationId="'+Location+'"&esn="'+ESN+'"&customerCode= "'+custCode+'"&unitNumber=&registration=&vin=';
            //reqWrapper.endPoint = endPointURL+'?sender=CSS&target=BMS&locationId=02860-40830&esn=&customerCode=197531&unitNumber=177604&registration=&vin=';
            reqWrapper.endPoint = endPointURL+'?sender=CSS&target=BMS&locationId='+Location+'&esn='+ESN+'&customerCode='+custCode+'&unitNumber=&registration=&vin=';
            reqWrapper.methodType = 'GET';
            reqWrapper.serviceName='BMSUnitService';
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                jsonResponse = returnWrapper.response.getBody();
            //Deserialize the response from Bms web service to the Wrapper Class 
            //CSS_BMSJ2A bms = (CSS_BMSJ2A)JSON.deserializeStrict(jsonResponse,CSS_BMSJ2A.class);
            //system.debug('bms>>>>'+bms.BMSResponse);
            //Deserialize the response from Bms web service respose__c field to the Wrapper Class
            //  UnitOutboundDetails = (CSS_UnitOutboundJSON2Apex)JSON.deserializeStrict(bms.BMSResponse,CSS_UnitOutboundJSON2Apex.class);
            
            //system.debug('UnitOutboundDetails****'+UnitOutboundDetails.DataArea);
            //system.debug('UnitOutboundDetails>>>>'+UnitOutboundDetails.Header +'*************'+UnitOutboundDetails);
            
            //Condition to check when the Server is down or we get response code other than 200 or 201.
            if(returnWrapper.response!=null && returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201){
                //CSS_PageErrorHandlingUtility.showError('CSS is unable to establish integration services at this time.  No Data returned.  Please capture customer information.');
                throw new CSS_CustomException('System is Down' + returnWrapper.response.getStatusCode());
            }
        }catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            jsonResponse = '{"Header":{"Status":"SYSTEM","Sender":{"ServiceName":"GetCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"02400-02394"}},"DataArea": []}';
            system.debug('jsonResponse>>>'+jsonResponse);
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                // Commented to handle INSITE Scenario. 
                /* if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS UnitOutbound Service', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS UnitOutbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
} */
            }
        }
        if(Test.isRunningTest())
            jsonResponse='{"Header":{"Sender":{"ServiceName":"GetUnitInfo","SenderID":"CSS","MessageID":"f7a55312-5cd4-4be6-a811-140b1b80cda5"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"Unit not Found","Location":{"LocationID":"02860-40830"}}}';
        UnitOutboundDetails = (CSS_UnitOutboundJSON2Apex)JSON.deserializeStrict(jsonResponse,CSS_UnitOutboundJSON2Apex.class);
        system.debug('UnitOutboundDetails in ws bms>>>'+UnitOutboundDetails);
        return UnitOutboundDetails;
    }
    
    // Method to Call WOQT Outbound 
    Public static CSS_BMSWOQTOutboundJSON2APEX callBMSWOQTOutboundService(){
        CSS_BMSWOQTOutboundJSON2APEX WOQTOutboundDetails;
        String endPointURL;
        string message;
        HttpResponse res1;
        String bmsUsername;
        String bmsPassword;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        
        try{
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('BMS');          
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;     
                //Setting Endpint URL 
                endPointURL = conDetails.End_Point__c+'WOQTOutbound';
            }
            else
                endPointURL = 'https://services-dev.cummins.com/css/WOQTOutbound/';
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            String access_token = splreceiveToken(Label.CSS_AltOAuth);
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
            req1.setHeader('Authorization','Bearer '+access_token);
            req1.setHeader('Content-Type','application/json');
            req1.setMethod('POST');
            req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
            //Setting End Point URL
            req1.setEndpoint(endPointURL);
            //Building Request Body or request String
            string JSONReq = '{ "Header":  {"Sender":  { "ServiceName": "GetWOQuote", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "02400-02394" } }, "DataArea":  { "CSSJobID": "CSS-00002678" } }';             
            //string JSONString = JSON.serialize(attachmentList);
            req1.setBody(JSONReq);
            System.debug('req1.getBody======'+req1.getBody());
            //Sending request and mapping the response
            res1 = h1.send(req1);
            System.debug('StatusCode>>>> :'+res1.getStatusCode());
            system.debug('Response Body>>>>:'+res1.getBody());
            //Setting response to the string
            string jsonResponse = res1.getBody();
            //Deserialize the response from Bms web service to the Wrapper Class 
            //CSS_BMSJ2A bms = (CSS_BMSJ2A)JSON.deserializeStrict(jsonResponse,CSS_BMSJ2A.class);
            //system.debug('bms>>>>'+bms.BMSResponse);
            //Deserialize the response from Bms web service respose__c field to the Wrapper Class
            WOQTOutboundDetails = (CSS_BMSWOQTOutboundJSON2APEX)JSON.deserializeStrict(jsonResponse,CSS_BMSWOQTOutboundJSON2APEX.class);
            system.debug('sj>>>>'+WOQTOutboundDetails.Header +'*************'+WOQTOutboundDetails);
            system.debug('WOQTOutboundDetails.DataArea.Companycode*****'+WOQTOutboundDetails.DataArea.Companycode);
            system.debug('WOQTOutboundDetails.DataArea.DivisionCode******'+WOQTOutboundDetails.DataArea.DivisionCode);
            return WOQTOutboundDetails;
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOQTOutbound Service', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOQTOutbound Service', res1.getBody(), 'BMS');
                }
            }
        }
        return null;
        
    }
    
    //Method to Call WOQT Inbound
    public static CSS_BMSWOQTInboundJSON2APEX callBMSWOQTInboundService(String CSSJobID,String OrderType,String custCode,String Inshop,String CreateDate,String PromisedDate,String BillType,String ContactName,String CustomerPhone,String SubType,String UnitNumber,String Model,String Make,String ServiceModelName,String EngineFamily,String ESN,String Application,String location,String ContactID,String EmailID,String CreateUser,String ChangeUser){
        system.debug('CustomerPhone****'+CustomerPhone);
        CSS_BMSWOQTInboundJSON2APEX WOQTInboundDetails;
        String endPointURL;
        string message;
        //HttpResponse res1; commented by sravanthi 
        String bmsUsername;
        String bmsPassword;
        //@TestVisible
        String PhoneNumber;
        Boolean bmsWORetry;
        Integer bmsWORetryCount = 1;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        String jsonResponse = '';
        string JSONReq = '';
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        do{
            bmsWORetry = false;
            try{
                Http h1 = new Http();
                HttpRequest req1 = new HttpRequest();
                if(!Test.isRunningTest()){
                    conDetails = CSS_getConnnectionDetails.getConnection('BMSWOQTInbound');          
                    bmsUsername = conDetails.Username__c; 
                    bmsPassword = conDetails.Passcode__c;     
                    //Setting Endpint URL 
                    //endPointURL = conDetails.End_Point__c+'bmsworkorder';
                    endPointURL = conDetails.End_Point__c;
                }
                else
                    endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/services-workorders/workorder';
                //getting Access Token 
                //String access_token = CSS_SRT.receiveToken();
                /*String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
//Setting End Point URL
req1.setEndpoint(endPointURL);*/
                if(SubType == null)
                    SubType = '';
                if(ESN == null)
                    ESN = '';
                if(ServiceModelName == null)
                    ServiceModelName = '';
                if(UnitNumber == null)
                    UnitNumber = '';
                if(EngineFamily == null)
                    EngineFamily = '';
                String distrCode = '';
                String brnchCode = '';
                String[] locArray;
                if(location != null && location != '')
                    locArray = location.split('-');
                if(locArray != null && locArray.size()>0){
                    distrCode = locArray[0];
                    brnchCode = locArray[1];
                }
                //if(Test.isRunningTest())
                //{PhoneNumber = '7777777777';}
                //else
                system.debug('hey CustomerPhone>>>'+CustomerPhone);
                if(string.isNotBlank(CustomerPhone)){
                    PhoneNumber = ((CustomerPhone.remove('(')).remove(')').trim()).replace(' ', '-');
                }
                system.debug('PhoneNumber>>>after>>'+PhoneNumber);
                string SourceType= System.Label.Source_Environment_Type;
                system.debug('SourceType>>>after>>'+SourceType);
                //Building Request Body or request String      
                JSONReq = '{"Header": { "Sender": { "ServiceName": "CreateWorkOrder", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+location+'" } }, "DataArea": { "CSSJobID": "'+CSSJobID+'", "DistributorCode": "'+distrCode+'", "BranchCode": "'+brnchCode+'", "OrderType": "'+OrderType+'", "CustomerNumber": "'+custCode+'", "Inshop": "'+Inshop+'", "CreateDate": "'+CreateDate+'", "PromisedDate": "'+PromisedDate+'","ScheduledDate":"'+PromisedDate+'","BillType": "'+BillType+'", "CustomerName": "'+ContactName+'", "CustomerPhone": "'+PhoneNumber+'","SubType": "'+SubType+'", "UnitNumber": "'+UnitNumber+'", "Model": "'+Model+'", "Make": "'+Make+'", "ServiceModelName": "'+ServiceModelName+'", "EngineFamily": "'+EngineFamily+'", "ESN": "'+ESN+'", "Application": "'+Application+'","ContactID": "'+ContactID+'","EmailId": "'+EmailID+'","CreateUser": "'+CreateUser+'","ChangeUser": "'+ChangeUser+'" ,"Source":"'+SourceType+'"} }';
                
                /*req1.setBody(JSONReq);
System.debug('req1.getBody======'+req1.getBody());
//Sending request and mapping the response
res1 = h1.send(req1);
System.debug('StatusCode>>>>: '+res1.getStatusCode());
system.debug('Response body>>>:'+res1.getbody());
//Setting Reponse to a string*/
                CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
                reqWrapper.jsonReqBody = JSONReq;
                reqWrapper.endPoint = endPointURL;
                reqWrapper.methodType = conDetails.Method_Type__c;
                reqWrapper.serviceName='BMSWOQTInbound';
                //CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                    jsonResponse = returnWrapper.response.getBody();
                //jsonResponse = '{\"Header\":{\"ReturnCodeDescription\":\"Distributor Not Setup\",\"Status\":\"ERROR\",\"Sender\":{\"ServiceName\":\"GetCustomer\",\"SenderID\":\"CSS\"},\"Target\":{\"TargetID\":\"BMS\"},\"Location\":{\"LocationID\":\"Test\"}},\"DataArea\":{\"WOReferenceNumber\":\"1234\"}}'; // Error Response for testing
                //jsonResponse = '{"DataArea":{"ContactID":43795002,"WOReferenceNumber":79803},"Header":{"Status":"SUCCESS","ReturnCodeDescription":"WO reference no 79803 for the customer 43795 has been created successfully in BMS. New Contact ID 43795002 has been Created"}}'; // Success Response
                if(returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201)
                {
                    throw new CSS_CustomException('System is Down' + returnWrapper.response.getStatusCode());
                    
                }
            }catch(Exception ex){
                
                jsonResponse = '{\"Header\":{\"ReturnCodeDescription\":\"Integration to BMS is unavailable at this time, Please try again later.' + 
                    '\",\"Status\":\"SYSTEM\",\"Sender\":{\"ServiceName\":\"GetCustomer\",\"SenderID\":\"CSS\"},\"Target\":{\"TargetID\":\"BMS\"},\"Location\":{\"LocationID\":\"Test\"}},\"DataArea\":{\"WOReferenceNumber\":\"\"}}';
                
                System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
                System.debug('getLineNumber*********************is :: '+ex.getMessage());
                if(!Test.isRunningTest()){
                    message = ex.getMessage(); //System.CalloutException
                    String eType = ex.getTypeName();
                    system.debug('exception message is -->'+ ex.getTypeName());
                    if(message.equalsignorecase('Read timed out') || eType.contains('CalloutException')){
                        bmsWORetryCount = bmsWORetryCount + 1; 
                        bmsWORetry = TRUE;
                        system.debug('retryValue is -->' +bmsWORetryCount);
                        system.debug('reTry flag is -->' +bmsWORetry);                    
                    }
                    
                    
                    if(message.contains('timed out')){
                        //css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOQTInbound Service', 'RESPONSE IS NULL', 'BMS');
                        css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOQTInbound Service', 'RESPONSE IS NULL', 'BMS'+';;'+'+CSSJobID+'); //GSSC - 86, capturing Service JOB
                    }
                    else{
                        //css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOQTInbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
                        css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOQTInbound Service', jsonResponse==null?'RESPONSE IS NULL':jsonResponse, 'BMS'+';;'+'+CSSJobID+');//GSSC - 86, capturing Service JOB
                    }
                }
                
            }
        }while(bmsWORetryCount <= Integer.valueof(Label.CSS_bmsretryServices) && bmsWORetry == TRUE);
        //Deserialize the response from Bms web service respose__c field to the Wrapper Class
        if(Test.isRunningTest())
            jsonResponse='{"DataArea":{"CSSJobID":"","ContactID":0,"WOReferenceNumber":0},"Header":{"Status":"ERROR","ReturnCodeDescription":"Customer number is null,deactivated or does not exist in BMS. Dist-Branch 02930-02434 is not active for CSS integration in BMS. Sub-type is not active or does not exist in BMS."}}';
        WOQTInboundDetails = (CSS_BMSWOQTInboundJSON2APEX)JSON.deserializeStrict(jsonResponse,CSS_BMSWOQTInboundJSON2APEX.class);
        system.debug('WOQTInboundDetails>>>>'+WOQTInboundDetails.Header);
        // system.debug('WOQTInboundDetails.WOReferenceNumber>>>>'+WOQTInboundDetails.DataArea.WOReferenceNumber);
        if((WOQTInboundDetails != null && (WOQTInboundDetails.Header.Status=='ERROR' || WOQTInboundDetails.Header.Status.trim()=='ERROR')) || returnWrapper.response.getStatusCode() != 200){ 
            css_utility.LogOutIntError(endPointURL+'-Request is:'+JSONReq,WOQTInboundDetails.Header.ReturnCodeDescription+'-BMS WOQTInbound Service', jsonResponse==null?'RESPONSE IS NULL':jsonResponse, 'BMS'+';;'+CSSJobID);//GSSC - 86, capturing Service JOB
        }
        return WOQTInboundDetails;
    }
    
    //Method to  call Service History Outbound
    /*@Future(callout=true)
public static void callServiceHistoryOutboundService_Existing(String ESN,String Location){
CSS_ServiceHistoryOutboundJSON2Apex serviceHistoryDetail;
String endPointURL;
string message;
HttpResponse res1;
String bmsUsername;
String bmsPassword;
CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
// Added as part of defect 135552,143130
List<CSS_JobEventTemporary__c> jobEveTemp = new List<CSS_JobEventTemporary__c>([Select Id,Attribute5__c from CSS_JobEventTemporary__c where Attribute5__c!=null and Key__c=:ESN order by lastmodifieddate desc]);
try{
Http h1 = new Http();
HttpRequest req1 = new HttpRequest();
if(!Test.isRunningTest()){
conDetails = CSS_getConnnectionDetails.getConnection('BMS');          
bmsUsername = conDetails.Username__c; 
bmsPassword = conDetails.Passcode__c;     
//Setting Endpint URL 
endPointURL = conDetails.End_Point__c+'bmsservicehistory';
}
else
{
endPointURL = 'https://services-dev.cummins.com/css/bmsservicehistory';
}
//getting Access Token 
//String access_token = CSS_SRT.receiveToken();
String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setEndpoint(endPointURL);

//Building Request Body or request String 
//string JSONReq = '{ "Header":  {"Sender":  { "ServiceName": "GetServHistory", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "02400-02394" } }, "DataArea":  {   "ESN": "79494646" } }';             
string JSONReq = '{ "Header":  {"Sender":  { "ServiceName": "GetServHistory", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea":  {   "ESN": "'+ESN+'" } }';             
req1.setBody(JSONReq);             
System.debug('req1.getBody======'+req1.getBody());

//Sending request and mapping the response 
res1 = h1.send(req1);
System.debug('Status Code >>> :: '+res1.getStatusCode());
system.debug('Response Body >>>'+res1.getbody());

//Setting response to the string 
string jsonResponse;

jsonResponse = res1.getBody();
//Deserialize the response from Bms web service respose__c field to the Wrapper Class 
serviceHistoryDetail = (CSS_ServiceHistoryOutboundJSON2Apex)JSON.deserializeStrict(jsonResponse,CSS_ServiceHistoryOutboundJSON2Apex.class);
system.debug('Service History Detail>>>>'+serviceHistoryDetail.Header +'*************'+serviceHistoryDetail);
//return serviceHistoryDetail;
system.debug('serviceHistoryDetail>>>>>>>>'+serviceHistoryDetail);
// Insert Service History to JobEventTemporary Object(S-63173)
List<CSS_JobEventTemporary__c> lstJobEventTemp = new List<CSS_JobEventTemporary__c>();
CSS_JobEventTemporary__c cjet; 
if(serviceHistoryDetail.DataArea!=null){

for(integer i=0 ;i<serviceHistoryDetail.DataArea.size();i++){
cjet = new CSS_JobEventTemporary__c();
cjet.Name = 'BMS';
cjet.Source__c = 'BMS';
// cjet.Attribute1__c = serviceHistoryDetail.DataArea[i].ProductModel;
// cjet.Key__c = serviceHistoryDetail.DataArea[i].ProductModel;
cjet.Key__c = ESN; // as part Of GSSC -735 - pushed by git 
//cjet.Comp_Location__c = serviceHistoryDetail.DataArea[i].WorkSummaryCAUSE;
cjet.Circuit_Description__c = serviceHistoryDetail.DataArea[i].FaultcodesCORRECTION;
cjet.Attribute2__c = serviceHistoryDetail.DataArea[i].ReceivedDate;
cjet.Reason__c = serviceHistoryDetail.DataArea[i].WorkSummaryCOMPLAINT + ' '+ serviceHistoryDetail.DataArea[i].WorkSummaryCAUSE;
cjet.Attribute9__c = serviceHistoryDetail.DataArea[i].DistanceType;
cjet.Attribute5__c = serviceHistoryDetail.DataArea[i].BMSWOreference;
cjet.Attribute14__c = serviceHistoryDetail.DataArea[i].Distance;
cjet.Attribute3__c = serviceHistoryDetail.DataArea[i].CustomerName;
cjet.Attribute7__c = serviceHistoryDetail.DataArea[i].Location;
cjet.Attribute15__c = serviceHistoryDetail.DataArea[i].BMSLink;
cjet.Attribute6__c = serviceHistoryDetail.DataArea[i].ClaimNumber;
cjet.Attribute10__c = string.valueof(serviceHistoryDetail.DataArea[i].Invoice);



string str2 = serviceHistoryDetail.DataArea[i].ReceivedDate;
string yy = str2.substring(0, 4); 
System.debug('The dd isW!@!'+yy);
string mm = str2.substring(5, 7);
System.debug('The months is@!#@!'+mm);
string dd= str2.substring(8,10);
System.debug('The yy is#@!#!@'+dd);
string hh = str2.substring(11,13);
string min = str2.substring(14,16);
string hhmin= str2.substring(11,16);
System.debug('The hh is@!#!@'+hh);
System.debug('The min is@!#!@'+min);
System.debug('The hhmin is@!#!@'+hhmin);
string stringDate = yy+'-'+mm+'-'+dd+' '+hhmin+':'+0;
datetime gmtTimeConvert = datetime.valueOfGmt(stringDate);
cjet.Attribute13__c = gmtTimeConvert;

// Added as part of defect 135552
if(jobEveTemp.size()>0){
for(CSS_JobEventTemporary__c c: jobEveTemp){
if(c.Attribute5__c!= null && c.Attribute5__c==serviceHistoryDetail.DataArea[i].BMSWOreference){
cjet.Id=c.id;
break;
}

}
}
lstJobEventTemp.add(cjet);
}

}
system.debug('lstJobEventTemp'+lstJobEventTemp);
if(!lstJobEventTemp.isempty()){
upsert lstJobEventTemp;
}
}catch(Exception ex){
System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
System.debug('getLineNumber*********************is :: '+ex.getMessage());
if(!Test.isRunningTest()){
message = ex.getMessage();

if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS ServiceHistoryOutbound Service', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS ServiceHistoryOutbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
}
}

}
//return null;
}*/
    @Future(callout=true)
    public static void callServiceHistoryOutboundService(String ESN,String Location){
        CSS_ServiceHistoryOutboundJSON2Apex serviceHistoryDetail;
        String endPointURL;
        string message;
        HttpResponse res1;
        String bmsUsername;
        String bmsPassword;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        // Added as part of defect 135552,143130
        List<CSS_JobEventTemporary__c> jobEveTemp = new List<CSS_JobEventTemporary__c>([Select Id,Attribute5__c from CSS_JobEventTemporary__c where Attribute5__c!=null and Key__c=:ESN order by lastmodifieddate desc]);
        try{
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('BMSServiceHistory');          
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;     
                //Setting Endpint URL 
                endPointURL = conDetails.End_Point__c;
            }
            else
                endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-services/servicehistory?sender=CSS&target=BMS&locationId=02680-02669&esn=76390321';
            
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            /*String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setEndpoint(endPointURL);

//Building Request Body or request String 
//string JSONReq = '{ "Header":  {"Sender":  { "ServiceName": "GetServHistory", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "02400-02394" } }, "DataArea":  {   "ESN": "79494646" } }';             
string JSONReq = '{ "Header":  {"Sender":  { "ServiceName": "GetServHistory", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea":  {   "ESN": "'+ESN+'" } }';             
req1.setBody(JSONReq);             
System.debug('req1.getBody======'+req1.getBody());*/
            /*CG_OP_OAGWrapper accessTokenOPWrap = CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('BMSCustomer').AuthEnv__c,'BMSCustomer');
String access_token = accessTokenOPWrap.accesstoken;*/ 
            //Mule Integration starts
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.endPoint = endPointURL+'?sender=CSS&target=BMS&locationId='+Location+'&esn='+ESN+'';
            reqWrapper.methodType = 'GET';
            reqWrapper.serviceName='BMSServiceHistory';
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            
            //Sending request and mapping the response 
            //res1 = h1.send(reqWrapper);
            //System.debug('Status Code >>> :: '+res1.getStatusCode());
            //system.debug('Response Body >>>'+res1.getbody());
            
            //Setting response to the string 
            string jsonResponse;
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                jsonResponse = returnWrapper.response.getBody();
            if(Test.isRunningTest()){
                //jsonResponse='{"Header":{"Sender":{"ServiceName": "GetServHistory", "SenderID": "CSS"},"Target": {"TargetID": "BMS"},"Location": {"LocationID": "02680-02669"},"ReturnCodeDescription": "ServiceHistory Data not Found","Status": "ERROR"}}';
                jsonResponse='{ '+
                    '\"Header\": { '+
                    '  \"Status\": \"success\", '+
                    '  \"ReturnCodeDescription\": \"message_ifany\", '+
                    '  \"Location\": { '+
                    '   \"LocationID\": \"02400-02394\" '+
                    '  } '+
                    '}, '+
                    '\"DataArea\": [ '+
                    '  { '+
                    '   \"CustomerName\": \"NYPD\", '+
                    '   \"BMSWOreference\": \"AB23456\", '+
                    '   \"ReceivedDate\": \"2020-03-12 04:05:06\", '+
                    '   \"ProductModel\": \"\", '+
                    '   \"Location\": \"12345-23456\", '+
                    '   \"WorkSummaryCAUSE\": \"1XFFERR2344REWS\", '+
                    '   \"WorkSummaryCOMPLAINT\": \"KENWORTH\", '+
                    '   \"FaultcodesCORRECTION\": \"\", '+
                    '   \"DistanceType\": \"\", '+
                    '   \"Distance\": \"0\", '+
                    '   \"UnitHours\": \"0\", '+
                    '   \"BMSLink\": \"test\" '+
                    '  }, '+
                    '  { '+
                    '   \"CustomerName\": \"NYPD1\", '+
                    '   \"BMSWOreference\": \"AB234561\", '+
                    '   \"ReceivedDate\": \"2020-03-12 04:05:06\", '+
                    '   \"ProductModel\": \"\", '+
                    '   \"Location\": \"12345-23456\", '+
                    '   \"WorkSummaryCAUSE\": \"1XFFERR2344REWS\", '+
                    '   \"WorkSummaryCOMPLAINT\": \"KENWORTH\", '+
                    '   \"FaultcodesCORRECTION\": \"\", '+
                    '   \"DistanceType\": \"\", '+
                    '   \"Distance\": \"0\", '+
                    '   \"UnitHours\": \"0\", '+
                    '   \"BMSLink\": \"test\" '+
                    '  } '+
                    '] '+
                    '}';
                
            }
            system.debug('jsonResponse**'+jsonResponse);
            //Deserialize the response from Bms web service respose__c field to the Wrapper Class 
            serviceHistoryDetail = (CSS_ServiceHistoryOutboundJSON2Apex)JSON.deserializeStrict(jsonResponse,CSS_ServiceHistoryOutboundJSON2Apex.class);
            system.debug('Service History Detail>>>>'+serviceHistoryDetail.Header +'*************'+serviceHistoryDetail);
            //return serviceHistoryDetail;
            system.debug('serviceHistoryDetail>>>>>>>>'+serviceHistoryDetail);
            // Insert Service History to JobEventTemporary Object(S-63173)
            List<CSS_JobEventTemporary__c> lstJobEventTemp = new List<CSS_JobEventTemporary__c>();
            CSS_JobEventTemporary__c cjet; 
            if(serviceHistoryDetail.DataArea!=null){
                
                for(integer i=0 ;i<serviceHistoryDetail.DataArea.size();i++){
                    cjet = new CSS_JobEventTemporary__c();
                    cjet.Name = 'BMS';
                    cjet.Source__c = 'BMS';
                    // cjet.Attribute1__c = serviceHistoryDetail.DataArea[i].ProductModel;
                    // cjet.Key__c = serviceHistoryDetail.DataArea[i].ProductModel;
                    cjet.Key__c = ESN; // as part Of GSSC -735 - pushed by git 
                    //cjet.Comp_Location__c = serviceHistoryDetail.DataArea[i].WorkSummaryCAUSE;
                    cjet.Circuit_Description__c = serviceHistoryDetail.DataArea[i].FaultcodesCORRECTION;
                    cjet.Attribute2__c = serviceHistoryDetail.DataArea[i].ReceivedDate;
                    cjet.Reason__c = serviceHistoryDetail.DataArea[i].WorkSummaryCOMPLAINT + ' '+ serviceHistoryDetail.DataArea[i].WorkSummaryCAUSE;
                    cjet.Attribute9__c = serviceHistoryDetail.DataArea[i].DistanceType;
                    cjet.Attribute5__c = serviceHistoryDetail.DataArea[i].BMSWOreference;
                    cjet.Attribute14__c = serviceHistoryDetail.DataArea[i].Distance;
                    cjet.Attribute3__c = serviceHistoryDetail.DataArea[i].CustomerName;
                    cjet.Attribute7__c = serviceHistoryDetail.DataArea[i].Location;
                    cjet.Attribute15__c = serviceHistoryDetail.DataArea[i].BMSLink;
                    cjet.Attribute6__c = serviceHistoryDetail.DataArea[i].ClaimNumber;
                    cjet.Attribute10__c = string.valueof(serviceHistoryDetail.DataArea[i].Invoice);
                    
                    
                    
                    string str2 = serviceHistoryDetail.DataArea[i].ReceivedDate;
                    string yy = str2.substring(0, 4); 
                    System.debug('The dd isW!@!'+yy);
                    string mm = str2.substring(5, 7);
                    System.debug('The months is@!#@!'+mm);
                    string dd= str2.substring(8,10);
                    System.debug('The yy is#@!#!@'+dd);
                    string hh = str2.substring(11,13);
                    string min = str2.substring(14,16);
                    string hhmin= str2.substring(11,16);
                    System.debug('The hh is@!#!@'+hh);
                    System.debug('The min is@!#!@'+min);
                    System.debug('The hhmin is@!#!@'+hhmin);
                    string stringDate = yy+'-'+mm+'-'+dd+' '+hhmin+':'+0;
                    datetime gmtTimeConvert = datetime.valueOfGmt(stringDate);
                    cjet.Attribute13__c = gmtTimeConvert;
                    
                    // Added as part of defect 135552
                    if(jobEveTemp.size()>0){
                        for(CSS_JobEventTemporary__c c: jobEveTemp){
                            if(c.Attribute5__c!= null && c.Attribute5__c==serviceHistoryDetail.DataArea[i].BMSWOreference){
                                cjet.Id=c.id;
                                break;
                            }
                            
                        }
                    }
                    lstJobEventTemp.add(cjet);
                }
                
            }
            system.debug('lstJobEventTemp'+lstJobEventTemp);
            if(!lstJobEventTemp.isempty()){
                upsert lstJobEventTemp;
            }
        }catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS ServiceHistoryOutbound Service', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS ServiceHistoryOutbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
                }
            }
            
        }
        //return null;
    }
    
    
    //Method to call WOComment Inbound
    /*public static CSS_WOCommentInboundJson2Apex callWOCommentInboundService_Existing(String location,String CSSJobID,String OrderType,String BMSReferenceNumber,String CommentType,String Comment,String CreateUser,String ChangeUser, String CreateDate, String ChangeDate){
CSS_WOCommentInboundJson2Apex commentInboundDetails;
String endPointURL;
string message;
HttpResponse res1;
String bmsUsername;
String bmsPassword;
CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
system.debug('Test >>>>.');
string JSONReq = '';
try{
Http h1 = new Http();
HttpRequest req1 = new HttpRequest();
if(!Test.isRunningTest()){
conDetails = CSS_getConnnectionDetails.getConnection('BMS');          
bmsUsername = conDetails.Username__c; 
bmsPassword = conDetails.Passcode__c;     
//Setting Endpint URL 
endPointURL = conDetails.End_Point__c+'bmsworkordercomments';
system.debug('endPointURL Wo Comment' +  ' ' + endPointURL);
}
else
{
endPointURL = 'https://services-dev.cummins.com/css/bmsworkordercomments';
}
//getting Access Token 
//String access_token = CSS_SRT.receiveToken();
String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setEndpoint(endPointURL);
String distrCode = '';
String brnchCode = '';
String[] locArray;
if(location != null && location != '')
locArray = location.split('-');
if(locArray != null && locArray.size()>0){
distrCode = locArray[0];
brnchCode = locArray[1];
}
if(Comment == null || Comment == '')
Comment = ' ';

//Building Request Body or request String 
JSONReq = '{ "Header": {  "Sender": {   "ServiceName": "SetComment",   "SenderID": "CSS"  },  "Target": {   "TargetID": "BMS"  },  "Location": {   "LocationID": "'+location+'"  } }, "DataArea": {  "CSSJobID": "'+CSSJobID+'",  "DistributorNumber": "'+distrCode+'",  "Branchnumber": "'+brnchCode+'",  "OrderType": "'+OrderType+'",  "BMSReferenceNumber": "'+BMSReferenceNumber+'",  "CommentType": "'+CommentType+'",  "Comment": "'+Comment+'" ,  "CreateUser": "'+CreateUser+'" ,  "CreateDate": "'+CreateDate+'" ,  "ChangeUser": "'+ChangeUser+'" ,  "ChangeDate": "'+ChangeDate+'" }}';             
req1.setBody(JSONReq);             
System.debug('req1.getBody======'+req1.getBody());

//Sending request and mapping the response 
res1 = h1.send(req1);
System.debug('Status Code >>> :: '+res1.getStatusCode());
system.debug('Response Body >>>'+res1.getbody());

//Setting response to the string 
string jsonResponse = res1.getBody();

//Deserialize the response from Bms web service to the Wrapper Class 
//CSS_BMSJ2A bms = (CSS_BMSJ2A)JSON.deserializeStrict(jsonResponse,CSS_BMSJ2A.class);
//system.debug('bms>>>>'+bms.BMSResponse);

//Deserialize the response from Bms web service respose__c field to the Wrapper Class 
commentInboundDetails = (CSS_WOCommentInboundJson2Apex)JSON.deserializeStrict(jsonResponse,CSS_WOCommentInboundJson2Apex.class);
system.debug('WOComment Details >>>>'+commentInboundDetails.Header +'*************'+commentInboundDetails);
if((commentInboundDetails != null && (commentInboundDetails.Header.Status=='ERROR' || commentInboundDetails.Header.Status.trim()=='ERROR')) || res1.getStatusCode() != 200){
css_utility.LogOutIntError(endPointURL+'-Request is:'+JSONReq,commentInboundDetails.Header.ReturnCodeDescription+'-BMS WOQTInbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS'+';;'+CSSJobID);//GSSC - 86, capturing Service JOB
}
return commentInboundDetails;
}catch(Exception ex){
System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
System.debug('getLineNumber*********************is :: '+ex.getMessage());

if(!Test.isRunningTest()){
message = ex.getMessage();

if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOComment Inbound Service', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOComment Inbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
}
}

}
return null;
}*/
    public static CSS_WOCommentInboundJson2Apex callWOCommentInboundService(String location,String CSSJobID,String OrderType,String BMSReferenceNumber,String CommentType,String Comment,String CreateUser,String ChangeUser, String CreateDate, String ChangeDate){
        CSS_WOCommentInboundJson2Apex commentInboundDetails;
        String endPointURL;
        string message;
        HttpResponse res1;
        String bmsUsername;
        String bmsPassword;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        system.debug('Test >>>>.');
        string JSONReq = '';
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        try{
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('BMSWOCommentInbound');          
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;     
                //Setting Endpint URL 
                endPointURL = conDetails.End_Point__c;
                system.debug('endPointURL Wo Comment' +  ' ' + endPointURL);
            }
            else
            {
                endPointURL = 'https://api-ue-devnf3-aw-ex.cummins.com/services-workorders/workorder/comments';
            }
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            String distrCode = '';
            String brnchCode = '';
            String[] locArray;
            if(location != null && location != '')
                locArray = location.split('-');
            if(locArray != null && locArray.size()>0){
                distrCode = locArray[0];
                brnchCode = locArray[1];
            }
            if(Comment == null || Comment == '')
                Comment = ' ';
            
            //Building Request Body or request String 
            JSONReq = '{ "Header": {  "Sender": {   "ServiceName": "SetComment",   "SenderID": "CSS"  },  "Target": {   "TargetID": "BMS"  },  "Location": {   "LocationID": "'+location+'"  } }, "DataArea": {  "CSSJobID": "'+CSSJobID+'",  "DistributorNumber": "'+distrCode+'",  "Branchnumber": "'+brnchCode+'",  "OrderType": "'+OrderType+'",  "BMSReferenceNumber": "'+BMSReferenceNumber+'",  "CommentType": "'+CommentType+'",  "Comment": "'+Comment+'" ,  "CreateUser": "'+CreateUser+'" ,  "CreateDate": "'+CreateDate+'" ,  "ChangeUser": "'+ChangeUser+'" ,  "ChangeDate": "'+ChangeDate+'" }}';             
            /*CG_OP_OAGWrapper accessTokenOPWrap = CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('BMSWOCommentInbound').AuthEnv__c,'BMSCustomer');
String access_token = accessTokenOPWrap.accesstoken;*/
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = JSONReq;
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.serviceName='BMSWOCommentInbound';
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            
            //Setting response to the string 
            string jsonResponse;
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                jsonResponse = returnWrapper.response.getBody();
            
            //Deserialize the response from Bms web service to the Wrapper Class 
            //CSS_BMSJ2A bms = (CSS_BMSJ2A)JSON.deserializeStrict(jsonResponse,CSS_BMSJ2A.class);
            //system.debug('bms>>>>'+bms.BMSResponse);
            if(Test.isRunningTest())
                jsonResponse='{"Header":{"Sender":{"ServiceName":"SetComment","SenderID":"CSS","MessageID":"ed874a57-5ec7-4042-852a-eeb5894a157f"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"CSS job id, Order reference number, Comment type is not sent from CSS for record no.1","Location":{"LocationID":"02680-02669"}}}';
            //Deserialize the response from Bms web service respose__c field to the Wrapper Class 
            commentInboundDetails = (CSS_WOCommentInboundJson2Apex)JSON.deserializeStrict(jsonResponse,CSS_WOCommentInboundJson2Apex.class);
            system.debug('WOComment Details >>>>'+commentInboundDetails.Header +'*************'+commentInboundDetails);
            if((commentInboundDetails != null && (commentInboundDetails.Header.Status=='ERROR' || commentInboundDetails.Header.Status.trim()=='ERROR')) || returnWrapper.response.getStatusCode() != 200){
                css_utility.LogOutIntError(endPointURL+'-Request is:'+JSONReq,commentInboundDetails.Header.ReturnCodeDescription+'-BMS WOQTInbound Service', returnWrapper.response==null?'RESPONSE IS NULL':returnWrapper.response.getBody(), 'BMS'+';;'+CSSJobID);//GSSC - 86, capturing Service JOB
            }
            return commentInboundDetails;
        }catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOComment Inbound Service', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS WOComment Inbound Service', returnWrapper.response==null?'RESPONSE IS NULL':returnWrapper.response.getBody(), 'BMS');
                }
            }
            
        }
        return null;
    }
    
    public class CSS_CustomException extends Exception {}
    
    //Method to call Unit Inbound Service
    public static CSS_unitInboundJSON2Apex callUnitInbound(String custCode,String UnitNumber,String UnitType,String Model,String VIN,String Make,String ServiceModelName,String ESN,String EngineFamily,String ApplicationCode,String location,String distanceType,String distance,String hours,String failureDate,String WarrantyStartDate,String Accesscode){
        String endPointURL;
        string message;
        HttpResponse res1;
        String bmsUsername;
        String bmsPassword;
        Boolean bmsWORetry;
        Integer bmsWORetryCount = 1;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        String  autoAppCodeDistance;//Added by Rajesh Narra for the story Number 182504
        String autoAppCodeDistanceType;//Added by Rajesh Narra for the story Number 182504
        
        List<String> autoMotiveApplicationCodes = new List<String>(); // Added by Rajesh Narra for the story Number 182504
        
        autoMotiveApplicationCodes = System.Label.CSS_Automotive_Application_Codes.split(',');
        
        String jsonResponse = '';
        string JSONReq = '';
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        do{
            try{
                Http h1 = new Http();
                HttpRequest req1 = new HttpRequest();
                if(!Test.isRunningTest()){
                    conDetails = CSS_getConnnectionDetails.getConnection('BMSUnitService');          
                    bmsUsername = conDetails.Username__c; 
                    bmsPassword = conDetails.Passcode__c;     
                    //Setting Endpint URL 
                    //endPointURL = conDetails.End_Point__c+'bmsunit';
                    endPointURL = conDetails.End_Point__c;
                }
                else
                {
                    endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-engine/unit';
                    
                }
                //getting Access Token 
                //String access_token = CSS_SRT.receiveToken();
                /*String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setHeader('Content-Type','application/json');
req1.setMethod('PUT');
req1.setEndpoint(endPointURL); */
                if(UnitNumber == null)
                    UnitNumber = '';
                if(VIN == null || VIN == '')
                    VIN = 'N/A';
                
                //Added the conditional operator logic to accomplish the story number 182504    
                if(autoMotiveApplicationCodes != null && autoMotiveApplicationCodes.size()>0 && autoMotiveApplicationCodes.contains(ApplicationCode) && distance != null && distance != ''){ 
                    autoAppCodeDistance = distance;
                    autoAppCodeDistanceType = distanceType;
                }else{
                    autoAppCodeDistance = '';
                    autoAppCodeDistanceType = '';
                }
                
                JSONReq = '{"Header":{"Sender":{"ServiceName":"UpsertUnitInfo","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"'+location+'"}},"DataArea":{"CustomerCode":"'+custCode+'","UnitNumber":"'+UnitNumber+'","UnitType":"'+UnitType+'","Model":"'+Model+'","VIN":"'+VIN+'","Make":"'+Make+'","ServiceModelName":"'+ServiceModelName+'","ESN":"'+ESN+'","EngineFamily":"'+EngineFamily+'","ApplicationCode":"'+ApplicationCode+'","DistanceType":"'+autoAppCodeDistanceType+'","Distance":"'+autoAppCodeDistance+'","Hours":"'+hours+'","FailureDate":"'+failureDate+'","WarrantyStartDate":"'+WarrantyStartDate+'","Accesscode":"'+Accesscode+'"}}';               
                req1.setBody(JSONReq);
                CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
                reqWrapper.jsonReqBody = JSONReq;
                reqWrapper.endPoint = endPointURL;
                reqWrapper.methodType = conDetails.Method_Type__c;
                reqWrapper.serviceName='BMSUnitService';
                
                returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                
                /*system.debug('CSS_unitInbound JSONReq>>>>>>>>>>>>>>>>>:'+JSONReq);
res1 = h1.send(req1);

System.debug('StatusCode>>>: '+res1.getStatusCode());
system.debug('Response Body:'+res1.getbody());*/
                if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                    jsonResponse = returnWrapper.response.getBody();
                if(returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201)
                {
                    throw new CSS_CustomException('System is Down' + returnWrapper.response.getStatusCode());
                    
                }
                //CSS_BMSJ2A bms = (CSS_BMSJ2A)JSON.deserializeStrict(jsonResponse,CSS_BMSJ2A.class);
                //system.debug('bms>>>>'+bms.BMSResponse);
                
            }catch(Exception ex){
                
                jsonResponse = '{ '+
                    '\"Header\": { '+
                    '  \"Status\": \"SYSTEM\", '+
                    '  \"ReturnCodeDescription\": \"Integration to BMS is unavailable at this time, Please try again later.\", '+
                    '  \"Location\": { \"LocationID\": \"02400-02394\" } '+
                    '}, '+
                    '\"DataArea\": { '+
                    '\"UnitNumber\": \"\" '+
                    '} '+
                    '}';
                
                System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
                System.debug('getLineNumber*********************is :: '+ex.getMessage());
                if(!Test.isRunningTest()){
                    message = ex.getMessage(); //System.CalloutException
                    String eType = ex.getTypeName();
                    system.debug('exception message is -->'+ ex.getTypeName());
                    if(message.equalsignorecase('Read timed out') || eType.contains('CalloutException')){
                        bmsWORetryCount = bmsWORetryCount + 1; 
                        bmsWORetry = TRUE;
                        system.debug('retryValue is -->' +bmsWORetryCount);
                        system.debug('reTry flag is -->' +bmsWORetry);                    
                    }
                    
                    if(message.contains('timed out')){
                        css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS UnitInbound Service', 'RESPONSE IS NULL', 'BMS');
                    }
                    else{
                        css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS UnitInbound Service', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
                        /*ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error Message or any custom message as per requirement.');
ApexPages.addMessage(myMsg);*/
                    }
                }
                
            }  
        }while(bmsWORetryCount <= Integer.valueof(Label.CSS_bmsretryServices) && bmsWORetry == TRUE);    
        if(Test.isRunningTest())
            jsonResponse='{"Header":{"Sender":{"ServiceName":"UpsertUnitInfo","SenderID":"CSS","MessageID":"b3b70396-2d3b-48ce-b164-79131cff4ea4"},"Status":"ERROR","Target":{"TargetID":"BMS"},"ReturnCodeDescription":"Distributor Not Setup","Location":{"LocationID":""}}}';
        system.debug('response after catch  >>'+jsonResponse);
        //return null;
        CSS_unitInboundJSON2Apex UIResp = (CSS_unitInboundJSON2Apex)JSON.deserializeStrict(jsonResponse,CSS_unitInboundJSON2Apex.class);
        system.debug('sj>>>>'+UIResp.Header +'*************'+UIResp.Header.Status);
        system.debug('StatusKal**'+UIResp.Header.Status);
        system.debug('StatusKal**'+UIResp.Header.Status.trim());
        if((UIResp != null && (UIResp.Header.Status=='ERROR' || UIResp.Header.Status.trim() == 'ERROR')) || returnWrapper.response.getStatusCode() != 200){
            system.debug('Inside Error**');
            system.debug('endPointURL**'+endPointURL);
            system.debug('JSONReq**'+JSONReq);
            system.debug('UIResp.Header.ReturnCodeDescription**'+UIResp.Header.ReturnCodeDescription);
            system.debug('returnWrapper**'+returnWrapper);
            //system.debug('.response.getBody()**'+returnWrapper.response.getBody());
            
            if(returnWrapper != null)
                css_utility.LogOutIntError(endPointURL+'-Request is:'+JSONReq,UIResp.Header.ReturnCodeDescription+'-BMS UnitInbound Service', returnWrapper.response==null?'RESPONSE IS NULL':returnWrapper.response.getBody(), 'BMS');//GSSC - 86, capturing Service JOB
        }
        return UIResp;
    }
    // method to call cust inbound
    /*public static CSS_CustomerInboundJSON2APEX  callBMSCustInboundService_Existing(String custName,String custAddr1,String custAddr2,String custAddr3,String AreaCode,String Phone,String city,String state,String postCode,String postalcodesuffix,String cusContact,String countryCd,String lang,String application,string location){
CSS_CustomerInboundJSON2APEX  CustomerInboundRes;
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
conDetails = CSS_getConnnectionDetails.getConnection('BMSCustomer');          
bmsUsername = conDetails.Username__c; 
bmsPassword = conDetails.Passcode__c;     
//Setting Endpint URL 
//endPointURL = conDetails.End_Point__c+'bmscustomer';
//endPointURL = conDetails.End_Point__c+'customers/customer';
endPointURL = conDetails.End_Point__c;
}
else {
//endPointURL = 'https://services-dev.cummins.com/css/bmscustomer';
endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-customers/customer';
}
//getting Access Token 
//String access_token = CSS_SRT.receiveToken();
//String access_token = splreceiveToken(Label.CSS_AltOAuth);
CG_OP_OAGWrapper accessTokenOPWrap = CG_WS_Mule.getAccessToken(CSS_getConnnectionDetails.getConnection('BMSCustomer').AuthEnv__c,'BMSCustomer');
String access_token = accessTokenOPWrap.accessToken;
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setHeader('Content-Type','application/json');
req1.setMethod(conDetails.Method_Type__c);

req1.setEndpoint(endPointURL);  
String distrCode = '';
String brnchCode = '';
String[] locArray;

if(location != null && location != '')
locArray = location.split('-');
if(locArray != null && locArray.size()>0){
distrCode = locArray[0];
brnchCode = locArray[1];
}             

//string JSONReq = '{"Header": { "Sender": { "ServiceName": "CreateCustomer", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "02400-02394" } }, "DataArea": { "CustomerName": "", "CustomerAddressline1": "", "CustomerAddressline2": "", "CustomerAddressline3": "", "City": "", "State": "", "Postalcode": "", "Postalcodesuffix": "", "CustomerContact": "", "DistributorBranchcode": "", "CountryCode": "", "Language": "", "Application": ""} }';
string JSONReq = '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"'+location+'"}},"DataArea":{"CustomerName":"'+custName+'","CustomerAddressline1":"'+custAddr1+'","CustomerAddressline2":"'+custAddr2+'","CustomerAddressline3":"'+custAddr3+'","AreaCode":"'+AreaCode+'","Phone":"'+Phone+'","City":"'+city+'","State":"'+state+'","PostalCode":"'+postCode+'","PostalCodeSuffix":"'+postalcodesuffix+'","CustomerContact":"'+cusContact+'","BranchCode":"'+brnchCode+'","CountryCode":"'+countryCd+'","Language":"'+lang+'","Application":"'+application+'"}}';
// string JSONReq = '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"56270"}},"DataArea":{"CustomerName":"MyTestCSS Customer ","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"Gyan","PostalCodeSuffix":"","CustomerContact":"Test1 Test2","BranchCode":"56270","CountryCode":"CA","Language":"en","Application":"AUTO"}}';
req1.setBody(JSONReq);

System.debug('request.getBody======'+endPointURL );
System.debug('request.getBody*******'+JSONReq);

res1 = h1.send(req1);
System.debug('%%%%-----OAutAuthURL :: '+endPointURL );
System.debug('%%%%%%%%%%%res1 getStatusCode is :: '+res1.getStatusCode());
system.debug('######################################RESPONSE_BODY:'+res1.getbody());
system.debug('&&&&&&&&&&&&res1:'+res1.getBody());
jsonResponse = res1.getBody();

if(res1.getStatusCode()!=200 && res1.getStatusCode()!=201)
{
throw new CSS_CustomException('System is Down' + res1.getStatusCode());
}

// CSS_BMSJ2A bms = (CSS_BMSJ2A)JSON.deserializeStrict(jsonResponse,CSS_BMSJ2A.class);
//system.debug('bms>>>>'+bms.BMSResponse);

}catch(Exception ex){

jsonResponse = '{"Header\": { "ReturnCodeDescription\": \"'+ system.label.CSS_BMSAccount_Errormsg+ '\", \"Status\": \"SYSTEM\",\"Sender\":    { \"ServiceName\": \"CreateCustomer\",      \"MessageID\": \"856733ee-b73d-4125-9ad9-e0d52b68be71\",  \"SenderID\": \"CSS\"   }, \"Target\": {\"TargetID\": \"BMS\"},  \"Location\": {\"LocationID\": \"56270-56251\"}}}';
System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
System.debug('getLineNumber*********************is :: '+ex.getMessage());
if(!Test.isRunningTest()){
message = ex.getMessage();

if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMSCust InboundService', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMSCust InboundService', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
}
}

}
CustomerInboundRes = (CSS_CustomerInboundJSON2APEX )JSON.deserializeStrict(jsonResponse,CSS_CustomerInboundJSON2APEX.class);
system.debug('sj>>>>'+CustomerInboundRes.Header +'*************'+CustomerInboundRes );
return CustomerInboundRes;

//return Null;     
}*/
    public static CSS_CustomerInboundJSON2APEX  callBMSCustInboundService(String custName,String custAddr1,String custAddr2,String custAddr3,String AreaCode,String Phone,String city,String state,String postCode,String postalcodesuffix,String cusContact,String countryCd,String lang,String application,string location){
        CSS_CustomerInboundJSON2APEX  CustomerInboundRes;
        String endPointURL;
        string message;
        HttpResponse res1;
        String bmsUsername;
        String bmsPassword;
        string jsonResponse;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        try{
            String distrCode = '';
            String brnchCode = '';
            String[] locArray;
            String JSONReq = '';
            
            if(location != null && location != '')
                locArray = location.split('-');
            if(locArray != null && locArray.size()>0){
                distrCode = locArray[0];
                brnchCode = locArray[1];
            }             
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('BMSCustomer');          
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;     
                //Setting Endpint URL 
                //endPointURL = conDetails.End_Point__c+'bmscustomer';
                //endPointURL = conDetails.End_Point__c+'customers/customer';
                endPointURL = conDetails.End_Point__c;
                JSONReq = '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"'+location+'"}},"DataArea":{"CustomerName":"'+custName+'","CustomerAddressline1":"'+custAddr1+'","CustomerAddressline2":"'+custAddr2+'","CustomerAddressline3":"'+custAddr3+'","AreaCode":"'+AreaCode+'","Phone":"'+Phone+'","City":"'+city+'","State":"'+state+'","PostalCode":"'+postCode+'","PostalCodeSuffix":"'+postalcodesuffix+'","CustomerContact":"'+cusContact+'","BranchCode":"'+brnchCode+'","CountryCode":"'+countryCd+'","Language":"'+lang+'","Application":"'+application+'"}}';

            }
            else {
                //endPointURL = 'https://services-dev.cummins.com/css/bmscustomer';
                endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-customers/customer';
                conDetails = CSS_getConnnectionDetails.getConnection('BMSCustomer');          
                JSONReq =  '{"Header":{"Sender":{"ServiceName":"CreateCustomer","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"04959-04966"}},"DataArea":{"CustomerName":"MyTestCSS Customer ","CustomerAddressline1":"Columbus1","CustomerAddressline2":"Columbus2","CustomerAddressline3":"Columbus3","AreaCode":"812","Phone":"2342344","City":"Columbus","State":"IN","PostalCode":"Gyan","PostalCodeSuffix":"","CustomerContact":"Test1 Test2","BranchCode":"04966","CountryCode":"CA","Language":"en","Application":"AUTO"}}';
            }
            
            
            req1.setBody(JSONReq);
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = JSONReq;
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = conDetails.Method_Type__c;
            reqWrapper.serviceName='BMSCustomer';
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                system.debug('****Vijay **** 1 ** '+returnWrapper.response.getBody());
            jsonResponse = returnWrapper.response.getBody();
            
            if(returnWrapper.response.getStatusCode()!=200 && returnWrapper.response.getStatusCode()!=201)
            {
                throw new CSS_CustomException('System is Down' + returnWrapper.response.getStatusCode());
            }
            
            // CSS_BMSJ2A bms = (CSS_BMSJ2A)JSON.deserializeStrict(jsonResponse,CSS_BMSJ2A.class);
            //system.debug('bms>>>>'+bms.BMSResponse);
            
        }catch(Exception ex){
            
            jsonResponse = '{"Header\": { "ReturnCodeDescription\": \"'+ system.label.CSS_BMSAccount_Errormsg+ '\", \"Status\": \"SYSTEM\",\"Sender\":    { \"ServiceName\": \"CreateCustomer\",      \"MessageID\": \"856733ee-b73d-4125-9ad9-e0d52b68be71\",  \"SenderID\": \"CSS\"   }, \"Target\": {\"TargetID\": \"BMS\"},  \"Location\": {\"LocationID\": \"56270-56251\"}}}';
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMSCust InboundService', 'RESPONSE IS NULL', 'BMSCustomer');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMSCust InboundService', returnWrapper==null?'RESPONSE IS NULL':returnWrapper.response.getBody(), 'BMSCustomer');
                }
            }
            
        }
        system.debug('******Vijay******  '+jsonResponse);
        CustomerInboundRes = (CSS_CustomerInboundJSON2APEX )JSON.deserializeStrict(jsonResponse,CSS_CustomerInboundJSON2APEX.class);
        system.debug('sj>>>>'+CustomerInboundRes.Header +'*************'+CustomerInboundRes );
        return CustomerInboundRes;
        
        //return Null;     
    }
    // method to call QT Account inbound  
    
    /*public static CSS_BMSQTAcceptInboundJSON2APEX callBMSQTAccInboundService_Existing(String Location,String JobId,String BMSRefNum,String Status,String declineRsn,String PurchaseOrderNum){

CSS_BMSQTAcceptInboundJSON2APEX BMSQTAcceptanceInboundServiceResp;
String endPointURL;
string message;
HttpResponse res1;
String bmsUsername;
String bmsPassword;
CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();

try{
Http h1 = new Http();
HttpRequest req1 = new HttpRequest();
if(!Test.isRunningTest()){
conDetails = CSS_getConnnectionDetails.getConnection('BMS');          
bmsUsername = conDetails.Username__c; 
bmsPassword = conDetails.Passcode__c;     
//Setting Endpint URL 
endPointURL = conDetails.End_Point__c+'bmsquoteacceptance';
}
else {
endPointURL = 'https://services-dev.cummins.com/css/bmsquoteacceptance';
}
//getting Access Token 
//String access_token = CSS_SRT.receiveToken();
String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setEndpoint(endPointURL);
//req1.setBody('Test'); 
String distrCode = '';
String brnchCode = '';
String[] locArray; 
if(Location != null || Location!='')
locArray=Location.split('-');
if(locArray!=null && locArray.size()>0){
distrCode = locArray[0];
brnchCode = locArray[1];
}
datetime currentDate = System.now();
string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';
Id userId = UserInfo.getUserId();
User usr = css_utility.getUserAttributes(userId);
string User= usr.FederationIdentifier;

string JSONReq = '{ "Header": { "Sender": { "ServiceName": "SetQuoteInfo", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "CSSJobID": "'+JobId+'", "DistributorCode": "'+distrCode+'", "BranchCode": "'+brnchCode+'", "OrderType": "WOQT", "BMSReferenceNumber": "'+BMSRefNum+'", "QuoteStatus": "'+Status+'", "Rejectionreason": "'+declineRsn+'", "PromisedDate": "'+currDate+'", "QuoteCompletedby": "'+User+'",   "QuoteCompletedDate": "'+currDate+'", "PONumber": "'+PurchaseOrderNum+'", "UserId": "'+User+'" } }'    ;
//string JSONString = JSON.serialize(attachmentList);
req1.setBody(JSONReq);
System.debug('req1.getBody======'+req1.getBody());

res1 = h1.send(req1);
System.debug('%%%%%%%%%%%res1 getStatusCode is :: '+res1.getStatusCode());
system.debug('######################################RESPONSE_BODY:'+res1.getbody());
system.debug('&&&&&&&&&&&&res1:'+res1.getBody());
string jsonResponse = res1.getBody();
BMSQTAcceptanceInboundServiceResp = (CSS_BMSQTAcceptInboundJSON2APEX)JSON.deserializeStrict(jsonResponse,CSS_BMSQTAcceptInboundJSON2APEX.class);
system.debug('BMSQTAcceptanceInboundServiceResp>>>>'+BMSQTAcceptanceInboundServiceResp.Header +'*************'+BMSQTAcceptanceInboundServiceResp);
return BMSQTAcceptanceInboundServiceResp;
}catch(Exception ex){
System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
System.debug('getLineNumber*********************is :: '+ex.getMessage());

if(!Test.isRunningTest()){
message = ex.getMessage();

if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMSQTAcc InboundService', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMSQTAcc InboundService', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
}
}  
}
return Null; 
}*/
    
    public static CSS_BMSQTAcceptInboundJSON2APEX callBMSQTAccInboundService(String Location,String JobId,String BMSRefNum,String Status,String declineRsn,String PurchaseOrderNum){
        
        CSS_BMSQTAcceptInboundJSON2APEX BMSQTAcceptanceInboundServiceResp;
        String endPointURL;
        string message;
        HttpResponse res1;
        String bmsUsername;
        String bmsPassword;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        
        try{
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('CG_BMSQuoteAcceptance');          
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;     
                //Setting Endpint URL 
                endPointURL = conDetails.End_Point__c;
            }
            else {
                endPointURL = 'https://api-ue-devnf3-aw-ex.cummins.com/cmi/quotes/v1/acceptance';
                
            }
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            /*String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req1.setHeader('Authorization','Bearer '+access_token);
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setEndpoint(endPointURL);*/
            //req1.setBody('Test'); 
            String distrCode = '';
            String brnchCode = '';
            String[] locArray; 
            if(Location != null || Location!='')
                locArray=Location.split('-');
            if(locArray!=null && locArray.size()>0){
                distrCode = locArray[0];
                brnchCode = locArray[1];
            }
            datetime currentDate = System.now();
            string currDate = currentDate.format('YYYY-MM-dd') +'T00:00:00';
            Id userId = UserInfo.getUserId();
            User usr = css_utility.getUserAttributes(userId);
            string User= usr.FederationIdentifier;
            
            string JSONReq = '{ "Header": { "Sender": { "ServiceName": "SetQuoteInfo", "SenderID": "CSS" }, "Target": { "TargetID": "BMS" }, "Location": { "LocationID": "'+Location+'" } }, "DataArea": { "CSSJobID": "'+JobId+'", "DistributorCode": "'+distrCode+'", "BranchCode": "'+brnchCode+'", "OrderType": "WOQT", "BMSReferenceNumber": "'+BMSRefNum+'", "QuoteStatus": "'+Status+'", "Rejectionreason": "'+declineRsn+'", "PromisedDate": "'+currDate+'", "QuoteCompletedby": "'+User+'",   "QuoteCompletedDate": "'+currDate+'", "PONumber": "'+PurchaseOrderNum+'", "UserId": "'+User+'" } }'    ;
            //string JSONString = JSON.serialize(attachmentList);
            /*req1.setBody(JSONReq);
System.debug('req1.getBody======'+req1.getBody());

res1 = h1.send(req1);*/
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = CSS_getConnnectionDetails.getConnection('CG_BMSQuoteAcceptance').Method_Type__c;          
            reqWrapper.serviceName='CG_BMSQuoteAcceptance';
            reqWrapper.jsonReqBody=JSONReq;
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            System.debug('%%%%%%%%%%%res1 getStatusCode is :: '+returnWrapper.response.getStatusCode());
            system.debug('######################################RESPONSE_BODY:'+returnWrapper.response.getbody());
            string jsonResponse = returnWrapper.response.getBody();
            BMSQTAcceptanceInboundServiceResp = (CSS_BMSQTAcceptInboundJSON2APEX)JSON.deserializeStrict(jsonResponse,CSS_BMSQTAcceptInboundJSON2APEX.class);
            system.debug('BMSQTAcceptanceInboundServiceResp>>>>'+BMSQTAcceptanceInboundServiceResp.Header +'*************'+BMSQTAcceptanceInboundServiceResp);
            return BMSQTAcceptanceInboundServiceResp;
        }catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMSQTAcc InboundService', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMSQTAcc InboundService', returnWrapper==null?'RESPONSE IS NULL':returnWrapper.response.getBody(), 'BMS');
                }
            }  
        }
        return Null; 
    }
    public static CSS_jobPlanInboundJSON2Apex callJobPlanInboundService(CSS_BMS_SRTReq req){
        String endPointURL;
        string message;
        HttpResponse res1;
        String bmsUsername;
        String bmsPassword;
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        CSS_jobPlanInboundJSON2Apex jobPlanResp = new CSS_jobPlanInboundJSON2Apex();
        
        try{
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            if(!Test.isRunningTest()){
                conDetails = CSS_getConnnectionDetails.getConnection('BMS');          
                bmsUsername = conDetails.Username__c; 
                bmsPassword = conDetails.Passcode__c;     
                //Setting Endpint URL 
                endPointURL = conDetails.End_Point__c+'bmsjobplan';
                //endPointURL = conDetails.End_Point__c;
                
            }
            else {
                endPointURL = 'https://services-dev.cummins.com/css/bmsjobplan';
            }
            //getting Access Token 
            //String access_token = CSS_SRT.receiveToken();
            String access_token = splreceiveToken(Label.CSS_AltOAuth);
            system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
            req1.setHeader('Authorization','Bearer '+access_token);
            req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
            req1.setHeader('Content-Type','application/json');
            req1.setMethod('POST');
            req1.setEndpoint(endPointURL);      
            //string JSONReq = '{"Header": { "Sender": { "ServiceName": "SetJobPlan", "SenderID": "CSS" },"Target": { "TargetID": "BMS" }, "Location": { "LocationID": "02400-02394" } }, "DataArea":  {   "CSSJobID": "" , "Location": "" , "OrderType": "",  "ShopWOnumber": "",  "Accesscode": "",  "Model": "", "SRT":[ {"SRTgroupnum": "",  "Procedureno": "",  "Stepnumber": "", "SRTquantity": "","Bill": "","Time1": ""}] }}';            
            String JSONReq = CSS_BMS_SRTReq.parse(req);
            
            system.debug('JSONReq----<' + JSONReq);
            req1.setBody(JSONReq);
            
            res1 = h1.send(req1);
            System.debug('%%%%%%%%%%%res1 getStatusCode is :: '+res1.getStatusCode());
            system.debug('######################################RESPONSE_BODY:'+res1.getbody());
            system.debug('&&&&&&&&&&&&res1:'+res1.getBody());
            string jsonResponse = res1.getBody();
            responseMsg = res1.getBody();
            jobPlanResp = (CSS_jobPlanInboundJSON2Apex)JSON.deserializeStrict(jsonResponse,CSS_jobPlanInboundJSON2Apex.class);
            system.debug('jobPlanResp>>>>'+jobPlanResp.Header +'*************'+jobPlanResp);
        }catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-JobPlan InboundService', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-JobPlan InboundService', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
                }
            }
        }
        return jobPlanResp;
        
    }
    /*public static CSS_getPartsListBMSResponseJ2A sendGSQParts_Existing(CSS_getPartsListBMSRequestJ2A sendGSQPartsReq){
CSS_getPartsListBMSResponseJ2A sendGSQPartsRes;
String message;
String endPointURL;
HttpResponse res1;
//getting Access Token 
//String access_token = CSS_SRT.receiveToken();
String access_token = splreceiveToken(Label.CSS_AltOAuth);//Label.CSS_AltOAuth OAGOAuthDev
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);
system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+sendGSQPartsReq);
try
{
Http h1 = new Http();
HttpRequest req1 = new HttpRequest();

if(!Test.isRunningTest()){
endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_BMS_SENDPARTS').End_Point__c;

}else{
endPointURL = 'https://services-dev.cummins.com/csswarranty/'; }

req1.setHeader('Authorization','Bearer '+access_token);
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setEndpoint(endPointURL);

String reqWrpperInput = JSON.serialize(sendGSQPartsReq);
req1.setBody(reqWrpperInput);              
System.debug('req1.getBody======'+req1.getBody());
String jsonResponseBody;
res1 = h1.send(req1);
jsonResponseBody=res1.getBody();

//Sending request and mapping the response 

//de-serializing the response and mapping it to wrapper class
sendGSQPartsRes= (CSS_getPartsListBMSResponseJ2A )JSON.deserialize(jsonResponseBody,CSS_getPartsListBMSResponseJ2A.class);
System.debug('Status Code >>> :: '+res1.getStatusCode());
System.debug('REST response is :: '+res1);
system.debug('Response Body >>>'+res1.getbody());
}
catch(Exception ex){
System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
System.debug('getLineNumber*********************is :: '+ex.getMessage());
if(!Test.isRunningTest()){
message = ex.getMessage();

if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- SendGSQPartsRes', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- SendGSQPartsRes', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
}
}
}
return sendGSQPartsRes;
}*/
    public static CSS_getPartsListBMSResponseJ2A sendGSQParts(CSS_getPartsListBMSRequestJ2A sendGSQPartsReq){
        CSS_getPartsListBMSResponseJ2A sendGSQPartsRes;
        String message;
        String endPointURL;
        HttpResponse res1;
        //getting Access Token 
        //String access_token = CSS_SRT.receiveToken();
        /*String access_token = splreceiveToken(Label.CSS_AltOAuth);//Label.CSS_AltOAuth OAGOAuthDev
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);*/
        system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+sendGSQPartsReq);
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        try
        {
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            
            if(!Test.isRunningTest()){
                endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_BMS_SENDPARTS').End_Point__c;
                
            }else{
                endPointURL = 'https://services-dev.cummins.com/csswarranty/'; }
            
            /*req1.setHeader('Authorization','Bearer '+access_token);
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setEndpoint(endPointURL);*/
            
            String reqWrpperInput = JSON.serialize(sendGSQPartsReq);
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = reqWrpperInput;
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = CSS_getConnnectionDetails.getConnection('CSS_BMS_SENDPARTS').Method_Type__c;
            reqWrapper.serviceName='CSS_BMS_SENDPARTS';
            
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            String jsonResponseBody;
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                jsonResponseBody=returnWrapper.response.getBody();
            
            //Sending request and mapping the response 
            
            //de-serializing the response and mapping it to wrapper class
            sendGSQPartsRes= (CSS_getPartsListBMSResponseJ2A )JSON.deserialize(jsonResponseBody,CSS_getPartsListBMSResponseJ2A.class);
            System.debug('Status Code >>> :: '+returnWrapper.response.getStatusCode());
            System.debug('REST response is :: '+returnWrapper);
            system.debug('Response Body >>>'+returnWrapper.response.getbody());
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- SendGSQPartsRes', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- SendGSQPartsRes', returnWrapper==null?'RESPONSE IS NULL':returnWrapper.response.getBody(), 'BMS');
                }
            }
        }
        return sendGSQPartsRes;
    }
    public string jsonResponseBody ='';
    //Method to call web service and get response    
    /* public void getSubTypesUnitTypesService_Existing(string strLoc){
CSS_GetSubTypUnitTypResJ2A  SubTypeDetails;
string endPointURL;
HttpResponse res;
string message;
//getting Access Token 
//String access_token = CSS_SRT.receiveToken();
String access_token = splreceiveToken(Label.CSS_AltOAuth);
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);
try{ 
Http h1 = new Http();
HttpRequest req = new HttpRequest();

if(!Test.isRunningTest()){
endPointURL =  CSS_getConnnectionDetails.getConnection('BMS_UNITTYPE').End_Point__c; 
}else{
endPointURL = 'https://services-dev.cummins.com/csswarranty/bmssubtype';
}

//String endPointURL = 'https://services-dev.cummins.com/csswarranty/bmssubtype';
system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req.setHeader('Authorization','Bearer '+access_token);
req.setHeader('Content-Type','application/json');
req.setMethod('POST');
req.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req.setEndpoint(endPointURL);

string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetSubTypeUnitType","SenderID": "CSS"},"Target": { "TargetID": "BMS"},"Location": {"LocationID": "'+strLoc+'"}}}';
req.setBody(JSONReq);

System.debug('req1.getBody======'+req.getBody());
//Sending request and mapping the response 
res = h1.send(req);
System.debug('Status Code >>> :: '+res.getStatusCode());
system.debug('Response Body >>>'+res.getbody());

// String jsonResponseBody=res.getBody();
jsonResponseBody=res.getBody();
//de-serializing the response and mapping it to wrapper class
SubTypeDetails = (CSS_GetSubTypUnitTypResJ2A)JSON.deserialize(jsonResponseBody,CSS_GetSubTypUnitTypResJ2A.class);
System.debug('JSON Response  >>> :: '+jsonResponseBody);
System.debug('Response  >>> :: '+SubTypeDetails);
System.debug('Status Code >>> :: '+res.getStatusCode());
System.debug('REST response is :: '+res);

}
catch(Exception ex){
System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
System.debug('getLineNumber*********************is :: '+ex.getMessage());
if(!Test.isRunningTest()){
message = ex.getMessage();

if(message.contains('timed out')){
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS UnitType', 'RESPONSE IS NULL', 'BMS');
}
else{
css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS UnitType', res==null?'RESPONSE IS NULL':res.getBody(), 'BMS');
}
}

}   
//return SubTypeDetails;
insertJobEvent(SubTypeDetails);
}*/
    public void getSubTypesUnitTypesService(string strLoc){
        CSS_GetSubTypUnitTypResJ2A  SubTypeDetails;
        string endPointURL;
        HttpResponse res;
        string message;
        //getting Access Token 
        //String access_token = CSS_SRT.receiveToken();
        try{ 
            Http h1 = new Http();
            HttpRequest req = new HttpRequest();
            
            if(!Test.isRunningTest()){
                endPointURL =  CSS_getConnnectionDetails.getConnection('BMS_UNITTYPE').End_Point__c; 
            }else{
                endPointURL = 'https://api-ue-devnf3-aw-ex.cummins.com/services-workorders/workorder/subtype?ServiceName=GetSubTypeUnitType&SenderID=CSS&TargetID=BMS&LocationID=56270-56255';
            }
            
            //String endPointURL = 'https://services-dev.cummins.com/csswarranty/bmssubtype';
            /*system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);                
req.setHeader('Authorization','Bearer '+access_token);
req.setHeader('Content-Type','application/json');
req.setMethod('POST');
req.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req.setEndpoint(endPointURL);*/
            
            //string JSONReq = '{"Header": {"Sender": {"ServiceName": "GetSubTypeUnitType","SenderID": "CSS"},"Target": { "TargetID": "BMS"},"Location": {"LocationID": "'+strLoc+'"}}}';
            /* req.setBody(JSONReq);

System.debug('req1.getBody======'+req.getBody());
//Sending request and mapping the response 
res = h1.send(req);
System.debug('Status Code >>> :: '+res.getStatusCode());
system.debug('Response Body >>>'+res.getbody());*/
            
            String jsonResponseBody;
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            
            reqWrapper.endPoint = endPointURL+'?ServiceName=GetSubTypeUnitType&SenderID=CSS&TargetID=BMS&LocationID='+strLoc+'';
            reqWrapper.methodType = CSS_getConnnectionDetails.getConnection('BMS_UNITTYPE').Method_Type__c;
            reqWrapper.serviceName='BMS_UNITTYPE';
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                jsonResponseBody = returnWrapper.response.getBody();
            
            //de-serializing the response and mapping it to wrapper class
            SubTypeDetails = (CSS_GetSubTypUnitTypResJ2A)JSON.deserialize(jsonResponseBody,CSS_GetSubTypUnitTypResJ2A.class);
            System.debug('JSON Response  >>> :: '+jsonResponseBody);
            System.debug('Response  >>> :: '+SubTypeDetails);
            
            
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS UnitType', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'-BMS UnitType', res==null?'RESPONSE IS NULL':res.getBody(), 'BMS');
                }
            }
            
        }   
        //return SubTypeDetails;
        insertJobEvent(SubTypeDetails);
    }
    
    //Method to insert records to CSS_JobEventTemporary__c after getting response from web service. 
    public void insertJobEvent(CSS_GetSubTypUnitTypResJ2A  Result){
        //Variable Declaration
        string SubTypeString='';
        string UnitTypesString='';
        string SalesSegmentString='';
        map<string, string> subTypeList = new map<string, string>();
        map<string, string> salesSegmentList = new map<string, string>();
        map<string, string> unitTypeList = new map<string, string>();
        map<string, string> claimTypeList = new map<string, string>();
        map<string, string> woqtRejectionReasonList = new map<string, string>();
        
        try{
            if(Result !=Null && Result.DataArea !=Null){
                //Put result into proper string
                for(integer i=0;i<(Result.DataArea).size();i++){            
                    //               if(Result.DataArea[i].Code == 'SUBTYPE' ||Result.DataArea[i].Code == 'SUBTYPE_INT'){
                    if(Result.DataArea[i].Code == 'SUBTYPE'){
                        
                        subTypeList.put(Result.DataArea[i].CodeValue, Result.DataArea[i].CodeDescription);
                        
                    }             
                    
                    if(Result.DataArea[i].Code == 'SALES_SEGMENT'){
                        
                        salesSegmentList.put(Result.DataArea[i].CodeValue, Result.DataArea[i].CodeDescription);
                    }      
                    
                    if(Result.DataArea[i].Code == 'UNIT_TYPE'){
                        
                        unitTypeList.put(Result.DataArea[i].CodeValue, Result.DataArea[i].CodeDescription);
                    }
                    if(Result.DataArea[i].Code == 'CLAIM_TYPE'){
                        
                        claimTypeList.put(Result.DataArea[i].CodeValue, Result.DataArea[i].CodeDescription);
                        
                    }
                    if(Result.DataArea[i].Code == 'WOQT_rejection_reasons'){
                        
                        woqtRejectionReasonList.put(Result.DataArea[i].CodeValue, Result.DataArea[i].CodeDescription);
                        
                    }
                }
                
                system.debug('Result>>>>SubType and SubTypeInt: '+ JSON.serialize(subTypeList));
                system.debug('Result>>>>UnitTypes: '+ JSON.serialize(unitTypeList));
                system.debug('Result>>>>SalesSegment: '+ JSON.serialize(SalesSegmentList));
                
                List<CSS_JobEventTemporary__c> jobEventList= new List<CSS_JobEventTemporary__c>();
                
                List<CSS_JobEventTemporary__c> jobEventDelList= [select id from CSS_JobEventTemporary__c where Key__c=:Result.Header.Location.LocationID];
                if (jobEventDelList.size()==0){
                    CSS_JobEventTemporary__c Record= new CSS_JobEventTemporary__c();
                    //Record.Reason__c=SubTypeString;
                    Record.Reason__c=JSON.serialize(subTypeList);
                    Record.Key__c=Result.Header.Location.LocationID;
                    Record.ExpireDateTime__c= Date.today()+1;
                    Record.Name=Result.Header.Location.LocationID + 'SubType';
                    Record.Attribute1__c='SubType';  
                    jobEventList.add(Record);
                    
                    CSS_JobEventTemporary__c Record2= new CSS_JobEventTemporary__c();
                    Record2.Reason__c=JSON.serialize(unitTypeList); //UnitTypesString;
                    Record2.Key__c=Result.Header.Location.LocationID;
                    Record2.ExpireDateTime__c= Date.today()+1;
                    Record2.Name=Result.Header.Location.LocationID+'UnitTypes';
                    Record2.Attribute1__c='UnitTypes';
                    jobEventList.add(Record2);
                    
                    CSS_JobEventTemporary__c Record3= new CSS_JobEventTemporary__c();
                    Record3.Reason__c=JSON.serialize(SalesSegmentList); //SalesSegmentString;
                    Record3.Key__c=Result.Header.Location.LocationID;
                    Record3.ExpireDateTime__c= Date.today()+1;
                    Record3.Name=Result.Header.Location.LocationID+'SalesSegment'; 
                    Record3.Attribute1__c='SalesSegment';
                    jobEventList.add(Record3);
                    
                    CSS_JobEventTemporary__c Record4= new CSS_JobEventTemporary__c();
                    Record4.Reason__c=JSON.serialize(claimTypeList); 
                    Record4.Key__c=Result.Header.Location.LocationID;
                    Record4.ExpireDateTime__c= Date.today()+1;
                    Record4.Name=Result.Header.Location.LocationID+'ClaimType'; 
                    Record4.Attribute1__c='ClaimType';
                    jobEventList.add(Record4);
                    
                    CSS_JobEventTemporary__c Record5= new CSS_JobEventTemporary__c();
                    Record5.Reason__c=JSON.serialize(woqtRejectionReasonList); 
                    Record5.Key__c=Result.Header.Location.LocationID;
                    Record5.ExpireDateTime__c= Date.today()+1;
                    Record5.Name=Result.Header.Location.LocationID+'WOQTRejectionReason'; 
                    Record5.Attribute1__c='WOQTRejectionReason';
                    jobEventList.add(Record5);     
                    
                    system.debug('jobEventList-->'+ jobEventList);   
                    insert jobEventList; 
                }
            }
        }catch(DmlException e) {
            System.debug('getLineNumber*********************is :: '+e.getLineNumber());
            System.debug('getLineNumber*********************is :: '+e.getMessage());
        }     
    }
    
    public static CG_ReqPDFInbound_Resp reqPDFInbound(CG_ReqPDFInbound_Req reqPDFInboundReq){
        CG_ReqPDFInbound_Resp reqPDFInboundRes;
        String message;
        String endPointURL;
        HttpResponse res1;
        //getting Access Token 
        //String access_token = splreceiveToken(Label.CSS_AltOAuth);
        //Commented 1225 line by Rajesh Narra
        //String access_token = splreceiveToken('OAGOAuthStg');
        //system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);
        system.debug('SBL$$$$$$$$@@@@@@@@@@:::'+reqPDFInboundReq);
        try
        {
            Http h1 = new Http();
            HttpRequest req1 = new HttpRequest();
            
            if(!Test.isRunningTest()){
                endPointURL =  CSS_getConnnectionDetails.getConnection('CSS_BMS_RequestPDF').End_Point__c;
                
            }else{
                // endPointURL = 'https://services-dev.cummins.com/csswarranty/bmsrequestpdf/'; 
                endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/jobs/requestpdf';
            }
            
            /*req1.setHeader('Authorization','Bearer '+access_token);
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setEndpoint(endPointURL);*/
            
            String reqWrpperInput = JSON.serialize(reqPDFInboundReq);
            req1.setBody(reqWrpperInput);              
            System.debug('req1.getBody======'+req1.getBody());
            CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
            reqWrapper.jsonReqBody = reqWrpperInput;
            reqWrapper.endPoint = endPointURL;
            reqWrapper.methodType = CSS_getConnnectionDetails.getConnection('CSS_BMS_RequestPDF').Method_Type__c;
            reqWrapper.serviceName='CSS_BMS_RequestPDF';
            CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
            String jsonResponseBody;
            if(returnWrapper != null && returnWrapper.response != null && returnWrapper.response.getBody() != null)
                jsonResponseBody=returnWrapper.response.getBody();
            
            //Sending request and mapping the response 
            
            //string req = '{\"Header\": {\"Target\": {\"TargetID\": \"BMS\"},\"Sender\": {\"ServiceName\": \"sendPDFGenerationReq\",\"SenderID\": \"CSS\"},\"Location\": {\"LocationID\": \"03520-02331\"}},\"DataArea\":{\"CSSJobID\": \"CSS-00176434\",\"DistributorCode\": \"03520\",\"BranchCode\": \"02331\",\"CustomerCode\": \"WOQT\",\"OrderType\": \"WOQT\",\"BMSReferenceNumber\": \"283122\",\"CustomerPO\":\"\",\"Action\": \"QUOTE REQUEST\",\"SecurityCode\":\"\",\"InvoiceUser\":\"\"}}';
            //system.debug('Request--'+req);
            //de-serializing the response and mapping it to wrapper class
            reqPDFInboundRes = (CG_ReqPDFInbound_Resp )JSON.deserialize(jsonResponseBody,CG_ReqPDFInbound_Resp.class);
            //reqPDFInboundRes = (CG_ReqPDFInbound_Resp )JSON.deserialize(req,CG_ReqPDFInbound_Resp.class);
            System.debug('Status Code >>> :: '+returnWrapper.response.getStatusCode());
            System.debug('REST response is :: '+returnWrapper.response);
            system.debug('Response Body >>>'+returnWrapper.response.getbody());
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- SendGSQPartsRes', 'RESPONSE IS NULL', 'BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- SendGSQPartsRes', res1==null?'RESPONSE IS NULL':res1.getBody(), 'BMS');
                }
            }
        }
        return reqPDFInboundRes;
    }
    
    //Method to send Claims Details to BMS
    public static void claimsInbound(List<CSS_Claim_Submission__c> lstSubmissionClaim){
        CG_ClaimsInbound_Resp claimsInboundRes;
        list<CSS_JobHistory__c> jobHistoryToInsertList = new list<CSS_JobHistory__c>();
        List< CSS_Integration_Error__c> lsterror = new  List< CSS_Integration_Error__c>();
        List<CSS_Claim_Submission__c> lstsRecord = new List<CSS_Claim_Submission__c>();
        String message;
        String endPointURL;
        HttpResponse res1;
        //getting Access Token 
        //String access_token = splreceiveToken(Label.CSS_AltOAuth);
        //String access_token = splreceiveToken('OAGOAuth');
        //system.debug('access_token$$$$$$$$@@@@@@@@@@:::'+access_token);
        system.debug('BMS$$$$$$$$@@@@@@@@@@:::'+lstSubmissionClaim);
        CG_OP_OAGWrapper returnWrapper = new CG_OP_OAGWrapper();
        
        try
        {
            // Http h1 = new Http();
            //HttpRequest req1 = new HttpRequest();
            
            if(!Test.isRunningTest()){
                endPointURL =  CSS_getConnnectionDetails.getConnection('ClaimsInbound').End_Point__c;
                
            }else{
                endPointURL = 'https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/claims/'; }
            
            if(lstSubmissionClaim.size()>0){
                for(CSS_Claim_Submission__c c: lstSubmissionClaim){
                    system.debug('lstSubmissionClaim'+c.id);
                    //String reqWrpperInput = JSON.serialize(c.BMS_Claim_ReqJSON__c);
                    
                    /*req1.setHeader('Authorization','Bearer '+access_token);
req1.setHeader('Content-Type','application/json');
req1.setMethod('POST');
req1.setTimeout(Integer.valueof(Label.CSS_TimeOut_BMSServices));
req1.setEndpoint(endPointURL);

req1.setBody(c.BMS_Claim_ReqJSON__c);              
System.debug('req1.getBody======'+req1.getBody());*/
                    CG_IP_OAGWrapper reqWrapper = new CG_IP_OAGWrapper();
                    reqWrapper.jsonReqBody = c.BMS_Claim_ReqJSON__c;
                    reqWrapper.endPoint = endPointURL;
                    reqWrapper.methodType = CSS_getConnnectionDetails.getConnection('ClaimsInbound').Method_Type__c;
                    reqWrapper.serviceName='ClaimsInbound';
                    system.debug('c.BMS_Claim_ReqJSON__c:::'+c.BMS_Claim_ReqJSON__c);
                    if(c.BMS_Claim_ReqJSON__c != null && c.BMS_Claim_ReqJSON__c != ''){
                        system.debug('reqWrapper:::'+reqWrapper);
                        if(!Test.isRunningTest()){
                            
                            returnWrapper = CG_WS_Mule.calloutGenericMule(reqWrapper);
                        }
                        else{
                            returnWrapper = returnWrapperglobal;
                            //HttpResponse h = new HttpResponse();
                            //h.setBody('test');
                            //h.setStatusCode(200);
                            //returnWrapper.response = h;
                            //returnWrapper.response = Test.setMock(HttpCalloutMock.class , new SubmitClaimsmock_test());
                            
                        }
                    }
                    system.debug('returnWrapper:::'+returnWrapper);
                    String jsonResponseBody;
                    if(returnWrapper != null && returnWrapper.response != null)
                        jsonResponseBody=returnWrapper.response.getBody();
                    
                    //Sending request and mapping the response 
                    
                    //string req = '{\"Header\": {\"Target\": {\"TargetID\": \"BMS\"},\"Sender\": {\"ServiceName\": \"sendPDFGenerationReq\",\"SenderID\": \"CSS\"},\"Location\": {\"LocationID\": \"03520-02331\"}},\"DataArea\":{\"CSSJobID\": \"CSS-00176434\",\"DistributorCode\": \"03520\",\"BranchCode\": \"02331\",\"CustomerCode\": \"WOQT\",\"OrderType\": \"WOQT\",\"BMSReferenceNumber\": \"283122\",\"CustomerPO\":\"\",\"Action\": \"QUOTE REQUEST\",\"SecurityCode\":\"\",\"InvoiceUser\":\"\"}}';
                    //system.debug('Request--'+req);
                    
                    //claimsInboundRes = (CG_ClaimsInbound_Resp )JSON.deserialize(req,CG_ClaimsInbound_Resp.class);
                    System.debug('res1 :: '+returnWrapper.response);
                    System.debug(' res1.getStatusCode():: '+returnWrapper.response.getStatusCode());
                    Integer StatusCode=returnWrapper.response.getStatusCode();
                    /*if(Test.isRunningTest()){
jsonResponseBody='{'+
'	"DataArea": {'+
'		"BMSClaimNumber": "1-127827968"'+
'	},'+
'	"Header": {'+
'		"ReturnCodeDescription": "",'+
'		"Status": "Success",'+
'		 "Sender": '+
'			{'+
'			 "ServiceName": "",'+
'			  "MessageID": "",'+
'			  "SenderID": ""'+
'			},'+
'		"Target": '+
'			{'+
'			 "TargetID": ""'+
'			},'+
'		"Location": '+
'			{'+
'			 "LocationID": ""'+
'			}'+
'	}	'+
'}';
StatusCode=200;
}*/
                    if(returnWrapper.response == null || returnWrapper.response.getStatusCode() != 200){
                        System.debug('inside REST response is :: '+returnWrapper.response);
                        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
                        errObj.Error_Description__c = 'Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'Submit Claims to BMS Webservice Execution failed';
                        errObj.Source__c = 'Submit Claims to BMS';
                        errObj.Processed_Data__c = 'CSS_WS_BMS-Submit Claims to BMS';
                        errObj.Response_Body__c = (returnWrapper.response.getBody() != null && returnWrapper.response.getBody() != '')?returnWrapper.response.getBody():'The Response body is Null, Check with Middleware team';
                        lsterror.add(errObj);
                        System.debug('REST response lsterror :: '+lsterror);
                        CSS_JobHistory__c jobHist = new CSS_JobHistory__c();
                        jobHist.CSS_Field_Name__c = 'Claim '+c.CSS_Claims__r.name+' failed for adjudication at '+system.now();
                        jobHist.CSS_Job_Id__c = c.Id;
                        jobHist.CSS_Object_Name__c = 'CSS_Claim__c';
                        jobHistoryToInsertList.add(jobHist);
                        CSS_Claim_Submission__c csub = new CSS_Claim_Submission__c();
                        csub.id=c.id;
                        //csub.Status__c='In Process';
                        csub.ERP_Status__c = 'Error';
                        lstsRecord.add(csub);
                    }
                    else if(returnWrapper.response.getBody().contains('OSB Service Callout action received SOAP Fault response')){
                        System.debug('Incorrect json format-- STATUS:'+returnWrapper.response.getStatus()+'STATUS_CODE:'+returnWrapper.response.getStatusCode());
                        CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
                        errObj.Error_Description__c = 'Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'OSB Service Callout action received SOAP Fault response';
                        errObj.Source__c = 'Submit Claims to BMS';
                        errObj.Processed_Data__c = 'CSS_WS_BMS-Submit Claims to BMS';
                        errObj.Response_Body__c = (returnWrapper.response.getBody() != null && returnWrapper.response.getBody() != '')?returnWrapper.response.getBody():'The Response body is Null, Check with Middleware team';
                        lsterror.add(errObj);
                        CSS_JobHistory__c jobHist = new CSS_JobHistory__c();
                        jobHist.CSS_Field_Name__c = 'Claim '+c.CSS_Claims__r.name+' was retuned with Error status from BMS.';
                        jobHist.CSS_Job_Id__c = c.Id;
                        jobHist.CSS_Object_Name__c = 'CSS_Claim__c';
                        jobHistoryToInsertList.add(jobHist);
                        CSS_Claim_Submission__c csub = new CSS_Claim_Submission__c();
                        csub.id=c.id;
                        //csub.Status__c='In Process';
                        csub.ERP_Status__c = 'Error';
                        lstsRecord.add(csub);
                    }
                    else if(returnWrapper != null && returnWrapper.response != null && StatusCode == 200){
                        //de-serializing the response and mapping it to wrapper class
                        claimsInboundRes = (CG_ClaimsInbound_Resp )JSON.deserialize(jsonResponseBody,CG_ClaimsInbound_Resp.class);
                        //claimsInboundRes = (CG_ClaimSubmission_Resp )JSON.deserialize(httpRes.getBody(),CG_ClaimSubmission_Resp.class);
                        System.debug('Status Code >>> :: '+returnWrapper.response.getStatusCode());
                        System.debug('REST response is :: '+returnWrapper);
                        system.debug('Response Body >>>'+returnWrapper.response.getbody());
                        CSS_Claim_Submission__c csub = new CSS_Claim_Submission__c();
                        csub.id=c.id;
                        if(returnWrapper.response.getBody() != null && returnWrapper.response.getBody() != ''){
                            //csub.Siebel_Claim_Number__c=claimsInboundRes.DataArea.ClaimNumber+system.now();
                            //csub.Status__c='In Review';
                            if(claimsInboundRes.Header.Status == 'Success'){
                                csub.ERP_Status__c = 'Success';
                                lstsRecord.add(csub);
                            }
                            else{
                                CSS_Integration_Error__c errObj = new CSS_Integration_Error__c();
                                errObj.Error_Description__c = 'Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'OSB Service Callout action received SOAP Fault response';
                                errObj.Source__c = 'Submit Claims to BMS';
                                errObj.Processed_Data__c = 'CSS_WS_BMS-Submit Claims to BMS';
                                errObj.Response_Body__c = (returnWrapper.response.getBody() != null && returnWrapper.response.getBody() != '')?returnWrapper.response.getBody():'The Response body is Null, Check with Middleware team';
                                lsterror.add(errObj);
                                CSS_JobHistory__c jobHist = new CSS_JobHistory__c();
                                jobHist.CSS_Field_Name__c = 'Claim '+c.CSS_Claims__r.name+' was retuned with Error status from BMS.';
                                jobHist.CSS_Job_Id__c = c.Id;
                                jobHist.CSS_Object_Name__c = 'CSS_Claim__c';
                                jobHistoryToInsertList.add(jobHist);
                                csub.ERP_Status__c = 'Error';
                                lstsRecord.add(csub);
                            }
                        }
                    }
                }
            }
            if(lsterror.size()>0){
                insert lsterror;
            }
            if(lstsRecord.size()>0){
                update lstsRecord;
                
            }
            if(jobHistoryToInsertList != null && !jobHistoryToInsertList.isEmpty()){
                CSS_utility.createJobhistory(jobHistoryToInsertList);
            }  
        }
        catch(Exception ex){
            System.debug('getLineNumber*********************is :: '+ex.getLineNumber());
            System.debug('getLineNumber*********************is :: '+ex.getMessage());
            if(!Test.isRunningTest()){
                message = ex.getMessage();
                
                if(message.contains('timed out')){
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- Send Claims to BMS', 'RESPONSE IS NULL'+returnWrapper.response.getStatusCode(), 'Submit Claims to BMS');
                }
                else{
                    css_utility.LogOutIntError(endPointURL,ex.getMessage()+'- Send Claims to BMS', returnWrapper==null?'RESPONSE IS NULL':returnWrapper.response.getBody(), 'Submit Claims to BMS');
                }
            }
        }
        //return claimsInboundRes;
    }
    
}