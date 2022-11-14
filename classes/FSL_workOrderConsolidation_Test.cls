@isTest
//Adding comment for code push
public class FSL_workOrderConsolidation_Test {
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
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Id guidanzCashRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        insert acc;
        
        Account acc1 = new Account();
        acc1.Name = 'Guidanz cash Record';
        acc1.RecordTypeId = guidanzCashRecId;
        acc1.BillingStreet='hyderabad';
        insert acc1;
        
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Guidanz').getRecordTypeId();
        Contact con= new Contact();
        con.LastName='test';
        con.FirstName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        con.IAM_Contact_Status__c = 'Active';
        con.RecordTypeId = recTypeId;
        insert con;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        serviceterritory st = new serviceterritory();
        st.name='BrisbaneNew';
        st.state='Queensland';
        st.city='Carole Park';
        st.Street='39-53 Ron Boyle Crescent';
        st.country='Australia';
        st.postalcode='4300';
        st.Phone__c ='+61 7 3710 4700'; 
        st.OperatingHoursId = oh.Id;
        st.IsActive = true;
        st.Location_Code__c = '03522-04893';
        st.FSL_Service_Territory_Code__c = '04893';
        st.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        st.Territory__c = 'AUSTRALIA';
        insert st;
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
        addressObj.Status__c = 'Active';
        addressObj.Account__c = acc.Id;
        addressObj.ParentId = locationObj.Id;
        insert addressObj;
        
        list<asset> astlst=new list<asset>();
        Asset ast = new Asset();
        ast.name='79371784';
        ast.Unit_Number__c='595769';
        ast.VIN__c='BJ361430';
        ast.AccountId = acc.Id;
        ast.Application__c = '130 - AUTOMOTIVE';
        ast.Product_Application_Code__c = '01';
        insert ast;
        Asset ast2 = new Asset();
        ast2.name='79371785';
        ast2.Customer_Name__c = 'Test';
        ast2.AccountId = acc1.Id;
        ast2.Unit_Number__c='595765';
        ast2.VIN__c='BJ361431';
        insert ast2;
        Asset ast3 = new Asset();
        ast3.name='79371786';
        ast3.Unit_Number__c='595769';
        ast3.VIN__c='BJ361430';
        //ast3.AccountId = acc.Id;
        insert ast3;
        
        Asset ast4 = new Asset();
        ast4.name='79371787';
        ast4.Unit_Number__c='595770';
        ast4.VIN__c='BJ361431';
        ast4.Customer_Name__c = 'Test';
        ast4.AccountId = acc1.Id;
        insert ast4;
        
        Case  cs = new Case();
        cs.Status = 'Intake';
        cs.AccountId = acc.id;
        cs.AssetId = ast.id;
        cs.Priority = 'Medium';
        insert cs; 
        
        WorkType pmWorkType = new WorkType();
        pmWorkType.name='PM';
        pmWorkType.EstimatedDuration=4;
        insert pmWorkType;
        
        FSL_SubType__c subType = new FSL_SubType__c();
        subType.name = 'Test Sub Type';
        subType.Status__c = 'Active';
        subType.Branch_Code__c = 1234;
        insert subType;
        
        MaintenancePlan objMP = new MaintenancePlan();
        objMP.StartDate= system.today();
        objMP.EndDate=system.today()+365;
        objMP.Frequency=1;
        objMP.FrequencyType ='Months';
        objMP.NextSuggestedMaintenanceDate = system.today();
        objMP.GenerationTimeframe=2;
        objMP.WorkTypeId = pmWorkType.id;
        insert objMP;
        
        MaintenanceAsset MA = new MaintenanceAsset();
        MA.MaintenancePlanId = objMP.Id;
        MA.AssetId =ast.Id;
        MA.WorkTypeId=pmWorkType.Id;
        MA.Branch_Code__c = 1234;
        MA.Sub_Type__c = subType.Id;
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

