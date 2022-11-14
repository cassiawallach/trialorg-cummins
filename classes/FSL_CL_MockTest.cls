@isTest
public class FSL_CL_MockTest implements HttpCalloutMock{
    public HTTPResponse respond(HTTPRequest req){
        system.debug('=====req.getEndpoint()====='+req.getEndpoint());
        HttpResponse res = new HttpResponse( );
        res.setHeader( 'Content-Type', 'application/json');
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        res.setBody('{"DataArea": {"Details": [{"DeductibleAmount": "23","Message": "Test","WarrantyId": "12333","AccountCode": "35555"}]},"Header": {"Status": "Success"}}');
        return res;
    }
}