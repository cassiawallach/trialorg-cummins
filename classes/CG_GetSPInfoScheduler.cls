/**********************************************************************
Name: CG_GetSPInfoScheduler
Copyright © 2018  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for fetching Get SP Information from Siebel system
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Surender M       04/04/2018     INITIAL DEVELOPMENT                    
***********************************************************************/
global class CG_GetSPInfoScheduler implements Schedulable/*, Database.AllowsCallouts, Database.Batchable<sObject>*/{
    
global void execute(SchedulableContext sc){
        getSPInfoData();
    }

    @future(callout=true)
    public static void getSPInfoData(){
        System.debug('<----- inside CG_GetSPInfoScheduler ------>');
        CSS_FN_SIEBEL.getSPInfoData();
    }
}