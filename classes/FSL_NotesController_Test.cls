/*
* Test Class for Apex Controller - FSL_NotesController
* Author - Piyush Rani
*/ 
@isTest
public class FSL_NotesController_Test {
    private static void createData(){
        CSS_Integration_Details__c objIntegrationDetails1 = new CSS_Integration_Details__c();
        objIntegrationDetails1.Name = 'OAGOAuthTest';
        objIntegrationDetails1.ApplicationName__c = 'OAGOAuthTest';
        objIntegrationDetails1.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/css';
        objIntegrationDetails1.IsActive__c = true;
        objIntegrationDetails1.Key__c = '12346';
        objIntegrationDetails1.Passcode__c= 'test';
        objIntegrationDetails1.Username__c= 'test';
        insert objIntegrationDetails1;
        
        CSS_Integration_Details__c objIntegrationDetails2 = new CSS_Integration_Details__c();
        objIntegrationDetails2.IsActive__c=true;
        objIntegrationDetails2.Key__c = '2344';
        objIntegrationDetails2.End_Point__c= 'https://services-test.cummins.com/css/getcampaigndetails';
        objIntegrationDetails2.Name = 'GetCampaign';
        objIntegrationDetails2.ApplicationName__c = 'GetCampaign';        
        objIntegrationDetails2.Passcode__c= 'test123';
        objIntegrationDetails2.Username__c= 'test';
        objIntegrationDetails2.Timeout__c=120000.0;
        objIntegrationDetails2.Method_Type__c='POST' ;
        objIntegrationDetails2.Logging__c='BOTH';
        objIntegrationDetails2.AuthEnv__c='OAGOAuthTest';
        insert objIntegrationDetails2;
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '01234-01234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '01234';
        objServiceTerritory.OperatingHoursId = objOperatingHours.Id;
        objServiceTerritory.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        objServiceTerritory.Territory__c = 'AUSTRALIA';
        insert objServiceTerritory;
        
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        insert objAccount;
        
        WorkType objWorkType = new WorkType();
        objWorkType.Name = 'Test WorkType';
        objWorkType.EstimatedDuration = 60.0;
        objWorkType.DurationType = 'Minutes';
        insert objWorkType;
        
        Asset objAsset = new Asset();
        objAsset.Name = '79788868';
        objAsset.Type_PSN__c = 'Engines-79788868';
        insert objAsset;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Shop_Work_Order__c='Movex Test';
        insert objWorkOrder;
        
        fsl_Switch__c fs=new fsl_Switch__c();
        fs.Name='Job_Notes';
        fs.ERP__c='BMS;MOVEX';
        fs.IsActive__c=true;
        Insert fs;
        
    }
    
    private static testMethod void validateFetchNoteRecords(){
        createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder];
        FSL_NotesController.fetchNoteRecords(objWorkOrder.Id,'ASC');
        Test.stopTest();
    }
    
    private static testMethod void validateFetchUser(){
        createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder];
        FSL_NotesController.fetchUser();
        Test.stopTest();
    }
    
    private static testMethod void validateSaveNotesDetails(){
        createData();
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u = new User(Alias = 'standt', Email = 'qt943@cummins.com',
                          EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US', ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles', UserName = 'qt943@cummins.com.testrun',
                          FSL_Primary_Service_Territory_Code__c = '04892-I');
        u.ERP__C = 'MOVEX';
        insert u; 
        system.runAs(u) {
        
        
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder where Shop_Work_Order__c='Movex Test'];
        String configData = '{"recId":"'+objWorkOrder.Id+'","noteType":"WRITERNOTES","noteValue":"Test"}';
        FSL_NotesController.DataWrapper config = (FSL_NotesController.DataWrapper)JSON.deserialize(configData, FSL_NotesController.DataWrapper.class);
       
        FSL_NotesController.saveNotesDetails(configData);
        objWorkOrder.Type__c = 'Dealer';
        update objWorkOrder;
        FSL_NotesController.saveNotesDetails(configData);

        Test.stopTest();
        }
    }
    
    /* private static testMethod void validateSaveNotesDetails1(){
    createData();
    Test.startTest();
    WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder];
    FSL_NotesController.saveNotesDetails('');
    Test.stopTest();
    }
    
   
    
    private static testMethod void validateSaveNotesDetails3(){
    createData();
    Test.startTest();
    WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder];
    Note objNote = new Note();
    objNote.Body = 'Tedt Body';
    objNote.title = 'Body Title';
    objNote.ParentId	 = objWorkOrder.Id;
    insert objNote;
    FSL_NotesController.notesWrapper n = new FSL_NotesController.notesWrapper(objNote);
    Test.stopTest();
    }
    */
    private static testMethod void validateSaveNotesDetails3(){
        createData();
        
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder];
        
        Note objNote = (Note) Json.deserialize('{"createdDate" : "2019-06-10T00:00:00Z",' +
                                         '"title" : "Body Title",' +
                                         '"body" : "Test Body",' +
                                         '"parentId" : "' + objWorkOrder.id + '"' +
                                         '}',
                                         Note.class);
        insert objNote;
        
        Test.startTest();
        FSL_NotesController.fetchUserInfo();// new change
        FSL_NotesController.getCustomMetaDataTypesForErrors('error message'); // new change
        FSL_NotesController.notesWrapper n = new FSL_NotesController.notesWrapper(objNote);
        Test.stopTest();
    }
}