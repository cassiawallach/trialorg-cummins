@isTest
public class FSL_populatePayer_Test {
    @isTest
    static void payerTest()
    {
        
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/Getwarrantydocs';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_QSOL_Getwarrantydocs';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/GetApiTokenQSOL';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        objAccount.FSL_Payer_Code__c = '456';
        objAccount.FSL_ERP_Customer_Code__c = '336';
        insert objAccount;
        
        Account objAccount1 = new Account();
        objAccount1.RecordTypeId = accRecId;
        objAccount1.Name = 'Account';
        objAccount1.FSL_Payer_Code__c   = '45689';
        objAccount1.FSL_ERP_Customer_Code__c ='456';
        insert objAccount1;
        
        Account objAccount2 = new Account();
        objAccount2.RecordTypeId = accRecId;
        objAccount2.Name = 'Account';        
        objAccount2.FSL_ERP_Customer_Code__c ='45689';
        insert objAccount2;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';        
        insert objWorkType;
        
        Asset objAsset = new Asset();
        objAsset.Name = '79788868';
        objAsset.accountId =  objAccount.Id;
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Type__c = 'Engines';
        insert objAsset;
        
        Asset objAsset1 = new Asset();
        objAsset1.Name = '79788456';
        objAsset1.accountId =  objAccount1.Id;
        objAsset1.Type_PSN__c = 'Engines-79788888';
        insert objAsset1;
                
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Shop_Work_Order__c='12345';
        objWorkOrder.Process_Step__c = 'Intake';
        insert objWorkOrder;
        
        map<id,workorder> mapOld = new map<id,workorder>([select id,AccountId,AssetId,Payer__c,Shop_Work_Order__c from WorkOrder]);
        map<id,workorder> mapnew = new map<id,workorder>();
        for(id key:mapOld.keyset())
        {
            workorder woObj = mapOld.get(key);
            if(woObj.AccountId == objAccount2.Id)
            {
                woObj.AccountId = objAccount1.Id;
            }else{
                woObj.AccountId = objAccount2.Id;    
            }            
            mapnew.put(key,woObj);
        }
        
        test.startTest();
        FSL_populatePayer.updatePayer(mapnew,mapOld);
        objWorkOrder.AccountId = objAccount2.Id;
        update objWorkOrder;
        
        workorder wo = [select id,AccountId from WorkOrder limit 1];
        wo.AccountId = objAccount1.Id;
        update wo;
        
        
       // test.stopTest();
        list<WorkOrder>  wolist=new List<WorkOrder>();
        wolist.add(objWorkOrder);
        
        objWorkOrder.AssetId = objAsset1.Id;
      
        update objWorkOrder;
        
        list<WorkOrder>  wolist1=new List<WorkOrder>();
      
        objWorkOrder.AccountId = null;
        wolist1.add(objWorkOrder);
        System.debug('$$$'+ wolist1);
        update wolist1;
        test.stopTest();
        FSL_populatePayer.updatePayerOnInsert(wolist1);
        
    }
    
    @isTest
    static void payerUpdateTest() {
        
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        List<Account> accList = new List<Account>();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        objAccount.FSL_Payer_Code__c = '456';
        objAccount.FSL_ERP_Customer_Code__c = '336';
        accList.add(objAccount);
        
        Account objAccount1 = new Account();
        objAccount1.RecordTypeId = accRecId;
        objAccount1.Name = 'Account';
        objAccount1.FSL_Payer_Code__c   = '45689';
        objAccount1.FSL_ERP_Customer_Code__c ='456';
        accList.add(objAccount1);
        
        Account objAccount2 = new Account();
        objAccount2.RecordTypeId = accRecId;
        objAccount2.Name = 'Account';        
        objAccount2.FSL_ERP_Customer_Code__c ='45689';
        accList.add(objAccount2);
        
        insert accList;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';        
        insert objWorkType;
        
        List<Asset> assetList = new List<Asset>();
        Asset objAsset = new Asset();
        objAsset.Name = '79788868';
        objAsset.accountId =  objAccount.Id;
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Type__c = 'Engines';
        assetList.add(objAsset);
        
        Asset objAsset1 = new Asset();
        objAsset1.Name = '79788456';
        objAsset1.accountId =  objAccount1.Id;
        objAsset1.Type_PSN__c = 'Engines-79788888';
        assetList.add(objAsset1);
        
        insert assetList;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Shop_Work_Order__c='12345';
        objWorkOrder.Process_Step__c = 'Intake';
        insert objWorkOrder;
        
        Map<Id, WorkOrder> oldMap = new Map<Id, WorkOrder>();
        oldMap.put(objWorkOrder.id,objWorkOrder);
        
        Test.startTest();
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        objWorkOrder.AssetId = objAsset1.Id;
        //update objWorkOrder;
        
        Map<Id, WorkOrder> newMap = new Map<Id, WorkOrder>();
        newMap.put(objWorkOrder.id, objWorkOrder);
        
        FSL_populatePayer.updatePayer(newMap,oldMap);
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        objWorkOrder.AssetId = objAsset1.Id;
        update objWorkOrder;
        
        Test.stopTest();
    }
    
    @isTest
    static void payerUpdateTestAccount() {        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        List<Account> accList = new List<Account>();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        objAccount.FSL_Payer_Code__c = '456';
        objAccount.FSL_ERP_Customer_Code__c = '336';
        accList.add(objAccount);
        
        Account objAccount1 = new Account();
        objAccount1.RecordTypeId = accRecId;
        objAccount1.Name = 'Account';
        objAccount1.FSL_Payer_Code__c   = '45689';
        objAccount1.FSL_ERP_Customer_Code__c ='456';
        accList.add(objAccount1);
        
        Account objAccount2 = new Account();
        objAccount2.RecordTypeId = accRecId;
        objAccount2.Name = 'Account';        
        objAccount2.FSL_ERP_Customer_Code__c ='45689';
        accList.add(objAccount2);
        
        insert accList;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';        
        insert objWorkType;
        
        List<Asset> assetList = new List<Asset>();
        Asset objAsset = new Asset();
        objAsset.Name = '79788868';
        objAsset.accountId =  objAccount.Id;
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Type__c = 'Engines';
        assetList.add(objAsset);
        
        Asset objAsset1 = new Asset();
        objAsset1.Name = '79788456';
        objAsset1.accountId =  objAccount1.Id;
        objAsset1.Type_PSN__c = 'Engines-79788888';
        assetList.add(objAsset1);
        
        insert assetList;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Shop_Work_Order__c='12345';
        objWorkOrder.Process_Step__c = 'Intake';
        insert objWorkOrder;
        
        Map<Id, WorkOrder> oldMap = new Map<Id, WorkOrder>();
        oldMap.put(objWorkOrder.id,objWorkOrder);
        
        Test.startTest();
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        objWorkOrder.AccountId = objAccount1.Id;
        //update objWorkOrder;
        
        Map<Id, WorkOrder> newMap = new Map<Id, WorkOrder>();
        newMap.put(objWorkOrder.id, objWorkOrder);
        
        FSL_populatePayer.updatePayer(newMap,oldMap);
        
        Test.stopTest();
    }
    
}