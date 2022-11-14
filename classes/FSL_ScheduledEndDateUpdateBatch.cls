global class FSL_ScheduledEndDateUpdateBatch implements Database.Batchable<sObject>{
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        Datetime nextHour = Datetime.now().addHours(1);
        Datetime currentTime = Datetime.now();
        String query= 'SELECT Id,SchedEndTime,Extend_Scheduled_EndDate__c  FROM ServiceAppointment WHERE SchedEndTime <= :nextHour AND SchedEndTime >:currentTime';
        return Database.getQueryLocator(query); 
    }
    global void execute(Database.BatchableContext bc, List<ServiceAppointment> scope)
    {
        List<ServiceAppointment> SRlist = new List<ServiceAppointment>();
        for(ServiceAppointment SR: scope)
        {
            SR.Extend_Scheduled_EndDate__c = true;
            system.debug('SR Id###'+SR.Id);
            SRlist.add(SR);
        }
        List<Database.SaveResult> SaveResultList = Database.update(SRlist,false);  
        /*for (Database.SaveResult sr : SaveResultList) {
            if (!sr.isSuccess()) {                
                for(Database.Error err : sr.getErrors()) {
                }
            }
            else {
            }
        }*/
    }
    
    global void finish(Database.BatchableContext bc)
    {
        
    }
}