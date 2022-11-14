public with sharing class FSL_CreateServiceAppointments{
    
    @AuraEnabled
    public static void CreateServiceAppointment(String inputParams){
        String dmlError;
        try{
            inputParams params = (inputParams)JSON.deserialize(inputParams, inputParams.class);
            
            WorkOrder Service_Order = [SELECT Id, AccountId, ServiceTerritoryId, WorkTypeId FROM WorkOrder WHERE Id =:params.serviceOrderId LIMIT 1]; 
            if(Service_Order != null){
                List<ServiceAppointment> ServiceAppointmentList = new List<ServiceAppointment>();
                system.debug('params++++'+params);
                if(params.techAppointments != null && params.techAppointments > 0){
                    for(Integer i=0; i<params.techAppointments; i++){
                        ServiceAppointment serviceAppointmentObj = getServiceAppointment(params, Service_Order, 'TECH');                        
                        serviceAppointmentObj.Is_a_Tech_Appointment__c = true;
                        ServiceAppointmentList.add(serviceAppointmentObj);
                    }
                }
                if(params.bayAppointments != null && params.bayAppointments > 0){
                    for(Integer i=0; i<params.bayAppointments; i++){
                        ServiceAppointment serviceAppointmentObj = getServiceAppointment(params, Service_Order, 'BAY');                        
                        serviceAppointmentObj.Is_a_Bay_Area_Appointment__c = true;
                        ServiceAppointmentList.add(serviceAppointmentObj);
                    }
                }
                system.debug('ServiceAppointmentList++++'+ServiceAppointmentList);
                if(!ServiceAppointmentList.isEmpty()){
                     try{
                        insert ServiceAppointmentList;}
                    catch(DmlException e){
                        dmlError  = e.getDMLMessage(e.getNumDMl()-1);
                        throw new AuraHandledException(dmlError);
                        
                    }
                   
                }
            }
        }catch(exception e){
            system.debug('error while creating ServiceAppointments: '+ e.getMessage() +' get line '+e.getLineNumber());
             if(string.isNotBlank(dmlError))
                throw new AuraHandledException(dmlError);
            else throw new AuraHandledException(e.getMessage());
            
        }
        
    }
    
    private static ServiceAppointment getServiceAppointment(inputParams params, WorkOrder Service_Order, String Type){
        ServiceAppointment serviceAppointmentObj = new ServiceAppointment();
        if(Type == 'TECH'){
            serviceAppointmentObj.Duration = params.techDuration;
        }else if(Type == 'BAY'){
            serviceAppointmentObj.Duration = params.bayDuration;
        }
        serviceAppointmentObj.DurationType = 'Hours';
        serviceAppointmentObj.Status = 'None';
        serviceAppointmentObj.ParentRecordId = params.serviceOrderId;
        serviceAppointmentObj.Service_Order__c = params.serviceOrderId;
        serviceAppointmentObj.ServiceTerritoryId = Service_Order.ServiceTerritoryId;
        return serviceAppointmentObj;
    }
    
    public class inputParams{
        @InvocableVariable
        public String serviceOrderId;
        
        @InvocableVariable
        public Integer techAppointments;
        
        @InvocableVariable
        public decimal techDuration;
        
        @InvocableVariable
        public Integer bayAppointments;
        
        @InvocableVariable
        public decimal bayDuration;
    }
    
}