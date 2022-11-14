@IsTest
public class OSM_WS_ScheduleSubCancellation_Test {

    //static testmethod void testMethod1(){
    
    //Test.StartTest();
    //OSM_WS_ScheduleSubscriptionCancellation.scheduleIntegration();
    //OSM_WS_ScheduleSubscriptionCancellation sh1 = new OSM_WS_ScheduleSubscriptionCancellation();
    //String sch = '0 0 * * * ?'; 
    //system.schedule('Test Territory Check', sch, sh1);
     //Test.stopTest();
  //}
    
    static testmethod void testMethod2(){
    
    Test.StartTest();
    
OSM_WS_DA_ScheduleBatchJobs.scheduleIntegration();
        
        
 Test.stopTest();
  }
    
    }