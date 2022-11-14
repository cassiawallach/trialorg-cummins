/**********************************************************************
Name: CG_SPCertification
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
global class CG_SPCertificationScheduler implements Schedulable/*, Database.AllowsCallouts, Database.Batchable<sObject>*/{
    
global void execute(SchedulableContext sc){
      getSPCertificationData();
    }

    @future(callout=true)
    public static void getSPCertificationData(){
        System.debug('<----- inside CG_GetSPInfoScheduler ------>');
        CSS_FN_SIEBEL.getSPCertificationData();
    }
}