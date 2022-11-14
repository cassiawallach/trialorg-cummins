global class FSLSMNDTCsSC implements Schedulable {
    global void execute(SchedulableContext sc) {        
        FSLSMNDTCBatchProcess ST = new FSLSMNDTCBatchProcess();
        Database.executeBatch(ST, 10);
    }
}