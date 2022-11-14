/*********************************************************
* Test Class for Apex Controller - FSL_CL_FaultCodeSolutions
* Author - Piyush Rani
* added changes
************************************************************/ 
//Adding comment for deployment-3/30 Piyush
@isTest
public class FSL_CL_FaultCodeSolutions_Test { 
    
    @testSetup 
    static void setup() {
        
        CSS_Integration_Details__c objIntegrationDetails1 = new CSS_Integration_Details__c();
        objIntegrationDetails1.Name = 'OAGOAuthTest';
        objIntegrationDetails1.ApplicationName__c = 'OAGOAuthTest';
        objIntegrationDetails1.End_Point__c = 'https://services-test-oauth.cummins.com/api/oauth/token/css';
        objIntegrationDetails1.IsActive__c = true;
        objIntegrationDetails1.Key__c = '12345';
        objIntegrationDetails1.Passcode__c= 'test';
        objIntegrationDetails1.Username__c= 'test';
        insert objIntegrationDetails1;
        
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.End_Point__c = 'https//test.com/getQSOLToken';
        conDetails.Passcode__c = 'Admin';
        conDetails.Username__c = 'Admin';
        conDetails.Name = 'FSL_GetApiToken_QSOL';
        insert conDetails;
        
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
        //TimeZone operatinghours
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
        objAsset.Type__c = 'Engines';
        objAsset.Service_Model__c = 'ISL9 CM2350 L101';
        insert objAsset;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        //objWorkOrder.FSL_Locked_Assest__c = 'AssetLocked';
        //objWorkOrder.Application__c = ''
        insert objWorkOrder;
        FSL_TestDataUtility.createServiceOrderExtension(objWorkOrder.id, true, '1234-1234-1234-1234');
        List<CSS_Fault_Code__c> listFaultCode = new List<CSS_Fault_Code__c>();
        for(Integer i = 0; i < 4 ; i++){
            CSS_Fault_Code__c objFaultCode = new CSS_Fault_Code__c();
            objFaultCode.Name = 'Test Fault Code' + i;
            objFaultCode.Fault_Code_Type__c = '1';
            objFaultCode.sequence__c = 2;
            objFaultCode.Service_Order__c = objWorkOrder.Id; 
            listFaultCode.add(objFaultCode);
        }     
        insert listFaultCode;
        
        CSS_Integration_Details__c inteDetails =  FSL_TestDataUtility.createCSSIntegrationDetails('FSL_CDS_GetSolutions', 'https://cdssolutions-stg.cummins.com/api/GetSolution', 'POST');
        inteDetails.AuthEnv__c = 'FSL_CDS_GetSolutions';
        insert inteDetails;
        
        List<FSL_Failure__c> failureList = new List<FSL_Failure__c>();
        failureList.add(FSL_TestDataUtility.createFailure('F11000020', 'WU', 'SS', 'ISL9 CM2350 L101', false));
        failureList.add(FSL_TestDataUtility.createFailure('F30001060', 'WU', 'SS', 'ISL9 CM2350 L101', false));
        insert failureList;
    }
    
    public static testMethod void validateFetchFaultCodeSolutions() {
        
        WorkOrder objWO = [SELECT Id, Asset.Service_Model__c FROM WorkOrder];
        List<CSS_Fault_Code__c> listFaultCode = [SELECT Id, Name, Fault_Code_Type__c,Number_of_Solutions__c,sequence__c,Service_Order__c FROM CSS_Fault_Code__c];
 		Set<String> failureIdSet = new Set<String>();
        Map<String, FSL_Failure__c> failureIdWithFailure = new Map<String, FSL_Failure__c>();
                
        Test.startTest();
        
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest()); 
        FSL_CL_FaultCodeSolutions.fetchFaultCodeSolutions(objWO.Id, listFaultCode);
        List<CSS_Solutions__c> cssSolutions = [SELECT id,Name,CSS_Nested_Solutions__c from CSS_Solutions__c];
        List<Id> cssSolutionsListId = new List<Id>();
        for(CSS_Solutions__c sol: cssSolutions){
            cssSolutionsListId.add(sol.id);
        }
        FSL_CL_FaultCodeSolutions.getDiagTargetTime(cssSolutionsListId, objWO.Id);
        Test.stopTest();

        List<CSS_Solution_Component__c> solutionComponentList = [SELECT Id, Solutions__c, Component_Id__c
                                                                 FROM CSS_Solution_Component__c 
                                                                 WHERE Selected_Component__c = true
                                                                	AND FSL_Service_Job__c =: objWO.Id ];
        for(CSS_Solution_Component__c solComp: solutionComponentList){
            failureIdSet.add(solComp.Component_Id__c);
        }
        
        List<FSL_Failure__c> failureList = [SELECT Id, Failure_Id__c, Component_Code__c, System_Code__c, Service_Model_Name__c 
                                            FROM FSL_Failure__c
                                            WHERE Failure_Id__c IN: failureIdSet
                                            	AND Service_Model_Name__c =: objWO.Asset.Service_Model__c];

        System.assertEquals(4, cssSolutions.size());
        System.assertEquals(2, solutionComponentList.size());
        System.assertEquals(2, failureList.size());
    }
}