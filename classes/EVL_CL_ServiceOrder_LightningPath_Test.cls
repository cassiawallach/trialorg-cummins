//This is Test class for EVL_CL_ServiceOrder_LightningPath class
/*******************************************************************************************************************
Name: EVL_CL_ServiceOrder_LightningPath_Test
Copyright © 2020  Cummins
===================================================================================================================
===================================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Lochana Rajput     08/18/2022     
*******************************************************************************************************************/
// Sriprada S- Adding comment to deploy changes
@isTest
public class EVL_CL_ServiceOrder_LightningPath_Test {
    
    public static void createData() {
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '12345-12345';
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
        objAsset.Name = '23234324';
        objAsset.Type_PSN__c = 'Engines-23234324';
        objAsset.Type__c = 'Engines';
        insert objAsset;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        insert objWorkOrder;
    
        CSS_Solutions__c cs = new CSS_Solutions__c();
        cs.Diagnostic_Response__c = 'Most likely the solution. Repair recommended.';
        cs.Repair_Response__c = 'Repair Successful.';
        cs.FSL_Service_Job__c = objWorkOrder.Id;
        insert cs;
        EVL_CL_ServiceOrder_LightningPath.insertMakeModelStaging(objWorkOrder.id);
    }
    
    @isTest
    public static void validateChevronData(){
        // Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator());
        createData();
        Test.startTest();
        List<WorkOrder> objWorkOrder = [SELECT Id FROM WorkOrder limit 01];
        
        EVL_CL_ServiceOrder_LightningPath.getChevronData(objWorkOrder[0].Id) ;
        objWorkOrder[0].EVL_Stage__c = 'Intake';
        update objWorkOrder[0];
         EVL_CL_ServiceOrder_LightningPath.getChevronData(objWorkOrder[0].Id) ;
        objWorkOrder[0].EVL_Stage__c = 'Repair';
        update objWorkOrder[0];
         EVL_CL_ServiceOrder_LightningPath.getChevronData(objWorkOrder[0].Id) ;
        objWorkOrder[0].EVL_Stage__c = 'Job Plan';
        update objWorkOrder[0];
         EVL_CL_ServiceOrder_LightningPath.getChevronData(objWorkOrder[0].Id) ;
        objWorkOrder[0].EVL_Stage__c = 'Closed';
        update objWorkOrder[0];
        String result = EVL_CL_ServiceOrder_LightningPath.getChevronData(objWorkOrder[0].Id) ;
        Test.stopTest();
        System.assertEquals(true, result.contains('Inactive'));
    }
    
