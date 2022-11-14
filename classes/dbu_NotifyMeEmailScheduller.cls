global class dbu_NotifyMeEmailScheduller implements Schedulable{
	
    global void execute(SchedulableContext yt){
        dbu_SendNotifyMeEmailsBatch sendNotifyMeEmails = new dbu_SendNotifyMeEmailsBatch();
        database.executeBatch(sendNotifyMeEmails, 25); 
    }
}