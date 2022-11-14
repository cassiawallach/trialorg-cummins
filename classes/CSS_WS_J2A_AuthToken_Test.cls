@IsTest
public class CSS_WS_J2A_AuthToken_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"token_type\": \"Bearer\",'+
        '    \"expires_in\": \"3599\",'+
        '    \"ext_expires_in\": \"3599\",'+
        '    \"expires_on\": \"1594741866\",'+
        '    \"not_before\": \"1594737966\",'+
        '    \"resource\": \"https://api-ue-devnf-aw-ex.cummins.com/cmi/warranty\",'+
        '    \"access_token\": \"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsIng1duzxnWHDhAaiWXj4tP4uK513RtyXllUpy7x0Vhf50BHxw\"'+
        '}';
        CSS_WS_J2A_AuthToken obj = CSS_WS_J2A_AuthToken.parse(json);
        System.assert(obj != null);
    }
}