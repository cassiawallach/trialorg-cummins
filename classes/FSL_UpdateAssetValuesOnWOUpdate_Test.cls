@isTest
public class FSL_UpdateAssetValuesOnWOUpdate_Test {
        //added comment by sravanthi for migration test run
    private static String getRandomString() {
        String rs = String.valueOf(Math.random() * Datetime.now().getTime());
        return rs.substring(rs.length() - 15, rs.length() - 5);
    }
    
    @isTest
    private static void updateWoDetailsTest1() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;

        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        asset.Unit_Number__c = '123';
        asset.Registration__c = '1234';
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.Unit_NB__c = asset.Unit_Number__c;
        wo21.Registration__c = asset.Registration__c;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'Dealer';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.Repair_Location__c = 'Mobile';
        
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    
    @isTest
    private static void updateWoDetailsTest2() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
       Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;
        
        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        // asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        //  asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        // asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        //  asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.Repair_Location__c = 'Mobile';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    @isTest
    private static void updateWoDetailsTest3() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
       acct.Name = 'Test Account ';
          acct.RecordTypeId = accGCRecId;
            acct.BillingStreet = '1466 N National Rd';
            acct.BillingCity = 'Columbus';
            acct.BillingState = 'Indiana';
            acct.BillingCountry= 'United States';
            acct.BillingPostalCode = '47201';
            acct.FSL_ERP_Customer_Code__c = '';
			acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
       Schema.Location locationObj = new Schema.Location();
				locationObj.Name = 'Test';
				locationObj.FSL_Account__c = acct.Id;
				locationObj.FSL_Contact_ID__c = '10';
				insert locationObj;
			
			Schema.Address addressObj = new Schema.Address();
				addressObj.FSL_Site_ID__c = '39';
				addressObj.Street = '345 Dr';
				addressObj.City = 'Brisbane';
				addressObj.State = 'South Australia';
				addressObj.Country = 'Australia';
				addressObj.FSL_Tax_District__c ='';
				addressObj.PostalCode = '5000093';
				addressObj.Latitude = 70.0;
				addressObj.Longitude = 175.0;
				addressObj.ParentId = locationObj.Id;
				addressObj.Account__c = acct.Id;
                insert addressObj;
                       
        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        // asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        //  asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.Repair_Location__c = 'Mobile';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    @isTest
    private static void updateWoDetailsTest4() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
         Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;

        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.Repair_Location__c = 'In Shop';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    
    @isTest
    private static void updateWoDetailsTest5() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
       Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;

        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        //asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        // asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.Repair_Location__c = 'In Shop';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    @isTest
    private static void updateWoDetailsTest6() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
       Schema.Location locationObj = new Schema.Location();
				locationObj.Name = 'Test';
				locationObj.FSL_Account__c = acct.Id;
				locationObj.FSL_Contact_ID__c = '10';
				insert locationObj;
			
			Schema.Address addressObj = new Schema.Address();
				addressObj.FSL_Site_ID__c = '39';
				addressObj.Street = '345 Dr';
				addressObj.City = 'Brisbane';
				addressObj.State = 'South Australia';
				addressObj.Country = 'Australia';
				addressObj.FSL_Tax_District__c ='';
				addressObj.PostalCode = '5000093';
				addressObj.Latitude = 70.0;
				addressObj.Longitude = 175.0;
				addressObj.ParentId = locationObj.Id;
				addressObj.Account__c = acct.Id;
                insert addressObj; 
                       
        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        // asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        // asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.Repair_Location__c = 'In Shop';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    @isTest
    private static void updateWoDetailsTest7() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
       Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;

        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = asset.AccountId;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.Repair_Location__c = 'In Shop';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    @isTest
    private static void updateWoDetailsTest8() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
 Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;

        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        // wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.ServiceTerritoryId = objServiceTerritory.Id;
        wo21.Repair_Location__c = 'In Shop';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,ServiceTerritoryId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.ServiceTerritoryId = objServiceTer.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    
    @isTest
    private static void updateWoDetailsTest9_new() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
		acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;
        
        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        RecursiveTriggerHandler.chkSRAccountId=true;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = '';
        wo21.RecordTypeId = intakeRTID;
        wo21.ServiceTerritoryId = objServiceTerritory.Id;
        wo21.Repair_Location__c = 'In Shop';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,ServiceTerritoryId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.id;
        wo.Repair_Location__c = 'Mobile';
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    
    @isTest
    private static void updateWoDetailsTest9() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;
        
        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.ServiceTerritoryId = objServiceTerritory.Id;
        wo21.Repair_Location__c = 'In Shop';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,ServiceTerritoryId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.id;
        wo.Repair_Location__c = 'Mobile';
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    
    
