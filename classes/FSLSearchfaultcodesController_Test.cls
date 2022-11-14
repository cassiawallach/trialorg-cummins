//Adding Comment for Deploying the changes - Sriprada 
// increased code coverage - Diksha

@isTest
public class FSLSearchfaultcodesController_Test
{
    // No Change
    static testMethod void testlogic1()
    { 
        
        List<FSL_Symptom__c> fss = new list<FSL_Symptom__c>();
        List<FSL_SMN_DTC__c> fsm = new list<FSL_SMN_DTC__c>();
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        asset ast = new asset(name='12345678',Engine_Family__c='testeng',Unit_Type__c='testut', Type_PSN__c= 'Engines-12345678', Engine_Family_Code__c='testeng', AccountId=a.id, 
                              Make__c='testmk',Model__c='tetmodel2',Service_Model__c='testsm',Unit_Number__c='testun', site__c=site.id);
        insert ast;
        
        FSL_Symptom__c fs = new FSL_Symptom__c (Symptom__c='testsymp1', Symptom_Category__c='testsympcat1');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp1', Symptom_Category__c='testsympcat1');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp12', Symptom_Category__c='testsympcat1');
        fss.add(fs);
        fs = new FSL_Symptom__c (Symptom__c='testsymp123', Symptom_Category__c='testsympcat1');
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
        test.starttest();
        update wo;
        System.debug('ast1 : ' + ast1);
        System.debug('wo-- ' + wo.Asset.Service_Model__c + '-----'+wo);
        FSLSearchfaultcodesController.getSymptos('testsympcat1');
        // Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a);
        FSLSearchfaultcodesController.getSymptomsCategories();
        FSLSearchfaultcodesController.getfaultcodes('ABC','XYZ','LMN');
        //added by harsha for false condition 04-23-2020
        FSLSearchfaultcodesController.getfaultcodes(null,'XYZ','LMN');
        FSLSearchfaultcodesController.getfaultcodes(null,null,'LMN');
        //added by harsha for false condition 04-23-2020
        FSLSearchfaultcodesController.getsearchresults('');
        FSLSearchfaultcodesController.getsearchspnresults('');
        FSLSearchfaultcodesController.changeRecord(wo.id);
        FSLSearchfaultcodesController.showHidesearchstring(wo.id);
        
        
        FSLSearchfaultcodesController.hidetakecontrol(wo.id);
        FSLSearchfaultcodesController.echo('test');
        FSLSearchfaultcodesController.getWorkOrderRecordType(wo.id);
        
        FSL_SPN_FMI__c fpcm=new FSL_SPN_FMI__c(name='FSL_PCode__c');
        insert fpcm;
        FSLSearchfaultcodesController.captureSearchFaultCode(wo.id,
                                                             '{"pCode":"","faultCode":"","spnfmiCode":"'+fpcm.id+'","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        FSL_PCode__c fpc=new FSL_PCode__c(name='FSL_PCode__c');
        insert fpc;
        FSLSearchfaultcodesController.captureSearchFaultCode(wo.id,
                                                             '{"pCode":"'+fpc.id+'","faultCode":"","spnfmiCode":"","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        FSL_Fault_Code__c ffc = new FSL_Fault_Code__c(name='testfc');
        insert ffc;
        FSLSearchfaultcodesController.captureSearchFaultCode(wo.id,
                                                             '{"pCode":"pCode","faultCode":"'+ffc.id+'","spnfmiCode":"spnfmiCode","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        FSLSearchfaultcodesController.captureSearchFaultCode(wo.id,
                                                             '{"pCode":"","faultCode":"","spnfmiCode":"","symtpomCategory":"symtpomCategory","symptom":"symptom"}');
        FSLSearchfaultcodesController.fetchFTRFlag(wo.id);
        test.stoptest();
    }
}