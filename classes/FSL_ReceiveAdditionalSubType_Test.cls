//Added by Krishna for Code Coverage
/*
* Test Class for Apex Controller - FSL_ReceiveAdditionalSubType_Test
* Author - Piyush Rani 
* Revision - Raghav : try catch removed, data setup corrected, errors removed
*/ 
//Added by Mallika for Test class coverage
@isTest
public class FSL_ReceiveAdditionalSubType_Test {
	
    @testSetup
    static void dataSetup() {
        Id accGCRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz-Cash').getRecordTypeId();
        Account objAccount = new Account();
        objAccount.RecordTypeId = accGCRecId;
        objAccount.Name = 'Test Account ';
        objAccount.BillingStreet = '1466 N National Rd';
        objAccount.BillingCity = 'Columbus';
        objAccount.BillingState = 'Indiana';
        objAccount.BillingCountry= 'United States';
        objAccount.BillingPostalCode = '47201';
        objAccount.FSL_ERP_Customer_Code__c = '';
        objAccount.Email_Notification_Frequency__c = 'Nightly';
        insert objAccount;
        
        worktype  wType = new worktype();
        wType.EstimatedDuration = Decimal.valueOf('40.02');
        wType.Name = 'Test';
        insert wType;
        
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
        wo1.ESN_Insite__c = '769999';
        wo1.AccountId = objAccount.Id;
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
        ts.StartTime__c = System.Datetime.now();
        ts.Reason__c = 'Travel';
        ts.Status__c = 'new';
        ts.Additional_Sub_Type__c = ASType.Id;
        TSList.add(ts);
        insert TSList;
        
    }
    
    
    @isTest
    static void testReceiveAdditionSubtype() {
        String woNo=[Select id,WorkOrderNumber from workorder where ESN_Insite__c = '769999'][0].WorkOrderNumber;
        
        String requestJSON =  '{'+
            '   \"Header\":{'+
            '      \"Sender\":{'+
            '         \"ServiceName\":\"AdditionalSubTypes\",'+
            '         \"SenderID\":\"MOVEX-UK\"'+
            '      },'+
            '      \"Target\":{'+
            '         \"TargetID\":\"Guidanz\"'+
            '      }'+
            '   },'+
            '   \"DataArea\":{'+
            '      \"CSSJobID\":\"'+woNo+'\",'+
            '      \"ERPWONumber\":\"'+woNo+'\",'+
            '      \"PayerAccount\":\"\",'+
            '      \"AssignmentNumber\":\"\",'+
            '      \"PrimarySubType\":\"USN-F1-01\",'+
            '      \"ERPJobLineNumber\":\"\",'+
            '      \"Status\":\"\",'+
            '      \"AdditionalSubTypes\":['+
            '         {'+
            '            \"SubType\":\"USN-F1-02\",'+
            '            \"AssignmentNumber\":\"\",'+
            '            \"ERPJobLineNumber\":\"\",'+
            '            \"PayerAccount\":\"\",'+
            '            \"Status\":\"\"'+
            '         },'+
            '         {'+
            '            \"SubType\":\"USN-F1-03\",'+
            '            \"AssignmentNumber\":\"\",'+
            '            \"ERPJobLineNumber\":\"\",'+
            '            \"PayerAccount\":\"\",'+
            '            \"Status\":\"\"'+
            '         },'+
            '         {'+
            '            \"SubType\":\"USN-F1-04\",'+
            '            \"AssignmentNumber\":\"\",'+
            '            \"ERPJobLineNumber\":\"\",'+
            '            \"PayerAccount\":\"\",'+
            '            \"Status\":\"\"'+
            '         }'+
            '      ]'+
            '   }'+
            '}';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/services/apexrest/additionalsubtype/';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(requestJSON);
        System.debug('*** Request JSON = '+requestJSON);
        RestContext.request = req;
        RestContext.response= res;
        Test.startTest();
        FSL_ReceiveAdditionalSubType.handleAdditionalSubtype();
        Test.stopTest();
    }
    
    @isTest
    static void testReceiveAdditionSubtype2() {
        String woNo=[Select id,WorkOrderNumber from workorder where ESN_Insite__c = '769999'][0].WorkOrderNumber;
        
        String requestJSON =  '{'+
            '   \"Header\":{'+
            '      \"Sender\":{'+
            '         \"ServiceName\":\"AdditionalSubTypes\",'+
            '         \"SenderID\":\"MOVEX\"'+
            '      },'+
            '      \"Target\":{'+
            '         \"TargetID\":\"Guidanz\"'+
            '      }'+
            '   },'+
            '   \"DataArea\":{'+
            '      \"CSSJobID\":\"\",'+
            '      \"ERPWONumber\":\"'+woNo+'\",'+
            '      \"PayerAccount\":\"\",'+
            '      \"AssignmentNumber\":\"\",'+
            '      \"PrimarySubType\":\"USN-F1-01\",'+
            '      \"ERPJobLineNumber\":\"\",'+
            '      \"Status\":\"\",'+
            '      \"AdditionalSubTypes\":['+
            '         {'+
            '            \"SubType\":\"USN-F1-02\",'+
            '            \"AssignmentNumber\":\"\",'+
            '            \"ERPJobLineNumber\":\"\",'+
            '            \"PayerAccount\":\"\",'+
            '            \"Status\":\"\"'+
            '         },'+
            '         {'+
            '            \"SubType\":\"USN-F1-03\",'+
            '            \"AssignmentNumber\":\"\",'+
            '            \"ERPJobLineNumber\":\"\",'+
            '            \"PayerAccount\":\"\",'+
            '            \"Status\":\"\"'+
            '         },'+
            '         {'+
            '            \"SubType\":\"USN-F1-04\",'+
            '            \"AssignmentNumber\":\"\",'+
            '            \"ERPJobLineNumber\":\"\",'+
            '            \"PayerAccount\":\"\",'+
            '            \"Status\":\"\"'+
            '         }'+
            '      ]'+
            '   }'+
            '}';
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse(); 
        req.requestURI = '/services/apexrest/additionalsubtype/';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json');
        req.requestBody = Blob.valueOf(requestJSON);
        System.debug('*** Request JSON = '+requestJSON);
        RestContext.request = req;
        RestContext.response= res;
        
        Test.startTest();
        FSL_ReceiveAdditionalSubType.handleAdditionalSubtype();
        Test.stopTest();
    }
    
    
}