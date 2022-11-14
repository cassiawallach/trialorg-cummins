@isTest
global class Mock_GOMS_Mule_Integration_Failure implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse httpRes = new HttpResponse();
        httpRes.setHeader('Content-Type', 'application/json');
        httpRes.setStatusCode(400);
        httpRes.setBody('{"transactionId": "I-0000001972","status": "Webservice call is Success","message": "Invoice has been staged successfully"}');
        return httpRes;
    }
}