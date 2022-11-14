@isTest
public  class dbu_Integration_Druple_Test {
  @isTest 
  public  static void getDrupleContentTest(){
        string data = '39716';
      //added by saikomal for production deployment
        CSS_Integration_Details__c accessTokenConDetails = new CSS_Integration_Details__c();
            accessTokenConDetails.End_Point__c =  'https://api-ue-devnf2-aw-ex.cummins.com:443/api/core-security-api/v1/auth/token';
           	accessTokenConDetails.Key__c = 'b7922fab-cacb-4e10-a9b2-15e1a7ff2641';
            accessTokenConDetails.Passcode__c =  'H4C3Ww1f~uRf5PIv6gi.fCdM4.f8l.u_YV';
            accessTokenConDetails.Method_Type__c = 'POST';
        	accessTokenConDetails.Name = 'dbu_druple_AccessToken';
        insert accessTokenConDetails;
        
          CSS_Integration_Details__c drupleConDetails = new CSS_Integration_Details__c();
            drupleConDetails.End_Point__c =  'https://api-ue-devnf2-aw-ex.cummins.com:443/cmi/v1/contentmanagement/';
            drupleConDetails.Method_Type__c = 'GET';
        	drupleConDetails.grant_type__c = 'application/json';
        	drupleConDetails.Name = 'dbu_Druple_Content';
        insert drupleConDetails;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new dbu_Integration_Druple_Mock());
        dbu_Integration_Druple.getDrupleContent(data);
        Test.stopTest();
    }
    
    
    //@isTest
    /*public with sharing class dbu_Integration_Druple_Access_Token_Mock implements HttpCalloutMock{
	
    public HTTPResponse respond(HTTPRequest request) {
       dbu_Integration_Druple.TokenResponse res = new dbu_Integration_Druple.TokenResponse();
        res.token_type = '';
        res.expires_in = '';
        res.ext_expires_in = '';
        res.expires_on = '';
        res.not_before = '';
        res.resource = '';
        res.access_token = '';
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(JSON.serialize(res));
        response.setStatusCode(200);
        return response; 
    }
}*/
}