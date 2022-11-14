/**********************************************************************
Name: FSLSPProductRangeScheduler
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch of FSLSPProductRangeBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         03/31/2020           INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class FSLSPProductRangeScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {  
        FSLSPProductRangeBatch batch = new FSLSPProductRangeBatch(); 
        Database.executeBatch(batch);
    }
}