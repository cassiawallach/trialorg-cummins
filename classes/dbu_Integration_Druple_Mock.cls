@isTest
global with sharing class dbu_Integration_Druple_Mock implements HttpCalloutMock{
    
   public HTTPResponse respond(HTTPRequest req) {
       dbu_Integration_Druple.TokenResponse resObj = new dbu_Integration_Druple.TokenResponse();
        resObj.token_type = '';
        resObj.expires_in = '';
        resObj.ext_expires_in = '';
        resObj.expires_on = '';
        resObj.not_before = '';
        resObj.resource = '';
        resObj.access_token = '';
       
       String title = 'Terms and Conditions - USA';
        String body = '"body": "T&amp;C for USA. - Placeholder"';
        String image = '';
       List<dbu_Integration_Druple.DrupleResponseWrapper> responseObjectList = new List<dbu_Integration_Druple.DrupleResponseWrapper>();
        dbu_Integration_Druple.DrupleResponseWrapper responseObject = new dbu_Integration_Druple.DrupleResponseWrapper(title,body,image);
       responseObjectList.add(responseObject);
       
            if (req.getEndpoint().endsWith('auth/token')) {
                HTTPResponse res = new HTTPResponse();
                res.setBody(JSON.serialize(resObj));
                res.setStatusCode(200);
                return res;
            } else if (req.getEndpoint().endsWith('contentmanagement/39716')) {
              HTTPResponse res = new HTTPResponse();
                res.setBody(JSON.serialize(responseObjectList));
                res.setStatusCode(200);
                return res;
            } else {
                System.assert(false, 'unexpected endpoint ' + req.getEndpoint());
                return null;
            }
        }
}