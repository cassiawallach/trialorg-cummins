@isTest
private class FSL_CL_AuditTrail_Test {
    public static void createData() {
        CSS_Integration_Details__c objIntegrationDetails = new CSS_Integration_Details__c();
        objIntegrationDetails.Name = 'OAGOAuthTest';
        objIntegrationDetails.ApplicationName__c = 'OAGOAuthTest';
        objIntegrationDetails.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/css';
        objIntegrationDetails.IsActive__c = true;
        objIntegrationDetails.Key__c = '12345';
        objIntegrationDetails.Passcode__c= 'test';
        objIntegrationDetails.Username__c= 'test';
        insert objIntegrationDetails;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory - In Shop';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '1234-1234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';
        insert objWorkType;
        
        Asset objAsset = new Asset();
        objAsset.Name = '79788868';
        objAsset.Type_PSN__c = 'Engines-79788868';
        insert objAsset;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        insert objWorkOrder;
        
        FSL_Audit_Trail__c objAuditTrail = new FSL_Audit_Trail__c();
        
        List<Audit_Trail_Event__mdt> objAuditTrailEvent = FSL_CumminsUtilities.getEventRecord('Event-01');
        objAuditTrail.Event__c = objAuditTrailEvent[0].Event_Type__c;
        objAuditTrail.FSL_Diagnostic_Audit__c = objAuditTrailEvent[0].Diagnostic_Audit_Trail__c;
        objAuditTrail.FSL_Description__c =  objAuditTrailEvent[0].Event_Description__c;
        objAuditTrail.Rank__c = '1 to 5';
        objAuditTrail.FSL_Diagnostic_Audit__c=true ;
        objAuditTrail.Service_Order__c =objWorkOrder.Id ;
        objAuditTrail.Solution_Response__c = '';
        objAuditTrail.Symptom__c = '';
        insert objAuditTrail;
    }
    private static testMethod void test() {
        
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator());
        test.startTest();
        createData();
        WorkOrder audit = [SELECT ID
                           FROM WorkOrder LIMIT 1];
        FSL_CL_AuditTrail.getAuditTrailData(audit.Id);
        FSL_CumminsUtilities.auditTrailInsert('Event-01',audit.Id,'','','','');
        test.stopTest();
     }
}