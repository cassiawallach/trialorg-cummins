@IsTest
public class CSS_WS_J2A_GetFailCodes_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"DataArea\": {'+
        '    \"Details\": ['+
        '      {'+
        '        \"Active\": \"Y\",'+
        '        \"BusinesUnit\": \"CMI\",'+
        '        \"ServiceGroupCode\": \"19\",'+
        '        \"UpdatedDate\": \"2019-04-03T03:15:07.000-05:00\",'+
        '        \"SystemCode\": \"DS\",'+
        '        \"ComponentCode\": \"JH\",'+
        '        \"FailureName\": \"\",'+
        '        \"SystemName\": \"DIGI SOL\",'+
        '        \"ComponentName\": \"JUMPER HARNESS\",'+
        '        \"Created\": \"2019-04-03T03:15:07.000-05:00\"'+
        '      }'+
        '    ]'+
        '  },'+
        '  \"Header\": {'+
        '    \"Status\": \"Success\",'+
        '    \"ReturnCode\": \"\",'+
        '    \"ReturnCodeDescription\": \"\",'+
        '    \"MessageIdentifier\": \"1523f642-7862-4db1-a9ed-52fbfeb24623\"'+
        '  }'+
        '}';
        CSS_WS_J2A_GetFailCodes obj = CSS_WS_J2A_GetFailCodes.parse(json);
        System.assert(obj != null);
    }
}