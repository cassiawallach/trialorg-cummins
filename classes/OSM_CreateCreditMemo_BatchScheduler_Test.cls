@isTest
public class OSM_CreateCreditMemo_BatchScheduler_Test{
    static TestMethod void methodScheduler(){
        String schIns = '0 0 22 * * ?'; 
        Test.startTest();
        OSM_CreateCreditMemo_BatchScheduler ccmSchdl = new OSM_CreateCreditMemo_BatchScheduler();
        system.schedule('Test Schedule Ins', schIns, ccmSchdl);
        Test.stopTest();
    }
}