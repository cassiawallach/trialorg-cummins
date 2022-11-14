//Added by Krishna for CodeCoverage
@isTest
public class FSL_GanttCustomActionsController_Test {
     @testSetup static void setup() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com'
                          , FederationIdentifier ='zxABC');
        insert u;
       /* Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '102686';
        acc.Name = 'Test Acc FTM';
        acc.Cmi_account_status__c = 'Active';
        acc.Type = 'Customer';
        acc.FSL_Source_ERP__c = 'BMS';
        insert acc;*/
        
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
        
        /*Schema.Location loc = new Schema.Location();
        loc.Name = 'TestNew';
        loc.FSL_Account__c = acc.Id;
        insert loc;*/
         
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
            //addressObj.CreatedById = u.id;
            addr.ParentId = loc.Id;
			addr.Account__c = acc.Id;
            insert addr;
        
        
        Id SRTDataId = [Select Id From RecordType Where SobjectType = 'CSS_Make_Model_Access__c' AND DeveloperName = 'SRTData'].Id;
        CSS_Make_Model_Access__c makemodel = new CSS_Make_Model_Access__c();
        makemodel.Make__c = 'MAKE';
        makemodel.Model__c = 'MODEL';
        makemodel.EngineFamilyCode__c = 'TEST';
        makemodel.RecordTypeId = SRTDataId;
        insert makemodel;
        
        Asset asset1 = new Asset();
        asset1.Name = '342819';
        asset1.Type_PSN__c = 'External-78';
        asset1.Type__c = 'Engines';
        asset1.AccountId = acc.Id;
        //asset1.FSL_Site__c = addr.Id;
        asset1.Engine_Family_Code__c = 'TEST';
        asset1.Make_Model__c = makemodel.Id;
        asset1.Application__c = '130 - AUTOMOTIVE';
        insert asset1;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory In Shop OR Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '12345-12345';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        WorkType workType = new WorkType();
        workType.Name = 'Test WorkType FTM';
        workType.EstimatedDuration = 60.0;
        workType.DurationType = 'Minutes';
        insert workType;
        
        FSL_SubType__c st = new FSL_SubType__c();
        st.Name ='TestSubTypeFTM';
        insert st;
        
        FSL_SMN_DTC__c smn = new FSL_SMN_DTC__c();
        smn.name = 'TEST SMN';
        smn.FaultTypeFC__c = 'Yes';
        insert smn;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = acc.Id;
        objWorkOrder.WorkTypeId = workType.Id;
        objWorkOrder.FSL_Sub_Type__c = st.id;
        objWorkOrder.AssetId = asset1.Id;
        objWorkOrder.Shop_Work_Order__c='49440';
        //objWorkOrder.Repair_Site_Address__c = addr.Id;
        objWorkOrder.Repair_Location__c = 'Mobile';
        objWorkOrder.FSL_SMN__c = smn.Id;
        insert objWorkOrder;
        
        List<ServiceResource> srList = new List<ServiceResource>();
        ServiceResource sr = new ServiceResource();
        sr.RelatedRecordId = UserInfo.getUserId();
        sr.Is_a_Tech__c = true;
        sr.name = 'Test Resource';
        srList.add(sr);
        ServiceResource sr1 = new ServiceResource();
        sr1.RelatedRecordId = u.Id;
        sr1.Is_a_Tech__c = true;
        sr1.name = 'Test Resource 1';
        srList.add(sr1);
        insert srList;
        
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = objWorkOrder.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa.SchedStartTime=datetime.now()+3;
        sa.SchedEndTime=datetime.now()+4;
        sa.Service_Order__c= objWorkOrder.id;
        sa.Is_a_Tech_Appointment__c = true;
        sa.Assigned_ServiceResource__c = sr.Id;
        insert sa;
        
        serviceappointment sa1= new serviceappointment();
        sa1.parentrecordId = objWorkOrder.Id;
        sa1.Status = 'None';
        sa1.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa1.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa1.SchedStartTime=sa.SchedStartTime;
        sa1.SchedEndTime=sa.SchedEndTime;
        sa1.Service_Order__c= objWorkOrder.id;
        sa1.Is_a_Tech_Appointment__c = true;
        sa1.FSL_Parent_Crew_SA__c = sa.Id;
        sa1.Assigned_ServiceResource__c = sr1.Id;
        insert sa1;
    }
    public testMethod static void ganttNegativeTest(){
        serviceappointment sa = [SELECT Id FROM serviceappointment WHERE FSL_Parent_Crew_SA__c = NULL LIMIT 1 ];
        PageReference testPage = Page.FSL_GanttCustomActionVF; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', sa.Id);
        ApexPages.CurrentPage().getParameters().put('id', sa.Id);
        FSL_GanttCustomActionsController ganttCustom = new FSL_GanttCustomActionsController();
        ganttCustom.saveAppointment();
    }
    public testMethod static void ganttPostiveTest(){
        serviceappointment sa = [SELECT Id FROM serviceappointment WHERE FSL_Parent_Crew_SA__c != NULL LIMIT 1 ];
        PageReference testPage = Page.FSL_GanttCustomActionVF; 
        Test.setCurrentPage(testPage);
        testPage.getParameters().put('Id', sa.Id);
        ApexPages.CurrentPage().getParameters().put('id', sa.Id);
        FSL_GanttCustomActionsController ganttCustom = new FSL_GanttCustomActionsController();
        ganttCustom.saveAppointment();
        FSL_GanttCustomActionsController.calcualteDurationHours(system.now(),system.now());
    }

}