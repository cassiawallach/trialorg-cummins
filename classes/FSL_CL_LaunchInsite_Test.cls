/*
Added Comment by Krishna  for DeploymenCodeCoverage
 This is a test class for FSL_CL_LaunchInsite class
 */
@isTest
public class FSL_CL_LaunchInsite_Test {
    private static void createData(){
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
        objAsset.Name = '23234324';
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Type__c = 'Engines';
        insert objAsset;
        
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        //objWorkOrder.ESN_Insite__c = '79799702';
        objWorkOrder.ESN_Insite__c = '23234324';
        objWorkOrder.Process_Step__c = 'Repair';
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
         for(Integer i = 0; i < 4 ; i++){
            CSS_Fault_Code__c objFaultCode = new CSS_Fault_Code__c();
            objFaultCode.Name = 'Test Fault Code' + i;
            objFaultCode.Fault_Code_Type__c = '1';
            objFaultCode.Status__c = 'Test';
            objFaultCode.Count__c = 20;
            objFaultCode.Fault_Code_Type__c = 'ABC';
             if(i == 3){
                  objFaultCode.Fault_Code_Type__c = 'BLANK';
             }
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
        objSolutions.FSL_Service_Job__c = objWorkOrder.Id;
        objSolutions.FaultCode__c = listFaultCode[0].Id;
        objSolutions.FSL_Solution_Position__c = '1.00';
        objSolutions.userTimestamp__c = system.now();
        listSolutions.add(objSolutions);
        insert listSolutions;
        
        CSS_Solution_Component__c objSolutionComponent = new CSS_Solution_Component__c();
        objSolutionComponent.Name = 'Test Solution Component';
        objSolutionComponent.Solutions__c = listSolutions[0].Id;
        insert objSolutionComponent;
    }
    private static testmethod void validateLaunchInsite() {
        createData();
        Test.startTest();
        workorder objwo = [SELECT Id
                           FROM WorkOrder];
        FSL_CL_LaunchInsite.getjobordernumber(objWO.id);
        Test.stopTest();
    }
    
    private static testmethod void validateCheckAsset() {
        createData();
        Test.startTest();
        
        Asset objAsset = [SELECT Id,Name
                          FROM Asset];
        Account objAccount = [SELECT Id 
                              FROM Account];
        workorder objwo = [SELECT Id
                           FROM WorkOrder];
        FSL_CL_LaunchInsite.checkAsset(objAsset.Name,objAccount.Id,objWO.id);
      
        Test.stopTest();
    }
    private static testmethod void validateCheckAsset2() {
        createData();
        Test.startTest();
        Asset objAsset = [SELECT Id,Name
                          FROM Asset];
        
        Account objAccount = [SELECT Id 
                              FROM Account];
        workorder objwo = [SELECT Id
                           FROM WorkOrder];
        FSL_CL_LaunchInsite.checkAsset('',objAccount.Id,'');
        Test.stopTest();
    }
    
    private static testmethod void validateGetWorkOrderData() {
        
        createData();
        Test.startTest();
        
        workorder objwo = [SELECT Id,AssetId
                           FROM WorkOrder];
            FSL_CL_LaunchInsite.getWorkOrderData(objWO.id);
        Test.stopTest();
    }
     private static testmethod void validateGetWorkOrderData2() {
        
        createData();
        Test.startTest();
         Asset objAst = [SELECT Id,Name
                          FROM Asset];
       objAst.Name='23234324';
         update objAst;
        workorder objwo = [SELECT Id,AssetId
                           FROM WorkOrder];
       objwo.ESN_Insite__c = '79799702';
         update objwo;
            FSL_CL_LaunchInsite.getWorkOrderData(objWO.id);
        Test.stopTest();
    }
    private static testmethod void validateGetWorkOrderData3() {
        
        createData();
        Test.startTest();
        workorder objwo = [SELECT Id,AssetId
                           FROM WorkOrder];
        objwo.AssetId = null;
         update objwo;
        FSL_CL_LaunchInsite.getWorkOrderData(objWO.id);
        Test.stopTest();
    }
    
    private static testmethod void validateCheckCountFaultcode() {
        createData();
        Test.startTest();
        workorder objwo = [SELECT Id
                           FROM WorkOrder];
        FSL_CL_LaunchInsite.checkCountFaultcode(objWO.id);
        Test.stopTest();
    }
    private static testmethod void validateCaptureFaultCodeAuditTrack() {
        createData();
        Test.startTest();
        workorder objwo = [SELECT Id
                           FROM WorkOrder];
        FSL_CL_LaunchInsite.captureFaultCodeAuditTrack(objWO.id);
        Test.stopTest();
    }
    
    private static testmethod void validateGetFaultCodes() {
        createData();
        Test.startTest();
        workorder objwo = [SELECT Id
                           FROM WorkOrder];
        FSL_CL_LaunchInsite.getFaultCodes(objwo.Id);
        Test.stopTest();
    }
    private static testmethod void validateCaptureLaunchInsiteAuditTrack() {
        createData();
        Test.startTest();
        workorder objwo = [SELECT Id
                           FROM WorkOrder];
        FSL_CL_LaunchInsite.captureLaunchInsiteAuditTrack(objWO.id);
        Test.stopTest();
    }
    private static testmethod void validateHidetakecontrol() {
        createData();   
        Test.startTest();
        workorder objwo = [SELECT Id 
                           FROM WorkOrder];
        FSL_CL_LaunchInsite.hidetakecontrol(objWO.id);
        FSL_CL_LaunchInsite.getSolutionsForFTR(objWO.id);
        Test.stopTest();
    }
}