/**********************************************************************
Name: CSS_WS_TG_GetAssessData_V3_Test
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    This is Test class for GetAssessData_V3
web service of Triage
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
2.0     Surender M        01/23/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CSS_WS_TG_GetAssessData_V3_Test {
    
    // This method is used for success & validation scenarios of GetAssessData service name
    @isTest static void testGetAssessDataValidationsResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetAssessDataMockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V03/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        //Validation
        String jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //ToolID Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //PSN Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //SERVICEMODELNAME Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //Request Null Validation
        jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //ERT Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //MAKE Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //Model Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //FaultList Null Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        
        //Invalid JSON Validation
        jSONRequestBody = '{{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        //performValidationsForCreateCSSJob
        CSS_FN_Triage_V3 fn = new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapinput = new CSS_FN_Triage_V3.WrapperInput();
        //fn.performValidationsForCreateCSSJob(req, wrapinput);
        Test.stopTest();
    }
    
    //For GetPrioritizedFC service name Response
    @isTest static void testGetPrioritizedFCResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetAssessDataMockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V03/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        Test.stopTest();
    }
    
    //For GetPrioritizedFC service name Response2
    @isTest static void testGetFCAServiceResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_FCAPrioritizedFCMockTest());  //Mock for FCA service
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V03/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        //String fcaReq = '{"token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","version":1,"toolId":"15","esn":"79634249 ","currentRunTime":11693,"faultList":{"items":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"inactive","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":35},{"fc":"3596","occurenceTime":21536057,"status":"inactive","count":15},{"fc":"2636","occurenceTime":21536560,"status":"inactive","count":1},{"fc":"3568","occurenceTime":21535417,"status":"inactive","count":1},{"fc":"3714","occurenceTime":21535417,"status":"inactive","count":20}]}}';
        String jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        Test.stopTest();
    }
    
    //For GetLaborHrsData service name Response
    @isTest static void testGetFCAServiceResponse2(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_FCAPrioritizedFCMockTest());  //Mock for FCA service
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V03/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        //String fcaReq = '{"token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","version":1,"toolId":"15","esn":"79634249 ","currentRunTime":11693,"faultList":{"items":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"inactive","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":35},{"fc":"3596","occurenceTime":21536057,"status":"inactive","count":15},{"fc":"2636","occurenceTime":21536560,"status":"inactive","count":1},{"fc":"3568","occurenceTime":21535417,"status":"inactive","count":1},{"fc":"3714","occurenceTime":21535417,"status":"inactive","count":20}]}}';
        String jSONRequestBody = '{"Header":{"ServiceName":"GetLaborHrsData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        Test.stopTest();
    }
    
    //For GetAssessData service name's success response2
    @isTest static void testGetFCAServiceResponse3(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_FCAPrioritizedFCMockTest());  //Mock for FCA service
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V03/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        //String fcaReq = '{"token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","version":1,"toolId":"15","esn":"79634249 ","currentRunTime":11693,"faultList":{"items":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"inactive","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":35},{"fc":"3596","occurenceTime":21536057,"status":"inactive","count":15},{"fc":"2636","occurenceTime":21536560,"status":"inactive","count":1},{"fc":"3568","occurenceTime":21535417,"status":"inactive","count":1},{"fc":"3714","occurenceTime":21535417,"status":"inactive","count":20}]}}';
        String jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        Test.stopTest();
    }
    
    
    /*
* This method is used for code coverage for GetMakeModelAccessList service1 of Version1 of CSS_FN_Triage_V2 class
* Since GetMakeModelAccessList service1 is not changed by any code in Version2 but for future usage easily, 
* moved the CSS_FN_Triage code of GetMakeModelAccessList to CSS_FN_Triage_V2
*  For GetMakeModelAccessList service name's success response2
*/ 
    
    /*@isTest static void testPerformValidationsForMakeModelAccess(){
Test.startTest();
String jSONRequestBody = '{"Header": {"ServiceName": "GetMakeModelAccessList","ServiceVersion": "1.0","ToolID": "ATLASMOBILE","SenderID": "oh559","TargetID": "CSS"},"DataArea": {"PSN": "79484646"}  }';
RestRequest req = new RestRequest();
RestResponse res = new RestResponse();
req.addHeader('Content-Type', 'application/json');
req.requestURI = '/services/apexrest/Assess/V01/CSS/GetMakeModelAccessList/';  //Request URL
req.httpMethod = 'POST';
req.requestBody = Blob.valueof(jSONRequestBody);

CSS_FN_Triage_V2 tgObj = new CSS_FN_Triage_V2();
tgObj.performValidationsForMakeModelAccess(req);
Test.stopTest();
}*/
    
    // To cover IACSSJobCreation performValidationsForCreateUpdateCSSJob method
    @isTest static void methodForperformValidationsForCreateUpdateCSSJob(){
        
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetAssessDataMockTest()); //Mock should be IASRecords response
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V03/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        
        //IASRecords Request 
        //req.requestURI = 'https://connectedsolutions-stg.cummins.com/IASRecords/v1/iasjsons';  //Request URL
        //String jSONRequestBody = '{"Header":{"Target":"MachineData","ServiceVersion":"1.0","ServiceName":"SendIARecords","SenderID":"CSS","RunTime":"IAJobs-2017-06-23T19:32:24.024Z"},"DataArea":[{"Version":"v02","UserLocation":"56270-56255-P&#124;02400-21108-S&#124;02400-93019-S&#124;02400-31840-S&#124;02400-24720-S&#124;02400-37580-S","ToolID":"GUIDANZ","TargetID":"CSS","Status":"Success","ServiceVersion":"2","ServiceName":"GetAssessData","SERVICEMODELNAME":"ISX15 CM2250","SenderID":"oh559","ReturnCodeDescription":"Fault Details Data sent successfully","Result":{"unPrioritizedData":[{"upfc":"1116","rc":"4"},{"upfc":"1118","rc":"4"},{"upfc":"1119","rc":"4"}],"prioritizedData":[{"rootCause4":"","rootCause3":"OEM Wiring Harness","rootCause2":"Engine Wiring Harness","rootCause1":"OEM Component","relfc":[],"rc4Likelihood":"","rc3Likelihood":"7%","rc2Likelihood":"11%","rc1Likelihood":"64%","prifc":"1117","lhrs":"5.65"}]},"PSN":"79484646","MODEL":"389","MAKE":"PETERBILT","Id":"a0p3B000000KWQkQAO","IASNumber":"IAS-0000022164","ERT":"15255","CustomerName":"IA Cummins Test","CSSJobNumber":null,"CSSEnabled":"Y","ComplaintText":"Oil Leak Testing12345","Algorithm":"Advanced","ACCESS":"B"},{"Version":"v02","UserLocation":"56270-56255-P&#124;02400-21108-S&#124;02400-93019-S&#124;02400-31840-S&#124;02400-24720-S&#124;02400-37580-S","ToolID":"GUIDANZ","TargetID":"CSS","Status":"Success","ServiceVersion":"2","ServiceName":"GetPrioritizedFC","SERVICEMODELNAME":"ISX15 CM2250","SenderID":"oh559","ReturnCodeDescription":"Prioritized FCs sent successfully","Result":{"unPrioritizedData":[{"upfc":"1116","rc":"4"},{"upfc":"1118","rc":"4"},{"upfc":"1119","rc":"4"}],"prioritizedData":[{"rootCause4":null,"rootCause3":null,"rootCause2":null,"rootCause1":null,"relfc":[],"rc4Likelihood":null,"rc3Likelihood":null,"rc2Likelihood":null,"rc1Likelihood":null,"prifc":"1117","lhrs":null}]},"PSN":"79484646","MODEL":"389","MAKE":"PETERBILT","Id":"a0p3B000000KWQlQAO","IASNumber":"IAS-0000022165","ERT":"15255","CustomerName":"IA Cummins Test","CSSJobNumber":null,"CSSEnabled":"Y","ComplaintText":"Oil Leak Testing12345","Algorithm":"Advanced","ACCESS":"B"}]}';
        
        //IACSSJobCreation Proper Request 
        String jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"3.0","ToolID":"Guidanz","SenderID":"cssdl02","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000035780","CSSJobNumber":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        FNtriage3.performValidationsForCreateUpdateCSSJob(req,wrapInput);
        
        //Request Null Validation
        jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FNtriage3.performValidationsForCreateUpdateCSSJob(req,wrapInput);
        
        //Request Invalid JSON Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FNtriage3.performValidationsForCreateUpdateCSSJob(req,wrapInput);
        
        //Request ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"3.0","ToolID":"Guidanz","SenderID":"cssdl02","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000035780","CSSJobNumber":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FNtriage3.performValidationsForCreateUpdateCSSJob(req,wrapInput);
        
        //Request Wrong ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"WrongServiceName","ServiceVersion":"3.0","ToolID":"Guidanz","SenderID":"cssdl02","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000035780","CSSJobNumber":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FNtriage3.performValidationsForCreateUpdateCSSJob(req,wrapInput);
        
        //Request ToolId Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"3.0","ToolID":"","SenderID":"cssdl02","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000035780","CSSJobNumber":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FNtriage3.performValidationsForCreateUpdateCSSJob(req,wrapInput);
        
        //Request IASNuber Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"3.0","ToolID":"Guidanz","SenderID":"cssdl02","TargetID":"CSS"},"DataArea":{"IASNumber":"","CSSJobNumber":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        FNtriage3.performValidationsForCreateUpdateCSSJob(req,wrapInput);
        
        Test.stopTest();
    }
    
    @isTest static void testGetAssessDataIARecordUpdateResponse(){
        Test.startTest();
        insertDERecord();
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000000462"}}';
        //String jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000000462"}}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V03/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        CSS_FN_Triage_V3.executeRESTWebservice('jSONRequestBody', 'requestURI', 'accessToken');
        //CSS_FN_Triage_V3 tgObj = new CSS_FN_Triage_V3();
        //tgObj.performValidationsForMakeModelAccess(req);
        Test.stopTest();
    }
    
    static void insertDERecord(){
        List<CSS_DataExchange_Parent__c> de = new List<CSS_DataExchange_Parent__c>();
        CSS_DataExchange_Parent__c dataExchangeObj = new CSS_DataExchange_Parent__c();
        dataExchangeObj.recordTypeId = [Select Id, Name from RecordType where Name = 'IA-Inbox' limit 1].Id;
        dataExchangeObj.Version__c = 'v02';
        //dataExchangeObj.CSS_Job_Number__c = null;
        dataExchangeObj.CSS_Job_Number__c = 'CSS-12345';
        dataExchangeObj.CSS_Enabled__c = null;
        dataExchangeObj.ServiceName__c = 'GetPrioritizedFC';
        dataExchangeObj.ServiceVersion__c = '2.0';
        dataExchangeObj.ToolID__c = 'GuidanzMobile';
        dataExchangeObj.SenderID__c = 'oh559';
        dataExchangeObj.TargetID__c = 'CSS';
        dataExchangeObj.PSN__c = '79484646';
        dataExchangeObj.SERVICEMODELNAME__c = 'ISX15 CM2250';
        dataExchangeObj.ERT__c = '15255';
        dataExchangeObj.MAKE__c = 'PETERBILT';
        dataExchangeObj.MODEL__c = '389';
        dataExchangeObj.ACCESS__c = 'B';
        dataExchangeObj.Created_By__c = 'oh559';
        dataExchangeObj.Updated_By__c = 'oh559';
        dataExchangeObj.User_Location__c = '44444-16402,56270-56255-P';
        dataExchangeObj.User_Location_filtered__c = '56270-56255';
        dataExchangeObj.Customer_Company_Name__c = 'IA Cummins Test';
        dataExchangeObj.Complaint_Text__c = 'Oil Leak Testing12345';
        dataExchangeObj.Request_JSON__c = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"PSN":"79484646","SERVICEMODELNAME":"ISX15 CM2250","ERT":"15255","MAKE":"PETERBILT","MODEL":"389","ACCESS":"B","UserLocation":",7362332,44444-16402,56270-56255-P","CustomerName":"IA Cummins Test","ComplaintText":"Oil Leak Testing12345","IASNumber":"","FAULTLIST":[{"fc":"1117","occurenceTime":12,"status":"active","count":1},{"fc":"1116","occurenceTime":654,"status":"active","count":1},{"fc":"1118","occurenceTime":7865,"status":"active","count":1},{"fc":"1119","occurenceTime":80876,"status":"active","count":1}]}}';
        dataExchangeObj.Response_JSON__c = '{"Header":{"TxnCodeDescription":"CG01-IAS record inserted successfully","Status":"Success","ServiceVersion":"2.0","ServiceName":"GetAssessData","ReturnCodeDescription":"Fault Details Data sent successfully"},"DataArea":{"unPrioritizedData":[{"upfc":"1116","rc":"4"},{"upfc":"1118","rc":"4"},{"upfc":"1119","rc":"4"}],"PSN":"79484646","prioritizedData":[{"rootCause4":"","rootCause3":"","rootCause2":"Engine Wiring Harness","rootCause1":"OEM Component","relfc":[],"rc4Likelihood":"","rc3Likelihood":"","rc2Likelihood":"11%","rc1Likelihood":"82%","prifc":"1117","lhrs":"5.65"}],"IASNumber":"IAS-0000000589","CSSEnabled":"Y","algorithm":"Advanced"}}';
        //dataExchangeObj = assignResDetails(res, dataExchangeObj, 'CG01-IAS record inserted successfully', null);
        //insert DataExchange record here
        insert dataExchangeObj;
        dataExchangeObj.MDC_Status__c = true;
        dataExchangeobj.MDC_Sent_DateTime__c = System.now();
        update dataExchangeobj;
        de.add(dataExchangeobj);
        CSS_FN_Triage_V3 tgObj = new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.updateDERecords(de);
        CSS_FN_Triage_V3.assignValues(dataExchangeObj);
        CSS_FN_Triage_V3.storeIASRecordsInMDC(de);
        CSS_FN_Triage_V3.prepareReqJSONForMDC(de);
        CSS_FN_Triage_V3.getTokenOfMDC();
        CSS_FN_Triage_V3 obj = new CSS_FN_Triage_V3();
        obj.getAdvancedRoleUserId('inputUserId', 'userLocation');
        CSS_FN_Triage_V3.WrapperInput wrapinput = new CSS_FN_Triage_V3.WrapperInput();
        CSS_WPR_TG_IACSSJobCreationResJSON_V3 jsn = tgObj.prepareResponseWrapperForCSSJob(wrapinput);
        //CSS_WPR_TG_IACSSJobCreationResJSON_V3 jsn1 = tgObj.createIACSSJob(wrapinput);
    } 
    
    
    //CSS_FN_Triage_V3_Test methods Start below
    
    @istest static void getPrioritizedFCResponseTest() {
        Test.startTest();
        //  test.setmock(HttpCalloutMock.class, new CSS_WPR_TG_GetAssesDataReqJSON2Mockup());
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
        CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3 res = new CSS_WPR_TG_PrioritizedFCsResJSON2Apex_V3();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        res = fnt.getPrioritizedFCResponse(req);
        Test.stopTest();
        
    }
    @istest static void getLaborHrsDataResponseTest() {
        Test.startTest();
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
        CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3 res = new CSS_WPR_TG_LaborHrsDataResJSON2Apex_V3();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        res = fnt.getLaborHrsDataResponse(req);
        Test.stopTest();
    }
    @istest static void getAssessDataResponseTest() {
        Test.startTest();
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
        CSS_WPR_TG_FaultDetailsDataResJSON_V3 res = new CSS_WPR_TG_FaultDetailsDataResJSON_V3();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        res = fnt.getAssessDataResponse(req);
        Test.stopTest();
    }
    @istest static void createIACSSJobTest() {
        Test.startTest();
        CSS_FN_Triage_V3.WrapperInput req = new CSS_FN_Triage_V3.WrapperInput();
        CSS_WPR_TG_IACSSJobCreationResJSON_V3 res = new CSS_WPR_TG_IACSSJobCreationResJSON_V3();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        String userIdAdvancedRole = 'test';
        //  res = fnt.createIACSSJob(req,userIdAdvancedRole);
        Test.stopTest();
    }
    @istest static void executeFCAandFaultDetailsServicesTest() {
        Test.startTest();
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
        CSS_FN_Triage_V3.WrapperInput res = new CSS_FN_Triage_V3.WrapperInput();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        res = fnt.executeFCAandFaultDetailsServices(req);
        Test.stopTest();
    }    
    @istest static void executeFCAServicesTest() {
        Test.startTest();
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
        CSS_FN_Triage_V3.WrapperInput res = new CSS_FN_Triage_V3.WrapperInput();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        Test.stopTest();               
    }
    @istest static void getResponseOfFCAFaultDetailsServiceTest() {
        Test.startTest();
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 req = new CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3();
        CSS_WPR_FCA_FaultDetailsResJSON2Apex res = new CSS_WPR_FCA_FaultDetailsResJSON2Apex();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        res = fnt.getResponseOfFCAFaultDetailsService(req);
        Test.stopTest();               
    }
    @istest static void getPrioritizedFCSetTest() {
        Test.startTest();
        CSS_WPR_FCA_PrioritizedFCsResJSON2Apex req = new CSS_WPR_FCA_PrioritizedFCsResJSON2Apex();
        Set<String> PriorFCset = new Set<String>();
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();
        PriorFCset = fnt.getPrioritizedFCSet(req);
        Test.stopTest();               
    }
    @istest static void prepareFaultDetailsMapTest() {
        Test.startTest();
        CSS_WPR_FCA_FaultDetailsResJSON2Apex req = new CSS_WPR_FCA_FaultDetailsResJSON2Apex();
        Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList> faultDetailsMap1 = new Map<String, CSS_WPR_FCA_FaultDetailsResJSON2Apex.FaultDetailsList>();
        faultDetailsMap1 = CSS_FN_Triage_V3.prepareFaultDetailsMap(req);
        Test.stopTest();               
    }
    @istest static void getLaborHrsMapTest() {
        Test.startTest();
        Set<String> setStr = new Set<String>{'abc','def'};
            Map<String, CSS_Make_Model_Access__c> laborHrsMap = new Map<String, CSS_Make_Model_Access__c>();           
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();        
        laborHrsMap = fnt.getLaborHrsMap(setStr,'smn','make','model','access');
        Test.stopTest();               
    }
    @istest static void getLaborHrsTest() {
        Test.startTest();
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        Map<String, String> laborHrsMap = new Map<String, String>{'a'=>'b','c'=>'d'};
            String laborHrs = '';
        CSS_FN_Triage_V3 fnt = new CSS_FN_Triage_V3();        
        // laborHrs = fnt.getLaborHrs(wrapInput,'faultcode1',laborHrsMap);
        Test.stopTest();               
    }
    static testmethod void createIACSSJobtestmethod()
    {
        Test.startTest();
        user u = CSS_TestData.createTestUser(false);
        u.Username='gopal@cummins.com';
        insert u;
        system.runAs(u)
        {
            //test.startTest();
            account a = css_testdata.createAccountObj(false);
            a.CSS_DealerCode__c='56255';
            a.CSS_DistributorCode__c='56270';
            insert a;
            CSS_DataExchange_Parent__c DE = new CSS_DataExchange_Parent__c();
            de.PSN__c='79838572';
            de.Customer_Company_Name__c='GopalRaj';
            de.Complaint_Text__c='Oil Leak Testing12345';
            de.Customer_Name__c='Gopal';
            de.User_Location_filtered__c='56270-56255';
            de.Request_JSON__c='{  "Header": {    "ServiceName": "GetAssessData",    "ServiceVersion": "2.0",    "ToolID": "GUIDANZ",    "SenderID": "oh559",    "TargetID": "CSS"  },  "DataArea": {    "PSN": "79838572",    "SERVICEMODELNAME": "ISX15 CM2350 X101",    "ERT": "15255",    "MAKE": "KENWORTH",    "MODEL": "T660",    "ACCESS": "B",    "UserLocation": "56270-56255-P|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S",    "CustomerName": "IA Cummins Test",    "ComplaintText": "Oil Leak Testing12345",    "IASNumber": "",    "FAULTLIST": [      {        "fc": "3563",        "occurenceTime": 15255,        "status": "active",        "count": 1      },      {        "fc": "3567",        "occurenceTime": 15255,        "status": "active",        "count": 1      },      {        "fc": "1683",        "occurenceTime": 15255,        "status": "active",        "count": 1      },      {        "fc": "3137",        "occurenceTime": 15255,        "status": "active",        "count": 1      },      {        "fc": "2375",        "occurenceTime": 15255,        "status": "active",        "count": 1      },      {        "fc": "2374",        "occurenceTime": 15255,        "status": "active",        "count": 1      }    ]  }}';
            de.Response_JSON__c='{"Header":{"TxnCodeDescription":"CG01-IAS record inserted successfully","Status":"Success","ServiceVersion":"2.0","ServiceName":"GetAssessData","ReturnCodeDescription":"Fault Details Data sent successfully"},"DataArea":{"unPrioritizedData":[],"PSN":"79838572","prioritizedData":[{"rootCause4":"","rootCause3":"","rootCause2":"","rootCause1":"EGR Orifice Pressure Sensor","relfc":[],"rc4Likelihood":"","rc3Likelihood":"","rc2Likelihood":"","rc1Likelihood":"73%","prifc":"3137","lhrprob":{"lbrprob4":"11","lbrprob3":"0","lbrprob2":"11","lbrprob1":"78"}},{"rootCause4":"","rootCause3":"","rootCause2":"OEM Component","rootCause1":"EGR Temperature Sensor","relfc":[],"rc4Likelihood":"","rc3Likelihood":"","rc2Likelihood":"6%","rc1Likelihood":"88%","prifc":"2375","lhrprob":{"lbrprob4":"0","lbrprob3":"0","lbrprob2":"14","lbrprob1":"86"}},{"rootCause4":"","rootCause3":"","rootCause2":"Component Voltage Malfunction","rootCause1":"Exhaust Gas Pressure Sensor","relfc":[],"rc4Likelihood":"","rc3Likelihood":"","rc2Likelihood":"11%","rc1Likelihood":"85%","prifc":"2374","lhrprob":{"lbrprob4":"20","lbrprob3":"10","lbrprob2":"0","lbrprob1":"70"}},{"rootCause4":"","rootCause3":"","rootCause2":"OEM Component","rootCause1":"Aftertreatment Diesel Exhaust Fluid Dosing Valve","relfc":[],"rc4Likelihood":"","rc3Likelihood":"","rc2Likelihood":"23%","rc1Likelihood":"48%","prifc":"3567","lhrprob":{"lbrprob4":"7","lbrprob3":"15","lbrprob2":"56","lbrprob1":"22"}},{"rootCause4":"","rootCause3":"Electrical Connector","rootCause2":"OEM Component","rootCause1":"Component Voltage Malfunction","relfc":[],"rc4Likelihood":"","rc3Likelihood":"11%","rc2Likelihood":"26%","rc1Likelihood":"49%","prifc":"3563","lhrprob":{"lbrprob4":"43","lbrprob3":"0","lbrprob2":"43","lbrprob1":"14"}},{"rootCause4":"","rootCause3":"Aftertreatment Diesel Exhaust Fluid Tank Heater Control Valve","rootCause2":"OEM Component","rootCause1":"Electrical Connector","relfc":[],"rc4Likelihood":"","rc3Likelihood":"20%","rc2Likelihood":"33%","rc1Likelihood":"33%","prifc":"1683","lhrprob":{"lbrprob4":"0","lbrprob3":"25","lbrprob2":"13","lbrprob1":"63"}}],"IASNumber":"IAS-0000148547","CSSEnabled":"Y","algorithm":"Advanced"}}';
            insert DE;
            CSS_DataExchange_Parent__c DE1 = [select id,PSN__c,CSS_Job_Number__c,Customer_Company_Name__c,Complaint_Text__c,User_Location_filtered__c,Request_JSON__c,Response_JSON__c from CSS_DataExchange_Parent__c limit 1];
            CSS_DataExchange_Parent__c DE2 = [select id,PSN__c,Complaint_Text__c,User_Location_filtered__c from CSS_DataExchange_Parent__c limit 1];
            string name1 = CSS_FN_Triage_V3.createIACSSJob(DE1,string.valueOf(u.Id));
            try{
                css_job_order__c c= [select id,name,ESN_IA__c,Customer_Name__c,General_Symptoms__c,CSS_Job_Location_Code__c,Request_JSON__c,Response_JSON__c,JobLocation__c,Status__c,IsAppointment__c from css_job_order__c where name=:name1 limit 1]; 
                if(c!=null)
                {
                    CSS_FN_Triage_V3.updateIACSSJob(DE1, string.valueOf(u.Id), c);
                    //catch block excuetion
                    CSS_FN_Triage_V3.updateIACSSJob(DE2, string.valueOf(u.Id), c);
                }
                system.debug('job order detail'+c);
            }
            catch(exception e)
            {
                system.debug('error message>>'+e.getLineNumber()+' message in detail'+e.getMessage());
            }
            
            //Excueting for catch block
            CSS_FN_Triage_V3.createIACSSJob(DE2,string.valueOf(u.Id));
            
            Test.stopTest();
        }
        
    }
    static testmethod void performValidationstestmethod()
    {
        Test.startTest();
        string json='{"DataArea": { "PSN": "56840000", "SERVICEMODELNAME": "EA561", "ERT": "E534", "MAKE": "E537", "MODEL": "E533", "ACCESS": "E4363", "UserLocation": "Advanced East1", "CustomerName": "Gopal", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "getprioritizedfc", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json);
        RestRequest R = new RestRequest();
        R.requestBody = blob.valueOf(json);
        r.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r.httpMethod='post';
        r.addHeader('content-type','application/json');
        Restcontext.request=r;
        CSS_FN_Triage_V3 FNtriage= new CSS_FN_Triage_V3();
        FNtriage.performValidations(R);
        
        string json2='{"DataArea": { "PSN": "", "SERVICEMODELNAME": "EA561", "ERT": "E534", "MAKE": "E537", "MODEL": "E533", "ACCESS": "E4363", "UserLocation": "Advanced East1", "CustomerName": "Gopal", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj2= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json2);
        RestRequest R2 = new RestRequest();
        R2.requestBody = blob.valueOf(json2);
        r2.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r2.httpMethod='post';
        r2.addHeader('content-type','application/json');
        Restcontext.request=r2;
        CSS_FN_Triage_V3 FNtriage2 =new CSS_FN_Triage_V3();
        FNtriage2.performValidations(R2);
        Test.stopTest();
        
    }
    static testmethod void performvalidationtestmethod1()
    {
        Test.startTest();
        string json1='{"DataArea": { "PSN": "", "SERVICEMODELNAME": "", "ERT": "", "MAKE": "", "MODEL": "", "ACCESS": "", "UserLocation": "", "CustomerName": "", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "", "ServiceVersion": "", "ToolID": "", "TargetID": "", "SenderID": "" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj1= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json1);
        RestRequest R1 = new RestRequest();
        R1.requestBody = blob.valueOf(json1);
        r1.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r1.httpMethod='post';
        r1.addHeader('content-type','application/json');
        Restcontext.request=r1;
        CSS_FN_Triage_V3 FNtriage1= new CSS_FN_Triage_V3();
        FNtriage1.performValidations(R1);
        string json='{"DataArea": { "PSN": "", "SERVICEMODELNAME": "EA561", "ERT": "E534", "MAKE": "E537", "MODEL": "E533", "ACCESS": "E4363", "UserLocation": "Advanced East1", "CustomerName": "Gopal", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "getprioritizedfc", "ToolID": "", "TargetID": "TargetID", "SenderID": "SenderID" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json);
        RestRequest R = new RestRequest();
        R.requestBody = blob.valueOf(json);
        r.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r.httpMethod='post';
        r.addHeader('content-type','application/json');
        Restcontext.request=r;
        CSS_FN_Triage_V3 FNtriage= new CSS_FN_Triage_V3();
        FNtriage.performValidations(R);
        Test.stopTest();
    }
    
    static testmethod void performvalidationtestmethod2()
    {
        Test.startTest();
        string json1='{"DataArea": { "PSN": "", "SERVICEMODELNAME": "", "ERT": "", "MAKE": "", "MODEL": "", "ACCESS": "", "UserLocation": "", "CustomerName": "", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj1= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json1);
        RestRequest R1 = new RestRequest();
        R1.requestBody = blob.valueOf(json1);
        r1.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r1.httpMethod='post';
        r1.addHeader('content-type','application/json');
        Restcontext.request=r1;
        CSS_FN_Triage_V3 FNtriage1= new CSS_FN_Triage_V3();
        FNtriage1.performValidations(R1);
        Test.stopTest();
    }
    
    static testmethod void performvalidationtestmethod3()
    {
        Test.startTest();
        string json4='{"DataArea": { "PSN": "56870000", "SERVICEMODELNAME": "SERVICEMODELNAME", "ERT": "ERT", "MAKE": "", "MODEL": "E533", "ACCESS": "E4363", "UserLocation": "Advanced East1", "CustomerName": "Gopal", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj4= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json4);
        RestRequest R4 = new RestRequest();
        R4.requestBody = blob.valueOf(json4);
        r4.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r4.httpMethod='post';
        r4.addHeader('content-type','application/json');
        Restcontext.request=r4;
        CSS_FN_Triage_V3 FNtriage4 =new CSS_FN_Triage_V3();
        FNtriage4.performValidations(R4);
        Test.stopTest();
    }
    
    static testmethod void performvalidationtestmethod4()
    {
        Test.startTest();
        string json2='{"DataArea": { "PSN": "PSN", "SERVICEMODELNAME": "EA561", "ERT": "E534", "MAKE": "E537", "MODEL": "E533", "ACCESS": "E4363", "UserLocation": "Advanced East1", "CustomerName": "Gopal", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "", "TargetID": "TargetID", "SenderID": "SenderID" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj2= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json2);
        RestRequest R2 = new RestRequest();
        R2.requestBody = blob.valueOf(json2);
        r2.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r2.httpMethod='post';
        r2.addHeader('content-type','application/json');
        Restcontext.request=r2;
        CSS_FN_Triage_V3 FNtriage2 =new CSS_FN_Triage_V3();
        FNtriage2.performValidations(R2);
        Test.stopTest();
    }
    
    static testmethod void performvalidationtestmethod5()
    {
        Test.startTest();
        string json3='{"DataArea": { "PSN": "56870000", "SERVICEMODELNAME": "SERVICEMODELNAME", "ERT": "", "MAKE": "E537", "MODEL": "E533", "ACCESS": "E4363", "UserLocation": "Advanced East1", "CustomerName": "Gopal", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        Test.stopTest();
    }
    
    static testmethod void performvalidationtestmethod6()
    {
        Test.startTest();
        string json4='{"DataArea": { "PSN": "56870000", "SERVICEMODELNAME": "SERVICEMODELNAME", "ERT": "ERT", "MAKE": "MAKE", "MODEL": "", "ACCESS": "E4363", "UserLocation": "Advanced East1", "CustomerName": "Gopal", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj4= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json4);
        RestRequest R4 = new RestRequest();
        R4.requestBody = blob.valueOf(json4);
        r4.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r4.httpMethod='post';
        r4.addHeader('content-type','application/json');
        Restcontext.request=r4;
        CSS_FN_Triage_V3 FNtriage4 =new CSS_FN_Triage_V3();
        FNtriage4.performValidations(R4);
        Test.stopTest();
    }
    
    static testmethod void performvalidationtestmethod7()
    {
        Test.startTest();
        string json3='{"DataArea": { "PSN": "56870000", "SERVICEMODELNAME": "SERVICEMODELNAME", "ERT": "E534", "MAKE": "E537", "MODEL": "E533", "ACCESS": "E4363", "UserLocation": "Advanced East1", "CustomerName": "Gopal", "ComplaintText": "Oil LEAK", "IASNumber": "6535", "faultList": [ { "fc": "2354", "occurenceTime": "3", "status": "Intake", "count": "1" } ] }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "", "TargetID": "TargetID", "SenderID": "SenderID" }}';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void testmethodcreate()
    {
        Test.startTest();
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        CSS_FN_Triage_V3 obj = new CSS_FN_Triage_V3();
        obj.prepareResWrapperForIAAppoints(wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod()
    { 
        Test.startTest();
        string json3='{ "DataArea": { "UserLocation": "56473-53423", "CurrentDate": "Cancelled" }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod1()
    {
        Test.startTest();
        string json3='{ "DataArea": { "UserLocation": "56473-53423", "CurrentDate": "" }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod2()
    { 
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "56473-53423", "CurrentDate": "'+d1+'" }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod3()
    { 
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "", "CurrentDate": "'+d1+'" }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod4()
    { 
        Test.startTest();
        CSS_DataExchange_Parent__c de = new CSS_DataExchange_Parent__c();
        de.Customer_Name__c = 'customer1';
        de.Contact_Name__c = 'custContact';
        de.City__c= 'las vegas';
        de.Country__c = 'USA';
        insert de;
        list<CSS_DataExchange_Parent__c> delst=[select name ,id from CSS_DataExchange_Parent__c];
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        wrapInput.IASNumber = delst[0].name ;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.createUpdateIACSSJob(wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod5()
    { 
        Test.startTest();
        CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
        Date d = Date.Today();
        // System.debug('date');
        SerRec.DSID__c='12345';
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        SerRec.Warranty_Start_Date__c=d;
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.sub_Type__c='cedan';
        SerRec.INSITE_UpdateTimeStamp__c= system.today();
        SerRec.INSITE_ESN_Choice__c='Not Selected';
        SerRec.Shop_Work_Order__c='1234';
        SerRec.DSID_Creation_Timestamp__c=system.today();
        SerRec.DSID_WorkGroup__c='Wrkgrp';
        SerRec.Equipment_ID__c='Equip';
        SerRec.Status__c = 'Triage & Diagnosis/Repair' ;
        SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec.CSS_Job_Location_Code__c='56270-56255';
        SerRec.PSN_Not_Available__c = true;
        insert serrec;
        CSS_Job_Order__c j = [select id,name,ESN__c from CSS_Job_Order__c limit 1];
        CSS_DataExchange_Parent__c de = new CSS_DataExchange_Parent__c();
        de.Customer_Name__c = 'customer1';
        de.Contact_Name__c = 'custContact';
        de.City__c= 'las vegas';
        de.Country__c = 'USA';
        de.CSS_Enabled__c='y';
        de.CSS_Job_Number__c=j.Name;
        insert de;
        list<CSS_DataExchange_Parent__c> delst=[select name ,id,CSS_Enabled__c from CSS_DataExchange_Parent__c];
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        wrapInput.IASNumber = delst[0].name ;
        wrapInput.CSSJobNumber=j.name;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.createUpdateIACSSJob(wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod6()
    { 
        Test.startTest();
        CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
        Date d = Date.Today();
        // System.debug('date');
        SerRec.DSID__c='12345';
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        SerRec.Warranty_Start_Date__c=d;
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.sub_Type__c='cedan';
        SerRec.INSITE_UpdateTimeStamp__c= system.today();
        SerRec.INSITE_ESN_Choice__c='Not Selected';
        SerRec.Shop_Work_Order__c='1234';
        SerRec.DSID_Creation_Timestamp__c=system.today();
        SerRec.DSID_WorkGroup__c='Wrkgrp';
        SerRec.Equipment_ID__c='Equip';
        SerRec.Status__c = 'Appointment' ;
        SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec.CSS_Job_Location_Code__c='56270-56255';
        SerRec.PSN_Not_Available__c = true;
        insert serrec;
        CSS_Job_Order__c j = [select id,name,ESN__c from CSS_Job_Order__c limit 1];
        CSS_DataExchange_Parent__c de = new CSS_DataExchange_Parent__c();
        de.Customer_Name__c = 'customer1';
        de.Contact_Name__c = 'custContact';
        de.City__c= 'las vegas';
        de.Country__c = 'USA';
        de.CSS_Enabled__c='y';
        de.CSS_Job_Number__c=j.Name;
        insert de;
        list<CSS_DataExchange_Parent__c> delst=[select name ,id,CSS_Enabled__c from CSS_DataExchange_Parent__c];
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        wrapInput.IASNumber = delst[0].name ;
        wrapInput.CSSJobNumber=j.name;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.createUpdateIACSSJob(wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod7()
    {
        Test.startTest();
        CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
        Date d = Date.Today();
        // System.debug('date');
        SerRec.DSID__c='12345';
        SerRec.DSID_Status__c='open';
        SerRec.ESN__c ='79464647';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Failure_Point__c=2.2;
        SerRec.Unit_Number__c='1234';
        SerRec.Service_Model__c='ESN';
        SerRec.Service_Model_N__c = 445566;
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.VIN__c='1XKAD49X6CJ305490';
        SerRec.Customer_Name__c='ABC';
        SerRec.Warranty_Start_Date__c=d;
        SerRec.Failure_Point_Measure__c = 'MI'; 
        SerRec.Application__c='Automotive'; 
        SerRec.sub_Type__c='cedan';
        SerRec.INSITE_UpdateTimeStamp__c= system.today();
        SerRec.INSITE_ESN_Choice__c='Not Selected';
        SerRec.Shop_Work_Order__c='1234';
        SerRec.DSID_Creation_Timestamp__c=system.today();
        SerRec.DSID_WorkGroup__c='Wrkgrp';
        SerRec.Equipment_ID__c='Equip';
        SerRec.Status__c = 'Appointment' ;
        SerRec.Previous_Status__c = 'Triage & Diagnosis' ;
        SerRec.CSS_Job_Location_Code__c='56270-56255';
        SerRec.PSN_Not_Available__c = true;
        insert serrec;
        CSS_Job_Order__c j = [select id,name,ESN__c from CSS_Job_Order__c limit 1];
        CSS_DataExchange_Parent__c de = new CSS_DataExchange_Parent__c();
        de.Customer_Name__c = 'customer1';
        de.Contact_Name__c = 'custContact';
        de.City__c= 'las vegas';
        de.Country__c = 'USA';
        de.CSS_Enabled__c='y';
        de.CSS_Job_Number__c=j.Name;
        insert de;
        list<CSS_DataExchange_Parent__c> delst=[select name ,id,CSS_Enabled__c from CSS_DataExchange_Parent__c];
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        wrapInput.IASNumber = delst[0].name ;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.createUpdateIACSSJob(wrapInput);
        Test.stopTest();
    } 
    
    static testmethod void getLaborHrstestmethod()
    {
        Test.startTest();
        CSS_FN_Triage_V3.WrapperInput wrapperObj = new CSS_FN_Triage_V3.WrapperInput();
        wrapperobj.access ='';
        string fc ='2358';
        Map<String, CSS_Make_Model_Access__c> laborHrsMap = new Map<String, CSS_Make_Model_Access__c>();
        CSS_FN_Triage_V3 FNsieb = new CSS_FN_Triage_V3();
        FNsieb.getLaborHrs(wrapperObj, fc, laborHrsMap);
        Test.stopTest();
    }
    
    static testmethod void getLaborHrstestmethod1()
    {
        Test.startTest();
        CSS_FN_Triage_V3.WrapperInput wrapperObj = new CSS_FN_Triage_V3.WrapperInput();
        wrapperobj.make='UNLISTED';
        wrapperobj.model='ALL';
        string fc ='2358';
        Map<String, CSS_Make_Model_Access__c> laborHrsMap = new Map<String, CSS_Make_Model_Access__c>();
        CSS_FN_Triage_V3 FNsieb = new CSS_FN_Triage_V3();
        FNsieb.getLaborHrs(wrapperObj, fc, laborHrsMap);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod13()
    {
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "", "CurrentDate": "'+d1+'" }, "Header": { "ServiceName": "ServiceName", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void TestgetIAAppointmentsMethod()
    {
        Test.startTest();
        String json = '{ "Header": { "Status": "Success", "ServiceName": "IAAppointments", "ServiceVersion": "1.0", "ReturnCodeDescription": "IA Appointments data as Response" }, "DataArea": { "CSSEnabled": "True", "IAAppointments": [ { "CustomerName": "Tom Curise", "ContactFirstName": "Tom", "ContactLastName": "Curise", "CSSJobNumber": "CSS00012345", "UnitNumber": "10548795612", "ComplaintText": "Curise control is not working", "AvailableForService": "1" } ] } }';
        
        CSS_WPR_TG_IAAppointmentsResJSON_V1 obj = CSS_WPR_TG_IAAppointmentsResJSON_V1.parse(json);
        CSS_FN_Triage_V3.WrapperInput Wrapperobj= new CSS_FN_Triage_V3.WrapperInput();
        CSS_FN_Triage_V3 FNtriage = new CSS_FN_Triage_V3();
        FNtriage.getIAAppointments(Wrapperobj);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod14()
    { 
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "", "CurrentDate": "'+d1+'" }, "Header": { "ServiceName": "iaappointments", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        //R3.requestBody = blob.valueOf(json3);
        R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod15()
    { 
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "", "CurrentDate": "'+d1+'" }, "Header": { "ServiceName": "", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod16()
    {
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "", "CurrentDate": "'+d1+'" }, "Header": { "ServiceName": "iaappointment", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod17()
    { 
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "", "CurrentDate": "'+d1+'" }, "Header": { "ServiceName": "iaappointments", "ServiceVersion": "ServiceVersion", "ToolID": "", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    static testmethod void performValidationsForIAAppointmentstestmethod18()
    { 
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "", "CurrentDate": "'+d1+'" }, "Header": { "ServiceName": "iaappointments", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod19()
    { 
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "UserLocation", "CurrentDate":"'+d1+'" }, "Header": { "ServiceName": "iaappointments", "ServiceVersion": "ServiceVersion", "ToolID": "", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        system.debug('date '+obj3.DataArea);
        
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        //   FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod20()
    { 
        Test.startTest();
        date d1= system.today();
        string json3='{ "DataArea": { "UserLocation": "UserLocation", "CurrentDate":"2018-06-16" }, "Header": { "ServiceName": "iaappointments", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        system.debug('date '+obj3.DataArea);
        
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        //   FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod21()
    { 
        Test.startTest();    
        string json3='{ "DataArea": { "UserLocation": "", "CurrentDate":"12/27/2009" }, "Header": { "ServiceName": "iaappointments", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        system.debug('date '+obj3.DataArea);
        
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        //   FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod22()
    { 
        Test.startTest();
        date d1= Date.valueOf('2018-12-31');
        string json3='{ "DataArea": { "UserLocation": "56870-56870", "CurrentDate":"12/27/2009" }, "Header": { "ServiceName": "iaappointments", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        system.debug('date '+obj3.DataArea);
        
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        //   FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void performValidationsForIAAppointmentstestmethod23()
    { 
        Test.startTest();
        Account a = new account();
        a.Name='Gopal';
        a.CSS_DealerCode__c='56870';
        a.CSS_DistributorCode__c='56870';
        a.IA_CSSEnabled__c=true;
        insert a;
        date d1= Date.valueOf('2018-12-31');
        string json3='{ "DataArea": { "UserLocation": "56870-56870", "CurrentDate":"12/27/2009" }, "Header": { "ServiceName": "iaappointments", "ServiceVersion": "ServiceVersion", "ToolID": "ToolID", "TargetID": "TargetID", "SenderID": "SenderID" } }';
        CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3 obj3= CSS_WPR_TG_GetAssesDataReqJSON2Apex_V3.parse(json3);
        system.debug('date '+obj3.DataArea);
        
        RestRequest R3 = new RestRequest();
        R3.requestBody = blob.valueOf(json3);
        //R3.requestBody = blob.valueOf('');
        r3.requestURI='http://cummins--cssdev.cs50.my.salesforce.com/apex/services/v1/testing';
        r3.httpMethod='post';
        r3.addHeader('content-type','application/json');
        Restcontext.request=r3;
        CSS_FN_Triage_V3 FNtriage3 =new CSS_FN_Triage_V3();
        CSS_FN_Triage_V3.WrapperInput wrapInput = new CSS_FN_Triage_V3.WrapperInput();
        //   FNtriage3.performValidations(R3);
        FNtriage3.performValidationsForIAAppointments(R3,wrapInput);
        Test.stopTest();
    }
    
    static testmethod void TestgetIAAppointmentsMethod1()
    {
        Test.startTest();    
        CSS_FN_Triage_V3.WrapperInput Wrapperobj= new CSS_FN_Triage_V3.WrapperInput();
        wrapperObj.CurrentDate='12/26/2018';
        CSS_FN_Triage_V3 FNtriage = new CSS_FN_Triage_V3();
        FNtriage.getIAAppointments(Wrapperobj);
        Test.stopTest();
    }
    
    static testmethod void TestgetIAAppointmentsMethod2()
    {
        Test.startTest();
        user u= CSS_TestData.createTestUser(false);
        u.Username='gopal.ra@cummins.com';
        u.User_Location__c='50909-50909';
        insert u;
        system.runAs(u){
            
            css_job_order__c wo = new css_job_order__C();
            wo.Customer_Name__c='Gopal';
            wo.Customer_Code__c='123';
            wo.Status__c='Appointment';
            wo.ESN__c='54327534';
            wo.Unit_Number__c='1234';
            wo.Date_in_Shop__c=system.today();
            wo.General_Symptoms__c='oil leak';
            wo.BMS_Last_Name__c='Raj';
            
            insert wo;
            
            CSS_FN_Triage_V3.WrapperInput Wrapperobj= new CSS_FN_Triage_V3.WrapperInput();
            wrapperObj.CurrentDate='06/17/2018';
            wrapperObj.userLocation='50909-50909';  
            CSS_FN_Triage_V3 FNtriage = new CSS_FN_Triage_V3();
            FNtriage.getIAAppointments(Wrapperobj);
        }
        Test.stopTest();
    }
    //CSS_FN_Triage_V3_Test methods End 
    
    
}