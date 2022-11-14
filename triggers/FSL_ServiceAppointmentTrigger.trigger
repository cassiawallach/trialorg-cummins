/******************************************************************************************************
Name : ServiceAppointment 
Description : ServiceAppointment Trigger.

Version                 Date                    Author                      Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                                             Cummins                       Trigger created          
2.0                   06/25/2021               Vijay/Rajkumar                 Added logic to avoid Trigger Recursion
*********************************************************************************************************/

trigger FSL_ServiceAppointmentTrigger on ServiceAppointment (before insert, after insert, before update, after update) {
    if(trigger.isBefore && trigger.isInsert) {
        FSL_ServiceAppointmentTriggerHandler.ServiceAppointmentHandlerBeforeInsert(Trigger.New);
    }
    
    if(trigger.isBefore && trigger.isUpdate) {
        //Added below IF condition to avoid trigger recursion
        if(RecursiveTriggerHandler.isSABeforeUpdate == true){
            RecursiveTriggerHandler.isSABeforeUpdate = false;
            FSL_ServiceAppointmentTriggerHandler.ServiceAppointmentHandlerBeforeUpdate(Trigger.NewMap, Trigger.oldMap);
        }
    }
    
    /*** if(trigger.isAfter && trigger.isInsert) {
        // Bharat - 101, this method is required only when SA.Status changed to 'Scheduled'
        FSL_ServiceAppointmentTriggerHandler.ServiceAppointmentHandlerAfterInsert(Trigger.New);
    } ***/
    
     if(trigger.isAfter && trigger.isInsert) {
        // Bharat - 101, this method is required only when SA.Status changed to 'Scheduled'
        //FSL_ServiceAppointmentTriggerHandler.FSLScheduledStartUpdateOnWorkOrder(Trigger.NewMap,Trigger.oldMap);
    } 
    
    if(trigger.isAfter && trigger.isUpdate) {
        //Added below IF condition to avoid trigger recursion
        if(RecursiveTriggerHandler.isSAAfterUpdate == true){
            RecursiveTriggerHandler.isSAAfterUpdate = false;
            
            ServiceAppointment saNew = trigger.new.get(0);
            ServiceAppointment saold = trigger.old.get(0);
            // if(FSL_ServiceAppointmentTriggerHandler.isAfterUpdateExecutingRecurssive == true) {
            //FSL_ServiceAppointmentTriggerHandler.ServiceAppointmentUserSharing(trigger.new, trigger.oldMap);//commented out by Viren to check the 10001 error - this is trying to insert 10k rows
            FSL_ServiceAppointmentTriggerHandler.ServiceAppointmentUserSharing(trigger.new, trigger.oldMap);//uncommented by Mallika to ensure existing functionality in prod. is not impacted
            FSL_ServiceAppointmentTriggerHandler.ServiceAppointmentHandlerAfterUpdate(trigger.newMap, trigger.oldMap);
            FSL_ServiceAppointmentTriggerHandler.SendTechnicianInfoToANVL(trigger.newMap, trigger.oldMap); //CT3-198
            FSL_ServiceAppointmentTriggerHandler.createForms(trigger.new, trigger.oldMap);
            
            //ServiceAppointmentTriggerHandler.ServiceAppointmentHandlerAfterUpdate(trigger.newMap,trigger.oldMap);
            // FSL_ServiceAppointmentTriggerHandler.isAfterUpdateExecutingRecurssive=false;
            // }
            //Commented below line of code as it is allowing recursive and causing 101 exception 
            //FSL_ServiceAppointmentTriggerHandler.SAHandlerAfterUpdateAllowsRecursive(trigger.newMap, trigger.oldMap);
            
        }
    }
}