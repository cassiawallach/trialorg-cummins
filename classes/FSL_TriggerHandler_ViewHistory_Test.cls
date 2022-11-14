//Adding comment for deploying changes ---- Sriprada
//Comment added for deployment sept 2022
@isTest
public class FSL_TriggerHandler_ViewHistory_Test {
    
    @isTest  static void testRPV() {
        
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email= 'piyush.rani@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST In Shop or Mobile';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-02851';
        sT.FSL_Service_Territory_Code__c = '02851';
        sT.IsActive=true;
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA'; 
        insert sT;
        
        WorkOrder cjb = new WorkOrder();
        cjb.Mileage__c = 1000;
        cjb.ESN__c = '79464646';
        cjb.Mileage_Measure__c = 'Kilometers';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.DSID__c = 'DSBDT4760';
        // cjb.DSID_Creation_Timestamp__c = System.now();
        cjb.ServiceTerritoryId=sT.Id;
        cjb.RPVControlNumber__c = '1001';
        // cjb.Repeat_Visit__c = false;
        cjb.ESN__c='79797979';
        string vpersonType = 'DLR';
        string vmiles = 'Miles';
        string vmileage = '1000';
        string cssJobNum = '01234';
        string vdsid = '';
        string esn = '79788868';
        DateTime vDSIDCrDt; 
        string vcontrolNum = '';
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/gettoken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'OAGOAuth';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/css/QueryRepeatVisitFlag';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'RPV';
        insert conDetails1;
        
        Test.setMock(HttpCalloutMock.class, new CSS_RPVMock_Test());
        //FSL_TriggerHandler_ViewHistory.handleRepeatFlag(jobOrder);
        //FSL_TriggerHandler_ViewHistory.updateRepeatFlag(conDetails1, vpersonType, esn,vmiles,vmileage, cssJobNum,vdsid,vDSIDCrDt , vcontrolNum);
        insert cjb;
        // FSL_TriggerHandler_ViewHistory.updateRepeatFlag(conDetails1,vpersonType, cjb.ESN__c, cjb.Mileage__c , cjb.Mileage_Measure__c, cjb.DSID__c, '',vDSIDCrDt, cjb.RPVControlNumber__c);
    }
    
    @isTest static void testCallout() {
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        FSL_WS_OAG.getAccessToken();
        List<WorkOrder> jobOrder = new List<WorkOrder>();
        set<Id> setAssetIds = new set<id>();
        FSL_TriggerHandler_ViewHistory.handleRepeatFlag(setAssetIds);
        test.stopTest();
    }
    
    @TestVisible
    @isTest static void testCallout1() {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account ';
        insert acc;
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con=new Contact();
        con.RecordTypeId = conRecId;
        con.FirstName='Steve';
        con.LastName='Johnson';
        con.Phone='1234567890';
        con.email= 'piyush.rani@cummins.com';
        con.AccountId=acc.id;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory sT= new ServiceTerritory();
        sT.name = 'TEST ST Mobile or In Shop';
        sT.OperatingHoursId=oh.id;
        sT.Location_Code__c='03250-02851';
        sT.FSL_Service_Territory_Code__c = '02851';
        sT.IsActive=true;
        sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        sT.Territory__c = 'AUSTRALIA';
        insert sT;
        
        WorkOrder cjb = new WorkOrder();
        cjb.Mileage__c = 1000;
        cjb.ESN__c = '79464646';
        cjb.Mileage_Measure__c = 'Kilometers';
        cjb.Equipment_ID__c = 'EQ7667';
        cjb.DSID__c = 'DSBDT4760';
        // cjb.DSID_Creation_Timestamp__c = System.now();
        cjb.ServiceTerritoryId=sT.Id;
        cjb.RPVControlNumber__c = '1001';
        // cjb.Repeat_Visit__c = false;
        cjb.ESN__c='79797979';
        string vpersonType = 'DLR';
        string vmiles = 'Miles';
        string vmileage = '1000';
        string cssJobNum = '01234';
        string vdsid = '';
        string esn = '79788868';
        DateTime vDSIDCrDt; 
        string vcontrolNum = '';
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/gettoken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'OAGOAuth';
        insert conDetails;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.End_Point__c = 'https//test.com/css/QueryRepeatVisitFlag';
        conDetails1.Passcode__c = 'Admin';
        conDetails1.Username__c = 'Admin';
        conDetails1.Name = 'RPV';
        insert conDetails1;
        
        FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();  
        reqWrapper= new FSL_IP_NamedCredentialWrapper();
        reqWrapper.methodType = 'POST';
        reqWrapper.NamedCredential = 'FSL_NC_Services';
        reqWrapper.Path = '/repeatvisitflag';
        reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
        string rpvRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName": "ServiceRequest","SenderID": "SF"},"Target":{"TargetID":"RPV"}},';
        reqWrapper.jsonReqBody = rpvRequest;
        reqWrapper.timeOut = 120000;
        
        test.startTest();
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_RPVMock_Test());
        List<WorkOrder> jobOrder = new List<WorkOrder>();
        FSL_TriggerHandler_ViewHistory.updateRepeatFlag(reqWrapper,vpersonType, cjb.ESN__c, cjb.Mileage__c , cjb.Mileage_Measure__c, cjb.DSID__c, '',vDSIDCrDt, cjb.RPVControlNumber__c);
        
