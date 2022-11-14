@isTest
public class FSL_GetTimesheetStatus_Test {

    @testSetup
    static void dataSetup() {
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'Test';
        insert wType;
        
        
        FSL_Labor_Multiplier__c labMultiplier = new FSL_Labor_Multiplier__c();
        labMultiplier.Name='TIER B';
        insert labMultiplier;
        
        Asset  ast = new Asset();
        ast.Service_Model__c = 'ISL9 CM2350 L101';
        ast.Unit_Number__c = '1234';
        ast.Make__c = 'KENWORTH';
        ast.Model__c = 'T800';
        ast.Name = '79963830';
        ast.Unit_Type__c = 'EQ8349';
        ast.VIN__c = '1NKDX4TX6JJ180253';
        ast.Type_PSN__c = 'Engines-79963830';
        ast.Application_Description__c = 'AUTOMOTIVE';
        ast.Application_Code__c = '130';
        ast.Engine_Family__c    ='56'; 
        ast.Type__c = 'Engines';
        ast.Labor_Multiplier__c = labMultiplier.Id;
        insert ast;
        
        Asset  ast1 = new Asset();
        ast1.Service_Model__c = 'ISL9 CM2350 L101';
        ast1.Unit_Number__c = '1234';
        ast1.Make__c = 'KENWORTH';
        ast1.Model__c = 'T800';
        ast1.Name = '79963831';
        ast1.Unit_Type__c = 'EQ8349';
        ast1.VIN__c = '1NKDX4TX6JJ180253';
        ast1.Type_PSN__c = 'Engines-79963831';
        ast1.Application_Description__c = 'AUTOMOTIVE';
        ast1.Application_Code__c = '130';
        ast1.Engine_Family__c    ='56'; 
        ast1.Type__c = 'Engines';
        ast1.Labor_Multiplier__c = labMultiplier.Id;
        insert ast1;
        
        OperatingHours  oh = new OperatingHours ();
        oh.Name = 'new';
        oh.TimeZone = 'America/Chicago';
        insert oh;
        
        ServiceTerritory serTer1 = new ServiceTerritory();
        serTer1.Name = 'ST005 In Shop';
        serTer1.OperatingHoursId = oh.Id;
        serTer1.IsActive = true;
        serTer1.Location_Code__c = '03522-04893';
        serTer1.FSL_Service_Territory_Code__c = '04893';
        serTer1.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer1.Territory__c = 'AUSTRALIA';
        insert serTer1; 
        
        ServiceTerritory serTer = new ServiceTerritory();
        serTer.Name = 'ST001 Mobile';
        serTer.OperatingHoursId = oh.Id;
        serTer.IsActive = true;
        serTer.Location_Code__c = '03520';
        serTer.FSL_Service_Territory_Code__c = '04892';
        serTer.Region__c = 'AUSTRALIA/ NEW ZEALAND';
        serTer.Territory__c = 'AUSTRALIA';
        insert serTer;
        
        Case  cs = new Case();
        cs.Status = 'Triage & Diagnosis';
        //cs.Service_Territory__c = serTer.id;
        cs.AssetId = ast.id;
        cs.Priority = 'Medium';
        insert cs; 
        
        FSL_SubType__c subType = new FSL_SubType__c();
        subType.name = 'Test Sub Type';
        subType.Branch_Code__c =10;
        subType.Status__c='Active';
        insert subType;
        
        List<workorder> woInfo = new List<workorder>();
        workorder wo1 = new workorder();
        wo1.Status = 'Triage & Diagnosis';
        wo1.Process_Step__c = 'Triage & Diagnosis'; 
        wo1.Asset = ast1;
        wo1.Repair_Location__c = 'Mobile';
        wo1.EditComplaint__c = 'Testing';
        wo1.EditCause__c = 'Testing';
        wo1.EditCorrection__c = 'Testing';
        wo1.EditCoverage__c = 'Testing';
        wo1.ServiceTerritoryid = serTer.id;
        wo1.Case = cs;
        //wo1.sub_status__c = 'Troubleshooting Complete';
        //wo1.FSL_Additional_Email_Notifications__c='test@test.com';
        woInfo.add(wo1);
        
        insert woInfo;
        wo1.FSL_Sub_Type__c = subType.Id;
        wo1.Asset = ast1;
        update wo1;
        
        List<FSL_Additional_Sub_Type__c> ASTList = new List<FSL_Additional_Sub_Type__c>();
        FSL_Additional_Sub_Type__c ASType1 = new FSL_Additional_Sub_Type__c();
        ASType1.Service_Order__c = wo1.id;
        ASType1.Assignment_Number__c = '12345';
        ASType1.name = wo1.payer__c;
        ASType1.ERP_Job_Line_Number__c = '';
        // AST.Payer_Account__c = wo1.payer__c.split(':')[1];
        ASTList.add(ASType1);

        FSL_Additional_Sub_Type__c ASType = new FSL_Additional_Sub_Type__c();
        ASType.Service_Order__c = wo1.id;
        ASType.Assignment_Number__c = '001';
        ASType.name = wo1.payer__c;
        ASType.ERP_Job_Line_Number__c = '1234';
        // AST.Payer_Account__c = wo1.payer__c.split(':')[1];
        ASType.Primary__c = true;
        ASTList.add(ASType);

        insert ASTList;

	    List<FSL_Timesheet__c> TSList = new List<FSL_Timesheet__c>();
        FSL_Timesheet__c ts = new FSL_Timesheet__c();
        ts.Service_Order__c = wo1.Id;
        //ts.StartTime__c = System.Datetime.now()+1;
        ts.Reason__c = 'Travel';
        ts.Status__c = 'Invalid';
        ts.Additional_Sub_Type__c = ASType.Id;
        ts.StartTime__c = system.today()+1;
        TSList.add(ts);
        insert TSList;

    }

