@IsTest
public class CSS_WS_J2A_CreateStatementMX_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '   \"Header\": {'+
        '       \"Status\": \"success\",'+
        '       \"ReturnCodeDescription\": \"message_ifany\"'+
        '   },'+
        '   \"DataArea\": {'+
        '       \"MsgTransaction\": \"msg_transaction\",'+
        '       \"MsgDescription\": \"msg_description\"'+
        '   }'+
        '}';
        CSS_WS_J2A_CreateStatementMX obj = CSS_WS_J2A_CreateStatementMX.parse(json);
        System.assert(obj != null);
    }
}