        Test.startTest();
        WorkOrder wo = new WorkOrder();
        wo.AccountId = acc.id; 
        wo.Payer__c = acc.id;        
        wo.Payer_ContactID__c=con.Id;
        wo.ESN__c='79371784';
        wo.Unit_Type__c='595769';
        wo.Make__c='INTERNATIONAL';
        wo.Model__c='PROSTAR';
        wo.AssetId=ast.Id;
        wo.CaseId = cs.id;
        wo.ServiceTerritoryId=st.Id;
        wo.EditCause__c = 'Testing Info2';
        wo.EditCorrection__c = 'Testing Info2';
        wo.EditCoverage__c = 'Testing Info12';
        wo.MaintenancePlanId =objMP.Id;
        wo.SuggestedMaintenanceDate = system.today();
        wo.ContactID = con.id;
        wo.FSL_Sub_Type__c=subtype.id; 
        //wo.Repair_Site_Address__c=[SELECT id FROM Address Limit 1].id;
         //wo.AssetId = ast2.id;
        insert wo;
        Test.stopTest();
                
        CSS_JobEventTemporary__c JET = new CSS_JobEventTemporary__c();
        JET.Key__c = 'MarketingApplicationCodes';
        JET.Attribute1__c = ast.Product_Application_Code__c;
        JET.Attribute2__c = ast.Application__c.substringBefore('-');
        insert JET;
        
    }
    public testMethod static void updateWoDetailsTest(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name ='79371786' limit 1];
        wo.Type__c = 'Dealer';
        wo.AssetId=astlst.Id;
        update wo;
        Test.stoptest();
    }
    public testMethod static void ExternalTypeTest(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name ='79371785' limit 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'Mobile';
        wo.Shop_Work_Order__c = '12345';
        wo.Customer_Name__c = 'TEST';
        update wo;
        Test.stoptest();
    }
    
    public testMethod static void ExternalTypeShopWorkOrder(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name ='79371786' limit 1];
        ServiceTerritory serTerr = [SELECT Id,state,city,Street,country,postalcode FROM ServiceTerritory LIMIT 1];
        Schema.address addres = [SELECT Id,state,city,Street,country,postalcode FROM Address LIMIT 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'Mobile';
        wo.Shop_Work_Order__c = '';
        update wo;
        FSL_workOrderConsolidation.addressUpdateRepairSite(wo,serTerr);
        FSL_workOrderConsolidation.addressUpdateWordOrderAsset(wo,addres);
        Test.stoptest();
    }
    
    public testMethod static void ExternalTypeTestcustomerName(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name ='Guidanz cash Record' LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name='79371786' limit 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'Mobile';
        wo.Shop_Work_Order__c = '12345';
        wo.Customer_Name__c = '';
        update wo;
        Test.stoptest();
    }
    public testMethod static void repairLocationMobile(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name ='Guidanz cash Record' LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE AccountId = '' limit 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'Mobile';
        wo.Shop_Work_Order__c = '12345';
        wo.Customer_Name__c = '';
        update wo;
        Test.stoptest();
    }
    public testMethod static void repairLocation(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId,AccountId,ContactId FROM WorkOrder LIMIT 1];
        Contact con = [SELECT Id,FirstName,LastName,Email,phone FROM Contact LIMIT 1];
        Account acc = [SELECT Id,Name,RecordType.DeveloperName,BillingCity,BillingState,
                       Billingstreet,BillingCountry,BillingPostalCode
                       FROM Account WHERE Name ='Guidanz cash Record' LIMIT 1];
        FSL_workOrderConsolidation.changeInRepairLocation(wo,acc,con);
        FSL_workOrderConsolidation.updateCustomerDetails(wo,acc,con);
        Test.stoptest();
    }
    
    public testMethod static void changeInRepairLocationTest(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId,AccountId,ContactId FROM WorkOrder LIMIT 1];
        Contact con = [SELECT Id,FirstName,LastName,Email,phone FROM Contact LIMIT 1];
        Asset astlst = [SELECT Id,Name,Customer_Name__c,City__c,State__c,
                        MoveX_Customer_Address_1__c,MoveX_Customer_Address_2__c,
                        MoveX_Customer_Address_3__c,Contact_Name__c,MoveX_Email_ID__c,MoveX_Phone_Number__c 
                        FROM Asset limit 1];
        Account acc = [SELECT Id,Name,RecordType.DeveloperName,BillingCity,BillingState,
                       Billingstreet,BillingCountry,BillingPostalCode
                       FROM Account WHERE Name !='Guidanz cash Record' LIMIT 1];
        FSL_workOrderConsolidation.changeInRepairLocation(wo,acc,con);
        FSL_workOrderConsolidation.cashCustomerDetails(wo,astlst);
        Test.stoptest();
    }
    public testMethod static void inShopRepairLocation(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name ='79371785' limit 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'In Shop';
        wo.Shop_Work_Order__c = '12345';
        wo.Customer_Name__c = 'TEST';
        update wo;
        Test.stoptest();
    }
    
    public testMethod static void InshopWorkOrderAssetNull(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name ='Guidanz cash Record' LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name='79371786' limit 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'In Shop';
        wo.Shop_Work_Order__c = '12345';
        wo.Customer_Name__c = '';
        update wo;
        Test.stoptest();
    }
    
    public testMethod static void woAccountIdandWOAssetAccountId(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId,Type__c,Mileage_Measure__c,Repair_Location__c,Shop_Work_Order__c FROM WorkOrder LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name ='Guidanz cash Record' LIMIT 1];
        Asset astlst = [SELECT Id,Name,AccountId,Unit_Number__c,Application__c,Registration__c,Equipment_Id__c,
                        Make__c,Model__c,Service_Model__c,Equipment_Configuration__c
                        FROM Asset WHERE Name='79371785' limit 1];
        ServiceTerritory sr = [SELECT Id,Mileage_Measure__c FROM ServiceTerritory LIMIT 1];
        wo.caseId = NULL;
        update wo;
        FSL_workOrderConsolidation.updateAssetWorkOrder(wo,NULL,astlst,sr);
        Test.stoptest();
    }
    
    public testMethod static void RepairSiteMobileAddAsset(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId,AccountId FROM WorkOrder LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name ='Freightliner of Arizona LLC' LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE AccountId != '' limit 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'Mobile';
        wo.Repair_Site_Address__c=[SELECT id FROM Address Limit 1].id;
        wo.Shop_Work_Order__c = null;
        update wo;
        Test.stoptest();
    }
    
    public testMethod static void MobileWorkOrderCashCustomer(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name ='Guidanz cash Record' LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name='79371787' limit 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'Mobile';
        wo.Shop_Work_Order__c = '12345';
        wo.Customer_Name__c = '';
        update wo;
        Test.stoptest();
    }
        public testMethod static void InShopAddAsset(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId,AccountId FROM WorkOrder LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name ='Freightliner of Arizona LLC' LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE AccountId != '' limit 1];
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'In Shop';
        wo.Shop_Work_Order__c = null;
        update wo;
        Test.stoptest();
    }
    
    public testMethod static void InshopWorkOrderNull(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Account acc = [SELECT Id FROM Account WHERE Name ='Guidanz cash Record' LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name='79371786' limit 1];
        astlst.Warranty_Start_Date__c = Date.newInstance(2016, 12, 9);
        update astlst;
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'In Shop';
        wo.Shop_Work_Order__c = null;
        wo.Customer_Name__c = '';
        update wo;
        Test.stoptest();
    }
    
    public testMethod static void InshopWOAssetAcctNull(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name ='79371785' limit 1];
        astlst.AccountId = null;
        update astlst;
        wo.Type__c = 'External';
        wo.AssetId=astlst.Id;
        wo.Repair_Location__c = 'In Shop';
        wo.Shop_Work_Order__c = '12346';
        wo.Customer_Name__c = 'TEST8';
        update wo;
        Test.stoptest();
    }
    
    public testMethod static void InshopWOAssetNull(){
        Test.startTest();
        WorkOrder wo = [SELECT Id,AssetId FROM WorkOrder LIMIT 1];
        serviceterritory st = [SELECT Id, Name from serviceterritory WHERE name='BrisbaneNew' limit 1];
        Asset astlst = [SELECT Id,Name FROM Asset WHERE Name ='79371785' limit 1];
        wo.Type__c = 'External';
        wo.AssetId = null;
        wo.ServiceTerritoryId = st.Id;
        wo.Repair_Location__c = 'In Shop';
        wo.Shop_Work_Order__c = '12346';
        wo.Customer_Name__c = 'TEST8';
        update wo;
        Test.stoptest();
    }
    
}