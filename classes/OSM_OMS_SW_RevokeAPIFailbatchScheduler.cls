/************************************************************
Name:  OSM_OMS_SW_RevokeAPIFailbatchScheduler
Copyright © 2018  Cummins
=============================================================
=============================================================
Purpose:                                                            
This batch class will be used to schedule the Revoke API failre batch.
============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma        22nd Feb 2019     INITIAL DEVELOPMENT          


*************************************************************/

global class OSM_OMS_SW_RevokeAPIFailbatchScheduler implements Schedulable{
    
    global void execute(SchedulableContext SC){
        OSM_OMS_SW_RevokeAPIFailurebatch bjobs = new OSM_OMS_SW_RevokeAPIFailurebatch();
        database.executebatch(bjobs,1);
    }
    
}