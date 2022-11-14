@IsTest
public class CSS_WS_J2A_GetSRTOverlap2_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"DataArea\": {'+
        '    \"TotalOverlapHours\": 2.1,'+
        '    \"Steps\": ['+
        '      {'+
        '        \"Qty\": 1,'+
        '        \"OverlapTime\": ['+
        '          {'+
        '            \"SRTNumber\": \"\",'+
        '            \"OverlapHrs\": 0'+
        '          }'+
        '        ],'+
        '        \"SRTHours\": 0.3,'+
        '        \"SRTAdjustedHours\": 0.2,'+
        '        \"StepId\": 134357,'+
        '        \"AccessCode\": \"C\"'+
        '      },'+
        '      {'+
        '        \"Qty\": 2,'+
        '        \"OverlapTime\": ['+
        '          {'+
        '            \"SRTNumber\": \"\",'+
        '            \"OverlapHrs\": 0'+
        '          }'+
        '        ],'+
        '        \"SRTHours\": 0.9,'+
        '        \"SRTAdjustedHours\": 1.8,'+
        '        \"StepId\": 134072,'+
        '        \"AccessCode\": \"C\"'+
        '      }'+
        '    ],'+
        '    \"TotalAdjustedHours\": 2'+
        '  },'+
        '  \"Header\": {'+
        '    \"ReturnCodeDescription\": \"Normal, Successful completion.\",'+
        '    \"ReturnCode\": \"ORA-00000\",'+
        '    \"Status\": \"Error\",'+
        '    \"MessageIdentifier\": \"S\"'+
        '  }'+
        '}';
        CSS_WS_J2A_GetSRTOverlap2 obj = CSS_WS_J2A_GetSRTOverlap2.parse(json);
        System.assert(obj != null);
    }
}