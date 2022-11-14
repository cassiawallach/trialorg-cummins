//Adding comment for deployment -- Akansha MV_688 8/25/2022

@IsTest
public class FSL_DiagTargetTimeResponse_Test {
     static testMethod void testParse() {
        String json = '{'+
        ' \"Header\": {'+
        '  \"ReturnCodeDescription\": \"02400-02394\",'+
        '  \"MessageType\": \"MessageType\",'+
        '  \"Status\": \"Status\",'+
        '  \"ReturnCode\": \"ReturnCode\",'+
        '  \"MessageIdentifier\": \"MessageIdentifier\"'+
        ' },'+
        ' \"Solutions\": {'+
        '  \"SolutionId\": \"SolutionId\",'+
        '  \"DiagnosticTargetTime\": \"DiagnosticTargetTime\",'+
        '  \"TargetMessage\": \"TargetMessage\"'+
        ' },'+
        ' \"DataArea\": {'+
        '    \"Solutions\": [ {'+
        '    \"SolutionId\": \"CECO\",'+
        '    \"DiagnosticTargetTime\": \"431894700\",'+
        '    \"TargetMessage\": \"TargetMessage\"} ,'+
        '     {'+
        '    \"SolutionId\": \"CECO\",'+
        '    \"DiagnosticTargetTime\": \"431894700\",'+
        '    \"TargetMessage\": \"TargetMessage\"} '+
        ']'+
        '}'+
        '}';
        FSL_DiagTargetTimeResponse obj = FSL_DiagTargetTimeResponse.parse(json);
        System.assert(obj != null);
    }
}