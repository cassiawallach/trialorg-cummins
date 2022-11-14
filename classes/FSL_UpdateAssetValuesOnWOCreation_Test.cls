/************************************************************************************
Name: FSL_UpdateAssetValuesOnWOCreation_Test
Copyright © 2019  Cummins
=====================================================================================
=====================================================================================
Purpose: For Accept logic from SR to SO
=====================================================================================
=====================================================================================
History
-------
VERSION  AUTHOR            		DATE                DETAIL
1.0      Lochana Rajut          06/23/2022     Added test method for Service Order Extension record creation and 
                                               to copy FTR fields from Case
************************************************************************************/
@isTest
public class FSL_UpdateAssetValuesOnWOCreation_Test {
    
    @isTest static void TestCreationNewWODetails() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        account.FSL_BMS_Instance__c = 'USA';
        
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        account1.CMI_Account_Status__c = 'Active';
        account1.FSL_BMS_Instance__c = 'USA';
        
        
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'First',
                                      LastName = 'Mishra',
                                      IAM_Contact_Status__c = 'Active',
                                      Username__c = 'testmishra@mymail.com',
                                      Email = 'testmishra@mymail.com',
                                      Phone='9878987890',
                                      AccountId = account1.Id,
                                      RecordTypeId = conRecId);       
        
        Insert contact;
        Id conRecId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact1 = new Contact(FirstName = 'First1',
                                       LastName = 'Mishra1',
                                       IAM_Contact_Status__c = 'Active',
                                       Username__c = 'testmishra1@mymail.com',
                                       Email = 'testmishra1@mymail.com',
                                       Phone='9878987890',
                                       AccountId = account.Id,
                                       RecordTypeId = conRecId1);
        Insert contact1;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        List<IAM_CDH_Cross_references__c> woRefLst = new List<IAM_CDH_Cross_references__c>();
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        woref.FSL_Site_Status__c = 'Active';
        woRefLst.add(woRef);
        
        IAM_CDH_Cross_references__c woRef1 = new IAM_CDH_Cross_references__c();
        woRef1.name = 'testing';
        woRef1.FSL_MoveX_Site_Id__c = '39';
        woRef1.IAM_Account__c = account.id;
        woRef1.FSL_MoveX_Contact_Id__c = '10';
        woRef1.FSL_Address_Line_1__c = '345 Dr';
        woRef1.FSL_Country__c = 'Australia';
        woref1.FSL_Site_Status__c = 'Active';
        woRefLst.add(woRef1);
        
        insert woRefLst;
        //create location 
        Schema.Location loc = new Schema.Location();
        loc.Name = 'Test';
        loc.FSL_Account__c = account.Id;
        loc.FSL_Contact_ID__c = '10';
        insert loc;
        
        Schema.Location loc1 = new Schema.Location();
        loc1.Name = 'Test';
        loc1.FSL_Account__c = account1.Id;
        loc1.FSL_Contact_ID__c = '10';
        insert loc1;
        
        //create Address 
        List<Schema.Address> adressList=new List<Schema.Address>();
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
        
        addr.ParentId = loc.Id;
        addr.Account__c = account.Id;
        adressList.add(addr);
        Schema.Address addr1 = new Schema.Address();
        addr1.FSL_Site_ID__c = '49';
        addr1.Street = '345 Dr';
        addr1.City = 'Brisbane';
        addr1.State = 'South Australia';
        addr1.Country = 'Australia';
        addr1.FSL_Tax_District__c ='';
        
        addr1.PostalCode = '5000093';
        addr1.Latitude = 70.0;
        addr1.Longitude = 175.0;
        
        addr1.ParentId = loc1.Id;
        addr1.Account__c = account1.Id;
        adressList.add(addr1);
        
        insert adressList;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.FSL_Site__c = addr.id;
        asset.AccountId = account.Id;
        asset.Site__c = woRef.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.MoveX_Email_ID__c = 'abc@gmail.com';
        asset.MoveX_Phone_Number__c = '9080706050';
        asset.MoveX_Customer_Address_1__c = 'test';
        asset.MoveX_Customer_Address_2__c = 'test';
        asset.MoveX_Customer_Address_3__c = 'test';
        asset.Customer_Name__c = 'New Customer1';
        asset.City__c = 'test';
        asset.State__c = 'test';
        //asset.Accountid = account1.Id;
        //asset.Contactid=contact1.id;
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account.Id;
        asset1.Site__c = woRef.Id;
        asset1.FSL_Site__c = addr.id;
        asset1.Contact_Name__c = 'test';
        asset1.MoveX_Email_ID__c = 'abc@gmail.com';
        asset1.MoveX_Phone_Number__c = '9080706050';
        asset1.MoveX_Customer_Address_1__c = 'test';
        asset1.MoveX_Customer_Address_2__c = 'test';
        asset1.MoveX_Customer_Address_3__c = 'test';
        asset1.Customer_Name__c = 'New Customer1';
        asset1.City__c = 'test';
        asset1.State__c = 'test';
        asset1.Unit_Number__c = '12';
        asset1.Registration__c = '123';
        assetList.add(asset1);
        
        Asset asset2 = new Asset();
        asset2.Name = '34281978';
        asset2.Type_PSN__c = 'Engines-7889';
        asset2.Type__c = 'Engines';
        asset2.AccountId = account.Id;
        asset2.Site__c = woRef.Id;
        assetList.add(asset2);
        
        Asset asset3 = new Asset();
        asset3.Name = '3428197899';
        asset3.Type_PSN__c = 'Engines-78890';
        asset3.Type__c = 'Engines';
        
        asset3.AccountId = account1.Id;
        //asset3.Site__c = woRef.Id;
        asset3.Customer_Name__c = 'New Customer11';
        assetList.add(asset3);
        
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
        serviceTerritory.Mileage_Measure__c = '11';
        insert serviceTerritory; 
        
        List<Case> lstcse = new List<Case>();
        Case cse = new Case();
        cse.Accountid = account1.Id;
        cse.Contactid = contact.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CCM').getRecordTypeId();       
        insert cse;
        lstcse.add(cse);
        
        
        Test.startTest();
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        //wo1.AccountId = account1.Id;
        //wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        wo1.AssetId = asset1.Id; 
        wo1.Unit_NB__c = asset1.Unit_Number__c;
        wo1.Registration__c = asset1.Registration__c;
        wo1.caseId = cse.id;
        WOList.add(wo1);
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        //wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External';
        //wo2.Type__c = 'Dealer';
        wo2.AssetId = asset.Id; 
        wo2.Repair_Location__c = 'Mobile';
        
        //WOList.add(wo2);
        
        WorkOrder wo3 = new WorkOrder();
        wo3.RecordTypeId = intakeRTID;
        wo3.Status = 'Intake';
        wo3.ESN_Insite__c = '79799702';
        wo3.Process_Step__c = 'Intake';
        wo3.AccountId = account.Id;
        wo3.ContactId = contact1.Id;
        wo3.Repair_Site_Address__c = addr.Id;
        wo3.WorkTypeId = workType.Id;
        wo3.Type__c = 'External';
        //wo2.Type__c = 'Dealer'; 
        wo3.Shop_Work_Order__c = '123124';
        wo3.Repair_Location__c = 'Mobile';
        wo3.AssetId = asset2.Id; 
        wo3.ServiceTerritory = ServiceTerritory;
        WOList.add(wo3);
        
        WorkOrder wo4 = new WorkOrder();
        wo4.RecordTypeId = intakeRTID;
        wo4.Status = 'Intake';
        wo4.ESN_Insite__c = '79799702';
        wo4.Process_Step__c = 'Intake';
        wo4.AccountId = account1.Id;
        wo4.ContactId = contact.Id;
        wo4.WorkTypeId = workType.Id;
        wo4.Repair_Site_Address__c = addr1.Id;
        wo4.Type__c = 'External'; 
        wo4.Shop_Work_Order__c = '123124';
        wo4.Repair_Location__c = 'Mobile';
        //wo4.Repair_Site_Name__c = woref.Id;
        wo4.AssetId = asset2.Id; 
        
        WOList.add(wo4);
        
        WorkOrder wo5 = new WorkOrder();
        wo5.RecordTypeId = intakeRTID;
        wo5.Status = 'Intake';
        wo5.ESN_Insite__c = '79799702';
        wo5.Process_Step__c = 'Intake';
        wo5.AccountId = account1.Id;
        //wo5.ContactId = contact.Id;
        wo5.WorkTypeId = workType.Id;
        wo5.Type__c = 'External'; 
        wo5.Shop_Work_Order__c = '123124';
        wo5.Repair_Location__c = 'Mobile';
        // wo5.Repair_Site_Name__c = woref.Id;
        wo5.AssetId = asset3.Id; 
        
        // WOList.add(wo5);
        
        insert WOList;
        
        Map<Id,List<Case>> workOrderIdVsCase = new Map<Id,List<Case>> ();
        workOrderIdVsCase.put(wo1.id, lstcse);
        
        Test.stopTest();
    }
    @isTest static void TestCreationNewWODetails2() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        account.FSL_BMS_Instance__c = 'USA';
        
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        account1.CMI_Account_Status__c = 'Active';
        account1.FSL_BMS_Instance__c = 'USA';
        
        
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'First',
                                      LastName = 'Mishra',
                                      IAM_Contact_Status__c = 'Active',
                                      Username__c = 'testmishra@mymail.com',
                                      Email = 'testmishra@mymail.com',
                                      Phone='9878987890',
                                      AccountId = account1.Id,
                                      RecordTypeId = conRecId);       
        
        Insert contact;
        Id conRecId1 = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact1 = new Contact(FirstName = 'First1',
                                       LastName = 'Mishra1',
                                       IAM_Contact_Status__c = 'Active',
                                       Username__c = 'testmishra1@mymail.com',
                                       Email = 'testmishra1@mymail.com',
                                       Phone='9878987890',
                                       AccountId = account.Id,
                                       RecordTypeId = conRecId1);
        Insert contact1;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        List<IAM_CDH_Cross_references__c> woRefLst = new List<IAM_CDH_Cross_references__c>();
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        woref.FSL_Site_Status__c = 'Active';
        woRefLst.add(woRef);
        
        IAM_CDH_Cross_references__c woRef1 = new IAM_CDH_Cross_references__c();
        woRef1.name = 'testing';
        woRef1.FSL_MoveX_Site_Id__c = '39';
        woRef1.IAM_Account__c = account.id;
        woRef1.FSL_MoveX_Contact_Id__c = '10';
        woRef1.FSL_Address_Line_1__c = '345 Dr';
        woRef1.FSL_Country__c = 'Australia';
        woref1.FSL_Site_Status__c = 'Active';
        woRefLst.add(woRef1);
        
        insert woRefLst;
        //create location 
        Schema.Location loc = new Schema.Location();
        loc.Name = 'Test';
        loc.FSL_Account__c = account.Id;
        loc.FSL_Contact_ID__c = '10';
        insert loc;
        
        Schema.Location loc1 = new Schema.Location();
        loc1.Name = 'Test';
        loc1.FSL_Account__c = account1.Id;
        loc1.FSL_Contact_ID__c = '10';
        insert loc1;
        
        //create Address 
        List<Schema.Address> adressList=new List<Schema.Address>();
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
        
        addr.ParentId = loc.Id;
        addr.Account__c = account.Id;
        adressList.add(addr);
        Schema.Address addr1 = new Schema.Address();
        addr1.FSL_Site_ID__c = '49';
        addr1.Street = '345 Dr';
        addr1.City = 'Brisbane';
        addr1.State = 'South Australia';
        addr1.Country = 'Australia';
        addr1.FSL_Tax_District__c ='';
        
        addr1.PostalCode = '5000093';
        addr1.Latitude = 70.0;
        addr1.Longitude = 175.0;
        
        addr1.ParentId = loc1.Id;
        addr1.Account__c = account1.Id;
        adressList.add(addr1);
        
        insert adressList;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.FSL_Site__c = addr.id;
        asset.AccountId = account.Id;
        asset.Site__c = woRef.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.MoveX_Email_ID__c = 'abc@gmail.com';
        asset.MoveX_Phone_Number__c = '9080706050';
        asset.MoveX_Customer_Address_1__c = 'test';
        asset.MoveX_Customer_Address_2__c = 'test';
        asset.MoveX_Customer_Address_3__c = 'test';
        asset.Customer_Name__c = 'New Customer1';
        asset.City__c = 'test';
        asset.State__c = 'test';
        //asset.Accountid = account1.Id;
        //asset.Contactid=contact1.id;
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account.Id;
        asset1.Site__c = woRef.Id;
        asset1.FSL_Site__c = addr.id;
        asset1.Contact_Name__c = 'test';
        asset1.MoveX_Email_ID__c = 'abc@gmail.com';
        asset1.MoveX_Phone_Number__c = '9080706050';
        asset1.MoveX_Customer_Address_1__c = 'test';
        asset1.MoveX_Customer_Address_2__c = 'test';
        asset1.MoveX_Customer_Address_3__c = 'test';
        asset1.Customer_Name__c = 'New Customer1';
        asset1.City__c = 'test';
        asset1.State__c = 'test';
        asset1.Unit_Number__c = '12';
        asset1.Registration__c = '123';
        assetList.add(asset1);
        
        Asset asset2 = new Asset();
        asset2.Name = '34281978';
        asset2.Type_PSN__c = 'Engines-7889';
        asset2.Type__c = 'Engines';
        asset2.AccountId = account.Id;
        asset2.Site__c = woRef.Id;
        assetList.add(asset2);
        
        Asset asset3 = new Asset();
        asset3.Name = '3428197899';
        asset3.Type_PSN__c = 'Engines-78890';
        asset3.Type__c = 'Engines';
        
        asset3.AccountId = account1.Id;
        //asset3.Site__c = woRef.Id;
        asset3.Customer_Name__c = 'New Customer11';
        assetList.add(asset3);
        
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
        serviceTerritory.Mileage_Measure__c = '';
        insert serviceTerritory; 
        
        List<Case> lstcse = new List<Case>();
        Case cse = new Case();
        cse.Accountid = account1.Id;
        cse.Contactid = contact.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CCM').getRecordTypeId();       
        insert cse;
        lstcse.add(cse);
        
        
        Test.startTest();
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        //wo1.AccountId = account1.Id;
        //wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        wo1.AssetId = asset1.Id; 
        wo1.Unit_NB__c = asset1.Unit_Number__c;
        wo1.Registration__c = asset1.Registration__c;
        wo1.caseId = cse.id;
        wo1.Type__c = 'Dealer';
        WOList.add(wo1);
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        //wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External';
        //wo2.Type__c = 'Dealer';
        wo2.AssetId = asset.Id; 
        wo2.Repair_Location__c = 'Mobile';
        
        //WOList.add(wo2);
        
        WorkOrder wo3 = new WorkOrder();
        wo3.RecordTypeId = intakeRTID;
        wo3.Status = 'Intake';
        wo3.ESN_Insite__c = '79799702';
        wo3.Process_Step__c = 'Intake';
        wo3.AccountId = account.Id;
        wo3.ContactId = contact1.Id;
        wo3.Repair_Site_Address__c = addr.Id;
        wo3.WorkTypeId = workType.Id;
        wo3.Type__c = 'External';
        //wo2.Type__c = 'Dealer'; 
        wo3.Shop_Work_Order__c = '123124';
        wo3.Repair_Location__c = 'Mobile';
        wo3.AssetId = asset2.Id; 
        wo3.ServiceTerritory = ServiceTerritory;
        WOList.add(wo3);
        
        WorkOrder wo4 = new WorkOrder();
        wo4.RecordTypeId = intakeRTID;
        wo4.Status = 'Intake';
        wo4.ESN_Insite__c = '79799702';
        wo4.Process_Step__c = 'Intake';
        wo4.AccountId = account1.Id;
        wo4.ContactId = contact.Id;
        wo4.WorkTypeId = workType.Id;
        wo4.Repair_Site_Address__c = addr1.Id;
        wo4.Type__c = 'External'; 
        wo4.Shop_Work_Order__c = '123124';
        wo4.Repair_Location__c = 'Mobile';
        //wo4.Repair_Site_Name__c = woref.Id;
        wo4.AssetId = asset2.Id; 
        
        WOList.add(wo4);
        
        WorkOrder wo5 = new WorkOrder();
        wo5.RecordTypeId = intakeRTID;
        wo5.Status = 'Intake';
        wo5.ESN_Insite__c = '79799702';
        wo5.Process_Step__c = 'Intake';
        wo5.AccountId = account1.Id;
        //wo5.ContactId = contact.Id;
        wo5.WorkTypeId = workType.Id;
        wo5.Type__c = 'External'; 
        wo5.Shop_Work_Order__c = '123124';
        wo5.Repair_Location__c = 'Mobile';
        // wo5.Repair_Site_Name__c = woref.Id;
        wo5.AssetId = asset3.Id; 
        
        // WOList.add(wo5);
        
        insert WOList;
        
        Map<Id,List<Case>> workOrderIdVsCase = new Map<Id,List<Case>> ();
        workOrderIdVsCase.put(wo1.id, lstcse);
        
        Test.stopTest();
    }
    @isTest static void TestCreationNewWODetail3() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
        
        
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
        Insert contact;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        List<IAM_CDH_Cross_references__c> woRefLst = new List<IAM_CDH_Cross_references__c>();
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        woref.FSL_Site_Status__c = 'Active';
        woRefLst.add(woRef);
        
        IAM_CDH_Cross_references__c woRef1 = new IAM_CDH_Cross_references__c();
        woRef1.name = 'testing';
        woRef1.FSL_MoveX_Site_Id__c = '39';
        woRef1.IAM_Account__c = account.id;
        woRef1.FSL_MoveX_Contact_Id__c = '10';
        woRef1.FSL_Address_Line_1__c = '345 Dr';
        woRef1.FSL_Country__c = 'Australia';
        woref1.FSL_Site_Status__c = 'Active';
        woRefLst.add(woRef1);
        
        insert woRefLst;
        //create location 
               Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = account.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
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
            addr.ParentId = loc.Id;
			addr.Account__c = account.Id;
            insert addr;
                
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.FSL_Site__c = addr.id;
        asset.AccountId = account.Id;
        asset.Site__c = woRef.Id;
        asset.Customer_Name__c = 'New Customer';
        asset.MoveX_Email_ID__c = 'abc@gmail.com';
        asset.MoveX_Phone_Number__c = '9080706050';
        asset.MoveX_Customer_Address_1__c = 'test';
        asset.MoveX_Customer_Address_2__c = 'test';
        asset.MoveX_Customer_Address_3__c = 'test';
        asset.City__c = 'test';
        asset.State__c = 'test';
        assetList.add(asset);
        
       
        
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
        serviceTerritory.Mileage_Measure__c = '11';
        insert serviceTerritory; 
        
        Case cse = new Case();
        cse.Accountid = account1.Id;
        cse.Contactid = contact.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();       
        insert cse;
        
        Test.startTest();
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        //wo1.AccountId = account1.Id;
        //wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        
        wo1.AssetId = asset.Id; 
        wo1.caseId = cse.id;
        WOList.add(wo1);
        
        insert WOList;
        
        Test.stopTest();
    }
    @isTest static void TestCreationNewWODetails3() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
        
        
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
        Insert contact;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        List<IAM_CDH_Cross_references__c> woRefLst = new List<IAM_CDH_Cross_references__c>();
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        woref.FSL_Site_Status__c = 'Active';
        woRefLst.add(woRef);
        
        IAM_CDH_Cross_references__c woRef1 = new IAM_CDH_Cross_references__c();
        woRef1.name = 'testing';
        woRef1.FSL_MoveX_Site_Id__c = '39';
        woRef1.IAM_Account__c = account.id;
        woRef1.FSL_MoveX_Contact_Id__c = '10';
        woRef1.FSL_Address_Line_1__c = '345 Dr';
        woRef1.FSL_Country__c = 'Australia';
        woref1.FSL_Site_Status__c = 'Active';
        woRefLst.add(woRef1);
        
        insert woRefLst;
        //create location 
        Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = account.Id;
            loc.FSL_Contact_ID__c = '10';
            insert loc;
        
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
            addr.ParentId = loc.Id;
			addr.Account__c = account.Id;
            insert addr;
                
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.FSL_Site__c = addr.id;
        asset.AccountId = account.Id;
        asset.Site__c = woRef.Id;
        asset.Customer_Name__c = 'New Customer';
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account.Id;
        asset1.Site__c = woRef.Id;
        asset1.FSL_Site__c = addr.id;
        asset1.Contact_Name__c = 'test';
        asset1.MoveX_Email_ID__c = 'abc@gmail.com';
        asset1.MoveX_Phone_Number__c = '9080706050';
        asset1.MoveX_Customer_Address_1__c = 'test';
        asset1.MoveX_Customer_Address_2__c = 'test';
        asset1.MoveX_Customer_Address_3__c = 'test';
        asset1.Customer_Name__c = 'New Customer1';
        asset1.City__c = 'test';
        asset1.State__c = 'test';
        assetList.add(asset1);
        
        Asset asset2 = new Asset();
        asset2.Name = '34281978';
        asset2.Type_PSN__c = 'Engines-7889';
        asset2.Type__c = 'Engines';
        asset2.AccountId = account.Id;
        asset2.Site__c = woRef.Id;
        assetList.add(asset2);
        
        Asset asset3 = new Asset();
        asset3.Name = '3428197899';
        asset3.Type_PSN__c = 'Engines-78890';
        asset3.Type__c = 'Engines';
       
        asset3.AccountId = account1.Id;
        //asset3.Site__c = woRef.Id;
         asset3.Customer_Name__c = 'New Customer11';
        assetList.add(asset3);
        
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
        serviceTerritory.Mileage_Measure__c = '11';
        insert serviceTerritory; 
        
        Case cse = new Case();
        cse.Accountid = account1.Id;
        cse.Contactid = contact.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();       
        insert cse;
        
        Test.startTest();
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        //wo1.AccountId = account1.Id;
        //wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        
        //wo1.AssetId = asset1.Id; 
        wo1.caseId = cse.id;
        WOList.add(wo1);
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        //wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        //wo2.AssetId = asset.Id; 
        wo2.Repair_Location__c = 'Mobile';
        wo2.Repair_Site_Address__c = addr.Id;
        
        //WOList.add(wo2);
        
        WorkOrder wo3 = new WorkOrder();
        wo3.RecordTypeId = intakeRTID;
        wo3.Status = 'Intake';
        wo3.ESN_Insite__c = '79799702';
        wo3.Process_Step__c = 'Intake';
        wo3.AccountId = account.Id;
        //wo3.ContactId = contact.Id;
        wo3.Repair_Site_Address__c = addr.Id;
        wo3.WorkTypeId = workType.Id;
        wo3.Type__c = 'External'; 
        wo3.Shop_Work_Order__c = '123124';
        wo3.Repair_Location__c = 'Mobile';
        //wo3.AssetId = asset2.Id; 
        
        WOList.add(wo3);
        
        
        
        insert WOList;
        
        Test.stopTest();
    }
    @isTest static void TestCreationWODetails() {
        List<WorkOrder> WorkOrderList = new List<WorkOrder>();
        Id intakeRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
        
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        List<Account> accList = new List<Account>();
        Account account = new Account(); 
        account.RecordTypeId = accRecId;
        account.Name = 'Test Account';
        account.BillingStreet = '1466 N National Rd';
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
        
        
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
        Insert contact;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        List<IAM_CDH_Cross_references__c> woRefLst = new List<IAM_CDH_Cross_references__c>();
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account1.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        woRefLst.add(woRef);
        
        IAM_CDH_Cross_references__c woRef1 = new IAM_CDH_Cross_references__c();
        woRef1.name = 'testing';
        woRef1.FSL_MoveX_Site_Id__c = '39';
        woRef1.IAM_Account__c = account.id;
        woRef1.FSL_MoveX_Contact_Id__c = '10';
        woRef1.FSL_Address_Line_1__c = '345 Dr';
        woRef1.FSL_Country__c = 'Australia';
        woRefLst.add(woRef1);
        
        insert woRefLst;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        //asset.FSL_Site__c = 
        asset.AccountId = account.Id;
        //asset.Site__c = woRef.Id;
        asset.Customer_Name__c = 'New Customer';
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.Site__c = woRef.Id;
        asset1.Contact_Name__c = 'test';
        asset1.MoveX_Email_ID__c = 'abc@gmail.com';
        asset1.MoveX_Phone_Number__c = '9080706050';
        asset1.MoveX_Customer_Address_1__c = 'test';
        asset1.MoveX_Customer_Address_2__c = 'test';
        asset1.MoveX_Customer_Address_3__c = 'test';
        asset1.Customer_Name__c = 'New Customer1';
        asset1.City__c = 'test';
        asset1.State__c = 'test';
        assetList.add(asset1);
        
        Asset asset2 = new Asset();
        asset2.Name = '34281978';
        asset2.Type_PSN__c = 'Engines-7889';
        asset2.Type__c = 'Engines';
        asset2.AccountId = account1.Id;
        asset2.Site__c = woRef.Id;
        assetList.add(asset2);
        
        Asset asset3 = new Asset();
        asset3.Name = '3428197899';
        asset3.Type_PSN__c = 'Engines-78890';
        asset3.Type__c = 'Engines';
       
        asset3.AccountId = account1.Id;
        asset3.Site__c = woRef.Id;
         asset3.Customer_Name__c = 'New Customer11';
        assetList.add(asset3);
        
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
        serviceTerritory.Mileage_Measure__c = '11';
        insert serviceTerritory; 
        
        Case cse = new Case();
        cse.Accountid = account1.Id;
        cse.Contactid = contact.Id;
        cse.Description = 'TestDescription';
        cse.Status = 'New';
        cse.Subject = 'TestSubject';
        cse.RecordTypeId  = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();       
        insert cse;
        Test.startTest();
        List<WorkOrder> WOList = new List<WorkOrder>();
        WorkOrder wo1 = new WorkOrder();
        wo1.RecordTypeId = intakeRTID;
        wo1.Status = 'Intake';
        wo1.ESN_Insite__c = '79799702';
        wo1.Process_Step__c = 'Intake';
        wo1.AccountId = account1.Id;
        //wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        wo1.AssetId = asset1.Id; 
        wo1.caseId = cse.id;
        WOList.add(wo1);
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.AssetId = asset.Id; 
        wo2.Repair_Location__c = 'Mobile';
        
        //WOList.add(wo2);
        
        WorkOrder wo3 = new WorkOrder();
        wo3.RecordTypeId = intakeRTID;
        wo3.Status = 'Intake';
        wo3.ESN_Insite__c = '79799702';
        wo3.Process_Step__c = 'Intake';
        wo3.AccountId = account1.Id;
        wo3.ContactId = contact.Id;
        wo3.WorkTypeId = workType.Id;
        wo3.Type__c = 'External'; 
        wo3.Shop_Work_Order__c = '123124';
        wo3.Repair_Location__c = 'Mobile';
        wo3.AssetId = asset2.Id; 
        
        WOList.add(wo3);
        
        WorkOrder wo4 = new WorkOrder();
        wo4.RecordTypeId = intakeRTID;
        wo4.Status = 'Intake';
        wo4.ESN_Insite__c = '79799702';
        wo4.Process_Step__c = 'Intake';
        wo4.AccountId = account1.Id;
        wo4.ContactId = contact.Id;
        wo4.WorkTypeId = workType.Id;
        wo4.Type__c = 'External'; 
        wo4.Shop_Work_Order__c = '123124';
        wo4.Repair_Location__c = 'Mobile';
        wo4.Repair_Site_Name__c = woref.Id;
        wo4.AssetId = asset2.Id; 
        
        WOList.add(wo4);
        
        WorkOrder wo5 = new WorkOrder();
        wo5.RecordTypeId = intakeRTID;
        wo5.Status = 'Intake';
        wo5.ESN_Insite__c = '79799702';
        wo5.Process_Step__c = 'Intake';
        wo5.AccountId = account1.Id;
        //wo5.ContactId = contact.Id;
        wo5.WorkTypeId = workType.Id;
        wo5.Type__c = 'External'; 
        wo5.Shop_Work_Order__c = '123124';
        wo5.Repair_Location__c = 'Mobile';
        wo5.Repair_Site_Name__c = woref.Id;
        wo5.AssetId = asset3.Id; 
        
        WOList.add(wo5);
        
        insert WOList;
        
        Test.stopTest();
    }
    
    //Create WO with Asset and Account
    @isTest static void TestCreateWOAssetWithAcc() {
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
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
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
        
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account1.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        insert woRef;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.AccountId = account1.Id;
        asset.Customer_Name__c = 'New Customer';
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.Site__c = woRef.Id;
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
      //  wo1.AccountId = account.Id;
        wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        wo1.AssetId = asset1.Id; 
        WOList.add(wo1);
        
      WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
       // wo2.AccountId = account.Id;
        wo2.ContactId = contact.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Shop_Work_Order__c = '123124';
        wo2.Repair_Location__c = 'Mobile';
        wo2.AssetId = asset.Id; 
        WOList.add(wo2);
        
        insert WOList;
        
        Test.stopTest();
    }
    
    //Condition - 3
    //(wo.AssetId == null && wo.Repair_Site_Name__c != null && wo.Repair_Site_Name__c == oldMap.get(wo.Id).Repair_Site_Name__c){
    @isTest static void TestUpdateWORepairSite() {
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
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        List<IAM_CDH_Cross_references__c> siteList = new List<IAM_CDH_Cross_references__c>();
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account1.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        siteList.add(woRef);
        
        IAM_CDH_Cross_references__c objSite = new IAM_CDH_Cross_references__c();
        objSite.Name = 'Test';
        objSite.IAM_Account__c = account1.Id;
        objSite.FSL_MoveX_Contact_Id__c = '10';
        objSite.FSL_MoveX_Site_Id__c = '1';
        objSite.FSL_City__c = 'Brisbane';
        siteList.add(objSite);
        
        IAM_CDH_Cross_references__c objSite1 = new IAM_CDH_Cross_references__c();
        objSite1.Name = 'TestNew';
        objSite1.IAM_Account__c = account.Id;
        objSite1.FSL_MoveX_Contact_Id__c = '10';
        objSite1.FSL_MoveX_Site_Id__c = '1';
        objSite1.FSL_City__c = 'Brisbane';
        siteList.add(objSite1);
        insert siteList;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        //asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.Site__c = woRef.Id;
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
        //wo1.Repair_Site_Name__c = objSite.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        WOList.add(wo1);
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        //wo2.Repair_Site_Name__c = objSite1.Id;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Repair_Location__c = 'Mobile';
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
    
    //Condition - 4 (Wo-Addres update when Repair Site is null and is changed)
    @isTest static void TestUpdateWOBlankRepairSite() {
        RecursiveTriggerHandler recHandler = new RecursiveTriggerHandler();
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
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
        accList.add(account);
        accList.add(account1);
        insert accList;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        List<IAM_CDH_Cross_references__c> siteList = new List<IAM_CDH_Cross_references__c>();
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account1.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        siteList.add(woRef);
        
        IAM_CDH_Cross_references__c objSite = new IAM_CDH_Cross_references__c();
        objSite.Name = 'Test';
        objSite.IAM_Account__c = account1.Id;
        objSite.FSL_MoveX_Contact_Id__c = '10';
        objSite.FSL_MoveX_Site_Id__c = '1';
        objSite.FSL_City__c = 'Brisbane';
        siteList.add(objSite);
        
        IAM_CDH_Cross_references__c objSite1 = new IAM_CDH_Cross_references__c();
        objSite1.Name = 'TestNew';
        objSite1.IAM_Account__c = account.Id;
        objSite1.FSL_MoveX_Contact_Id__c = '10';
        objSite1.FSL_MoveX_Site_Id__c = '1';
        objSite1.FSL_City__c = 'Brisbane';
        siteList.add(objSite1);
        insert siteList;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        //asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.Site__c = woRef.Id;
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
        wo1.Repair_Site_Name__c = objSite1.Id; 
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'Mobile';
        WOList.add(wo1);
        
        //The Repair Site associated with the Asset is Inactive or not tied to the selected Account. Please pick / create a Repair Site associated to the Account.: [Repair_Site_Name__c]
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        //wo2.Repair_Site_Name__c = objSite1.Id;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account.Id; 
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Repair_Location__c = 'Mobile';
        WOList.add(wo2);
        
        insert WOList;
        
        List<WorkOrder> WOListToUpdate = new List<WorkOrder>();
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        wo1.Repair_Site_Name__c = null;
        wo1.Repair_Location__c = 'In Shop';
        wo2.Repair_Site_Name__c = objSite1.Id;
        WOListToUpdate.add(wo1);
        WOListToUpdate.add(wo2);
        update WOListToUpdate;
        
        Test.stopTest();
    }
    //Condition - 5 (Wo-Address update when Repair Site is changed & not blank)
    
    
    @isTest static void TestUpdateWOInShopDetails() {
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
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
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
        
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account1.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        insert woRef;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.Site__c = woRef.Id;
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
        WOList.add(wo2);
        
        insert WOList;
        
       
        
        Test.stopTest();
    }
    
    @isTest static void TestUpdateWOInShopAssetWithOutAcc() {
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
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
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
        
        IAM_CDH_Cross_references__c woRef = new IAM_CDH_Cross_references__c();
        woRef.name = 'testing';
        woRef.FSL_MoveX_Site_Id__c = '39';
        woRef.IAM_Account__c = account1.id;
        woRef.FSL_MoveX_Contact_Id__c = '10';
        woRef.FSL_Address_Line_1__c = '345 Dr';
        woRef.FSL_Country__c = 'Australia';
        insert woRef;
        
        List<Asset> assetList = new List<Asset>();
        Asset asset = new Asset();
        asset.Name = '23234324';
        asset.Type_PSN__c = 'Engines-79788868';
        asset.Type__c = 'Engines';
        //asset.AccountId = account.Id;
        asset.Customer_Name__c = 'New Customer';
        assetList.add(asset);
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'Engines-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = account1.Id;
        asset1.ContactId = contact.Id;
        asset1.Customer_Name__c = 'New Customer';
        asset1.Site__c = woRef.Id;
        assetList.add(asset1);
        
        Asset asset2 = new Asset();
        asset2.Name = '3428199';
        asset2.Type_PSN__c = 'Engines-789';
        asset2.Type__c = 'Engines';
        asset2.AccountId = account1.Id;
        asset2.ContactId = contact.Id;
        asset2.Customer_Name__c = 'New Customer';
        asset2.Site__c = woRef.Id;
        assetList.add(asset2);
        
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
        //wo1.AccountId = account1.Id;
        wo1.AssetId = asset.Id;
        wo1.ContactId = contact.Id;
        wo1.WorkTypeId = workType.Id;
        wo1.Type__c = 'External'; 
        wo1.Shop_Work_Order__c = '123124';
        wo1.Repair_Location__c = 'In Shop';
        WOList.add(wo1);
        
        WorkOrder wo2 = new WorkOrder();
        wo2.RecordTypeId = intakeRTID;
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Intake';
        wo2.AccountId = account1.Id;
        wo2.ServiceTerritoryId = serviceTerritory.Id;
        wo2.AssetId = asset1.Id;
        wo2.WorkTypeId = workType.Id;
        wo2.Type__c = 'External'; 
        wo2.Repair_Location__c = 'In Shop';
        WOList.add(wo2);
        
        WorkOrder wo3 = new WorkOrder();
        wo3.RecordTypeId = intakeRTID;
        wo3.Status = 'Intake';
        wo3.ESN_Insite__c = '79799702';
        wo3.Process_Step__c = 'Intake';
        wo3.AccountId = account.Id;
        wo3.ServiceTerritoryId = serviceTerritory.Id;
        wo3.AssetId = asset1.Id;
        wo3.WorkTypeId = workType.Id;
        wo3.Type__c = 'External'; 
        wo3.Repair_Location__c = 'In Shop';
        WOList.add(wo3);
        
        insert WOList;
        
        Test.stopTest();
    }
    
    //wo.AssetId == null && wo.ServiceTerritoryId != null && wo.ServiceTerritoryId == oldMap.get(wo.Id).ServiceTerritoryId
    @isTest static void TestUpdateWOInShopSerTerrNotBlank() {
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
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
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
    
    @isTest static void TestUpdateWOInShopChangeSerTerr() {
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
        account.BillingCity = 'Columbus';
        account.BillingState = 'Indiana';
        account.BillingCountry= 'United States';
        account.BillingPostalCode = '47201';
        
        Account account1 = new Account(); 
        account1.RecordTypeId = accGCRecId;
        account1.Name = 'Test GC';
        account1.BillingStreet = '1466 N National Rd';
        account1.BillingCity = 'Columbus';
        account1.BillingState = 'Indiana';
        account1.BillingCountry= 'United States';
        account1.BillingPostalCode = '47201';
        
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
        WOList.add(wo1);
        
        insert WOList;
      // Test.stopTest();
        
        List<WorkOrder> WOListToUpdate = new List<WorkOrder>();
        
        FSL_workorderListTriggerHandle.avoidAfterupdate = false;
        wo1.AssetId = null;
        wo1.ServiceTerritoryId = objServiceTerritory.Id;
        WOListToUpdate.add(wo1);
      //  Test.startTest();
        update WOListToUpdate;
        
        Test.stopTest();
    
    }

    @isTest
    public static void test_serviceOrderExtensionCreation() {
        OperatingHours testOh = TestUtility.createOperatingHours('testName');

        ServiceTerritory testTerritory = TestUtility.createServiceTerritory('testName', true, testOh.Id);
        Account  acc= FSL_TestDataUtility.createAccount();

        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = FSL_TestDataUtility.createContact(conRecId, acc.Id);
        insert con;

        Asset assetObj = FSL_TestDataUtility.createAsset();
        assetObj.Customer_Name__c = 'Test Customer';
        update assetObj;

        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('IA Request').getRecordTypeId();
        List<Case> lstCases = FSL_TestDataUtility.createCases(servRecId,acc.Id, con.Id,assetObj.Id,testTerritory.Id,1);
        lstCases[0].FSL_ABRFlag__c = true;
        lstCases[0].FSL_TransactionID__c = '12345-5678-655-44444-578';
        insert lstCases;
        FSL_Switch__c FSlSwitch = FSL_TestDataUtility.createFSLSwitchRecord('Enable_FTR_Switch', true);
            insert FSlSwitch;
        Test.startTest();
        List<Workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        insert lstWO;
        Test.stopTest();
        List<Service_Order_Extension__c> SOExtensionlst = [SELECT Id from Service_Order_Extension__c];
        List<Service_Order_Extension__c> SOExtensionlstFTR = [SELECT Id from Service_Order_Extension__c 
                        where FSL_ABRFlag__c = true and FSL_TransactionID__c = '12345-5678-655-44444-578'];
        System.assertEquals(lstWO.size(), SOExtensionlst.size());
        System.assertEquals(1, SOExtensionlstFTR.size());

    }
    
}