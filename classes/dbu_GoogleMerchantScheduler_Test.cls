@isTest
public class dbu_GoogleMerchantScheduler_Test {
    
    @isTest
     static void testschedule() {
        
        Test.StartTest();
        dbu_GoogleMerchantScheduler obj = new dbu_GoogleMerchantScheduler();
        
        String sch = '0 0 23 * * ?'; 
        system.schedule('Google Merchant Scheduler', sch, obj); 
        Test.stopTest(); }
    
}