/*
 * Block comments with details of changes
 */
global class CG_GetMarketingAppCodeScheduler implements Schedulable 
{
    global void execute(SchedulableContext sc)
    {
     getApplicationCodes();   
    }
    @future(callout=true)
    public static void getApplicationCodes()
    {
         CSS_FN_SIEBEL.getApplicationCodesData();
    }
}