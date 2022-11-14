/**********************************************************************
Name: CSS_GetTechInfoScheduler
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for fetching Get Tech Information from Siebel system
on a weekly basis
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Surender M       01/22/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CSS_GetTechInfoScheduler implements Schedulable/*, Database.AllowsCallouts, Database.Batchable<sObject>*/{
    
global void execute(SchedulableContext sc){  
        getTechInfoData();
   		//getSPInfoData();
    }

    @future(callout=true)
    public static void getTechInfoData(){
        System.debug('<----- inside CSS_GetTechInfoScheduler ------>');
        CSS_FN_SIEBEL.getTechInfoData();
    }
    
    /*@future(callout=true)
    public static void getSPInfoData(){
        System.debug('<----- inside getSPInfoData ------>');
        CSS_FN_SIEBEL.getSPInfoData();
    }*/
}