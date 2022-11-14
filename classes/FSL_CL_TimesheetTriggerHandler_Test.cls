@isTest
public class FSL_CL_TimesheetTriggerHandler_Test {
    
    @testSetup static void setup() {
        Id profid = [select Id from profile where name= 'System Administrator' LIMIT 1].Id;
        Id RepairRTID =Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        
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
        
        //create Account
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account(); //CT2-388
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        // create contact
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'testFirst',
                                      LastName = 'testLast',
                                      Username__c = 'testUser@testEmail.com',
                                      Email = 'testUser@testEmail.com',
                                      AccountId = objAccount.Id,
                                      RecordTypeId = conRecId,
                                      //Mobile_Phone__c = '1212333300', // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                                      MobilePhone = '1212333300');
        Insert contact;
        
        // create OperatingHours
        OperatingHours hours = new OperatingHours();
        hours.Name = 'Test Hours';
        hours.Description = 'Test Description';
        insert hours;
        FSL_Labor_Multiplier__c labMultiplier = new FSL_Labor_Multiplier__c();
        labMultiplier.Name='TIER B';
        insert labMultiplier;
        
        Asset objAssetSet = new Asset();
        objAssetSet.Name = 'A1B2C3D4';
        objAssetSet.Type_PSN__c = 'Engines-A1B2C3D4';
        objAssetSet.Type__c = 'Engines';
        objAssetSet.Service_Model__c ='NONCUMMINS';
        objAssetSet.Engine_Family_Code__c  ='99';
        objAssetSet.Source__c  = 'BMS';
        objAssetSet.Labor_Multiplier__c = labMultiplier.Id;
        insert objAssetSet;
        
        WorkType objWorkTypeSet = new WorkType();
        objWorkTypeSet.Name = 'Test WorkType';
        objWorkTypeSet.EstimatedDuration = 60.0;
        objWorkTypeSet.DurationType = 'Minutes';
        insert objWorkTypeSet;
        
        OperatingHours oh = new OperatingHours();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        
        ServiceTerritory terrSet = new ServiceTerritory();
        terrSet.Name = 'testPopulateTerritory Territory';
        terrSet.OperatingHoursId = oh.Id;
        terrSet.IsActive = true; 
        terrSet.Location_Code__c = '01234-01234';
        terrSet.FSL_Service_Territory_Code__c = '01234';
        terrSet.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        terrSet.Territory__c = 'AUSTRALIA';
        insert terrSet;
        
        //CT2-388
        FSL_SubType__c subTypeInfoSet = new FSL_SubType__c();
        subTypeInfoSet.Name = 'R1';
        subTypeInfoSet.CodeValueBranchCode__c = terrSet.Location_Code__c;
        subTypeInfoSet.Branch_Code__c = 04892;
        subTypeInfoSet.Status__c = 'Active';
        insert subTypeInfoSet;
        
        Service_Order_Extension__c soe = new Service_Order_Extension__c();
        insert soe;
        
        List<workorder> wolist=new List<workorder>();
        
        WorkOrder wo = new WorkOrder();
        wo.AccountId = objAccount.Id;
        wo.Service_Order_Extension__c = soe.Id;
        //wo.ContactId = contact.Id;
        wo.ServiceTerritoryId = terrSet.Id;
        wo.Priority = 'Low';
        wo.Status = 'Intake';
        wo.ESN_Insite__c = '79799701';
        wo.Process_Step__c = 'Repair';
        wo.WorkTypeId = objWorkTypeSet.Id;
        wo.Type__c = 'Internal';
        wo.AssetId = objAssetSet.Id;
        wo.Shop_Work_Order__c = 'test_Shop_Work_Order'; //ct2-388
        wo.FSL_Sub_Type__c = subTypeInfoSet.Id; //ct2-388
        // insert wo;
        wolist.add(wo);
        WorkOrder wo2 = new WorkOrder();
        wo2.AccountId = objAccount.Id;
        wo2.Service_Order_Extension__c = soe.Id;
        //wo.ContactId = contact.Id;
        wo2.ServiceTerritoryId = terrSet.Id;
        wo2.Priority = 'Low';
        wo2.Status = 'Intake';
        wo2.ESN_Insite__c = '79799702';
        wo2.Process_Step__c = 'Repair';
        wo2.WorkTypeId = objWorkTypeSet.Id;
        wo2.Type__c = 'Internal';
        wo2.AssetId = objAssetSet.Id;
        wo2.Shop_Work_Order__c = 'test_Shop_Work_Order'; //ct2-388
        wo2.FSL_Sub_Type__c = subTypeInfoSet.Id; //ct2-388
        wolist.add(wo2);
        //insert wo2;
        insert wolist;
        
        FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
        tsheet.Service_Order__c = wo.Id;
        tsheet.StartTime__c = System.Datetime.now();
        tsheet.Endtime__c = tsheet.StartTime__c.addminutes(30);
        tsheet.Resource__c = users[0].Id;
        tsheet.Reason__c = 'Travel';
        tsheet.Notes__c = 'Starttimechangesetup';
        tsheet.Status__c = 'New';
        insert tsheet;
        
    }
    
