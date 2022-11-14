/**********************************************************************
Name:CG_CL_HTTPMultiRequestMock
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is Used to  store MultipleHttpmocks in Single Transaction
======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE                DETAIL                                 
1.0 -     Nandigam sasi     07/12/2019          INITIAL DEVELOPMENT                    
***********************************************************************/
@isTest
public class CG_CL_HTTPMultiRequestMock implements HttpCalloutMock {
	Map<String, HttpCalloutMock> requests;

	public CG_CL_HTTPMultiRequestMock(Map<String, HttpCalloutMock> requests) {
		this.requests = requests;
	}

	public HTTPResponse respond(HTTPRequest req) {
		HttpCalloutMock mock = requests.get(req.getEndpoint());
		return mock.respond(req);
		
	}
    public void addRequestMock(String url, HttpCalloutMock mock) {
		requests.put(url, mock);
	}
}