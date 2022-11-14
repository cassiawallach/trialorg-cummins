/*--**************************************************************************
Name:CG_GetApprovalAuthCodeScheduler
Copyright Â© 2018  Cummins
==============================================================================
==============================================================================
Purpose:                                                            
-------  
This class is to schedule getApprovalAuthCode service from CSS_FN_SIEBEL Class
==============================================================================
==============================================================================
History                                                            
-------                                                            
VERSION   AUTHOR          DATE                DETAIL                                 
1.0 -    Vignesh S      10/10/2018      INITIAL DEVELOPMENT                    
******************************************************************************/
global class CG_GetApprovalAuthCodeScheduler implements Schedulable{
    global void execute(SchedulableContext sc){  
        getApprovalAuthCodeData();
    }
    @future(callout=true)
    public static void getApprovalAuthCodeData(){
        CSS_FN_SIEBEL.getApprovalAuthCode();
    }
}