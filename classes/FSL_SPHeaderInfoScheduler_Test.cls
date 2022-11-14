@isTest
public class FSL_SPHeaderInfoScheduler_Test
{
    static testMethod void FSL_SPHeaderInfoScheduler_Test()
    {
        Test.startTest();
        FSL_SPHeaderInfoScheduler spHeaderSch = new FSL_SPHeaderInfoScheduler();
        string spHeaderCExp = '0 0 23 * * ?';
        system.schedule('FSL SP Header Info Scheduler', spHeaderCExp, spHeaderSch); 
        Test.stoptest();
    }
}