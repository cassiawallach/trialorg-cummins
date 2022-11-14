@isTest
public class OSM_AccounGroupScheduler_Test {
    
    public static testMethod void testschedule() {
        
        Test.StartTest();
        OSM_AccounGroupScheduler sh1 = new OSM_AccounGroupScheduler();
        
        String sch = '0 0 3 * * ?';
        system.schedule('Test  Check', sch, sh1); 
        Test.stopTest(); 
    }  
    
    
}