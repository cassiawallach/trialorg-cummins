/**********************************************************************
Name:EVL_ServiceOrderPartsPDFController_Test
Copyright Â© 2021  Cummins
Author: Sruthi Mudireddy
********************************************************************************************************************/


@isTest
public class EVL_ServiceOrderPartsPDFController_Test {

    static testmethod void testController(){
        
        WorkOrder wo = new WorkOrder();
        insert wo;
        
        Test.startTest();
        
        Test.setCurrentPageReference( Page.EVL_ServiceOrderPartsPDFPage);
        System.currentPageReference().getParameters().put('Id', wo.Id);
        
        EVL_ServiceOrderPartsPDFController obj = new EVL_ServiceOrderPartsPDFController(); 
        
        Test.stopTest();
    }
}