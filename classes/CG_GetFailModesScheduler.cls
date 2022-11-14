global class CG_GetFailModesScheduler implements Schedulable/*, Database.AllowsCallouts*/{
 global void execute(SchedulableContext sc){  
        getFailModesData();
    }
    @future(callout=true)
    public static void getFailModesData(){
       CSS_FN_SIEBEL.getFailModes();
    }
}