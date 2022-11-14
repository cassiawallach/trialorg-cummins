@isTest
global class CSS_WS_TG_FCAPrioritizedFCMockTest implements HttpCalloutMock{
	// Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"version":1,"transactionId":"568770238087168","algorithm":"Advanced","prioritizedData":[{"pri":"3596","rel":["3574","3714"]}],"unPrioritizedData":[{"fc":"1117","rc":"6"},{"fc":"1682","rc":"6"},{"fc":"2636","rc":"6"},{"fc":"3568","rc":"6"}]}');
        res.setStatusCode(200);
        return res;
    }
}