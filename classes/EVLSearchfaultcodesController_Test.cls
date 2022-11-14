//Adding comment for deployment -- Sriprada
//worked for cvrg increase --Priyanka
//Adding comment for deployment - priyanka
// increased code coverage - Diksha Rajpurohit 
@isTest
public class EVLSearchfaultcodesController_Test
{
    @testSetup static void setup() {
        List<FSL_Symptom__c> fss = new list<FSL_Symptom__c>();
        List<FSL_SMN_DTC__c> fsm = new list<FSL_SMN_DTC__c>();
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        asset ast = new asset(name='79635341',Engine_Family__c='testeng',Unit_Type__c='testut', Type_PSN__c= 'Engines-12345678', Engine_Family_Code__c='testeng', AccountId=a.id, 
                              Make__c='testmk',Model__c='tetmodel2',Service_Model__c='testsm',Unit_Number__c='testun', site__c=site.id);
        insert ast;
        
        FSL_Symptom__c fs = new FSL_Symptom__c (Symptom__c='testsymp1', Symptom_Category__c='testsympcat1',Business_Unit__c='Engine');
       fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp1', Symptom_Category__c='testsympcat1',Business_Unit__c='Engine');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp12', Symptom_Category__c='testsympcat1',Business_Unit__c='Engine');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp123', Symptom_Category__c='testsympcat1',Business_Unit__c='Engine');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp1234', Symptom_Category__c='testsympcat1');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp12345', Symptom_Category__c='testsympcat1');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp12345', Symptom_Category__c='testsympcat2');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp12345', Symptom_Category__c='testsympcat2');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp12345', Symptom_Category__c='testsympcat3',name='testmodel');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='', Symptom_Category__c='testsympcat3',name='testmodel');
        fss.add(fs);         
        insert fss;
        FSL_SMN_DTC__c fst=new FSL_SMN_DTC__c (name='testmodel',BusinessUnit__c='test',FaultTypeFC__c='Yes',FaultTypePCode__c='Yes',FaultTypeSPNFMI__c='Yes');
        insert fst;
        FSLTestDataSetupCls.createIntegrationConfigs();
        Account at = FSLTestDataSetupCls.createAccountData();
        Asset ast1=FSLTestDataSetupCls.createAssetRecord();
        ast1.Service_Model__c = 'testmodel';
        update ast1;
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast1, at, st);
        wo.AssetId = ast1.Id;
        update wo;
    }
    static testMethod void testlogic1()
    {
        Workorder wo = [SELECT Id FROM WorkOrder Limit 1];
        test.starttest();
        
        EVLSearchfaultcodesController.getSymptos('testsympcat1');
        // Workorder wo = EVLTestDataSetupCls.createWorkOrder(ast, a);
        EVLSearchfaultcodesController.getSymptomsCategories();
        EVLSearchfaultcodesController.getfaultcodes('ABC','XYZ','LMN');
        EVLSearchfaultcodesController.getfaultcodes(null,'XYZ','LMN');
        EVLSearchfaultcodesController.getfaultcodes(null,null,'LMN');
        EVLSearchfaultcodesController.getsearchresults('');
        EVLSearchfaultcodesController.getsearchspnresults('');
        EVLSearchfaultcodesController.changeRecord(wo.id);
        EVLSearchfaultcodesController.showHidesearchstring(wo.id);
        
        EVLSearchfaultcodesController.hidetakecontrol(wo.id);
        EVLSearchfaultcodesController.echo('test');
        EVLSearchfaultcodesController.SearchWrapper wrap = new EVLSearchfaultcodesController.SearchWrapper();
        wrap.symtpomCategory = 'test';
        wrap.symptom = 'test1';
        EVLSearchfaultcodesController.fetchTakeControl(wo.id); 
        EVLSearchfaultcodesController.getWorkOrderRecordType(wo.id);
        FSL_SPN_FMI__c fpcm=new FSL_SPN_FMI__c(name='EVL_PCode__c');
        insert fpcm;
        
        FSL_Fault_Code__c ffc = new FSL_Fault_Code__c(name='testfc');
        insert ffc;
        
        CSS_Fault_Code__c cfc = new CSS_Fault_Code__c(name='testfc', Number_of_Solutions__c = '2', Service_Order__c = wo.Id);
        insert cfc;
        
        EVLSearchfaultcodesController.captureSearchFaultCode(wo.id,
                                                             '{"pCode":"pCode","faultCode":"'+ffc.Id+'","spnfmiCode":"spnfmiCode","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        EVLSearchfaultcodesController.captureSearchFaultCode(wo.id,
                                                             '{"pCode":"pCode","faultCode":"","spnfmiCode":"spnfmiCode","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        EVLSearchfaultcodesController.captureSearchFaultCode(wo.id,
                                                             '{"pCode":"","faultCode":"","spnfmiCode":"spnfmiCode","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        EVLSearchfaultcodesController.captureSearchFaultCode(wo.id,
                                                             '{"pCode":"","faultCode":"","spnfmiCode":"","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        // FSL_Fault_Code__c ffc = new FSL_Fault_Code__c(name='testfc');
        // insert ffc;
        // EVLSearchfaultcodesController.captureSearchFaultCode(wo.id,
        //  '{"pCode":"pCode","faultCode":"'+ffc.id+'","spnfmiCode":"spnfmiCode","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        
        test.stoptest();
    }
}