/**********************************************************************
Name: FSL_CL_FieldActionsRetry
Copyright © 2020  Cummins
=======================================================================
=======================================================================
Purpose: This class is used for FieldAction webservice retry functionality.
=======================================================================
=======================================================================
VERSION         AUTHOR                   DATE                DETAIL                                 
1.0      Surender Madipeddi           07/12/2020          INITIAL DEVELOPMENT                   
***********************************************************************/
public class FSL_CL_FieldActionsRetry {
    
    //Calling FieldActions Service
    @AuraEnabled
    public static void callFieldActionsService(String woId) { //String woId
        system.debug('in callFieldActionsService woId:'+woId);
        try {
            //ROAD-24, Removed update of workorder from this line because of getting error System.CalloutException.
            
            //callFieldActionsService
            //delete FAs here?? //Id woID = '0WO0r0000001ezdGAA'; //intialize woID here //Id woId2 = woId;
            FSL_GETCampaignServices.executeFieldActionService(woId); 
            system.debug('After Retry of callFieldActionsService');
            
            //Bharat - Added to not show FA Retry button when User clicked on Retry //ROAD-24, added after API call. 
            WorkOrder objWO =[SELECT Id, FieldActionService_Failure_Flag__c     
                               FROM WorkOrder WHERE id=:woID ];
            if(objWO.FieldActionService_Failure_Flag__c == true && RecursiveTriggerHandler.isUpdFSLFailureFlag == true){
                objWO.FieldActionService_Failure_Flag__c = false;
                update objWO;    
            }
            
        } catch(Exception e) {
            system.debug('EXCEPTION of FSL_CL_FieldActionsRetry callFieldActionsService method >>> '+e.getMessage() + ' ' + e.getLineNumber() + ' ' +e.getCause());
        }
    }
    
    @auraEnabled
    public static WorkOrder getWorkOrderInfo(String woId) {
        return [SELECT Id, AssetId, FieldActionService_Failure_Flag__c 
                FROM workOrder 
                WHERE Id= :woId];
        //Comment By Sravanthi Gundreddy: removed Available_FAs_Count__c, Required_To_Complete__c fields from query beacuse of fieldactions issue we are deleting this two fields from object
    }    
}