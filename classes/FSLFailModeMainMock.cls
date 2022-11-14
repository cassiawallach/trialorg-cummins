@isTest
global class FSLFailModeMainMock implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse fakeResponse = new HttpResponse();
        fakeResponse.setStatusCode(200);
        string body = '{"DataArea":{"Details":[{"Active":"Y","Description":"CAMPAIGN","FailModeCode":"VY","BusinessUnit":"CMI","TargetID":"CMI"},{"Active":"Y","Description":"CAMPAIGN","FailModeCode":"JM","BusinessUnit":"CMI","TargetID":"CMI"}]},"Header":{"Status":"Success","ReturnCode":"","ReturnCodeDescription":"","MessageIdentifier":"53bf5d70-a635-46ea-8f28-64aa64157101"}}';
        fakeResponse.setBody(body);
        return fakeResponse;
    }
}