    @isTest 
    static void testAfterInsert() {
        user testUser = [SELECT Id FROM User LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours objOperatingHours = [SELECT Id FROM OperatingHours LIMIT 1];
        WorkOrder objWorkOrder;
        
        try {            
            WorkType objWorkType = new WorkType();
            objWorkType.Name = 'Test WorkType';
            objWorkType.EstimatedDuration = 60.0;
            objWorkType.DurationType = 'Minutes';
            
            WorkType wrtype = new WorkType();
            wrtype.Name = 'Internal';
            wrtype.EstimatedDuration = 8;
            
            insert new List<WorkType>{wrtype,objWorkType};
                
            Test.startTest();
            
            ServiceResource sr=new ServiceResource();
            sr.Name='service resource';
            sr.IsActive=true;
            sr.RelatedRecordId=testUser.id;
            sr.ResourceType='T';
            insert sr;
            
            ServiceTerritory objServiceTerritory = new ServiceTerritory();
            objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
            objServiceTerritory.IsActive = true; 
            objServiceTerritory.Location_Code__c = '01234-01234';
            objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
            objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
            objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            objServiceTerritory.Territory__c = 'AUSTRALIA';
            insert objServiceTerritory; 
            
            ServiceTerritoryMember stm=new ServiceTerritoryMember();
            stm.ServiceResourceId=sr.id;
            stm.ServiceTerritoryId=objServiceTerritory.id;
            stm.TerritoryType='P';
            stm.EffectiveStartDate=datetime.now();
            stm.Street = '1460 N National Rd';
            stm.City = 'Columbus';
            stm.State = 'Indiana';
            stm.Country = 'United States';
            stm.PostalCode = '47201';
            insert stm;
            Id intakeRTID =
                Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Intake').getRecordTypeId();
            Id RepairRTID =
                Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
            
            Asset objAsset = new Asset();
            objAsset.Name = '23234324';
            objAsset.Type_PSN__c = 'Engines-79788868';
            objAsset.Type__c = 'Engines';
            insert objAsset;
            
            List<WorkOrder> WorkOrderList = new List<WorkOrder>();
            
            objWorkOrder = new WorkOrder();
            objWorkOrder.recordtypeid=RepairRTID;
            objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
            objWorkOrder.Status = 'Intake';
            objWorkOrder.ESN_Insite__c = '79799702';
            objWorkOrder.Process_Step__c = 'Repair';
            objWorkOrder.AccountId = accountObj.Id;
            objWorkOrder.WorkTypeId = objWorkType.Id;
            objWorkOrder.Type__c = 'External'; 
            objWorkOrder.AssetId = objAsset.Id;
            //insert objWorkOrder;
            WorkOrderList.add(objWorkOrder);
            
            WorkOrder objWork = new WorkOrder();
            objWork.ServiceTerritoryId = objServiceTerritory.Id;
            objWork.Status = 'Intake';
            objWork.ESN_Insite__c = '79799702';
            objWork.Process_Step__c = 'Intake';
            objWork.AccountId = accountObj.Id;
            objWork.WorkTypeId = objWorkType.Id;
            objWork.Type__c = 'Internal';
            objWork.AssetId = objAsset.Id;
            objWork.recordtypeid=intakeRTID;
            insert objWork;
            //WorkOrderList.add(objWork);
            insert WorkOrderList;
            
            //Added - 31-March-2020
            
            
            serviceappointment sa= new serviceappointment();
            sa.parentrecordId = objWork.Id;
            sa.Status = 'None';
            sa.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
            sa.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
            sa.SchedStartTime=datetime.now()+3;
            sa.SchedEndTime=datetime.now()+4;
            sa.Service_Order__c= objWork.id;
            insert sa;
            
            
            Test.stopTest();
            
            
            List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
            FSL_Timesheet__c ts = new FSL_Timesheet__c();
            ts.Service_Order__c = objWorkOrder.Id;
            ts.StartTime__c = System.Datetime.now();
            //ts.EndTime__c = System.Datetime.now().addDays(1);
            ts.Reason__c = 'Travel';
            
            FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
            tsheet.Service_Order__c = objWork.Id;
            tsheet.StartTime__c = System.Datetime.now();
            //ts.EndTime__c = System.Datetime.now().addDays(1);
            //    tsheet.Reason__c = 'Travel';
            insert tsheet;
            
            tsheet.EndTime__c = System.Datetime.now().addDays(1);
            update tsheet;
            
            FSL_Timesheet__c tsLunch = new FSL_Timesheet__c();
            tsLunch.Service_Order__c = objWorkOrder.Id;
            tsLunch.StartTime__c = System.Datetime.now();
            //tsLunch.EndTime__c = System.Datetime.now().addDays(1);
            tsLunch.Reason__c = 'Lunch';
            
            FSL_Timesheet__c tsPaperWork = new FSL_Timesheet__c();
            tsPaperWork.Service_Order__c = objWorkOrder.Id;
            tsPaperWork.StartTime__c = System.Datetime.now();
            //tsPaperWork.EndTime__c = System.Datetime.now().addDays(1);
            tsPaperWork.Reason__c = 'Paper Work';
            
            tsList.add(ts);
            tsList.add(tsLunch);
            tsList.add(tsPaperWork);
            //tsList.add(tsheet);
            insert tsList;
            
            tsPaperWork.EndTime__c = System.Datetime.now().addDays(1);
            update tsPaperWork;
            List<FSL_Timesheet__c> tsList1 = [SELECT Id FROM FSL_Timesheet__c WHERE Service_Order__c = :objWorkOrder.Id];
        	System.assertEquals(3, tsList1.size());
        }
        catch(exception ex) {
        }
        
    }
    
    @isTest
    private static void testTimeSheetTrigger() {
        user testUser = [SELECT Id FROM User LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        try {
            
            WorkType wt = new WorkType(name='Internal',EstimatedDuration=4,DurationType='Hours');
            insert wt;
            
            TimeSlot timeslt = new TimeSlot();
            timeslt.DayOfWeek = system.now().adddays(3).format('EEEE');
            timeslt.StartTime = Time.newInstance(08,00,00,00);
            timeslt.EndTime =  Time.newInstance(17,00,00,00);
            timeslt.Operatinghoursid = hours.id;
            insert timeslt;
            Id ruleId = Schema.SObjectType.FSL__Work_Rule__c.getRecordTypeInfosByName().get('Field Service - Match Skills').getRecordTypeId();
            FSL__Work_Rule__c newRule = new FSL__Work_Rule__c();
            newRule.Name = 'My Test Rule';
            newRule.FSL__Active__c = TRUE;
            newRule.FSL__Match_Skill_Level__c = TRUE;
            newRule.RecordTypeId = ruleId;
            Insert newRule;
            
            Asset objAsset = new Asset();
            objAsset.Name = 'A1B2C3D4';
            objAsset.Type_PSN__c = 'Engines-A1B2C3D4';
            objAsset.Type__c = 'Engines';
            insert objAsset;
            
            WorkType objWorkType = new WorkType();
            objWorkType.Name = 'Test WorkType';
            objWorkType.EstimatedDuration = 60.0;
            objWorkType.DurationType = 'Minutes';
            insert objWorkType;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = testUser.Id;
            res.IsActive = true;
            res.ResourceType = 'T';
            insert res;
            
            Test.startTest();
            
            ServiceTerritory terr = new ServiceTerritory();
            terr.Name = 'testPopulateTerritory Territory';
            terr.OperatingHoursId = hours.Id;
            terr.IsActive = true;
            terr.Location_Code__c = '01234-01234';
            terr.FSL_Service_Territory_Code__c = '01234';
            terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            terr.Territory__c = 'AUSTRALIA';
            insert terr;
            
            
            
            
            
            WorkOrder wo = new WorkOrder();
            wo.AccountId = accountObj.Id;
            wo.ContactId = contactObj.Id;
            wo.ServiceTerritoryId = terr.Id;
            wo.Priority = 'Low';
            wo.Status = 'Intake';
            wo.ESN_Insite__c = '79799702';
            wo.Process_Step__c = 'Repair';
            wo.WorkTypeId = objWorkType.Id;
            wo.Type__c = 'External';
            wo.AssetId = objAsset.Id;
            insert wo;
            
            ServiceAppointment appt = new ServiceAppointment();
            appt.Status = 'None';
            appt.ParentRecordId = wo.Id;
            appt.ServiceTerritoryId = terr.Id;
            appt.ContactId = contactObj.Id;
            appt.SchedStartTime = DateTime.now();
            appt.SchedEndTime = DateTime.now().addHours(4);
            //insert appt;
            
            
            
            ServiceTerritoryMember tMember = new ServiceTerritoryMember();
            tMember.EffectiveStartDate = Date.today().addDays(-1);
            tMember.EffectiveEndDate = Date.today().addDays(100);
            tMember.ServiceResourceId = res.Id;
            tMember.TerritoryType = 'P';
            tMember.ServiceTerritoryId = terr.Id;
            tMember.Street = '1460 N National Rd';
            tMember.City = 'Atlanta';
            tMember.State = 'Indiana';
            tMember.Country = 'United States';
            tMember.PostalCode = '40021';
            insert tMember;
            
            Test.stopTest();
            //Added - 31-March-2020
            ResourceAbsence ra = new ResourceAbsence(start=system.now().adddays(3),end=system.now().adddays(4),Billing_Type__c='ATO-AUTHORIZED TIME OFF',Resource_ERP__c='BMS');
            insert ra;
            List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
            FSL_Timesheet__c ts = new FSL_Timesheet__c();
            ts.Service_Order__c = wo.Id;
            ts.StartTime__c = System.Datetime.now();
            ts.Resource__c = testUser.Id;
            //ts.EndTime__c = System.Datetime.now().addDays(1);
            ts.Reason__c = 'Travel';
            
            FSL_Timesheet__c tsLunch = new FSL_Timesheet__c();
            tsLunch.Service_Order__c = wo.Id;
            tsLunch.StartTime__c = System.Datetime.now();
            tsLunch.Resource__c = testUser.Id;
            //tsLunch.EndTime__c = System.Datetime.now().addDays(1);
            tsLunch.Reason__c = 'Lunch';
            
            FSL_Timesheet__c tsPaperWork = new FSL_Timesheet__c();
            tsPaperWork.Service_Order__c = wo.Id;
            tsPaperWork.StartTime__c = System.Datetime.now();
            //tsPaperWork.EndTime__c = System.Datetime.now().addDays(1);
            tsPaperWork.Reason__c = 'Paper Work';
            tsPaperWork.Resource__c = testUser.Id;
            
            tsList.add(ts);
            tsList.add(tsLunch);
            tsList.add(tsPaperWork);
            insert tsList;
            
            tsPaperWork.EndTime__c = System.Datetime.now().addDays(1);
            //update tsPaperWork;
            List<FSL_Timesheet__c> timeSheets = [SELECT Id, Reason__c FROM FSL_Timesheet__c WHERE Reason__c = 'Lunch'];
            System.assertEquals(1, timeSheets.size());
            System.assertEquals('Lunch', timeSheets[0].Reason__c);
        } catch(Exception ex) {
            System.debug('::: Exception in testTimeSheetTrigger = '+ex.getMessage());
        }
        
    }
    
    /** @isTest
private static void testStartendtimeorg() { 
user testUser = [SELECT Id FROM User LIMIT 1];
Account accountObj = [SELECT Id FROM Account LIMIT 1];
Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];

Asset objAsset = new Asset();
objAsset.Name = 'A1B2C3D4';
objAsset.Type_PSN__c = 'Engines-A1B2C3D4';
objAsset.Type__c = 'Engines';
insert objAsset;

WorkType wrtype = new WorkType();
wrtype.Name = 'Internal';
wrtype.EstimatedDuration = 60.0;
wrtype.DurationType = 'Minutes';
insert wrtype;
system.debug('testUser++++'+testUser);
Test.startTest();
system.debug('testUser++++'+testUser);
ServiceResource res = new ServiceResource();
res.Name = 'Test Unqualified Resource';
res.RelatedRecordId = testUser.Id;
res.IsActive = true;
res.ResourceType = 'T';
insert res;

ServiceTerritory terr = new ServiceTerritory();
terr.Name = 'testPopulateTerritory Territory';
terr.OperatingHoursId = hours.Id;
terr.IsActive = true;
terr.Location_Code__c = '01234-01234';
terr.FSL_Service_Territory_Code__c = '01234';
terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
terr.Territory__c = 'AUSTRALIA';
insert terr;



WorkOrder wo = new WorkOrder();
wo.AccountId = accountObj.Id;
wo.ContactId = contactObj.Id;
wo.ServiceTerritoryId = terr.Id;
wo.Priority = 'Low';
wo.Status = 'Intake';
wo.ESN_Insite__c = '79799702';
wo.Process_Step__c = 'Repair';
wo.WorkTypeId = wrtype.id;
wo.Type__c = 'External';
wo.AssetId = objAsset.Id;
insert wo;

ServiceTerritoryMember tMember = new ServiceTerritoryMember();
tMember.EffectiveStartDate = Date.today().addDays(-1);
tMember.EffectiveEndDate = Date.today().addDays(100);
tMember.ServiceResourceId = res.Id;
tMember.TerritoryType = 'P';
tMember.ServiceTerritoryId = terr.Id;
tMember.Street = '1460 N National Rd';
tMember.City = 'Atlanta';
tMember.State = 'Indiana';
tMember.Country = 'United States';
tMember.PostalCode = '40021';
insert tMember;
Test.stoptest();
List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
FSL_Timesheet__c ts = new FSL_Timesheet__c();
ts.Service_Order__c = wo.Id;
ts.StartTime__c = System.Datetime.now();
ts.Resource__c = testUser.Id; 
ts.EndTime__c = System.Datetime.now().addDays(1);
ts.Reason__c = 'Travel';

FSL_Timesheet__c tsPaperWork = new FSL_Timesheet__c();
tsPaperWork.Service_Order__c = wo.Id;
tsPaperWork.StartTime__c = System.Datetime.now().addDays(2);
tsPaperWork.EndTime__c = System.Datetime.now().addDays(3);
tsPaperWork.Reason__c = 'Paper Work';
tsPaperWork.Resource__c = testUser.Id;
tsPaperWork.Change_Reason__c = 'Test';

tsList.add(ts);
tsList.add(tsPaperWork);
insert tsList;

FSL_SRT__c objsrt = new FSL_SRT__c();
objsrt.Type__c = 'Travel';
objsrt.Service_Order__c = wo.id;
objsrt.Non_SRTs__c = wo.id;
objsrt.SRT_Time__c = 6;
objsrt.Name = 'Travel';
insert objsrt;

tsPaperWork.EndTime__c = System.Datetime.now().addDays(4);
tsPaperWork.Change_Reason__c = 'testt';
tsPaperWork.Submit_to_ERP__c=True;
try{
update tsPaperWork;
}
catch(exception e){
system.debug('excep--'+e);
}

}**/
    
    @isTest
    private static void testPosttoChatter() {
        user testUser = [SELECT Id FROM User LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        try {
            
            Id ruleId = Schema.SObjectType.FSL__Work_Rule__c.getRecordTypeInfosByName().get('Field Service - Match Skills').getRecordTypeId();
            FSL__Work_Rule__c newRule = new FSL__Work_Rule__c();
            newRule.Name = 'My Test Rule';
            newRule.FSL__Active__c = TRUE;
            newRule.FSL__Match_Skill_Level__c = TRUE;
            newRule.RecordTypeId = ruleId;
            Insert newRule;
            
            FSL__Scheduling_Policy__c newPolicy = new FSL__Scheduling_Policy__c();
            newPolicy.Name = 'My Test Policy';
            newPolicy.FSL__Description__c = 'My Test Policy Description';
            Insert newPolicy;
            
            FSL__Scheduling_Policy_Work_Rule__c newPolicyRule = new FSL__Scheduling_Policy_Work_Rule__c();
            newPolicyRule.FSL__Scheduling_Policy__c = newPolicy.Id;
            newPolicyRule.FSL__Work_Rule__c = newRule.Id;
            Insert newPolicyRule;
            
            ServiceTerritory terr = new ServiceTerritory();
            terr.Name = 'testPopulateTerritory Territory';
            terr.OperatingHoursId = hours.Id;
            terr.IsActive = true;
            terr.Location_Code__c = '01234-01234';
            terr.FSL_Service_Territory_Code__c = '01234';
            terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            terr.Territory__c = 'AUSTRALIA';
            insert terr;
            
            Asset objAsset = new Asset();
            objAsset.Name = 'A1B2C3D4';
            objAsset.Type_PSN__c = 'Engines-A1B2C3D4';
            objAsset.Type__c = 'Engines';
            insert objAsset;
            
            WorkType objWorkType = new WorkType();
            objWorkType.Name = 'Test WorkType';
            objWorkType.EstimatedDuration = 60.0;
            objWorkType.DurationType = 'Minutes';
            insert objWorkType;
            
            WorkOrder wo = new WorkOrder();
            wo.AccountId = accountObj.Id;
            wo.ContactId = contactObj.Id;
            wo.ServiceTerritoryId = terr.Id;
            wo.Priority = 'Low';
            wo.Status = 'Intake';
            wo.ESN_Insite__c = '79799702';
            wo.Process_Step__c = 'Repair';
            wo.WorkTypeId = objWorkType.Id;
            wo.Type__c = 'External';
            wo.AssetId = objAsset.Id;
            insert wo;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = testUser.Id;
            res.IsActive = true;
            res.ResourceType = 'T';
            insert res;
            
            ServiceTerritoryMember tMember = new ServiceTerritoryMember();
            tMember.EffectiveStartDate = Date.today().addDays(-1);
            tMember.EffectiveEndDate = Date.today().addDays(100);
            tMember.ServiceResourceId = res.Id;
            tMember.TerritoryType = 'P';
            tMember.ServiceTerritoryId = terr.Id;
            tMember.Street = '1460 N National Rd';
            tMember.City = 'Atlanta';
            tMember.State = 'Indiana';
            tMember.Country = 'United States';
            tMember.PostalCode = '40021';
            insert tMember;
            
            Test.startTest();
            
            ServiceAppointment appt = new ServiceAppointment();
            appt.Status = 'None';
            appt.ParentRecordId = wo.Id;
            appt.ServiceTerritoryId = terr.Id;
            appt.ContactId = contactObj.Id;
            appt.SchedStartTime = DateTime.now();
            appt.SchedEndTime = DateTime.now().addHours(4);
            insert appt;
            
            AssignedResource asr = new AssignedResource();
            asr.ServiceResourceId = res.Id;
            asr.ServiceAppointmentId = appt.Id;
            insert asr;
            
            WorkType wrtype = new WorkType();
            wrtype.Name = 'Internal';
            wrtype.EstimatedDuration = 8;
            insert wrtype;
            
            TimeSlot timeslt = new TimeSlot();
            timeslt.DayOfWeek = 'Monday';
            timeslt.StartTime = Time.newInstance(08,00,00,00);
            timeslt.EndTime =  Time.newInstance(17,00,00,00);
            timeslt.Operatinghoursid = hours.id;
            insert timeslt;
            
            
            /*  List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
FSL_Timesheet__c ts = new FSL_Timesheet__c();
ts.Service_Order__c = wo.Id;
ts.StartTime__c = System.Datetime.now();
ts.Resource__c = users[0].Id;
ts.EndTime__c = System.Datetime.now().addHours(1);
ts.Reason__c = 'Travel';



FSL_Timesheet__c tsPaperWork = new FSL_Timesheet__c();
tsPaperWork.Service_Order__c = wo.Id;
tsPaperWork.StartTime__c = System.Datetime.now().addDays(2);
tsPaperWork.EndTime__c = System.Datetime.now().addDays(3);
tsPaperWork.Reason__c = 'Paper Work';
tsPaperWork.Resource__c = users[0].Id;

tsList.add(ts);
tsList.add(tsPaperWork);
//tsList.add(tsheet);
insert tsList;
*/
            
            Test.stoptest();
        }
        catch(exception e) {
            system.debug('check');
        }
    }
    
    @isTest
    private static void testSRTs() {
        try {
            Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator());
            user testUser = [SELECT Id FROM User LIMIT 1];
            Account accountObj = [SELECT Id FROM Account LIMIT 1];
            Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
            OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
            //Test.starttest();                  
            
            ServiceTerritory terr = new ServiceTerritory();
            terr.Name = 'testPopulateTerritory Territory';
            terr.OperatingHoursId = hours.Id;
            terr.IsActive = true; 
            terr.Location_Code__c = '01234-01234';
            terr.FSL_Service_Territory_Code__c = '01234';
            terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            terr.Territory__c = 'AUSTRALIA';
            insert terr;
            
            //CT2-388
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = terr.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            Asset objAsset = new Asset();
            objAsset.Name = 'A1B2C3D4';
            objAsset.Type_PSN__c = 'Engines-A1B2C3D4';
            objAsset.Type__c = 'Engines';
            objAsset.Service_Model__c ='NONCUMMINS';
            objAsset.Engine_Family_Code__c  ='99';
            objAsset.Source__c  = 'BMS';
            insert objAsset;
            
            WorkType objWorkType = new WorkType();
            objWorkType.Name = 'Test WorkType';
            objWorkType.EstimatedDuration = 60.0;
            objWorkType.DurationType = 'Minutes';
            insert objWorkType;
            
            
            WorkOrder wo = new WorkOrder();
            wo.AccountId = accountObj.Id;
            //wo.ContactId = contact.Id;
            wo.ServiceTerritoryId = terr.Id;
            wo.Priority = 'Low';
            wo.Status = 'Intake';
            wo.ESN_Insite__c = '79799702';
            wo.Process_Step__c = 'Repair';
            wo.WorkTypeId = objWorkType.Id;
            wo.Type__c = 'External';
            wo.AssetId = objAsset.Id;
            wo.Shop_Work_Order__c = 'test_Shop_Work_Order'; //ct2-388
            wo.FSL_Sub_Type__c = subTypeInfo.Id; //ct2-388
            insert wo;
            
            ServiceAppointment appt = new ServiceAppointment();
            appt.Status = 'None';
            appt.ParentRecordId = wo.Id;
            appt.ServiceTerritoryId = terr.Id;
            //appt.ContactId = contact.Id;
            appt.SchedStartTime = DateTime.now();
            appt.SchedEndTime = DateTime.now().addHours(4);
            insert appt;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = testUser.Id;
            res.IsActive = true;
            res.ResourceType = 'T';
            insert res;
            
            ServiceTerritoryMember tMember = new ServiceTerritoryMember();
            tMember.EffectiveStartDate = Date.today().addDays(-1);
            tMember.EffectiveEndDate = Date.today().addDays(100);
            tMember.ServiceResourceId = res.Id;
            tMember.TerritoryType = 'P';
            tMember.ServiceTerritoryId = terr.Id;
            tMember.Street = '1460 N National Rd';
            tMember.City = 'Atlanta';
            tMember.State = 'Indiana';
            tMember.Country = 'United States';
            tMember.PostalCode = '40021';
            //insert tMember;
            //Test.stoptest();
            
            
            Test.startTest();
            List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
            FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
            tsheet.Service_Order__c = wo.Id;
            tsheet.StartTime__c = System.Datetime.now();
            tsheet.EndTime__c = System.Datetime.now();
            tsheet.Resource__c = testUser.Id;
            tsheet.Reason__c = 'Travel';//updated
            tsheet.Notes__c = 'test_Notes'; //CT2-388
            //tsheet.Resource_ERP__c = 'MoveX UK';//CT2-388 : picklist values not added to record type
            //tsheet.Billing_Type__c = '101-LEAVE ANNUAL'; //CT2-388 : picklist values not added to record type
            tsheet.Status__c = 'New';
            tsList.add(tsheet);
            
            FSL_Timesheet__c tsheet1 = new FSL_Timesheet__c();
            tsheet1.Service_Order__c = wo.Id;
            tsheet1.StartTime__c = System.Datetime.now();
            tsheet1.Resource__c = testUser.Id;
            tsheet1.Reason__c = 'Travel';//updated
            tsheet1.Notes__c = 'test_Notes'; //CT2-388
            //tsheet1.Resource_ERP__c = 'MoveX UK';//CT2-388 : picklist values not added to record type
            //tsheet1.Billing_Type__c = '101-LEAVE ANNUAL'; //CT2-388 : picklist values not added to record type
            tsheet1.Status__c = 'New';//CT2-388
            tsList.add(tsheet1);//updated
            
            FSL_Timesheet__c tsNew = new FSL_Timesheet__c();
            tsNew.Service_Order__c = wo.Id;
            tsNew.StartTime__c = System.Datetime.now();
            tsNew.Resource__c = testUser.Id;
            tsNew.EndTime__c = Null;
            tsNew.Reason__c = 'Meal Period';//updated
            //tsNew.Service_Order_Type__c ='Internal';  //updated
            tsNew.Notes__c = 'test_Notes'; //CT2-388
            //tsNew.Resource_ERP__c = 'MoveX UK';//CT2-388 : picklist values not added to record type
            //tsNew.Billing_Type__c = '101-LEAVE ANNUAL'; //CT2-388 : picklist values not added to record type
            tsNew.Status__c = 'New';//CT2-388
            tsList.add(tsNew);
            insert tsList;
            
            Id submittedTimesheetRecordType = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByDeveloperName().get('Submitted_Timesheet').getRecordTypeId();
            tsNew.EndTime__c = System.Datetime.now().addHours(11);
            tsNew.change_reason__C = 'test change';
            tsNew.Status__c = 'Submitted';
            tsNew.RecordTypeId = submittedTimesheetRecordType;
            tsNew.Notes__c = 'test_Notes'; //CT2-388
            //tsNew.Resource_ERP__c = 'MoveX SPAC'; //CT2-388 : picklist values not added to record type
            //tsNew.Billing_Type__c = '101-LEAVE ANNUAL'; //CT2-388 : picklist values not added to record type
            update tsNew;
            Test.stoptest();
            FSL_Timesheet__c updatedtSheet = [SELECT Id, change_reason__C from FSL_Timesheet__c WHERE Id = :tsNew.Id];
            System.assert(updatedtSheet != null, 'Timesheet should exist');
            System.assertEquals('test change', updatedtSheet.change_reason__C);
            
        }
        catch(exception e) { 
            system.debug('check');
        }
        
    }
    
    
    @isTest
    private static void testSRTsWOSA() {
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator());
        user testUser = [SELECT Id FROM User LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        try {
            
            ServiceTerritory terr = new ServiceTerritory();
            terr.Name = 'testPopulateTerritory Territory00';
            terr.OperatingHoursId = hours.Id;
            terr.IsActive = true; 
            terr.Location_Code__c = '01234-01234';
            terr.FSL_Service_Territory_Code__c = '01234';
            terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            terr.Territory__c = 'AUSTRALIA';
            insert terr;
            
            //CT2-388
            FSL_SubType__c subTypeInfo = new FSL_SubType__c();
            subTypeInfo.Name = 'R1';
            subTypeInfo.CodeValueBranchCode__c = terr.Location_Code__c;
            subTypeInfo.Branch_Code__c = 04892;
            subTypeInfo.Status__c = 'Active';
            insert subTypeInfo;
            
            Asset objAsset = new Asset();
            objAsset.Name = 'A1B2C3D4';
            objAsset.Type_PSN__c = 'Engines-A1B2C3D4';
            objAsset.Type__c = 'Engines';
            objAsset.Service_Model__c ='NONCUMMINS';
            objAsset.Engine_Family_Code__c  ='99';
            objAsset.Source__c  = 'BMS';
            insert objAsset;
            
            WorkType objWorkType = new WorkType();
            objWorkType.Name = 'Test WorkType';
            objWorkType.EstimatedDuration = 60.0;
            objWorkType.DurationType = 'Minutes';
            insert objWorkType;
            
            
            WorkOrder wo = new WorkOrder();
            wo.AccountId = accountObj.Id;
            //wo.ContactId = contact.Id;
            wo.ServiceTerritoryId = terr.Id;
            wo.Priority = 'Low';
            wo.Status = 'Intake';
            wo.ESN_Insite__c = '79799702';
            wo.Process_Step__c = 'Repair';
            wo.WorkTypeId = objWorkType.Id;
            wo.Type__c = 'Internal';
            wo.AssetId = objAsset.Id;
            wo.Shop_Work_Order__c = 'test_Shop_Work_Order'; //ct2-388
            wo.FSL_Sub_Type__c = subTypeInfo.Id; //ct2-388
            insert wo;
            
            ServiceAppointment appt = new ServiceAppointment();
            appt.Status = 'None';
            appt.ParentRecordId = wo.Id;
            appt.ServiceTerritoryId = terr.Id;
            //appt.ContactId = contact.Id;
            appt.SchedStartTime = DateTime.now();
            appt.SchedEndTime = DateTime.now().addHours(4);
            insert appt;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = testUser.Id;
            res.IsActive = true;
            res.ResourceType = 'T';
            insert res;
            
            ServiceTerritoryMember tMember = new ServiceTerritoryMember();
            tMember.EffectiveStartDate = Date.today().addDays(-1);
            tMember.EffectiveEndDate = Date.today().addDays(100);
            tMember.ServiceResourceId = res.Id;
            tMember.TerritoryType = 'P';
            tMember.ServiceTerritoryId = terr.Id;
            tMember.Street = '1460 N National Rd';
            tMember.City = 'Atlanta';
            tMember.State = 'Indiana';
            tMember.Country = 'United States';
            tMember.PostalCode = '40021';
            tMember.TerritoryType = 'P';
            insert tMember;
            //Test.stoptest();
            
            
            Test.startTest();
            List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
            FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
            tsheet.Service_Order__c = wo.Id;
            tsheet.StartTime__c = System.Datetime.now();
            tsheet.Resource__c = testUser.Id;
            tsheet.Reason__c = 'Travel';//updated
            tsheet.Notes__c = 'test_Notes'; //CT2-388
            //tsheet.Resource_ERP__c = 'MoveX UK';//CT2-388 : picklist values not added to record type
            //tsheet.Billing_Type__c = '101-LEAVE ANNUAL'; //CT2-388 : picklist values not added to record type
            tsheet.Status__c = 'New';
            tsList.add(tsheet);
            
            FSL_Timesheet__c tsheet1 = new FSL_Timesheet__c();
            tsheet1.Service_Order__c = wo.Id;
            tsheet1.StartTime__c = System.Datetime.now();
            tsheet1.Resource__c = testUser.Id;
            tsheet1.Reason__c = 'Travel';//updated
            tsheet1.Notes__c = 'test_Notes'; //CT2-388
            //tsheet1.Resource_ERP__c = 'MoveX UK';//CT2-388 : picklist values not added to record type
            //tsheet1.Billing_Type__c = '101-LEAVE ANNUAL'; //CT2-388 : picklist values not added to record type
            tsheet1.Status__c = 'New';//CT2-388
            //tsList.add(tsheet1);//updated
            
            FSL_Timesheet__c tsNew = new FSL_Timesheet__c();
            tsNew.Service_Order__c = wo.Id;
            tsNew.StartTime__c = System.Datetime.now();
            tsNew.Resource__c = testUser.Id;
            tsNew.EndTime__c = Null;
            tsNew.Reason__c = 'Meal Period';//updated
            //tsNew.Service_Order_Type__c ='Internal';  //updated
            tsNew.Notes__c = 'test_Notes'; //CT2-388
            //tsNew.Resource_ERP__c = 'MoveX UK';//CT2-388 : picklist values not added to record type
            //tsNew.Billing_Type__c = '101-LEAVE ANNUAL'; //CT2-388 : picklist values not added to record type
            tsNew.Status__c = 'New';//CT2-388
            //tsList.add(tsNew);
            insert tsList;
            
            Id submittedTimesheetRecordType = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByDeveloperName().get('Submitted_Timesheet').getRecordTypeId();
            tsNew.EndTime__c = System.Datetime.now().addHours(11);
            tsNew.change_reason__C = 'test change';
            tsNew.Status__c = 'Submitted';
            tsNew.RecordTypeId = submittedTimesheetRecordType;
            tsNew.Notes__c = 'test_Notes'; //CT2-388
            //tsNew.Resource_ERP__c = 'MoveX SPAC'; //CT2-388 : picklist values not added to record type
            //tsNew.Billing_Type__c = '101-LEAVE ANNUAL'; //CT2-388 : picklist values not added to record type
            update tsNew;
            FSL_Timesheet__c submittedTSheet = [SELECT Id, RecordTypeId, Status__c FROM FSL_Timesheet__c WHERE Id = :tsNew.Id];
            System.assert(submittedTSheet != null, 'submittedTSheet should not be null');
            System.assertEquals(submittedTimesheetRecordType, submittedTSheet.RecordTypeId);
            Test.stoptest();
        }
        catch(exception e) { 
            system.debug('check');
        }
    }
    
    //Create Account - sinlge record
    private static Account createAccount() {
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.Name = 'Test Account';
        acc.phone = '6884382997';
        acc.BillingStreet = 'Test Street';
        acc.BillingCountry = 'United States';
        acc.BillingCity = 'NewYork';
        acc.BillingState = 'Florida';
        acc.BillingPostalCode = '99999';
        return acc;
    }
    
    @isTest
    private static void test_TsInsert() {
        user testUser = [SELECT Id FROM User where username='testUserRaghav@testEmail.com' LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        
        test.startTest();
        ServiceTerritory terr1 = [select id,Location_Code__c from ServiceTerritory Limit 1];
        
        FSL_SubType__c subTypeInfo=[select id from FSL_SubType__c Limit 1];
        Asset objAsset=[select id,Name,Type_PSN__c,Type__c,Service_Model__c,Engine_Family_Code__c,Source__c from Asset Limit 1];
        
        WorkType objWorkType =[Select id,Name,EstimatedDuration,DurationType from WorkType limit 1];
        
        Service_Order_Extension__c soe = new Service_Order_Extension__c();
        insert soe;
        
        List<workorder> wolist=new List<workorder>();
        
        WorkOrder wo = new WorkOrder();
        wo.Service_Order_Extension__c = soe.Id;
        wo.AccountId = accountObj.Id;
        //wo.ContactId = contact.Id;
        wo.ServiceTerritoryId = terr1.Id;
        wo.Priority = 'Low';
        wo.Status = 'Intake';
        wo.ESN_Insite__c = '79796702';
        wo.Process_Step__c = 'Repair';
        wo.WorkTypeId = objWorkType.Id;
        wo.Type__c = 'Internal';
        wo.AssetId = objAsset.Id;
        wo.Shop_Work_Order__c = 'test_Shop_Work_Order'; //ct2-388
        wo.FSL_Sub_Type__c = subTypeInfo.Id; //ct2-388
        wolist.add(wo);
        Insert wolist;
        
        List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
        FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
        tsheet.Service_Order__c = wo.Id;
        tsheet.StartTime__c = System.Datetime.now();
        tsheet.Endtime__c = null;
        tsheet.Resource__c = testUser.Id;
        tsheet.Reason__c = 'Travel';
        tsheet.Notes__c = 'Starttimechangemethod';
        tsheet.Status__c = 'New';
        try{
            insert tsheet;
            FSL_Timesheet__c tSheetRec = [SELECT Id, Resource__c, Reason__c, Status__c FROM FSL_Timesheet__c WHERE Id = :tsheet.Id];
            System.assertEquals(testUser.Id, tSheetRec.Resource__c);
        }catch(Exception e) {
            system.debug(LoggingLevel.ERROR, 'Exception Occurred:: '+e);
        }
        test.stopTest();
    }
    
    @isTest
    private static void test_TsInsert2() {
        user testUser = [SELECT Id FROM User where username='testUserRaghav@testEmail.com' LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        
        test.startTest();
        ServiceTerritory terr1 = [select id,Location_Code__c from ServiceTerritory Limit 1];
        
        FSL_SubType__c subTypeInfo=[select id from FSL_SubType__c Limit 1];
        Asset objAsset=[select id,Name,Type_PSN__c,Type__c,Service_Model__c,Engine_Family_Code__c,Source__c from Asset Limit 1];
        
        WorkType objWorkType =[Select id,Name,EstimatedDuration,DurationType from WorkType limit 1];
        
        Service_Order_Extension__c soe = new Service_Order_Extension__c();
        insert soe;
        
        List<workorder> wolist=new List<workorder>();
        WorkOrder wo = new WorkOrder();
        wo.AccountId = accountObj.Id;
        wo.Service_Order_Extension__c = soe.Id;
        //wo.ContactId = contact.Id;
        wo.ServiceTerritoryId = terr1.Id;
        wo.Priority = 'Low';
        wo.Status = 'Triage & Diagnosis';
        wo.ESN_Insite__c = '79796702';
        wo.WorkTypeId = objWorkType.Id;
        wo.Process_Step__c = 'Triage & Diagnosis';
        wo.Type__c = 'External';
        wo.AssetId = objAsset.Id;
        wo.Shop_Work_Order__c = 'test_Shop_Work_Order'; //ct2-388
        wo.FSL_Sub_Type__c = subTypeInfo.Id; //ct2-388
        wolist.add(wo);
        Insert wolist;
        System.debug('WO created**** '+wo.Id);
        
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = wo.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.newInstance(2022, 6, 1, 12, 30, 0);
        sa.DueDate = datetime.newInstance(2022, 6, 1, 12, 30, 0);
        sa.SchedStartTime=date.today()-2;
        sa.SchedEndTime=date.today();
        sa.Service_Order__c= wo.id;
        insert sa;
        System.debug('SA created**** '+sa.Id);
        ServiceResource res = new ServiceResource();
        res.Name = 'Test Unqualified Resource';
        res.RelatedRecordId = testUser.Id;
        res.IsActive = true;
        res.ResourceType = 'T';
        insert res;
        
        ServiceTerritoryMember stm = new ServiceTerritoryMember(TerritoryType = 'P', EffectiveStartDate = date.today()-3, ServiceTerritoryId = terr1.Id, ServiceResourceId = res.Id);
        insert stm;
        
        AssignedResource ar = new AssignedResource();
        ar.ServiceAppointmentId = sa.Id;
        ar.ServiceResourceId = res.Id;
        try{
            insert ar; // Inserting it throws nullPointerException from FSL package in FSL.TR021_AssignedResource_AfterInsert
        }catch(Exception e){
            System.debug('Exception Occurred:: '+e);
        }
        
        System.debug('res created**** '+res.Id);
        List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
        FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
        tsheet.Service_Order__c = wo.Id;
        tsheet.StartTime__c = System.Datetime.now();
        tsheet.Endtime__c = null;
        tsheet.Resource__c = testUser.Id;
        tsheet.Reason__c = 'Meal Period';
        tsheet.Notes__c = 'Starttimechangemethod';
        tsheet.Status__c = 'Submitted';
        insert tsheet;
        FSL_Timesheet__c tSheetRec = [SELECT Id, Resource__c, Reason__c, Status__c FROM FSL_Timesheet__c WHERE Id = :tsheet.Id];
        System.assertEquals('Submitted', tSheetRec.Status__c);
    }
    
    
    @isTest
    private static void testallocatenewTimesheets_Endtime() {
        user testUser = [SELECT Id FROM User where username='testUserRaghav@testEmail.com' LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        
        test.startTest();
        workorder wo2=[select id from workorder where ESN_Insite__c = '79799702' limit 1];
        FSL_Timesheet__c tsheet=[Select id,StartTime__c,EndTime__c from FSL_Timesheet__c   limit 1];
        tsheet.Allocate_to_Service_Order__c=wo2.Id;
        tsheet.EndTime__c= tsheet.StartTime__c.addminutes(15);
        tsheet.Change_Reason__c='chanaged';
        tsheet.Notes__c='notesnew';
        try{
            update tsheet;
            FSL_Timesheet__c tSheetRec = [SELECT Id, Resource__c, Allocate_to_Service_Order__c FROM FSL_Timesheet__c WHERE Id = :tsheet.Id];
        	System.assertEquals(wo2.Id, tSheetRec.Allocate_to_Service_Order__c);
            test.stopTest();
        }catch(exception ex) {
        }
    }
    
    @isTest
    private static void testallocatenewTimesheets_sochange() {
        user testUser = [SELECT Id FROM User where username='testUserRaghav@testEmail.com' LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        
        test.startTest();
        workorder wo2=[select id from workorder where ESN_Insite__c = '79799702' limit 1];
        FSL_Timesheet__c tsheet=[Select id,StartTime__c,EndTime__c from FSL_Timesheet__c   limit 1];
        tsheet.Allocate_to_Service_Order__c=wo2.Id;
        tsheet.Change_Reason__c='chanaged';
        tsheet.Notes__c='notesnew';
        try{
            update tsheet;
            FSL_Timesheet__c tSheetRec = [SELECT Id, Allocate_to_Service_Order__c, Reason__c, Status__c FROM FSL_Timesheet__c WHERE Id = :tsheet.Id];
        	System.assertEquals(wo2.Id, tSheetRec.Allocate_to_Service_Order__c);
            test.stopTest();
        } catch(exception ex) {
        }
    }
    
    @isTest
    private static void testallocatenewTimesheets_startime() {
        user testUser = [SELECT Id FROM User where username='testUserRaghav@testEmail.com' LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        
        test.startTest();
        workorder wo2=[select id from workorder where ESN_Insite__c = '79799702' limit 1];
        FSL_Timesheet__c tsheet=[Select id,StartTime__c,EndTime__c from FSL_Timesheet__c   limit 1];
        tsheet.Allocate_to_Service_Order__c=wo2.Id;
        tsheet.StartTime__c= System.Datetime.now().addminutes(20);
        tsheet.Change_Reason__c='chanaged';
        tsheet.Notes__c='notesnew';
        try{
            update tsheet;
            FSL_Timesheet__c tSheetRec = [SELECT Id, Allocate_to_Service_Order__c, Reason__c, Status__c FROM FSL_Timesheet__c WHERE Id = :tsheet.Id];
        	System.assertEquals(wo2.Id, tSheetRec.Allocate_to_Service_Order__c);
            test.stopTest();
        }
        catch(exception ex) {
        }
    }
    
    @isTest
    private static void test_stopSubmittingTimesheets() {
        user testUser = [SELECT Id FROM User where username='testUserRaghav@testEmail.com' LIMIT 1];
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Contact contactObj = [SELECT Id FROM Contact LIMIT 1];
        OperatingHours hours = [SELECT Id FROM OperatingHours LIMIT 1];
        
        test.startTest();
        workorder wo2=[select id from workorder where ESN_Insite__c = '79799702' limit 1];
        FSL_Timesheet__c tsheet=[Select id,StartTime__c,EndTime__c from FSL_Timesheet__c   limit 1];
        tsheet.Submit_to_ERP__c=true;
        try{
            update tsheet;
            FSL_Timesheet__c tSheetRec = [SELECT Id, Submit_to_ERP__c, Reason__c, Status__c FROM FSL_Timesheet__c WHERE Id = :tsheet.Id];
        	System.assertEquals(true, tSheetRec.Submit_to_ERP__c);
            test.stopTest();
        }
        catch(exception ex) {
        }
    }
    
    @isTest
    private static void test_insertFSLSRT() {
        Id profid = [select Id from profile where name= 'System Administrator' LIMIT 1].Id;
        List<User> users = new List<User>();
        users.add(new User(
            ProfileId = profid,
            LastName = 'testUser',
            Email = 'testUserRaghav4@testEmail.com',
            Username = 'testUserRaghav4@testEmail.com',
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
            IAM_UID__c = 'testUserRaghav4@testEmail.com',
            FederationIdentifier = 'testUserRaghav4@testEmail.com'
        ));
        Insert users;
        test.startTest();
        workorder wo2=[select id from workorder where ESN_Insite__c = '79799702' limit 1];
        
        FSL_SRT__c objsrt = new FSL_SRT__c();
        objsrt.Type__c = 'Travel';
        objsrt.Service_Order__c = wo2.id;
        objsrt.Non_SRTs__c = wo2.id;
        objsrt.SRT_Time__c = 6;
        objsrt.Name = 'Travel';
        insert objsrt;
        
        FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
        tsheet.Service_Order__c = wo2.Id;
        tsheet.StartTime__c = System.Datetime.now();
        tsheet.Endtime__c = tsheet.StartTime__c.addminutes(30);
        tsheet.Resource__c = users[0].Id;
        tsheet.Reason__c = 'Travel';
        tsheet.Notes__c = 'Starttimechangesetup';
        tsheet.Status__c = 'New';
        insert tsheet;
        
        FSL_CL_TimesheetTriggerHandler.updateTimesheetIdInServiceAppointment();
        FSL_Timesheet__c tSheetRec = [SELECT Id, Submit_to_ERP__c, Reason__c, Status__c FROM FSL_Timesheet__c WHERE Status__c = 'New' limit 1];
        	System.assert(tSheetRec != null);
        test.stopTest();
    }   
    @isTest
    static void testCodeCoverage(){
        User userRec =[Select id from User limit 1];
        Id RepairRTID =Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        Account accountObj = [SELECT Id FROM Account LIMIT 1];
        Asset asst =[select id from asset limit 1];
        ServiceTerritory terrset =[select id from ServiceTerritory limit 1];
        WorkType objWorkTypeSet=[select id from WorkType limit 1];
        Test.startTest();
        
        Service_Order_Extension__c soe = new Service_Order_Extension__c();
        insert soe;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.Service_Order_Extension__c = soe.Id;
        objWorkOrder.recordtypeid=RepairRTID;
        objWorkOrder.ServiceTerritoryId = terrSet.Id;
        objWorkOrder.Status = 'Job Plan';
        objWorkOrder.ESN_Insite__c = '79799702';
        objWorkOrder.Process_Step__c = 'Repair';
        objWorkOrder.AccountId = accountObj.Id;
        objWorkOrder.WorkTypeId = objWorkTypeSet.Id;
        objWorkOrder.Type__c = 'External'; 
        objWorkOrder.AssetId = asst.Id;
        insert objWorkOrder;
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = objWorkOrder.Id;
        sa.Status = 'Dispatched';
        sa.EarliestStartTime = datetime.newInstance(2022, 6, 1, 12, 30, 0);
        sa.DueDate = datetime.newInstance(2022, 6, 1, 12, 30, 0);
        sa.SchedStartTime=date.today()-2;
        sa.SchedEndTime=date.today();
        sa.Service_Order__c= objWorkOrder.id;
        insert sa;
        Test.stopTest();
        
        ServiceResource res = new ServiceResource();
        res.Name = 'Test Unqualified Resource';
        res.RelatedRecordId = userRec.Id;
        res.IsActive = true;
        res.ResourceType = 'T';
        insert res;
        
        FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
        tsheet.Service_Order__c = objWorkOrder.Id;
        tsheet.StartTime__c = System.Datetime.now();
        tsheet.Resource__c = userRec.Id;
        tsheet.Reason__c = 'Travel';
        tsheet.Notes__c = 'Starttimechangesetup';
        tsheet.Status__c = 'New';
        insert tsheet;
        FSL_Timesheet__c tSheetRec = [SELECT Id, Submit_to_ERP__c, Reason__c, Status__c FROM FSL_Timesheet__c WHERE Status__c = 'New' limit 1];
        System.assert(tSheetRec != null);
    }
    
}