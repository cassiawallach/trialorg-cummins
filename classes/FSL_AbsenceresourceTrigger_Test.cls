// Cretaed by vinod Yelala


@isTest public class FSL_AbsenceresourceTrigger_Test {
     @isTest 
    static void testscheduler_Test() {
        try { 
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/getQSOLToken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'FSL_GetApiToken_QSOL';
            //insert conDetails1;
            CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
            conDetail1.Name = 'FSL_GETCampaignServices';
            conDetail1.Username__c = 'Pv+LOSogIKym9f3n/PzRirx5XvDf2P7EnfPg0U0mLGaol0uZio1w089RMA+RSfZJpZ9UHJxDsy789paaVZNQsw==';
            conDetail1.Passcode__c = '6jjycQJ9Rv0eMM3zFEkCzkEGTHe2PKnLWwmiiSfgf//26b5Lb/FRObHxDx3edDveSI4YVr6q+6faA38akBa7SQ==';
            conDetail1.IsActive__c = true;
            conDetail1.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com';
            conDetail1.Key__c = 'yq69XtOvpN4jEyU6ae/JuQIvIH5Iz1c6VZKwAZpUOOA=';
            insert new List<CSS_Integration_Details__c>{conDetail1,conDetails1}; 
                
                FSL_GETCampaignServices.doCallout = false;
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account account = new Account();
            account.RecordTypeId = accRecId;
            account.Name = 'Test Account';
            insert account;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact contact = new Contact(FirstName = 'First',
                                          LastName = 'Mishra',
                                          Username__c = 'testmishra@mymail.com',
                                          Email = 'testmishra@mymail.com',
                                          AccountId = account.Id,
                                          RecordTypeId = conRecId);
            Insert contact;
            OperatingHours hours = new OperatingHours();
            hours.Name = 'Test Hours';
            insert hours;
            TimeSlot timeslt = new TimeSlot();
            timeslt.DayOfWeek = system.now().adddays(3).format('EEEE');
            timeslt.StartTime = Time.newInstance(08,00,00,00);
            timeslt.EndTime =  Time.newInstance(17,00,00,00);
            timeslt.Operatinghoursid = hours.id;
            insert timeslt;
            
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
            
            Id profid = [SELECT Id FROM Profile WHERE name = 'System Administrator'].Id;
            
            List<User> users = new List<User>();
            users.add(new User(
                ProfileId = profid,
                LastName = 'Kejrulal',
                Email = 'testmishra@mymail.com',
                Username = 'testmishra@mymail.com'+system.now(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
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
                IAM_UID__c = 'testmishra@mymail.com',
                FederationIdentifier = 'testmishra@mymail.com',
                FSL_Primary_Service_Territory_Code__c='01234'
            ));
            Insert users;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = users[0].Id;
            res.IsActive = true;
            res.ResourceType = 'T';
            insert res;
            
            // Test.startTest();
            ServiceTerritory terr = new ServiceTerritory();
            terr.Name = 'testPopulateTerritory Territory';
            terr.OperatingHoursId = hours.Id;
            terr.IsActive = true;
            terr.Location_Code__c = '01234-01234';
            terr.FSL_Service_Territory_Code__c = '01234';
            terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            terr.Territory__c = 'AUSTRALIA';
            insert terr;
            Id worecordTypeId =  Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal_Billing').getRecordTypeId();
            WorkOrder wo = new WorkOrder();
            wo.AccountId = account.Id;
            wo.ContactId = contact.Id;
            wo.ServiceTerritoryId = terr.Id;
            wo.Priority = 'Low';
            wo.Status = 'Intake';
            wo.ESN_Insite__c = '79799702';
            wo.Process_Step__c = 'Repair';
            wo.WorkTypeId = objWorkType.Id;
            wo.Type__c = 'External';
            wo.AssetId = objAsset.Id;
            wo.Billing_Type__c='ATO-AUTHORIZED TIME OFF';
            wo.RecordTypeId=worecordTypeId;
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
            //insert tMember;
            System.runAs(users[0])
            {
                // Test.stopTest();
                //Added - 31-March-2020
                Id Absencerecrd = Schema.SObjectType.Resourceabsence.getRecordTypeInfosByName().get('All Day').getRecordTypeId();
                ResourceAbsence ra = new ResourceAbsence(start=system.now().adddays(1),end=system.now().adddays(4),Billing_Type__c='ATO-AUTHORIZED TIME OFF',Resource_ERP__c='BMS',
                                                         ResourceId = res.id, RecordTypeId = Absencerecrd);
                insert ra;
                
                
                test.startTest();
                
                FSL_RecordTimesheetEntriesForAbsences uca = new FSL_RecordTimesheetEntriesForAbsences();
                Id batchId = Database.executeBatch(uca);
                test.stopTest();
            }
        }
        catch(exception ex) {
        }
    }
    @isTest 
    static void testAfterInsert_Test() {
        try { 
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/getQSOLToken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'FSL_GetApiToken_QSOL';
            //insert conDetails1;
            CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
            conDetail1.Name = 'FSL_GETCampaignServices';
            conDetail1.Username__c = 'Pv+LOSogIKym9f3n/PzRirx5XvDf2P7EnfPg0U0mLGaol0uZio1w089RMA+RSfZJpZ9UHJxDsy789paaVZNQsw==';
            conDetail1.Passcode__c = '6jjycQJ9Rv0eMM3zFEkCzkEGTHe2PKnLWwmiiSfgf//26b5Lb/FRObHxDx3edDveSI4YVr6q+6faA38akBa7SQ==';
            conDetail1.IsActive__c = true;
            conDetail1.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com';
            conDetail1.Key__c = 'yq69XtOvpN4jEyU6ae/JuQIvIH5Iz1c6VZKwAZpUOOA=';
            insert new List<CSS_Integration_Details__c>{conDetail1,conDetails1}; 
                
                FSL_GETCampaignServices.doCallout = false;
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account account = new Account();
            account.RecordTypeId = accRecId;
            account.Name = 'Test Account';
            insert account;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact contact = new Contact(FirstName = 'First',
                                          LastName = 'Mishra',
                                          Username__c = 'testmishra@mymail.com',
                                          Email = 'testmishra@mymail.com',
                                          AccountId = account.Id,
                                          RecordTypeId = conRecId);
            Insert contact;
            OperatingHours hours = new OperatingHours();
            hours.Name = 'Test Hours';
            insert hours;
            TimeSlot timeslt = new TimeSlot();
            timeslt.DayOfWeek = system.now().adddays(3).format('EEEE');
            timeslt.StartTime = Time.newInstance(08,00,00,00);
            timeslt.EndTime =  Time.newInstance(17,00,00,00);
            timeslt.Operatinghoursid = hours.id;
            insert timeslt;
            
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
            
            Id profid = [SELECT Id FROM Profile WHERE name = 'System Administrator'].Id;
            
            List<User> users = new List<User>();
            users.add(new User(
                ProfileId = profid,
                LastName = 'Kejrulal',
                Email = 'testmishra@mymail.com',
                Username = 'testmishra@mymail.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
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
                IAM_UID__c = 'testmishra@mymail.com',
                FederationIdentifier = 'testmishra@mymail.com',
                FSL_Primary_Service_Territory_Code__c='01234'
            ));
            Insert users;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = users[0].Id;
            res.IsActive = true;
            res.ResourceType = 'T';
            insert res;
            
            // Test.startTest();
            ServiceTerritory terr = new ServiceTerritory();
            terr.Name = 'testPopulateTerritory Territory';
            terr.OperatingHoursId = hours.Id;
            terr.IsActive = true;
            terr.Location_Code__c = '01234-01234';
            terr.FSL_Service_Territory_Code__c = '01234';
            terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            terr.Territory__c = 'AUSTRALIA';
            insert terr;
            Id worecordTypeId =  Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal_Billing').getRecordTypeId();
            WorkOrder wo = new WorkOrder();
            wo.AccountId = account.Id;
            wo.ContactId = contact.Id;
            wo.ServiceTerritoryId = terr.Id;
            wo.Priority = 'Low';
            wo.Status = 'Intake';
            wo.ESN_Insite__c = '79799702';
            wo.Process_Step__c = 'Repair';
            wo.WorkTypeId = objWorkType.Id;
            wo.Type__c = 'External';
            wo.AssetId = objAsset.Id;
            wo.Billing_Type__c='ATO-AUTHORIZED TIME OFF';
            wo.RecordTypeId=worecordTypeId;
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
            //insert tMember;
            System.runAs(users[0])
            {
                // Test.stopTest();
                //Added - 31-March-2020
                Id Absencerecrd = Schema.SObjectType.Resourceabsence.getRecordTypeInfosByName().get('All Day').getRecordTypeId();
                ResourceAbsence ra = new ResourceAbsence(start=system.now().adddays(1),end=system.now().adddays(4),Billing_Type__c='ATO-AUTHORIZED TIME OFF',Resource_ERP__c='BMS',
                                                         ResourceId = res.id, RecordTypeId = Absencerecrd);
                insert ra;
                
                
                test.startTest();
                
                FSL_RecordTimesheetEntriesForAbsences uca = new FSL_RecordTimesheetEntriesForAbsences();
                //Id batchId = Database.executeBatch(uca);
                //String sch ='0 48 * * * ?'; 
                //System.schedule('Schedule to update Account Name', sch,uca);
                //OpportunityScheduler testsche = new OpportunityScheduler();
                String sch = '0 0 0 3 9 ? 2022';
                String jobId = System.schedule('testBasicScheduledApex',sch, new FSL_RecordTimesheetEntriesForAbsencesSch());
                test.stopTest();
            }
        }
        catch(exception ex) {
        }
    }
    
    @isTest 
    static void testlightningcontroller_Test() {
        try { 
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/getQSOLToken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'FSL_GetApiToken_QSOL';
            //insert conDetails1;
            CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
            conDetail1.Name = 'FSL_GETCampaignServices';
            conDetail1.Username__c = 'Pv+LOSogIKym9f3n/PzRirx5XvDf2P7EnfPg0U0mLGaol0uZio1w089RMA+RSfZJpZ9UHJxDsy789paaVZNQsw==';
            conDetail1.Passcode__c = '6jjycQJ9Rv0eMM3zFEkCzkEGTHe2PKnLWwmiiSfgf//26b5Lb/FRObHxDx3edDveSI4YVr6q+6faA38akBa7SQ==';
            conDetail1.IsActive__c = true;
            conDetail1.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com';
            conDetail1.Key__c = 'yq69XtOvpN4jEyU6ae/JuQIvIH5Iz1c6VZKwAZpUOOA=';
            insert new List<CSS_Integration_Details__c>{conDetail1,conDetails1}; 
                
                FSL_GETCampaignServices.doCallout = false;
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account account = new Account();
            account.RecordTypeId = accRecId;
            account.Name = 'Test Account';
            insert account;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact contact = new Contact(FirstName = 'First',
                                          LastName = 'Mishra',
                                          Username__c = 'testmishra@mymail.com',
                                          Email = 'testmishra@mymail.com',
                                          AccountId = account.Id,
                                          RecordTypeId = conRecId);
            Insert contact;
            OperatingHours hours = new OperatingHours();
            hours.Name = 'Test Hours';
            insert hours;
            TimeSlot timeslt = new TimeSlot();
            timeslt.DayOfWeek = system.now().adddays(3).format('EEEE');
            timeslt.StartTime = Time.newInstance(08,00,00,00);
            timeslt.EndTime =  Time.newInstance(17,00,00,00);
            timeslt.Operatinghoursid = hours.id;
            TimeSlot  timeslt1 = new TimeSlot();
            timeslt1.DayOfWeek = system.now().format('EEEE');
            timeslt1.StartTime = Time.newInstance(08,00,00,00);
            timeslt1.EndTime =  Time.newInstance(17,00,00,00);
            timeslt1.Operatinghoursid = hours.id;
            insert new List<TimeSlot  >{timeslt1,timeslt};
            
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
            
            Id profid = [SELECT Id FROM Profile WHERE name = 'System Administrator'].Id;
            
            List<User> users = new List<User>();
            users.add(new User(
                ProfileId = profid,
                LastName = 'Kejrulal',
                Email = 'testmishra@mymail.com',
                Username = 'testmishra@mymail.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
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
                IAM_UID__c = 'testmishra@mymail.com',
                FederationIdentifier = 'testmishra@mymail.com',
                FSL_Primary_Service_Territory_Code__c='01234'
            ));
            Insert users;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = users[0].Id;
            res.IsActive = true;
            res.ResourceType = 'T';
            insert res;
            User usr = [select FSL_Primary_Service_Territory_Code__c from User where id=: UserInfo.getUserId() limit 1];
            // Test.startTest();
            ServiceTerritory terr = new ServiceTerritory();
            terr.Name = 'testPopulateTerritory Territory';
            terr.OperatingHoursId = hours.Id;
            terr.IsActive = true;
            terr.Location_Code__c = '01234-01234';
            terr.FSL_Service_Territory_Code__c = '01234';//usr.FSL_Primary_Service_Territory_Code__c;
            terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            terr.Territory__c = 'AUSTRALIA';
            insert terr;
            Id worecordTypeId =  Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal_Billing').getRecordTypeId();
            WorkOrder wo = new WorkOrder();
            wo.AccountId = account.Id;
            wo.ContactId = contact.Id;
            wo.ServiceTerritoryId = terr.Id;
            wo.Priority = 'Low';
            wo.Status = 'Intake';
            wo.ESN_Insite__c = '79799702';
            wo.Process_Step__c = 'Repair';
            wo.WorkTypeId = objWorkType.Id;
            wo.Type__c = 'External';
            wo.AssetId = objAsset.Id;
            wo.Billing_Type__c='ATO-AUTHORIZED TIME OFF';
            wo.RecordTypeId=worecordTypeId;
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
            //insert tMember;
            System.runAs(users[0])
            {
                // Test.stopTest();
                //Added - 31-March-2020
                Id Absencerecrd = Schema.SObjectType.Resourceabsence.getRecordTypeInfosByName().get('All Day').getRecordTypeId();
                ResourceAbsence ra = new ResourceAbsence(start=system.now().adddays(3),end=system.now().adddays(4),Billing_Type__c='ATO-AUTHORIZED TIME OFF',Resource_ERP__c='BMS',
                                                         ResourceId = res.id, RecordTypeId = Absencerecrd);
                insert ra;
                
                
                test.startTest();
                
                FSL_CreateAbsenceRecordCls fsc = new FSL_CreateAbsenceRecordCls();
                FSL_CreateAbsenceRecordCls.getOperatingHrs();
                ResourceAbsence ra1 = new ResourceAbsence (start = system.now(), end = system.now().addMinutes(120),ResourceId = res.Id,
                                                           Billing_Type__c='ATO-AUTHORIZED TIME',FSL__Approved__c=false);
                FSL_CreateAbsenceRecordCls.insertAbsenceRec(JSON.serialize(ra1), '2020-10-19T04:55:00.000Z','2020-10-19T06:55:00.000Z','true');
                FSL_CreateAbsenceRecordCls.getRecordTypeValues();
                
                test.stopTest();
            }
        }
        catch(exception ex) {
        }
    }
    
    
     @isTest 
    static void testdeletera() {
    
          
            User usr = [select FSL_Primary_Service_Territory_Code__c from User where id=: UserInfo.getUserId() limit 1];
           Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account account = new Account();
            account.RecordTypeId = accRecId;
            account.Name = 'Test Account';
            insert account;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
           /* Contact contact = new Contact(FirstName = 'First',
                                          LastName = 'Mishra',
                                          Username__c = 'testmishra@mymail.com',
                                          Email = 'testmishra@mymail.com',
                                          phone='1234567890',
                                          AccountId = account.Id,
                                          RecordTypeId = conRecId);
            Insert contact; */
            OperatingHours hours = new OperatingHours();
            hours.Name = 'Test Hours';
            insert hours;
            TimeSlot timeslt = new TimeSlot();
            timeslt.DayOfWeek = system.now().adddays(3).format('EEEE');
            timeslt.StartTime = Time.newInstance(08,00,00,00);
            timeslt.EndTime =  Time.newInstance(17,00,00,00);
            timeslt.Operatinghoursid = hours.id;
            TimeSlot  timeslt1 = new TimeSlot();
            timeslt1.DayOfWeek = system.now().format('EEEE');
            timeslt1.StartTime = Time.newInstance(08,00,00,00);
            timeslt1.EndTime =  Time.newInstance(17,00,00,00);
            timeslt1.Operatinghoursid = hours.id;
            insert new List<TimeSlot  >{timeslt1,timeslt};
            
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
            
             ServiceTerritory terr = new ServiceTerritory();
            terr.Name = 'testPopulateTerritory Territory';
            terr.OperatingHoursId = hours.Id;
            terr.IsActive = true;
            terr.Location_Code__c = '01234-01234';
            terr.FSL_Service_Territory_Code__c = '01234';//usr.FSL_Primary_Service_Territory_Code__c;
            terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
            terr.Territory__c = 'AUSTRALIA';
            insert terr;
            Id worecordTypeId =  Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal_Billing').getRecordTypeId();
            WorkOrder wo = new WorkOrder();
            wo.AccountId = account.Id;
           // wo.ContactId = contact.Id;
            wo.ServiceTerritoryId = terr.Id;
            wo.Priority = 'Low';
            wo.Status = 'Scheduled';
            wo.ESN_Insite__c = '79799702';
            wo.Process_Step__c = 'Repair';
            wo.WorkTypeId = objWorkType.Id;
            wo.Type__c = 'External';
            wo.AssetId = objAsset.Id;
            wo.Billing_Type__c='ATO-AUTHORIZED TIME OFF';
            wo.RecordTypeId=worecordTypeId;
            insert wo;
            
            Id profid = [SELECT Id FROM Profile WHERE name = 'System Administrator'].Id;
            
            List<User> users = new List<User>();
            users.add(new User(
                ProfileId = profid,
                LastName = 'Kejrulal',
                Email = 'testmishra@mymail.com',
                Username = 'testmishra@mymail.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
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
                IAM_UID__c = 'testmishra@mymail.com',
                FederationIdentifier = 'testmishra@mymail.com',
                FSL_Primary_Service_Territory_Code__c='01234'
            ));
            Insert users;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = users[0].Id;
            res.IsActive = true;
            res.ResourceType = 'T';
            insert res;
          //  User usr = [select FSL_Primary_Service_Territory_Code__c from User where id=: UserInfo.getUserId() limit 1];
            // Test.startTest();
          
            System.runAs(users[0])
            {
                // Test.stopTest();
                //Added - 31-March-2020
                Id Absencerecrd = Schema.SObjectType.Resourceabsence.getRecordTypeInfosByName().get('All Day').getRecordTypeId();
                ResourceAbsence ra = new ResourceAbsence(start=system.now().adddays(3),end=system.now().adddays(4),Billing_Type__c='ATO-AUTHORIZED TIME OFF',Resource_ERP__c='BMS',
                                                         ResourceId = res.id, RecordTypeId = Absencerecrd);
                insert ra;
                
                
                test.startTest();
                FSL_Timesheet__c ts = new FSL_Timesheet__c();
        ts.Service_Order__c = wo.Id;
        ts.StartTime__c = System.Datetime.now();
        ts.Resource__c = users[0].Id;
        ts.EndTime__c = System.Datetime.now().addDays(1);
        ts.Reason__c = 'Travel';
        ts.Resource_Absence__c = ra.id;
        ts.status__C = 'New';
        insert ts;
        
        delete ra;
                
                test.stopTest();
            }
        
     
    }
    @isTest 
    static void testAfterInsert_Test2() {
        try { 
            
            CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
            conDetails1.End_Point__c = 'https//test.com/getQSOLToken';
            conDetails1.Passcode__c = 'Admin';
            conDetails1.Username__c = 'Admin';
            conDetails1.Name = 'FSL_GetApiToken_QSOL';
            //insert conDetails1;
            CSS_Integration_Details__c conDetail1 = new CSS_Integration_Details__c();
            conDetail1.Name = 'FSL_GETCampaignServices';
            conDetail1.Username__c = 'Pv+LOSogIKym9f3n/PzRirx5XvDf2P7EnfPg0U0mLGaol0uZio1w089RMA+RSfZJpZ9UHJxDsy789paaVZNQsw==';
            conDetail1.Passcode__c = '6jjycQJ9Rv0eMM3zFEkCzkEGTHe2PKnLWwmiiSfgf//26b5Lb/FRObHxDx3edDveSI4YVr6q+6faA38akBa7SQ==';
            conDetail1.IsActive__c = true;
            conDetail1.End_Point__c = 'https://api-ue-devnf-aw-ex.cummins.com';
            conDetail1.Key__c = 'yq69XtOvpN4jEyU6ae/JuQIvIH5Iz1c6VZKwAZpUOOA=';
            insert new List<CSS_Integration_Details__c>{conDetail1,conDetails1}; 
                
                FSL_GETCampaignServices.doCallout = false;
            Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Account account = new Account();
            account.RecordTypeId = accRecId;
            account.Name = 'Test Account';
            insert account;
            
            Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
            Contact contact = new Contact(FirstName = 'First',
                                          LastName = 'Mishra',
                                          Username__c = 'testmishra@mymail.com',
                                          Email = 'testmishra@mymail.com',
                                          AccountId = account.Id,
                                          RecordTypeId = conRecId);
            Insert contact;
            OperatingHours hours = new OperatingHours();
            hours.Name = 'Test Hours';
            insert hours;
            TimeSlot timeslt = new TimeSlot();
            timeslt.DayOfWeek = system.now().adddays(3).format('EEEE');
            timeslt.StartTime = Time.newInstance(08,00,00,00);
            timeslt.EndTime =  Time.newInstance(17,00,00,00);
            timeslt.Operatinghoursid = hours.id;
            insert timeslt;
            
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
            
            Id profid = [SELECT Id FROM Profile WHERE name = 'System Administrator'].Id;
            
            List<User> users = new List<User>();
            users.add(new User(
                ProfileId = profid,
                LastName = 'Kejrulal',
                Email = 'testmishra@mymail.com',
                Username = 'testmishra@mymail.com',
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
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
                IAM_UID__c = 'testmishra@mymail.com',
                FederationIdentifier = 'testmishra@mymail.com',
                FSL_Primary_Service_Territory_Code__c='01234',
                ERP__c='MOVEX'
            ));
            Insert users;
            System.runAs(users[0]){
                ServiceResource res = new ServiceResource();
                res.Name = 'Test Unqualified Resource';
                res.RelatedRecordId = users[0].Id;
                res.IsActive = true;
                res.ResourceType = 'T';
                insert res;
                
                // Test.startTest();
                ServiceTerritory terr = new ServiceTerritory();
                terr.Name = 'testPopulateTerritory Territory';
                terr.OperatingHoursId = hours.Id;
                terr.IsActive = true;
                terr.Location_Code__c = '01234-01234';
                terr.FSL_Service_Territory_Code__c = '01234';
                terr.Region__c = 'AUSTRALIA/ NEW ZEALAND';
                terr.Territory__c = 'AUSTRALIA';
                insert terr;
                
                Id worecordTypeId =  Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Internal_Billing').getRecordTypeId();
                WorkOrder wo = new WorkOrder();
                wo.AccountId = account.Id;
                wo.ContactId = contact.Id;
                wo.ServiceTerritoryId = terr.Id;
                wo.Priority = 'Low';
                wo.Status = 'Intake';
                wo.ESN_Insite__c = '990099';
                wo.Process_Step__c = 'Repair';
                wo.WorkTypeId = objWorkType.Id;
                wo.Type__c = 'External';
                wo.AssetId = objAsset.Id;
                wo.Billing_Type__c='ATO-AUTHORIZED TIME OFF';
                wo.RecordTypeId=worecordTypeId;
                wo.ERP__c='MOVEX';
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
                Id Absencerecrd = Schema.SObjectType.Resourceabsence.getRecordTypeInfosByName().get('All Day').getRecordTypeId();
                ResourceAbsence ra = new ResourceAbsence(start=system.now().adddays(1),end=system.now().adddays(4),Billing_Type__c='ATO-AUTHORIZED TIME OFF',Resource_ERP__c='BMS',
                                                         ResourceId = res.id, RecordTypeId = Absencerecrd);
                insert ra;
                
                
                test.startTest();
                
                FSL_RecordTimesheetEntriesForAbsences uca = new FSL_RecordTimesheetEntriesForAbsences();
                String sch = '0 0 0 3 9 ? 2022';
                String jobId = System.schedule('testBasicScheduledApex',sch, new FSL_RecordTimesheetEntriesForAbsencesSch());
                test.stopTest();
            }
        }
        catch(exception ex) {
        }
    }
    
                
}