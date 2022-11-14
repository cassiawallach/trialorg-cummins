/************************************************************
Name:  IAM_SessionManagement_Test
Copyright © 2020  Cummins
============================================================= 
=============================================================
Purpose:                                                            
This is Class for PWC User session  management API                          
=============================================================
============================================================= 
*****************************************************/

@isTest
private class IAM_SessionManagement_Test{

    static testMethod void myUnitTest() 
    {  
   String JsonMsg = JSON.serialize('Test');
   RestRequest req = new RestRequest(); 
   RestResponse res = new RestResponse();         
   req.requestURI = '/services/apexrest/IAMsession/';  //Request URL
   req.httpMethod = 'POST';
   req.requestBody = Blob.valueof(JsonMsg);
   RestContext.request = req;
   RestContext.response= res;
   IAM_SessionManagement.UserInfo payload = new IAM_SessionManagement.UserInfo();
   payload.userName= 'Test234';
   IAM_SessionManagement.IAMusersession(payload);

    }
}