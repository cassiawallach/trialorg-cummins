/**********************************************************************
Name: CG_SendClaimInfo_Schedule
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for scheduling the batch CG_SendClaimInfoBatch.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Shanthi         05/29/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
global with sharing class CG_SendClaimInfo_Schedule implements Schedulable
{
    global void execute(SchedulableContext sc) 
    {  
        CG_SendClaimInfoBatch batch = new CG_SendClaimInfoBatch(); 
        Database.executeBatch(batch,5);
        
        
        
        /*String day = string.valueOf(system.now().day());
        String month = string.valueOf(system.now().month());
        String hour = string.valueOf(system.now().hour());
        String minute = string.valueOf(system.now().minute() + 1);
        String second = string.valueOf(system.now().second());
        
        String strJobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month;
        String strSchedule = '0 ' + minute + ' ' + hour + ' ' + day + ' ' + month + ' ?';
        System.schedule(strJobName, strSchedule, new CG_SendClaimInfo_Schedule());*/
    }
}