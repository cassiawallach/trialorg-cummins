/*****************************************************************************************************************************
Name : EVL_WOTechnicianTrigger 
Description : Technician / Work_Order_Technicians__c object Trigger.

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                  10/14/2021                 Piyush Rani                       Trigger created 
******************************************************************************************************************************/
trigger EVL_WOTechnicianTrigger on Work_Order_Technicians__c (after Delete, before Delete) {
    if(trigger.isAfter && trigger.isDelete) {
        EVL_WOTechnicianTriggerHandler.deleteSharedRecord(trigger.old);
    }
   //By Priyanka for VGRS2-43
   if(trigger.isBefore && trigger.isDelete) {
        EVL_WOTechnicianTriggerHandler.deleteSOCLose(trigger.old);
    }    

}