global class FSL_Send_Com_Nightly_BMS_Schedular implements Schedulable {
    global void execute(SchedulableContext sc) {
        FSL_Send_Communication_Nightly_BMS Schedularbatch = new FSL_Send_Communication_Nightly_BMS();
        database.executebatch(Schedularbatch);
    }
}