/******************************************************************************************************
Name: FSL_TimesheetTrigger 
Description: Timesheet Trigger.

Version                 Date                    Author                      Summary Of Change
------------------------------------------------------------------------------------------------------- 
1.0                                             Cummins                     Trigger created          
2.0                 7/8/2020                    Vinod                       Added before insert context.
3.0                 7/13/2020                   Ravikanth                  added code for Time overlap
4.0                 10/06/2020                   Ravikanth                  Added code for CT2-157
******************************************************************************************************/
 
trigger FSL_TimesheetTrigger on FSL_Timesheet__c (before insert, before update,after insert, after update) {
    if(FSL_CL_TimesheetTriggerHandler.runTrigger){
        if(trigger.isBefore && trigger.isInsert) {
            FSL_CL_TimesheetTriggerHandler.beforeInsert(Trigger.New);
            FSL_CL_TimesheetTriggerHandler.resourceTimeOverlap(Trigger.New,Trigger.oldMap);//Added code for CT2-28 BY Mallika
           
        }
        
          
        if(trigger.isBefore && trigger.isUpdate) {
          //  FSL_CL_TimesheetTriggerHandler.beforeUpdate(Trigger.newMap, Trigger.oldMap);
           FSL_CL_TimesheetTriggerHandler.resourceTimeOverlap(Trigger.New,Trigger.oldMap);
           //FSL_CL_TimesheetTriggerHandler.stopSubmittingTimesheets(Trigger.New,Trigger.oldMap)//Commented by Krishna to disable the Sequencing logic for TS
            FSL_CL_TimesheetTriggerHandler.beforeUpdateTS(Trigger.New, Trigger.oldMap); 
    
        }
    
        if(trigger.isAfter && trigger.isInsert) {
            FSL_CL_TimesheetTriggerHandler.afterInsert(Trigger.New);
            //FSL_CL_UpdateActualSRT.updateActualSRTFromTrigger(Trigger.New,Trigger.oldMap); Commented By Krishna as Srt functionality should be disabled for cico
          //FSL_CL_TimesheetTriggerHandler.insertFSLSRT(Trigger.New);// Added Ravikanth CT2-332 Commented By Krishna as Srt functionality should be disabled for cico
            FSL_CL_TimesheetTriggerHandler.calculateRollupsOnInsert(Trigger.New); //mallika  MV-228
        }
        
        if(trigger.isAfter && trigger.isUpdate) {
        FSL_CL_TimesheetTriggerHandler.afterUpdate(Trigger.New, Trigger.oldMap); 
    
        //FSL_CL_TimesheetTriggerHandler.postToChatterOnServiceOrder(Trigger.New,Trigger.oldMap); Commented by Akansha for MV-602
            //FSL_CL_UpdateActualSRT.updateActualSRTFromTrigger(Trigger.New,Trigger.oldMap);Commented By Krishna as Srt functionality should be disabled for cico
            
            //PB to trigger //Added changes for CT2-1206 Karthik Pedditi 01/04/2021
            if(FSL_CL_TimesheetTriggerHandler.firstRun){
                FSL_CL_TimesheetTriggerHandler.allocatenewTimesheets(Trigger.New,Trigger.oldMap);
                FSL_CL_TimesheetTriggerHandler.firstRun=false;
            }
             FSL_CL_TimesheetTriggerHandler.calculateRollupsOnUpdate(Trigger.New,Trigger.oldMap);//mallika MV-228
             FSL_CL_TimesheetTriggerHandler.calculateRollupsOnDelete(Trigger.old);//mallika  MV-228
            
        } 
       
    }

}