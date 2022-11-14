/**********************************************************************
Name: CG_SPClaimHistory_Schedule
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch CG_SPClaimHistoryBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE                DETAIL                                 
1.0     Krishnamoorthi         07/23/2019           INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class CG_SPClaimHistory_Schedule implements Schedulable {
    global void execute(SchedulableContext sc) {  
        CG_SPClaimHistoryBatch batch = new CG_SPClaimHistoryBatch(); 
        Database.executeBatch(batch,50);
    }
}