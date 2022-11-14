@isTest
global class IAM_CSTUserStatusOutboundHelper_Mock implements HttpCalloutMock {
  global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"access_token": "asdui1891dlh11381dhjhd","token_type":"bearer","expires_in":"3600","refresh_token":"aksd2183jjd9ad1jdklsajd","scope":"api"}');
        response.setStatusCode(200);
        return response;
    }
}