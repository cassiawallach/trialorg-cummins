@isTest
public class CG_CL_ClaimsPOCComp_Test{
    public static testMethod void CG_CL_ClaimsPartsandOtherClaimblesComp_Method(){
         Test.startTest();
        CG_CL_ClaimsPartsandOtherClaimblesComp po = new CG_CL_ClaimsPartsandOtherClaimblesComp();
        po.getallCustomPartsData();
        po.AddRow();
        po.removingRow();
        po.saveOtherClaimables();
        po.getItems();
        po.getfailcodeDropDown();
        po.getAccountCodeDropDown();
    }

    
    
}