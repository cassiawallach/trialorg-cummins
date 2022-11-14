public class CSM_IncidentSNOWUpdateQueueable implements Queueable,Database.AllowsCallouts {
    public List<Incident> incidents;
    public string token;
    public CSM_IncidentSNOWUpdateQueueable(List<Incident> records,String token) {
        this.incidents = records;
        this.token=token;
    }
    public void execute(QueueableContext context) {
        for (Incident inc : incidents) {
            if(limits.getLimitCallouts()!=limits.getCallouts()){
                HttpResponse response= CSM_IncidentSNOWUpdateService.doCallout(inc,token); 
                CSM_SNOWResponsedata responseWrapper ;
                if (response.getStatusCode() == 200) {
                    String responseJson = response.getBody();
                    if(string.isNotBlank(responseJson)){
                        responseWrapper = CSM_SNOWResponsedata.parse(responseJson);
                        inc.SNow_Last_Synched_Date__c=system.now();
                        inc.Status = responseWrapper.result.State;
                    }
                }
            }  
        }
        update incidents;
    }
    //this comments use for deployment.suport to missing cmp
}