/**********************************************************************
Name: CG_SPAffiliations
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
global class CG_SPAffiliationsScheduler implements Schedulable/*, Database.AllowsCallouts, Database.Batchable<sObject>*/{
    
global void execute(SchedulableContext sc){
      getSPAffiliationData();
    }

    @future(callout=true)
    public static void getSPAffiliationData(){
        System.debug('<----- inside CG_GetSPInfoScheduler ------>');
        CSS_FN_SIEBEL.getSPAffiliationData();
    }
}