@isTest
public class CG_SPCertificationScheduler_Test {
    
    static TestMethod void testScheduler() {
         
    CG_SPCertificationScheduler schClass = new CG_SPCertificationScheduler();
    String sch = '0 0 23 * * ?'; 
    Test.startTest();
    system.schedule('Test Schedule', sch, schClass); 
    Test.stopTest(); 
   }
}