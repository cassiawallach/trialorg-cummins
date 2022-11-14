@isTest
private class FSL_CreateServiceAppointments_Test {
    @testSetup static void setup() {
        Test.StartTest();
        //create WorkType
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';
        insert objWorkType;
        
        // Create account
        WOrkOrder WorkOrderObj = FSL_TestDataUtility.createWorkOrder(2, 'Miles');
        WorkOrderObj.WorkTypeId = objWorkType.Id;
        update WorkOrderObj;
        Test.StopTest();
    }
    
    @isTest static void CreateServiceAppointment_Test() {
        Test.StartTest();
        FSL_CreateServiceAppointments.inputParams params = new FSL_CreateServiceAppointments.inputParams();
        params.serviceOrderId = [SELECT Id FROM WOrkOrder LIMIT 1].Id;
        params.bayAppointments = 5;
        params.bayDuration = 10;
        params.techAppointments = 5;
        params.techDuration = 7;
        
        String sParams = JSON.serialize(params);
        FSL_CreateServiceAppointments.CreateServiceAppointment(sParams);
        Test.StopTest();
    }
}