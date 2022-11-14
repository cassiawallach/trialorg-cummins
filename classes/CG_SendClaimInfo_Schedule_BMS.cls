/**********************************************************************
Name: CG_SendClaimInfo_Schedule_BMS
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch CG_SendClaimInfoBatch_BMS.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Rajkumar BT      06/13/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class CG_SendClaimInfo_Schedule_BMS implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {  
        CG_SendClaimInfoBatch_BMS batch = new CG_SendClaimInfoBatch_BMS(); 
        Database.executeBatch(batch,40);
    }
}