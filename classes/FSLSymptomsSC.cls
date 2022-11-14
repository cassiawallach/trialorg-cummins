global class FSLSymptomsSC implements Schedulable {
    global void execute(SchedulableContext sc) {        
        FSLSymptomUpdatesBatchProcess ST = new FSLSymptomUpdatesBatchProcess();
        Database.executeBatch(ST, 50);
    }
}