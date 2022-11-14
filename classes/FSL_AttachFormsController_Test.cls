@isTest
public class FSL_AttachFormsController_Test{
    
    @testSetup
    public static void setupData(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com'
                          , FederationIdentifier ='zxABC');
        insert u;
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
        asset1.FSL_Site__c = addr.Id;
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
        objWorkOrder.Repair_Site_Address__c = addr.Id;
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
        
        List<serviceappointment> saList = new List<serviceappointment>();
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
        saList.add(sa);
        
        serviceappointment sa1= new serviceappointment();
        sa1.parentrecordId = objWorkOrder.Id;
        sa1.Status = 'None';
        sa1.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa1.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa1.SchedStartTime=sa.SchedStartTime;
        sa1.SchedEndTime=sa.SchedEndTime;
        sa1.Service_Order__c= objWorkOrder.id;
        sa1.Is_a_Tech_Appointment__c = true;
        sa1.Assigned_ServiceResource__c = sr1.Id;
        saList.add(sa1);
        insert saList;
        Test.startTest();
        sa.Status = 'Scheduled';
        sa1.status = 'Scheduled';
        update saList;
        sa.status = 'Dispatched';
        sa1.status = 'Dispatched';
        update saList;
        Test.stopTest();
    }
    
    @isTest
    public static void test_createForm_NoMatch(){
                
        List<WorkOrder> wo = [Select id From WorkOrder Limit 1];
        Test.startTest();
        try{
            FSL_AttachFormsController.createForm_apex(wo[0].id);
        } catch(Exception e){
            System.assertEquals(Label.FSL_AttachForm_NoMatch, e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    public static void test_createForm_ORCondition(){
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template OR';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        List<FSL_SubType__c> subType = [Select id From FSL_SubType__c Where Name = 'TestSubTypeFTM'];
        List<WorkType> wt = [Select Id From WorkType Where Name = 'Test WorkType FTM'];
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'OR';
        ftm.FSL_Sub_Type__c = subType[0].Id;
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Work_Type__c = wt[0].Id;
        ftm.One_Form_Per_Service_Order__c = true;
        ftm.Active__c = true;
        insert ftm;
        
        List<WorkOrder> wo = [Select id From WorkOrder Where FSL_Sub_Type__c = :subType[0].Id];
        Test.startTest();
            FSL_AttachFormsController.createForm_apex(wo[0].id);
        Test.stopTest();
        List<disco__Form__c> forms = [Select id,disco__Form_Template_Name__c From disco__Form__c Where Service_Order__c = :wo[0].id];
        System.assertEquals('Test Template OR', forms[0].disco__Form_Template_Name__c);        
    }
    
    @isTest
    public static void test_createForm_ANDCondition(){
        disco__Form_Template__c formTemplate = new disco__Form_Template__c();
        formTemplate.name = 'Test Template AND';
        formTemplate.FSL_Approval_Status__c = 'Approved';
        formTemplate.disco__Status__c = 'In Use';
        insert formTemplate;
        
        List<WorkOrder> wo = [Select id,ServiceTerritoryId,WorkTypeId,FSL_Sub_Type__c,AccountId,FSL_SMN__c 
                              From WorkOrder Limit 1];
        List<Schema.Address> addr= [Select id From Address Limit 1];
        List<Asset> asset = [Select Id From Asset Limit 1];
        List<CSS_Make_Model_Access__c> makemodel = [Select id From CSS_Make_Model_Access__c Limit 1];
        FSL_Form_Template_Matrix__c ftm = new FSL_Form_Template_Matrix__c();
        ftm.FSL_Query_Operator__c = 'AND';
        ftm.FSL_Form_Template__c = formTemplate.Id;
        ftm.FSL_Sub_Type__c = wo[0].FSL_Sub_Type__c;
        ftm.FSL_Work_Type__c = wo[0].WorkTypeId;
        ftm.Repair_Site_Number__c = addr[0].Id;
        ftm.Account__c = wo[0].AccountId;
        ftm.Service_Territory__c = wo[0].ServiceTerritoryId;
        ftm.SMN__c = wo[0].FSL_SMN__c;
        ftm.Application__c = '130 - AUTOMOTIVE';
        ftm.Make_Model__c = makemodel[0].id;
        ftm.Asset__c = asset[0].id;
        ftm.One_Form_Dispatched_ServiceAppointment__c = true;
        ftm.Engine_Family_Code__c = 'TEST';
        ftm.Active__c = true;
        insert ftm;
        
        Test.startTest();
            FSL_AttachFormsController.createForm_apex(wo[0].id);
        Test.stopTest();
        List<disco__Form__c> forms = [Select id,disco__Form_Template_Name__c From disco__Form__c Where Service_Order__c = :wo[0].id];
        System.assertEquals('Test Template AND', forms[0].disco__Form_Template_Name__c); 
    }
    
}