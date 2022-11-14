@isTest
public class FSL_CL_ServiceOrder_LightningPath_Test {
    @testsetup
    public static void createData() {   //deployment purpose
        /* CSS_Integration_Details__c objIntegrationDetails1 = new CSS_Integration_Details__c();
objIntegrationDetails1.Name = 'OAGOAuthTest';
objIntegrationDetails1.ApplicationName__c = 'OAGOAuthTest';
objIntegrationDetails1.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/css';
objIntegrationDetails1.IsActive__c = true;
objIntegrationDetails1.Key__c = '12345';
objIntegrationDetails1.Passcode__c= 'test'; 
objIntegrationDetails1.Username__c= 'test';
insert objIntegrationDetails1; */ 
        
        Id profid = [select Id from profile where name= 'System Administrator' LIMIT 1].Id;
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
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '12345-12346';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';
        insert objWorkType;
        
        List<Asset> assetList = new List<Asset>();
        Asset objAsset = new Asset();
        objAsset.Name = '23234324';
        objAsset.Type_PSN__c = 'Engines-23234324';
        objAsset.Type__c = 'Engines';
        objAsset.Make__c ='make';
        objAsset.Model__c ='model';
        assetList.add(objAsset);
        
        Asset objAsset1 = new Asset();
        objAsset1.Name = '23234344';
        objAsset1.Type_PSN__c = 'Engines-23234344';
        objAsset1.Type__c = 'Engines';
        assetList.add(objAsset1);
        
        insert assetList;
        
        Service_Order_Extension__c soe = new Service_Order_Extension__c();
        Service_Order_Extension__c soe1 = new Service_Order_Extension__c();
        List<Service_Order_Extension__c> soList = new List<Service_Order_Extension__c>{soe, soe1};
        insert soList;
        
        List<WorkOrder> woList = new List<WorkOrder>();
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Service_Order_Extension__c = soe.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Type__c = 'Internal';
        woList.add(objWorkOrder);

        WorkOrder objWorkOrder1 = new WorkOrder();
        objWorkOrder1.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder1.Service_Order_Extension__c = soe1.Id;
        objWorkOrder1.Status = 'Job Plan';
        objWorkOrder1.Sub_Status__c ='Send 4Cs to ERP' ;
        objWorkOrder1.Make__c ='Test';
        objWorkOrder1.Model__c ='Test';
        objWorkOrder1.Process_Step__c = 'Intake';
        objWorkOrder1.AccountId = objAccount.Id;
        objWorkOrder1.WorkTypeId = objWorkType.Id;
        objWorkOrder1.AssetId = objAsset.Id;
        objWorkOrder1.Correction_Notes__c ='test';
        objWorkOrder1.Field_Actions__c ='test';
        woList.add(objWorkOrder1);

        insert woList;


        //new lines added-start
        fsl_Switch__c fslswitch=new fsl_Switch__c();
        fslswitch.name='Send_4Cs';
        insert fslswitch;
        //new lines added-end
        FSL_CL_ServiceOrder_LightningPath.insertMakeModelStaging(objWorkOrder.id);
        
        FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
        tsheet.Service_Order__c = objWorkOrder.Id;
        tsheet.StartTime__c = System.Datetime.now();
        tsheet.Endtime__c = tsheet.StartTime__c.addminutes(30);
        tsheet.Resource__c = users[0].Id;
        tsheet.Reason__c = 'Travel';
        tsheet.Notes__c = 'Starttimechangesetup';
        tsheet.Status__c = 'New';
        insert tsheet;
    }
    
   @isTest
    public static void checkOpenTimeSheetTest() {
        // createData();
        WorkOrder wo = [SELECT Id FROM WorkOrder WHERE Status = 'Intake' ORDER BY CreatedDate Desc limit 1];
        FSL_CL_ServiceOrder_LightningPath.erpTimesheetWrapper tsWrap = FSL_CL_ServiceOrder_LightningPath.checkOpenTimeSheet(wo.Id);
        System.assertEquals(true, tsWrap.isTimeSheetOpen, 'isTimeSheetOpen should be true');
    }
    
