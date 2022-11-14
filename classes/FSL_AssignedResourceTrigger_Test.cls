@isTest(seeAllData=true)
public class FSL_AssignedResourceTrigger_Test {
    
    
    @isTest
    private static void testPosttoChatter() {
        try {       
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
                FederationIdentifier = 'testmishra@mymail.com'
            ));
            Insert users;
            
            ServiceResource res = new ServiceResource();
            res.Name = 'Test Unqualified Resource';
            res.RelatedRecordId = users[0].Id;
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
            
            Test.starttest();
            ServiceAppointment appt = new ServiceAppointment();
            appt.Status = 'In Progress';
            appt.ParentRecordId = wo.Id;
            appt.ServiceTerritoryId = terr.Id;
            appt.ContactId = contact.Id;
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
            Test.stoptest();
            
            List<FSL_Timesheet__c> tsList = new List<FSL_Timesheet__c>();
            FSL_Timesheet__c ts = new FSL_Timesheet__c();
            ts.Service_Order__c = wo.Id;
            ts.StartTime__c = System.Datetime.now();
            ts.Resource__c = users[0].Id;
            ts.EndTime__c = System.Datetime.now().addDays(1);
            ts.Reason__c = 'Travel';
            
            FSL_Timesheet__c tsheet = new FSL_Timesheet__c();
            tsheet.Service_Order__c = wo.Id;
            tsheet.StartTime__c = System.Datetime.now();
            tsheet.Resource__c = users[0].Id;
            tsheet.Reason__c = 'Travel';
            
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
            
            FSL_Timesheet__c tsNew = new FSL_Timesheet__c();
            tsNew.Service_Order__c = wo.Id;
            tsNew.StartTime__c = System.Datetime.now();
            tsNew.Resource__c = users[0].Id;
            tsNew.EndTime__c = Null;
            tsNew.Reason__c = 'Travel';
            insert tsNew;
            
            tsNew.EndTime__c = System.Datetime.now().addHours(11);
            tsNew.change_reason__C = 'test change';
            update tsNew;
        }
        catch(exception e) {
            system.debug('check');
        }
    }
}