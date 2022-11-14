global class OSM_SW_SubExpBatchScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        System.debug('hey');
        OSM_SW_SubscriptionExpirationBatch  bjobs = new OSM_SW_SubscriptionExpirationBatch();
        database.executebatch(bjobs,1);
        /*String str = '0 0 13 * * ?' ;  //Everyday at 1AM
        OSM_SW_SubExpBatchScheduler b = new OSM_SW_SubExpBatchScheduler();
        if(Test.isRunningTest()) {
            system.schedule('Update Job Test', str, b);
        }
        else {
            system.schedule('Update Job', str, b);
        }*/
    }
}