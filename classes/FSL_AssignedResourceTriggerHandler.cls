/**********************************************************************
Name: FSL_AssignedResourceTriggerHandler
Copyright Â© 2021  Cummins
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 -                                   INITIAL DEVELOPMENT
2.0 - Vijay/Rajkumar      07/09/2021    To Update Assigned Resource on Service Appointment
***********************************************************************/
public class FSL_AssignedResourceTriggerHandler {
    
    public static void updateSATechandBay( Map<Id, AssignedResource> oldMap, Map<Id, AssignedResource> newMap) {
        
        Set<Id> setARId = new Set<Id>();
        Set<Id> setSRId = new Set<Id>();
        List<ServiceAppointment> lstServiceAppointment = new List<ServiceAppointment>();
        List<ServiceAppointment> lstServiceAppointmentsToUpdate = new List<ServiceAppointment>();
        List<ServiceResource> lstServiceResource = new List<ServiceResource>();
        Map<Id,ServiceAppointment> IdVsSerAppointmentMap= new Map<Id,ServiceAppointment>();
        
        for(AssignedResource ARSA : newMap.values()){
            setARId.add(ARSA.ServiceAppointmentId);
            setSRId.add(ARSA.ServiceResourceId);
        }
        
        lstServiceAppointment = [Select Id, Is_a_Bay_Area_Appointment__c, Is_a_Tech_Appointment__c from ServiceAppointment where Id IN: setARId];
        lstServiceResource = [Select Id, Is_a_Bay_Area__c, Is_a_Tech__c from ServiceResource where Id IN : setSRId];
        
        for(AssignedResource AR : newMap.values()){
            for(ServiceAppointment SA : lstServiceAppointment){
                if(AR.ServiceAppointmentId == SA.Id){
                    ServiceAppointment saRec = new ServiceAppointment();
                    saRec.Id = SA.Id;
                    saRec.Assigned_ServiceResource__c = AR.ServiceResourceId;
                    system.debug('Bay--'+AR.ServiceResource.Is_a_Bay_Area__c+' Tech--'+AR.ServiceResource.Is_a_Tech__c);
                    if(SA.Is_a_Bay_Area_Appointment__c == false && SA.Is_a_Tech_Appointment__c == false){
                        for(ServiceResource SR : lstServiceResource){
                            if(AR.ServiceResourceId == SR.Id){
                                saRec.Is_a_Bay_Area_Appointment__c = SR.Is_a_Bay_Area__c;
                                saRec.Is_a_Tech_Appointment__c = SR.Is_a_Tech__c;
                            }
                        }
                    }
                    
                     if(saRec != null && !lstServiceAppointmentsToUpdate.contains(saRec)){
                        lstServiceAppointmentsToUpdate.add(saRec);
                        IdVsSerAppointmentMap.put(saRec.Id,saRec);
                    }
                }
            }
        }
        
        system.debug('lstServiceAppointmentsToUpdate--'+lstServiceAppointmentsToUpdate);
        if(lstServiceAppointmentsToUpdate != null){
            //update lstServiceAppointmentsToUpdate;
            update IdVsSerAppointmentMap.values();
        }
    }
}