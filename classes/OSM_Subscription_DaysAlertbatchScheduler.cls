/*****************************************************************
Name:  OSM_Subscription_DaysAlertbatchScheduler
Copyright © 2019  Cummins
==================================================================
==================================================================
Purpose:                                                            
this is scheduler for OSM_Subscription_DaysAlertbatch
==================================================================
==================================================================
History                                                            
-------                                                            
VERSION  AUTHOR                 DATE              DETAIL                                
1.0 -   Neha Sharma         01/09/2019     INITIAL DEVELOPMENT          

******************************************************************/
global class OSM_Subscription_DaysAlertbatchScheduler implements Schedulable{
    
    global void execute(SchedulableContext SC){
        OSM_Subscription_DaysAlertbatch bjobs = new OSM_Subscription_DaysAlertbatch();
        database.executebatch(bjobs,1);
    }
    
}