        test.stopTest();
    }
    @TestVisible
    @isTest public static void fslTest() {
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '04892-I');
        u.ERP__C = 'BMS';
        insert u; 
        system.runAs(u) {
            FSL_StatusUpdate.getCurrentUserERP();
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
            acc.Email_Notification_Frequency__c = 'Nightly';
            insert acc;
            
            FSL_StatusUpdate.getCustomMetaDataTypesForErrors('OSB-382500');
            FSL_StatusUpdate.getCustomMetaDataTypesForErrors('Invalid-OSB-12345');
            
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
            payerCon.CMI_IsActive__c=true;
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
            
            ServiceTerritory sT = new ServiceTerritory();
            sT.Name = 'ST001 Mobile';
            sT.OperatingHoursId = oh.Id;
            sT.IsActive = true;
            sT.Location_Code__c = '03520-04892'; 
            sT.FSL_Service_Territory_Code__c = '04892';
            sT.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            sT.Territory__c = 'AUSTRALIA';
            Insert sT;
            
            Schema.Location loc = new Schema.Location();
            loc.Name = 'Test';
            loc.FSL_Account__c = acc.Id;
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
            //addr.CreatedById = u.id;
            addr.ParentId = loc.Id;
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
            ast.Type__c = 'Engines';
            insert ast;
            
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = sT.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            WorkOrder wo = new WorkOrder();
            wo.WorkTypeId = wt.id;
            wo.ServiceTerritoryId = sT.Id;
            wo.Shop_Work_Order__c = '75148';
            wo.CSS_Hours__c = 12;
            wo.Branch_Code__c = subTypeInfo.Branch_Code__c;
            wo.Process_Step__c = 'Intake';
            wo.Make__c = 'AUTOCAR12';
            wo.Model__c = 'Test2';
            //wo.Asset = ast;
            wo.AssetId = ast.Id;
            wo.AccountId = acc.Id;
            wo.ContactId = con.Id;
            wo.Scheduled__c = true;
            wo.CreatedDate = system.now().addDays(-29);
            wo.Available_for_Service__c = system.now().addDays(10);
            wo.FSL_Sub_Type__c = subTypeInfo.id;
            wo.Repair_Location__c = 'In Shop';
            wo.Purchase_Order__c = 'Testing';
            wo.Application__c = '130 - AUTOMOTIVE';
            wo.Payer__c = acc.Id;
            wo.Status = 'Intake';
            wo.Payer_ContactID__c = payerCon.Id;
            wo.FSL_Make_Model_Flag__c = true; //Newly added.
            insert wo;
            
            WorkOrder cjb = new WorkOrder();
            cjb.Mileage__c = 1000;
            cjb.ESN__c = '79464646';
            cjb.Mileage_Measure__c = 'Kilometers';
            cjb.Equipment_ID__c = 'EQ7667';
            cjb.DSID__c = 'DSBDT4760';
            // cjb.DSID_Creation_Timestamp__c = System.now();
            cjb.ServiceTerritoryId=sT.Id;
            cjb.RPVControlNumber__c = '1001';
            // cjb.Repeat_Visit__c = false;
            cjb.ESN__c='79797979';
            string vpersonType = 'DLR';
            string vmiles = 'Miles';
            string vmileage = '1000';
            string cssJobNum = '01234';
            string vdsid = '';
            string esn = '79788868';
            DateTime vDSIDCrDt; 
            string vcontrolNum = '';
            
            
            FSL_IP_NamedCredentialWrapper reqWrapper = new FSL_IP_NamedCredentialWrapper();  
            reqWrapper= new FSL_IP_NamedCredentialWrapper();
            reqWrapper.methodType = 'POST';
            reqWrapper.NamedCredential = 'FSL_NC_Services';
            reqWrapper.Path = '/repeatvisitflag';
            reqWrapper.endPoint =[SELECT Endpoint FROM NamedCredential where DeveloperName=: reqWrapper.NamedCredential LIMIT 1].Endpoint+reqWrapper.Path;
            string rpvRequest='{"Header":{"Sender":{"MessageID": "unique message ID at SF","ServiceName": "ServiceRequest","SenderID": "SF"},"Target":{"TargetID":"RPV"}},';
            reqWrapper.jsonReqBody = rpvRequest;
            reqWrapper.timeOut = 120000;
            
            test.startTest();
            // Set mock callout class 
            Test.setMock(HttpCalloutMock.class, new CSS_RPVMock_Test());
            List<WorkOrder> jobOrder = new List<WorkOrder>();
            FSL_TriggerHandler_ViewHistory.updateRepeatFlag(reqWrapper,vpersonType, cjb.ESN__c, cjb.Mileage__c , cjb.Mileage_Measure__c, cjb.DSID__c, '',vDSIDCrDt, cjb.RPVControlNumber__c);
            FSL_TriggerHandler_ViewHistory.getRPVFlag(wo.Id);
            test.stopTest();
            
        }
    }
}