@istest
public class CG_CL_Standard_Header2_Test {
    static testmethod void testmethod1()
    {
        CG_CL_Standard_Header2 nw = new  CG_CL_Standard_Header2();
        
        pageReference pager = page.CG_CreateClaims;
        Test.setCurrentPage(pager);
        nw.redirectAction();
        
        pageReference pager1 = page.CSS_globalSearch;
        Test.setCurrentPage(pager1);
        nw.redirectglobal();
        
        
    }

}