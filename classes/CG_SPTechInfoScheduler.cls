/**********************************************************************
Name: CG_SPTechInfo
Copyright © 2019  Cummins
=======================================================================
=======================================================================
Purpose:    This class is for fetching Get SP Information from Siebel system
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0      Venkat G       24/06/2019   INITIAL DEVELOPMENT                    
***********************************************************************/
global class CG_SPTechInfoScheduler implements Schedulable/*, Database.AllowsCallouts, Database.Batchable<sObject>*/{
    
global void execute(SchedulableContext sc){
      GetSPTechnicianData();
    }

    @future(callout=true)
    public static void GetSPTechnicianData(){
        System.debug('<----- inside CG_GetSPInfoScheduler ------>');
        CSS_FN_SIEBEL.GetSPTechnicianData();
    }
}