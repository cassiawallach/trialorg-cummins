@IsTest
public class CSS_WS_J2A_ClaimReliability_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"messageIdentifier\": \"1-306d8891-dda1-11eb-8a11-022059974d50\",'+
        '  \"returnCode\": \"201\",'+
        '  \"returnCodeDescription\": \"Created\",'+
        '  \"status\": \"Success\",'+
        '  \"message\": \"2 claim header records inserted into CLAIM_CSV_DAILY_LOADER table and 2 claim parts records inserted into CLAIM_CSV_PART_LOADER table\"'+
        '}';
        CSS_WS_J2A_ClaimReliability obj = CSS_WS_J2A_ClaimReliability.parse(json);
        System.assert(obj != null);
    }
    
}