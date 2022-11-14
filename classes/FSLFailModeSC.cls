global class FSLFailModeSC implements Schedulable {
    global void execute(SchedulableContext sc) {        
        FSLFailModeBatch ST = new FSLFailModeBatch();
        Database.executeBatch(ST, 10);
    }    
}