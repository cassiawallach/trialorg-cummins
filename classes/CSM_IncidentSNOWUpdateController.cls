public class CSM_IncidentSNOWUpdateController {
    @AuraEnabled public static responseWrapper getIncidentStatus(String recordId){
        responseWrapper resp=new responseWrapper();
        Try{
            List<Incident>incidentList=[Select Id,Status, IncidentNumber,CSM_Ticket_Incident_Number__c,SNow_Last_Synched_Date__c,Service_Request__c FROM Incident WHERE Service_Request__c =:recordId AND Status!=:'Closed Complete' AND CSM_Ticket_Incident_Number__c!=null ];
            if(!incidentList.isEmpty()){
                string token=CSM_IncidentSNOWUpdateService.getAuthenticationToken();
                for(Incident inc:incidentList){
                    HttpResponse response= CSM_IncidentSNOWUpdateService.doCallout(inc,token);  
                    CSM_SNOWResponsedata responseWrapper ;
                    if (response.getStatusCode() == 200) {
                        String responseJson = response.getBody();
                        if(string.isNotBlank(responseJson)){
                            responseWrapper = CSM_SNOWResponsedata.parse(responseJson);
                            inc.SNow_Last_Synched_Date__c=system.now();
                            inc.Status = responseWrapper.result.State;
                            resp.syncIncident= resp.syncIncident +' '+inc.CSM_Ticket_Incident_Number__c;
                        }
                    }
                    else {
                        resp.failedIncident=resp.syncIncident +' '+inc.CSM_Ticket_Incident_Number__c;  
                    }
                }
                update incidentList; 
            }
            system.debug('responseWrapper==='+resp);
            return resp;
        }
        catch(Exception ex){
            resp.systemError=ex.getMessage();
            return resp;
        }
    }
    public class responseWrapper{
      @AuraEnabled  public String syncIncident='';
      @AuraEnabled  public string failedIncident='';
      @AuraEnabled  public string systemError='';
    }
    //this comments use for deployment purpose  and support to misisng cmp
}