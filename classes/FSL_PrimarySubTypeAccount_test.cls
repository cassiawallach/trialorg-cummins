/*****************************************************************************************************************************
Name : FSL_PrimarySubTypeAccount_test 
Description : Work Order object Trigger Handler
Description2 : use this handler to create Primary Account and Primary Subtype

Version                 Date                    Author                             Summary Of Change
--------------------------------------------------------------------------------------------------------- 
1.0                  11/02/2021                Raghav Bansal               test class

******************************************************************************************************************************/@isTest
private class FSL_PrimarySubTypeAccount_test{
    
    @testSetup static void setup(){
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
            ERP__C = 'MOVEX-UK',
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
        List<Account> accountList = new List<Account>();
        Account acc = new Account();
        acc.Name = 'Freightliner of Arizona LLC';
        acc.RecordTypeId = accRecId;
        acc.BillingPostalCode = '47201';
        acc.FSL_ERP_Customer_Code__c = '99999-SPL';
        acc.ACCOUNT_STATUS__c = 'Active';
        //acc.FSL_Source_ERP__c = 'BMS';
        accountList.add(acc);
        
        Account acc1 = new Account();
        acc1.Name = 'Guidanz cash Record';
        acc1.RecordTypeId = guidanzCashRecId;
        acc1.BillingStreet = 'test Street1, street 2';
        acc1.BillingPostalCode = '47201';
        acc1.FSL_ERP_Customer_Code__c = '88888-SPL';
        acc1.ACCOUNT_STATUS__c = 'Active';
        //acc.FSL_Source_ERP__c = 'BMS';
        accountList.add(acc1);
        
        insert accountList;
        
        Contact con= new Contact();
        con.LastName='test';
        con.FirstName='test';
        con.AccountId=acc.id;
        con.Email = 'test@cummins.com';
        con.IAM_Contact_Status__c = 'Active';
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
        st.postalcode='99999';
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
        astlst.add(ast);
        
        Asset ast2 = new Asset();
        ast2.name='79371785';
        ast2.Customer_Name__c = 'Test';
        ast2.AccountId = acc1.Id;
        ast2.Unit_Number__c='595765';
        ast2.VIN__c='BJ361431';
        astlst.add(ast2);
        
        Asset ast3 = new Asset();
        ast3.name='79371786';
        ast3.Unit_Number__c='595769';
        ast3.VIN__c='BJ361430';
        //ast3.AccountId = acc.Id;
        astlst.add(ast3);
        insert astlst;
        
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
        list <FSL_SubType__c> sub = new list<FSL_SubType__c>();
        FSL_SubType__c subType = new FSL_SubType__c();
        subType.name = 'Test Sub Type';
        subType.Status__c = 'Active';
        subType.Branch_Code__c = 1234;
        sub.add(subType);
        FSL_SubType__c subType1 = new FSL_SubType__c();
        subType1.name = 'Test Type';
        subType1.Status__c = 'Active';
        subType1.Branch_Code__c = 1234;
        sub.add(subType1);
        insert sub;
        
        
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
        
    }
    
