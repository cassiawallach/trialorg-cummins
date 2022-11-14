@isTest
public class CG_GetMarketingAppCodeScheduler_Test {
    static testMethod void CG_GetMarketingAppCodeScheduler_Test() {
        test.startTest();
        CG_GetMarketingAppCodeScheduler sh1 = new CG_GetMarketingAppCodeScheduler();      
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        test.stopTest();
    }
}