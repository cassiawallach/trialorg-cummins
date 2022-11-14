@isTest
public class CSS_SBL_GetFailCodesBatch_Test {
    static testMethod void CSS_SBL_GetFailCodesBatch_Test() {
        test.startTest();
        CSS_SBL_GetFailCodesBatch sh1 = new CSS_SBL_GetFailCodesBatch();      
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        test.stopTest();
    }
}