    @isTest
    public static void validateChevronData(){
        // Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator());
        // createData();
        Test.startTest();
        List<WorkOrder> objWorkOrder = [SELECT Id FROM WorkOrder limit 01];
        String chevronData = FSL_CL_ServiceOrder_LightningPath.getChevronData(objWorkOrder[0].Id) ;
        Test.stopTest();
        System.assert(String.isNotBlank(chevronData));
    }
    
    // Added Ravikanth
    @isTest
    public static void validateChevronDataStatus(){
        // createData();
        Test.startTest();
        List<WorkOrder> objWorkOrder = [SELECT Id FROM WorkOrder limit 01];
        objWorkOrder[0].Type__c='External';
        update objWorkOrder;
        String chevronData = FSL_CL_ServiceOrder_LightningPath.getChevronData(objWorkOrder[0].Id) ;
        System.assert(String.isNotBlank(chevronData));
        Test.stopTest();
    }
    
    @isTest
    private static void testIsStageActiveFor(){
        Test.startTest();
        List<String> stageValues1 = FSL_CumminsUtilities.getStageValues('System Administrator');
        List<String> stageValues2 = FSL_CL_ServiceOrder_LightningPath.isStageActiveFor('System Administrator');
        Test.stopTest();
        System.assertEquals(stageValues1.size(), stageValues2.size());
    }
    @isTest
    private static void testUpdateStageAndRecordType(){
        //  createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder WHERE Status = 'Intake'];
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Intake');
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Schedule');
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Triage & Diagnosis');
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Job Plan');
        Test.stopTest();
        WorkOrder updatedWO = [SELECT Id, Process_Step__c FROM WorkOrder WHERE Id = :objWorkOrder.Id];
        System.assertEquals('Job Plan', updatedWO.Process_Step__c);
    }
    @isTest
    private static void testUpdateStageAndRecordType_Intake(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder WHERE Status = 'Intake'];
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Intake');
        Test.stopTest();
        WorkOrder updatedWO = [SELECT Id, Process_Step__c FROM WorkOrder WHERE Id = :objWorkOrder.Id];
        System.assertEquals('Intake', updatedWO.Process_Step__c);
    }
    @isTest
    private static void testUpdateStageAndRecordType_Schedule(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder WHERE Status = 'Intake'];
        
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Schedule');
        FSL_CL_ServiceOrder_LightningPath.checkOpenTimeSheet(objWorkOrder.Id);
        Test.stopTest();
        WorkOrder updatedWO = [SELECT Id, Process_Step__c FROM WorkOrder WHERE Id = :objWorkOrder.Id];
        System.assertEquals('Schedule', updatedWO.Process_Step__c);
    }
    @isTest
    private static void testUpdateStageAndRecordType_TANDD(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder WHERE Status = 'Intake'];
        
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Triage & Diagnosis');
        //FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Job Plan');
        Test.stopTest();
        WorkOrder updatedWO = [SELECT Id, Process_Step__c FROM WorkOrder WHERE Id = :objWorkOrder.Id];
        System.assertEquals('Triage & Diagnosis', updatedWO.Process_Step__c);
    }
    @isTest
    private static void testUpdateStageAndRecordType_JobPlan(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder WHERE Status = 'Intake'];
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Job Plan');
        Test.stopTest();
        WorkOrder updatedWO = [SELECT Id, Process_Step__c FROM WorkOrder WHERE Id = :objWorkOrder.Id];
        System.assertEquals('Job Plan', updatedWO.Process_Step__c);
    }
    @isTest
    private static void testUpdateStageRecordType(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder WHERE Status = 'Intake'];
        
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Warranty Claims');
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Invoice');
        Test.stopTest();
        WorkOrder updatedWO = [SELECT Id, Process_Step__c FROM WorkOrder WHERE Id = :objWorkOrder.Id];
        System.assertEquals('Invoice', updatedWO.Process_Step__c);
    }
    @isTest
    private static void testUpdateStageRecordType_RepairClose(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder WHERE Status = 'Intake'];
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Repair');
        FSL_CL_ServiceOrder_LightningPath.updateStageAndRecordType(objWorkOrder.Id, 'Close');
        Test.stopTest();
        WorkOrder updatedWO = [SELECT Id, Process_Step__c FROM WorkOrder WHERE Id = :objWorkOrder.Id];
        System.assertEquals('Close', updatedWO.Process_Step__c);
    }
    
    @isTest
    private static void testGetProcessStatus(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id,Process_Step__c FROM WorkOrder WHERE Status = 'Intake'];
        FSL_CL_ServiceOrder_LightningPath.getProcessStatus(objWorkOrder.Id);
        objWorkOrder.Process_Step__c = 'Intake';
        update objWorkOrder;
        String processStep = FSL_CL_ServiceOrder_LightningPath.getProcessStatus(objWorkOrder.Id);
        Test.stopTest();
        System.assertEquals(objWorkOrder.Process_Step__c, processStep);
    }
    
    @isTest
    private static void testCheckForMostLikely(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id,Process_Step__c FROM WorkOrder WHERE Status = 'Intake'];
        Boolean isMostLikely = FSL_CL_ServiceOrder_LightningPath.checkForMostLikely(objWorkOrder.Id);
        Test.stopTest();
        System.assert(!isMostLikely);
    }  
    
    @isTest
    private static void testcheckForRepairSelection(){
        //createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id,Process_Step__c FROM WorkOrder LIMIT 1];
        objWorkOrder.Correction_Notes__c ='test';
        objWorkOrder.Field_Actions__c ='test';
        update objWorkOrder;
        Boolean repairSelection = FSL_CL_ServiceOrder_LightningPath.checkForRepairSelection(objWorkOrder.Id);
        Test.stopTest();
        System.assertEquals(False, repairSelection);
    }    
    @isTest
    private static void testisTechDispatched(){
        //createData();
        Test.startTest();
        
        WorkOrder objWorkOrder = [SELECT Id,Process_Step__c FROM WorkOrder WHERE Status = 'Intake'];
        objWorkOrder.Status ='Triage & Diagnosis';
        objWorkOrder.Sub_Status__c ='Troubleshooting Complete';
        update objWorkOrder;
        
        Boolean isTechDispatched = FSL_CL_ServiceOrder_LightningPath.isTechDispatched(objWorkOrder.Id);
        Test.stopTest();
        WorkOrder wo=[SELECT Is_Tech_Dispatched__c FROM WorkOrder WHERE Id=:objWorkOrder.Id Limit 1]; 
        System.assertEquals(isTechDispatched, wo.Is_Tech_Dispatched__c);
    }        
    
    @isTest
    public static void updatemakemodelTest() {
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder WHERE Status = 'Job Plan' ORDER BY CreatedDate Desc limit 1];
        List<FSL_MakeModel_Stage__c> objstag = new List<FSL_MakeModel_Stage__c>();
        FSL_MakeModel_Stage__c fms = new FSL_MakeModel_Stage__c();
        fms.Manufacturer__c = 'Test';
        fms.ProductApplicationCode__c = 'test';
        // fms.PSN__c = '79788878';
        fms.Name = 'test';
        fms.Type_PSN__c ='Engines-79361294';
        objstag.add(fms); 
        insert objstag;
        
        CSS_Solutions__c sc = new CSS_Solutions__c();
        sc.FSL_Service_Job__c = objWorkOrder.id;
        sc.Name = 'test';
        sc.Diagnostic_Response__c = 'Most likely the solution. Repair recommended.';
        insert sc;
        //new lines added-start
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345',ERP__c = 'BMS');
        insert u;
        Boolean stateStatus;
        List<String> options;
        List<String> repainOptions = new List<String>();        
        Schema.DescribeFieldResult fieldResult = CSS_Solutions__c.Repair_Response__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();        
        for( Schema.PicklistEntry f : ple)
        {
            repainOptions.add(f.getValue());
        }
        system.runAs(u){
            fsl_Switch__c fslswitch=new fsl_Switch__c();
            fslswitch.name='Send_4Cs';
            fslswitch.ERP__c='BMS';
            insert fslswitch;
            fsl_Switch__c fs = [SELECT name,Id,IsActive__C,User_Type__c,ERP__c FROM fsl_Switch__c where name = 'Send_4Cs' limit 1];
            System.debug('fsl switch*** '+fs);
            System.debug('fslswitch Id*** '+fslswitch.Id);
            //new lines added-end
            stateStatus = FSL_CL_ServiceOrder_LightningPath.getstateStatus(objWorkOrder.id);
            FSL_CL_ServiceOrder_LightningPath.getstateStatus1(objWorkOrder.id);
            FSL_CL_ServiceOrder_LightningPath.insertMakeModelStaging(objWorkOrder.id);
            FSL_CL_ServiceOrder_LightningPath.handleCloseModal(objWorkOrder.id);
            FSL_CL_ServiceOrder_LightningPath.handleTAndDRepairJobPlanClose(objWorkOrder.id);
            //  FSL_CL_ServiceOrder_LightningPath.callBMSWebServices(objWorkOrder.id);
            FSL_CL_ServiceOrder_LightningPath.isTechDispatched(objWorkOrder.id);
            FSL_CL_ServiceOrder_LightningPath.isWorkOrderCreated(objWorkOrder.id);
            options = FSL_CL_ServiceOrder_LightningPath.getRepairRespLOVs();
            FSL_CL_ServiceOrder_LightningPath.cssSolutionWrapper csswrap = new FSL_CL_ServiceOrder_LightningPath.cssSolutionWrapper();
        }
        System.assertEquals(options, repainOptions);
        Test.StopTest();
    }
    @isTest
    public static void updatemakemodelTest1() {
        WorkOrder objWorkOrder = [SELECT Id, Make__c,Asset.Make__c,Model__c,Asset.Model__c FROM WorkOrder WHERE Status = 'Job Plan' ORDER BY CreatedDate Desc limit 1];
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c ='Troubleshooting Complete';
        objWorkOrder.Make__c = 'makeTwo';
        objWorkOrder.Model__c = 'modelTwo';
        Test.startTest();
        update objWorkOrder;
        system.debug('hellowTest--'+objWorkOrder.Asset.Model__c);
        List<FSL_MakeModel_Stage__c> objstag = new List<FSL_MakeModel_Stage__c>();
        FSL_MakeModel_Stage__c fms = new FSL_MakeModel_Stage__c();
        fms.Manufacturer__c = 'Test';
        fms.ProductApplicationCode__c = 'test';
        // fms.PSN__c = '79788878';
        fms.Name = 'test';
        fms.Type_PSN__c ='Engines-79361294';
        objstag.add(fms); 
        insert objstag;
        
        CSS_Solutions__c sc = new CSS_Solutions__c();
        sc.FSL_Service_Job__c = objWorkOrder.id;
        sc.Name = 'test';
        sc.Diagnostic_Response__c = 'Most likely the solution. Repair recommended.';
        insert sc;
        //new lines added-start
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345',ERP__c = 'BMS');
        insert u;
        String result;
        system.runAs(u){
            fsl_Switch__c fslswitch=new fsl_Switch__c();
            fslswitch.name='Send_4Cs';
            fslswitch.ERP__c='BMS';
            insert fslswitch;
            fsl_Switch__c fs = [SELECT name,Id,IsActive__C,User_Type__c,ERP__c FROM fsl_Switch__c where name = 'Send_4Cs' limit 1];
            System.debug('fsl switch*** '+fs);
            System.debug('fslswitch Id*** '+fslswitch.Id);
            //new lines added-end
            result = FSL_CL_ServiceOrder_LightningPath.insertMakeModelStaging(objWorkOrder.id);
            System.debug('result:: '+result);
        }
        System.assertEquals(null, result, 'FSL_MakeModel_Stage__c rec should not create bcz Asset Make, Model is null');
        Test.StopTest();
    }
    
    @isTest
    public static void getstateStatus1Test(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345',ERP__c = 'BMS');
        insert u;
        Test.startTest();
        system.runAs(u){
            List<WorkOrder> woList = [SELECT Id FROM WorkOrder limit 2];
            woList[0].Sub_Status__c = 'Work in Progress';
            woList[0].Authorized_Work_Started__c = false;
            woList[0].Service_Work_Completed__c = false;
            
            woList[1].Sub_Status__c = 'Work in Progress';
            woList[1].Authorized_Work_Started__c = true;
            woList[1].Service_Work_Completed__c = false;
            update woList;
            System.assertEquals(true, FSL_CL_ServiceOrder_LightningPath.getstateStatus1(woList[0].id));
            System.assertEquals(true, FSL_CL_ServiceOrder_LightningPath.getstateStatus1(woList[1].id)); 
        }
        Test.stopTest();
        
    }
    
    public static testMethod void sendJsonRequestEXPTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '12345',ERP__c = 'BMS');
        insert u;
        system.runAs(u) {
            
            CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
            conDetails.End_Point__c = 'https://test.com/css/bmsunit';
            conDetails.Passcode__c = 'Admin';
            conDetails.Username__c = 'Admin';
            conDetails.Name = 'FSL_InBoundServiceRequest';
            insert conDetails;
            
            //Test.setMock(HttpCalloutMock.class, new FSLFailModeMock());  
            //Test.setMock(HttpCalloutMock.class, new FSLFailModeMockToken());
            Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
            
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account acc = new Account();
            acc.RecordTypeId = accRecId;
            acc.Name = 'East Bronx1';
            acc.CMI_Account_Status__c = 'Active';
            acc.PaymentType__c = 'Cash';
            acc.FSL_ERP_Customer_Code__c = '48923';
            acc.FSL_Credit_Limit__c = 78888.8;
            insert acc;
            Test.startTest();
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact con=new Contact();
            con.RecordTypeId = conRecId;
            con.FirstName='Steve';
            con.LastName='Johnson';
            con.Phone='1234567890';
            con.AccountId=acc.id;
            con.FSL_Contact_Id__c='1';
            insert con;
            
            worktype  wType = new worktype();
            wType.EstimatedDuration = Decimal.valueOf('40.02');
            wType.Name = 'Test';
            insert wType;
            
            Asset  ast = new Asset();
            ast.Account = acc;
            ast.Service_Model__c = 'ISL9 CM2350 L101';
            ast.Unit_Number__c = '1234';
            ast.Make__c = 'KENWORTH';
            ast.Model__c = 'T800';
            ast.Name = '79963830';
            ast.Unit_Type__c = 'EQ8349';
            ast.VIN__c = '1NKDX4TX6JJ180253';
            ast.Type_PSN__c = '796';
            ast.Application_Description__c = 'AUTOMOTIVE';
            ast.Application_Code__c = '130';
            ast.Engine_Family__c    ='56';
            // ast.Access_Code__c = 'B';
            ast.Individual__c = '';
            ast.Type__c = 'Engines';
            insert ast;
            
            
            OperatingHours  oh = new OperatingHours ();
            oh.Name = 'new';
            oh.TimeZone = 'America/Chicago';
            insert oh;
            
            List<ServiceTerritory> servTerrList = new List<ServiceTerritory>();
            
            ServiceTerritory serTer1 = new ServiceTerritory();
            serTer1.Name = 'ST005 Mobile';
            serTer1.OperatingHoursId = oh.Id;
            serTer1.IsActive = true;
            serTer1.Location_Code__c = '03522-04893';
            serTer1.FSL_Service_Territory_Code__c = '04893';
            serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            serTer1.Territory__c = 'AUSTRALIA';
            servTerrList.add(serTer1);
            
            ServiceTerritory serTer = new ServiceTerritory();
            serTer.Name = 'ST001 Mobile';
            serTer.OperatingHoursId = oh.Id;
            serTer.IsActive = true;
            serTer.Location_Code__c = '03520-04892';
            serTer.FSL_Service_Territory_Code__c = '04892';
            serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            serTer.Territory__c = 'AUSTRALIA';
            servTerrList.add(serTer);
            
            insert servTerrList;
            
            IAM_CDH_Cross_references__c objSite = new IAM_CDH_Cross_references__c();
            objSite.Name = 'Test';
            objSite.IAM_Account__c = acc.Id;
            objSite.FSL_MoveX_Contact_Id__c = '10';
            objSite.FSL_MoveX_Site_Id__c = '1';
            objSite.FSL_City__c = 'Brisbane';
            insert objSite;
            
            Case  cs = new Case();
            cs.Status = 'Intake';
            //cs.Service_Territory__c = serTer.id;
            cs.AccountId = acc.id;
            cs.AssetId = ast.id;
            cs.Priority = 'Medium';
            insert cs; 
            
            List<workorder> woInfo = new List<workorder>();
            workorder wo1 = new workorder();
            wo1.AccountId = acc.Id;
            wo1.Process_Step__c = 'Intake';
            wo1.Asset = ast;
            wo1.Repair_Location__c = 'Mobile';
            wo1.EditComplaint__c = 'Testing';
            wo1.EditCause__c = 'Testing';
            wo1.EditCorrection__c = 'Testing';
            wo1.EditCoverage__c = 'Testing';
            wo1.ServiceTerritoryid = serTer.id;
            wo1.WorkTypeId = wType.Id;
            wo1.AssetId = ast.Id;
            wo1.Repair_Site_Name__c = objSite.id;
            wo1.Case = cs;
            woInfo.add(wo1);
            insert woInfo;
            //update woInfo;
            
            List<workorder> woInfo1 = new List<workorder>();
            workorder wo2 = new workorder();
            wo2.id = woInfo[0].id;
            wo2.Account = acc;
            // wo2.Asset = ast;
            wo2.ServiceTerritoryid = serTer1.id;
            wo2.ContactId = null;
            wo2.EditComplaint__c = 'Testing Info';
            wo2.EditCause__c = 'Testing Info';
            wo2.EditCorrection__c = 'Testing Info';
            wo2.EditCoverage__c = 'Testing Info1';
            wo2.ServiceTerritoryid = serTer1.id;
            wo2.Application__c ='130 - AUTOMOTIVE';
            wo2.Repair_Location__c = 'Mobile';
            // wo2.Asset.name = ast.Name;
            wo2.Mileage_Measure__c ='87';
            //wo2.Asset.Access_Code__c = 'B';
            // wo2.Asset.Registration__c = '12345';
            wo2.Repair_Site_Name__r = null;
            // wo2.Repair_Site_Name__r.FSL_MoveX_Site_Id__c = objSite.FSL_MoveX_Site_Id__c;
            wo2.Mileage__c = 123;
            wo2.CSS_Hours__c =89;
            wo2.Failure_Date__c = system.Today();
            wo2.Warranty_Start_Date__c =system.Today();
            wo2.Fuel_Burn__c =89;
            woInfo1.add(wo2);
            update woInfo1;
            
            List<FSL_MakeModel_Stage__c> objstag = new List<FSL_MakeModel_Stage__c>();
            FSL_MakeModel_Stage__c fms = new FSL_MakeModel_Stage__c();
            fms.Manufacturer__c = 'Test';
            fms.ProductApplicationCode__c = 'test';
            fms.PSN__c = '79788878';
            fms.Name = 'test';
            fms.Type_PSN__c ='Engines-79361294';
            objstag.add(fms); 
            insert objstag;
            
            try{
                
                FSLInBoundService.TargetERP = 'BMS';
                FSLInBoundService.sendJsonRequest(woInfo1[0].id,acc.FSL_ERP_Customer_Code__c,con.Id,'0');
                FSL_StatusUpdate.calloutResponseWraper resp = FSL_CL_ServiceOrder_LightningPath.callBMSWebServices(woInfo1[0].id);
                System.assert(String.isBlank(resp.errorCode));
            }
            catch(exception e){}
            Test.stopTest();
        }
        
    }
    
    @isTest
    private static void testGetServiceOrderType(){
        //createData();
        Test.startTest();
        List<WorkOrder> objWorkOrder = [SELECT Id FROM WorkOrder limit 1];
        objWorkOrder[0].Type__c='Internal';
        update objWorkOrder;
        String type = FSL_CL_ServiceOrder_LightningPath.getServiceOrderType(objWorkOrder[0].Id) ;
        Test.stopTest();
        system.assertEquals(type,'Internal');
        
    }
}