    @isTest
    static void getTimesheetStatus_positiveTest() {
		List<workorder> woList = [SELECT Id, WorkOrderNumber FROM workorder];
        String requestJSON =  '{'+
		'  "Header": {'+
		'    "Sender": {'+
		'      "ServiceName": "getTimesheetStatus",'+
		'      "SenderID": "MoveX"'+
		'    },'+
		'    "Target": {'+
		'      "TargetID": "Guidanz"'+
		'    }'+
		'  },'+
		'  "DataArea": {'+
		'    "CSSJobID": "'+woList[0].WorkOrderNumber+'",'+
		'    "ERPJobLineNumber": "1234",'+
		'    "AssignmentNumber": ""'+
		'  }'+
		'}';
system.debug('requestJSON++++'+requestJSON);
        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest(); 
        request.requestURI = '/services/data/apexrest/getTimesheetStatus/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(requestJSON);
        RestContext.request = request;
        RestContext.response= response;
        Test.startTest();
        FSL_GetTimesheetStatus.getTimesheetStatus();
        FSL_GetTimesheetStatusRequest.parse(requestJSON);
        Test.stopTest();
    }

    @isTest
    static void getTimesheetStatus_positiveTest2() {
        List<workorder> woList = [SELECT Id, WorkOrderNumber FROM workorder];
        String requestJSON =  '{'+
		'  "Header": {'+
		'    "Sender": {'+
		'      "ServiceName": "getTimesheetStatus",'+
		'      "SenderID": "MoveX"'+
		'    },'+
		'    "Target": {'+
		'      "TargetID": "Guidanz"'+
		'    }'+
		'  },'+
		'  "DataArea": {'+
		'    "CSSJobID": "'+woList[0].WorkOrderNumber+'",'+
		'    "ERPJobLineNumber": "",'+
		'    "AssignmentNumber": "12345"'+
		'  }'+
		'}';

        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest(); 
        request.requestURI = '/services/data/apexrest/getTimesheetStatus/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(requestJSON);
        RestContext.request = request;
        RestContext.response= response;
        Test.startTest();
        FSL_GetTimesheetStatus.getTimesheetStatus();
        Test.stopTest();
    }

    @isTest
    static void getTimesheetStatus_positiveTest3() {
        List<workorder> woList = [SELECT Id, WorkOrderNumber FROM workorder];
        String requestJSON =  '{'+
		'  "Header": {'+
		'    "Sender": {'+
		'      "ServiceName": "getTimesheetStatus",'+
		'      "SenderID": "MoveX"'+
		'    },'+
		'    "Target": {'+
		'      "TargetID": "Guidanz"'+
		'    }'+
		'  },'+
		'  "DataArea": {'+
		'    "CSSJobID": "'+woList[0].WorkOrderNumber+'",'+
		'    "ERPJobLineNumber": "",'+
		'    "AssignmentNumber": "123456"'+
		'  }'+
		'}';

        RestResponse response = new RestResponse();
        RestRequest request = new RestRequest(); 
        request.requestURI = '/services/data/apexrest/getTimesheetStatus/';
        request.httpMethod = 'POST';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf(requestJSON);
        RestContext.request = request;
        RestContext.response= response;
        
        Test.startTest();
        FSL_GetTimesheetStatus.getTimesheetStatus();
        
        boolean isException = false;
        try{
            FSL_Additional_Sub_Type__c ASType = [SELECT Id FROM FSL_Additional_Sub_Type__c WHERE Assignment_Number__c = '12345' LIMIT 1];
            workorder wo1 = [SELECT Id FROM workorder LIMIT 1];
            List<FSL_Timesheet__c> TSList = new List<FSL_Timesheet__c>();
            FSL_Timesheet__c ts = new FSL_Timesheet__c();
            ts.Service_Order__c = wo1.Id;
            ts.StartTime__c = System.Datetime.now();
            ts.Reason__c = 'Travel';
            ts.Status__c = 'Invalid';
            ts.Additional_Sub_Type__c = ASType.Id;
            TSList.add(ts);
            insert TSList;
        }catch(exception ex){
            isException = true;
        }
        system.assertEquals(true, isException);
        Test.stopTest();
    }   

}