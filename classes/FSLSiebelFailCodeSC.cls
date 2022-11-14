global class FSLSiebelFailCodeSC implements Schedulable {
    global void execute(SchedulableContext sc) {
        FSL_SiebelWSbatch ST = new FSL_SiebelWSbatch();
        Database.executeBatch(ST, 50);
    }
}