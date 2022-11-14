/*
 * Block comments with details of changes
 */
public class CG_JobRepairSRTQueueable implements Queueable, Database.AllowsCallouts 
{
    List<String> srtWrapper;

    public CG_JobRepairSRTQueueable(list<string> srtWrapper) 
    {
        this.srtWrapper = srtWrapper;
    }

    public void execute(QueueableContext context) 
    {
        CSS_SRT.repairSRT(srtWrapper);
    }
}