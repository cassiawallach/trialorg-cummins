@isTest
global class FSLFailModeMockToken implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
         res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{'+
		'   \"access_token\": \"ffYVjhpw7pEigWdjJWmZ9ACyNCySnQB3SbtPGk0H4vYkJ09Hwwzfrv\",'+
		'   \"token_type\": \"Bearer\",'+
		'   \"expires_in\": 1200,'+
		'   \"refresh_token\": \"bv51htbK5dvXze8MXzOxp575ZvrF7sXZ6HmApQDR6EH0hv\",'+
		'   \"scope\": \"CSSCloud\"'+
		'}');
            return res; 
    }
}