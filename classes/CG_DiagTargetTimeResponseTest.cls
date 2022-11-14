@isTest
public class CG_DiagTargetTimeResponseTest {
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
        CG_DiagTargetTimeResponse obj = CG_DiagTargetTimeResponse.parse(json);
        System.assert(obj != null);
    }

}