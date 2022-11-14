public with Sharing class FSL_GanttCustomActionsController{
    public String resourceId {get;set;}//create variables for parameter values and allow access from VF page
    public List<ServiceAppointment> crewsServiceAppointment{get;set;}
    public ServiceAppointment parentServiceAppointment{get;set;}
    public ServiceAppointment serAppointmentRec{get;set;}
    public FSL_GanttCustomActionsController()
    {
        resourceId = apexpages.currentpage().getparameters().get('id');//initializing variables to parameter values from the related apex page (VF page that launched via console custom action)
        System.debug('resourceId##'+resourceId);
        crewsServiceAppointment = new List<ServiceAppointment>();
        serAppointmentRec = [SELECT id, SchedStartTime, SchedEndTime,Assigned_ServiceResource__r.Id,Assigned_ServiceResource__r.ServiceCrew.Name,Service_Order__c,
                                                Assigned_ServiceResource__r.ResourceType,FSL_Parent_Crew_SA__c,AppointmentNumber,Assigned_ServiceResource__r.Name,Service_Order__r.WorkOrderNumber
                                                FROM ServiceAppointment 
                                                WHERE Id = :resourceId LIMIT 1];
         crewsServiceAppointment = [SELECT id, SchedStartTime, SchedEndTime,Assigned_ServiceResource__r.Id,Assigned_ServiceResource__r.ServiceCrew.Name,
                                       Assigned_ServiceResource__r.ResourceType,FSL_Parent_Crew_SA__c,AppointmentNumber,Assigned_ServiceResource__r.Name
                                       FROM ServiceAppointment 
                                       WHERE Service_Order__c = :serAppointmentRec.Service_Order__c];
        
    /*    if(serAppointmentRec.FSL_Parent_Crew_SA__c == NULL){
            parentServiceAppointment = serAppointmentRec;
            crewsServiceAppointment = [SELECT id, SchedStartTime, SchedEndTime,Assigned_ServiceResource__r.Id,Assigned_ServiceResource__r.ServiceCrew.Name,
                                       Assigned_ServiceResource__r.ResourceType,FSL_Parent_Crew_SA__c,AppointmentNumber,Assigned_ServiceResource__r.Name,Service_Order_Num__c
                                       FROM ServiceAppointment 
                                       WHERE FSL_Parent_Crew_SA__c = :resourceId];
        }
        else{
            parentServiceAppointment = [SELECT id, SchedStartTime, SchedEndTime,Assigned_ServiceResource__r.Id,Assigned_ServiceResource__r.ServiceCrew.Name,
                                        Assigned_ServiceResource__r.ResourceType,FSL_Parent_Crew_SA__c,AppointmentNumber,Assigned_ServiceResource__r.Name 
                                        FROM ServiceAppointment 
                                        WHERE Id = :serAppointmentRec.FSL_Parent_Crew_SA__c];
            crewsServiceAppointment = [SELECT id, SchedStartTime, SchedEndTime,Assigned_ServiceResource__r.Id,Assigned_ServiceResource__r.ServiceCrew.Name,
                                       Assigned_ServiceResource__r.ResourceType,FSL_Parent_Crew_SA__c,AppointmentNumber,Assigned_ServiceResource__r.Name,
                                       FROM ServiceAppointment 
                                       WHERE FSL_Parent_Crew_SA__c = :serAppointmentRec.FSL_Parent_Crew_SA__c];
        }*/
    }
    
    
    public PageReference saveAppointment() {
        if(crewsServiceAppointment !=null){
            update crewsServiceAppointment;
        }
        /**List<ServiceAppointment> childServiceAppointmentToUpdate = new List<ServiceAppointment>();
        Boolean validationCheck = false;
        Decimal durationHours = calcualteDurationHours(parentServiceAppointment.SchedStartTime,parentServiceAppointment.SchedEndTime);
        system.debug('durationHours##'+durationHours);
        for(ServiceAppointment sr : crewsServiceAppointment){
            if(sr.SchedStartTime < parentServiceAppointment.SchedStartTime || Test.isRunningTest() ){
                validationCheck = true;
            }
            if(sr.SchedStartTime > parentServiceAppointment.SchedEndTime || Test.isRunningTest() ){
                validationCheck = true;
            }
            if(sr.SchedEndTime < parentServiceAppointment.SchedStartTime || Test.isRunningTest() ){
                validationCheck = true;
            }
            if(sr.SchedEndTime > parentServiceAppointment.SchedEndTime || Test.isRunningTest() ){
                validationCheck = true;
            }
        }
        if(validationCheck){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Start and End Date Should lie within Parent Service Appointmenent Schedule'));
        }
        else{
            parentServiceAppointment.Duration = durationHours;
            for(ServiceAppointment sr: crewsServiceAppointment){
                sr.Duration = calcualteDurationHours(sr.SchedStartTime,sr.SchedEndTime);
            	childServiceAppointmentToUpdate.add(sr);
            }
            try{
                update parentServiceAppointment;
                update childServiceAppointmentToUpdate;
            }
            catch(DmlException ex){
                ApexPages.addMessages(ex); 
            }
        }**/
        return null;
    }
    
    public static Decimal calcualteDurationHours(DateTime serAppointmentstart,DateTime serAppointmentEnd) {
        Datetime startDate = serAppointmentstart;
        Datetime endDate = serAppointmentEnd;
        Integer intDays =  startDate.Date().daysBetween(endDate.Date());
        Datetime sameDayEndDate = startDate.addDays(intDays);
        Decimal durationHours = ((endDate.getTime())/1000/60/60) - ((sameDayEndDate.getTime())/1000/60/60);
        durationHours += intDays*24;
        return durationHours;
    }
}