@isTest
global class Mock_OSM_MuleSoft_MW_Services_Failure implements HttpCalloutMock {
    global HttpResponse respond(HttpRequest req) {
        HttpResponse httpRes = new HttpResponse();
        httpRes.setHeader('Content-Type', 'application/json');
        httpRes.setStatusCode(400);
        httpRes.setBody('"Status":"Success","ErrorMessage":"success"');
        return httpRes;
    }
}