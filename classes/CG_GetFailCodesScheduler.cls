global class CG_GetFailCodesScheduler implements Schedulable/*, Database.AllowsCallouts*/{
 global void execute(SchedulableContext sc){  
        getFailCodesData();
    }
    @future(callout=true)
    public static void getFailCodesData(){
       CSS_FN_SIEBEL.getFailCodes();
    }
}