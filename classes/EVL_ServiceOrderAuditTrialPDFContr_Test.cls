/**********************************************************************
Name:EVL_ServiceOrderAuditTrialPDFContr_Test
Copyright Â© 2021  Cummins
Author: Sruthi Mudireddy
********************************************************************************************************************/
//adding comment to deploy test class
@isTest
public class EVL_ServiceOrderAuditTrialPDFContr_Test {

    static testmethod void testController(){
        
        WorkOrder wo = new WorkOrder();
        insert wo;
        
        Test.startTest();
        
        Test.setCurrentPageReference( Page.EVL_ServiceOrderAuditTrialPDFPage);
        System.currentPageReference().getParameters().put('Id', wo.Id);
        
        EVL_ServiceOrderAuditTrialPDFController obj = new EVL_ServiceOrderAuditTrialPDFController(); 
        
        Test.stopTest();
    }
}