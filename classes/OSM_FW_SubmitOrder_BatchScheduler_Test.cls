// updated by sharad 13th sept 21
// updated by Ashish 22/03/2022
@isTest
private class OSM_FW_SubmitOrder_BatchScheduler_Test {
    static testMethod void test_Scheduler(){
        Test.startTest();
        SchedulableContext sc;
        OSM_FW_SubmitOrder_BatchScheduler schdlr = new OSM_FW_SubmitOrder_BatchScheduler();
        schdlr.execute(sc);
        Test.stopTest();
    }   
}