/**********************************************************************
Name: CSS_GetApplicationListScheduler
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for fetching Application list from SIEBEL
on a weekly basis
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        04/10/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_SBL_GetApplicationListScheduler implements Schedulable{
    
global void execute(SchedulableContext sc){
       // CSS_SBL_GetApplicationListBatch getBatch = new CSS_SBL_GetApplicationListBatch();
       // Id batchProcessId = Database.ExecuteBatch(getBatch);
       CSS_SBL_GetApplicationList();
    }
    
     @future (callout=true) 
    static void CSS_SBL_GetApplicationList(){
        //Call FN class here
        CSS_FN_SIEBEL.storeApplicationOrCategoryComplaintList('GetApplicationList');
    }
    
}