@isTest
public class CSS_WS_TG_IAAppointments_V2_Test {

    static void testGetSuccessResponse()
    {
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IAAppointments_V2MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V02/CSS/IAAppointments/';  //Request URL
        req.httpMethod = 'POST';
        
        //Success
        String jSONRequestBody = '{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"GUIDANZ","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","CurrentDate":"12/24/2017","dateSpan":"3"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();
        Test.stopTest();
    }
    
    //Validations Response
    @isTest static void testGetVAlidationsResponse(){
        Test.startTest();
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_WS_TG_IAAppointments_V2MockTest());
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.addHeader('Content-Type', 'application/json');
        req.requestURI = '/services/apexrest/Assess/V02/CSS/IAAppointments/';  //Request URL
        req.httpMethod = 'POST';
        
        //Request Null Validation
        String jSONRequestBody = '';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();
        
        //Request Header null Validation
        jSONRequestBody = '{}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();
        
        //Invalid JSON Validation
        jSONRequestBody = '{{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"GUIDANZ","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","CurrentDate":"12/24/2017","dateSpan":"3"}}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();

        //ServiceName Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"2.0","ToolID":"GUIDANZ","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","CurrentDate":"12/24/2017","dateSpan":"3"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();
        
        //UserLocation Blank Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"2.0","ToolID":"GUIDANZ","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"","CurrentDate":"12/24/2017","dateSpan":"3"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();
        
        //UserLocation Invalid Validation
        jSONRequestBody = '{"Header":{"ServiceName":"","ServiceVersion":"2.0","ToolID":"GUIDANZ","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"123","CurrentDate":"12/24/2017","dateSpan":"3"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();

        //ToolID Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","CurrentDate":"12/24/2017","dateSpan":"3"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();
        
        //CurrentDate Validation
        jSONRequestBody = '{"Header":{"ServiceName":"IAAppointments","ServiceVersion":"2.0","ToolID":"GUIDANZ","SenderID":"oh559","TargetID":"CSS"},"DataArea":{"UserLocation":"03520-04892-P|56270-56255-S|02400-21108-S|02400-93019-S|02400-31840-S|02400-24720-S|02400-37580-S","CurrentDate":"","dateSpan":"3"}}';
        req.requestBody = Blob.valueof(jSONRequestBody);
        RestContext.request = req;
        RestContext.response= res;
        CSS_WS_TG_IAAppointments_V2.getIAAppointments();
        Test.stopTest();
    }
}