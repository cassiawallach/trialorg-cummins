//Comment added for deployment sept 2022
@isTest
public class FSL_CL_CICOService_Test {
    @testSetup
    public static void setupData(){
        Id profid = [select Id from profile where name= 'System Administrator' LIMIT 1].Id;
        User testUser = new User(
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
            
            );
        insert testUser;
        
        //create Account
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
        insert acc;
         
        // create contact
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact contact = new Contact(FirstName = 'testFirst',
                                      LastName = 'testLast',
                                      Username__c = 'testUser@testEmail.com',
                                      Email = 'testUser@testEmail.com',
                                      AccountId = acc.Id,
                                      RecordTypeId = conRecId,
                                      //Mobile_Phone__c = '1212333300', // Migrating from Mobile_Phone__c custom field to MobilePhone standard field
                                      MobilePhone = '1212333300');
        insert contact;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test Hours';
        objOperatingHours.Description = 'Test Description';
        insert objOperatingHours;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';
        insert objWorkType;
        
        ServiceResource sr=new ServiceResource();
        sr.Name = 'service resource';
        sr.IsActive = true;
        sr.RelatedRecordId = testUser.id;
        sr.ResourceType = 'T';
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
        
        Asset objAsset = new Asset();
        objAsset.Name = '23234324';
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Type__c = 'Engines';
        insert objAsset;
        
        Id RepairRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Repair').getRecordTypeId();
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.recordtypeid=RepairRTID;
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Job Plan';
        objWorkOrder.ESN_Insite__c = '79799702';
        objWorkOrder.Process_Step__c = 'Repair';
        objWorkOrder.AccountId = acc.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.Type__c = 'External'; 
        objWorkOrder.AssetId = objAsset.Id;
        insert objWorkOrder;
    }
    
    @isTest
    public static void testSuccess(){
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.AuthEnv__c = 'MuleAuthDEV';
        conDetails.Name = 'FSL_CL_CICOWebService';
        conDetails.ApplicationName__c = 'FSL_MoveX_ServiceHistory';
        conDetails.End_Point__c = 'https://api-ue-devnf3-aw-ex.cummins.com/jobs/pmrinfo ';
        conDetails.IsActive__c = true;
        conDetails.Key__c = 'zgZkT6rJlwriwrawZ+xt5K5Z7O5QvQ83FWZIqXWNHAU=';
        conDetails.Passcode__c = 'IMkd8o1GfAz1pMzSfsETThGpFRnC8IZhzhp12vAtrr7kdXS61mXmsl2O477jTaTJY/mb144vwQUDGRXtGynyvA==';
        conDetails.Username__c = '9uX9kGoJoG8h9Nj01BrwZbZe3qrumf4ErRTl05eZCbn8P+j0D+q6IgJgErZVF4OcHoH8A+SuL/pMUsqjzKBXMg==';
        conDetails.Method_Type__c = 'POST';
        insert conDetails;
        
		FSL_CL_CICOService.testSuccess = true;
        WorkOrder objWorkOrder = [Select id From WorkOrder Limit 1];
        FSL_Timesheet__c ts = new FSL_Timesheet__c();
        ts.Service_Order__c = objWorkOrder.Id;
        ts.StartTime__c = System.Datetime.now();
        //ts.EndTime__c = System.Datetime.now().addDays(1);
        ts.Reason__c = 'Travel';
        Test.startTest();
        insert ts;
        ts.status__c = 'Submitted';
        update ts;
        Test.stopTest();
    }
    
    @isTest
    public static void testError(){
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.AuthEnv__c = 'MuleAuthDEV';
        conDetails.Name = 'FSL_CL_CICOWebService';
        conDetails.ApplicationName__c = 'FSL_MoveX_ServiceHistory';
        conDetails.End_Point__c = 'https://api-ue-devnf3-aw-ex.cummins.com/jobs/pmrinfo ';
        conDetails.IsActive__c = true;
        conDetails.Key__c = 'zgZkT6rJlwriwrawZ+xt5K5Z7O5QvQ83FWZIqXWNHAU=';
        conDetails.Passcode__c = 'IMkd8o1GfAz1pMzSfsETThGpFRnC8IZhzhp12vAtrr7kdXS61mXmsl2O477jTaTJY/mb144vwQUDGRXtGynyvA==';
        conDetails.Username__c = '9uX9kGoJoG8h9Nj01BrwZbZe3qrumf4ErRTl05eZCbn8P+j0D+q6IgJgErZVF4OcHoH8A+SuL/pMUsqjzKBXMg==';
        conDetails.Method_Type__c = 'POST';
        insert conDetails;
        
		FSL_CL_CICOService.testSuccess = false;
        WorkOrder objWorkOrder = [Select id From WorkOrder Limit 1];
        FSL_Timesheet__c ts = new FSL_Timesheet__c();
        ts.Service_Order__c = objWorkOrder.Id;
        ts.StartTime__c = System.Datetime.now();
        //ts.EndTime__c = System.Datetime.now().addDays(1);
        ts.Reason__c = 'Travel';
        Test.startTest();
        insert ts;
        ts.status__c = 'Submitted';
        update ts;
        Test.stopTest();
    }
    
    @isTest
    public static void initializeWrapper(){
        FSL_CL_CICOResWrapper wrapper = new FSL_CL_CICOResWrapper();
    }
}