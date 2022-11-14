@IsTest
public class CSS_JSON2Apex_Test {
    
    static testMethod void testParse() {
        String json = '{  '+
        '    \"CUSTNAME\" : \"Sam\",'+
        '    \"CJOD\" : \"CC123456\",'+
        '    \"TI\" : \"123ABC\",'+
        '    \"UNT\"  : \"5435\",'+
        '    \"ESN\"       : \"ABCDERDF\",'+
        '    \"ERT\"   : \"123456\",'+
        '    \"TMS\" : \"2012-04-23T18:25:43.511Z\",'+
        '    \"FaultCode\" : ['+
        '        {'+
        '            \"FD\": {'+
        '                \"APD\": null,'+
        '                \"BPD\": null,'+
        '                \"UFD\": {'+
        '                    \"UPA\": [],'+
        '                    \"UPI\": [\"145\",\"845\"]'+
        '                }'+
        '            },'+
        '            \"IMGNM\": \"IMG_Module_0\",'+
        '            \"Mod\": \"0\",'+
        '            \"PAT\": \"N\"'+
        '        }                           '+
        '    ]'+
        '}';
        CSS_JSON2Apex obj = CSS_JSON2Apex.parse(json);
        System.assert(obj != null);
    }
}