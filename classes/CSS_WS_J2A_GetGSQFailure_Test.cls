@IsTest
public class CSS_WS_J2A_GetGSQFailure_Test {
    
    static testMethod void testParse() {
        String json = '{'+
        '    \"DataArea\": ['+
        '        {'+
        '            \"FailureName\": \"ATC 1777\",'+
        '            \"SystemCode\": \"WE\",'+
        '            \"ComponentCode\": \"QP\",'+
        '            \"FailureID\": \"F30007170\",'+
        '            \"FailureMode\": \"ES\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"Air Compressor\",'+
        '            \"SystemCode\": \"QC\",'+
        '            \"ComponentCode\": \"AS\",'+
        '            \"FailureID\": \"F12000000\",'+
        '            \"FailureMode\": \"\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"CAMPAIGN 1631\",'+
        '            \"SystemCode\": \"WE\",'+
        '            \"ComponentCode\": \"QP\",'+
        '            \"FailureID\": \"F30009330\",'+
        '            \"FailureMode\": \"EK\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"Fuel Injector\",'+
        '            \"SystemCode\": \"FI\",'+
        '            \"ComponentCode\": \"AS\",'+
        '            \"FailureID\": \"F05000100\",'+
        '            \"FailureMode\": \"\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"Need To Assign\",'+
        '            \"SystemCode\": \"US\",'+
        '            \"ComponentCode\": \"DU\",'+
        '            \"FailureID\": \"F30011170\",'+
        '            \"FailureMode\": \"\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"Need To Assign\",'+
        '            \"SystemCode\": \"YN\",'+
        '            \"ComponentCode\": \"EB\",'+
        '            \"FailureID\": \"F30011170\",'+
        '            \"FailureMode\": \"\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"Starting Motor\",'+
        '            \"SystemCode\": \"SA\",'+
        '            \"ComponentCode\": \"CD\",'+
        '            \"FailureID\": \"F13000170\",'+
        '            \"FailureMode\": \"\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"TRP 1338\",'+
        '            \"SystemCode\": \"WI\",'+
        '            \"ComponentCode\": \"ES\",'+
        '            \"FailureID\": \"F30010320\",'+
        '            \"FailureMode\": \"JJ\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"Turbocharger Oil Drain Line\",'+
        '            \"SystemCode\": \"LS\",'+
        '            \"ComponentCode\": \"HT\",'+
        '            \"FailureID\": \"F10000170\",'+
        '            \"FailureMode\": \"\"'+
        '        },'+
        '        {'+
        '            \"FailureName\": \"Water Pump\",'+
        '            \"SystemCode\": \"KP\",'+
        '            \"ComponentCode\": \"BD\",'+
        '            \"FailureID\": \"F08000180\",'+
        '            \"FailureMode\": \"\"'+
        '        }'+
        '    ],'+
        '    \"Header\": {'+
        '        \"ReturnCode\": \"ORA-00000\",'+
        '        \"ReturnCodeDescription\": \"Normal, Successful completion.\",'+
        '        \"MessageIdentifier\": \"2-687e77a0-dd8c-11ea-9cde-122ad0d67aa6\",'+
        '        \"Status\": \"SUCCESS\",'+
        '        \"MessageType\": \"S\"'+
        '    }'+
        '}';
        CSS_WS_J2A_GetGSQFailure obj = CSS_WS_J2A_GetGSQFailure.parse(json);
        System.assert(obj != null);
    }
    
}