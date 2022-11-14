@IsTest
public class CSS_WS_J2A_GetGSQSRT_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '  \"DataArea\": {'+
        '    \"CaseResponse\": ['+
        '      {'+
        '        \"AccessCodeD\": 0.2,'+
        '        \"AccessCodeC\": 0,'+
        '        \"SRTDetails\": \"00-400-00\",'+
        '        \"AccessCodeB\": 0,'+
        '        \"SRTAccessCode\": \"D\",'+
        '        \"AccessCodeA\": 0,'+
        '        \"S6Desc\": \"\",'+
        '        \"Assignment\": \"PRIMARY\",'+
        '        \"S9Desc\": \"\",'+
        '        \"SRTDesc\": \"Steam Clean - Single\\nComponent Replacemt\",'+
        '        \"SRTTime\": 0.2,'+
        '        \"S1Desc\": \"\",'+
        '        \"S5Desc\": \"\",'+
        '        \"S3Desc\": \"\",'+
        '        \"S8Desc\": \"\",'+
        '        \"SRTQuantity\": 1,'+
        '        \"AccessCodeS1\": 0,'+
        '        \"SRTTitle\": \"Steam Clean - Single Component Repair\",'+
        '        \"S4Desc\": \"\",'+
        '        \"FailureID\": \"F12000000\",'+
        '        \"VerifyRepeatValue\": {'+
        '          \"SRTEventPerfDateTime\": \"\",'+
        '          \"SRTType\": \"\",'+
        '          \"Step\": {'+
        '            \"StepID\": 89620,'+
        '            \"Percentage\": 0,'+
        '            \"SRTModifyDateTime\": \"\",'+
        '            \"StepDescription\": ['+
        '              \"Steam Clean - Single\\nComponent Replacemt\"'+
        '            ]'+
        '          }'+
        '        },'+
        '        \"AccessCodeS8\": 0,'+
        '        \"AccessCodeS9\": 0,'+
        '        \"AccessCodeR\": 0.2,'+
        '        \"AccessCodeS6\": 0,'+
        '        \"S2Desc\": \"\",'+
        '        \"AccessCodeS7\": 0,'+
        '        \"SRTMessage\": \"\",'+
        '        \"AccessCodeS4\": 0,'+
        '        \"AccessCodeS5\": 0,'+
        '        \"AccessCodeS2\": 0,'+
        '        \"AccessCodeS3\": 0,'+
        '        \"FailureName\": \"Air Compressor\",'+
        '        \"S7Desc\": \"\"'+
        '      },'+
        '      {'+
        '        \"AccessCodeD\": 1.1,'+
        '        \"AccessCodeC\": 0,'+
        '        \"SRTDetails\": \"12-001-00\",'+
        '        \"AccessCodeB\": 0,'+
        '        \"SRTAccessCode\": \"D\",'+
        '        \"AccessCodeA\": 0,'+
        '        \"S6Desc\": \"\",'+
        '        \"Assignment\": \"PRIMARY\",'+
        '        \"S9Desc\": \"\",'+
        '        \"SRTDesc\": \"Repair Manual)\\n\\nIncludes:\\n\\n -Drain and fill cooling system\\n -Disconnect and connect:\\n  . Batteries\\n  . Coolant hoses to compressor\\n  . Air tubes to compressor\\n  . Oil tubes to compressor\\n -Remove and install:\\n  . Support bracket\\n  . Air compressor\\n -Clean and visually check gasket surfaces and\\n  parts removed\\n -Check antifreeze concentration\\n -Operate engine to check for leaks and proper\\n  operation\\n(Refer to the appropriate Troubleshooting and\",'+
        '        \"SRTTime\": 1.1,'+
        '        \"S1Desc\": \"\",'+
        '        \"S5Desc\": \"\",'+
        '        \"S3Desc\": \"\",'+
        '        \"S8Desc\": \"\",'+
        '        \"SRTQuantity\": 1,'+
        '        \"AccessCodeS1\": 0,'+
        '        \"SRTTitle\": \"Air Compressor (All Models) - Remove and Install, (Common Rail Fuel System)\",'+
        '        \"S4Desc\": \"\",'+
        '        \"FailureID\": \"F12000000\",'+
        '        \"VerifyRepeatValue\": {'+
        '          \"SRTEventPerfDateTime\": \"\",'+
        '          \"SRTType\": \"\",'+
        '          \"Step\": {'+
        '            \"StepID\": 89791,'+
        '            \"Percentage\": 0,'+
        '            \"SRTModifyDateTime\": \"\",'+
        '            \"StepDescription\": ['+
        '              \"Repair Manual)\\n\\nIncludes:\\n\\n -Drain and fill cooling system\\n -Disconnect and connect:\\n  . Batteries\\n  . Coolant hoses to compressor\\n  . Air tubes to compressor\\n  . Oil tubes to compressor\\n -Remove and install:\\n  . Support bracket\\n  . Air compressor\\n -Clean and visually check gasket surfaces and\\n  parts removed\\n -Check antifreeze concentration\\n -Operate engine to check for leaks and proper\\n  operation\\n(Refer to the appropriate Troubleshooting and\"'+
        '            ]'+
        '          }'+
        '        },'+
        '        \"AccessCodeS8\": 0,'+
        '        \"AccessCodeS9\": 0,'+
        '        \"AccessCodeR\": 0.7,'+
        '        \"AccessCodeS6\": 0,'+
        '        \"S2Desc\": \"\",'+
        '        \"AccessCodeS7\": 0,'+
        '        \"SRTMessage\": \"\",'+
        '        \"AccessCodeS4\": 0,'+
        '        \"AccessCodeS5\": 0,'+
        '        \"AccessCodeS2\": 0,'+
        '        \"AccessCodeS3\": 0,'+
        '        \"FailureName\": \"Air Compressor\",'+
        '        \"S7Desc\": \"\"'+
        '      }'+
        '    ],'+
        '    \"ResponseMessage\": \"\"'+
        '  },'+
        '  \"Header\": {'+
        '    \"Status\": \"Success\",'+
        '    \"ReturnCodeDescription\": \"\"'+
        '  }'+
        '}';
        CSS_WS_J2A_GetGSQSRT obj = CSS_WS_J2A_GetGSQSRT.parse(json);
        System.assert(obj != null);
    }
}