/*******************************************************************************
Name: FSL_CL_RecordChangeCapture
Copyright Â© 2020  Cummins
================================================================================
================================================================================
Purpose:                                                            
This class is used for fetching the Field Actions record counts for a WorkOrder.
================================================================================
================================================================================
History                                                            
-------                                                            
VERSION     AUTHOR                     DATE          DETAIL                         
1.0         Sravanthi Gundreddy        11/02/2020    Initial Development
*******************************************************************************/
public class FSL_CL_RecordChangeCapture {
    
    @AuraEnabled
    public static Integer getAvailableFAs(Id woId) {
        
        List<CSS_Solution_Component__c> avFAList = [SELECT Id 
                                                    FROM CSS_Solution_Component__c 
                                                    WHERE FSL_Service_Order__c = :woId];
        return avFAList.size();
    }
    
    @AuraEnabled
    public static Integer getReqToCompFAs(Id woId) {
        
        List<CSS_Solution_Component__c> rcFAList = [SELECT Id 
                                                    FROM CSS_Solution_Component__c 
                                                    WHERE FSL_Service_Order__c = :woId 
                                                    AND Performed_Review__c = TRUE 
                                                    AND Performed__c = FALSE];
        return rcFAList.size();
    }
}