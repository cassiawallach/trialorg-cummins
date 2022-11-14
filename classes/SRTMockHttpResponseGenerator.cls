@isTest
global class SRTMockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        System.assertEquals('POST', req.getMethod());
        
    
    CSS_SRTComponentLookupResponseJ2A.Header header = new  CSS_SRTComponentLookupResponseJ2A.Header();
    header.ReturnCodeDescription = 'Normal, Successful completion.';
    header.ReturnCode = 'ORA-00000';
    header.MessageIdentifier = 'S';
       
    CSS_SRTComponentLookupResponseJ2A.DataArea dArea = new  CSS_SRTComponentLookupResponseJ2A.DataArea();
    
    dArea.ComponentCode = 'CG';
    dArea.FailureMode = '';
    dArea.FailureID = 'F30000860';
    dArea.FailureName = 'Accessory Plate Cover Gasket';
    dArea.SystemCode = 'BG';
    
    CSS_SRTComponentLookupResponseJ2A controller = new CSS_SRTComponentLookupResponseJ2A();
    controller.Header = header;
     
    List<CSS_SRTComponentLookupResponseJ2A.DataArea> dtList = new List<CSS_SRTComponentLookupResponseJ2A.DataArea> ();
    dtList.add(dArea);
    controller.DataArea=dtList;
    
    // Create a fake response
    HttpResponse res = new HttpResponse();
    res.setHeader('Content-Type', 'application/json');
    res.setBody(Json.serialize(controller));
    res.setStatusCode(200);
    return res;
    }
}