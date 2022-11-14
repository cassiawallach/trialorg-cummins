/******************************************************************************************************
Name : FSL_MaintenancePlanTrigger  
Description : Maintenance Plan object Trigger.
Description2 : Using this trigger to add WorkType to the new Maintenance Plan record

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                   04/03/2021                  Harish                             Trigger created 

*********************************************************************************************************/
trigger FSL_MaintenancePlanTrigger on MaintenancePlan (before insert, before update, after insert, after update) {
    if(!FSL_MaintenancePlanTriggerHandle.isExecuting){						//To avoid trigger recurssion
        if(Trigger.isbefore && Trigger.isInsert){							// Before Insert
            FSL_MaintenancePlanTriggerHandle.maintenancePlanBeforeInsert(Trigger.new);
            FSL_MaintenancePlanTriggerHandle.isExecuting = true;
        }
    }
}