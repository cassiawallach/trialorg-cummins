@isTest
public class CG_SPHeaderInfoScheduler_Test {
    
    static TestMethod void testScheduler() {
         
    CG_SPHeaderInfoScheduler schClass = new CG_SPHeaderInfoScheduler();
    String sch = '0 0 23 * * ?'; 
    Test.startTest();
    system.schedule('Test Schedule', sch, schClass); 
    Test.stopTest(); 
   }
}