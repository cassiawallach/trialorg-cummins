/*
*Author: Sruthi
*Description: Test class for EVL_TDSController class
//Comment to check coverage-Piyush 1/5/22
*/
@isTest
public class EVL_TDSController_Test {

    static testmethod void testController(){
        
        WorkOrder wo = new WorkOrder();
        insert wo;
        
        EVL_TDSController.fetchWORecord(wo.Id);
    }
    
    static testmethod void testTakeControl(){
        
        WorkOrder wo = new WorkOrder();
        insert wo;
        
        EVL_TDSController.fetchTakeControl(wo.Id);
    }
    
    static testmethod void testTakeControl1(){
        
        WorkOrder wo = new WorkOrder();
        wo.User__c = userInfo.getUserId();
        insert wo;
        
        EVL_TDSController.fetchTakeControl(wo.Id);
    }
        
    static testmethod void recordStatus(){
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accRecId;
        objAccount.Name = 'Test Account';
        objAccount.FSL_ERP_Customer_Code__c = '7103507';
        objAccount.BillingStreet = '400 BROWN ST';
        objAccount.BillingCity = 'Columbus';
        objAccount.BillingState = 'Indiana';
        objAccount.BillingCountry = 'United States';
        objAccount.BillingPostalCode = '47201';
        insert objAccount;
        
        Asset objAsset = new Asset();
        objAsset.Name = '23234324';
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Make__c ='make';
        objAsset.Model__c ='model';
        insert objAsset;
        
        WorkOrder objWorkOrder = new WorkOrder();
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c ='Troubleshooting Complete' ;
        objWorkOrder.Make__c ='Test';
        objWorkOrder.Model__c ='Test';
        objWorkOrder.Type__c = 'Dealer';
       // objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.RecordTypeId = recTypeId;
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c = 'Troubleshooting Complete';
        insert objWorkOrder;
        
        EVL_TDSController.recordStatus(objWorkOrder.Id);
    }
    
     static testmethod void fetchFCData(){
        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
         Account objAccount = new Account();
         objAccount.RecordTypeId = accRecId;
         objAccount.Name = 'Test Account';
         objAccount.FSL_ERP_Customer_Code__c = '7103507';
         objAccount.BillingStreet = '400 BROWN ST';
         objAccount.BillingCity = 'Columbus';
         objAccount.BillingState = 'Indiana';
         objAccount.BillingCountry = 'United States';
         objAccount.BillingPostalCode = '47201';
         insert objAccount;
        
        Asset objAsset = new Asset();
        objAsset.Name = '23234324';
        objAsset.Type_PSN__c = 'Engines-79788868';
        objAsset.Make__c ='make';
        objAsset.Model__c ='model';
        insert objAsset;
        
        WorkOrder objWorkOrder = new WorkOrder();
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c ='Troubleshooting Complete' ;
        objWorkOrder.Make__c ='Test';
        objWorkOrder.Model__c ='Test';
        objWorkOrder.Type__c = 'Dealer';
       // objWorkOrder.Process_Step__c = 'Intake';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.AssetId = objAsset.Id;
        objWorkOrder.RecordTypeId = recTypeId;
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c = 'Troubleshooting Complete';
       // objWorkOrder.FaultCodeId__c = '123';
        insert objWorkOrder;
         
        FSL_Fault_Code__c cfc= new FSL_Fault_Code__c();
        cfc.Cummins_Fault_Code__c = '123';
        insert cfc;
        
        FSL_SPN_FMI__c spnfc= new FSL_SPN_FMI__c();
        spnfc.SPN__c ='3597-2';
        insert spnfc;
        
        FSL_PCode__c pfc= new FSL_PCode__c();
        pfc.CDS_ID__c='p008';
        insert pfc;
        
        CSS_Fault_Code__c fcode=new CSS_Fault_Code__c();
        fcode.Name=cfc.name;
        fcode.Type__c = 'Fault';
        fcode.Fault_Code_Type__c = '1';
        fcode.Service_Order__c = objWorkOrder.id;
        fcode.extfield__c = cfc.id+' '+objWorkOrder.id;
        insert fcode;
        
        CSS_Solutions__c sol = new CSS_Solutions__c();
        sol.Name='T00000690';
        sol.Solution_Title__c='Battery circuit fuse has open circuit test';
        sol.FSL_Solution_Position__c='1';
        sol.Diagnostic_Notes__c='Test';
        sol.Repair_Notes__c='Good';
        sol.Diagnostic_Response__c='Most likely the solution. Repair recommended.';
        sol.Repair_Response__c='Repair Successful.';
        sol.FaultCode__c=fcode.Id;
        sol.FSL_Service_Job__c=objWorkOrder.Id;
        sol.userTimestamp__c=datetime.now();
        insert sol;
         
        EVL_TDSController.fetchFCData(objWorkOrder.Id);
        EVL_TDSController.fetchFCSolData(objWorkOrder.Id);
        EVL_TDSController.fetchSolData(objWorkOrder.Id);
         EVL_TDSController.getUserDetails();
    }
    //Added by Shirisha 08/25/2022 ROAD-556
    static testmethod void fetchFTRTest(){
        
        Test.startTest();
        WorkOrder objWorkOrder = new WorkOrder();
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c ='Troubleshooting Complete' ;
        objWorkOrder.Make__c ='Test';
        objWorkOrder.Model__c ='Test';
        objWorkOrder.Type__c = 'Dealer';
        objWorkOrder.RecordTypeId = recTypeId;
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.Sub_Status__c = 'Troubleshooting Complete';
        insert objWorkOrder;
        
        Service_Order_Extension__c SOEobj = new Service_Order_Extension__c(FSL_ABRFlag__c = true, Service_Order_Id__c = objWorkOrder.Id);
        insert SOEobj;
        
        EVL_TDSController.fetchFTRFlag(objWorkOrder.Id);
        Test.stopTest();
        
    }
    
}