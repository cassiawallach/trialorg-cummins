public with Sharing class FSL_GanttCloneSAController{
    public String resourceId {get;set;}//create variables for parameter values and allow access from VF page
    public ServiceAppointment serAppointmentRec{get;set;}
    public ServiceAppointment serAppointmentCloneRec{get;set;}
    
    public FSL_GanttCloneSAController()
    {
        resourceId = apexpages.currentpage().getparameters().get('id');//initializing variables to parameter values from the related apex page (VF page that launched via console custom action)
        System.debug('resourceId##'+resourceId);
        serAppointmentRec = [SELECT SchedStartTime, SchedEndTime,ParentRecordId,EarliestStartTime,DueDate,Duration,Description,Status,Is_a_Tech_Appointment__c,FSL__IsMultiDay__c,Assigned_ServiceResource__c,Assigned_ServiceResource__r.Id,Assigned_ServiceResource__r.ServiceCrew.Name,
                                                Assigned_ServiceResource__r.ResourceType,AppointmentNumber,Assigned_ServiceResource__r.Name 
                                                FROM ServiceAppointment 
                                                WHERE Id = :resourceId LIMIT 1];
        serAppointmentCloneRec = serAppointmentRec;
     }
    
    
    public PageReference saveAppointment() {
        Boolean validationCheck = false;
        system.debug('started##');
        ServiceAppointment saObj = new ServiceAppointment();
        saObj.SchedStartTime = serAppointmentRec.SchedStartTime;
        saObj.Duration = serAppointmentRec.Duration;
        if(serAppointmentRec.Duration !=null){
            saObj.SchedEndTime = saObj.SchedStartTime + (serAppointmentRec.Duration*60)/1440;
        }
        saObj.EarliestStartTime = serAppointmentRec.EarliestStartTime;
        saObj.DueDate = serAppointmentRec.DueDate;
        saObj.ParentRecordId = serAppointmentRec.ParentRecordId;
        saObj.Status = 'Scheduled';
        system.debug('started2 ##');
        saObj.Description = serAppointmentRec.Description;
        saObj.Is_a_Tech_Appointment__c = serAppointmentRec.Is_a_Tech_Appointment__c;
        //saObj.FSL__IsMultiDay__c = serAppointmentRec.FSL__IsMultiDay__c;
        if(serAppointmentRec !=null && serAppointmentRec.Assigned_ServiceResource__c !=null){
            saObj.Assigned_ServiceResource__c = serAppointmentCloneRec.Assigned_ServiceResource__c;
        }
        system.debug('saObj##'+saObj);
        try{
            insert saObj; //insert serAppointmentCloneRec;
            system.debug('after saObj##'+saObj);
            //creating AssignedResource record
            AssignedResource arRef = new AssignedResource();
            arRef.ServiceAppointmentId=saObj.Id;
            arRef.ServiceResourceId= saObj.Assigned_ServiceResource__c;//serAppointmentCloneRec.Assigned_ServiceResource__c;
            insert arRef;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Confirm,'Cloning of Service Appointment is successful.'));
        }catch(DmlException ex){
            system.debug('after ex##'+ex);
            ApexPages.addMessages(ex); 
        }
        return null;
    }
    
}