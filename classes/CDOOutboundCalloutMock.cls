@isTest
global class CDOOutboundCalloutMock implements HttpCalloutMock {
    
    protected Integer code; 
  protected String status; 
  protected String bodyAsString; 
  protected Blob bodyAsBlob; 
  protected Map<String, String> responseHeaders; 
    
    public CDOOutboundCalloutMock(Integer code, String status, String body, Map<String, String> responseHeaders) { 
    this.code = code; 
    this.status = status; 
    this.bodyAsString = body; 
    this.bodyAsBlob = null; 
    this.responseHeaders = responseHeaders; 
} 
    
    global HttpResponse respond(HttpRequest req) {
        // Creating a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"status":"success"}');
        res.setStatusCode(code);
        res.setStatus(status);
        if (bodyAsBlob != null) { 
      res.setBodyAsBlob(bodyAsBlob); 
      } else { 
            res.setBody(bodyAsString); 
          }
        
        if (responseHeaders != null) { 
      for (String key : responseHeaders.keySet()) { 
        res.setHeader(key, responseHeaders.get(key)); 
      } 
    } 
        return res; 
    }
}