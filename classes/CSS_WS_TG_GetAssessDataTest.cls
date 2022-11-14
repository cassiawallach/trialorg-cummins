/**********************************************************************
Name: CSS_WS_TG_GetAssessDataTest
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is Test class for GetAssessData 
            web service of Triage
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        10/05/2016     INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CSS_WS_TG_GetAssessDataTest {
    
    @isTest static void testGetAssessDataValidationsResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetAssessDataMockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        //Validation
        String jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();

        //ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();

        //ToolID Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //PSN Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //SERVICEMODELNAME Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //Request Null Validation
        jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //ERT Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":null,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //MAKE Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //Model Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //FaultList Null Validation
        jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        
        //Invalid JSON Validation
        jSONRequestBody = '{{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        Test.stopTest();
    }
    
    //For GetPrioritizedFC Response
    @isTest static void testGetPrioritizedFCResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_GetAssessDataMockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        String jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        Test.stopTest();
    }
    
    @isTest static void testGetFCAServiceResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_FCAPrioritizedFCMockTest());  //Mock for FCA service
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        //String fcaReq = '{"token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","version":1,"toolId":"15","esn":"79634249 ","currentRunTime":11693,"faultList":{"items":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"inactive","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":35},{"fc":"3596","occurenceTime":21536057,"status":"inactive","count":15},{"fc":"2636","occurenceTime":21536560,"status":"inactive","count":1},{"fc":"3568","occurenceTime":21535417,"status":"inactive","count":1},{"fc":"3714","occurenceTime":21535417,"status":"inactive","count":20}]}}';
        String jSONRequestBody = '{"Header":{"ServiceName":"GetPrioritizedFC","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        Test.stopTest();
    }
    
    @isTest static void testGetFCAServiceResponse2(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_FCAPrioritizedFCMockTest());  //Mock for FCA service
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        //String fcaReq = '{"token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","version":1,"toolId":"15","esn":"79634249 ","currentRunTime":11693,"faultList":{"items":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"inactive","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":35},{"fc":"3596","occurenceTime":21536057,"status":"inactive","count":15},{"fc":"2636","occurenceTime":21536560,"status":"inactive","count":1},{"fc":"3568","occurenceTime":21535417,"status":"inactive","count":1},{"fc":"3714","occurenceTime":21535417,"status":"inactive","count":20}]}}';
        String jSONRequestBody = '{"Header":{"ServiceName":"GetLaborHrsData","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        Test.stopTest();
    }
    
    @isTest static void testGetFCAServiceResponse3(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_FCAPrioritizedFCMockTest());  //Mock for FCA service
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/GetAssessData/';  //Request URL
        req.httpMethod = 'POST';
        
        //String fcaReq = '{"token":"uPe4AzYnaWAPEXUbUMyLa%aSUhuBadaS","version":1,"toolId":"15","esn":"79634249 ","currentRunTime":11693,"faultList":{"items":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"inactive","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":35},{"fc":"3596","occurenceTime":21536057,"status":"inactive","count":15},{"fc":"2636","occurenceTime":21536560,"status":"inactive","count":1},{"fc":"3568","occurenceTime":21535417,"status":"inactive","count":1},{"fc":"3714","occurenceTime":21535417,"status":"inactive","count":20}]}}';
        String jSONRequestBody = '{"Header":{"ServiceName":"GetAssessData","ServiceVersion":"1.0","ToolID":"ATLASMOBILE","SenderID":"nt321","TargetID":"CSS"},"DataArea":{"PSN":"79634249","SERVICEMODELNAME":"ISX15 CM2350 X101","ERT":11693,"MAKE":"FREIGHTLINER","MODEL":"CASCADIA","ACCESS":"","FAULTLIST":[{"fc":"1117","occurenceTime":21319736,"status":"inactive","count":1},{"fc":"1682","occurenceTime":21530503,"status":"active","count":1},{"fc":"3574","occurenceTime":21536057,"status":"inactive","count":1},{"fc":"3596","occurenceTime":21536057,"status":"active","count":2},{"fc":"2636","occurenceTime":21536560,"status":"active","count":1},{"fc":"3568","occurenceTime":21535417,"status":"active","count":1},{"fc":"3714","occurenceTime":21535417,"status":"active","count":20}]}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_GetAssessData.getAssessData();
        Test.stopTest();
    }
    


}