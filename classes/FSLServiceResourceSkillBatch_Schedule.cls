global class FSLServiceResourceSkillBatch_Schedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        FSLServiceResourceSkillBatch bthObj = new FSLServiceResourceSkillBatch();
        Database.executeBatch(bthObj, 200);
    }
}