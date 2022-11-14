@isTest
public class CG_GetFailModesScheduler_Test {
    static testmethod void TestFailModes(){
        test.startTest();
         CG_GetFailModesScheduler sh1 = new CG_GetFailModesScheduler();      
         String sch = '0  00 1 3 * ?';
           system.schedule('Test', sch, sh1);
        test.stopTest();       
    }

}