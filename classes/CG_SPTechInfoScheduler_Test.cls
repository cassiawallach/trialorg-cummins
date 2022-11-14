@isTest
public class CG_SPTechInfoScheduler_Test {
    
    static TestMethod void testScheduler() {
         
    CG_SPTechInfoScheduler schClass = new CG_SPTechInfoScheduler();
    String sch = '0 0 23 * * ?'; 
    Test.startTest();
    system.schedule('Test Schedule', sch, schClass); 
    Test.stopTest(); 
   }

}