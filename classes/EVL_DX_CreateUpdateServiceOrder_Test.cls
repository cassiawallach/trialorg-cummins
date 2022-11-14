// By priyanka for VGRS2-601 cvrg increase
// Comment for code Deployment Adam
@IsTest
public class EVL_DX_CreateUpdateServiceOrder_Test {
    
    
    @isTest
    static void testSORequest() {
       // String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": "", "SPCode": "29550"},"DataArea": {"SPCode": "29550","ServiceOrderNumber": "12","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "1234","ProductHours": "12.5","ProductMileage": "123","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "2021-02-02","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
       String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "12","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""}]}}';
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('WWSPS').getRecordTypeId();
        
        List<WorkOrder> woList = new List<WorkOrder>();
        
        Account acc = new Account();
        acc.IAM_Service_Provider_Code__c = '29550';
        acc.Name = 'test';
        acc.RecordTypeId = accRecTypeId;
        insert acc;
        acc.IsPartner=true;
        update acc;
        Asset ast = new Asset();
        ast.Name = '79635341';
        ast.Warranty_Start_Date__c = Date.today();
        ast.Make__c = 'Test';
        ast.Model__c = 'Test Model';

        ast.VIN__c = '2ST55SF09FS285';
        // ast.Type_PSN__c='Engines-79635341';
        insert ast;
        
        WorkOrder wo = new WorkOrder();
        wo.Shop_Work_Order__c = '75148';
        wo.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo.AccountId = acc.Id;
        wo.EVL_Customer__c = 'Test';
        wo.EVL_Stage__c = 'Intake';
        wo.Make__c = 'AUTOCAR12';
        wo.Model__c = 'Test2';
        wo.RecordTypeId = recTypeId;
        wo.AssetId = ast.Id;
        wo.Type__c = 'Dealer';
        wo.Scheduled__c = true;
        wo.CreatedDate = system.now().addDays(-29);
        wo.Available_for_Service__c = system.now().addDays(10);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.Status = 'Intake';
        woList.add(wo);
        insert woList;
         CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        JO.CSS_Job_Location_Code__c='03742-03742';
        update JO;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
         solcomp.name='TRP 2258';
        solcomp.EVL_DX_Service_Order__c=wo.id;
        insert solcomp;
        
        CSS_JobEventTemporary__c servHistCreate = new CSS_JobEventTemporary__c();
        servHistCreate.Name = '54357';
      //  servHistCreate.EVL_Service_Order__c = woList[0].id;
        servHistCreate.Key__c = 'Dealer_DataExchange - '+ '00015554';
        servHistCreate.Attribute1__c = 'Name';
        servHistCreate.Attribute2__c = 'ISX15 CM2350 X101';
        servHistCreate.Attribute4__c = 'Test';
        servHistCreate.Attribute5__c = '145';
        servHistCreate.Attribute13__c = system.now();
        servHistCreate.Attribute6__c = '8878';
        servHistCreate.Attribute7__c = 'Miles';
        servHistCreate.Attribute3__c = '02466-29550';
        insert servHistCreate;
        /* WorkOrder wo1 = new WorkOrder();
        //wo1.Id = wo.Id;
        wo1.Shop_Work_Order__c = '75148';
        wo1.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo1.AccountId = acc.Id;
        wo1.EVL_Customer__c = 'Test';
        wo1.EVL_Stage__c = 'Intake';
        wo1.Make__c = 'AUTOCAR12';
        wo1.Model__c = 'Test2';
        wo1.Type__c = 'Dealer';
        wo1.AssetId = ast.Id;
        wo1.Scheduled__c = true;
        wo1.Application__c = '130 - AUTOMOTIVE';
        wo1.Status = 'Triage & Diagnosis';
        woList.add(wo1);
        insert woList; */
        
        //  woList[0].Shop_Work_Order__c = '3333';
        // update woList;
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        EVL_DX_CreateUpdateServiceOrder.doPostOperation();
        EVL_DX_SORequestWrapper.DataArea st = new EVL_DX_SORequestWrapper.DataArea();
        Test.stopTest();
    }
    @isTest
    static void testSORequest_Neg1() {
       // String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": "", "SPCode": "29550"},"DataArea": {"SPCode": "29550","ServiceOrderNumber": "12","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "1234","ProductHours": "12.5","ProductMileage": "123","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "2021-02-02","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
       String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "12","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""}]}}';
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('WWSPS').getRecordTypeId();
        
        List<WorkOrder> woList = new List<WorkOrder>();
        
        Account acc = new Account();
        acc.IAM_Service_Provider_Code__c = '29550';
        acc.Name = 'test';
        acc.RecordTypeId = accRecTypeId;
        insert acc;
        acc.IsPartner=true;
        update acc;
        Asset ast = new Asset();
        ast.Name = '79635341';
        //ast.Warranty_Start_Date__c = Date.today();
        ast.Make__c = 'Test';
        ast.Model__c = 'Test Model';
        ast.VIN__c = '2ST55SF09FS285';
        // ast.Type_PSN__c='Engines-79635341';
        insert ast;
        
        WorkOrder wo = new WorkOrder();
        wo.Shop_Work_Order__c = '75148';
        wo.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo.AccountId = acc.Id;
        wo.EVL_Customer__c = 'Test';
        wo.EVL_Stage__c = 'Intake';
        wo.Make__c = 'AUTOCAR12';
        wo.Model__c = 'Test2';
        wo.RecordTypeId = recTypeId;
        wo.AssetId = ast.Id;
        wo.Type__c = 'Dealer';
        wo.Scheduled__c = true;
        wo.CreatedDate = system.now().addDays(-29);
        wo.Available_for_Service__c = system.now().addDays(10);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.Status = 'Intake';
        woList.add(wo);
        insert woList;
         CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        JO.CSS_Job_Location_Code__c='03742-03742';
        update JO;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
         solcomp.name='TRP 2258';
        solcomp.EVL_DX_Service_Order__c=wo.id;
        insert solcomp;
        
        CSS_JobEventTemporary__c servHistCreate = new CSS_JobEventTemporary__c();
        servHistCreate.Name = '54357';
      //  servHistCreate.EVL_Service_Order__c = woList[0].id;
        servHistCreate.Key__c = 'Dealer_DataExchange - '+ '00015554';
        servHistCreate.Attribute1__c = 'Name';
        servHistCreate.Attribute2__c = 'ISX15 CM2350 X101';
        servHistCreate.Attribute4__c = 'Test';
        servHistCreate.Attribute5__c = '145';
        servHistCreate.Attribute13__c = system.now();
        servHistCreate.Attribute6__c = '8878';
        servHistCreate.Attribute7__c = 'Miles';
        servHistCreate.Attribute3__c = '02466-29550';
        insert servHistCreate;
        /* WorkOrder wo1 = new WorkOrder();
        //wo1.Id = wo.Id;
        wo1.Shop_Work_Order__c = '75148';
        wo1.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo1.AccountId = acc.Id;
        wo1.EVL_Customer__c = 'Test';
        wo1.EVL_Stage__c = 'Intake';
        wo1.Make__c = 'AUTOCAR12';
        wo1.Model__c = 'Test2';
        wo1.Type__c = 'Dealer';
        wo1.AssetId = ast.Id;
        wo1.Scheduled__c = true;
        wo1.Application__c = '130 - AUTOMOTIVE';
        wo1.Status = 'Triage & Diagnosis';
        woList.add(wo1);
        insert woList; */
        
        //  woList[0].Shop_Work_Order__c = '3333';
        // update woList;
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        EVL_DX_CreateUpdateServiceOrder.doPostOperation();
        EVL_DX_SORequestWrapper.DataArea st = new EVL_DX_SORequestWrapper.DataArea();
        Test.stopTest();
    }
    @isTest
    static void testSORequest_Neg() {
       // String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": "", "SPCode": "29550"},"DataArea": {"SPCode": "29550","ServiceOrderNumber": "12","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "1234","ProductHours": "12.5","ProductMileage": "123","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "2021-02-02","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('WWSPS').getRecordTypeId();
        
        List<WorkOrder> woList = new List<WorkOrder>();
        
        Account acc = new Account();
        acc.IAM_Service_Provider_Code__c = '29550';
        acc.Name = 'test';
        acc.RecordTypeId = accRecTypeId;
        insert acc;
        acc.IsPartner=true;
        update acc;
        Asset ast = new Asset();
        ast.Name = '79635241';
        ast.Warranty_Start_Date__c = Date.today();
        ast.Make__c = 'Test';
        ast.Model__c = 'Test Model';
       ast.VIN__c = '2ST55SF09FS285';
        
        // ast.Type_PSN__c='Engines-79635341';
        insert ast;
        
        WorkOrder wo = new WorkOrder();
        wo.Shop_Work_Order__c = '75148';
        wo.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo.AccountId = acc.Id;
        wo.EVL_Customer__c = 'Test';
        wo.EVL_Stage__c = 'Intake';
        wo.Make__c = 'AUTOCAR12';
        wo.Model__c = 'Test2';
        wo.RecordTypeId = recTypeId;
        wo.AssetId = ast.Id;
        wo.Type__c = 'Dealer';
        wo.Scheduled__c = true;
        wo.CreatedDate = system.now().addDays(-29);
        wo.Available_for_Service__c = system.now().addDays(10);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.Status = 'Intake';
        woList.add(wo);
        insert woList;
        WorkOrder woObj = [Select Id, WorkOrderNumber from WorkOrder where Id =: woList[0].Id];
        String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "'+woObj.WorkOrderNumber+'","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""}]}}';
         CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        JO.CSS_Job_Location_Code__c='03742-03742';
        update JO;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
         solcomp.name='TRP 2258';
        solcomp.EVL_DX_Service_Order__c=wo.id;
        insert solcomp;
        
        CSS_JobEventTemporary__c servHistCreate = new CSS_JobEventTemporary__c();
        servHistCreate.Name = '54357';
      //  servHistCreate.EVL_Service_Order__c = woList[0].id;
        servHistCreate.Key__c = 'Dealer_DataExchange - '+ '00015554';
        servHistCreate.Attribute1__c = 'Name';
        servHistCreate.Attribute2__c = 'ISX15 CM2350 X101';
        servHistCreate.Attribute4__c = 'Test';
        servHistCreate.Attribute5__c = '145';
        servHistCreate.Attribute13__c = system.now();
        servHistCreate.Attribute6__c = '8878';
        servHistCreate.Attribute7__c = 'Miles';
        servHistCreate.Attribute3__c = '02466-29550';
        insert servHistCreate;
        /* WorkOrder wo1 = new WorkOrder();
        //wo1.Id = wo.Id;
        wo1.Shop_Work_Order__c = '75148';
        wo1.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo1.AccountId = acc.Id;
        wo1.EVL_Customer__c = 'Test';
        wo1.EVL_Stage__c = 'Intake';
        wo1.Make__c = 'AUTOCAR12';
        wo1.Model__c = 'Test2';
        wo1.Type__c = 'Dealer';
        wo1.AssetId = ast.Id;
        wo1.Scheduled__c = true;
        wo1.Application__c = '130 - AUTOMOTIVE';
        wo1.Status = 'Triage & Diagnosis';
        woList.add(wo1);
        insert woList; */
        
        //  woList[0].Shop_Work_Order__c = '3333';
        // update woList;
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        EVL_DX_CreateUpdateServiceOrder.doPostOperation();
        EVL_DX_SORequestWrapper.DataArea st = new EVL_DX_SORequestWrapper.DataArea();
        Test.stopTest();
    }
	@isTest
    static void testSORequest2() {
       // String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": "", "SPCode": "29550"},"DataArea": {"SPCode": "29550","ServiceOrderNumber": "12","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "1234","ProductHours": "12.5","ProductMileage": "123","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "2021-02-02","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
       String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "TRP 225","CampaignsATCsDataType": ""}]}}';
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('WWSPS').getRecordTypeId();
        
        List<WorkOrder> woList = new List<WorkOrder>();
        
        Account acc = new Account();
        acc.IAM_Service_Provider_Code__c = '29550';
        acc.Name = 'test';
        acc.RecordTypeId = accRecTypeId;
        insert acc;
        acc.IsPartner=true;
        update acc;
        
        
        Asset ast = new Asset();
        ast.Name = '79635341';
        ast.Warranty_Start_Date__c = Date.today();
        ast.Make__c = 'Test';
        ast.Model__c = 'Test Model';
        ast.VIN__c = '2ST55SF09FS285';
        
        // ast.Type_PSN__c='Engines-79635341';
        insert ast;
        
        WorkOrder wo = new WorkOrder();
        wo.Shop_Work_Order__c = '75148';
        wo.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo.AccountId = acc.Id;
        wo.EVL_Customer__c = 'Test';
        wo.EVL_Stage__c = 'Intake';
        wo.Make__c = 'AUTOCAR12';
        wo.Model__c = 'Test2';
        wo.RecordTypeId = recTypeId;
        wo.AssetId = ast.Id;
        wo.Type__c = 'Dealer';
        wo.Scheduled__c = true;
        wo.CreatedDate = system.now().addDays(-29);
        wo.Available_for_Service__c = system.now().addDays(10);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.Status = 'Intake';
        woList.add(wo);
        insert woList;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        JO.CSS_Job_Location_Code__c='03742-03742';
        update JO;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
         solcomp.name='TRP 225';
        solcomp.EVL_DX_Service_Order__c=wo.id;
        insert solcomp;
        
        CSS_JobEventTemporary__c servHistCreate = new CSS_JobEventTemporary__c();
        servHistCreate.Name = '54357';
      //  servHistCreate.EVL_Service_Order__c = woList[0].id;
        servHistCreate.Key__c = 'Dealer_DataExchange - '+ '00015554';
        servHistCreate.Attribute1__c = 'Name';
        servHistCreate.Attribute2__c = 'ISX15 CM2350 X101';
        servHistCreate.Attribute4__c = 'Test';
        servHistCreate.Attribute5__c = '145';
        servHistCreate.Attribute13__c = system.now();
        servHistCreate.Attribute6__c = '8878';
        servHistCreate.Attribute7__c = 'Miles';
        servHistCreate.Attribute3__c = '02466-29550';
        insert servHistCreate;
        /* WorkOrder wo1 = new WorkOrder();
        //wo1.Id = wo.Id;
        wo1.Shop_Work_Order__c = '75148';
        wo1.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo1.AccountId = acc.Id;
        wo1.EVL_Customer__c = 'Test';
        wo1.EVL_Stage__c = 'Intake';
        wo1.Make__c = 'AUTOCAR12';
        wo1.Model__c = 'Test2';
        wo1.Type__c = 'Dealer';
        wo1.AssetId = ast.Id;
        wo1.Scheduled__c = true;
        wo1.Application__c = '130 - AUTOMOTIVE';
        wo1.Status = 'Triage & Diagnosis';
        woList.add(wo1);
        insert woList; */
        
        //  woList[0].Shop_Work_Order__c = '3333';
        // update woList;
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        EVL_DX_CreateUpdateServiceOrder.doPostOperation();
        EVL_DX_SORequestWrapper.DataArea st = new EVL_DX_SORequestWrapper.DataArea();
        Test.stopTest();
    }  
    @isTest
    static void testSORequest3() {
       // String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": "", "SPCode": "29550"},"DataArea": {"SPCode": "29550","ServiceOrderNumber": "12","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "1234","ProductHours": "12.5","ProductMileage": "123","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "2021-02-02","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
       String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "796341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "TRP 225","CampaignsATCsDataType": ""}]}}';
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('WWSPS').getRecordTypeId();
        
        List<WorkOrder> woList = new List<WorkOrder>();
        
        Account acc = new Account();
        acc.IAM_Service_Provider_Code__c = '29550';
        acc.Name = 'test';
        acc.RecordTypeId = accRecTypeId;
        insert acc;
        acc.IsPartner=true;
        update acc;
        
        
        Asset ast = new Asset();
        ast.Name = '79635141';
        ast.Warranty_Start_Date__c = Date.today();
        ast.Make__c = 'Test';
        ast.Model__c = 'Test Model';
        ast.VIN__c = '2ST55SF09FS285';
        // ast.Type_PSN__c='Engines-79635341';
        insert ast;
        
        WorkOrder wo = new WorkOrder();
        wo.Shop_Work_Order__c = '75148';
        wo.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo.AccountId = acc.Id;
        wo.EVL_Customer__c = 'Test';
        wo.EVL_Stage__c = 'Intake';
        wo.Make__c = 'AUTOCAR12';
        wo.Model__c = 'Test2';
        wo.RecordTypeId = recTypeId;
        wo.AssetId = ast.Id;
        wo.Type__c = 'Dealer';
        wo.Scheduled__c = true;
        wo.CreatedDate = system.now().addDays(-29);
        wo.Available_for_Service__c = system.now().addDays(10);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.Status = 'Intake';
        woList.add(wo);
        insert woList;
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(true);
        JO.Account__c=acc.id;
        JO.CSS_Job_Location_Code__c='03742-03742';
        update JO;
        
        CSS_Solutions__c sol = CSS_TestData.createSolutions(true,JO.Id);
        List<CSS_Solution_Component__c>lstsolcomp = new List<CSS_Solution_Component__c>();
        CSS_Solution_Component__c solcomp = CSS_TestData.createSRT(false,JO.Id,sol.Id);
        solcomp.AccountCodeEdit__c = 'EMISSIONS WARRANTY 70';
        solcomp.CoveredPartsQty__c = '100';
        solcomp.AccountCode__c     = 'DC';
        solcomp.AccountCodeType__c = 'CAP-Customized Assurance Plan';
        solcomp.Selected_Component__c = true;
        solcomp.CoveredOCAmount__c = '9999999';
        solcomp.Fail_Code_Editable__c = 'Intake Manifold Pressure/Temperature Sensor-EEBT';
        solcomp.Service_Job__c=jo.Id;
        solcomp.Solutions__c=sol.Id;
         solcomp.name='TRP 225';
        solcomp.EVL_DX_Service_Order__c=wo.id;
        insert solcomp;
        
        CSS_JobEventTemporary__c servHistCreate = new CSS_JobEventTemporary__c();
        servHistCreate.Name = '54357';
      //  servHistCreate.EVL_Service_Order__c = woList[0].id;
        servHistCreate.Key__c = 'Dealer_DataExchange - '+ '00015554';
        servHistCreate.Attribute1__c = 'Name';
        servHistCreate.Attribute2__c = 'ISX15 CM2350 X101';
        servHistCreate.Attribute4__c = 'Test';
        servHistCreate.Attribute5__c = '145';
        servHistCreate.Attribute13__c = system.now();
        servHistCreate.Attribute6__c = '8878';
        servHistCreate.Attribute7__c = 'Miles';
        servHistCreate.Attribute3__c = '02466-29550';
        insert servHistCreate;
        /* WorkOrder wo1 = new WorkOrder();
        //wo1.Id = wo.Id;
        wo1.Shop_Work_Order__c = '75148';
        wo1.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo1.AccountId = acc.Id;
        wo1.EVL_Customer__c = 'Test';
        wo1.EVL_Stage__c = 'Intake';
        wo1.Make__c = 'AUTOCAR12';
        wo1.Model__c = 'Test2';
        wo1.Type__c = 'Dealer';
        wo1.AssetId = ast.Id;
        wo1.Scheduled__c = true;
        wo1.Application__c = '130 - AUTOMOTIVE';
        wo1.Status = 'Triage & Diagnosis';
        woList.add(wo1);
        insert woList; */
        
        //  woList[0].Shop_Work_Order__c = '3333';
        // update woList;
        Test.startTest();
        RestRequest request = new RestRequest();
        request.requestUri ='https://cs13.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueof(myJSON);
        
        RestContext.request = request;
        RestContext.response = new RestResponse();
        EVL_DX_CreateUpdateServiceOrder.doPostOperation();
        EVL_DX_SORequestWrapper.DataArea st = new EVL_DX_SORequestWrapper.DataArea();
        Test.stopTest();
    }
    @isTest
    static void testSORequestUpdate() {
        //String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": ""},"DataArea": {"SPCode": "","PSNorESN": "79635341","VIN": "","Contact": "","ApplicationCode":"130 - AUTOMOTIVE","ServiceOrderNumber": "","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "1234","ProductHours": "","ProductMileage": "","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
       String myJSON = '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
        Id recTypeId = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        Id accRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('WWSPS').getRecordTypeId();
        
        List<WorkOrder> woInfo = new List<WorkOrder>();
        
        Account acc = new Account();
        acc.IAM_Service_Provider_Code__c = '29550';
        acc.Name = 'test';
        acc.RecordTypeId = accRecTypeId;
        insert acc;
        
        Asset ast = new Asset();
        ast.Name = '79635341';
        ast.Warranty_Start_Date__c = Date.today();
        ast.Make__c = 'Test';
        ast.Model__c = 'Test Model';
       // ast.VIN__c = '2ST55SF09FS285';
        
        
        
        insert ast;
        
        WorkOrder wo = new WorkOrder();
        wo.Shop_Work_Order__c = '75148';
        wo.CSS_Hours__c = 12.5;
        wo.Mileage__c = 123;
        wo.AccountId = acc.Id;
        wo.EVL_Customer__c = 'Test';
        wo.EVL_Stage__c = 'Triage & Diagnosis';
        wo.Make__c = 'AUTOCAR12';
        wo.Model__c = 'Test2';
        wo.AssetId = ast.Id;
        wo.Type__c = 'Dealer';
        wo.RecordTypeId = recTypeId;
        wo.Scheduled__c = true;
        wo.CreatedDate = system.now().addDays(-29);
        wo.Available_for_Service__c = system.now().addDays(10);
        wo.Application__c = '130 - AUTOMOTIVE';
        wo.Status = 'Triage & Diagnosis';
        woInfo.add(wo);
        insert woInfo;
        
        List<workorder> woInfo1 = new List<workorder>();
        List<CSS_JobEventTemporary__c> temp = new List<CSS_JobEventTemporary__c>();

        WorkOrder wo1 = new WorkOrder();
        wo1.Id = woInfo[0].Id;
        wo1.Shop_Work_Order__c = '75148';
        wo1.CSS_Hours__c = 12.5;
        wo1.Mileage__c = 123;
        wo1.AccountId = acc.Id;
        wo1.EVL_Customer__c = 'Test';
        wo1.EVL_Stage__c = 'Triage & Diagnosis';
        wo1.Make__c = 'AUTOCAR12';
        wo1.Model__c = 'Test2';
        wo1.Type__c = 'Dealer';
        wo1.RecordTypeId = recTypeId;
        wo1.AssetId = ast.Id;
        wo1.Scheduled__c = true;
        wo1.Application__c = '130 - AUTOMOTIVE';
        wo1.Status = 'Triage & Diagnosis';
        woInfo1.add(wo1);
        // insert woList;
        // insert woInfo1;
        
        CSS_JobEventTemporary__c servHistCreate = new CSS_JobEventTemporary__c();
        servHistCreate.Name = '54357';
      //  servHistCreate.EVL_Service_Order__c = woInfo1[0].id;
        servHistCreate.ESN__c = '79635341';
        servHistCreate.Key__c = 'Dealer_DataExchange - '+ '00015554';
        servHistCreate.Attribute2__c = 'ISX15 CM2350 X101';
        servHistCreate.Attribute4__c = 'Test';
        servHistCreate.Attribute5__c = '145';
        servHistCreate.Attribute13__c = system.now();
        servHistCreate.Attribute6__c = '8878';
        servHistCreate.Attribute7__c = 'Miles';
        servHistCreate.Attribute3__c = '02466-29550';
        temp.add(servHistCreate);
        insert servHistCreate;
        
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
        fcode.Service_Order__c = woInfo[0].id;
        insert fcode;
        
        woInfo1[0].Shop_Work_Order__c = '3333';
        update woInfo1;
        
        temp[0].Name = '25555';
        update temp;
        Test.startTest();
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestUri ='https://cs13.salesforce.com/services/apexrest/DataXSOCreateUpdate/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(getRequestBody2());
        
      //  RestContext.request = req;
      //  RestContext.response = res;
      //  EVL_DX_CreateUpdateServiceOrder.doPostOperation();
       // EVL_DX_SORequestWrapper obj = EVL_DX_SORequestWrapper.parse(getRequestBody());
        
        RestContext.request = req;
        RestContext.response = res;
        EVL_DX_CreateUpdateServiceOrder.doPostOperation();
        EVL_DX_SORequestWrapper obj1 = EVL_DX_SORequestWrapper.parse(getRequestBody2());
        Test.stopTest();
    }
    
    public static String getRequestBody() {
        String workOrdNum = [SELECT Id, WorkOrderNumber FROM WorkOrder LIMIT 1][0].WorkOrderNumber;
       return '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "'+workOrdNum+'","SPCode": "","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "N","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
       // / return '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": ""},"DataArea": {"SPCode": "29550","PSNorESN": "79635341","VIN": "","Contact": "","ApplicationCode":"130 - AUTOMOTIVE","ServiceOrderNumber": "'+workOrdNum+'","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "","ProductHours": "12.5","ProductMileage": "123","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "2019-02-10","FailureDate": "2021-02-02","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
    }
    public static String getRequestBody1() {
        // String workOrdNum = [SELECT Id, WorkOrderNumber FROM WorkOrder LIMIT 1][0].WorkOrderNumber;
        return '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "29550","UserId": ""},"DataArea": {"ServiceOrderNumber": "","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';

        // return '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": ""},"DataArea": {"SPCode": "29550","PSNorESN": "79635341","VIN": "","Contact": "","ApplicationCode":"130 - AUTOMOTIVE",ServiceOrderNumber": "","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "","ProductHours": "12.5","ProductMileage": "123","MileageMeasure": "Miles","Unit": "","Make": "","Model": "","WarrantyStartDate": "2019-02-10","FailureDate": "2021-02-02","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
    }
    public static String getRequestBody2() {
        String workOrdNum = [SELECT Id, WorkOrderNumber FROM WorkOrder LIMIT 1][0].WorkOrderNumber;
        return '{"Header": {"ServiceName": "DataXSOCreateUpdate","ToolID": "<Name of Dealer System>","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","SPCode": "","UserId": ""},"DataArea": {"ServiceOrderNumber": "'+workOrdNum+'","SPCode": "29550","SERVICEHIST": [{"Source": "123","JobDate": "2020-01-06","CustomerName": "Test","ShopWO": "WO9876","ServiceModelNM": "ISB_CM2150","ServiceLocation": "02466-29550","WorkSummary": "checking for parts","FaultCodeSymptom": "Leak","Mileage": "20000","MileageMeasure": "Miles"}],"CUST_DATA": {"CustomerName": "TestCustomer","Location": "TestLocation","ShopWO": "WO9876", "Contact": "","CustomerComplaint": "","JobCreatedDate": "2020-01-06","AvailableForService": "2020-01-06"},"UNIT_DATA": {"PSN": "79635341","UnitNumber": "638839","Application": "Automotive","ServiceModel": "ISB_CM2150","Make": "TATA","Model": "NOVUS","VIN": "2ST55SF09FS285","WarrStartDate": "2017-01-06","BeforeInService": "FALSE","FailureDate": "2017-01-06","ProductHours": "","ProductMileage": "5446","MileageMeasure": "Miles"},"CampaignDetails": [{"CampaignsATCsDataFlag": "Y","CampaignsATCsDataNumber": "TRP 2258","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';

        // return '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": ""},"DataArea": {"SPCode": "","PSNorESN": "79635341","VIN": "","Contact": "","ApplicationCode":"130 - AUTOMOTIVE","ServiceOrderNumber": "'+workOrdNum+'","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "12345","ProductHours": "12.5","ProductMileage": "123","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "2021-02-02","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "N","CampaignsATCsDataNumber": "TRP 2257","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
    }
    
    /* public static String getRequestBody3() {
    	String workOrdNum = [SELECT Id, WorkOrderNumber FROM WorkOrder LIMIT 1][0].WorkOrderNumber;
    	return '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "<DealerName>","TargetId": "Guidanz","UserId": ""},"DataArea": {"SPCode": "29550","PSNorESN": "100008","VIN": "","Contact": "","ApplicationCode":"130 - AUTOMOTIVE","ServiceOrderNumber": "'+workOrdNum+'","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "12345","ProductHours": "","ProductMileage": "","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
    }
    public static String getRequestBody4() {
    	String workOrdNum = [SELECT Id, WorkOrderNumber FROM WorkOrder LIMIT 1][0].WorkOrderNumber;
    	return '{"Header": {"ServiceName": "DataXSOCreateUpdate","ServiceVersion": "1.0","SenderId": "","TargetId": "Guidanz","UserId": ""},"DataArea": {"SPCode": "29550","PSNorESN": "100008","VIN": "","Contact": "","ApplicationCode":"130 - AUTOMOTIVE","ServiceOrderNumber": "'+workOrdNum+'","Customer": "Test","CustomerComplaint": "","ShopWorkOrder": "12345","ProductHours": "","ProductMileage": "","MileageMeasure": "","Unit": "","Make": "","Model": "","WarrantyStartDate": "","FailureDate": "","ApplicationCode ": "","BeforeInService": "","CampaignDetails": [{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""},{"CampaignsATCsDataFlag": "","CampaignsATCsDataNumber": "","CampaignsATCsDataType": ""}]}}';
    } */
}