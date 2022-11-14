@isTest
public class FSL_ServiceOrderUpdateForIA_Test {
    
    @isTest
    public static void TestServiceOrderUpdateForIA() {
        case cs1 = new case();
        cs1.Product_Hours__c = 2;
        cs1.Product_Mileage_Unit__c = 'km';
        cs1.Product_Mileage__c = 1211;
        cs1.Available_for_Service__c = datetime.now() + 2;
        cs1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
        insert cs1;
        workorder wo = new workorder(); 
        wo.CSS_Hours__c=2; 
        wo.Mileage__c= 1211;
        wo.Mileage_Measure__c = 'km';
        wo.CaseId = cs1.id; 
        wo.Available_for_Service__c = cs1.Available_for_Service__c;
        insert wo;
        Case cs2 = [SELECT Id,RecordTypeId, Product_Hours__c, Product_Mileage__c, 
                    Product_Mileage_Unit__c, Available_for_Service__c FROM Case where id = :cs1.id limit 1];
        Test.startTest();
        /*  CS2.id = cs1.id;
        cs2.Product_Hours__c = 3;
        cs2.Product_Mileage_Unit__c = 'mi';
        cs2.Product_Mileage__c = 1212;
        cs2.Available_for_Service__c = datetime.now() + 3;
        update cs2; */
        workorder wo1=new workorder();
        wo1.Id = wo.Id;
        wo1.Available_for_Service__c = cs2.Available_for_Service__c;
        update wo;
        Test.stopTest();
    }
    
    @isTest
    public static  void TestupdateMakeModelSmn1() {
        Asset astUpdate=new Asset();
        astUpdate.Make__c='ISBXL';
        astUpdate.Model__c='EQ567';
        astUpdate.Name='567478';
        astUpdate.Service_Model__c='IE253';
        insert astUpdate;
        workorder wo=new workorder();
        wo.Make__c=astUpdate.Make__c;
        wo.Model__c = astUpdate.Model__c;
        wo.AssetId=astUpdate.id;
        insert wo;
        
        case csUpdate = new case();
        csUpdate.Make__c='ISBXL1';
        csUpdate.Model__c='EQ568';   
        csUpdate.status = 'Intake';
        csUpdate.Product_Mileage_Unit__c = 'mi';
        csUpdate.Service_Model__c='IE254';
        csUpdate.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
        csUpdate.AssetId=astUpdate.id;
        insert csUpdate;
        
        Map<Id,Case> OldMap = new Map<Id,Case>();
        OldMap.put(csUpdate.Id, csUpdate);
        
        csUpdate.ServiceJob__c = wo.Id;
        csUpdate.Product_Hours__c = 3;
        csUpdate.Product_Mileage_Unit__c = 'Kilometers';
        csUpdate.Product_Mileage__c = 42;
        
        Map<Id,Case> caseMap = new Map<Id,Case>();
        caseMap.put(csUpdate.Id, csUpdate);
        
        FSL_ServiceOrderUpdateForIA.updateServiceOrderForIAType(caseMap,OldMap);
        
        Asset astUpdate1 = new Asset(ID=csUpdate.AssetId);
        astUpdate1.Make__c = csUpdate.Make__c;
        astUpdate1.Model__c = csUpdate.Model__c;
        astUpdate1.Service_Model__c = csUpdate.Service_Model__c;
        update astUpdate1;
        
        workorder wo1 = new workorder();
        wo1.Id = wo.Id;
        wo1.Make__c = astUpdate.Make__c;
        wo1.Model__c = astUpdate.Model__c;
        wo1.AssetId = astUpdate.id;
        wo1.CaseId = csUpdate.id;
        update wo;
        
        /* CSS_Make_Model_Access__c cMM=new CSS_Make_Model_Access__c(Id=csUpdate.AssetId);        
        cMM.Make__c=csUpdate.Make__c;
        cMM.Model__c=csUpdate.Model__c;
        cMM.Service_Model_Name__c=csUpdate.Service_Model__c;
        insert cMM; */
    }
    
