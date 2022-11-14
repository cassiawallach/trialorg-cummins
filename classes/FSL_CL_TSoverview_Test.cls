//Sriprada - Adding Comment for Deployment
//Adding comment for Deployment - Jan Release
@isTest
public class FSL_CL_TSoverview_Test {
    
    public static void createData(){
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
        // Added by 
        insert objIntegrationDetails2;
        
        CSS_Integration_Details__c conDetails1 = new CSS_Integration_Details__c();
        conDetails1.name= 'CSS_SBL_WarrantyDetailCoverage';
        conDetails1.End_Point__c= 'https://test.Com/getWarrantyDetailCoverage';
        conDetails1.Username__c= '/R1pbX7W914eNcDkTv34Nt6HruY/e0Z6xgORI2erdsJLn4liuVHhDXIOt6gdStt2hcPNyUEIBHxCGRqicPXloQ==';
        conDetails1.Passcode__c= 'hHjuOsr1QNqKgX1Ryuguv3vvrRI+zvqozvqPkGNYuy2qKYIeh4POyeb0gzfBMPd2uvsMkS2KpZGQtpRY3R8PEA==';
        conDetails1.IsActive__c = true;
        conDetails1.Key__c ='tRPnkpoi6ZX/lFDmBYDzkD1gNAty7F1wNxLM/pjgIY4=';
        
        insert conDetails1; 
        
        OperatingHours objOperatingHours = new OperatingHours();
        objOperatingHours.Name = 'Test OperatingHours';
        objOperatingHours.Description = 'Test OperatingHours';
        //TimeZone
        insert objOperatingHours;
        
        ServiceTerritory objServiceTerritory = new ServiceTerritory();
        objServiceTerritory.Name = 'Test ServiceTerritory Mobile';
        objServiceTerritory.IsActive = true;
        objServiceTerritory.Location_Code__c = '1234-1234';
        objServiceTerritory.FSL_Service_Territory_Code__c = '1234-1234';
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
        insert objAsset;
        
        FSL_Approval_Code__c objApprCode = new FSL_Approval_Code__c();
        objApprCode.Approval_Code__c = '23';
        objApprCode.Approval_Code_Auth_Number__c = '45';
        insert objApprCode;
        
        // shirisha created Service_Order_Extension__c
        Service_Order_Extension__c soeObj = new Service_Order_Extension__c();
        soeObj.FSL_ABRFlag__c = true;
        insert soeObj;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Application__c = '130 - AUTOMOTIVE';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Service_Order_Extension__c = soeObj.Id; // shirisha added field value
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
            objSolutions.FaultCode__c = listFaultCode[i].Id; 
            objSolutions.FSL_Service_Job__c = objWorkOrder.Id;
			objSolutions.userTimestamp__c = system.now() - i;
            listSolutions.add(objSolutions);
        }      
        CSS_Solutions__c objSolutions = new CSS_Solutions__c();
        objSolutions.FaultCode__c = listFaultCode[0].Id;    
        objSolutions.FSL_Service_Job__c = objWorkOrder.Id;
        objSolutions.userTimestamp__c = system.now();
        listSolutions.add(objSolutions);
        insert listSolutions;
        
        FSL_Account_Code__c ac = new FSL_Account_Code__c();
        ac.Account_Code_Description__c = 'abc';
        ac.Name = '123';
        ac.Coverage_Type__c = 'cap';
        insert ac;
        
        CSS_Solution_Component__c objSolutionComponent = new CSS_Solution_Component__c();
        objSolutionComponent.Name = 'Test Solution Component';
        objSolutionComponent.Solutions__c = listSolutions[0].Id;
        objSolutionComponent.FSL_FA_Service_Order__c = objWorkOrder.Id;
        objSolutionComponent.FSL_Service_Job__c = objWorkOrder.Id;
        objSolutionComponent.FailCode__c ='BR';
        objSolutionComponent.Failure_Mode__c = 'crank';
        objSolutionComponent.Component_Id__c = '1603';
        objSolutionComponent.Type__c = 'cam';
        objSolutionComponent.Campaign_Description__c = 'xyz';
        objSolutionComponent.Account_Code__c = ac.Id;
        objSolutionComponent.FSL_Account_Code__c = ac.name;
      
        objSolutionComponent.FSL_Link__c ='www.test.com' ;
        
