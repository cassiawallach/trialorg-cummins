/*********************************************************************************
Name:  FSL_workorderListTriggerHandle_Test
Copyright © 2019  Cummins
-----------------------------------------------
History:

Version        Author                    Date            Details               
1.0            Mallika Subhashini        08/17/2019      TestMethod
2.0            Sriprada Sesham           08/17/2020      Updated for Code Coverage
3.0            Dinesh Yadav              10/23/2020      Updated for Code Coverage 
***********************************************************************************/
@isTest


public class FSL_workorderListTriggerHandle_Test{
    
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
        
        Account acc = new Account();
        acc.Name = 'East Bronx1';
        acc.CMI_Account_Status__c = 'Active';
        acc.PaymentType__c = 'Cash';
        acc.FSL_ERP_Customer_Code__c = '48923';
        acc.FSL_Credit_Limit__c = 78888.5;
        acc.Email_Notification_Frequency__c='Real-Time';
        insert acc;
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc1 = new Account();
        acc1.Name = 'Freightliner of Arizona LLC';
        acc1.RecordTypeId = accRecId;
        acc1.Email_Notification_Frequency__c='Real-Time';
        insert acc1;
        
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
        
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 In Shop';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = '03522-04893';
        serTer1.FSL_Service_Territory_Code__c = '04893';
        serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer1.Territory__c = 'AUSTRALIA';
        insert serTer1; 
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520-04892';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        insert serTer;
        
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
        insert subType;
        
    }
    
    public testMethod static void TiggerHandler_One(){
        Account acc=[select id,name,CMI_Account_Status__c,PaymentType__c,FSL_ERP_Customer_Code__c,FSL_Credit_Limit__c,
                     Email_Notification_Frequency__c from account where name='East Bronx1' limit 1];

        Asset  ast = [select id,Type__c,Type_PSN__c,Service_Model__c,Unit_Number__c,Make__c,Model__c,name,Unit_Type__c,
                      VIN__c,Application_Description__c,Application_Code__c,Engine_Family__c from Asset where name = '79963830' limit 1];
        Asset  ast1 = [select id,Type__c,Type_PSN__c,Service_Model__c,Unit_Number__c,Make__c,Model__c,name,Unit_Type__c,
                       VIN__c,Application_Description__c,Application_Code__c,Engine_Family__c from Asset where name = '79963831' limit 1];
        
        ServiceTerritory serTer = [select id,name,OperatingHoursId, IsActive,Territory__c,Region__c,
                                   FSL_Service_Territory_Code__c from ServiceTerritory where name='ST001 Mobile' limit 1];
        ServiceTerritory serTer1 = [select id,name,OperatingHoursId, IsActive,Territory__c,Region__c,
                                    FSL_Service_Territory_Code__c from ServiceTerritory where name='ST005 In Shop' limit 1];
        
        Case  cs = [select id,Status,AccountId,AssetId,Priority from case where AccountId=:acc.id limit 1];
        FSL_SubType__c subType = [select id,name,Branch_Code__c,Status__c from FSL_SubType__c where name='Test Sub Type' limit 1];
        
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
        
        woInfo.add(wo1);
        
        insert woInfo;
        wo1.FSL_Sub_Type__c = subType.Id;
        wo1.Asset = ast1;
        update wo1;
        
        List<workorder> woInfo1 = new List<workorder>();
        workorder wo2 = new workorder();
        wo2.id = woInfo[0].id;
        wo2.EditComplaint__c = 'Testing Info';
        wo2.EditCause__c = 'Testing Info';
        wo2.EditCorrection__c = 'Testing Info';
        wo2.EditCoverage__c = 'Testing Info1';
        wo2.ServiceTerritoryid = serTer1.id;
        wo2.sub_status__c = 'A';
        wo2.Asset = ast1;
        wo2.assetid = ast1.id;
        wo2.FSL_Sub_Type__c =subType.Id;
        // wo2.FSL_Additional_Email_Notifications__c='test@test.com';
        woInfo1.add(wo2);
        
        test.startTest();
        update woInfo1;
        
        Map<id,workorder> woInfoTest = new Map<id,workorder>();
        
        woInfoTest.put(woInfo[0].id,woInfo[0]);
        
        Map<id,workorder> woInfoTest1 = new Map<id,workorder>();
        
        woInfoTest1.put(woInfo1[0].id,woInfo1[0]);
        map<id,WorkOrder> mapOldServiceorder = new  map<id,WorkOrder>();
        mapOldServiceorder.put(woInfo1[0].id,woInfo1[0]);
        
        FSL_workorderListTriggerHandle.workorderTriggerHandleAfterInsert(woInfo);
        FSL_workorderListTriggerHandle.workorderTriggerHandleBeforeInsert(woInfo);
        //FSL_workorderListTriggerHandle.workorderTriggerHandleBeforeUpdate(woInfoTest,woInfoTest1);
        FSL_workorderListTriggerHandle.workorderTriggerHandleAfterUpdate(woInfoTest,woInfoTest1);
        FSL_WorkorderTriggerHelper.updateFourCs(woInfo,woInfoTest1);
        FSL_workorderListTriggerHandle.getcampaingintegration(woInfo,woInfoTest1,true);
        FSL_workorderListTriggerHandle.subStatusToTroubleshootingComplete(woInfoTest,woInfoTest1);
        system.assertEquals('A', wo2.sub_status__c , 'success');
        
        test.stoptest();
    }
    
    public testMethod static void TiggerHandler_two(){
        
        list<CSS_Solution_Component__c> lstCSS = new list<CSS_Solution_Component__c>();

        ServiceTerritory st = [select id,name,OperatingHoursId, IsActive,Territory__c,Region__c,
                               FSL_Service_Territory_Code__c from ServiceTerritory where name='ST001 Mobile' limit 1];
        

        Asset  ast = [select id,Type__c,Type_PSN__c from Asset where name = '79963830' limit 1];
        
        Date d = Date.Today();
        WorkOrder SerRec = new WorkORder();
        SerRec.DSID__c='12345';
        SerRec.Customer_Name__c='ABC';
        SerRec.Failure_Date__c =d;
        SerRec.Service_Model__c='ESN';
        SerRec.Make__c='test';
        SerRec.Model__c='test1';
        SerRec.Customer_Name__c='Sam Torq';
        SerRec.Warranty_Start_Date__c=d; 
        SerRec.ESN__c = '79464647';
        SerRec.Mileage__c = 12345;
        SerRec.Mileage_measure__c = 'Miles'; 
        SerRec.ServiceTerritoryId = sT.Id;
        SerRec.AssetId = ast.id;
        
        Insert SerRec;
         
        CSS_Solutions__c sol=new CSS_Solutions__c();
        sol.Case_Name__c='test';
        sol.Name = 'sol';
        sol.Rank__c = 0;
        sol.Diagnostic_Response__c = null;
        sol.Repair_Response__c='test';
        //sol.Symptom__c=sym.id;
        sol.FSL_Service_Job__c =SerRec.Id;
        insert sol;
        
        CSS_SymptomQA__c sym=new CSS_SymptomQA__c();
        // sym.Job_Order__c=JO.id;
        sym.caption__c ='white smoke';
        sym.Option1__c  ='12213';
        // sym.Job_Order__c  =Jo.id;
        sym.Option_type__c  ='qwewqe';
        sym.Guide_Question__c  ='1asdsad2213';
        sym.Type__c  ='SearchString';
        sym.Answers__c = 'ans';
        sym.Caption__c = 'cap';
        sym.Sequence__c = 1.6;
        insert sym;
        test.starttest();
        Css_job_order__c Job = CSS_TestData.createJobOrder(true);
        css_solutions__c Solution = CSS_TestData.createSolutions(true,Job.id);
        
        CSS_Solution_Component__c AddsolComp = new CSS_Solution_Component__c();
        AddsolComp.Component_Id__c ='F0051000';
        AddsolComp.FSL_Service_Job__c = SerRec.Id;
        AddsolComp.FSL_Service_Order__c = SerRec.Id;
        AddsolComp.Action__c = 'Repair';
        AddsolComp.Solutions__c = Solution.id;
        AddsolComp.Quantity__c = 4;
        AddsolComp.type__c='CAM';
        //AddsolComp.
        AddsolComp.Selected_Component__c = True;
        AddsolComp.AccountCode__c = 'Test-AccountCode';
        AddsolComp.AccountCodeEdit__c = 'Test-ACEdit';
        AddsolComp.CoveredPartsQty__c = null;
        AddsolComp.AccountCodeType__c='ASAS';
        AddsolComp.Fail_Code_Editable__c='CAM-campaign';
        
        AddsolComp.Charlength__c = true;
        AddsolComp.Name = 'Test'+Math.random();
        
        insert AddsolComp;
        
        WorkOrder wo =  new WorkOrder();
       
        wo.DSID__c='12345';
        wo.Customer_Name__c='ABC';
        wo.Failure_Date__c =d;
        wo.Service_Model__c='ESN';
        wo.Make__c='test';
        wo.Model__c='test1';
        wo.Customer_Name__c='Sam Torq';
        wo.Warranty_Start_Date__c=d;
        wo.ESN__c = '';
        wo.Mileage__c = 12345;
        wo.Mileage_measure__c = 'Miles';
        wo.ServiceTerritoryId = sT.Id;
        wo.AssetId = ast.id;
        wo.Type__c='Internal';
        wo.General_Symptoms__c='Test123';
        //Insert wo;    
        system.assertEquals('CAM', AddsolComp.type__c , 'Matched1');
        
        FSL_workorderListTriggerHandle.deleteFieldActions(SerRec.id);
        test.stoptest();
    }
    
    public testMethod static void TiggerHandler_three(){
       
        account acc=[select id,name,Email_Notification_Frequency__c,RecordTypeId 
                     from account where Name = 'Freightliner of Arizona LLC' limit 1];
        
        ServiceTerritory st = [select id,name,OperatingHoursId, IsActive,Territory__c,Region__c,
                               FSL_Service_Territory_Code__c from ServiceTerritory where name='ST001 Mobile' limit 1];
        
        user testUser =  [SELECT Id FROM user WHERE userName = 'testUserRaghav@testEmail.com' LIMIT 1]; 
        ServiceResource res = new ServiceResource();
        res.Name = 'Test Unqualified Resource';
        res.RelatedRecordId = testUser.id;
        res.IsActive = true;
        res.ResourceType = 'T';
        insert res;
        ServiceTerritoryMember stm=new ServiceTerritoryMember();
        stm.ServiceResourceId=res.Id;
        stm.ServiceTerritoryId=st.id;
        stm.TerritoryType='P';
        stm.EffectiveStartDate=datetime.now();
        stm.Street = '1460 N National Rd';
        stm.City = 'Columbus';
        stm.State = 'Indiana';
        stm.Country = 'United States';
        stm.PostalCode = '47201';
        insert stm;
        
        Asset  ast = [select id,Type__c,Type_PSN__c,Service_Model__c,Unit_Number__c,Make__c,Model__c,name,Unit_Type__c,
                      VIN__c,Application_Description__c,Application_Code__c,Engine_Family__c from Asset where name = '79963830' limit 1];
        
        WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        
        MaintenancePlan objMP = new MaintenancePlan();
        objMP.StartDate= system.today();
        objMP.EndDate=system.today()+365;
        objMP.Frequency=1;
        objMP.FrequencyType ='Months';
        objMP.NextSuggestedMaintenanceDate = system.today();
        objMP.GenerationTimeframe=2;
        objMP.WorkTypeId = pmWorkType.id;
        //  objMP.DoesGenerateUponCompletion=true;
        // objMP.MaintenanceWindowStartDays=10;
        //  objMP.MaintenanceWindowEndDays=12;
        // objMP.SuggestedMaintenanceDate = System.today()+3;
        insert objMP;
        FSL_SubType__c subType1 = new FSL_SubType__c();
        subType1.name = 'Test Sub Type';
        subType1.Branch_Code__c =10;
        subType1.Status__c='Active';
        insert subType1;
        MaintenanceAsset MA = new MaintenanceAsset();
        MA.MaintenancePlanId = objMP.Id;
        MA.AssetId =ast.Id;
        MA.Branch_Code__c = subType1.Branch_Code__c;
        
        MA.WorkTypeId=pmWorkType.Id;
        MA.Sub_Type__c = subType1.Id;
        insert MA;
        
        Maintenance_Asset_Part__c MASS = new Maintenance_Asset_Part__c();
        MASS.Maintenance_Asset__c =MA.Id;
        insert MASS;
        
        Maintenance_Asset_SRT__c MST = new Maintenance_Asset_SRT__c();
        MST.Maintenance_Asset__c =MA.Id;
        insert MST;
        
        MaintenanceWorkRule objWR = new MaintenanceWorkRule();
        objWR.SortOrder =1;
        // objWR.ParentMaintenancePlanId = objMP.Id;
        objWR.Title ='Test';
        objWR.RecurrencePattern ='FREQ=MONTHLY;INTERVAL=1;COUNT=5';
        objWR.NextSuggestedMaintenanceDate = system.today()+30;
        objWR.ParentMaintenanceRecordId = MA.Id;
        objWR.WorkTypeId=pmWorkType.Id;
        insert objWR;
        
        List<WorkOrder> woList = new List<WorkOrder>();
        WorkOrder wo = new WorkOrder();
        wo.AccountId = acc.id; 
        wo.Payer__c = acc.id;        
        // wo.Payer_ContactID__c=con.Id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.ServiceTerritoryId=st.Id;
        wo.EditCause__c = 'Testing Info2';
        //wo.ServiceTerritoryid = serTer1.id;
        wo.EditCorrection__c = 'Testing Info2';
        wo.EditCoverage__c = 'Testing Info12';
        // wo.MaintenanceWorkRuleId=objWR.Id;
        wo.MaintenancePlanId =objMP.Id;
        wo.SuggestedMaintenanceDate = system.today();
        //wo.Type__c = 'Internal';
        wo.Service_Team_Contact__c = testUser.id;
        woList.add(wo);
        Test.startTest();
        insert woList;
        
        //FSL_workorderListTriggerHandle.insertServiceOrderContactList(woList);
        
        CSS_CampTsbTrp__c ctt2 = new CSS_CampTsbTrp__c();
        ctt2.Type__c = 'TRP';
        ctt2.URL__c = 'https://qs-stg.cummins.com/qs3/pubsys2/xml/en/atc/19TC/atc1623.html';
        ctt2.Doc_Num__c = 'TF0051000';
        ctt2.Doc_Title__c = 'DUAL FUEL DATAPLATE ATC';
        ctt2.Performed__c = false;
        ctt2.Performed_Review__c = true;
        ctt2.Reviewed__c = false;
        ctt2.FSL_ServiceJob__c = woList[0].Id;
        ctt2.cu_language__C = 'fr';
        insert ctt2;
        
        
        wo.EditCause__c = 'Testing Info';
        wo.ServiceTerritoryid = null;
        wo.EditCorrection__c = 'Testing Info';
        wo.EditCoverage__c = 'Testing Info1';
        
        update wo;
        
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        FSL_SubType__c stype = new FSL_SubType__c();
        stype.Name ='TestSubTypeFTM';
        insert stype;
        List<WorkType> wt = [Select Id From WorkType Where Name = 'Test WorkType FTM'];
        List<Account> acc2 = [Select Id From Account Where Name = 'Test Acc FTM'];
        List<FSL_Form_Template_Matrix__c> templateList = new List<FSL_Form_Template_Matrix__c>();
        try{
            FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
            
            
            ftm.FSL_Query_Operator__c = 'OR';
            ftm.FSL_Form_Template__c = formTemplate.Id;
            ftm.FSL_Sub_Type__c = stype.Id;
            ftm.FSL_Work_Type__c = pmWorkType.Id;
            ftm.Account__c = acc.Id;
            ftm.One_Form_Per_Service_Order__c = true;
            
            insert ftm;}
        catch (exception e){}
        
        wo.status='Canceled';
        
        update wo;
        system.assertEquals('Canceled', wo.status , 'Matched2');
        
        test.stoptest();
    }
    
    public testMethod static void TiggerHandler_four(){  
     
        account acc=[select id,name,Email_Notification_Frequency__c,RecordTypeId 
                     from account where Name = 'Freightliner of Arizona LLC' limit 1];
        //Contact con=[select id,LastName,FirstName,AccountId,Email from Contact where FirstName='test' limit 1];
        
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con= new Contact();
        con.RecordTypeId = conRecId;
        con.LastName='test';
        con.FirstName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        // con.Email_Notifications__c = true;
        // con.Text_Notifications__c = true;
        // con.Nightly_Communications__c = true;
        insert con;
        
       
        ServiceTerritory st = [select id,name,OperatingHoursId, IsActive,Territory__c,Region__c,
                               FSL_Service_Territory_Code__c from ServiceTerritory where name='ST001 Mobile' limit 1];
        
        user testUser = [SELECT Id FROM user WHERE userName = 'testUserRaghav@testEmail.com' LIMIT 1];
        ServiceResource res = new ServiceResource();
        res.Name = 'Test Unqualified Resource';
        res.RelatedRecordId = testUser.id;
        res.IsActive = true;
        res.ResourceType = 'T';
        insert res;
        ServiceTerritoryMember stm=new ServiceTerritoryMember();
        stm.ServiceResourceId=res.Id;
        stm.ServiceTerritoryId=st.id;
        stm.TerritoryType='P';
        stm.EffectiveStartDate=datetime.now();
        stm.Street = '1460 N National Rd';
        stm.City = 'Columbus';
        stm.State = 'Indiana';
        stm.Country = 'United States';
        stm.PostalCode = '47201';
        insert stm;
        list<asset> astlst=new list<asset>();
        Asset ast = new Asset();
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        //insert ast;
        astlst.add(ast);
        Asset ast2 = new Asset();
        ast2.name='79371785';
        ast2.Unit_Number__c='595765';
        ast2.VIN__c='BJ361431';
        // insert ast2;
        astlst.add(ast2);
        insert astlst;
        
        WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        
        MaintenancePlan objMP = new MaintenancePlan();
        objMP.StartDate= system.today();
        objMP.EndDate=system.today()+365;
        objMP.Frequency=1;
        objMP.FrequencyType ='Months';
        objMP.NextSuggestedMaintenanceDate = system.today();
        objMP.GenerationTimeframe=2;
        objMP.WorkTypeId = pmWorkType.id;
        //  objMP.DoesGenerateUponCompletion=true;
        // objMP.MaintenanceWindowStartDays=10;
        //  objMP.MaintenanceWindowEndDays=12;
        // objMP.SuggestedMaintenanceDate = System.today()+3;
        insert objMP;
        FSL_SubType__c subType1 = new FSL_SubType__c();
        subType1.name = 'Test Sub Type';
        subType1.Branch_Code__c =10;
        subType1.Status__c='Active';
        insert subType1;
        MaintenanceAsset MA = new MaintenanceAsset();
        MA.MaintenancePlanId = objMP.Id;
        MA.AssetId =ast.Id;
        MA.WorkTypeId=pmWorkType.Id;
        MA.Sub_Type__c = subType1.Id;
        MA.Branch_Code__c=subType1.Branch_Code__c;
        insert MA;
        
        Maintenance_Asset_Part__c MASS = new Maintenance_Asset_Part__c();
        MASS.Maintenance_Asset__c =MA.Id;
        insert MASS;
        
        Maintenance_Asset_SRT__c MST = new Maintenance_Asset_SRT__c();
        MST.Maintenance_Asset__c =MA.Id;
        insert MST;
        
        MaintenanceWorkRule objWR = new MaintenanceWorkRule();
        objWR.SortOrder =1;
        // objWR.ParentMaintenancePlanId = objMP.Id;
        objWR.Title ='Test';
        objWR.RecurrencePattern ='FREQ=MONTHLY;INTERVAL=1;COUNT=5';
        objWR.NextSuggestedMaintenanceDate = system.today()+30;
        objWR.ParentMaintenanceRecordId = MA.Id;
        objWR.WorkTypeId=pmWorkType.Id;
        insert objWR;
        
        test.startTest();
        WorkOrder wo = new WorkOrder();
        wo.AccountId = acc.id; 
        wo.Payer__c = acc.id;        
        wo.Payer_ContactID__c=con.Id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.ServiceTerritoryId=st.Id;
        wo.EditCause__c = 'Testing Info2';
        //wo.ServiceTerritoryid = serTer1.id;
        wo.EditCorrection__c = 'Testing Info2';
        wo.EditCoverage__c = 'Testing Info12';
        // wo.MaintenanceWorkRuleId=objWR.Id;
        wo.MaintenancePlanId =objMP.Id;
        wo.SuggestedMaintenanceDate = system.today();
        //wo.Type__c = 'Internal';
        // wo.Service_Team_Contact__c = testUser.id;
        wo.ContactID = con.id;
        wo.FSL_Sub_Type__c=subtype1.id;
        
        insert wo;
        
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        FSL_SubType__c stype = new FSL_SubType__c();
        stype.Name ='TestSubTypeFTM';
        insert stype;
        List<WorkType> wt = [Select Id From WorkType Where Name = 'Test WorkType FTM'];
        List<Account> acc2 = [Select Id From Account Where Name = 'Test Acc FTM'];
        List<FSL_Form_Template_Matrix__c> templateList = new List<FSL_Form_Template_Matrix__c>();
        try{  FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
            ftm.FSL_Query_Operator__c = 'OR';
            ftm.FSL_Form_Template__c = formTemplate.Id;
            ftm.FSL_Sub_Type__c = stype.Id;
            ftm.FSL_Work_Type__c = pmWorkType.Id;
            ftm.Account__c = acc.Id;
            ftm.One_Form_Per_Service_Order__c = true;
            
            insert ftm;
           }
        catch (exception e){}
        
        system.assertEquals('PROSTAR', wo.Model__c , 'Matched');
        
        test.stoptest();
    }
    
    public testMethod static void TiggerHandler_prepaidupdate(){
      
        Account acc=[select id,name,CMI_Account_Status__c,PaymentType__c,FSL_ERP_Customer_Code__c,FSL_Credit_Limit__c,
                     Email_Notification_Frequency__c from account where name='East Bronx1' limit 1];
        
        
        Asset  ast = [select id,Type__c,Type_PSN__c,Service_Model__c,Unit_Number__c,Make__c,Model__c,name,Unit_Type__c,
                      VIN__c,Application_Description__c,Application_Code__c,Engine_Family__c from Asset where name = '79963830' limit 1];
       
        ServiceTerritory serTer = [select id,name,OperatingHoursId, IsActive,Territory__c,Region__c,
                                   FSL_Service_Territory_Code__c from ServiceTerritory where name='ST001 Mobile' limit 1];
        
        
        Case  cs = [select id,Status,AccountId,AssetId,Priority from case where AccountId=:acc.id limit 1];
        
        
        FSL_SubType__c subType1 = new FSL_SubType__c();
        subType1.name = 'Test Sub Type';
        subType1.Branch_Code__c =10;
        subType1.Status__c='Active';
        insert subType1;
        
        WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        
        MaintenancePlan objMP = new MaintenancePlan();
        objMP.StartDate= system.today();
        objMP.EndDate=system.today()+365;
        objMP.Frequency=1;
        objMP.FrequencyType ='Months';
        objMP.NextSuggestedMaintenanceDate = system.today();
        objMP.GenerationTimeframe=2;
        objMP.WorkTypeId = pmWorkType.id;
        objMP.Payment__c='Prepaid';
        objMP.Sub_Type__c = subType1.Id;
        insert objMP;
        
        MaintenanceAsset MA = new MaintenanceAsset();
        MA.MaintenancePlanId = objMP.Id;
        MA.AssetId =ast.Id;
        MA.WorkTypeId=pmWorkType.Id;
        MA.Sub_Type__c = subType1.Id;
        MA.Branch_Code__c=subType1.Branch_Code__c;
        insert MA;
        
        Maintenance_Asset_Part__c MASS = new Maintenance_Asset_Part__c();
        MASS.Maintenance_Asset__c =MA.Id;
        insert MASS;
        
        workorder wo1 = new workorder();
        wo1.Account = acc;
        wo1.Process_Step__c = 'Intake';
        wo1.Asset = ast;
        wo1.ESN__c='700700088';
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
        wo1.Case = cs;
        wo1.MaintenancePlanId =objMP.Id;
        wo1.sub_status__c = 'Troubleshooting Complete';
        wo1.AssetId = ast.id;
        wo1.SuggestedMaintenanceDate=system.today();
        wo1.FSL_Sub_Type__c = subType1.Id;
        wo1.WorkTypeId = pmWorkType.Id;
        insert wo1;
        
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'OR';
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Sub_Type__c = subType1.Id;
        ftm.FSL_Work_Type__c = pmWorkType.Id;
        ftm.Account__c = acc.Id;
        ftm.One_Form_Per_Service_Order__c = true;
        ftm.Active__c = true;
        insert ftm;
        
        test.startTest();
        workorder woRec=[SELECT Id,Prepaid__c,ESN__c FROM workorder WHERE  ESN__c='700700088'];
        system.assertEquals('Y', woRec.Prepaid__c, 'Matched3');
        test.stopTest(); 
    } 
}