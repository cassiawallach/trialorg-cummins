@IsTest
private class FSL_createServiceOrderForAbsenceTS_Test {
    static Id WORecordTypeId_Internal = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
    @testSetup
    private static void setup() {
        //operating hours
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;

        //create ServiceTerritory
        ServiceTerritory sT = new ServiceTerritory();
        sT.Name = 'ST001 Mobile';
        sT.OperatingHoursId = oh.Id;
        sT.IsActive = true;
        sT.Location_Code__c = '03520-04892';
        sT.FSL_Service_Territory_Code__c = '04892';
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        sT.ERP__c = 'BMS';
        Insert sT;

        //create workorder
        WorkOrder WorkOrderObj = new WorkOrder();
        WorkOrderObj.RecordTypeId = WORecordTypeId_Internal;
        WorkOrderObj.ServiceTerritoryId = sT.Id;
        WorkOrderObj.FSL_Active__c = true;
        insert WorkOrderObj;

    }

    @IsTest
    static void testBatchable() {
        List < ServiceTerritory > ServiceTerritoryList = [SELECT Id FROM ServiceTerritory];
        Test.StartTest();
        Database.executeBatch(new FSL_createServiceOrderForAbsenceTSBatch());
        Test.StopTest();
        List < WorkOrder > reworkOrders = [SELECT Id FROM WorkOrder WHERE FSL_Active__c = true];
        System.assertEquals(ServiceTerritoryList.size(), reworkOrders.size(), 'Incorrect number of WorkOrder created.');
    }

    @IsTest
    private static void testSchedulable() {
        Test.startTest();
        System.schedule('create work orders', '0 0 1 * * ?', new FSL_createServiceOrderForAbsenceTSBatch());
        Test.stopTest();
        List < AsyncApexJob > batchJobs = [SELECT Id, Status FROM AsyncApexJob WHERE ApexClass.Name = 'FSL_createServiceOrderForAbsenceTSBatch'
            AND JobType = 'BatchApex'
        ];
        System.assertEquals(1, batchJobs.size(), 'Unexpected number of batch jobs ran: ' + batchJobs);
        System.assertEquals('Queued', batchJobs[0].Status, 'Job planned with an unexpected status.');
    }
}