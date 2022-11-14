global class FSL_ScheduleEndDateUpdate implements Schedulable{
    global void execute(SchedulableContext sc) {
        //invoke the batch class
        Database.executeBatch(new FSL_ScheduledEndDateUpdateBatch());
    }
}