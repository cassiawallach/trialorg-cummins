@isTest
public class CSS_SBL_GetCatCompScheduler_Test {
	
    static TestMethod void testScheduler() {
         
    CSS_SBL_GetCategoryComplaintScheduler schClass = new CSS_SBL_GetCategoryComplaintScheduler();
    String sch = '0 0 23 * * ?'; 
    Test.startTest();
    system.schedule('Test Schedule', sch, schClass); 
    Test.stopTest(); 
        
    }
}