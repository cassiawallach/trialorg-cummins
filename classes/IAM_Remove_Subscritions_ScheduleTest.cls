@isTest
public class IAM_Remove_Subscritions_ScheduleTest{
    @isTest
    static void testRemoveSchedule(){
        Test.startTest();
        IAM_Remove_Subscritions_Schedule sh1 = new IAM_Remove_Subscritions_Schedule();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test Territory Check', sch, sh1); 
        Test.stopTest();
          
    }
}