@isTest
public class CSS_WS_TG_IAAppointments_V1_Test {
	
    static void testGetSuccessResponse()
    {
        Test.startTest();
        	// Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IAAppointments_V1MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/IAAppointments/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        Test.stopTest();
    }
    
    //Validations Response
    @isTest static void testGetVAlidationsResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IAAppointments_V1MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V01/CSS/IAAppointments/';  //Request URL
        req.httpMethod = 'POST';
        
        //Request Null Validation
        String jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        
        //Invalid JSON Validation
        jSONRequestBody = '{{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();

        //ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();

        //ToolID Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":"IAS-0000004220"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        
        //CSSJobNumber Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"ATLASMOBILE","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"IASNumber":""}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V1.getIAAppointments();
        Test.stopTest();
    }
}