@isTest
public class CG_GetSPInfoTechRespWrap_Test {
    static testMethod void CG_GetSPInfoTechReqWrapper() {
   string json =' {"FirstName":"SIEBEL","LastName":"Cummins","PromotionID":"PromotionID","SP_CODE":"SP_CODE","SP_ROW_ID":"SP_ROW_ID","TECH_ROW_ID":"TECH_ROW_ID"}';
        CG_GetSPInfoTechRespWrap obj = CG_GetSPInfoTechRespWrap.parser(json);
        System.assert(obj != null);
        
    }
}