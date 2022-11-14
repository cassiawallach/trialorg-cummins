@isTest
public class CG_SPClaimHistory_Schedule_Test {
    
    static TestMethod void testScheduler() {
        
        CG_SPClaimHistory_Schedule schClass = new CG_SPClaimHistory_Schedule();
        String sch = '0  00 1 3 * ?';
        Test.startTest();
        system.schedule('Test Schdule', sch, schClass);
        Test.stopTest(); 
    }
    
}