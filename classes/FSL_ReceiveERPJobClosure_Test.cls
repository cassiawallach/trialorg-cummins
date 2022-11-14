//Adding comment for deployment -- Akansha MV_688 8/25/2022
@isTest
    public class FSL_ReceiveERPJobClosure_Test {
	@isTest
    private static void testERPJobClosure() {
        Test.startTest();
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
        objWorkOrder.ESN_Insite__c = '79799702';
        objWorkOrder.Process_Step__c = 'Repair';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        insert objWorkOrder;
        
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/erpjobclosure';  //Request URL
        req.httpMethod = 'POST';
        
        req.requestBody = Blob.valueof(getRequestBody());
        RestContext.request = req;
        RestContext.response= res;
        
        FSL_ReceiveERPJobClosure.doPostOperation();
        System.debug(':::Response ='+res);
        System.debug(':::Response Body='+res.responseBody);
        System.debug(':::Response Status='+res.statusCode);
        
        
        req.requestBody = Blob.valueof(getRequestBodyForWorkOrderWithOpenTimeSheet()); 
        RestContext.request = req;
        RestContext.response= res;
        
        //FSL_ReceiveERPJobClosure.doPostOperation();
        
        Test.stopTest();
    }
	
	@isTest
	private static void testERPJobClosureForOpenTimeSheet() {
        
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
        objWorkOrder.Status = 'Triage & Diagnosis';
        objWorkOrder.ESN_Insite__c = '79799702';
        objWorkOrder.Process_Step__c = 'Repair';
        objWorkOrder.AccountId = objAccount.Id;
        objWorkOrder.WorkTypeId = objWorkType.Id;
        objWorkOrder.AssetId = objAsset.Id;
        insert objWorkOrder;
        
    	
    	FSL_Timesheet__c openTimeSheet = new FSL_Timesheet__c();
        openTimeSheet.Service_Order__c	= objWorkOrder.id;
    	openTimeSheet.RecordTypeId = Schema.SObjectType.FSL_Timesheet__c.getRecordTypeInfosByName().get('New Timesheet').getRecordTypeId();
    	openTimeSheet.Status__c	 = 'New';
    	openTimeSheet.Reason__c	 = 'Travel';
    	openTimeSheet.StartTime__c =System.now();
    	//openTimeSheet.EndTime__c = ;
        openTimeSheet.Resource_ERP__c= 'MoveX';
    	openTimeSheet.Billing_Type__c =  '110-INJURY';
        Test.startTest();
        insert openTimeSheet;
        Test.stopTest();
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        
        req.requestURI = '/services/apexrest/erpjobclosure';  //Request URL
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof(getRequestBodyForWorkOrderWithOpenTimeSheet());
        RestContext.request = req;
        RestContext.response= res;
        
      //  FSL_ReceiveERPJobClosure.doPostOperation();
        System.debug(':::Response ='+res);
        System.debug(':::Response Body='+res.responseBody);
        System.debug(':::Response Status='+res.statusCode);
   
        
        
    }    
    public static String getRequestBody() {
        String workOrdNum = [Select Id, WorkOrderNumber FROM WorkOrder][0].WorkOrderNumber;
        return '{'+
            '  \"Header\": {'+
            '    \"Sender\": {'+
            '      \"ServiceName\": \"sendBMSJobDeletion\",'+
            '      \"SenderID\": \"BMS\"'+
            '    },'+
            '    \"Target\": {'+
            '      \"TargetID\": \"CSS\"'+
            '    },'+
            '    \"Location\": {'+
            '      \"LocationID\": \"02400-02394\"'+
            '    }'+
            '  },'+
            '  \"DataArea\": {'+
            '    \"CSSJobId\": \"'+workOrdNum+'\",'+
            '    \"DistributorCode\": \"02400\",'+
            '    \"BranchCode\": \"02394\",'+
            '    \"CustomerCode\": \"C100002045\",'+
            '    \"OrderType\": \"WO/WOQT\",'+
            '    \"BMSReferenceNumber\": \"98687687\",'+
            '    \"Action\": \"DELETE\",'+
            '    \"Reason\": \"Job deleted in BMS.\"'+
            '  }'+
            '}';
    }
    public static String getRequestBodyForWorkOrderWithOpenTimeSheet() {
        String workOrdNum =  [Select Id, WorkOrderNumber FROM WorkOrder][0].WorkOrderNumber;
        return '{'+
            '  \"Header\": {'+
            '    \"Sender\": {'+
            '      \"ServiceName\": \"sendBMSJobDeletion\",'+
            '      \"SenderID\": \"BMS\"'+
            '    },'+
            '    \"Target\": {'+
            '      \"TargetID\": \"CSS\"'+
            '    },'+
            '    \"Location\": {'+
            '      \"LocationID\": \"02400-02394\"'+
            '    }'+
            '  },'+
            '  \"DataArea\": {'+
            '    \"CSSJobId\": \"'+workOrdNum+'\",'+
            '    \"DistributorCode\": \"02400\",'+
            '    \"BranchCode\": \"02394\",'+
            '    \"CustomerCode\": \"C100002045\",'+
            '    \"OrderType\": \"WO/WOQT\",'+
            '    \"BMSReferenceNumber\": \"98687687\",'+
            '    \"Action\": \"DELETE\",'+
            '    \"Reason\": \"Job deleted in BMS.\"'+
            '  }'+
            '}';
    }
}