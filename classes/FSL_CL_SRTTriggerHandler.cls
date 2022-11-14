/********************************************************************************
Name:FSL_CL_SRTTriggerHandler
Copyright © 2020  Cummins
======================================================
======================================================
Purpose:                                                            
-------  This is the class to handle FSL SRT trigger business methods
======================================================
User story : 
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR             DATE               DETAIL                                
V.1.0 	 Rajashekar N		11/13/2020		   
V.1.2	 Karthik Pedditi	06/04/2021		   Removing this Handler as part of CT2-720
*********************************************************************************/
public class FSL_CL_SRTTriggerHandler { 
	/*public static void callAdminSRTApiForTravelSRTs(List<FSL_SRT__c> lstSRTs){
        Set<String> setWorkOrderIds = new Set<String>();
        for(FSL_SRT__c srts : lstSRTs)
        {
            if(srts.Name == 'Travel'){
                setWorkOrderIds.add(srts.Service_Order__c);
            }
        }
        
        if(setWorkOrderIds.size()>0 || Test.isRunningTest() ){
            for(String workOrderId : setWorkOrderIds){
                FSL_CL_AdminSRTApi.future_adminSRTApi(workOrderId);
            }
        } 
    } */
 public static void dummy(){
        Integer i=0;
        i++;
    }   
}