    @isTest
    public static void TestupdateOthermakeandModel() {
        
        CSS_Make_Model_Access__c cmm1=new CSS_Make_Model_Access__c();
        cmm1.Make__c='ABC';
        cmm1.Model__c='cdf';
        cmm1.EngineFamilyCode__c = 'ENGCODE';
        cmm1.Service_Model_Name__c = 'Tst';
        cmm1.RecordTypeId = Schema.SObjectType.CSS_Make_Model_Access__c.getRecordTypeInfosByName().get('SRTData').getRecordTypeId();
        insert cmm1;
        
        asset ast=new asset();
        ast.name='123456';
        ast.Type__c='Engines';
        ast.Make__c='Test1';
        ast.Model__c='test2';
        ast.Service_Model__c='test3';
        ast.Engine_Family_Code__c = 'ENGCODE';
        ast.Make_Model__c = cmm1.Id;
        insert ast;
        
        OperatingHours operatingHours = new OperatingHours();
        operatingHours.Name = 'Test OperatingHours';
        operatingHours.Description = 'Test OperatingHours';
        insert operatingHours;
        
        ServiceTerritory serviceTerritory = new ServiceTerritory();
        serviceTerritory.Name = 'Test ServiceTerritory Mobile';
        serviceTerritory.IsActive = true; 
        serviceTerritory.Location_Code__c = '01234-01234';
        serviceTerritory.FSL_Service_Territory_Code__c = '01234';
        serviceTerritory.OperatingHoursId = operatingHours.Id;
        serviceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serviceTerritory.Territory__c = 'AUSTRALIA';
        insert serviceTerritory;   
        
        RecordType iaRequestRecTypeId = [SELECT Id,Name
                                         FROM RecordType 
                                         WHERE sObjectType='Case' AND Name='IA Request' LIMIT 1];
        Case caseObj = new Case();
        caseObj.RecordTypeId = iaRequestRecTypeId.Id;
        caseObj.IAS_Number__c = 'IAS00032452';
        caseObj.Status = 'Intake';
        caseObj.Make__c = 'ABC';
        caseObj.Model__c = 'cdf';
        caseObj.Service_Model__c = 'isb219351';
        caseObj.AssetId = ast.id;
        caseObj.Product_Hours__c = 1;
        caseObj.Product_Mileage__c = 65;
        caseObj.Available_for_Service__c = DateTime.Now().AddDays(2);
        insert caseObj;
        
        WorkOrder wo1 = new WorkOrder();
        wo1.ServiceTerritoryId=serviceTerritory.id;
        wo1.AssetId=ast.id;
        wo1.CaseId=caseObj.id;        
        wo1.Status = 'Intake';
        insert wo1;
        
        caseObj.ServiceJob__c = wo1.Id;
        caseObj.Product_Hours__c = 3;
        caseObj.Product_Mileage_Unit__c = 'mi';
        caseObj.Product_Mileage__c = 42;
        caseObj.FSL_ABRFlag__c = true;
        caseObj.FSL_TransactionID__c = '64F6B8CB-5973-4E02-8D51-63C0F3C92C61';
        update caseObj;
        
        Map<Id,Case> OldMap = new Map<Id,Case>();
        OldMap.put(caseObj.Id, caseObj);

        caseObj.ServiceJob__c = wo1.Id;
        caseObj.Product_Hours__c = 62;
        caseObj.Product_Mileage_Unit__c = 'Km';
        caseObj.Product_Mileage__c = 40;
        caseObj.Description = 'Test Comment';
        caseObj.Available_for_Service__c = DateTime.Now().AddDays(2);
        caseObj.IAS_Number__C = 'IAS00032453';
        
        //update caseObj;
        Map<Id,Case> caseMap = new Map<Id,Case>();
        caseMap.put(caseObj.Id, caseObj);
        FSL_Switch__c FSlSwitch = FSL_TestDataUtility.createFSLSwitchRecord('Enable_FTR_Switch', true);
        insert FSlSwitch;
        Test.startTest();
        FSL_ServiceOrderUpdateForIA.updateServiceOrderForIAType(caseMap,OldMap);
        FSL_ServiceOrderUpdateForIA.updateMakeModelSmn(caseMap);
        Test.stopTest();
        List<Service_Order_Extension__c> SOExtensionlst = [SELECT Id, FSL_ABRFlag__c, FSL_TransactionID__c 
                                                          FROM Service_Order_Extension__c];
        if(SOExtensionlst != null && SOExtensionlst.size() > 0){
            System.assertEquals(SOExtensionlst[0].FSL_ABRFlag__c, caseObj.FSL_ABRFlag__c);
            System.assertEquals(SOExtensionlst[0].FSL_TransactionID__c, caseObj.FSL_TransactionID__c);
        }
    }
}