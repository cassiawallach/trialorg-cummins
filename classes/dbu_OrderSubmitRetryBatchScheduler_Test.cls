@isTest
public class dbu_OrderSubmitRetryBatchScheduler_Test {
    
    public static testMethod void testschedule() {
        
        Test.StartTest();
        SchedulableContext sc;
        dbu_OrderSubmitRetryBatchScheduler sh1 = new dbu_OrderSubmitRetryBatchScheduler();
        sh1.execute(sc);
        //String sch = '0 0 3 * * ?';
        //system.schedule('Test  Check', sch, sh1); 
        Test.stopTest(); 
    }  
    
    
}