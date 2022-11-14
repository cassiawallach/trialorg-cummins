@isTest
public class FSL_CL_ApplicationErrorMessage_Test {
    
    @isTest
    static void insertErrTest() {
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
         CSS_JobEventTemporary__c  JobEvent = new CSS_JobEventTemporary__c();
        JobEvent.Attribute1__c  = 'BB';
        JobEvent.Attribute2__c  = '130';
        JobEvent.Attribute3__c  = 'test att3';
        JobEvent.Attribute5__c  = 'test att5';
        JobEvent.Key__c  = 'MarketingApplicationCodes';
        List<CSS_JobEventTemporary__c>  JobEvents = new List<CSS_JobEventTemporary__c>();
        JobEvents.add(JobEvent);
        Insert JobEvents;
        
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
        objAsset.Product_Application_Code__c = 'BB';
        objAsset.Application__c = '130 - AUTOMOTIVE';
        insert objAsset;
        
        Asset objAsset1 = new Asset();
        objAsset1.Name = '79788456';
        objAsset1.accountId =  objAccount.Id;
        objAsset1.Type_PSN__c = 'Engines-79788888';
        objAsset1.Product_Application_Code__c = '';
        
        insert objAsset1;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Shop_Work_Order__c='12345';
        objWorkOrder.Process_Step__c = 'Intake';
         objWorkOrder.Application__c = '130 - AUTOMOTIVE';
        insert objWorkOrder;
        
        
        test.startTest();
        map<id,workorder> mapOld = new map<id,workorder>([select id,AccountId,AssetId,Payer__c,Shop_Work_Order__c from WorkOrder]);
        map<id,workorder> mapnew = new map<id,workorder>();
        for(id key:mapOld.keyset())
        {
            workorder woObj = mapOld.get(key);
            if(woObj.AssetId == objAsset1.Id)
            {
                woObj.AssetId = objAsset.Id;
            }else{
                woObj.AssetId = objAsset1.Id;    
            }            
            mapnew.put(key,woObj);
        }
        FSL_CL_ApplicationErrorMessage.insertErrMessage(new List<WorkOrder>{objWorkOrder});
        FSL_CL_ApplicationErrorMessage.updateErrMessage(mapnew, mapOld);
        objWorkOrder.AssetId = objAsset1.Id;
        update objWorkOrder;
        
        workorder wo = [select id,AssetId from WorkOrder limit 1];
        wo.AssetId = objAsset1.Id;
        update wo;
        
        test.stopTest();
        list<WorkOrder>  wolist=new List<WorkOrder>();
        wolist.add(objWorkOrder);
        
        objWorkOrder.AssetId = objAsset1.Id;
        
        update objWorkOrder;
        
        list<WorkOrder>  wolist1=new List<WorkOrder>();
        
        objWorkOrder.AssetId = null;
        wolist1.add(objWorkOrder);
        System.debug('$$$'+ wolist1);
        update wolist1;
        FSL_CL_ApplicationErrorMessage.insertErrMessage(wolist1);
    }
    @isTest
    static void errMsgUpdateTest() {
        Test.startTest();
        
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
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount1 = new Account();
        objAccount1.RecordTypeId = accRecId;
        objAccount1.Name = 'Account';
        objAccount1.FSL_Payer_Code__c	= '45689';
        objAccount1.FSL_ERP_Customer_Code__c ='456';
        
        insert objAccount1;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';        
        insert objWorkType;
        
        List<Asset> assetList = new List<Asset>();
        Asset objAsset = new Asset();
        objAsset.Name = '79788868';
        objAsset.accountId =  objAccount1.Id;
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Type__c = 'Engines';
        objAsset.Product_Application_Code__c = 'BB';
        objAsset.Application__c = '130 - AUTOMOTIVE';
        assetList.add(objAsset);
        
        Asset objAsset1 = new Asset();
        objAsset1.Name = '79788456';
        objAsset1.accountId =  objAccount1.Id;
        objAsset1.Type_PSN__c = 'Engines-79788888';
        objAsset1.Product_Application_Code__c = 'aa';
        objAsset1.Application__c = '410 - FIRE TRUCK';
        
        
        assetList.add(objAsset1);
        insert assetList;
        
        
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount1.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Shop_Work_Order__c='12345';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder .FSL_Application_Error_Message__c = '';
        insert objWorkOrder;
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        //objWorkOrder.AssetId = objAsset1.Id;
        //update objWorkOrder;
        
        CSS_JobEventTemporary__c  JobEvent = new CSS_JobEventTemporary__c();
        JobEvent.Attribute1__c  = 'aa';
        JobEvent.Attribute2__c  = '410 ';
        JobEvent.Attribute3__c  = 'test att3';
        JobEvent.Attribute5__c  = 'test att5';
        JobEvent.Key__c  = 'MarketingApplicationCodes';
        List<CSS_JobEventTemporary__c>  JobEvents = new List<CSS_JobEventTemporary__c>();
        JobEvents.add(JobEvent);
        Insert JobEvents;
        
        
        WorkOrder objWorkOrder2 = new WorkOrder();
        objWorkOrder2.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder2.Status = 'Intake';
        objWorkOrder2.AccountId = objAccount1.Id;
        objWorkOrder2.WorkTypeId = objWorkType.Id;
        objWorkOrder2.AssetId = objAsset1.Id;
        objWorkOrder2.Shop_Work_Order__c='12345';
        objWorkOrder2.Process_Step__c = 'Intake';
        objWorkOrder2 .FSL_Application_Error_Message__c = '';
        insert objWorkOrder2;
        
        Map<Id, WorkOrder> newMap = new Map<Id, WorkOrder>();
        newMap.put(objWorkOrder.id,objWorkOrder);
        
        Map<Id, WorkOrder> OldMap = new Map<Id, WorkOrder>();
        OldMap.put(objWorkOrder.id,objWorkOrder2);
        try{
        FSL_CL_ApplicationErrorMessage.updateErrMessage(newMap,OldMap);
        }
        Catch(Exception ex){}
        
        //FSL_GetSolutions.upsertAdminSRT(objWorkOrder.Id);
        //FSL_CL_ApplicationErrorMessage.updateErrMessage(newMap, oldMap);
        Test.stopTest();
    }
}