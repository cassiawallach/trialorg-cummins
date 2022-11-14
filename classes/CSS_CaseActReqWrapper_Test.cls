@isTest
public class CSS_CaseActReqWrapper_Test {
    static testMethod void ActReqWrapperTest(){ 
        Test.startTest();
        CSS_CaseActReqWrapper obj = new CSS_CaseActReqWrapper();
        obj.actionType = 'Act';
        CSS_CaseActReqWrapper.CaseProperties csProp = new CSS_CaseActReqWrapper.CaseProperties();
        csProp.caseIndexInResultSet = 0.1;
        csProp.caseName = 'CaseName';
        obj.CaseProperties = csProp;
        String json = CSS_CaseActReqWrapper.parse(obj);        
        Test.stopTest();
    }
}