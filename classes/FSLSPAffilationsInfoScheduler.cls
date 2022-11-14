/**********************************************************************
Name: FSLSPAffilationsInfoScheduler
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch of FSLSPAffilationsInfoBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/31/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class FSLSPAffilationsInfoScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {  
        FSLSPAffilationsInfoBatch batch = new FSLSPAffilationsInfoBatch(); 
        Database.executeBatch(batch);
    }
}