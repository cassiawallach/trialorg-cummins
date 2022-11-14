@isTest
public class dbu_ReturnOrderSubmitRetrySched_Test {
    
    public static testMethod void testschedule() {
        
        Test.StartTest();
        SchedulableContext sc;
        dbu_ReturnOrderSubmitRetryBatchScheduler sh1 = new dbu_ReturnOrderSubmitRetryBatchScheduler();
         sh1.execute(sc);
        //String sch = '0 0 3 * * ?';
        //system.schedule('Test  Check', sch, sh1); 
        Test.stopTest(); 
    }  
    
    
}