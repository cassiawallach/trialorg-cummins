/**********************************************************************
Name: CSS_SBL_GetFailCodesBatch
Copyright © 2017  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for fetching Fail codes from Siebel system
on a weekly basis
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            		DATE                DETAIL                                 
1.0      Krishnamoorthi       	01/25/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_SBL_GetFailCodesBatch implements Schedulable, Database.AllowsCallouts {
	
     global void execute(SchedulableContext sc){  
        CSS_FN_SIEBEL.getFailCodes();
    }
}