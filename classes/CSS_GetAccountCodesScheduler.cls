/**********************************************************************
Name: CSS_GetAccountCodesScheduler
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
1.0     Rajkumar BT        05/09/2017     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_GetAccountCodesScheduler implements Schedulable{

      global void execute(SchedulableContext sc){ 
        CSS_SBL_GetAccountCodesBatch insBatch = new CSS_SBL_GetAccountCodesBatch();
        Id batchProcessId = Database.ExecuteBatch(insBatch);
    }
    
}