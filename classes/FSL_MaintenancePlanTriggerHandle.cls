/**********************************************************************
Name: FSL_MaintenancePlanTriggerHandle
Copyright Â© 2021  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Harish       01/20/2019      INITIAL DEVELOPMENT- Add WorkType to the Maintenance Plan record
***********************************************************************/
public class FSL_MaintenancePlanTriggerHandle {
	public static boolean isExecuting = false;
    public static void maintenancePlanBeforeInsert(list<MaintenancePlan> newMPs){
        WorkType pmWorkType = new WorkType();
        try{
        pmWorkType = [select id, name from WorkType where name ='PM' LIMIT 1];
        for(MaintenancePlan mpObj : newMPs){
            mpObj.WorkTypeId = pmWorkType.id;
        }
        } catch(Exception ee){
            system.debug('Exception'+ee);
        }
        
    }
}