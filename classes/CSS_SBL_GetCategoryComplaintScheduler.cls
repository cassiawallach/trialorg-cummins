/**********************************************************************
Name: CSS_SBL_GetCategoryComplaintScheduler
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This is used for fetching Category/Complaint list from SIEBEL
on a weekly basis
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Surender M        04/11/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_SBL_GetCategoryComplaintScheduler implements Schedulable{
    
    global void execute(SchedulableContext sc){
       // CSS_SBL_GetCategoryComplaintBatch getBatch = new CSS_SBL_GetCategoryComplaintBatch();
       // Id batchProcessId = Database.ExecuteBatch(getBatch);
       CSS_SBL_GetCategoryComplaintList();
    }
    
      @future (callout=true) 
     static void CSS_SBL_GetCategoryComplaintList(){
        
       CSS_FN_SIEBEL.storeApplicationOrCategoryComplaintList('GetComplaintsList');
    }
      
    
}