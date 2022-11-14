@istest
public class CG_SPClaimHistoryBatchScheduler_Test 
{
	static testmethod void testScheduledJob() 
    {
    Test.startTest();
	CG_SPClaimHistoryBatchScheduler sh1 = new CG_SPClaimHistoryBatchScheduler();
	String sch = '0 0 23 * * ?'; system.schedule('Claim History Batch Scheduler', sch, sh1); 
    Test.stoptest();
    }
}