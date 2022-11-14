@isTest
public class CSS_J2ASolution_Test {
    
    // This test method should give 100% coverage
    static testMethod void testParse() {
        // String json = '{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is <strong>not</strong> the first fault code that should be diagnosed.  <br />","verification":"<strong>Conditions</strong> <ul><li>Turn keyswitch ON.</li><li>Connect INSITE™ electronic service tool.</li></ul><strong>Action</strong><br />Check for active fault codes. <ul><li>Use INSITE™ electronic service tool to read the fault codes.</li></ul><strong>Specification</strong> <ul><li>If Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.</li></ul>","resolution":"<p>Perform a search on the appropriate fault code.</p>","poleLogicSolution":false}';
        //string json = '{ "status": "success",  "modificationDate": "01/02/2016",  "verification": "<strong>Conditions</strong> <ul><li>Turn keyswitch ON.</li><li>Connect INSITE™ electronic service tool.</li></ul><strong>Action</strong><br />Check for active fault codes. <ul><li>Use INSITE™ electronic service tool to read the fault codes.</li></ul><strong>Specification</strong> <ul><li>If Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.</li></ul>","resolution": "<p>Perform a search on the appropriate fault code.</p>","repCompoundSolutions": [{} ],  "solutionNumber": "K74452217","poleLogicSolution": true,"verCompoundSolutions": [{}],"solutionTitle": "Fault Code 122 triggered by another fault code","coreIssue": "There are some instances when a fault code is recorded, but is <strong>not</strong> the first fault code that should be diagnosed.  <br />","components": [{"value": "string","failureId": "string"}]}';
        string json = '{"key":"1234","message":"This is a test","messageArg":["a","b"],"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}],"repCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}],"verCompoundSolutions":[{"solutionNumber":"K74452217","solutionTitle":"Fault Code 122 triggered by another fault code","coreIssue":"There are some instances when a fault code is recorded, but is strongnotstrong the first fault code that should be diagnosed.  br ","modificationDate":"01022016","status":"success","verification":"strongConditionsstrong ulliTurn keyswitch ON.liliConnect INSITE electronic service tool.liulstrongActionstrongbr Check for active fault codes. ulliUse INSITE electronic service tool to read the fault codes.liulstrongSpecificationstrong ulliIf Fault Code 227, 352, or 386 is active, then perform a search on the appropriate fault and troubleshoot that fault prior to troubleshooting Fault Code 122.liul","resolution":"pPerform a search on the appropriate fault code.p","poleLogicSolution":true,"components":[{"value":"string","failureId":"string"}]}]}';
        CSS_J2ASolution_EDS r = CSS_J2ASolution_EDS.parse(json);
        System.assert(r != null);
        r.key = '1243';
        r.message = '123';
        r.messageArg[0]='1234';
        r.solutionNumber = 'ABC';
        r.solutionTitle ='123';
        r.coreIssue = 'ab';
        r.modificationDate = '12';
        r.status =  '12';
        r.verification = '123';
        r.resolution = '123';
        r.poleLogicSolution = false;
        r.Components[0].failureId = '123';
        r.Components[0].value = '1234';
        r.verCompoundSolutions[0].solutionNumber = '123';
        r.verCompoundSolutions[0].solutionTitle ='123';
        r.verCompoundSolutions[0].coreIssue = 'ab';
        r.verCompoundSolutions[0].modificationDate = '12';
        r.verCompoundSolutions[0].status =  '12';
        r.verCompoundSolutions[0].verification = '123';
        r.verCompoundSolutions[0].resolution = '123';
        r.verCompoundSolutions[0].poleLogicSolution = false;
        r.verCompoundSolutions[0].components[0].failureId = '123';
        r.verCompoundSolutions[0].components[0].value ='1234';
        r.repCompoundSolutions[0].solutionNumber = '123';
        r.repCompoundSolutions[0].solutionTitle ='123';
        r.repCompoundSolutions[0].coreIssue = 'ab';
        r.repCompoundSolutions[0].modificationDate = '12';
        r.repCompoundSolutions[0].status =  '12';
        r.repCompoundSolutions[0].verification = '123';
        r.repCompoundSolutions[0].resolution = '123';
        r.repCompoundSolutions[0].poleLogicSolution = false;
        r.repCompoundSolutions[0].components[0].failureId = '123';
        r.repCompoundSolutions[0].components[0].value ='1234';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].solutionNumber = '123';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].solutionTitle ='123';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].coreIssue = 'ab';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].modificationDate = '12';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].status =  '12';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].verification = '123';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].resolution = '123';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].poleLogicSolution = false;
        //r.repCompoundSolutions[0].verCompoundSolutions[0].components[0].failureId = '123';
        //r.repCompoundSolutions[0].verCompoundSolutions[0].components[0].value ='1234';
    }
}