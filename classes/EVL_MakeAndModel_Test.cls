/**********************************************************************
Name:EVL_MakeAndModel_Test
Copyright Â© 2020  Cummins
======================================================
======================================================
Purpose:    

-------  
This is used for the MakeModel Test class on the work order.
======================================================
======================================================
History                                                            
-------                                                            
VERSION     AUTHOR                  DATE                DETAIL                                 
1.0 -       Krishnamoorthi N        07/17/2020          Test Class for EVL_MakeAndModel                    
***********************************************************************/
@isTest
public class EVL_MakeAndModel_Test {
    
     static testMethod void testlogic1() {
        test.starttest();
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        asset ast = new asset(name='12345678',Engine_Family__c='testeng',Unit_Type__c='testut',Engine_Family_Code__c='testeng', AccountId=a.id, Product_Application_Code__c = '1',
                              Make__c='testmk',Model__c='tetmodel2', Engine_Manufacturer__c = 'CUMMINS', Type_PSN__c= 'Engines-12345678', Service_Model__c='testsm',Unit_Number__c='testun', site__c=site.id);
        ///[SELECT Make__c, Model__c, EngineFamilyCode__c, RecordTypeId FROM CSS_Make_Model_Access__c 
        //      WHERE EngineFamilyCode__c =: wo.Asset.Engine_Family_Code__c AND RecordTypeId =: SRTRecordTypeId 
        //    AND Make__c != null AND Make__c != '' ORDER BY Make__c, Model__c]
        insert ast;
        ServiceTerritory st = FSLTestDataSetupCls.createServiceTerritory();
        Id SRTRecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        list<CSS_Make_Model_Access__c > csms=new List< CSS_Make_Model_Access__c >();
        CSS_Make_Model_Access__c csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk', Model__c='tetmodel2', EngineFamilyCode__c='testeng',recordtypeid=SRTRecordTypeId);
        csms.add(csm);
     /**   csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk233', Model__c='tetmodel22', EngineFamilyCode__c='testeng',recordtypeid=SRTRecordTypeId);
        csms.add(csm);
        csm=new CSS_Make_Model_Access__c
            ( Make__c='testmk23', Model__c='tetmodel223', EngineFamilyCode__c='testeng',recordtypeid=SRTRecordTypeId);
        csms.add(csm);**/
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
        
        
        EVL_MakeAndModel.getMakeModels(wo.id);
        //EVL_MakeAndModel.saveMakeModels(ast.id, 'testsavemake','testsavemodel', 'wo.Id','510 - WORLDWIDE OFF-HIGHWAY', true);
          EVL_MakeAndModel.saveMakeModels(ast.id, 'testmk','tetmodel2', wo.Id,'510 - WORLDWIDE OFF-HIGHWAY', true); 
        EVL_MakeAndModel.getAssetId(wo.id);
        EVL_MakeAndModel.getLockAssetStatus(wo.id);
        EVL_MakeAndModel.getWOMakeModels(wo.id);
        EVL_MakeAndModel.validateApplicationCode(wo.Id, appCode);
        EVL_MakeAndModel.getPicklistvalues('WorkOrder', 'Status', true);
        EVL_MakeAndModel.getApplicationCode(wo.Id);
        EVL_MakeAndModel.getAppErrorMsg(wo.Id);
        test.stoptest();
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
        
        
        EVL_MakeAndModel.validateApplicationCode(wo.Id, appCode);
        test.stoptest();
    }
    
