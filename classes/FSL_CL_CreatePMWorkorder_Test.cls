/*********************************************************************************
Name:  FSL_CL_CreatePMWorkorder_Test
Copyright:  Cummins
-----------------------------------------------
History:

Version        Author                    Date            Details               
1.0            Raghav        			04/10/2021      TestMethod
***********************************************************************************/
//Test Class execution comment added by mallika as part of cps-102:10/29
//Added by Krishna for CodeCoverage
@isTest
private class FSL_CL_CreatePMWorkorder_Test {
    @testSetup static void setup() {
        Id profid = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1].Id;
        //create user
        List<User> users = new List<User>();
        users.add(new User(
            ProfileId = profid,
            LastName = 'testUser',
            Email = 'testUserRaghav@testEmail.com',
            Username = 'testUserRaghav@testEmail.com',
            CompanyName = 'testCompany',
            Title = 'testTitle',
            Alias = 'testUsr',
            ERP__C = 'BMS',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            UserPermissionsKnowledgeUser = true,
            UserPermissionsInteractionUser = true,
            IsActive = true,
            UserPermissionsOfflineUser = true,
            UserPermissionsSupportUser = true,
            UserPermissionsMobileUser = true,
            IAM_UID__c = 'testUserRaghav@testEmail.com',
            FederationIdentifier = 'testUserRaghav@testEmail.com'
        ));
        Insert users;
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        
        Account acc = new Account();
        acc.RecordTypeId = accGCRecId;
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        acc.Email_Notification_Frequency__c='Real-Time';
        acc.BillingStreet = 'testline1,testline2';
        insert acc;
        
        List<worktype> worktypes = new List<worktype>();
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'PM';
        worktypes.add(wType);

        worktype  wType1 = new worktype();
        wType1.EstimatedDuration = Decimal.valueOf('40.02');
        wType1.Name = 'Minor';
        worktypes.add(wType1);
        insert worktypes;
        
        Schema.Location locationObj = new Schema.Location();
        locationObj.Name = 'Test cross ref';
        locationObj.FSL_Account__c = acc.Id;
        locationObj.FSL_Contact_ID__c = '10';
        insert locationObj;
        
        Schema.Address addressObj = new Schema.Address();
        addressObj.Street = '345 Dr';
        addressObj.Country = 'Australia';
        addressObj.Geolocation__Latitude__s = 87.00;
        addressObj.Geolocation__Longitude__s = 170.00;
        addressObj.FSL_Site_ID__c = '39';
        addressObj.FSL_Tax_District__c ='';
        addressObj.ParentId = locationObj.Id;
        addressObj.Account__c = acc.Id;
        insert addressObj;
        
        Asset  ast = new Asset();
        ast.Account = acc;
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = 'Engines-79963830';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c    ='56'; 
        ast.Type__c = 'Engines';
        insert ast;
        
        Asset  ast1 = new Asset();
        ast1.Account = acc;
        ast1.Service_Model__c = 'ISL9 CM2350 L101';
        ast1.Unit_Number__c = '1234';
        ast1.Make__c = 'KENWORTH';
        ast1.Model__c = 'T800';
        ast1.Name = '79963831';
        ast1.Unit_Type__c = 'EQ8349';
        ast1.VIN__c = '1NKDX4TX6JJ180253';
        ast1.Type_PSN__c = 'Engines-79963831';
        ast1.Application_Description__c = 'AUTOMOTIVE';
        ast1.Application_Code__c = '130';
        ast1.Engine_Family__c    ='56'; 
        ast1.Type__c = 'Engines';
        insert ast1;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        List<ServiceTerritory> serviceTerritories = new List<ServiceTerritory>();
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 In Shop';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = '03522-04893';
        serTer1.FSL_Service_Territory_Code__c = '04893';
        serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer1.Territory__c = 'AUSTRALIA';
        serviceTerritories.add(serTer1);
       // insert serTer1; 
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        serTer.Work_Type__c = 'FPG;Mobile;In Shop';
        serviceTerritories.add(serTer);
       
