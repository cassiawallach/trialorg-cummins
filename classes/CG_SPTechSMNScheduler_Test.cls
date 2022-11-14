@isTest
public class CG_SPTechSMNScheduler_Test {
    
    static TestMethod void testScheduler() {
         
    CG_SPTechSMNScheduler schClass = new CG_SPTechSMNScheduler();
    String sch = '0 0 23 * * ?'; 
    Test.startTest();
    system.schedule('Test Schedule', sch, schClass); 
    Test.stopTest(); 
   }

}