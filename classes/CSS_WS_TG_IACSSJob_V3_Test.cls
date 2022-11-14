/**********************************************************************
Name: CSS_WS_TG_IACSSJob_V3Test
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:    This is Test class for CSS_WS_TG_IACSSJob_V3 
            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Prabhakar R        18/12/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CSS_WS_TG_IACSSJob_V3_Test{
    
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
        CSS_WS_TG_IACSSJob_V3.createUpdateIACSSJob();
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
        CSS_WS_TG_IACSSJob_V3.createUpdateIACSSJob();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V3.createUpdateIACSSJob();
        
        //Invalid JSON Validation
        jSONRequestBody = '{{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V3.createUpdateIACSSJob();

        //ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V3.createUpdateIACSSJob();

        //ToolID Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V3.createUpdateIACSSJob();
        
        //CSSJobNumber Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IACSSJobCreation","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IACSSJob_V3.createUpdateIACSSJob();
        
        Test.stopTest();
    }
    
}