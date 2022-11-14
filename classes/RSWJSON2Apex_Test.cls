@IsTest
public class RSWJSON2Apex_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"DataArea\": {'+
        '    \"CSSJobIdRecords\": {'+
        '      \"CSSJobIdRecord\": ['+
        '        {'+
        '          \"CSSJobId\": \"CSSJobId_1\",'+
        '          \"ControlNumbers\": {'+
        '            \"ControlNumber\": ['+
        '              \"111111\",'+
        '              \"22222\"'+
        '            ]'+
        '          }'+
        '        },'+
        '        {'+
        '          \"CSSJobId\": \"CSSJobId_1\",'+
        '          \"ControlNumbers\": {'+
        '            \"ControlNumber\": ['+
        '              \"33333\",'+
        '              \"444444\"'+
        '            ]'+
        '          }'+
        '        }'+
        '      ]'+
        '    }'+
        '  }'+
        '}';
        RSWJSON2Apex obj = RSWJSON2Apex.parse(json);
        System.assert(obj != null);
    }
}