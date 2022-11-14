@IsTest
public class CSS_WS_J2A_ClaimSubmission_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"message_ifany\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"ClaimNumber\": \"1234567890\",'+
        '       \"Status\": \"Success/Error\",'+
        '       \"ErrorMessage\": \"Error Message if any...\"'+
        '   }'+
        '}';
        CSS_WS_J2A_ClaimSubmission obj = CSS_WS_J2A_ClaimSubmission.parse(json);
        System.assert(obj != null);
    }
}