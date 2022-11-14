@isTest
public class FSLAssignedResourceAsynchronousCall_Test {
    @isTest
    public static void test_updateSATechandBay(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User u = new User(Alias = 'standt', Email='standardus@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='standardu@testorg.com'
                          , FederationIdentifier ='zxABC');
        insert u;
        /*Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        Account acc = new Account();
        acc.RecordTypeId = accGCRecId ;
        acc.FSL_ERP_Customer_Code__c = '102686';
        acc.Name = 'Test Acc FTM';
       // acc.Cmi_account_status__c = 'Active';
        acc.Type = 'Customer';
        acc.FSL_Source_ERP__c = 'BMS';
        insert acc;
                
        Account acct = new Account(); 
        acct.RecordTypeId = accGCRecId;
        acct.Name = 'Test GC';
        insert acct;
        
        Schema.Location loc = new Schema.Location();
        loc.Name = 'TestNew';
        loc.FSL_Account__c = acc.Id;
        insert loc;
        
        Schema.Location locationObj = new Schema.Location();
        locationObj.Name = 'Test cross ref';
        locationObj.FSL_Account__c = acct.Id;
        locationObj.FSL_Contact_ID__c = '10';
        insert locationObj;
                
        Schema.Address addressObj = new Schema.Address();
        addressObj.Street = '345 Dr';
        addressObj.Country = 'Australia';
        addressObj.State = 'South Australia';
        addressObj.PostalCode = '00123';
        addressObj.City = 'Melbourne';
        addressObj.Geolocation__Latitude__s = 87.00;
        addressObj.Geolocation__Longitude__s = 170.00;
        addressObj.FSL_Site_ID__c = '39';
        addressObj.FSL_Tax_District__c ='';
        addressObj.ParentId = locationObj.Id;
        insert addressObj;*/
        
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
        asset1.Customer_Name__c = 'New Customer';
        asset1.Warranty_Start_Date__c = Date.today() - 100;
        asset1.FSL_Site__c = addr.Id;
        Insert asset1;
        
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
        sr.ResourceType = 'T';
        insert sr;
        
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
        
        serviceappointment sa= new serviceappointment();
        sa.parentrecordId = objWorkOrder.Id;
        sa.Status = 'None';
        sa.EarliestStartTime = datetime.newInstance(2019, 7, 22, 12, 30, 0);
        sa.DueDate = datetime.newInstance(2019, 7, 29, 12, 30, 0);
        sa.SchedStartTime=datetime.now()+1;
        sa.SchedEndTime=datetime.now()+4;
        sa.Service_Order__c= objWorkOrder.id;
        sa.Is_a_Tech_Appointment__c = true;
        insert sa;
        
        ServiceCrew objServiceCrew = new ServiceCrew(Name ='Test Crew',CrewSize=1);
        Insert objServiceCrew;
        
        ServiceCrewMember objServiceCrewMember = new ServiceCrewMember(ServiceResourceId =sr.Id,
                                                                      ServiceCrewId=objServiceCrew.Id,
                                                                      StartDate=date.today().addDays(-1),
                                                                      endDate = date.today().addDays(2)); 
        Insert objServiceCrewMember;
        
        AssignedResource asr = new AssignedResource();
        asr.ServiceResourceId = sr.Id;
        asr.ServiceAppointmentId = sa.Id;
        asr.ServiceCrewId = objServiceCrew.Id;
        insert asr;
        Map<Id,AssignedResource> newMap = new Map<Id,AssignedResource>();
        newMap.put(asr.Id,asr);
        String newMapJSON = JSON.serialize(newMap);
        Test.startTest();
        FSLAssignedResourceAsynchronousCall.cloneSAForAssignedResource(newMapJSON);
        FSLAssignedResourceAsynchronousCall.populateSA(sa,DateTime.now(),DateTime.now());
        FSLAssignedResourceAsynchronousCall.cloneSAForAssignedResourceSynch(newMapJSON);
		Test.stopTest();
    }
}