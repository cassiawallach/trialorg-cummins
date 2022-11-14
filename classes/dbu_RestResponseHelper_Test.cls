@isTest
public class dbu_RestResponseHelper_Test {

    @isTest
    public static void SetRestResponseTest(){
        Integer statusCode = 400;
        String httpCode = 'BAD_REQUEST';
        String errorMessage = 'Invalid input';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/AccountService/';
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
        Test.startTest();
        dbu_RestResponseHelper.SetRestResponse(statusCode,httpCode,errorMessage);
        Test.stopTest();
    }
}