    @isTest
    private static void updateWoDetailsTest10() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
         Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;
        
               
        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Repair';
        wo21.AccountId = acct.id;
        wo21.AssetId = asset.id;
        wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.ServiceTerritoryId = objServiceTerritory.Id;
        wo21.Repair_Site_Address__c = addressObj.id;
        wo21.Repair_Location__c = 'Mobile';
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,Asset.AccountId,ServiceTerritoryId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.AssetId = asset1.id;
        wo.Repair_Location__c = 'In Shop';
        wo.Repair_Site_Address__c = null;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    
    @isTest
    private static void updateWoDetailsTest11() {
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Id evalRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test Account ';
        acct.BillingStreet = '1466 N National Rd';
        acct.BillingCity = 'Columbus';
        acct.BillingState = 'Indiana';
        acct.BillingCountry= 'United States';
        acct.BillingPostalCode = '47201';
        acct.FSL_ERP_Customer_Code__c = '';
        acct.Email_Notification_Frequency__c = 'Nightly';
        insert acct;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
       Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = acct.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = acct.Id;
            insert addressObj;
        
       
        List<Asset> assList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = getRandomString();
        asset.Type_PSN__c = getRandomString();
        asset.Type__c = 'Engines';
        asset.AccountId = acct.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c = Date.today() - 100;
        asset.FSL_Site__c = addressObj.Id;
        Insert asset;
        //assList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = getRandomString();
        asset1.Type_PSN__c = getRandomString();
        asset1.Type__c = 'Engines';
        asset1.AccountId = acct.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id;
        //assList.add(asset1);
        Insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> serList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = getRandomString();
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = getRandomString();
        objServiceTerritory.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTerritory);
        
        ServiceTerritory objServiceTer = new ServiceTerritory();
        objServiceTer.Name = getRandomString();
        objServiceTer.IsActive = true; 
        objServiceTer.Location_Code__c = getRandomString();
        objServiceTer.FSL_Service_Territory_Code__c = getRandomString();
        objServiceTer.OperatingHoursId = objOperatingHours.Id;
        objServiceTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTer.Territory__c = 'AUSTRALIA';
        serList.add(objServiceTer);
        insert serList;
        
