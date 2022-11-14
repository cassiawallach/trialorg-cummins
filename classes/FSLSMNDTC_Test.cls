@isTest
public class FSLSMNDTC_Test {
    
    static testMethod void testlogic1() {
        
        test.starttest(); 
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        Asset ast = new Asset(name = '12345678', Engine_Family__c = 'testeng', Unit_Type__c = 'testut', Engine_Family_Code__c='testeng', AccountId=a.id, 
                              Make__c='testmk',Model__c = 'tetmodel2', Type_PSN__c = 'Engines-12345678', Service_Model__c='testsm',Unit_Number__c='testun',Type__c = 'Engines', site__c=site.id);
        insert ast;
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        WorkOrder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st); 
        FSLSMNDTC.checkforSMNDTC(wo.Id);
        // FSLSMNDTC.getservicemodel(Wo.id);
        // FSLSMNDTC.getpsn(wo.id);
        
        test.stoptest();
    }
    
     static testMethod void testlogic2() {
        
        test.starttest(); 
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        Asset ast = new Asset(name = '12345678', Engine_Family__c = 'testeng', Unit_Type__c = 'testut', Engine_Family_Code__c='testeng', AccountId=a.id, 
                              Engine_Manufacturer__c='Cummins',Make__c='testmk',Model__c = 'tetmodel2', Type_PSN__c = 'Engines-12345678', Service_Model__c='testsm',Unit_Number__c='testun',Type__c = 'Engines', site__c=site.id);
        insert ast;
        FSL_SMN_DTC__c smn = new FSL_SMN_DTC__c();
        smn.name = 'TEST SMN';
        smn.FaultTypeFC__c = 'Yes';
        insert smn; 

        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        WorkOrder wo=new WorkOrder(AccountId=a.id, serviceterritoryId=st.Id,FSL_SMN__c=smn.Id,AssetId=ast.Id);
        insert wo;
        FSLSMNDTC.checkforSMNDTC(wo.Id);

        test.stoptest();
    }
    
    static testMethod void testlogic3() {
        
        test.starttest(); 
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        Asset ast = new Asset(name = '12345678', Engine_Family__c = 'testeng', Unit_Type__c = 'testut', Engine_Family_Code__c='testeng', AccountId=a.id, 
                              Engine_Manufacturer__c='Cummins',Make__c='testmk',Model__c = 'tetmodel2', Type_PSN__c = 'Engines-12345678', Service_Model__c='testsm',Unit_Number__c='testun',Type__c = 'Engines', site__c=site.id);
        insert ast;
        FSL_SMN_DTC__c smn = new FSL_SMN_DTC__c();
        smn.name = 'TEST SMN';
        smn.FaultTypeFC__c = 'Yes';
        insert smn; 

        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        WorkOrder wo=new WorkOrder(AccountId=a.id, serviceterritoryId=st.Id,FSL_SMN__c=smn.Id);
        insert wo;
        FSLSMNDTC.checkforSMNDTC(wo.Id);

        test.stoptest();
    }
    
    static testMethod void testlogic4() {
        
        test.starttest(); 
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        Asset ast = new Asset(name = '12345678', Engine_Family__c = 'testeng', Unit_Type__c = 'testut', Engine_Family_Code__c='testeng', AccountId=a.id, 
                              Engine_Manufacturer__c='Cummins',Make__c='testmk',Model__c = 'tetmodel2', Type_PSN__c = 'Engines-12345678', Service_Model__c='testsm',Unit_Number__c='testun',Type__c = 'Engines', site__c=site.id);
        insert ast;
        
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        WorkOrder wo=new WorkOrder(AccountId=a.id, serviceterritoryId=st.Id,AssetId=ast.Id);
        insert wo;
        FSLSMNDTC.checkforSMNDTC(wo.Id);

        test.stoptest();
    }
}