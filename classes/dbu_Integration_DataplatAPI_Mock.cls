@isTest
global class dbu_Integration_DataplatAPI_Mock implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(200);
        response.setBody('{"esn": 79929608,"vin": "3HTDTAPT7HN707018","apiToken":"asdsdasd3231232ewqwqe12323"}');
        
        return response;
    }
}