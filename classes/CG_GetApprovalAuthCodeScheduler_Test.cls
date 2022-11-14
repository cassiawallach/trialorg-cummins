@isTest
public class CG_GetApprovalAuthCodeScheduler_Test
{
    static testmethod void TestAppAuthCodes(){
        test.startTest();
        CG_GetApprovalAuthCodeScheduler sh1 = new CG_GetApprovalAuthCodeScheduler();      
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        test.stopTest();       
    }
}