        WorkOrder wo21 = new WorkOrder();
        wo21.Status = 'Intake';
        wo21.ESN_Insite__c = getRandomString();
        wo21.Process_Step__c = 'Intake';
        // wo21.AccountId = acct.id;
        // wo21.AssetId = null;
        //  wo21.WorkTypeId = workType.Id;
        wo21.Type__c = 'External';
        // wo21.Shop_Work_Order__c = getRandomString();
        wo21.RecordTypeId = intakeRTID;
        wo21.ServiceTerritoryId = objServiceTerritory.Id;
        Map<Id,Workorder> oldmap = new Map<Id,workorder>();
        Map<Id,Workorder> newmap = new Map<Id,workorder>();
        insert wo21;
        WorkOrder wo = [SELECT ID,Repair_Location__c,AccountId,AssetId,Asset.AccountId,ServiceTerritoryId,WorkTypeId FROM WorkOrder WHERE Id=:wo21.Id];
        oldmap.put(wo21.Id,wo21);
        wo.ServiceTerritoryId = objServiceTer.Id;
        update wo;
        newmap.put(wo.Id,wo);
        FSL_UpdateAssetValuesOnWOUpdate.updateWoDetails(newmap,oldmap);
        
    }
    @isTest
    private static void TestUpdateWODetails_updateAssetWorkOrderFields() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accGCRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';   
        
        Account account1 = new Account();
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test Account ';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        account1.FSL_ERP_Customer_Code__c = '';
		account1.Email_Notification_Frequency__c = 'Nightly';
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = account1.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = account1.Id;
            insert addressObj;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c =date.today() - 100;
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.FSL_Site__c = addressObj.Id;
        asset1.Customer_Name__c = 'Test';//CT2-416
        assetList.add(asset1);
        
        insert assetList;
        
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
        ServiceTerritory.Mileage_Measure__c = 'Miles';
        serviceTerritory.Territory__c = 'AUSTRALIA';
        insert serviceTerritory; 
        
        List<Case> listCase = new List<Case>();
        Case cse = new Case();
        cse.Accountid = account1.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.Error_Type__c = '';
        cse.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FSL Reported Problem').getRecordTypeId();       
        listCase.add(cse);
        
       /** Case cse1 = new Case();
        cse1.Accountid = account1.Id;
        cse1.Description = 'TestDescription';
        cse1.Status = 'New';
        cse1.Subject = 'TestSubject';
        cse1.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FSL Reported Problem').getRecordTypeId();       
        cse1.Error_Type__c='Access - Business Reports';
        listCase.add(cse1);**/
        insert listCase;
        
        
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        wo1.AccountId = account1.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        wo1.Warranty_Start_Date__c =asset.Warranty_Start_Date__c;
        wo1.AssetId = assetList[0].Id;
        wo1.CaseId=listCase[0].Id;
            
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'Dealer'; 
        wo2.Repair_Location__c = 'Mobile';
        wo2.AssetId = assetList[1].Id;
        
         WorkOrder wo3 = new WorkOrder();
        wo3.RecordTypeId = intakeRTID;
        wo3.Status = 'Intake';
        wo3.ESN_Insite__c = '79799702';
        wo3.Process_Step__c = 'Intake';
        wo3.AccountId = account1.Id;
        wo3.WorkTypeId = workType.Id;
        wo3.Type__c = 'External'; 
        wo3.ServiceTerritoryId=serviceTerritory.id;
        wo3.Shop_Work_Order__c = '123124';
        wo3.Repair_Location__c = 'Mobile';
        wo3.Warranty_Start_Date__c =asset.Warranty_Start_Date__c;
        wo3.AssetId = assetList[0].Id;
        wo3.CaseId=listCase[0].Id;
        
        WorkOrder wo4 = new WorkOrder();
        wo4.RecordTypeId = intakeRTID;
        wo4.Status = 'Intake';
        wo4.ESN_Insite__c = '79799702';
        wo4.Process_Step__c = 'Intake';
        wo4.AccountId = account.Id;
        wo4.WorkTypeId = workType.Id;
        wo4.Type__c = 'Dealer'; 
        wo4.Repair_Location__c = 'Mobile';
        wo4.AssetId = assetList[1].Id;
        
        
        List<Workorder> wolistrec=new List<Workorder>();
        wolistrec.add(wo2);
        wolistrec.add(wo1);
        //wolistrec.add(wo3);
        //wolistrec.add(wo4);
        Insert wolistrec;
        test.starttest();
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        WO1.assetId= assetList[0].Id;
        WO2.assetId= assetList[1].Id;
        update WO1;
        update WO2;
        FSL_UpdateAssetValuesOnWOUpdate.updateAssetWorkOrderFields(WO2);
         FSL_UpdateAssetValuesOnWOUpdate.updateAssetWorkOrderFields(WO1);
         //FSL_UpdateAssetValuesOnWOUpdate.updateAssetWorkOrderFields(WO3);
         //FSL_UpdateAssetValuesOnWOUpdate.updateAssetWorkOrderFields(WO4);
        test.stopTest();
    }
    
    @isTest
    private static void TestUpdateWODetails_updateAssetWorkOrderFields_new() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accGCRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';   
        
        Account account1 = new Account();
            account1.RecordTypeId = accGCRecId;
            account1.Name = 'Test Account ';
            account1.BillingStreet = '1466 N National Rd';
            account1.BillingCity = 'Columbus';
            account1.BillingState = 'Indiana';
            account1.BillingCountry= 'United States';
            account1.BillingPostalCode = '47201';
            account1.FSL_ERP_Customer_Code__c = '';
			account1.Email_Notification_Frequency__c = 'Nightly';
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = account1.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = account1.Id;
            insert addressObj;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c =date.today() - 100;
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.FSL_Site__c = addressObj.Id;
        asset1.Customer_Name__c = 'Test';//CT2-416
        assetList.add(asset1);
        
        insert assetList;
        
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
        ServiceTerritory.Mileage_Measure__c = 'Miles';
        serviceTerritory.Territory__c = 'AUSTRALIA';
        insert serviceTerritory; 
        
        List<Case> listCase = new List<Case>();
        Case cse = new Case();
        cse.Accountid = account1.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.Error_Type__c = '';
        cse.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FSL Reported Problem').getRecordTypeId();       
        listCase.add(cse);
        
       /** Case cse1 = new Case();
        cse1.Accountid = account1.Id;
        cse1.Description = 'TestDescription';
        cse1.Status = 'New';
        cse1.Subject = 'TestSubject';
        cse1.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('FSL Reported Problem').getRecordTypeId();       
        cse1.Error_Type__c='Access - Business Reports';
        listCase.add(cse1);**/
        insert listCase;
        
        
        List<WorkOrder> WOList = new List<WorkOrder>();
       
         WorkOrder wo3 = new WorkOrder();
        wo3.RecordTypeId = intakeRTID;
        wo3.Status = 'Intake';
        wo3.ESN_Insite__c = '79799702';
        wo3.Process_Step__c = 'Intake';
        wo3.AccountId = account1.Id;
        wo3.WorkTypeId = workType.Id;
        wo3.Type__c = 'Dealer'; 
        wo3.ServiceTerritoryId=serviceTerritory.id;
        wo3.Shop_Work_Order__c = '123124';
        wo3.Repair_Location__c = 'Mobile';
        wo3.Warranty_Start_Date__c =asset.Warranty_Start_Date__c;
        wo3.AssetId = assetList[0].Id;
        wo3.CaseId=listCase[0].Id;
        
        WorkOrder wo4 = new WorkOrder();
        wo4.RecordTypeId = intakeRTID;
        wo4.Status = 'Intake';
        wo4.ESN_Insite__c = '79799702';
        wo4.Process_Step__c = 'Intake';
        wo4.AccountId = account.Id;
        wo4.WorkTypeId = workType.Id;
        wo4.Type__c = 'External'; 
        wo4.Repair_Location__c = 'Mobile';
        wo4.AssetId = assetList[1].Id;
         wo4.ServiceTerritoryId=serviceTerritory.id;
        
        
        List<Workorder> wolistrec=new List<Workorder>();
       // wolistrec.add(wo2);
       // wolistrec.add(wo1);
        wolistrec.add(wo3);
        wolistrec.add(wo4);
        Insert wolistrec;
        test.starttest();
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
         FSL_UpdateAssetValuesOnWOUpdate.updateAssetWorkOrderFields(WO3);
         FSL_UpdateAssetValuesOnWOUpdate.updateAssetWorkOrderFields(WO4);
        test.stopTest();
    }
    
    @isTest
    private static void TestUpdateWOAssetWithOutAcc() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accGCRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        
         Account account1 = new Account();
            account1.RecordTypeId = accGCRecId;
            account1.Name = 'Test Account ';
            account1.BillingStreet = '1466 N National Rd';
            account1.BillingCity = 'Columbus';
            account1.BillingState = 'Indiana';
            account1.BillingCountry= 'United States';
            account1.BillingPostalCode = '47201';
            account1.FSL_ERP_Customer_Code__c = '';
			account1.Email_Notification_Frequency__c = 'Nightly';
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'First',
                                      LastName = 'Mishra',
                                      IAM_Contact_Status__c = 'Active',
                                      Username__c = 'testmishra@mymail.com',
                                      Email = 'testmishra@mymail.com',
                                      AccountId = account1.Id,
                                      RecordTypeId = conRecId);
        //Insert contact;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = account1.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = account1.Id;
            insert addressObj;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        //asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c =date.today() - 100;
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.FSL_Site__c = addressObj.Id; //CT2-416
        asset1.Warranty_Start_Date__c =date.today() - 100;
        assetList.add(asset1);
        
        insert assetList;
        
        
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
        
        
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        wo1.AccountId = account1.Id;
        wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        //  wo1.CaseId = cse2.id;
        WOList.add(wo1);
        
        System.debug('WorkOrder_Test wo.Type__c::'+ wo1.Type__c+ ':: wo.AssetId::'+ wo1.AssetId);           
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Repair_Location__c = 'Mobile';
        // wo1.CaseId = cse3.id;
        WOList.add(wo2);
        
        insert WOList;
        System.debug('WorkOrder_Test wo.Type__c::'+ wo1.Type__c+ ':: wo.AssetId::'+ wo1.AssetId); 
        List<WorkOrder> WOListToUpdate = new List<WorkOrder>();
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        wo1.AssetId = asset1.Id; 
        wo2.AssetId = asset.Id; 
        WOListToUpdate.add(wo1);
        WOListToUpdate.add(wo2);
        update WOListToUpdate;
        
        Test.stopTest();
    }
    
    //Condition - 3
    //(wo.AssetId == null && wo.Repair_Site_Name__c != null && wo.Repair_Site_Name__c == oldMap.get(wo.Id).Repair_Site_Name__c){
  
    //Condition - 4 (Wo-Addres update when Repair Site is null and is changed)
 /**   @isTest
    private static void TestUpdateWOBlankRepairSite() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        
         Account account1 = new Account();
            account1.RecordTypeId = accGCRecId;
            account1.Name = 'Test Account ';
            account1.BillingStreet = '1466 N National Rd';
            account1.BillingCity = 'Columbus';
            account1.BillingState = 'Indiana';
            account1.BillingCountry= 'United States';
            account1.BillingPostalCode = '47201';
            account1.FSL_ERP_Customer_Code__c = '';
			account1.Email_Notification_Frequency__c = 'Nightly';
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        //CT2-416 : create location
        List<Schema.Location> locationList = new List<Schema.Location>();
         Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = account1.Id;
            locationObj.FSL_Contact_ID__c = '10';
        locationList.add(locationObj);
        
        Schema.Location locationObj1 = new Schema.Location();
        locationObj1.Name = 'Test';
        locationObj1.FSL_Account__c = account.Id;
        locationObj1.FSL_Contact_ID__c = '11';
        locationList.add(locationObj1);
        
        //CT2-416 :create Address
        List<Schema.Address> siteList = new List<Schema.Address>();
      Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = account1.Id;
        siteList.add(addressObj);
        insert siteList;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        //asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c =date.today() - 100;
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account.Id;
        asset1.Warranty_Start_Date__c =date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id; //CT2-416
        assetList.add(asset1);
        
        insert assetList;
        
        
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
        
        
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        wo1.AccountId = account.Id;
        wo1.AssetId = asset1.Id; 
        wo1.Repair_Site_Address__c = addressObj.Id; //CT2-416
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        // wo1.CaseId = cse6.id;
        WOList.add(wo1);
        
        //The Repair Site associated with the Asset is Inactive or not tied to the selected Account. Please pick / create a Repair Site associated to the Account.: [Repair_Site_Name__c]
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Repair_Site_Address__c = addressObj.Id;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account.Id; 
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Repair_Location__c = 'Mobile';
        //  wo2.CaseId = cse7.id;
        WOList.add(wo2);
        
        WorkOrder wo3 = new WorkOrder();
        wo3.RecordTypeId = intakeRTID;
        wo3.Repair_Site_Address__c = addressObj.Id;
        wo3.Status = 'Intake';
        wo3.ESN_Insite__c = '79799702';
        wo3.Process_Step__c = 'Intake';
        wo3.AccountId = account.Id; 
        wo3.WorkTypeId = workType.Id;
        wo3.Type__c = 'External'; 
        wo3.Repair_Location__c = 'Mobile';
        //  wo2.CaseId = cse7.id;
        WOList.add(wo3);
        
        insert WOList;
        
        List<WorkOrder> WOListToUpdate = new List<WorkOrder>();
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        wo1.Repair_Site_Address__c = null;
        wo1.Repair_Location__c = 'In Shop';
        wo2.Repair_Site_Address__c = addressObj.Id; //CT2-416
        wo3.Repair_Site_Address__c = null;
        wo3.Repair_Location__c = 'In Shop';
        WOListToUpdate.add(wo1);
        WOListToUpdate.add(wo2);
        WOListToUpdate.add(wo3);
        update WOListToUpdate;
        
        Test.stopTest();
    }**/
    
    //Condition - 5 (Wo-Address update when Repair Site is changed & not blank)
    @isTest
    private static void TestUpdateWOInShopDetails() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'First',
                                      LastName = 'Mishra',
                                      IAM_Contact_Status__c = 'Active',
                                      Username__c = 'testmishra@mymail.com',
                                      Email = 'testmishra@mymail.com',
                                      AccountId = account1.Id,
                                      RecordTypeId = conRecId);
        //Insert contact;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
         
        Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = account1.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = account1.Id;
            insert addressObj;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.AccountId = account.Id;
        asset.Warranty_Start_Date__c =date.today() - 100;
        asset.Customer_Name__c = 'New Customer';
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.Warranty_Start_Date__c =date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id; //CT2-416
        assetList.add(asset1);
        
        insert assetList;
        
        
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
        
        
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        wo1.AccountId = account1.Id;
        wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'In Shop';
        //   wo1.CaseId = cse8.id;
        WOList.add(wo1);
        
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Repair_Location__c = 'In Shop';
        //  wo2.CaseId = cse9.id;
        WOList.add(wo2);
        
        insert WOList;
        
        List<WorkOrder> WOListToUpdate = new List<WorkOrder>();
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        wo1.AssetId = asset1.Id; 
        wo2.AssetId = asset.Id; 
        WOListToUpdate.add(wo1);
        WOListToUpdate.add(wo2);
        update WOListToUpdate;
        
        Test.stopTest();
    }
    
    @isTest
    private static void TestUpdateWOInShopAssetWithOutAcc() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        
         Account account1 = new Account();
            account1.RecordTypeId = accGCRecId;
            account1.Name = 'Test Account ';
            account1.BillingStreet = '1466 N National Rd';
            account1.BillingCity = 'Columbus';
            account1.BillingState = 'Indiana';
            account1.BillingCountry= 'United States';
            account1.BillingPostalCode = '47201';
            account1.FSL_ERP_Customer_Code__c = '';
			account1.Email_Notification_Frequency__c = 'Nightly';
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'First',
                                      LastName = 'Mishra',
                                      IAM_Contact_Status__c = 'Active',
                                      Username__c = 'testmishra@mymail.com',
                                      Email = 'testmishra@mymail.com',
                                      AccountId = account1.Id,
                                      RecordTypeId = conRecId);
        //Insert contact;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
       Schema.Location locationObj = new Schema.Location();
            locationObj.Name = 'Test';
            locationObj.FSL_Account__c = account1.Id;
            locationObj.FSL_Contact_ID__c = '10';
            insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
            addressObj.FSL_Site_ID__c = '39';
            addressObj.Street = '345 Dr';
            addressObj.City = 'Brisbane';
            addressObj.State = 'South Australia';
            addressObj.Country = 'Australia';
            addressObj.FSL_Tax_District__c ='';
            addressObj.PostalCode = '5000093';
            addressObj.Latitude = 70.0;
            addressObj.Longitude = 175.0;
            addressObj.ParentId = locationObj.Id;
			addressObj.Account__c = account1.Id;
            insert addressObj;
        
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        //asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.Warranty_Start_Date__c =date.today() - 100;
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.Warranty_Start_Date__c =date.today() - 100;
        asset1.FSL_Site__c = addressObj.Id; //CT2-416
        assetList.add(asset1);
        
        insert assetList;
        
        
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
        
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        wo1.AccountId = account1.Id;
        wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'In Shop';
        //  wo1.CaseId = cse10.id;
        WOList.add(wo1);
        
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        //wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Repair_Location__c = 'In Shop';
        //  wo2.CaseId = cse11.id;
        WOList.add(wo2);
        
        insert WOList;
        
        List<WorkOrder> WOListToUpdate = new List<WorkOrder>();
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        wo1.AssetId = asset1.Id; 
        wo2.AssetId = asset.Id; 
        WOListToUpdate.add(wo1);
        WOListToUpdate.add(wo2);
        update WOListToUpdate;
        
        Test.stopTest();
    }
    
    //wo.AssetId == null && wo.ServiceTerritoryId != null && wo.ServiceTerritoryId == oldMap.get(wo.Id).ServiceTerritoryId
    @isTest
    private static void TestUpdateWOInShopSerTerrNotBlank() {
        
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'First',
                                      LastName = 'Mishra',
                                      IAM_Contact_Status__c = 'Active',
                                      Username__c = 'testmishra@mymail.com',
                                      Email = 'testmishra@mymail.com',
                                      AccountId = account1.Id,
                                      RecordTypeId = conRecId);
        //Insert contact;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> STList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test Mobile Territory';
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        
        STList.add(objServiceTerritory);
        insert STList;
        
        
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        wo1.AccountId = account1.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.ServiceTerritoryId = objServiceTerritory.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'In Shop';
        //  wo1.CaseId = cse12.id;
        
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account.Id;
        wo2.ServiceTerritoryId = objServiceTerritory.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Repair_Location__c = 'In Shop';
        //  wo2.CaseId = cse13.id;
        
        WOList.add(wo1);
        WOList.add(wo2);
        
        insert WOList;
        
        List<WorkOrder> WOListToUpdate = new List<WorkOrder>();
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        wo1.AssetId = null;
        wo2.AssetId = null;
        WOListToUpdate.add(wo1);
        update WOListToUpdate;
        
        Test.stopTest();
    }
    
    @isTest
    private static void TestUpdateWOInShopChangeSerTerr() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        Test.startTest();
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'First',
                                      LastName = 'Mishra',
                                      IAM_Contact_Status__c = 'Active',
                                      Username__c = 'testmishra@mymail.com',
                                      Email = 'testmishra@mymail.com',
                                      AccountId = account1.Id,
                                      RecordTypeId = conRecId);
        //Insert contact;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        List<ServiceTerritory> STList = new List<ServiceTerritory>();
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test Mobile Territory';
        objServiceTerritory.IsActive = true; 
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        
        STList.add(objServiceTerritory);
        insert STList;
        
        
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        wo1.AccountId = account1.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'In Shop';
        //  wo1.CaseId = cse14.id;
        WOList.add(wo1);
        
        insert WOList;
        
        List<WorkOrder> WOListToUpdate = new List<WorkOrder>();
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        wo1.AssetId = null;
        wo1.ServiceTerritoryId = objServiceTerritory.Id;
        WOListToUpdate.add(wo1);
        update WOListToUpdate;
        
        Test.stopTest();
    }
}