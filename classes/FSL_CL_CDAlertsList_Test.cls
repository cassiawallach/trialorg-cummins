/*
 * Test Class for Apex Controller - FSL_CL_CDAlertsList
 * Author - Piyush Rani
 */ 
@isTest
public class FSL_CL_CDAlertsList_Test {
	@isTest static void testConnectedDiagnostics() {
        WorkOrder workOrd = new WorkORder();
        Test.startTest();
        workOrd = FSL_TestDataUtility.createWorkOrder(null, null);
        FSL_CL_CDAlertsList.getConnectedDiagnostics(workOrd.Id);
        
        workOrd.Mileage_Measure__c = 'Kilometers';
        workOrd.Mileage__c = 201168;
        update workOrd;
        FSL_CL_CDAlertsList.getConnectedDiagnostics(workOrd.Id);
        
        workOrd.Mileage_Measure__c = 'Hours';
        update workOrd;
        FSL_CL_CDAlertsList.getConnectedDiagnostics(workOrd.Id);
        
        workOrd.Mileage_Measure__c = 'Miles';
        update workOrd;
        FSL_CL_CDAlertsList.getConnectedDiagnostics(workOrd.Id);
        
        //Test getConnectedDiagnostics method
        
        Test.stopTest();
    }
    
    @isTest static void testConnectedDiagnosticsElse() {
        WorkOrder workOrd = new WorkORder();
        Test.startTest();
        workOrd = FSL_TestDataUtility.createWorkOrder(2, 'Miles');
        
        //Test getConnectedDiagnostics method
        FSL_CL_CDAlertsList.getConnectedDiagnostics(workOrd.Id);
        Test.stopTest();
    }
}