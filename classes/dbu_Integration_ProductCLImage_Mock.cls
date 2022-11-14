@isTest
global with sharing class dbu_Integration_ProductCLImage_Mock implements HttpCalloutMock{

    global HTTPResponse respond(HTTPRequest request) {
        dbu_Integration_ProductCloudfrontImages.TokenResponse tokenObj  = new  dbu_Integration_ProductCloudfrontImages.TokenResponse();
        tokenObj.token_type ='Bearer';    
        tokenObj.expires_in ='3599';
        //tokenObj.ext_expires_in ='3599';
        //tokenObj.expires_on ='1608194983';
        //tokenObj.not_before ='1608194983';
        //tokenObj.resource ='https://api-ue-devnf-aw-ex.cummins.com/cmi/v1/contentmanagement';
        tokenObj.access_token ='eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1dCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayIsImtpZCI6IjVPZjlQNUY5Z0NDd0NtRjJCT0hIeEREUS1EayJ9.eyJhdWQiOiJodHRwczovL2FwaS11ZS1kZXZuZi1hdy1leC5jdW1taW5zLmNvbS9jbWkvdjEvY29udGVudG1hbmFnZW1lbnQiLCJpc3MiOiJodHRwczovL3N0cy53aW5kb3dzLm5ldC9iMzFhNWQ4Ni02ZGRhLTQ0NTctODVlNS1jNTViYmMwNzkyM2QvIiwiaWF0IjoxNjA4MTkxMDgzLCJuYmYiOjE2MDgxOTEwODMsImV4cCI6MTYwODE5NDk4MywiYWlvIjoiRTJKZ1lEaS85TnZYRlk0dWR5cjVYL3htOXAvc0JRQT0iLCJhcHBpZCI6ImI3OTIyZmFiLWNhY2ItNGUxMC1hOWIyLTE1ZTFhN2ZmMjY0MSIsImFwcGlkYWNyIjoiMSIsImlkcCI6Imh0dHBzOi8vc3RzLndpbmRvd3MubmV0L2IzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZC8iLCJvaWQiOiJmZGY5NTM3YS1hMzdjLTRhMDUtYjUyNC04YjZjNDEwNDViMGQiLCJyaCI6IjAuQUFBQWhsMGFzOXB0VjBTRjVjVmJ2QWVTUGFzdmtyZkx5aEJPcWJJVjRhZl9Ka0VPQUFBLiIsInN1YiI6ImZkZjk1MzdhLWEzN2MtNGEwNS1iNTI0LThiNmM0MTA0NWIwZCIsInRpZCI6ImIzMWE1ZDg2LTZkZGEtNDQ1Ny04NWU1LWM1NWJiYzA3OTIzZCIsInV0aSI6IjdORzB3aVdMYmtHYXc1M3kwWDBUQUEiLCJ2ZXIiOiIxLjAifQ.qir6Cp4ns2_jAwhoNH1K4f31xWmTXIJubYuxizJAr3nNPkgIc77W_uAt-G9ag9fZZ49AXNhih5AzUSArZo6UE6w_Lnmncau12BrHgkYtzAKRYuNhDUiZDMVx-imEFlKH4qPOfd8gSCvQA0ceGOq6OW0QH9UJvspRBPpE9PQ3SLEUVG8stGGt80sFZ6FMqqmQOK-B_ij1pOEdeHm_rZL_fsHe3ZUJ-zt7lAFZ_TB_jnRSEwBNaYYpkcuyPGs07HKStAYd4by6CfD5NPZFXpaNOFUpVyIzXEVQxNGzA_M-O4_-5DDG2rO2JXdrlkyx3jhXQ794JqUV2QzEmiYH79CPmQ';
    
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(tokenObj));
        response.setStatusCode(200);
        return response; 
    }
}