    @isTest
    private static void testIsStageActiveFor(){
        Test.startTest();
        FSL_CumminsUtilities.getStageValues('System Administrator');
        List<String> values = EVL_CL_ServiceOrder_LightningPath.isStageActiveFor('System Administrator');
        Test.stopTest();
        System.assertEquals(true, values != null);
    }
    @isTest
    private static void testUpdateStageAndRecordType(){
        createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder];
        EVL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Intake');
        EVL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Triage & Diagnosis');
        EVL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Job Plan');
        EVL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Repair');
        EVL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Closed');
        objWorkOrder = [SELECT Id,EVL_Stage__c,Status FROM WorkOrder];
        Test.stopTest();
        System.assertEquals('Closed', objWorkOrder.EVL_Stage__c);
        System.assertEquals('Closed', objWorkOrder.Status);
    }
    
    @isTest
    private static void testGetProcessStatus(){
        createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id,Process_Step__c,EVL_Stage__c FROM WorkOrder];
        EVL_CL_ServiceOrder_LightningPath.getProcessStatus(objWorkOrder.Id);
        objWorkOrder.Process_Step__c = 'Intake';
        update objWorkOrder;
        String status = EVL_CL_ServiceOrder_LightningPath.getProcessStatus(objWorkOrder.Id);
        Test.stopTest();
        System.assertEquals(status, objWorkOrder.EVL_Stage__c);
    }
    
    @isTest
    private static void testCheckForMostLikely(){
        createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id,Process_Step__c FROM WorkOrder];
        objWorkOrder.Process_Step__c = 'Repair';
        update objWorkOrder;
        Boolean result = EVL_CL_ServiceOrder_LightningPath.checkForMostLikely(objWorkOrder.Id);
        Test.stopTest();
        System.assertEquals(true, result);
    }  
    
    @isTest
    private static void testcheckForRepairSelection(){
        createData();
        WorkOrder objWorkOrder = [SELECT Id,Process_Step__c FROM WorkOrder];
        objWorkOrder.Process_Step__c = 'Repair';
        update objWorkOrder;
        Test.startTest();
        Boolean isRepairSuccessful = EVL_CL_ServiceOrder_LightningPath.checkForRepairSelection(objWorkOrder.Id);
        Test.stopTest();
        System.assertEquals(true, isRepairSuccessful);
    }    
     
    

    
    public static testMethod void updatemakemodelTest() {
       
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();

        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '12345-12345';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        objAccount.FSL_ERP_Customer_Code__c = '7103507';
        insert objAccount;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';
        insert objWorkType;
        
        Asset objAsset = new Asset();
        objAsset.Name = '23234324';
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Make__c ='make';
        objAsset.Model__c ='model';
        insert objAsset;
        
       WorkOrder objWorkOrder = new WorkOrder();

        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c ='Troubleshooting Complete' ;
        objWorkOrder.Make__c ='Test';
        objWorkOrder.Model__c ='Test';
        objWorkOrder.Type__c = 'Dealer';
       // objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.RecordTypeId = recTypeId;
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c = 'Troubleshooting Complete';
        insert objWorkOrder;

        CSS_Solutions__c cs = new CSS_Solutions__c();
        cs.Diagnostic_Response__c = 'Most likely the solution. Repair recommended.';
        cs.Repair_Response__c = 'Repair Successful.';
        cs.FSL_Service_Job__c = objWorkOrder.Id;
        insert cs;
        
        List<FSL_MakeModel_Stage__c> objstag = new List<FSL_MakeModel_Stage__c>();
        FSL_MakeModel_Stage__c fms = new FSL_MakeModel_Stage__c();
        fms.Manufacturer__c = 'Test';
        fms.ModelSeries__c = 'Test Model';
        fms.ProductApplicationCode__c = 'test';
       	fms.PSN__c = '79788878';
        fms.Name = 'test';
        fms.Type_PSN__c ='Engines-79361294';
        
        objstag.add(fms); 
       insert objstag;
         Test.startTest();
        EVL_CL_ServiceOrder_LightningPath.insertMakeModelStaging(objWorkOrder.id);
		EVL_CL_ServiceOrder_LightningPath.handleCloseModal(objWorkOrder.id,null);
        EVL_CL_ServiceOrder_LightningPath.handleTAndDRepairJobPlanClose(objWorkOrder.id);
       //	FSL_CL_ServiceOrder_LightningPath.callBMSWebServices(objWorkOrder.id);
         EVL_CL_ServiceOrder_LightningPath.getRepairRespLOVs();
        EVL_CL_ServiceOrder_LightningPath.cssSolutionWrapper csswrap = new EVL_CL_ServiceOrder_LightningPath.cssSolutionWrapper();
        EVL_CL_ServiceOrder_LightningPath.recordStatus(objWorkOrder.id, Label.EVL_Add_Diagnostic_SRTs);
        EVL_CL_ServiceOrder_LightningPath.getRepairmsg(objWorkOrder.id);
        EVL_CL_ServiceOrder_LightningPath.handleCloseRep(objWorkOrder.id);
         EVL_CL_ServiceOrder_LightningPath.GetLoggedInUserDetail();
        Test.StopTest();
        objWorkOrder = [SELECT Id,status FROM WorkOrder];
        System.assertEquals('Closed', objWorkOrder.status);
    }
    @isTest
    public static void test_recordStatus() {
        OperatingHours testOh = TestUtility.createOperatingHours('testName');
        FSL_Switch__c FSlSwitch =FSL_TestDataUtility.createFSLSwitchRecord('Enable_FTR_Switch', true);
        insert FSlSwitch;
        ServiceTerritory testTerritory = TestUtility.createServiceTerritory('testName', true, testOh.Id);

        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = FSL_TestDataUtility.createAccount();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = FSL_TestDataUtility.createContact(conRecId, acc.Id);
        insert con;
        
        Asset  ast = FSL_TestDataUtility.createAsset();
        ast.VIN__c = '12344';
        update ast;
        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();
        List<Case> lstCases = FSL_TestDataUtility.createCases(servRecId,acc.Id, con.Id,ast.Id,testTerritory.Id,1);
        lstCases[0].FSL_ABRFlag__c= true;
        insert lstCases;
 
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        lstWO[0].RecordTypeId = DealerRTID;
        insert lstWO;
        Test.startTest();
        Boolean showLabel = EVL_CL_ServiceOrder_LightningPath.recordStatus(lstWO[0].id, Label.EVL_Add_Diagnostic_SRTs);
        Test.stopTest();
        System.assertEquals(false, showLabel);
    }
}