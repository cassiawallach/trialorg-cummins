/**********************************************************************
Name:EVL_ServiceOrderPartsPDFController
Copyright Â© 2021  Cummins
=================================================================================================================
=================================================================================================================
Purpose:                                                            
-----------------------------------------------------------------------------------------------------------------
This class is used for displaying the parts in a pdf

=================================================================================================================
=================================================================================================================
History                                                            
-------                                                            
VERSION     	AUTHOR                  DATE          DETAIL                         
1.0       	SRUTHI MUDIREDDY          03/18/2021    Initial Development for Parts PDF
********************************************************************************************************************/
public without sharing class EVL_ServiceOrderPartsPDFController {
    
    public String serOrderId {get;set;}
    public WorkOrder woObj {get;set;}
    public EVL_ServiceOrderPartsPDFController(){
        
        try{
            serOrderId = ApexPages.currentPage().getParameters().get('id');
            woObj = [Select Id, EVL_Customer__c, EVL_Assigned_Technician__c, AccountId, Account.Name, WorkOrderNumber, Dealer_Shop_Work_Order__c, Asset.Name, FSL_SMN__c, FSL_SMN__r.Name, Make__c, Model__c, Unit_Number_Formula__c, Application__c, Warranty_Start_Date__c, Failure_Date__c, Mileage__c, Mileage_Measure__c, CSS_Hours__c, Asset.VIN__c,
                     (Select Id, Part_Number__c, Part_Name__c, Select__c, Solution_Title__c, Name, Part_Description__c, Return_to_Factory__c, Return_Message__c, Part_Details__c, Replacement_Repair_Reason__c, Notes__c from GSQ_Parts__r), (Select Id, Name, Failure_Value__c, Performed_Review__c, Solution_Id__c from CSS_Solution_Components2__r),
                     (Select Id, Service_Order__c, Name, Item__c, Description__c, Amount__c, Unit_Price__c,Quantity__c from Other_Claimables__r),
                     (Select Id, Name, Quantity__c, Part_Number__c, Replacement_Reason__c, Notes__c from Custom_Parts__r),
                     (Select Id, Name, Part_Number__c, Select__c, Field_Action__c, Part_Name__c, Return_to_Factory__c, Return_Message__c, Part_Quantity__c, Fail_Code__c, Replacement_Repair_Reason__c, Notes__c from TRP__r), 
                     (Select Id, Name, Part_Number__c, Select__c, Field_Action__c, Part_Name__c, Return_to_Factory__c, Return_Message__c, Part_Quantity__c, Fail_Code__c, Replacement_Repair_Reason__c, Notes__c  from Campaign__r),
                     (Select Id, Name, Technician__c, Type__c, Quantity__c, Unit_Price__c, Expense_Total__c, Notes__c from Non_Commercial_Travel_Meals_and_Lodging__r),
                     (Select Id, Part_Number__c, Select__c, Field_Action__c, Part_Name__c, Return_to_Factory__c, Return_Message__c, Part_Quantity__c, Fail_Code__c, Replacement_Repair_Reason__c, Notes__c from ATC__r) from WorkOrder where Id =: serOrderId LIMIT 1];
        }
        Catch(Exception e){
            System.debug('----'+e.getMessage());
        }
    }
}