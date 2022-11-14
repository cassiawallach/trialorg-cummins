@isTest(seeAllData=true)
public class FSLCumminsServiceUtility_Test {
    
    @isTest
    private static void createHttpRequest_Test(){
        CSS_Integration_Details__c csi = new CSS_Integration_Details__c();
        csi = CSS_Integration_Details__c.getInstance('CG_GETAllSRT');
        String endPoint = 'https://services-stg.cummins.com/css/srtlookup';
        String authType = 'BEARER';
        String token = 'Bearer '+FSL_WS_OAG.getAccessToken();
        String method = 'POST';
        List<String> contentHdrs = new List<String>{'Content-Type','application/json'};
        Integer timeout = 120;
        String rBody = '';
        FSLCumminsServiceUtility.createHttpRequest(endPoint, authType, token, method, contentHdrs, rBody, timeout);
    }
    
    @isTest
    private static void sendHttpRequest_Test(){
        Test.setMock(HttpCalloutMock.class, new FSLCumminsServiceUtility_Mock_Test());
        HttpRequest req = new HttpRequest();
        FSLCumminsServiceUtility.sendHttpRequest(req);
    }
}