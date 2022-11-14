/*
 * Block comments with details of changes
 */
global class CG_MiscChargeLOV_Scheduler implements Schedulable
{
     global void execute(SchedulableContext sc) 
    {  
          CG_SL_BMS.getMISCChargeLOVs('03520','04892','03520-04892');//Hardcoded as the list of values will not change based on location but we have to pass some location
     }
    
}