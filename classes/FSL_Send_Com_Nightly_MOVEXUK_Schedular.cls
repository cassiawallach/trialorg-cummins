global class FSL_Send_Com_Nightly_MOVEXUK_Schedular implements Schedulable {
    global void execute(SchedulableContext sc) {
        FSL_Send_Communication_Nightly_MOVEXUK Schedularbatch = new FSL_Send_Communication_Nightly_MOVEXUK();
        database.executebatch(Schedularbatch);
    }
}