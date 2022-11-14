/**********************************************************************
Name:CSS_SRTAccessWebService_Mock
Copyright © 2016  Cummins
======================================================
======================================================
Purpose:  Mock Class for  CSS_SRTAccessWebService class.                                                           
======================================================
======================================================
History                                                            
-------                                                            
VERSION AUTHOR              DATE                    DETAIL                                
1.0     Rajesh P         11/15/2016         INITIAL DEVELOPMENT                      
***********************************************************************/
@isTest
global class CSS_SRTAccessWebService_Mock implements HttpCalloutMock {
     
    global HTTPResponse respond(HTTPRequest req)  
        {
                   
            HttpResponse res;
        
            if((req.getEndpoint()).contains('https://services-dev-oauth.cummins.com/api/oauth/token/css')){
            //Create a fake response
            res = new HttpResponse();
            res.setHeader('Content-Type','application/x-www-form-urlencoded');
            res.setBody('{"access_token": "wT8uFrak4EsURZsCerOBedRsSTyRoxdk1KjUSHkNGLaG3yVarNQFns","token_type": "Bearer","expires_in": 1200,"refresh_token": "IyvJ3BFtFudwOeKb3GAqhTDjUCZ8bxx7EsTwEDfs4JvsoB","scope": "CSSCloud"}');
            }
        
            else if((req.getEndpoint()).contains('RetrieveStandardRepairTime')){
            res = new HttpResponse();
            //response for calling method 
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"DataArea":{"CaseResponse":[{"SRTTitle":"Air Cleaner Assembly (Including Bracket) - Remove and Install, Each","SRTDetails":"10-117","SRTID":116840},{"SRTTitle":"Vehicle Fairing - Remove and Install","SRTDetails":"17-185","SRTID":109690},{"SRTTitle":"Vehicle Steps - Remove and Install","SRTDetails":"17-184","SRTID":109689},{"SRTTitle":"DUMMY"},{"SRTTitle":"DUMMY"}],"ResponseMessage":""},"Header":{"ReturnCodeDescription":"","Status":"Success"}}');                
        }
        return res;
    }
}