        insert serviceTerritories;
        
        Case  cs = new Case();
        cs.Status = 'Intake';
        //cs.Service_Territory__c = serTer.id;
        cs.AccountId = acc.id;
        cs.AssetId = ast.id;
        cs.Priority = 'Medium';
        insert cs; 
        
        FSL_SubType__c subType = new FSL_SubType__c();
        subType.name = 'Test Sub Type';
        subType.Branch_Code__c =10;
        subType.Status__c='Active';
        subType.Location_Code__c = '03520-M';
        subType.Code_Value__c = '1010';
        insert subType;
        
        List<workorder> woInfo = new List<workorder>();
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Asset = ast;
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
        wo1.Case = cs;
        wo1.sub_status__c = 'Troubleshooting Complete';
        wo1.Shop_Work_Order__c = '49440';
        //wo1.FSL_Additional_Email_Notifications__c='test@test.com';

        insert wo1;
    }
    
    @isTest  
    static void createPMWorkorder_test() {
        FSL_CL_SOWrapper objWrap = new FSL_CL_SOWrapper();
        objWrap.DataArea = new list<FSL_CL_SOWrapper.DataArea>();
        //set header
        FSL_CL_SOWrapper.Header headerObj = new FSL_CL_SOWrapper.Header();
        headerObj.LocationCode = '03520';
        objWrap.Header = headerObj;
        
        //set Parts
        FSL_CL_SOWrapper.Parts objParts = new FSL_CL_SOWrapper.Parts();
        objParts.PartLineNumber = '898493';
        objParts.PartLineType = 'PM';
        objParts.PartNumber = '32798404';
        objParts.ProductCode = 'Test1';
        objParts.PartDescription = 'Test Part1 Description';
        objParts.PartLocation = 'test';
        objParts.PartQuantityOrdered = '3';
        objParts.PartQuantityUsed = '2';
        objParts.EPRFlag = 'Y';
        
        //set Parts
        FSL_CL_SOWrapper.SRTs objSRTs = new FSL_CL_SOWrapper.SRTs();
        objSRTs.SRTGroup = 'Group1'; 
        objSRTs.SRTProcedure = 'Procedure1'; 
        objSRTs.PartNumber = '32798404'; 
        objSRTs.SRTDescription = 'SRT1 Description'; 
        objSRTs.SRTTime = '0.6'; 
        objSRTs.SRTQuantity = '2'; 
        objSRTs.TotalDuration = '1'; 
        
        //set DataArea
        FSL_CL_SOWrapper.DataArea objDataarea = new FSL_CL_SOWrapper.DataArea();
        objDataarea.ERPWorkOrder = '49440';
        objDataarea.EngineFamily = '99';
        objDataarea.ServiceModelName = 'NON CUMMINS';
        objDataarea.TransactionType = 'PM';
        objDataarea.CustomerCode = '48923';
        objDataarea.PSN = '79963830';
        objDataarea.SubType = '1010';
        objDataarea.NumberOfTechnicians = '2';
        objDataarea.StatusNotes = 'test';
        objDataarea.Parts = new List<FSL_CL_SOWrapper.Parts>{objParts};
        objDataarea.SRTs = new List<FSL_CL_SOWrapper.SRTs>{objSRTs};
        objWrap.DataArea.add(objDataarea);
        
        test.startTest();
        FSL_CL_CreatePMWorkorder CreatePMWorkorderObj = new FSL_CL_CreatePMWorkorder();
        CreatePMWorkorderObj.createPMWorkorder(objWrap);
        test.stopTest();
        
        List<CSS_Integration_Error__c> lstofError = [SELECT Id, Error_Description__c FROM CSS_Integration_Error__c LIMIT 1];
        System.assertEquals('ERP Work Order already exists', lstofError[0].Error_Description__c, 'Error discription should be same');
    }
    
    @isTest  
    static void createPMWorkorder_test2() {
        User usr = [SELECT Id FROM User WHERE Username = 'testUserRaghav@testEmail.com'];
        
        FSL_CL_SOWrapper objWrap = new FSL_CL_SOWrapper();
        objWrap.DataArea = new list<FSL_CL_SOWrapper.DataArea>();
        //set header
        FSL_CL_SOWrapper.Header headerObj = new FSL_CL_SOWrapper.Header();
        headerObj.LocationCode = '03520';
        objWrap.Header = headerObj;
        
        //set Parts
        FSL_CL_SOWrapper.Parts objParts = new FSL_CL_SOWrapper.Parts();
        objParts.PartLineNumber = '898493';
        objParts.PartLineType = 'PM';
        objParts.PartNumber = '32798404';
        objParts.ProductCode = 'Test1';
        objParts.PartDescription = 'Test Part1 Description';
        objParts.PartLocation = 'test';
        objParts.PartQuantityOrdered = '3';
        objParts.PartQuantityUsed = '2';
        objParts.EPRFlag = 'Y';
        
        //set Parts
        FSL_CL_SOWrapper.SRTs objSRTs = new FSL_CL_SOWrapper.SRTs();
        objSRTs.SRTGroup = 'Group1'; 
        objSRTs.SRTProcedure = 'Procedure1'; 
        objSRTs.PartNumber = '32798404'; 
        objSRTs.SRTDescription = 'SRT1 Description'; 
        objSRTs.SRTTime = '0.6'; 
        objSRTs.SRTQuantity = '2'; 
        objSRTs.TotalDuration = '1'; 
        
        //set DataArea
        FSL_CL_SOWrapper.DataArea objDataarea2 = new FSL_CL_SOWrapper.DataArea();
        objDataarea2.ERPWorkOrder = '49441';
        objDataarea2.EngineFamily = '98';
        objDataarea2.ServiceModelName = 'CUMMINS';
        objDataarea2.Type = 'ENGINE';
        objDataarea2.CustomerCode = '48923';
        objDataarea2.TransactionType = 'Major';
        objDataarea2.SiteLocation = 'Mobile';
        objDataarea2.PSN = '79963831';
        objDataarea2.SubType = '1010';
        objDataarea2.NumberOfTechnicians = '2';
        objDataarea2.StatusNotes = 'test';
        objDataarea2.Parts = new List<FSL_CL_SOWrapper.Parts>{objParts};
        objDataarea2.SRTs = new List<FSL_CL_SOWrapper.SRTs>{objSRTs};
        objWrap.DataArea.add(objDataarea2);

        test.startTest();
            FSL_CL_CreatePMWorkorder CreatePMWorkorderObj = new FSL_CL_CreatePMWorkorder();
            CreatePMWorkorderObj.createPMWorkorder(objWrap);
        test.stopTest();
        
        List<FSL_SRT__c> fslSRT = [SELECT Id, Type__c FROM FSL_SRT__c LIMIT 1];
        System.assertEquals('Repair Access', fslSRT[0].Type__c, 'Type should be same');   
    }
    
    @isTest  
    static void createPMWorkorder_test_PM() {
        User usr = [SELECT Id FROM User WHERE Username = 'testUserRaghav@testEmail.com'];
        
        FSL_CL_SOWrapper objWrap = new FSL_CL_SOWrapper();
        objWrap.DataArea = new list<FSL_CL_SOWrapper.DataArea>();
        //set header
        FSL_CL_SOWrapper.Header headerObj = new FSL_CL_SOWrapper.Header();
        headerObj.LocationCode = '03520';
        objWrap.Header = headerObj;
        
        //set Parts
        FSL_CL_SOWrapper.Parts objParts = new FSL_CL_SOWrapper.Parts();
        objParts.PartLineNumber = '898492';
        objParts.PartLineType = 'PM';
        objParts.PartNumber = '32798404';
        objParts.ProductCode = 'Test1';
        objParts.PartDescription = 'Test Part1 Description';
        objParts.PartLocation = 'test';
        objParts.PartQuantityOrdered = '3';
        objParts.PartQuantityUsed = '2';
        objParts.EPRFlag = 'Y';
        
        //set Parts
        FSL_CL_SOWrapper.SRTs objSRTs = new FSL_CL_SOWrapper.SRTs();
        objSRTs.SRTGroup = 'Group1'; 
        objSRTs.SRTProcedure = 'Procedure1'; 
        objSRTs.PartNumber = '32798404'; 
        objSRTs.SRTDescription = 'SRT1 Description'; 
        objSRTs.SRTTime = '0.6'; 
        objSRTs.SRTQuantity = '2'; 
        objSRTs.TotalDuration = '1'; 
        
        //set DataArea
        FSL_CL_SOWrapper.DataArea objDataarea2 = new FSL_CL_SOWrapper.DataArea();
        objDataarea2.ERPWorkOrder = '49111';
        objDataarea2.EngineFamily = '98';
        objDataarea2.ServiceModelName = 'CUMMINS';
        objDataarea2.Type = 'ENGINE';
        objDataarea2.CustomerCode = '48923';
        objDataarea2.TransactionType = 'PM'; 
        objDataarea2.PSN = '79963831';
        objDataarea2.SiteId = '39';
        objDataarea2.SubType = '1010';
        objDataarea2.NumberOfTechnicians = '2';
        objDataarea2.StatusNotes = 'test';
        objDataarea2.Parts = new List<FSL_CL_SOWrapper.Parts>{objParts};
        objDataarea2.SRTs = new List<FSL_CL_SOWrapper.SRTs>{objSRTs};
        objWrap.DataArea.add(objDataarea2);

        test.startTest();
            FSL_CL_CreatePMWorkorder CreatePMWorkorderObj = new FSL_CL_CreatePMWorkorder();
            CreatePMWorkorderObj.createPMWorkorder(objWrap);
        test.stopTest();
        WorkOrder woObj = [select id,workType.Name from WorkOrder where Shop_Work_Order__c = '49111' limit 1];        
        system.assertEquals(woObj.workType.Name, 'PM');
               
    }
    @isTest  
    static void createPMWorkorder_test3() {
        User usr = [SELECT Id FROM User WHERE Username = 'testUserRaghav@testEmail.com'];
        
        FSL_CL_SOWrapper objWrap = new FSL_CL_SOWrapper();
        objWrap.DataArea = new list<FSL_CL_SOWrapper.DataArea>();
        //set header
        FSL_CL_SOWrapper.Header headerObj = new FSL_CL_SOWrapper.Header();
        headerObj.LocationCode = '03520';
        objWrap.Header = headerObj;
        
        //set Parts
        FSL_CL_SOWrapper.Parts objParts = new FSL_CL_SOWrapper.Parts();
        objParts.PartLineNumber = '898493';
        objParts.PartLineType = 'PM';
        objParts.PartNumber = '32798404';
        objParts.ProductCode = 'Test1';
        objParts.PartDescription = 'Test Part1 Description';
        objParts.PartLocation = 'test';
        objParts.PartQuantityOrdered = '3';
        objParts.PartQuantityUsed = '2';
        objParts.EPRFlag = 'Y';
        
        //set Parts
        FSL_CL_SOWrapper.SRTs objSRTs = new FSL_CL_SOWrapper.SRTs();
        objSRTs.SRTGroup = 'Group1'; 
        objSRTs.SRTProcedure = 'Procedure1'; 
        objSRTs.PartNumber = '32798404'; 
        objSRTs.SRTDescription = 'SRT1 Description'; 
        objSRTs.SRTTime = '0.6'; 
        objSRTs.SRTQuantity = '2'; 
        objSRTs.TotalDuration = '1'; 
        
        //set DataArea
        FSL_CL_SOWrapper.DataArea objDataarea3 = new FSL_CL_SOWrapper.DataArea();
        objDataarea3.ERPWorkOrder = '49442';
        objDataarea3.EngineFamily = '98';
        objDataarea3.ServiceModelName = 'CUMMINS';
        objDataarea3.Type = 'NON ENGINE';
        objDataarea3.CustomerCode = '48923';
        objDataarea3.PSN = '79963832';
        objDataarea3.SubType = '1010';
        objDataarea3.TransactionType = 'Major';
        objDataarea3.SiteLocation = 'In Shop';
        objDataarea3.NumberOfTechnicians = '2';
        objDataarea3.StatusNotes = 'test';
        objDataarea3.ScheduledDate = string.valueOf(system.today()+1);
        objDataarea3.Parts = new List<FSL_CL_SOWrapper.Parts>{objParts};
        objDataarea3.SRTs = new List<FSL_CL_SOWrapper.SRTs>{objSRTs};
        objWrap.DataArea.add(objDataarea3);
        
        test.startTest();
        FSL_CL_CreatePMWorkorder CreatePMWorkorderObj = new FSL_CL_CreatePMWorkorder();
        CreatePMWorkorderObj.createPMWorkorder(objWrap);
        test.stopTest();
        
        List<FSL_SRT__c> fslSRT = [SELECT Id, Type__c FROM FSL_SRT__c LIMIT 1];
        System.assertEquals('Repair Access', fslSRT[0].Type__c, 'Type should be same');
    }
    
    @isTest  
    static void createPMWorkorder_test4() {
        User usr = [SELECT Id FROM User WHERE Username = 'testUserRaghav@testEmail.com'];
        
        FSL_CL_SOWrapper objWrap = new FSL_CL_SOWrapper();
        objWrap.DataArea = new list<FSL_CL_SOWrapper.DataArea>();
        //set header
        FSL_CL_SOWrapper.Header headerObj = new FSL_CL_SOWrapper.Header();
        headerObj.LocationCode = '04690';
        objWrap.Header = headerObj;
        
        //set Parts
        FSL_CL_SOWrapper.Parts objParts = new FSL_CL_SOWrapper.Parts();
        objParts.PartLineNumber = '898493';
        objParts.PartLineType = 'PM';
        objParts.PartNumber = '32798404';
        objParts.ProductCode = 'Test1';
        objParts.PartDescription = 'Test Part1 Description';
        objParts.PartLocation = 'test';
        objParts.PartQuantityOrdered = '3';
        objParts.PartQuantityUsed = '2';
        objParts.EPRFlag = 'Y';
        
        //set Parts
        FSL_CL_SOWrapper.SRTs objSRTs = new FSL_CL_SOWrapper.SRTs();
        objSRTs.SRTGroup = 'Group1'; 
        objSRTs.SRTProcedure = 'Procedure1'; 
        objSRTs.PartNumber = '32798404'; 
        objSRTs.SRTDescription = 'SRT1 Description'; 
        objSRTs.SRTTime = '0.6'; 
        objSRTs.SRTQuantity = '2'; 
        objSRTs.TotalDuration = '1'; 
        
        //set DataArea
        FSL_CL_SOWrapper.DataArea objDataarea3 = new FSL_CL_SOWrapper.DataArea();
        objDataarea3.ERPWorkOrder = '49442';
        objDataarea3.EngineFamily = '98';
        objDataarea3.ServiceModelName = 'CUMMINS';
        objDataarea3.Type = 'NON ENGINE';
        objDataarea3.CustomerCode = '48923';
        objDataarea3.PSN = '79963832';
        objDataarea3.SubType = '1010';
        objDataarea3.TransactionType = 'Major';
        objDataarea3.SiteLocation = 'In Shop';
        objDataarea3.NumberOfTechnicians = '2';
        objDataarea3.StatusNotes = 'test';
        objDataarea3.ScheduledDate = string.valueOf(system.today()+1);
        objDataarea3.Parts = new List<FSL_CL_SOWrapper.Parts>{objParts};
        objDataarea3.SRTs = new List<FSL_CL_SOWrapper.SRTs>{objSRTs};
        objWrap.DataArea.add(objDataarea3);
        
        test.startTest();
        FSL_CL_CreatePMWorkorder CreatePMWorkorderObj = new FSL_CL_CreatePMWorkorder();
        String jsonResp = CreatePMWorkorderObj.createPMWorkorder(objWrap);
        test.stopTest();
        
        Map<String, Object> respMap = (Map<String, Object>)JSON.deserializeUntyped(jsonResp);
        System.assertEquals('No matching Service Territory found', respMap.get('ReturnCodeDescription'));  
    }
    
    @isTest  
    static void createPMWorkorder_testForCatch() {
        FSL_CL_SOWrapper objWrap = new FSL_CL_SOWrapper();
        objWrap.DataArea = new list<FSL_CL_SOWrapper.DataArea>();
        //set header
        FSL_CL_SOWrapper.Header headerObj = new FSL_CL_SOWrapper.Header();
        headerObj.LocationCode = '03520';
        objWrap.Header = headerObj;
        
        //set Parts
        FSL_CL_SOWrapper.Parts objParts = new FSL_CL_SOWrapper.Parts();
        objParts.PartLineNumber = '898493';
        objParts.PartLineType = 'PM';
        objParts.PartNumber = '32798404';
        objParts.ProductCode = 'Test1';
        objParts.PartDescription = 'Test Part1 Description';
        objParts.PartLocation = 'test';
        objParts.PartQuantityOrdered = '3';
        objParts.PartQuantityUsed = '2';
        objParts.EPRFlag = 'Z';
        
        //set Parts
        FSL_CL_SOWrapper.SRTs objSRTs = new FSL_CL_SOWrapper.SRTs();
        objSRTs.SRTGroup = 'Group1'; 
        objSRTs.SRTProcedure = 'Procedure1'; 
        objSRTs.PartNumber = '32798404'; 
        objSRTs.SRTDescription = 'SRT1 Description'; 
        objSRTs.SRTTime = '0.6'; 
        objSRTs.SRTQuantity = '2'; 
        objSRTs.TotalDuration = '1'; 
        
        //set DataArea
        FSL_CL_SOWrapper.DataArea objDataarea = new FSL_CL_SOWrapper.DataArea();
        objDataarea.ERPWorkOrder = '49440';
        objDataarea.EngineFamily = '99';
        objDataarea.ServiceModelName = 'NON CUMMINS';
        objDataarea.TransactionType = 'PM';
        objDataarea.CustomerCode = '48923';
        objDataarea.PSN = '79963830';
        objDataarea.SubType = '1010';
        objDataarea.NumberOfTechnicians = '2';
        objDataarea.StatusNotes = 'test';
        objDataarea.Parts = new List<FSL_CL_SOWrapper.Parts>{objParts};
        objDataarea.SRTs = new List<FSL_CL_SOWrapper.SRTs>{objSRTs};
        objWrap.DataArea.add(objDataarea);
        
        test.startTest();
        FSL_CL_CreatePMWorkorder CreatePMWorkorderObj = new FSL_CL_CreatePMWorkorder();
        CreatePMWorkorderObj.createPMWorkorder(objWrap);
        test.stopTest();
        
        List<CSS_Integration_Error__c> lstofError = [SELECT Id, Source__c FROM CSS_Integration_Error__c LIMIT 1];
        System.assertEquals('Guidanz', lstofError[0].Source__c, 'Source should be Guidanz');
        
    }
}