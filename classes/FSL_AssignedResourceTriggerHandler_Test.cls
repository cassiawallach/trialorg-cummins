@isTest
public class FSL_AssignedResourceTriggerHandler_Test {
	
    @isTest
    public static void test_updateSATechandBay(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com'
                          , FederationIdentifier ='zxABC');
        insert u;
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accRecId;
        acc.FSL_ERP_Customer_Code__c = '102686';
        acc.Name = 'Test Acc FTM';
        acc.Cmi_account_status__c = 'Active';
        acc.Type = 'Customer';
        acc.FSL_Source_ERP__c = 'BMS';
        insert acc;
        
        Schema.Location loc = new Schema.Location();
        loc.Name = 'TestNew';
        loc.FSL_Account__c = acc.Id;
        insert loc;
        
        Schema.Address addr = new Schema.Address();
        addr.parentId = loc.id;
        addr.FSL_Site_Name__c = 'TestNew';
        addr.FSL_Site_ID__c = '1';
        addr.street = '101, Block B, 123 Street';
        addr.City = 'Brisbane';
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
        
        ServiceResource sr = new ServiceResource();
        sr.RelatedRecordId = u.Id;
        sr.Is_a_Tech__c = true;
        sr.name = 'Test Resource';
        sr.IsActive = true;
        insert sr;
        
        ServiceTerritoryMember stm = new ServiceTerritoryMember();
        stm.ServiceResourceId = sr.Id;
        stm.ServiceTerritoryId = objServiceTerritory.Id;
        stm.EffectiveStartDate = datetime.newInstance(2018, 7, 22, 12, 30, 0);
        stm.Street = '123 Street';
        stm.State = 'New York';
        insert stm;
        
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = objWorkOrder.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa.SchedStartTime=datetime.now()+3;
        sa.SchedEndTime=datetime.now()+4;
        sa.Service_Order__c= objWorkOrder.id;
        sa.Is_a_Tech_Appointment__c = true;
        insert sa;
        
        AssignedResource asr = new AssignedResource();
        asr.ServiceResourceId = sr.Id;
        asr.ServiceAppointmentId = sa.Id;
        insert asr;
    }
    
   
}