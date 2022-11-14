@isTest
public class EVL_FCServiceTable_Ctrl_Test {
    public static void createData(){
        Id recdtypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('SolutionRepair').getRecordTypeId();
        
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
        objAsset.Type_PSN__c = 'Engines-23234324';
        insert objAsset;
        
        Id DealerecTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        WorkOrder objWorkOrder = new WorkOrder();
        objWorkOrder.ServiceTerritoryId = objServiceTerritory.Id;
        objWorkOrder.Status = 'Intake';
        objWorkOrder.Process_Step__c = 'Repair';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.Type__c = 'Dealer';
        objWorkOrder.RecordTypeId = DealerecTypeId;
        insert objWorkOrder;
        
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name='123';
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = objWorkOrder.Id;
        //fcode.extfield__c = cfc.id+' '+objWorkOrder.id;
        insert fcode;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.FSL_Service_Job__c = objWorkOrder.Id;
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
        
        CSS_Solutions__c csol = new CSS_Solutions__c();
        csol.Name='T00000691';
        csol.Solution_Title__c='Battery circuit fuse has open circuit test';
        csol.FSL_Solution_Position__c='1.1';
        csol.Diagnostic_Notes__c='Test';
        csol.Repair_Notes__c='Good';
        csol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        csol.Repair_Response__c='Repair Successful.';
        csol.FaultCode__c=fcode.Id;
        csol.CSS_Nested_Solutions__c=sol.Id;
        csol.FSL_Service_Job__c=objWorkOrder.Id;
        insert csol;
        
        CSS_Solution_Component__c objSolutionComponent = new CSS_Solution_Component__c();
        objSolutionComponent.Name = 'Test Solution Component';
        //objSolutionComponent.Solutions__c = listSolutions[0].Id;
        insert objSolutionComponent;
    }
    
    public static testMethod void validateChangeRecord(){
        createData();
        Test.startTest();
        WorkOrder objobjWorkOrder = [SELECT Id FROM WorkOrder LIMIT 1];
        String tabName = 'Triage & Diagnosis';
        CSS_Fault_Code__c objFaultCode = [SELECT Id from CSS_Fault_Code__c LIMIT 1];
        EVL_FCServiceTable_Ctrl.changeRecord(objobjWorkOrder.Id,objFaultCode.Id, tabName);
        Test.stopTest();
        
    }
    public static testMethod void validateGetknowledge(){
        createData();
        Test.startTest();
        WorkOrder objobjWorkOrder = [SELECT Id FROM WorkOrder LIMIT 1];
        CSS_Fault_Code__c objFaultCode = [SELECT Id FROM CSS_Fault_Code__c LIMIT 1];
        CSS_Solutions__c objSolutions = [SELECT Id FROM  CSS_Solutions__c LIMIT 1];
        EVL_FCServiceTable_Ctrl.getknowledge(objSolutions.Id);
        Test.stopTest();
        
    }
    //adding comment as part of deployment
    public static testMethod void validateChangeSolRecord(){
        createData();
        Test.startTest();
        WorkOrder objWorkOrder = [SELECT Id FROM WorkOrder LIMIT 1];
        CSS_Fault_Code__c objFaultCode = [SELECT Id FROM CSS_Fault_Code__c LIMIT 1];
        CSS_Solutions__c csol = [SELECT Id,FSL_Solution_Position__c FROM  CSS_Solutions__c LIMIT 1];
        EVL_FCServiceTable_Ctrl.changesolRecord(objWorkOrder.Id, csol.Id);
        EVL_FCServiceTable_Ctrl.validateProductOnWO(objWorkOrder.Id);
        EVL_FCServiceTable_Ctrl.updateWO(objWorkOrder.Id,2,2);
        Test.stopTest();
    }
    
}