@isTest
public class CG_CL_DeleteClaimRecordScheduler_Test {
	
    static TestMethod void testScheduler() {
         
    CG_CL_DeleteClaimRecordScheduler schClass = new CG_CL_DeleteClaimRecordScheduler();
    String sch = '0 0 23 * * ?'; 
    Test.startTest();
    system.schedule('Test Schedule', sch, schClass); 
    Test.stopTest(); 
        
    }
}