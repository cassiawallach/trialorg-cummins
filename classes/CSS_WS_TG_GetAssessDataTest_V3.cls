@isTest
public class CSS_WS_TG_GetAssessDataTest_V3 {
    
    // This method is used for success & validation scenarios of GetAssessData service name
    @isTest static void testGetAssessDataValidationsResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetAssessDataMockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V02/CSS/GetAssessData/';  //Request URL
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
        req.requestURI = '/services/apexrest/Assess/V02/CSS/GetAssessData/';  //Request URL
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
        req.requestURI = '/services/apexrest/Assess/V02/CSS/GetAssessData/';  //Request URL
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
        req.requestURI = '/services/apexrest/Assess/V02/CSS/GetAssessData/';  //Request URL
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
        req.requestURI = '/services/apexrest/Assess/V02/CSS/GetAssessData/';  //Request URL
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
    
    
    
    @isTest static void testGetAssessDataIARecordUpdateResponse(){
        Test.startTest();
        insertDERecord();
        
        
        String jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000000462"}}';
        //String jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000000462"}}';
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V02/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(jSONRequestBody);
        CSS_WS_TG_GetAssessData_V3.getAssessData();
        CSS_FN_Triage_V3.executeRESTWebservice('jSONRequestBody', 'requestURI', 'accessToken');
        //CSS_FN_Triage_V2 tgObj = new CSS_FN_Triage_V2();
        //tgObj.performValidationsForMakeModelAccess(req);
        Test.stopTest();
    }
    
    
    @isTest static void insertDERecord(){
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
    
    }

}