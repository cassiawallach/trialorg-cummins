@isTest
global class FSL_SRTEditMockToken implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake  response
        HttpResponse res = new HttpResponse();
         res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"access_token":"v7VEut4A1lHYkMIN2UoNYt8xZQX7RwzP1bT5C92O8DUW9YUORg3Ps4","token_type":"Bearer","expires_in":1200,"refresh_token":"053uYyQG5zujmOIwpRYNqoPkuiy8f3Gv3bJQ5bGBnoHpYR","scope":"CSSCloud"}');
            return res; 
    }
}