    @isTest
    private static void insertMakeModelStagingTest() {
        Test.startTest();
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345');
        
        insert u;
        system.runAs(u) {
            FSL_StatusUpdate.fetchUser();
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'Test Account ';
            acc.BillingStreet = '1466 N National Rd';
            acc.BillingCity = 'Columbus';
            acc.BillingState = 'Indiana';
            acc.BillingCountry= 'United States';
            acc.BillingPostalCode = '47201';
            acc.FSL_ERP_Customer_Code__c = '';
            insert acc;
            
            
            
           
            
            List < Contact > conList = new List < Contact > ();
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con = new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName = 'Steve';
            con.LastName = 'Johnson';
            con.Phone = '1234567890';
            con.AccountId = acc.id;
            con.FSL_Contact_Id__c = '1';
            
            conList.add(con);
            
            Contact payerCon = new Contact();
            payerCon.RecordTypeId = conRecId;
            payerCon.FirstName = 'Steve';
            payerCon.LastName = 'Johnson';
            payerCon.Phone = '1234567890';
            payerCon.AccountId = acc.id;
            payerCon.FSL_Contact_Id__c = '1';
            conList.add(payerCon);
            
            insert conList;
            
            OperatingHours oh = new OperatingHours();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            WorkType wt = new WorkType();
            wt.Name = 'Test work type';
            wt.EstimatedDuration = 60.00;
            insert wt;
            
            FSL_SMN_DTC__c fslObj = new FSL_SMN_DTC__c();
            fslObj.Name = 'Test FSL';
            fslObj.Status__c = 'Active'; 
            fslObj.FaultTypeFC__c =  'Yes';
            insert fslObj;
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892';
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            //create location //CT2-416
            Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acc.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
            
            //create Address //CT2-416
           Schema.Address addr = new Schema.Address();
            addr.FSL_Site_ID__c = '39';
            addr.Street = '345 Dr';
            addr.City = 'Brisbane';
            addr.State = 'South Australia';
            addr.Country = 'Australia';
            addr.FSL_Tax_District__c ='';
            
            addr.PostalCode = '5000093';
            addr.Latitude = 70.0;
            addr.Longitude = 175.0;
            //addressObj.CreatedById = u.id;
            addr.ParentId = locationObj.Id;
			addr.Account__c = acc.Id;
            insert addr;
            
            Asset ast = new Asset();
            ast.Name = '79788868';
            ast.Warranty_Start_Date__c = date.today();
            ast.Make__c = 'AUTOCAR';
            ast.Type_PSN__c = 'Engines-79788868';
            ast.Service_Model__c = 'ISL G CM2180';
            ast.VIN__c = '5VCACLLE0CH213818';
            ast.Product_Application_Code__c = '10';
            ast.Unit_Number__c = '789';
            ast.Model__c = 'Test';
            ast.VIN__c = 'dsnflksdjlksd';
            ast.Service_Model__c = 'ISX CM570';
            ast.Application_Code__c = '12';
            ast.FSL_Site__c = addr.id;//CT2-416 
            ast.AccountId = acc.Id;
            ast.ContactId = con.Id;
            ast.Type__c = 'Engines';
            insert ast;
            
            Asset ast2 = new Asset();
            ast2.Name = '79988868';
            ast2.Warranty_Start_Date__c = date.today();
            ast2.Make__c = 'AUTOCAR';
            ast2.Type_PSN__c = 'Engines-79988868';
            ast2.Service_Model__c = 'ISL G CM2180';
            ast2.VIN__c = '5VCACLLE0CH213817';
            ast2.Product_Application_Code__c = '10';
            ast2.Unit_Number__c = '789';
            ast2.Model__c = 'Test';
            ast2.VIN__c = 'dsnflksdjksc';
            ast2.Service_Model__c = 'ISX CM570';
            ast2.Application_Code__c = '12';
            ast2.FSL_Site__c = addr.id;//CT2-416 
            ast2.AccountId = acc.Id;
            ast2.ContactId = con.Id;
            ast2.Type__c = 'MARINE GEAR';
            insert ast2;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
           list<Workorder> wolist = new list<workorder>();
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '75148';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
           // wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
            wo.Asset = ast;
            wo.FSL_Make_Model_Flag__c = true;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.RecordTypeId = recTypeId;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'In Shop';
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.Status = 'Intake';
            wo.FSL_SMN__c = fslObj.Id;
           // wo.Status = 'Intake Complete';
            wo.Payer_ContactID__c = payerCon.Id;
            wolist.add(wo);
            //insert wo;
           // By Priyanka to increase cvrg % 
            WorkOrder wo2 = new WorkOrder();
            wo2.WorkTypeId = wt.id;
            wo2.ServiceTerritoryId = sT.Id;
            wo2.Shop_Work_Order__c = '7514876';
            wo2.CSS_Hours__c = 12;
            wo2.Branch_Code__c = subTypeInfo.Branch_Code__c;
            //wo2.Process_Step__c = 'Intake';
            wo2.Make__c = 'AUTOCAR12';
            wo2.Model__c = 'Test2';
            wo2.Asset = ast2;
            wo2.RecordTypeId = recTypeId;
            wo2.FSL_Make_Model_Flag__c = true;
            wo2.AssetId = ast2.Id;
            wo2.AccountId = acc.Id;
            wo2.FSL_SMN__c = fslObj.Id;
            wo2.ContactId = con.Id;
            wo2.Scheduled__c = true;
            wo2.CreatedDate = system.now().addDays(-29);
            wo2.Available_for_Service__c = system.now().addDays(10);
            wo2.FSL_Sub_Type__c = subTypeInfo.id;
            wo2.Repair_Location__c = 'In Shop';
            wo2.Purchase_Order__c = 'Testing';
            wo2.Application__c = '130 - AUTOMOTIVE';
            wo2.Payer__c = acc.Id;
           // wo2.Status = 'Intake Complete';
            wo2.Status = 'Intake';
            wo2.Payer_ContactID__c = payerCon.Id;
            //insert wo2;
            wolist.add(wo2);
            insert wolist;
            
             FSL_MakeModel_Stage__c objstage = new FSL_MakeModel_Stage__c();
            objstage.Manufacturer__c = wo.Make__c;
            objstage.ModelSeries__c = wo.Model__c;
            objstage.ProductApplicationCode__c = ast.Product_Application_Code__c;
            objstage.PSN__c = ast.Name;
            objstage.Type_PSN__c = 'Engines-797888682';
            insert objstage;
            
            list < FSL_MakeModel_Stage__c > lstFsl = new list < FSL_MakeModel_Stage__c > ();
            FSL_MakeModel_Stage__c objMakeModelstg = new FSL_MakeModel_Stage__c();
            objMakeModelstg.ModelSeries__c = 'test';
            objMakeModelstg.PSN__c = 'test';
            objMakeModelstg.Manufacturer__c = 'test';
            objMakeModelstg.Type_PSN__c = 'Engines-79788868';
            lstFsl.add(objMakeModelstg);
            insert lstFsl;
            
            EVL_MakeAndModel.insertMakeModelStaging(wo.Id, true);
            EVL_MakeAndModel.insertMakeModelStaging(wo2.Id, true);
        }
        Test.stopTest();
    }
    
        static testMethod void testlogic2() {
        test.starttest();
        Account a = FSLTestDataSetupCls.createAccountData();
        IAM_CDH_Cross_references__c site = FSLTestDataSetupCls.createSite(a.id);
        asset ast = new asset(name='12345678',Engine_Family__c='testeng',Unit_Type__c='testut',Engine_Family_Code__c='testeng', AccountId=a.id, Product_Application_Code__c = '1',
                              Make__c='testmk',Model__c='tetmodel2', Engine_Manufacturer__c = 'CUMMINS', Type_PSN__c= 'Engines-12345678', Service_Model__c='testsm',Unit_Number__c='testun', site__c=site.id);
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
        if(appCode != null){
            String checkAppCode = appCode.substringBefore('-').trim();
        }
        CSS_JobEventTemporary__c je=new CSS_JobEventTemporary__c();
        je.key__c='MarketingApplicationCodes';
        je.Attribute1__c = '1'; 
        je.Attribute2__c = '130';
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
        EVL_MakeAndModel.validateApplicationCode(wo.Id, appCode);
        
    }
    
}