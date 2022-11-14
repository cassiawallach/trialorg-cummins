@isTest
public class OSM_UpdateOrderCancel_BatchSched_Test{
    static TestMethod void methodScheduler(){
        String schIns = '0 0 22 * * ?'; 
        Test.startTest();
        OSM_UpdateOrderCancel_BatchScheduler ccmSchdl = new OSM_UpdateOrderCancel_BatchScheduler();
        system.schedule('Test Schedule Ins', schIns, ccmSchdl);
        Test.stopTest();
    }
}