/*
* Test Class for Apex Controller - FSL_CL_RAPController
* Author - Piyush Rani
* Author - Sunitha Mattaparthi 12/18/2020
*/ 
@isTest
public class FSL_CL_RAPController_Test {
    //Rajashekar N ; 09/11/2020 ; Adding comments to git for the test coverage
    private static void createData(){
        CSS_Integration_Details__c objIntegrationDetails1 = new CSS_Integration_Details__c();
        objIntegrationDetails1.Name = 'OAGOAuthTest';
        objIntegrationDetails1.ApplicationName__c = 'OAGOAuthTest';
        objIntegrationDetails1.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/css';
        objIntegrationDetails1.IsActive__c = true;
        objIntegrationDetails1.Key__c = '12345';
        objIntegrationDetails1.Passcode__c= 'test';
        objIntegrationDetails1.Username__c= 'test';
        insert objIntegrationDetails1;
        
        CSS_Integration_Details__c objIntegrationDetails2 = new CSS_Integration_Details__c();
        objIntegrationDetails2.IsActive__c=true;
        objIntegrationDetails2.Key__c = '2344';
        objIntegrationDetails2.End_Point__c= 'https://services-test.cummins.com/css/getcampaigndetails';
        objIntegrationDetails2.Name = 'GetCampaign';
        objIntegrationDetails2.ApplicationName__c = 'GetCampaign';        
        objIntegrationDetails2.Passcode__c= 'test';
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
        insert objWorkOrder;
        
        List<CSS_Fault_Code__c> listFaultCode = new List<CSS_Fault_Code__c>();
        for(Integer i = 0; i < 4 ; i++){
            CSS_Fault_Code__c objFaultCode = new CSS_Fault_Code__c();
            objFaultCode.Name = 'Test Fault Code' + i;
            objFaultCode.Fault_Code_Type__c = '1';
            objFaultCode.Number_of_Solutions__c = '4';
            objFaultCode.Service_Order__c = objWorkOrder.Id; 
            listFaultCode.add(objFaultCode);
        }     
        insert listFaultCode;
        
        List<CSS_Solutions__c> listSolutions = new List<CSS_Solutions__c>();        
        for(Integer i = 0; i < 4 ; i++){
            CSS_Solutions__c objSolutions = new CSS_Solutions__c();
            objSolutions.FSL_Service_Job__c = objWorkOrder.Id;
            objSolutions.FaultCode__c = listFaultCode[i].Id;              
            objSolutions.userTimestamp__c = system.now() - i;
            listSolutions.add(objSolutions);
        }      
        CSS_Solutions__c objSolutions = new CSS_Solutions__c();
        objSolutions.FaultCode__c = listFaultCode[0].Id;              
        objSolutions.userTimestamp__c = system.now();
        objSolutions.FSL_Service_Job__c = objWorkOrder.Id;
        listSolutions.add(objSolutions);
        insert listSolutions;
        
        CSS_Solution_Component__c objSolutionComponent = new CSS_Solution_Component__c();
        objSolutionComponent.Name = 'Test Solution Component';
        objSolutionComponent.Solutions__c = listSolutions[0].Id;
        insert objSolutionComponent;
    }
    
    private static testMethod void validateFetchNoteRecords_Test(){
        createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder];
        CSS_Solutions__c objSolutions = [SELECT Id FROM CSS_Solutions__c LIMIT 1];
        FSL_CL_RAPController.caseCreation(objSolutions.Id, 'description', objWorkOrder.Id, '');
        Test.stopTest();
    }
    
}