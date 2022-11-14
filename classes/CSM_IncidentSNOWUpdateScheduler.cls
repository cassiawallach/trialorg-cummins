global class CSM_IncidentSNOWUpdateScheduler  implements Schedulable {
    global void execute(SchedulableContext sc) {
        DateTime currentTime = System.now();
        List<Incident>incidentList=[Select Id,Status, IncidentNumber,CSM_Ticket_Incident_Number__c,SNow_Last_Synched_Date__c from Incident Where Status!='Closed Complete' AND CSM_Ticket_Incident_Number__c!=null AND SNow_Last_Synched_Date__c <: currentTime LIMIT 50 ];
        if(!incidentList.isEmpty()){
        System.enqueueJob(new CSM_IncidentSNOWUpdateQueueable(incidentList,CSM_IncidentSNOWUpdateService.getAuthenticationToken()));
        }
    }
   //this is Missing cmp for SFDC SNOW functionality
}