//Test Class for FSL_WS_Mule

@isTest()
public class FSL_WS_Mule_Test {
    
    public static testMethod void FSL_WS_MuleMethod() {
        Test.startTest();    
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
        reqWrapper.jsonReqBody = '{"Header":{"Sender":{"ServiceName":"Fake_Service","SenderID":"Guidanz"},"Target":{"TargetID":"BMS"}}}';
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Claims';
        reqWrapper.Authinfo = 'FSL_Authdetails';
        
        //Setting Mock Response
        final String mockResponse = '{"Response":{"claim":{"serviceModelName":"ISX CM871 E","claimSubSource":"Draft","possessionFlag":"N","claimStatus":"Draft","status":"SUCCESS","claimSource":"Guidanz"},"DecisionID":"2022-05-02T14:10:05.671-05:00"},"Header":{"Sender":{"ServiceName":"Fake_Service","SenderID":"Guidanz"},"Target":{"TargetID":"Fake_Target"}}}';
        final MockHttpResponseGenerator httpMock = new MockHttpResponseGenerator(mockResponse);
        Test.setMock(HttpCalloutMock.class, httpMock);
        
        //Calling Actual Class
        CG_OP_OAGWrapper returnwrapper = FSL_WS_MULE.calloutNamedCredentials(reqWrapper);
        String responsebody = returnwrapper.response.getbody();
        
        //Ensuring response body is set
        System.assert(responsebody.contains('Fake_Service'));
        Test.stopTest();
        
    }

//Scenario where response is not equal to 220/201    
    public static testMethod void FSL_WS_MuleMethodError() {
        Test.startTest();    
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
        reqWrapper.jsonReqBody = '{"Header":{"Sender":{"ServiceName":"Fake_Service","SenderID":"GUIDANZ"},"Target":{"TargetID":"BMS"}}}';
        reqWrapper.NamedCredential = 'FSL_NC_Claims';
        reqWrapper.Authinfo = 'FSL_Authdetails';
        
        //Setting Mock Response to mimic 400 error
        final String mockResponse = '';
        final MockHttpResponseGenerator httpMock = new MockHttpResponseGenerator(mockresponse);
        httpMock.setResponseStatus(400);
        Test.setMock(HttpCalloutMock.class, httpMock);
        
        //Calling Actual Class
        CG_OP_OAGWrapper returnwrapper = FSL_WS_MULE.calloutNamedCredentials(reqWrapper);
        String responsebody = returnwrapper.response.getbody();
        
        //Ensuring Exception Flag is set and Exception message includes response status
        System.assertEquals(returnwrapper.exceptionFlag,true);
        System.assert(returnwrapper.exceptionMessage.contains('400'));
        Test.stopTest();
        
    }
    
//Scenario to handle null pointer exception
    public static testMethod void FSL_WS_MuleException() {
        Test.startTest();    
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();
        reqWrapper.jsonReqBody = 'abc';
        reqWrapper.NamedCredential = '';
        reqWrapper.Authinfo = 'FSL_Authdetails';
                
        CG_OP_OAGWrapper returnwrapper = FSL_WS_MULE.calloutNamedCredentials(reqWrapper);
        System.assertEquals(returnwrapper.exceptionFlag,true);
        Test.stopTest();
        
    }

//Mock reponse generator class    
    private class MockHttpResponseGenerator implements HttpCalloutMock {        
        string endpoint;
        string username;
        string password;
        string callbody;
        string responsebody;
        string responseContentType = 'application/json';
        Integer responseStatus = 200;
        Map<String, String> callHeaders = new Map<String, String>();
        
        //Set the response body from test
        public MockHttpResponseGenerator (string response){
            this.responsebody = response;
        }
        
        //Set the response status from test
        public MockHttpResponseGenerator setResponseStatus(Integer status) {
            this.responseStatus = status;
            return this;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
        this.endpoint = req.getendpoint();
        this.username = req.getHeader('client-id');
        this.password = req.getHeader('client-secret');
        this.callBody = req.getBody();
        this.callHeaders.put('content-type', req.getHeader('Content-Type'));
            
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(this.responseBody);
        res.setStatusCode(this.responseStatus);
        return res;
    	}
    }
}