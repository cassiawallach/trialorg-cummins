/**********************************************************************
Name: FSL_SPHeaderInfoScheduler
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch of FSL_SPHeaderInfoBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  	AUTHOR                 DATE                DETAIL                                 
1.0     Anvesh Reddy Sama         04/02/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class FSL_SPHeaderInfoScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {  
        FSL_SPHeaderInfoBatch SPHeaderBatch = new FSL_SPHeaderInfoBatch(); 
        Database.executeBatch(SPHeaderBatch);
    }
}