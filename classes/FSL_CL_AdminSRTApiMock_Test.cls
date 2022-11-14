/********************************************************************************
Name:FSL_CL_AdminSRTApiMock_Test
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the class for Admin SRT Integrtion
======================================================
User story : CT2-345
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE               DETAIL                                
V.1.0 	 Rajashekar N		11/13/2020		   Send Admin SRTs to ERP
*********************************************************************************/
@isTest
global class FSL_CL_AdminSRTApiMock_Test implements HttpCalloutMock {
	global HTTPResponse respond(HTTPRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"Header":{"Status":"SUCCESS","ReturnCodeDescription":"Records processed successfully"}}');
        response.setStatusCode(200);
        return response; 
    }
}