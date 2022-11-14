@isTest
public class FSLCDSBatchProcess_Test {
    //
    static testMethod void testSymptomfetcher()
    {
        test.startTest();
        FSLTestDataSetupCls.createIntegrationConfigs();
        // Set mock callout class
        //Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        /*Account a = FSLTestDataSetupCls.createAccountData();
Asset ast=FSLTestDataSetupCls.createAssetRecord();
ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st); */
        //Test.startTest();
        FSLSymptomUpdatesBatchProcess fsup = new FSLSymptomUpdatesBatchProcess();
        Database.executeBatch(fsup);
        FSLSymptomsRespIterator fsrp = new FSLSymptomsRespIterator();
        FSLSymptomRespWrapper fsyw=new FSLSymptomRespWrapper();
        fsyw.BusinessUnit='Engine';
        fsyw.cds_highlevelcategory='Lubricating Oil Symptom';
        fsyw.cds_highlevelcategoryId='1b37027a-119f-e811-a95b-000d3a37870e';
        fsyw.CDSID='test';
        fsyw.ComplaintCode='test';
        fsyw.CreatedBy='test';
        fsyw.CreatedOn='test';
        fsyw.filter='test';
        fsyw.ID='te6d5e6138-149f-e811-a95c-000d3a3780ddst';
        fsyw.LanguageKey='test';
        fsyw.ModifiedOn='test';
        fsyw.Name='1939 Display Does Not Respond/Function';
        fsyw.Status='Active';
        FSLSymptomsCDSService cds = new FSLSymptomsCDSService();
        cds.getSymptoms();
        
        SchedulableContext sc = null;
        FSLSymptomsSC tsc = new FSLSymptomsSC();
        tsc.execute(sc);
        Test.stopTest();
    }
    
    static testMethod void testSMNDTCCDService()
    {
        test.startTest();
        FSLTestDataSetupCls.createIntegrationConfigs();
        // Set mock callout class 
        //Test.setMock(HttpCalloutMock.class, new FSL_MockTest());      
        //FSLTestDataSetupCls.createIntegrationConfigs();
        /*Account a = FSLTestDataSetupCls.createAccountData();
Asset ast=FSLTestDataSetupCls.createAssetRecord();
ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st); 
*///Test.startTest();
        FSLSMNDTCBatchProcess fsup = new FSLSMNDTCBatchProcess();
        Database.executeBatch(fsup);
        FSLSMNDTCRespIterator fsmnr = new FSLSMNDTCRespIterator();
        FSLSMNDTCRespWrapper fst=new FSLSMNDTCRespWrapper();
        fst.BusinessUnit='test';
        fst.CDSID='test';
        fst.CreatedBy='test';
        fst.CreatedOn='test';
        fst.FaultTypeFC='test';
        fst.FaultTypePcode='test';
        fst.FaultTypeSPNFMI='test';
        fst.ID='test';
        fst.ModifiedOn='test';
        fst.Status='test';
        fst.Name='test';
        Test.stopTest();
    }
    
    static testMethod void testSMNDTCCDService1()
    {
        Test.startTest();
        FSLSymptomsCDSService cds = new FSLSymptomsCDSService();
        cds.getSymptoms();
        
        SchedulableContext sc = null;
        FSLSMNDTCsSC tsc = new FSLSMNDTCsSC();
        tsc.execute(sc);
        Test.stopTest();
    }
}