/***********************************************************************
VERSION  AUTHOR            		DATE                DETAIL                                 
1.0     Kalpana        07/03/2018    INITIAL DEVELOPMENT
***********************************************************************/
                                       
@istest
public class CG_ClaimsQueueable_Test 
{
	static testMethod void TestMethod1() 
    {
        Id jobId; 
        String sysCode='test';
        String compCode='test'; 
        Id compId; 
        String campNum='test';
        Boolean selcomp = true;
        list<CG_BL_Campaigns.CampaignsWrapper> cwList=new list <CG_BL_Campaigns.CampaignsWrapper>();
        for(Integer i = 0 ;i<10;i++)
        {
            CG_BL_Campaigns.CampaignsWrapper cmp = new CG_BL_Campaigns.CampaignsWrapper(null,syscode,compcode,null,campnum,selcomp);
             cwList.add(cmp);
        }
        CG_ClaimsQueueable sjq1=new CG_ClaimsQueueable(cwList);
        System.enqueueJob(sjq1);
        System.assertNotEquals(null, cwList.size());
    }
}