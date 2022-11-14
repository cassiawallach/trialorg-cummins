@IsTest
public class CSS_WS_J2A_GetCSSAmount_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"message_ifany\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"Status\": \"Success/Error\",'+
        '       \"ErrorMessage\": \"Error Message if any\"'+
        '   }'+
        '}';
        CSS_WS_J2A_GetCSSAmount obj = CSS_WS_J2A_GetCSSAmount.parse(json);
        System.assert(obj != null);
    }
}