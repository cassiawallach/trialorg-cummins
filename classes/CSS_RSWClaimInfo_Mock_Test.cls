@istest
public class CSS_RSWClaimInfo_Mock_Test {

    
    static TestMethod void testMockRSWClaimInfo() {
    CSS_RSWClaimInfo_Mock rswclaiminfo = new CSS_RSWClaimInfo_Mock();
        HTTPRequest req = new HTTPRequest();
        	req.setEndpoint('claiminformation123');
            req.setHeader('Content-Type','application/json');
         
        req.setBody('this is body');
            req.setMethod('POST');
    rswclaiminfo.respond(req);
        
        }
    static TestMethod void testMockRSWClaimInfo1() {
    CSS_RSWClaimInfo_Mock rswclaiminfo = new CSS_RSWClaimInfo_Mock();
        HTTPRequest req = new HTTPRequest();
        	req.setEndpoint('RSWClaim');
            req.setHeader('Content-Type','application/json');
         
        req.setBody('this is body');
            req.setMethod('POST');
    rswclaiminfo.respond(req);
        
        }
    static TestMethod void testMockRSWClaimInfo2() {
    CSS_RSWClaimInfo_Mock rswclaiminfo = new CSS_RSWClaimInfo_Mock();
        HTTPRequest req = new HTTPRequest();
        	req.setEndpoint('https://services-dev-oauth.cummins.com/api/oauth/token/css');
        req.setHeader('Content-Type','application/json');
                req.setBody('this is body');
            req.setMethod('POST');
    rswclaiminfo.respond(req);
        
        }
}