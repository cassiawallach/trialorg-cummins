/******************************************************************************************************************
Name: EVL_WS_RSW_Test
Copyright © 2020  Cummins
===================================================================================================================
===================================================================================================================
Purpose:    This class is for Create Claims funtionality.
===================================================================================================================
===================================================================================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE                DETAIL                                 
1.0     Lochana Rajput     06/10/2022     Added test method to test FTR ABRflag and Transaction ID attributes 
*******************************************************************************************************************/
//This is Test class for EVL_WS_RSW class
@isTest
public class EVL_WS_RSW_Test {          
    static TestMethod void testCallout() {  //deployment
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        
        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.
         //started By Naga Anusha Devi Malepati Introducing Test data Factory(TestUtility)for SonarQube quality validation(Duplicate lines) NIN-470  
         Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
         Account acc = TestUtility.createTestAccount('East Bronx1', accRecId);
        Asset ast = TestUtility.createTestAsset(acc,'Engines-79963830');
       Case cs = TestUtility.createTestCase(acc.id,ast.id);
        
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        
        workorder wo1 = TestUtility.createTestWorkOrder(acc,DealerRTID,ast,cs);
       
             CSS_List_Of_Values__c css = TestUtility.createCSSListValue('Automotive','AUTOMOTIVE','ALTERNATOR MALFUNCTIONING','Application Code','130');
          
            system.assertNotEquals('x1yz', css.Name);
            system.debug('===CSS=='+css);
        
        	CSS_List_Of_Values__c css1 =  TestUtility.createCSSListValue('Component / Part Specific Issue','Alternator','ALTERNATOR MALFUNCTIONING','Complaint Codes','507');
        
           
            system.debug('==CSS1=='+css1);
            
            
            string scode3=css_utility.getCodes('Complaint Codes','Component / Part Specific Issue','Alternator',null);
            string scode4=css_utility.getCodes('Application Code','Automotive',null,null);
            
            system.debug('scode3>>>>'+scode3);
            system.debug('scode4>>>>'+scode4);
            
             CSS_Integration_Details__c conDetails = TestUtility.createIntegrationDetails();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CSS_RSWClaimInfo_Mock());
            EVL_WS_RSW.sendClaimInfoToRSW(wo1.Id);
            Test.stopTest();
        
    }
    
    static void testMethod1() {
        
        CSS_getConnnectionDetails.getConnection('OAGOAuth');
    }
   
   static TestMethod void testCallout1() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        
        // Call method to test.
        // This causes a fake response to be sent from the class that implements HttpCalloutMock.  
        Id accRId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acct = TestUtility.createTestAccount('East Bronx1', accRId);
        Asset asst = TestUtility.createTestAsset(acct,'Engines-79963830');
        
       
         Case cse = TestUtility.createTestCase(acct.id,asst.id);
        
        Id DealRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        
        workorder wordr1 = TestUtility.createTestWorkOrder(acct,DealRTID,asst,cse);
             CSS_List_Of_Values__c csLV = TestUtility.createCSSListValue('Automotive','AUTOMOTIVE','ALTERNATOR MALFUNCTIONING','Application Code','130');
         system.assertNotEquals('x1yz', csLV.Name);
            system.debug('===CSS=='+csLV);
        
        	CSS_List_Of_Values__c csLV1 =  TestUtility.createCSSListValue('Component / Part Specific Issue','Alternator','ALTERNATOR MALFUNCTIONING','Complaint Codes','507');
         system.debug('==CSS1=='+csLV1);
            
            
            string scode1=css_utility.getCodes('Complaint Codes','Component / Part Specific Issue','Alternator',null);
            string scode2=css_utility.getCodes('Application Code','Automotive',null,null);
            
            system.debug('scode1>>>>'+scode1);
            system.debug('scode2>>>>'+scode2);
            
             CSS_Integration_Details__c cssDetails = TestUtility.createIntegrationDetails();

            
            
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new CSS_RSWClaimInfo_Mock());
            EVL_WS_RSW.sendClaimInfoToRSW(wordr1.Id);
            Test.stopTest();
       //Ended By Naga Anusha Devi Malepati Introducing Test data Factory(TestUtility)for SonarQube quality validation(Duplicate lines) NIN-470
        
    } 

    @isTest public static void testFTRFunctionality() {
        FSL_Switch__c FSlSwitch =FSL_TestDataUtility.createFSLSwitchRecord('Enable_FTR_Switch', true);
        FSL_Switch__c FSlSwitchRSW =FSL_TestDataUtility.createFSLSwitchRecord('Enable_RSWIntegrationforFTR', true);
        List<FSL_Switch__c> lstFeature = new List<FSL_Switch__c>();
        lstFeature.add(FSlSwitch);
        lstFeature.add(FSlSwitchRSW);
        insert lstFeature;

        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        OperatingHours testOh = TestUtility.createOperatingHours('testName');

        ServiceTerritory testTerritory = TestUtility.createServiceTerritory('testName', true, testOh.Id);

        Id accRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acc = FSL_TestDataUtility.createAccount();
        Id conRecId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact con = FSL_TestDataUtility.createContact(conRecId, acc.Id);
        insert con;
        
        Asset  ast = FSL_TestDataUtility.createAsset();
        ast.VIN__c = '12344';
        update ast;
        Id servRecId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();
        List<Case> lstCases = FSL_TestDataUtility.createCases(servRecId,acc.Id, con.Id,ast.Id,testTerritory.Id,1);
        lstCases[0].FSL_ABRFlag__c= true;
        insert lstCases;
        Id DealerRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWO = FSL_TestDataUtility.createWO(lstCases, acc.Id);
        lstWO[0].RecordTypeId = DealerRTID;
        insert lstWO;
        Workorder wo1= lstWO[0];

        //Creating custom setting record
        CSS_Integration_Details__c conDetails = FSL_TestDataUtility.createCSSIntegrationDetails('RSWClaim', 
        'https://api-ue-devnf-aw-ex.cummins.com/cmi-claims/information', 'POST');
        insert conDetails;

        //Setting Mock Response
        final String mockResponse = FSL_TestDataUtility.getRSWResponse();
        final MockHttpResponseGenerator httpMock = new MockHttpResponseGenerator(mockResponse);
        Test.setMock(HttpCalloutMock.class, httpMock);
        test.startTest();
        Service_Order_Extension__c soExtension = FSL_TestDataUtility.createServiceOrderExtension(wo1.Id, true, '12345-566788');
        EVL_WS_RSW.sendClaimInfoToRSW(wo1.Id);
        test.stopTest();
        System.assertEquals(Limits.getQueries() > 0, true);
    }

    @isTest public static void test_sendSerOrdInfoToRSWmenthod() {
        FSL_Switch__c FSlSwitch1 =FSL_TestDataUtility.createFSLSwitchRecord('Enable_FTR_Switch', true);
        FSL_Switch__c FSlSwitchRSW1 =FSL_TestDataUtility.createFSLSwitchRecord('Enable_RSWIntegrationforFTR', true);
        List<FSL_Switch__c> lstFeature1 = new List<FSL_Switch__c>();
        lstFeature1.add(FSlSwitch1);
        lstFeature1.add(FSlSwitchRSW1);
        insert lstFeature1;

        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        OperatingHours testOhrs = TestUtility.createOperatingHours('testName');

        ServiceTerritory testTrrty = TestUtility.createServiceTerritory('testName', true, testOhrs.Id);

        Id accRId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Account acct = FSL_TestDataUtility.createAccount();
        Id conRId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Guidanz').getRecordTypeId();
        Contact cont = FSL_TestDataUtility.createContact(conRId, acct.Id);
        insert cont;
        
        Asset  asst = FSL_TestDataUtility.createAsset();
        asst.VIN__c = '12344';
        update asst;
        Id servRcId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EVL_Guidanz_Dealer_Evolution').getRecordTypeId();
        List<Case> lstCse = FSL_TestDataUtility.createCases(servRcId,acct.Id, cont.Id,asst.Id,testTrrty.Id,1);
        lstCse[0].FSL_ABRFlag__c= true;
        insert lstCse;
 
        Id DealRTID = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('EVL_ServiceOrder').getRecordTypeId();
        List<workorder> lstWOrder = FSL_TestDataUtility.createWO(lstCse, acct.Id);
        lstWOrder[0].RecordTypeId = DealRTID;
        insert lstWOrder;
        Workorder wo1= lstWOrder[0];
        //Creating custom setting record
        CSS_Integration_Details__c conDetail = FSL_TestDataUtility.createCSSIntegrationDetails('EVL_RSWDiagData', 
        'https://api-ue-devnf2-aw-ex.cummins.com/services-workorders/workorder', 'POST');
        insert conDetail;
        
        //Creating custom setting record
        CSS_Integration_Details__c conDetail2 = FSL_TestDataUtility.createCSSIntegrationDetails('EVL_RSWToken', 
        'https://api-ue-devnf3-aw-ex.cummins.com/api/core-security-api/v1/auth/token', 'POST');
        new CSS_Integration_Details__c();
        insert conDetail2;


        EVL_RSW_ReqWrapper reqsJSON = new EVL_RSW_ReqWrapper();        
        
        EVL_RSW_ReqWrapper.Header headerDetails = new EVL_RSW_ReqWrapper.Header();
        
        EVL_RSW_ReqWrapper.Sender senderDetails = new EVL_RSW_ReqWrapper.Sender();
        
        senderDetails.SenderID ='CSS';
        
        headerDetails.Sender = senderDetails;
        
        EVL_RSW_ReqWrapper.Target targetDetails = new EVL_RSW_ReqWrapper.Target();
        
        targetDetails.TargetID = 'RSW';
        
        headerDetails.Target = targetDetails;
        
        reqsJSON.Header = headerDetails;
        
        EVL_RSW_ReqWrapper.DataArea DataAreaDtls = new EVL_RSW_ReqWrapper.DataArea(); 
        DataAreaDtls.id = wo1.WorkOrderNumber;
        DataAreaDtls.workOrder = wo1.Dealer_Shop_Work_Order__c;
        DataAreaDtls.esn = wo1.Engine_Serial_Number__c;
        DataAreaDtls.dsStatus = (wo1.Status == 'Closed' ? 'Closed' : 'Open');
        DataAreaDtls.nbSearches = '0';
        DataAreaDtls.accessSRTID = ''; 
        DataAreaDtls.manufacturer = wo1.Make__c;
        DataAreaDtls.modelSeries = wo1.Model__c;
        DataAreaDtls.unitNumber = wo1.Unit_Number_Formula__c;
        DataAreaDtls.customerName = '';
        reqsJSON.DataArea = DataAreaDtls;
         //Setting Mock Response
         final String mockResponses = FSL_TestDataUtility.getRSWResponse();
         final MockHttpResponseGenerator httpMockObj = new MockHttpResponseGenerator(mockResponses);
         Test.setMock(HttpCalloutMock.class, httpMockObj);
        Test.startTest();
        EVL_WS_RSW.sendSerOrdInfoToRSW(reqsJSON);
        EVL_WS_RSW.getAccessToken('EVL_RSWToken');
        Test.stopTest();
        System.assertEquals(Limits.getQueries() > 0, true);
    }
    //Mock reponse generator class    
    private class MockHttpResponseGenerator implements HttpCalloutMock {        
        string endpoint;
        string username;
        string password;
        string callbody;
        string responsebody;
        string responseContentType = 'application/json';
        Integer responseStatus = 200;
        Map<String, String> callHeaders = new Map<String, String>();
        
        //Set the response body from test
        public MockHttpResponseGenerator (string response){
            this.responsebody = response;
        }
        
        //Set the response status from test
        public MockHttpResponseGenerator setResponseStatus(Integer status) {
            this.responseStatus = status;
            return this;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            this.endpoint = req.getendpoint();
            this.username = req.getHeader('client-id');
            this.password = req.getHeader('client-secret');
            this.callBody = req.getBody();
            this.callHeaders.put('content-type', req.getHeader('Content-Type'));
                
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(this.responseBody);
            res.setStatusCode(this.responseStatus);
            return res;
    	}
    }
}