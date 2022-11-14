@IsTest
public class CSS_RSWJSON2Apex_Test {

    static testMethod void testParse() {
        String json = '{'+
        '  \"DataArea\": {'+
        '    \"CSSJobIdRecords\": {'+
        '      \"CSSJobIdRecord\": ['+
        '        {'+
        '          \"CSSJobId\": \"CSSJobId_1\",'+
        '          \"ControlNumbers\": {'+
        '            \"ControlNumber\": ['+
        '             \"111111\",'+
        '              \"22222\"'+
        '            ]'+
        '          }'+
        '        },'+
        '        {'+
        '          \"CSSJobId\": \"CSSJobId_1\",'+
        '          \"ControlNumbers\": {'+
        '            \"ControlNumber\": ['+
        '              \"33333\"]'+
        '          }'+
        '        }'+
        '      ]'+
        '    }'+
        '  }'+
        '}';
        CSS_RSWJSON2Apex obj = CSS_RSWJSON2Apex.parse(json);
        System.assert(obj != null);
    }
}