    @isTest
    private static void testMethod1() {
        User usr = [SELECT Id,ERP__C FROM USER WHERE Username = 'testUserRaghav@testEmail.com'];
        system.runAs(usr){
            Account acc = [SELECT Id,Name, FSL_ERP_Customer_Code__c,ACCOUNT_STATUS__c,FSL_Source_ERP__c FROM account where name ='Freightliner of Arizona LLC' LIMIT 1];
            Account acc1 = [SELECT Id, Name, FSL_ERP_Customer_Code__c,ACCOUNT_STATUS__c,FSL_Source_ERP__c FROM account where name = 'Guidanz cash Record' LIMIT 1];
            
            
            // Contact con = [SELECT Id FROM Contact LIMIT 1];
            Asset ast = [SELECT Id FROM Asset LIMIT 1];
            serviceterritory st = [SELECT Id FROM serviceterritory LIMIT 1];
            MaintenancePlan objMP = [SELECT Id FROM MaintenancePlan LIMIT 1];
            FSL_SubType__c subType = [SELECT Id,name FROM FSL_SubType__c where name = 'Test Sub Type' LIMIT 1];
            FSL_SubType__c subType1 = [SELECT Id,name FROM FSL_SubType__c where name = 'Test Type' LIMIT 1];
            
            
            list <WorkOrder> woList = new list<WorkOrder>();
            test.startTest();
            WorkOrder wo1 = new WorkOrder();
            wo1.AccountId = acc.id; 
            wo1.Payer__c = acc.id;  
            wo1.type__c = 'External';
            //  wo1.Payer_ContactID__c=con.Id;
            wo1.ESN__c='79371784';
            wo1.Unit_Type__c='595769';
            wo1.Make__c='INTERNATIONAL';
            wo1.Model__c='PROSTAR';
            wo1.AssetId=ast.Id;
            wo1.ServiceTerritoryId=st.Id;
            wo1.EditCause__c = 'Testing Info2';
            wo1.EditCorrection__c = 'Testing Info2';
            wo1.EditCoverage__c = 'Testing Info12';
            wo1.MaintenancePlanId =objMP.Id;
            wo1.SuggestedMaintenanceDate = system.today();
            // wo1.ContactID = con.id;
            wo1.FSL_Sub_Type__c=subtype.id; 
            wo1.ERP__c = 'MOVEX';
            insert wo1;
            wo1.FSL_Sub_Type__c=subType1.id;
            wo1.AccountId = acc1.id;
            wo1.Payer__c = acc1.id;  
            update wo1;
            wo1.AccountId = acc.id;
            wo1.Payer__c = acc.id;  
            update wo1;
            wo1.FSL_Sub_Type__c=subType.id;
            update wo1;
            test.stopTest();
        }
    }
	
	@isTest
    private static void testMethod2() {
        User usr = [SELECT Id,ERP__C FROM USER WHERE Username = 'testUserRaghav@testEmail.com'];
        system.runAs(usr){
            Account acc = [SELECT Id,Name, FSL_ERP_Customer_Code__c,ACCOUNT_STATUS__c,FSL_Source_ERP__c FROM account where name ='Freightliner of Arizona LLC' LIMIT 1];
            Account acc1 = [SELECT Id, Name, FSL_ERP_Customer_Code__c,ACCOUNT_STATUS__c,FSL_Source_ERP__c FROM account where name = 'Guidanz cash Record' LIMIT 1];
            
            
            // Contact con = [SELECT Id FROM Contact LIMIT 1];
            Asset ast = [SELECT Id FROM Asset LIMIT 1];
            serviceterritory st = [SELECT Id FROM serviceterritory LIMIT 1];
            MaintenancePlan objMP = [SELECT Id FROM MaintenancePlan LIMIT 1];
            FSL_SubType__c subType = [SELECT Id,name FROM FSL_SubType__c where name = 'Test Sub Type' LIMIT 1];
            FSL_SubType__c subType1 = [SELECT Id,name FROM FSL_SubType__c where name = 'Test Type' LIMIT 1];
            
            
            list <WorkOrder> woList = new list<WorkOrder>();
            test.startTest();
            WorkOrder wo1 = new WorkOrder();
            wo1.AccountId = acc.id; 
            wo1.Payer__c = acc.id;  
            wo1.type__c = 'External';
            //  wo1.Payer_ContactID__c=con.Id;
            wo1.ESN__c='79371784';
            wo1.Unit_Type__c='595769';
            wo1.Make__c='INTERNATIONAL';
            wo1.Model__c='PROSTAR';
            wo1.AssetId=ast.Id;
            wo1.ServiceTerritoryId=st.Id;
            wo1.EditCause__c = 'Testing Info2';
            wo1.EditCorrection__c = 'Testing Info2';
            wo1.EditCoverage__c = 'Testing Info12';
            wo1.MaintenancePlanId =objMP.Id;
            wo1.SuggestedMaintenanceDate = system.today();
            // wo1.ContactID = con.id;
            wo1.FSL_Sub_Type__c=subtype.id; 
            wo1.ERP__c = 'MOVEX-UK';
            insert wo1;
            wo1.FSL_Sub_Type__c=subType1.id;
            wo1.AccountId = acc1.id;
            wo1.Payer__c = acc1.id;  
            update wo1;
            wo1.AccountId = acc.id;
            wo1.Payer__c = acc.id;  
            update wo1;
            wo1.FSL_Sub_Type__c=subType.id;
            update wo1;
            test.stopTest();
        }
    }
}