@IsTest
public class CSS_WS_J2A_GetCurrencyExchange_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"message_ifany\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"ConversionRate\": \"150.00\"'+
        '   }'+
        '}';
        CSS_WS_J2A_GetCurrencyExchange obj = CSS_WS_J2A_GetCurrencyExchange.parse(json);
        System.assert(obj != null);
    }
}