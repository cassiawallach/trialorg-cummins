@isTest
global class CSS_WS_BMS_ReceiveQuoteServiceMockTest implements HttpCalloutMock {

     // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {

        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Header":{"Status":"Success","ReturnCodeDescription":"Quote is updated successfully",location{"locationId":"03742-03750"}}}');
        res.setStatusCode(200);
        return res;
         
          }
    
}