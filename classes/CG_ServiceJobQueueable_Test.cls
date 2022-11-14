/*Though covered this can be fully understood at https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_class_System_Queueable.htm#apex_class_System_Queueable*/
/**********************************************************************
Name: CG_ServiceJobQueueable_Test
Copyright © 2017  Cummins
History                                                            
-------                                                            
VERSION  AUTHOR            		DATE                DETAIL                                 
1.0     Rupesh Pande        07/03/2018    INITIAL DEVELOPMENT
***********************************************************************/
@istest
public class CG_ServiceJobQueueable_Test 
{
	static testMethod void TestMethod1() 
    {
        Id jobId; 
        String sysCode='test';
        String compCode='test'; 
        Id compId; 
        String campNum='test';
        list<CG_BL_Campaigns.CampaignsWrapper> cwList=new list <CG_BL_Campaigns.CampaignsWrapper>();
        for(Integer i = 0 ;i<10;i++)
        {
            CG_BL_Campaigns.CampaignsWrapper cmp = new CG_BL_Campaigns.CampaignsWrapper(jobId,syscode,compcode,compId,campnum,true);
             cwList.add(cmp);
        }
        CG_ServiceJobQueueable sjq1=new CG_ServiceJobQueueable(cwList);
        System.enqueueJob(sjq1);
        System.assertNotEquals(null, cwList.size());
    }
}