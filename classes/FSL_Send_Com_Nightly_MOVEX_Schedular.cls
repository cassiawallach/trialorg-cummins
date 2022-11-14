global class FSL_Send_Com_Nightly_MOVEX_Schedular implements Schedulable {
    global void execute(SchedulableContext sc) {
        FSL_Send_Communication_Nightly_MOVEX Schedularbatch = new FSL_Send_Communication_Nightly_MOVEX();
        database.executebatch(Schedularbatch);
    }
}