/**********************************************************************
Name: FSL_SPDeleteBatchScheduler
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch of FSL_SPDeleteBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 	DATE                DETAIL                                 
1.0     Anvesh Reddy Sama         05/04/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
//pushing through Git Testing
global with sharing class FSL_SPDeleteBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {  
        FSL_SPDeleteBatch batch = new FSL_SPDeleteBatch(); 
        Database.executeBatch(batch);
    }
}