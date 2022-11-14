/*Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for IAM_SingleRequestMock class. 
It is used to create a test response (mock test) for of external services we are calling in SF IAM                        
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Karthik Golakaram          04/12/2020       INITIAL DEVELOPMENT       
*****************************************************/
/********************************************************************************
***********************************************************************************/

@isTest
public class IAM_SingleRequestMock implements HttpCalloutMock {
	protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Blob bodyAsBlob;
    protected Map<String, String> responseHeaders;

    /* Constructor with body type String */
    public IAM_SingleRequestMock(Integer code, String status, String body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.bodyAsString = body;
        this.bodyAsBlob = null;
        this.responseHeaders = responseHeaders;
    }
    
    /* Constructor with body type Blob */
    public IAM_SingleRequestMock(Integer code, String status, Blob body, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.bodyAsBlob = body;
        this.bodyAsString = null;
        this.responseHeaders = responseHeaders;
    }

    /* It sends mock response */
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(code);
        resp.setStatus(status);
        if (bodyAsBlob != null) {
            resp.setBodyAsBlob(bodyAsBlob);
        } else {
            resp.setBody(bodyAsString);
        }        
        if (responseHeaders != null) {
            for (String key : responseHeaders.keySet()) {
                resp.setHeader(key, responseHeaders.get(key));
            }
        }
        return resp;
    }
}