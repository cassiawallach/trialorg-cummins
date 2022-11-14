@isTest
public class FSLStepDescriptionResp_Test {
    
    static testMethod void testParse() {
        String Json = '{"DataArea":{"CaseResponse":[{"SRTAccessCode":"C","SRTGroupProcedure":"00-102","SRTTime":6,"SRTContent":"Module from equipment","SRTTitle":"Engine Module - Remove and Install"}]},"Header":{"Status":"Success","ReturnCodeDescription":""}}';
        FSLStepDescriptionResp obj = FSLStepDescriptionResp.parse(Json);
        System.assert(obj != null);
    }
}