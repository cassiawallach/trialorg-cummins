/**********************************************************************
Name:EVL_ServiceOrderAuditTrialPDFController
Copyright Â© 2021  Cummins
=================================================================================================================
=================================================================================================================
Purpose:   
                                                         
-----------------------------------------------------------------------------------------------------------------
This class is used for displaying the Audit trail details in a pdf
=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     	AUTHOR                  DATE          DETAIL                         
1.0       	SRUTHI MUDIREDDY          03/18/2021    Initial Development for Audit trail PDF
********************************************************************************************************************/
public class EVL_ServiceOrderAuditTrialPDFController {

    public String serOrderId {get;set;}
    public WorkOrder woObj {get;set;}
    public List<FSL_Audit_Trail__c> objAuditTrailList {get;set;}
    public Boolean isFactoryUser {get;set;}
    
    public EVL_ServiceOrderAuditTrialPDFController(){
        
        serOrderId = ApexPages.currentPage().getParameters().get('id');
        objAuditTrailList = new List<FSL_Audit_Trail__c>();
        isFactoryUser = FALSE;
        
        UserRole userRole = [select Id,Name from UserRole WHERE Id =: UserInfo.getUserRoleId()];
        
        woObj = [Select Id, EVL_Customer__c, EVL_Assigned_Technician__c, AccountId, Account.Name, WorkOrderNumber, Dealer_Shop_Work_Order__c, Asset.Name, FSL_SMN__c, FSL_SMN__r.Name, Make__c, Model__c, Unit_Number_Formula__c, Application__c, Warranty_Start_Date__c, Failure_Date__c, Mileage__c, Mileage_Measure__c, CSS_Hours__c, Asset.VIN__c,Type__c,
                 (select Id, Name, FSL_Fault_Code_Formula__c, FSL_PositionOfSolution__c,FSL_Solution_Content__r.Title, Diagnostic_Response__c, Diagnostic_Notes__c, Repair_Response__c, Repair_Notes__c,CreatedBy.Name, LastModifiedDate from CSS_Solutions__r order by LastModifiedDate desc),
                 (Select Id, CreatedDate, Field, CreatedBy.Name, OldValue, NewValue from Histories order by CreatedDate desc),
                 (Select Id, Name,CreatedBy.Name,CreatedDate,FSL_Description__c, Rank__c,Service_Order__r.WorkOrderNumber,Icon__c,Symptom__c from FSL_Audit_Trail__r order by CreatedDate desc) from WorkOrder where Id =: serOrderId LIMIT 1];
        
        if(userRole != NULL && userRole.Name != NULL && userRole.Name.EqualsIgnoreCase('Factory') && woObj.Type__c == 'Dealer'){
            isFactoryUser = TRUE;
        }
    }
}