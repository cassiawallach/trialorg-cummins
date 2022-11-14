/**********************************************************************
Name: CSS_WS_TG_IACSSJobTest_V2
Copyright © 2017  Cummins
======================================================
======================================================
Purpose:    This is Test class for IACSSJobCreation 
            web service of IA/Triage
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
2.0     Surender M        03/10/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CSS_WS_TG_IACSSJobTest_V2 {
    
    @isTest static void testGetSuccessResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IACSSJobMockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V2.createIACSSJob();
        Test.stopTest();
    }
    
    //Validations Response
    @isTest static void testGetVAlidationsResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IACSSJobMockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/IACSSJobCreation/';  //Request URL
        req.httpMethod = 'POST';
        
        //Request Null Validation
        String jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V2.createIACSSJob();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V2.createIACSSJob();
        
        //Invalid JSON Validation
        jSONRequestBody = '{{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V2.createIACSSJob();

        //ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V2.createIACSSJob();

        //ToolID Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V2.createIACSSJob();
        
        //CSSJobNumber Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V2.createIACSSJob();
        
        Test.stopTest();
    }
    
}