global class FSLfaultcodesc implements Schedulable {
    global void execute(SchedulableContext sc) {        
          FSLFaultCodeBatchProcess fsrv = new FSLFaultCodeBatchProcess();
          Database.executeBatch(fsrv, 10);
    }    
}