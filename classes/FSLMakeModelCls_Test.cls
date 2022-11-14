/**********************************************************************
Name:FSLMakeModelClsTest
Copyright Â© 2019  Cummins
======================================================
======================================================
Purpose:                                                            
-------  
This is used for the MakeModel Test class on the work order.
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0 - Vinod Yelala      12/20/2018      INITIAL DEVELOPMENT                    
***********************************************************************/ 
// adding comment for deployment

@isTest
public class FSLMakeModelCls_Test
{
   
 
    static testMethod void testlogic1()
    {
        //
        test.starttest();
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        asset ast = new asset(name='12345678',Engine_Family__c='testeng',Unit_Type__c='testut',Engine_Family_Code__c='testeng', AccountId=a.id,Product_Application_Code__c = '1',
                              Make__c='testmk',Model__c='tetmodel2',Type_PSN__c= 'Engines-12345678', Service_Model__c='testsm',Unit_Number__c='testun', site__c=site.id);
        ///[SELECT Make__c, Model__c, EngineFamilyCode__c, RecordTypeId FROM CSS_Make_Model_Access__c 
        //      WHERE EngineFamilyCode__c =: wo.Asset.Engine_Family_Code__c AND RecordTypeId =: SRTRecordTypeId 
        //    AND Make__c != null AND Make__c != '' ORDER BY Make__c, Model__c]
        insert ast;
        
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        list<CSS_Make_Model_Access__c > csms=new List< CSS_Make_Model_Access__c >();
        CSS_Make_Model_Access__c csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk', Model__c='tetmodel2',EngineFamilyCode__c= ast.Engine_Family_Code__c ,recordtypeid=SRTRecordTypeId);
        csms.add(csm);
        csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk233', Model__c='tetmodel22', EngineFamilyCode__c='testeng',recordtypeid=SRTRecordTypeId);
        csms.add(csm);
        csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk23', Model__c='tetmodel223', EngineFamilyCode__c='testeng',recordtypeid=SRTRecordTypeId);
        csms.add(csm);
        insert csms;
        Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st); 
        String appCode = wo.Application__c;
            //FSLTestDataSetupCls.returnAppCode(ast, a);
        if(appCode != null){
        String checkAppCode = appCode.substringBefore('-').trim();
        }
        
        CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
            je.key__c='MarketingApplicationCodes';
            je.Attribute1__c = '1'; 
            je.Attribute2__c = appCode;
            je.Attribute3__c = 'Att3';
            je.Attribute4__c = 'Att4';
            je.Attribute5__c = 'Att5';
            je.Attribute6__c = 'Att6';
            je.Attribute7__c = 'Att7';
            je.Attribute8__c = 'Att8';
            je.Attribute9__c = 'MIHRKM';
            je.Attribute14__c = '9';
            je.Attribute13__c = system.now().addDays(-29);     
            insert je;
        
        test.stoptest();
        FSLMakeModelcls.getMakeModels(wo.id);
        FSLMakeModelcls.saveMakeModels(ast.id, csm.Make__c,csm.Model__c, wo.Id);
        FSLMakeModelcls.saveMakeModelsForNonCumminsAsset(ast.id, csm.Make__c,csm.Model__c, wo.Id);
        FSLMakeModelcls.getAssetId(wo.id);
        FSLMakeModelCls.getLockAssetStatus(wo.id);
        FSLMakeModelCls.getWOMakeModels(wo.id);
        FSLMakeModelCls.getPicklistvalues('WorkOrder', 'Status', true);
        FSLMakeModelCls.getAppErrorMsg(wo.Id);
        FSLMakeModelCls.getApplicationCode(wo.Id);
        FSLMakeModelCls.validateApplicationCode(wo.Id, appCode);
        FSLMakeModelCls.getApplicationDescMetadata();
        
    }
    
    static testMethod void testlogic()
    {
        test.starttest();
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        asset ast = new asset(name='12345678',Engine_Family__c='testeng',Unit_Type__c='testut',Engine_Family_Code__c='testeng', AccountId=a.id,
                              Make__c='testmk',Model__c='tetmodel2',Type_PSN__c= 'Engines-12345678', Service_Model__c='testsm',Unit_Number__c='testun', site__c=site.id);
        insert ast;
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        list<CSS_Make_Model_Access__c > csms=new List< CSS_Make_Model_Access__c >();
        CSS_Make_Model_Access__c csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk', Model__c='tetmodel2', EngineFamilyCode__c='testeng',recordtypeid=SRTRecordTypeId);
        csms.add(csm);
        csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk233', Model__c='tetmodel22', EngineFamilyCode__c='testeng',recordtypeid=SRTRecordTypeId);
        csms.add(csm);
        csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk23', Model__c='tetmodel223', EngineFamilyCode__c='testeng',recordtypeid=SRTRecordTypeId);
        csms.add(csm);
        insert csms;
        Workorder wo = FSLTestDataSetupCls.createWorkOrder(ast, a, st); 
        String appCode = wo.Application__c;
            //FSLTestDataSetupCls.returnAppCode(ast, a);
        if(appCode != null){
        String checkAppCode = appCode.substringBefore('-').trim();
        }
        test.stoptest();
       FSLMakeModelCls.isAssetCumminsOrNot(wo.Id);
        FSLMakeModelCls.validateApplicationCode(wo.Id, appCode);
        
    }
}