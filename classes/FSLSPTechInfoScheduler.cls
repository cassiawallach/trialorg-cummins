/**********************************************************************
Name: FSLSPTechInfoScheduler
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch of FSLSPTechInfoBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/31/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class FSLSPTechInfoScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {  
        FSLSPTechInfoBatch batch = new FSLSPTechInfoBatch(); 
        Database.executeBatch(batch);
    }
}