@IsTest
public class CSS_WS_J2A_GetPartPrice_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"DataArea\": {'+
        '    \"PartPrice\": \"10.0\"'+
        '  },'+
        '  \"Header\": {'+
        '    \"Status\": \"Success\",'+
        '   \"ReturnCodeDescription\": \"Message if any...\"'+
        '  }'+
        '}';
        CSS_WS_J2A_GetPartPrice obj = CSS_WS_J2A_GetPartPrice.parse(json);
        System.assert(obj != null);
    }
}