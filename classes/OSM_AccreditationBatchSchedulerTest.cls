@isTest
public class OSM_AccreditationBatchSchedulerTest {
	
    static TestMethod void testScheduler() {
         
    OSM_AccreditationInsert_BatchScheduler schClassIns = new OSM_AccreditationInsert_BatchScheduler();
    String schIns = '0 0 22 * * ?'; 
    OSM_AccreditationUpdate_BatchScheduler schClassUpd = new OSM_AccreditationUpdate_BatchScheduler();
    String schUpd = '0 0 23 * * ?'; 
    Test.startTest();
    system.schedule('Test Schedule Ins', schIns, schClassIns);
    system.schedule('Test Schedule Upd', schUpd, schClassUpd);
    Test.stopTest(); 
        
    }
}