/*
 * Block comments with details of changes
 */
public class CG_ClaimsQueueable implements Queueable, Database.AllowsCallouts 
{
    list<CG_BL_Campaigns.CampaignsWrapper> cwList;

    public CG_ClaimsQueueable(list<CG_BL_Campaigns.CampaignsWrapper> cwList) 
    {
        this.cwList = cwList;
    }

    public void execute(QueueableContext context) 
    {
        Integer num=0;
        List<CG_BL_Campaigns.CampaignsWrapper> fireLst = new List<CG_BL_Campaigns.CampaignsWrapper>();
        for(CG_BL_Campaigns.CampaignsWrapper wrap : cwList){
            num++;
            if(num==10)
            {
                String temp = JSON.serialize(fireLst);
                CG_BL_Campaigns.getAccountCodesforClaims(temp);
                fireLst = new List<CG_BL_Campaigns.CampaignsWrapper>();
                num=0;
            }
            fireLst.add(wrap);
        }

        if(num<10)
        {
            String temp = JSON.serialize(fireLst);
            CG_BL_Campaigns.getAccountCodesforClaims(temp);
            fireLst = new List<CG_BL_Campaigns.CampaignsWrapper>();
            num=0;
        }
        //for(CG_BL_Campaigns.CampaignsWrapper cw : cwList) {
        //CG_BL_Campaigns.getAccountCodes(cw.jobId, cw.sysCode, cw.compCode, cw.compId, cw.campNum);
        //}
        //CG_BL_Campaigns.getAccountCodes(jobId, sysCode, compCode, compId, campNum);
    }
}