        objSolutionComponent.Performed_Review__c = TRUE;
        insert objSolutionComponent;
        
        
        
         Test.setCurrentPageReference(new PageReference('Page.myPage')); 
		System.currentPageReference().getParameters().put('id', objSolutionComponent.Id);
        
        CSS_Parts_Options__c objPartsOptions = new CSS_Parts_Options__c();
        objPartsOptions.Name = 'Test Parts Options';
        objPartsOptions.Solutions__c = listSolutions[0].Id;
        insert objPartsOptions;
        
        List<FSL_SRT__c> ListSRT = new List<FSL_SRT__c>();
        FSL_SRT__c objSRT1 = new FSL_SRT__c();
        objSRT1.CSS_Fault_Code__c = listFaultCode[0].Id;
        objSRT1.Solution_Number__c = listSolutions[0].Id;
        objSRT1.Service_Order__c = objWorkOrder.Id;
        objSRT1.SRT_Select__c = true;
        objSRT1.SRT_Time__c = 1.0;
        objSRT1.Type__c = 'Diagnosis';
        ListSRT.add(objSRT1);
        
        FSL_SRT__c objSRT2 = new FSL_SRT__c();
        objSRT2.CSS_Fault_Code__c = listFaultCode[0].Id;
        objSRT2.Solution_Number__c = listSolutions[0].Id;
        objSRT2.Service_Order__c = objWorkOrder.Id;
        objSRT2.SRT_Select__c = true;
        objSRT2.SRT_Time__c = 1.0;
        objSRT2.Type__c = 'Diagnosis';
        ListSRT.add(objSRT2);
        insert ListSRT;
    }
    
    public static testMethod void validateFaultCodes(){
        Test.setMock(HttpCalloutMock.class, new FSL_MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new FSLFaultCodeTokenMock());
        createData();
        
        Test.startTest();
        WorkOrder objobjWorkOrder = [SELECT Id,Service_Order_Extension__r.FaultCodeId__c FROM WorkOrder];
        
        CSS_Solution_Component__c objSolutionComponent =  [SELECT Id,Account_Code__c, FSL_Service_Job__c  FROM CSS_Solution_Component__c ];
        FSL_Account_Code__c ac = [SELECT Id,Name, Coverage_Type__c FROM FSL_Account_Code__c  WHERE Id =: objSolutionComponent.Account_Code__c];
        FSL_Approval_Code__c objCode = [SELECT Id, Approval_Code__c FROM FSL_Approval_Code__c];
        
       // CSS_Fault_Code__c fc = [SELECT Id FROM CSS_Fault_Code__c WHERE Service_Order__c =: objobjWorkOrder.];
        FSL_CL_TSoverview.tsOverview(objobjWorkOrder.Id);
        FSL_CL_TSoverview.changeRecord(objobjWorkOrder.Id,objobjWorkOrder.Service_Order_Extension__r.FaultCodeId__c);
        FSL_CL_TSoverview.UpdateSolComp(objSolutionComponent.Id);
        FSL_CL_TSoverview.getAccountCodeCoverageType(objSolutionComponent.Id);
        FSL_CL_TSoverview.validateApprovalAndAuthorizationNumber(objCode.Approval_Code__c);
        //FSL_CL_TSoverview.getCoverageApex(objSolutionComponent);
        FSL_CL_TSoverview.getCoverageTypeFromApex(ac.Name);
        FSL_CL_TSoverview.getFaultId(objobjWorkOrder.Id,objobjWorkOrder.Service_Order_Extension__r.FaultCodeId__c);
        FSL_CL_TSoverview.saveAccountCode(objSolutionComponent.Id, objSolutionComponent.Account_Code__c); 
        FSL_CL_TSoverview.getStatus(objobjWorkOrder.Id);
       // FSL_CL_TSoverview.saveAccountCode(objSolutionComponent.Id, objSolutionComponent.Account_Code__c);
        // shirisha start
        FSL_CL_TSoverview.fetchFTRFlag(objobjWorkOrder.Id);
        FSL_CL_TSoverview.fetchUserInfo();
        FSL_CL_TSoverview.getProfileInfo();
        FSL_CL_TSoverview.updateAccountCode(objSolutionComponent.Id);
        // shirisha end
        Test.stopTest();
    }
}