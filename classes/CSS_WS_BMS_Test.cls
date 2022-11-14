/**********************************************************************
Name: CSS_WS_BMS_Test
Copyright © 2016  Cummins
======================================================
====================================================== 
Purpose:    Test Class for CSS_WS_BMS 

======================================================
======================================================
History                                                            
-------                                                            
VERSION   AUTHOR            DATE          DETAIL                                 
1.0       Rajkumar        08/09/2016    INITIAL DEVELOPMENT 
1.1       Nisha           21/09/2016    Added parameters to the called methods
2.0 	  Rakesh kumar 	  25/05/2017    Added parameters fixed the test class
2.1       Sravanthi       05/06/2021
*****************************************************************************/
@isTest
public class CSS_WS_BMS_Test {
    /*static testMethod void testParse() {
String json = '{\"Header\": { '+
'  \"Status\": \"success\", '+
'  \"Sender\": { '+
'\"ServiceName\": \"GetUnitInfo\",'+
'\"SenderID\": \"CSS\"'+
'},'+
' \"Target\": {'+
'\"TargetID\": \"BMS"'+
'},'+
'  \"Location\": { '+
'   \"LocationID\": \"02400-02394\" '+
'  } '+
'}, '+
'\"DataArea\": [{ '+
'  \"CustomerCode\" : \"A1234567\", '+
'  \"UnitNumber\": \"12345\", '+
'  \"UnitDescription\": \"\", '+
'  \"UnitType\": \"\", '+
'  \"Model\": \"\", '+
'  \"VIN\": \"\", '+
'  \"Manufacturer\": \"KENWORTH\", '+
'  \"SalesSegment\": \"\", '+
'  \"ModelNumber\": \"\", '+
'  \"ModelSeq\": 0, '+
'  \"ESN\": \"79834545\", '+
'  \"EngineFamily\": \"\", '+
'  \"Applicationcode\": \"\" '+
'}] '+
'}';
CSS_UnitOutboundJSON2Apex obj = CSS_UnitOutboundJSON2Apex.parse(json);
System.assert(obj != null);
}*/
    // method to Test Jobplan inbound
    static TestMethod void testJobplanInboundService() {
        // Set mock callout class    
        
        Test.setMock(HttpCalloutMock.class, new CSS_BMS_UnitOutboundMockup_Test());
        CSS_BMS_SRTReq REQ = new CSS_BMS_SRTReq();
        Test.startTest();
        CSS_WS_BMS.callJobPlanInboundService(REQ);
        Test.stopTest();
        //System.assertEquals('expected'; a.Description);
    }
    // method to Test WOQT inbound
    static TestMethod void testWOQTInbountService() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        CSS_Job_Order__c jobOrder = CSS_TestData.createJobOrder(true);
        String CSSJobID = jobOrder.Id;
        String DistributorCode = 'D001';
        String BranchCode = 'B001';
        String OrderType = 'Fresh';
        String custCode = 'C4455';
        String Inshop = 'Yes';
        String CreateDate = '20/09/2016';   
        String PromisedDate = '26/09/2016';   
        String BillType = 'bbtype'; //billType
        String ContactName = 'contact1';
        //String CustNamePhone = 'namephone';
        String CustomerPhone = '(1)-(541)-(754)-(3010)';
        //String SubType = jobOrder.sub_Type__c;
        String SubType = 'cedan';
        String UnitNumber = jobOrder.Unit_Number__c;                             
        String Model = jobOrder.Model__c;
        String Make = jobOrder.Make__c;
        String ServiceModelName = String.valueof(jobOrder.Service_Model_N__c);
        String EngineFamily = 'family1';
        String ESN = jobOrder.ESN__c;
        String Location = 'Test-test1-test2';
        String Application = jobOrder.Application__c;
        string contactId = 'testcon123';
        String EmailID = 'abc@example.com';
        String CreateUser = 'user1';
        String ChangeUser = 'user2';
        Test.startTest();
        css_ws_bms.callBMSWOQTInboundService(CSSJobID, OrderType, custCode, Inshop, CreateDate, PromisedDate, BillType, ContactName, CustomerPhone, SubType, UnitNumber, Model, Make, ServiceModelName, EngineFamily, ESN, Application, location,contactId,EmailID,CreateUser,ChangeUser);
        Test.stopTest();
    }
    // method to Test WOQT outbound
    static TestMethod void testWOQTOutbountService() {
        // Set mock callout class
        
        
        Test.setMock(HttpCalloutMock.class, new CSS_BMS_WOQTOutboundMockup_Test()); 
        Test.startTest();
        CSS_WS_BMS.callBMSWOQTOutboundService();
        Test.stopTest();
    }
    // method to Test customer inbound
    static TestMethod void testCustomerInboundService() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_CustInboundMock());
        
        
        String custName = 'newcust1';
        String custAddr1 = '2N42';
        String custAddr2 = 'nit fbd';
        String custAddr3 = '121001';
        String city = 'fbd';
        String state = 'haryana';
        String postCode = '121001';
        String postalCodeSuffix = '456';
        String cusContact = '66778899';
        String distBrnchCode = '23456';
        String countryCd = '111';
        String lang = 'eng';
        String application = 'newapp';
        String AreaCode = 'Test';
        String Phone = 'Test';
        String location = 'Test-test1-test2';
        
        Test.startTest();
        //CSS_WS_BMS.callBMSCustInboundService(custName,custAddr1,custAddr2,custAddr3,city,state,postCode,postalCodeSuffix,cusContact,distBrnchCode,countryCd,lang,application);
        css_ws_bms.callBMSCustInboundService(custName, custAddr1, custAddr2, custAddr3, AreaCode, Phone, city, state, postCode, postalCodeSuffix, cusContact, countryCd, lang, application, location);

        Test.stopTest();
    }
    // method to Test Customer outbound
    static TestMethod void testCustomerOutboundService() {
        // Set mock callout class
        
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        Test.setMock(HttpCalloutMock.class, new CSS_CustOutBoundMock());
        
        String custName = 'newcust2';
        String custCode = '2223344';
       // String custName = null;
        //String custCode = null;
        String Location = 'Test';
		CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSCustomer';
        csInt.ApplicationName__c='BMSCustomer';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/customer';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
        system.debug('csint**'+csint);
                
        Test.startTest();
        //CSS_WS_BMS.callCustOutboundService(custName,custCode);
        css_ws_bms.callCustOutboundService(custName, custCode, Location);
        Test.stopTest();
    }
    static TestMethod void testCustomerOutboundServiceExceptionMethod() {
        // Set mock callout class
        
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        Test.setMock(HttpCalloutMock.class, new CSS_CustOutBoundMock1());
        
        String custName = 'newcust2';
        String custCode = '2223344';
        String Location = 'Test';
        
        Test.startTest();
        //CSS_WS_BMS.callCustOutboundService(custName,custCode);
        css_ws_bms.callCustOutboundService(custName, custCode, Location);
        Test.stopTest();
    }
    // method to Test QTAcceptanceInbound
    static TestMethod void testQTAcceptanceInboundService() {
        // Set mock callout class
        String Location = 'Test-test1-test2';
        String JobId = 'Test';
        String BMSRefNum = '';
        String Status = '';
        String declineRsn = '';
        string PurchaseOrderNum='';
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new CSS_BMSQTACcInboundMockup_Test());
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CG_BMSQuoteAcceptance';
        csInt.ApplicationName__c='CG_BMSQuoteAcceptance';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf3-aw-ex.cummins.com/cmi/quotes/v1/acceptance';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        Test.startTest();
        CSS_WS_BMS.callBMSQTAccInboundService(Location, JobId, BMSRefNum, Status, declineRsn,PurchaseOrderNum);
        Test.stopTest();
    }
    // method to Test QTServiceHistoryOutbound
    static TestMethod void testServiceHistoryOutbound() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        
        String ESN = '234567';
        String Location = 'Test-test1-test2';
        List<CSS_JobEventTemporary__c> lstJobEventTemp = new List<CSS_JobEventTemporary__c>();
        
        CSS_JobEventTemporary__c jobevent = new CSS_JobEventTemporary__c();
        jobevent.File_Name__c='Test';
        jobevent.Circuit_Description__c='rrrr';
        jobevent.Comp_Location__c='dfgh';
        jobevent.Effect__c='klkl';
        jobevent.Engine__c='bfr';
        jobevent.Fault_Code_Description__c = 'intake';
        jobevent.File_Name__c = 'testing';
        jobevent.FMI__c = 'htyu';
        jobevent.Lamp__c = 'nhgt';
        jobevent.Reason__c = 'yyyy';
        jobevent.Service_Model_Name__c = 'fault';
        jobevent.SPN__c = 'bfgfhhj';
        jobevent.Attribute1__c= '2014-05-08T00:00:00.000-05:00'; //string.valueof(system.now());
        jobevent.Attribute2__c='test2';
        jobevent.Attribute3__c='test3';
        jobevent.Attribute4__c='1.0';
        jobevent.Attribute5__c='test5';
        jobevent.Attribute6__c='test6';
        jobevent.Attribute7__c='test7';
        jobevent.Attribute8__c='test9';
        jobevent.Attribute9__c='test10';
        jobevent.Attribute10__c='test11';
        jobevent.Attribute11__c='2014-05-08T00:00:00.000-05:00';
        jobevent.Attribute12__c='test13';
        date d =  Date.today();
        jobevent.Attribute13__c=d;
        jobevent.Attribute14__c='test15';
        jobevent.Attribute15__c='test8';
        jobevent.Reason__c='tEst';
        jobevent.key__c=ESN;
        jobevent.type__c='ClaimHistory';
        jobevent.Active__c=true;
        //jobevent.LastModifiedDate=system.now();
        insert jobevent;
        CSS_JobEventTemporary__c jobevent1 = new CSS_JobEventTemporary__c();
        jobevent1.type__c='ClaimHistory';
        jobevent1.Active__c=true;
        
        //jobevent1.LastModifiedDate=system.now();
        insert jobevent1;
        lstJobEventTemp.add(jobevent);
        lstJobEventTemp.add(jobevent1);
        List<CSS_JobEventTemporary__c> jobEveTemp = new List<CSS_JobEventTemporary__c>([Select Id,Attribute5__c from CSS_JobEventTemporary__c where Attribute5__c!=null and Key__c=:ESN order by lastmodifieddate desc]);
        system.debug('jobEveTemp**'+jobEveTemp);
        Test.startTest();
        CSS_WS_BMS.callServiceHistoryOutboundService(ESN, Location);
        
        Test.stopTest();
        //System.assertEquals('True1', ESN,'checking assert statement');              
        
    }
    // method to Test WOCommentInbound
    static TestMethod void testWOCommentInbound() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CSS_CommentInboundMock()); 
        
        String CSSJobID = 'J6666';
        String location = 'D3344-D3345-D3346';
        String branchNumber = 'B223344';
        String orderType = 'O3344';
        String BMSReferenceNumber = '';
        String commentType = 'extraa';
        String comment = null;
        
        Test.startTest();
        CSS_WS_BMS.callWOCommentInboundService(location, CSSJobID, OrderType, BMSReferenceNumber, CommentType, Comment, '', '', '', '');
        Test.stopTest();
    }
    // method to Test unitInbound
    static TestMethod void testunitInbound() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CG_BMS_UnitInboundMock_Test()); 
         CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSUnitService';
        csInt.ApplicationName__c='BMSUnitService';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-engines/unit';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        system.debug('csint**'+csint);
        String custCode;
        String unitNumber;
        String unitDescription;
        String model;
        String VIN;
        String make;
        String application;
        String serviceModelName;
        String ESN;
        String engineFamily;
      //  String applicationCode;
        String location; 
        String distanceType;
        String distance = 'aka';
        String hours;
        String failureDate;
        String WarrantyStartDate;
        String jsonResponseBody;
        String applicationCode = '130';
        Http h1 = new Http();
        HttpResponse res1;
        HttpRequest req1 = new HttpRequest();
        // res1 = h1.send(req1);
        //c.BMS_Claim_ReqJSON__c='';
        
    
        Test.startTest();
        CSS_WS_BMS.callUnitInbound(custCode,unitNumber,unitDescription,model,VIN,make,serviceModelName,ESN,engineFamily,applicationCode, location,distanceType,distance,hours,failureDate,failureDate,application);
        CG_ReqPDFInbound_Req req= new CG_ReqPDFInbound_Req();
        CG_ReqPDFInbound_Resp res=CSS_WS_BMS.reqPDFInbound(req);
      //  res1 = null;
        list<CSS_JobHistory__c> jobHistoryToInsertList = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c jh1=new CSS_JobHistory__c();
        jh1.CSS_Object_Name__c ='CSS_Claim__c';
        jobHistoryToInsertList.add(jh1);
        CSS_JobHistory__c jh2=new CSS_JobHistory__c();
        //jobHistoryToInsertList.add(jh1);
        jobHistoryToInsertList.add(jh2);
        List< CSS_Integration_Error__c> lsterror = new  List< CSS_Integration_Error__c>();
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c='Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'Submit Claims to BMS Webservice Execution failed';
        ie1.Source__c='Submit Claims to BMS';
        ie1.Processed_Data__c='CSS_WS_BMS-Submit Claims to BMS';
        //ie1.Response_Body__c ='submit claims';
        //insert ie1;
        lsterror.add(ie1);
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        ie2.Error_Description__c='Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'Submit Claims to BMS Webservice Execution failed';
        ie2.Source__c='Submit Claims to BMS';
        ie2.Processed_Data__c='CSS_WS_BMS-Submit Claims to BMS';
        lsterror.add(ie1);
        lsterror.add(ie2);
        //List<CSS_Integration_Details__c> lstdet = new List<CSS_Integration_Details__c>();
        
        CSS_Claim_Submission__c c1=new CSS_Claim_Submission__c();
        c1.BMS_Claim_ReqJSON__c='sucess';
        CSS_Claim_Submission__c c2=new CSS_Claim_Submission__c();
        CSS_Claim_Submission__c c3=new CSS_Claim_Submission__c();
        
        List<CSS_Claim_Submission__c> cs=new List<CSS_Claim_Submission__c>();
        cs.add(c1);
        cs.add(c2);
        cs.add(c3);
         List<String> autoMotiveApplicationCodes = new List<String>();
        
        autoMotiveApplicationCodes.add('element');
        
        CSS_Integration_Details__c csInt1 = new CSS_Integration_Details__c();
        csInt1.name = 'ClaimsInbound';
        csInt1.ApplicationName__c='ClaimsInbound';
        csInt1.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt1.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-engines/unit';
        csInt1.IsActive__c=true;
        csInt1.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt1.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt1.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt1.Method_Type__c='POST';
        csInt1.Id = null;
        insert csInt1;
        
        Test.setMock(HttpCalloutMock.class , new SubmitClaimsmock_test());
        HttpResponse h = new HttpResponse();
        h.setBody('OSB Service Callout action received SOAP Fault response');
        h.setStatusCode(200);
        //returnWrapper.response = h;
        CSS_WS_BMS.returnWrapperglobal.response = h;
        CSS_WS_BMS.claimsInbound(cs);
        
        string respbody = '{'+
		'	"DataArea": {'+
		'		"BMSClaimNumber": "1-127827968"'+
		'	},'+
		'	"Header": {'+
		'		"ReturnCodeDescription": "",'+
		'		"Status": "Success",'+
		'		 "Sender": '+
		'			{'+
		'			 "ServiceName": "",'+
		'			  "MessageID": "",'+
		'			  "SenderID": ""'+
		'			},'+
		'		"Target": '+
		'			{'+
		'			 "TargetID": ""'+
		'			},'+
		'		"Location": '+
		'			{'+
		'			 "LocationID": ""'+
		'			}'+
            
            
		'	}	'+
		'}';

        h.setBody(respbody);
        h.setStatusCode(200);
        //returnWrapper.response = h;
        CSS_WS_BMS.returnWrapperglobal.response = h;
        CSS_WS_BMS.claimsInbound(cs);
        
        //h.setBody('');
        h.setStatusCode(500);
        //returnWrapper.response = h;
        CSS_WS_BMS.returnWrapperglobal.response = null;
        CSS_WS_BMS.claimsInbound(cs);
        
        Test.stopTest();
    }
    //
    
     static TestMethod void testclaimsInbound() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CG_BMS_UnitInboundMock_Test()); 
         CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSUnitService';
        csInt.ApplicationName__c='BMSUnitService';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-engines/unit';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        system.debug('csint**'+csint);
        String custCode;
        String unitNumber;
        String unitDescription;
        String model;
        String VIN;
        String make;
        String application;
        String serviceModelName;
        String ESN;
        String engineFamily;
      //  String applicationCode;
        String location; 
        String distanceType;
        String distance = 'aka';
        String hours;
        String failureDate;
        String WarrantyStartDate;
        String jsonResponseBody;
        String applicationCode = '130';
        Http h1 = new Http();
        HttpResponse res1;
        HttpRequest req1 = new HttpRequest();
        // res1 = h1.send(req1);
        //c.BMS_Claim_ReqJSON__c='';
        
    
        Test.startTest();

      //  res1 = null;
        list<CSS_JobHistory__c> jobHistoryToInsertList = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c jh1=new CSS_JobHistory__c();
        jh1.CSS_Object_Name__c ='CSS_Claim__c';
        jobHistoryToInsertList.add(jh1);
        CSS_JobHistory__c jh2=new CSS_JobHistory__c();
        //jobHistoryToInsertList.add(jh1);
        jobHistoryToInsertList.add(jh2);
        List< CSS_Integration_Error__c> lsterror = new  List< CSS_Integration_Error__c>();
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c='Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'Submit Claims to BMS Webservice Execution failed';
        ie1.Source__c='Submit Claims to BMS';
        ie1.Processed_Data__c='CSS_WS_BMS-Submit Claims to BMS';
        //ie1.Response_Body__c ='submit claims';
        //insert ie1;
        lsterror.add(ie1);
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        ie2.Error_Description__c='Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'Submit Claims to BMS Webservice Execution failed';
        ie2.Source__c='Submit Claims to BMS';
        ie2.Processed_Data__c='CSS_WS_BMS-Submit Claims to BMS';
        lsterror.add(ie1);
        lsterror.add(ie2);
        //List<CSS_Integration_Details__c> lstdet = new List<CSS_Integration_Details__c>();
        
        CSS_Claim_Submission__c c1=new CSS_Claim_Submission__c();
        c1.BMS_Claim_ReqJSON__c='sucess';
        CSS_Claim_Submission__c c2=new CSS_Claim_Submission__c();
        CSS_Claim_Submission__c c3=new CSS_Claim_Submission__c();
        
        List<CSS_Claim_Submission__c> cs=new List<CSS_Claim_Submission__c>();
        cs.add(c1);
        cs.add(c2);
        cs.add(c3);
         List<String> autoMotiveApplicationCodes = new List<String>();
        
        autoMotiveApplicationCodes.add('element');
        
        CSS_Integration_Details__c csInt1 = new CSS_Integration_Details__c();
        csInt1.name = 'ClaimsInbound';
        csInt1.ApplicationName__c='ClaimsInbound';
        csInt1.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt1.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-engines/unit';
        csInt1.IsActive__c=true;
        csInt1.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt1.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt1.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt1.Method_Type__c='POST';
        csInt1.Id = null;
        insert csInt1;
        
        Test.setMock(HttpCalloutMock.class , new SubmitClaimsmock_test());
        HttpResponse h = new HttpResponse();
        h.setBody('OSB Service Callout action received SOAP Fault response');
        h.setStatusCode(200);
        //returnWrapper.response = h;
        CSS_WS_BMS.returnWrapperglobal.response = h;
        CSS_WS_BMS.claimsInbound(cs);
        
        string respbody = '{'+
		'	"DataArea": {'+
		'		"BMSClaimNumber": "1-127827968"'+
		'	},'+
		'	"Header": {'+
		'		"ReturnCodeDescription": "",'+
		'		"Status": "Error",'+
		'		 "Sender": '+
		'			{'+
		'			 "ServiceName": "",'+
		'			  "MessageID": "",'+
		'			  "SenderID": ""'+
		'			},'+
		'		"Target": '+
		'			{'+
		'			 "TargetID": ""'+
		'			},'+
		'		"Location": '+
		'			{'+
		'			 "LocationID": ""'+
		'			}'+
		'	}	'+
		'}';
        
        h.setBody(respbody);
        h.setStatusCode(200);
        //returnWrapper.response = h;
        CSS_WS_BMS.returnWrapperglobal.response = h;
        CSS_WS_BMS.claimsInbound(cs);
        
        //h.setBody('');
        h.setStatusCode(500);
        //returnWrapper.response = h;
        CSS_WS_BMS.returnWrapperglobal.response = null;
        CSS_WS_BMS.claimsInbound(cs);
        
        Test.stopTest();
    }
    
    // method to Test unitInbound
    static TestMethod void testunitOutbound() {
        // Set mock callout class
        
        Test.setMock(HttpCalloutMock.class, new CSS_AccessToken_SRT_Test()); 
        Test.setMock(HttpCalloutMock.class, new CSS_BMS_UnitOutboundMockup_Test()); 
        String ESN = '445566';
        String custCode = 'C3344';
        String Location = 'Test-test1-test2';
        
        Test.startTest();    
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        //CSS_WS_BMS.callUnitOutboundService(ESN,custCode);
        css_ws_bms.callUnitOutboundService(ESN, custCode, Location);
        css_ws_bms.callUnitOutboundService('', '', '');
        
        
        Test.stopTest();
    }
    static testMethod void testGetsubtypeUnittype(){            
        
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMS_UNITTYPE';
        csInt.ApplicationName__c='BMS_UNITTYPE';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-engines/unit';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        String Location ='Test';
        //CSS_GetSubTypesUnitTypesService unittypeservice = new CSS_GetSubTypesUnitTypesService();
        //CSS_GetSubTypUnitTypResJ2A response;
        CSS_GetSubTypUnitTypResJ2A SubTypeDetails = new CSS_GetSubTypUnitTypResJ2A();
        string response = '{"DataArea":[{"CodeValue":"AUTO - FIRE TRUCK","CodeDescription":"AUTO - FIRE TRUCK","Code":"SALES_SEGMENT"},{"CodeValue":"AUTO - RV","CodeDescription":"AUTO - RV","Code":"SALES_SEGMENT"},{"CodeValue":"AUTO - SCHOOL BUS","CodeDescription":"AUTO - SCHOOL BUS","Code":"SALES_SEGMENT"},{"CodeValue":"AUTO - SHUTTLE BUS","CodeDescription":"AUTO - SHUTTLE BUS","Code":"SALES_SEGMENT"},{"CodeValue":"AUTO - TRANSIT-COACH BUS","CodeDescription":"AUTO - TRANSIT-COACH BUS","Code":"SALES_SEGMENT"},{"CodeValue":"AUTO - TRUCK","CodeDescription":"AUTO - TRUCK","Code":"SALES_SEGMENT"},{"CodeValue":"AUTO-OTHER(Incl. Pick-up)","CodeDescription":"AUTO - OTHERS","Code":"SALES_SEGMENT"},{"CodeValue":"HHP - MARINE Commercial","CodeDescription":"HIGH HORSEPOWER - MARINE","Code":"SALES_SEGMENT"},{"CodeValue":"HHP - MINING","CodeDescription":"HIGH HORSEPOWER - MINING","Code":"SALES_SEGMENT"},{"CodeValue":"HHP - OIL - GAS","CodeDescription":"HIGH HORSEPOWER - OIL-GAS","Code":"SALES_SEGMENT"},{"CodeValue":"HHP - OTHER","CodeDescription":"HIGH HORSEPOWER - OTHERS","Code":"SALES_SEGMENT"},{"CodeValue":"HHP - RAIL","CodeDescription":"HIGH HORSEPOWER - RAIL","Code":"SALES_SEGMENT"},{"CodeValue":"IND - AGRICULTURE","CodeDescription":"IND - AGRICULTURE","Code":"SALES_SEGMENT"},{"CodeValue":"IND - CONST - LOGGING","CodeDescription":"IND - CONST - LOGGING","Code":"SALES_SEGMENT"},{"CodeValue":"IND - OTHER","CodeDescription":"IND - OTHERS","Code":"SALES_SEGMENT"},{"CodeValue":"INTERNAL","CodeDescription":"INTERNAL WORK ORDER","Code":"SALES_SEGMENT"},{"CodeValue":"MARINE  (Non-HHP)","CodeDescription":"MARINE (Non-HHP)","Code":"SALES_SEGMENT"},{"CodeValue":"OTHER - ALLIED","CodeDescription":"OTHER - ALLIED","Code":"SALES_SEGMENT"},{"CodeValue":"PG - COMMERCIAL <200KW","CodeDescription":"PG - COMMERCIAL <200KW","Code":"SALES_SEGMENT"},{"CodeValue":"PG - COMMERCIAL >200KW","CodeDescription":"PG - COMMERCIAL >200KW","Code":"SALES_SEGMENT"},{"CodeValue":"PG - CONSUMER","CodeDescription":"PG - CONSUMER","Code":"SALES_SEGMENT"},{"CodeValue":"PG - OTHER","CodeDescription":"PG - OTHERS","Code":"SALES_SEGMENT"},{"CodeValue":"PG - RENTAL","CodeDescription":"PG - RENTAL","Code":"SALES_SEGMENT"},{"CodeValue":"PG - SWITCHES-SWITCHGEAR","CodeDescription":"PG - SWITCHES-SWITCHGEAR","Code":"SALES_SEGMENT"},{"CodeValue":"REFRIGERATION","CodeDescription":"REFRIGERATION","Code":"SALES_SEGMENT"},{"CodeValue":"AFS","CodeDescription":"**DO NOT USE**","Code":"SUBTYPE"},{"CodeValue":"AFS325","CodeDescription":"AUTO-FIELD SERVICE 325","Code":"SUBTYPE"},{"CodeValue":"CAPITALIZED","CodeDescription":"Capitalized SIRIUS BMS","Code":"SUBTYPE"},{"CodeValue":"CFB","CodeDescription":"CFB SUFFIELD","Code":"SUBTYPE"},{"CodeValue":"CGRI","CodeDescription":"CUMMINS GEN  REWARD INSP","Code":"SUBTYPE"},{"CodeValue":"DIAVEK","CodeDescription":"DIAVEK","Code":"SUBTYPE"},{"CodeValue":"ESB","CodeDescription":"ENERGY SOLUTIONS BUSINESS","Code":"SUBTYPE"},{"CodeValue":"FSMERC","CodeDescription":"MERCRUISER-FIELD SERVICE","Code":"SUBTYPE"},{"CodeValue":"IFS","CodeDescription":"**DO NOT USE**","Code":"SUBTYPE"},{"CodeValue":"IFS325","CodeDescription":"IND-FIELD SERVICE 325","Code":"SUBTYPE"},{"CodeValue":"INTERNAL IN SHOP","CodeDescription":"INTER COMPANY-IN SHOP","Code":"SUBTYPE"},{"CodeValue":"INTERNAL325","CodeDescription":"INTER COMPANY-325 FS","Code":"SUBTYPE"},{"CodeValue":"INTERNALFS","CodeDescription":"INTER COMPANY-FIELD SERV","Code":"SUBTYPE"},{"CodeValue":"INTERNALFSPG","CodeDescription":"INTERCOMPANY PG FIELD","Code":"SUBTYPE"},{"CodeValue":"INTERNALUPFIT","CodeDescription":"INTER COMPANY UPFIT","Code":"SUBTYPE"},{"CodeValue":"INTL RTL ASSET","CodeDescription":"INTERCO RNTL ASSET IMPROV","Code":"SUBTYPE"},{"CodeValue":"INTL RTL CHECKIN/OUT","CodeDescription":"INTERCO RNTL CHECKIN/OUT","Code":"SUBTYPE"},{"CodeValue":"INTL RTL CPG BLT ASSET","CodeDescription":"INTRCO RTL CPG ASSET IMPR","Code":"SUBTYPE"},{"CodeValue":"INTL RTL MAINT","CodeDescription":"INTERCO RNTL GENL MAINT","Code":"SUBTYPE"},{"CodeValue":"INTL RTL MAJ REP","CodeDescription":"INTERCO RNTL MAJOR REPAIR","Code":"SUBTYPE"},{"CodeValue":"INTL RTL MIN REP","CodeDescription":"INTERCO RNTL MINOR REPAIR","Code":"SUBTYPE"},{"CodeValue":"INTL RTL UPFIT","CodeDescription":"INTERCOMPANY RENTAL UPFIT","Code":"SUBTYPE"},{"CodeValue":"ISMERC","CodeDescription":"MERCRUISER-IN SHOP","Code":"SUBTYPE"},{"CodeValue":"MFS","CodeDescription":"**DO NOT USE**","Code":"SUBTYPE"},{"CodeValue":"MFS325","CodeDescription":"Marine-Field Service","Code":"SUBTYPE"},{"CodeValue":"PGFS","CodeDescription":"PowerGen-Field Service","Code":"SUBTYPE"},{"CodeValue":"PGI","CodeDescription":"PowerGen-Inside","Code":"SUBTYPE"},{"CodeValue":"PGM","CodeDescription":"PowerGen-Mobile","Code":"SUBTYPE"},{"CodeValue":"PGPM","CodeDescription":"PowerGen-Prev Maint","Code":"SUBTYPE"},{"CodeValue":"PGSE","CodeDescription":"POWER GEN SMALL ENGINE WO","Code":"SUBTYPE"},{"CodeValue":"PGUS","CodeDescription":"POWERGEN-UPSELL","Code":"SUBTYPE"},{"CodeValue":"PMINS","CodeDescription":"PM INSPECTION","Code":"SUBTYPE"},{"CodeValue":"REB","CodeDescription":"Rebuild","Code":"SUBTYPE"},{"CodeValue":"REB-FP-CUST","CodeDescription":"REBUILD FUEL PUMP-CUST","Code":"SUBTYPE"},{"CodeValue":"REB-FP-INT","CodeDescription":"REBUILD FUEL PUMP-INTERCO","Code":"SUBTYPE"},{"CodeValue":"REEFER","CodeDescription":"REEFER SERVICE","Code":"SUBTYPE"},{"CodeValue":"RENTFS","CodeDescription":"RENTAL CUSTOMER FIELD SER","Code":"SUBTYPE"},{"CodeValue":"RENTIS","CodeDescription":"RENTAL CUSTOMER  IN SHOP","Code":"SUBTYPE"},{"CodeValue":"RMIFS","CodeDescription":"REMOTE MINE IND FIELD SER","Code":"SUBTYPE"},{"CodeValue":"RV","CodeDescription":"RV DRIVE ENGINES","Code":"SUBTYPE"},{"CodeValue":"SC","CodeDescription":"Service Centre","Code":"SUBTYPE"},{"CodeValue":"TWO","CodeDescription":"THERMOKING LABOUR","Code":"SUBTYPE"},{"CodeValue":1097,"CodeDescription":"1097 Warranty Parts","Code":"SUBTYPE_INT"},{"CodeValue":"ACC","CodeDescription":"PROJ-VENDOR PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"ACCDRIVE","CodeDescription":"Drive Units and Systems","Code":"SUBTYPE_INT"},{"CodeValue":"AD-CONS","CodeDescription":"ADVERTISING-CONSUMER","Code":"SUBTYPE_INT"},{"CodeValue":"AD-OIL & GAS","CodeDescription":"ADVERTISING/-OIL & GAS","Code":"SUBTYPE_INT"},{"CodeValue":"ADAUTO","CodeDescription":"Advertising/Shows-AUTO/IN","Code":"SUBTYPE_INT"},{"CodeValue":"ADMINE","CodeDescription":"Advertising/Shows-MINES","Code":"SUBTYPE_INT"},{"CodeValue":"ADOS","CodeDescription":"Advertising/Shows-ONAN SA","Code":"SUBTYPE_INT"},{"CodeValue":"ADOTH","CodeDescription":"Advertising/Shows-OTHER","Code":"SUBTYPE_INT"},{"CodeValue":"ADPG","CodeDescription":"ADVERTISING/SHOWS-PG","Code":"SUBTYPE_INT"},{"CodeValue":"ADPGS","CodeDescription":"ADVERTISING/SHOWS-PG SERV","Code":"SUBTYPE_INT"},{"CodeValue":"ADPRT","CodeDescription":"Advertising/Shows-PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"ADREB","CodeDescription":"Advertising/Shows-REB","Code":"SUBTYPE_INT"},{"CodeValue":"ADREEFER","CodeDescription":"ADVERTISING/SHOWS-REEFER","Code":"SUBTYPE_INT"},{"CodeValue":"ADSC","CodeDescription":"Advertising/Shows-SC","Code":"SUBTYPE_INT"},{"CodeValue":"ADV SALES","CodeDescription":"ADVERTISING/SHOWS-SALES","Code":"SUBTYPE_INT"},{"CodeValue":"AEDRLL","CodeDescription":"A&E DRILLING FEE","Code":"SUBTYPE_INT"},{"CodeValue":"AEPARTS/TOOLS","CodeDescription":"AE PARTS & TOOLS","Code":"SUBTYPE_INT"},{"CodeValue":"AIRCOMPRESS","CodeDescription":"Compressed Air System","Code":"SUBTYPE_INT"},{"CodeValue":"AIRINTAKE","CodeDescription":"Air Intake System","Code":"SUBTYPE_INT"},{"CodeValue":"AS IS ENGINE COST","CodeDescription":"As is engine cost","Code":"SUBTYPE_INT"},{"CodeValue":"BM325","CodeDescription":"BUILDING MAINTENANCE-325","Code":"SUBTYPE_INT"},{"CodeValue":"BMOTH","CodeDescription":"Building Maintenance-OTHR","Code":"SUBTYPE_INT"},{"CodeValue":"BMPG","CodeDescription":"BUILDING MAINT-PG SERV","Code":"SUBTYPE_INT"},{"CodeValue":"BMPRT","CodeDescription":"Building Maintenance-PART","Code":"SUBTYPE_INT"},{"CodeValue":"BMREB","CodeDescription":"Building Maintenance-REB","Code":"SUBTYPE_INT"},{"CodeValue":"BMREEFER","CodeDescription":"BUILDING MAINT-REEFER","Code":"SUBTYPE_INT"},{"CodeValue":"BMRNTL","CodeDescription":"BUILDING MAINT-RENTALS","Code":"SUBTYPE_INT"},{"CodeValue":"BMSC","CodeDescription":"Building Maintenance-SC","Code":"SUBTYPE_INT"},{"CodeValue":"BMUP","CodeDescription":"BUILDING MAINT-UPFIT","Code":"SUBTYPE_INT"},{"CodeValue":"BONNYVILLE","CodeDescription":"BONNYVILLE","Code":"SUBTYPE_INT"},{"CodeValue":"BRAKES","CodeDescription":"Vehicle Braking","Code":"SUBTYPE_INT"},{"CodeValue":"CABLE MAIN","CodeDescription":"CABLE MAINTENANCE","Code":"SUBTYPE_INT"},{"CodeValue":"CAMFOLLOW","CodeDescription":"Cam Follower Assemblies","Code":"SUBTYPE_INT"},{"CodeValue":"CMTY","CodeDescription":"COMMUNITY INVOLVEMENT","Code":"SUBTYPE_INT"},{"CodeValue":"CMTY-FS","CodeDescription":"COMMUNITY INVOLVEMENT FS","Code":"SUBTYPE_INT"},{"CodeValue":"CMTY-PG","CodeDescription":"COMMUNITY INVOLVEMENT PG","Code":"SUBTYPE_INT"},{"CodeValue":"CMTY-REB","CodeDescription":"COMMUNITY INVOLVEMENT REB","Code":"SUBTYPE_INT"},{"CodeValue":"CMTY-RENT","CodeDescription":"COMMUNITY INVOLVEMENT 550","Code":"SUBTYPE_INT"},{"CodeValue":"CMTY300","CodeDescription":"COMMUNITY INVOLVEMENT 300","Code":"SUBTYPE_INT"},{"CodeValue":"COMFORT GUARD","CodeDescription":"COMFORT GUARD","Code":"SUBTYPE_INT"},{"CodeValue":"COMP REBUILD","CodeDescription":"COMPONENT REBUILD","Code":"SUBTYPE_INT"},{"CodeValue":"COMP SOL","CodeDescription":"COMP SOLUTIONS-DO NOT USE","Code":"SUBTYPE_INT"},{"CodeValue":"CONRODS","CodeDescription":"Connecting Rods","Code":"SUBTYPE_INT"},{"CodeValue":"CONSUMERSET","CodeDescription":"Upfit of consumer sets","Code":"SUBTYPE_INT"},{"CodeValue":"COOLING","CodeDescription":"Cooling System","Code":"SUBTYPE_INT"},{"CodeValue":"CORP VEH","CodeDescription":"REP & MAINT CORP VEH","Code":"SUBTYPE_INT"},{"CodeValue":"COS CECO MR DOEM","CodeDescription":"COS-CECO MR - DOEM","Code":"SUBTYPE_INT"},{"CodeValue":"COS CECO RETAIL","CodeDescription":"COS CECO RETAIL","Code":"SUBTYPE_INT"},{"CodeValue":"COS CPG","CodeDescription":"COST OF POWERGEN PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"COS ENGINES","CodeDescription":"COST OF ENG SALES DEALER","Code":"SUBTYPE_INT"},{"CodeValue":"COS OIL & GAS","CodeDescription":"COST OF SALES OIL & GAS","Code":"SUBTYPE_INT"},{"CodeValue":"COS PARTS","CodeDescription":"COST OF PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"COS RECON ENG","CodeDescription":"COST OF SALES RECON ENG","Code":"SUBTYPE_INT"},{"CodeValue":"COS YAMAHA","CodeDescription":"COS YAMAHA","Code":"SUBTYPE_INT"},{"CodeValue":"COS-B&S","CodeDescription":"COS-BRIGGS & STRATTON","Code":"SUBTYPE_INT"},{"CodeValue":"COS-CONSUMER-RETAIL","CodeDescription":"COS-Consumer-Retail","Code":"SUBTYPE_INT"},{"CodeValue":"COS-CONSUMER-RV","CodeDescription":"COS-Consumer-RV","Code":"SUBTYPE_INT"},{"CodeValue":"COS-HOMESB","CodeDescription":"COS-HOME STANDBY","Code":"SUBTYPE_INT"},{"CodeValue":"COS-MOBILE GS","CodeDescription":"COS-MOBILE GENSET","Code":"SUBTYPE_INT"},{"CodeValue":"COS-RENTFS","CodeDescription":"COS-RENTAL FS","Code":"SUBTYPE_INT"},{"CodeValue":"CSALESUP","CodeDescription":"SUPPLIES CUMMINS SALES","Code":"SUBTYPE_INT"},{"CodeValue":"CUST-ENG-FLAT REBUILD","CodeDescription":"Cust Eng Flatrate Rebuild","Code":"SUBTYPE_INT"},{"CodeValue":"CWCGEN","CodeDescription":"CWC GENERATOR","Code":"SUBTYPE_INT"},{"CodeValue":"CYLBLOCK","CodeDescription":"Cylinder Block","Code":"SUBTYPE_INT"},{"CodeValue":"CYLHEAD","CodeDescription":"Cylinder Head","Code":"SUBTYPE_INT"},{"CodeValue":"DFSE","CodeDescription":"PROJ-DFSE LABOR","Code":"SUBTYPE_INT"},{"CodeValue":"DIAVIK COSTS","CodeDescription":"DIAVIK LABOUR & COSTS","Code":"SUBTYPE_INT"},{"CodeValue":"DONATIONS","CodeDescription":"Donations or Gifts","Code":"SUBTYPE_INT"},{"CodeValue":"DPPG","CodeDescription":"DIST POLICY-PG SERVICE","Code":"SUBTYPE_INT"},{"CodeValue":"DPREB","CodeDescription":"Dist Policy-Rebuild","Code":"SUBTYPE_INT"},{"CodeValue":"DPSC","CodeDescription":"Dist Policy-Service Centr","Code":"SUBTYPE_INT"},{"CodeValue":"DRC AS400","CodeDescription":"**DO NOT USE**","Code":"SUBTYPE_INT"},{"CodeValue":"DW ESB","CodeDescription":"DIST WARR ESB","Code":"SUBTYPE_INT"},{"CodeValue":"DW FSE","CodeDescription":"DIST WARR FS ENGINE","Code":"SUBTYPE_INT"},{"CodeValue":"DW FSPG","CodeDescription":"DIST WARR FS POWER GEN","Code":"SUBTYPE_INT"},{"CodeValue":"DW IS","CodeDescription":"DIST WARR IN SHOP","Code":"SUBTYPE_INT"},{"CodeValue":"DW-REB","CodeDescription":"DIST WARR-REBUILD","Code":"SUBTYPE_INT"},{"CodeValue":"DW325","CodeDescription":"DIST WARR-325","Code":"SUBTYPE_INT"},{"CodeValue":"DWEXCCOMP","CodeDescription":"Dist Warr-Exch Comp","Code":"SUBTYPE_INT"},{"CodeValue":"DWPG","CodeDescription":"DIST WARR-PG SERVICE","Code":"SUBTYPE_INT"},{"CodeValue":"DWPGSALES","CodeDescription":"DIST WARR PG SALES","Code":"SUBTYPE_INT"},{"CodeValue":"DWPRT","CodeDescription":"DIST WARR - PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"DWREB","CodeDescription":"Dist Warr-Rebuild","Code":"SUBTYPE_INT"},{"CodeValue":"DWSC","CodeDescription":"Dist Warr-Service Centre","Code":"SUBTYPE_INT"},{"CodeValue":"DYNO","CodeDescription":"REPAIRS TO DYNO","Code":"SUBTYPE_INT"},{"CodeValue":"ENG DEL - FAB","CodeDescription":"ENGINE DELIVERY-FAB SHOP","Code":"SUBTYPE_INT"},{"CodeValue":"ENG DEL - FAB1","CodeDescription":"ENG DEL-FAB-NO PROJECT","Code":"SUBTYPE_INT"},{"CodeValue":"ENG DEL - OIL & GAS","CodeDescription":"ENGINE DELIVERY - OIL & G","Code":"SUBTYPE_INT"},{"CodeValue":"ENG DEL - REBUILD","CodeDescription":"ENGINE DELIVERY - REBUILD","Code":"SUBTYPE_INT"},{"CodeValue":"ENG DEL - TRUCK SHOP","CodeDescription":"ENGINE DELIVERY - TRUCK","Code":"SUBTYPE_INT"},{"CodeValue":"ENG-TRADEOUT","CodeDescription":"Warranty Engine Tradeout","Code":"SUBTYPE_INT"},{"CodeValue":"ENGCONTROL","CodeDescription":"Electronic Engine Control","Code":"SUBTYPE_INT"},{"CodeValue":"EQRTL300","CodeDescription":"EQUIP RENTAL DEPT 300","Code":"SUBTYPE_INT"},{"CodeValue":"EQRTL325","CodeDescription":"EQUIP RENTAL DEPT 325","Code":"SUBTYPE_INT"},{"CodeValue":"EQRTL530","CodeDescription":"EQUIP RENTAL DEPT 530","Code":"SUBTYPE_INT"},{"CodeValue":"EX-WAR","CodeDescription":"EX WARRANTY","Code":"SUBTYPE_INT"},{"CodeValue":"EXHAUST","CodeDescription":"Exhaust System","Code":"SUBTYPE_INT"},{"CodeValue":"EXP TOOLS - 340","CodeDescription":"EXPEND TOOLS 340","Code":"SUBTYPE_INT"},{"CodeValue":"EXP TOOLS - 430","CodeDescription":"EXPEND TOOLS 430","Code":"SUBTYPE_INT"},{"CodeValue":"EXP TOOLS - 535","CodeDescription":"EXPEND TOOLS DFSE","Code":"SUBTYPE_INT"},{"CodeValue":"EXP TOOLS - PG","CodeDescription":"EXPEND TOOLS PG SERVICE","Code":"SUBTYPE_INT"},{"CodeValue":"EXP TOOLS - RENTAL","CodeDescription":"EXPEND TOOLS RENTALS","Code":"SUBTYPE_INT"},{"CodeValue":"EXPENDABLE TOOLS","CodeDescription":"Expendable Tools Expense","Code":"SUBTYPE_INT"},{"CodeValue":"EXPENDABLE TOOLS 325","CodeDescription":"EXPENDABLE TOOLS 325","Code":"SUBTYPE_INT"},{"CodeValue":"EXWARR","CodeDescription":"ACCRUED EX ENG WARRANTY","Code":"SUBTYPE_INT"},{"CodeValue":"FCS FSE","CodeDescription":"FREE CUST FS ENGINE","Code":"SUBTYPE_INT"},{"CodeValue":"FCS FSPG","CodeDescription":"FREE CUST FS POWER GEN","Code":"SUBTYPE_INT"},{"CodeValue":"FCS IS","CodeDescription":"FREE CUST IN SHOP","Code":"SUBTYPE_INT"},{"CodeValue":"FCS-CON","CodeDescription":"FCS-CONSUMER","Code":"SUBTYPE_INT"},{"CodeValue":"FCS-DFSE","CodeDescription":"FCS-DFSE","Code":"SUBTYPE_INT"},{"CodeValue":"FCS325","CodeDescription":"FCS-325","Code":"SUBTYPE_INT"},{"CodeValue":"FCSADM","CodeDescription":"FCS-Administration","Code":"SUBTYPE_INT"},{"CodeValue":"FCSAE","CodeDescription":"FCS-APPLICATION ENGINEER","Code":"SUBTYPE_INT"},{"CodeValue":"FCSAUTO","CodeDescription":"FCS-Auto/Ind","Code":"SUBTYPE_INT"},{"CodeValue":"FCSESB","CodeDescription":"FCS-ESB","Code":"SUBTYPE_INT"},{"CodeValue":"FCSMINE","CodeDescription":"FCS-Mines","Code":"SUBTYPE_INT"},{"CodeValue":"FCSOIL","CodeDescription":"FCS-OIL AND GAS","Code":"SUBTYPE_INT"},{"CodeValue":"FCSOS","CodeDescription":"FCS-Onan Sales","Code":"SUBTYPE_INT"},{"CodeValue":"FCSPG","CodeDescription":"FCS-PG SERVICE","Code":"SUBTYPE_INT"},{"CodeValue":"FCSPME","CodeDescription":"FCS-PG PRIME","Code":"SUBTYPE_INT"},{"CodeValue":"FCSPP","CodeDescription":"FCS-PG POWER PLANT","Code":"SUBTYPE_INT"},{"CodeValue":"FCSPRT","CodeDescription":"FCS-Parts","Code":"SUBTYPE_INT"},{"CodeValue":"FCSREB","CodeDescription":"FCS-Rebuild","Code":"SUBTYPE_INT"},{"CodeValue":"FCSRVADM","CodeDescription":"FCS-RV CUSTOMER ADMIN","Code":"SUBTYPE_INT"},{"CodeValue":"FCSSB","CodeDescription":"FCS- PG STANBY","Code":"SUBTYPE_INT"},{"CodeValue":"FCSSC","CodeDescription":"FCS-Service Centre","Code":"SUBTYPE_INT"},{"CodeValue":"FCSTEC","CodeDescription":"FCS-Tehnical Support (RB)","Code":"SUBTYPE_INT"},{"CodeValue":"FCSUPFIT","CodeDescription":"FCS-UPFIT","Code":"SUBTYPE_INT"},{"CodeValue":"FEEDOC","CodeDescription":"PROJ-DOCUMENTAION FEES","Code":"SUBTYPE_INT"},{"CodeValue":"FEEPRJT","CodeDescription":"PROJ-PM FEE","Code":"SUBTYPE_INT"},{"CodeValue":"FEETECH","CodeDescription":"PROJ-TECH FEE","Code":"SUBTYPE_INT"},{"CodeValue":"FLAT RATE","CodeDescription":"FLAT RATE ENG REBUILD","Code":"SUBTYPE_INT"},{"CodeValue":"FREIGHTCLAIMS","CodeDescription":"Freightclaims","Code":"SUBTYPE_INT"},{"CodeValue":"FRT","CodeDescription":"PROJ-FREIGHT CHARGE","Code":"SUBTYPE_INT"},{"CodeValue":"FUELDYNO","CodeDescription":"FUEL DYNO","Code":"SUBTYPE_INT"},{"CodeValue":"FUELPUMP","CodeDescription":"Fuel Pumps","Code":"SUBTYPE_INT"},{"CodeValue":"GENSET-DLR","CodeDescription":"GEN SETS-WARRANTY DLR","Code":"SUBTYPE_INT"},{"CodeValue":"GERSHMAN","CodeDescription":"GERSHMAN UNIT TRACKING","Code":"SUBTYPE_INT"},{"CodeValue":"GS","CodeDescription":"PROJ-SERIALIZED GS","Code":"SUBTYPE_INT"},{"CodeValue":"INJECTORS","CodeDescription":"Injectors and Fuel Lines","Code":"SUBTYPE_INT"},{"CodeValue":"INTL RTL COS","CodeDescription":"INTL RTL COS","Code":"SUBTYPE_INT"},{"CodeValue":"INTSUB","CodeDescription":"BRANCH INTERNAL SUBLET","Code":"SUBTYPE_INT"},{"CodeValue":"INVENTORY","CodeDescription":"COST OF TAKING INVENTORY","Code":"SUBTYPE_INT"},{"CodeValue":"INVRE","CodeDescription":"INVENTORY REFURBISHMENT","Code":"SUBTYPE_INT"},{"CodeValue":"LAUNDRY","CodeDescription":"LAUNDRY","Code":"SUBTYPE_INT"},{"CodeValue":"LEASEHOLD IMPROVEMENTS","CodeDescription":"Leasehold Improvements","Code":"SUBTYPE_INT"},{"CodeValue":"LOADBANK","CodeDescription":"LOADBANK CHARGES","Code":"SUBTYPE_INT"},{"CodeValue":"LUBE","CodeDescription":"Lubricating Oil System","Code":"SUBTYPE_INT"},{"CodeValue":"MACQUARIE","CodeDescription":"MACQUARIE EQUIP","Code":"SUBTYPE_INT"},{"CodeValue":"MANUFACT","CodeDescription":"Assembly/Manufacture","Code":"SUBTYPE_INT"},{"CodeValue":"MCDFSE","CodeDescription":"PROJ-DFSE EXP","Code":"SUBTYPE_INT"},{"CodeValue":"MCPRJT","CodeDescription":"PROJ-PM EXP","Code":"SUBTYPE_INT"},{"CodeValue":"MCSALE","CodeDescription":"PROJ-WARCHEST","Code":"SUBTYPE_INT"},{"CodeValue":"MCTECH","CodeDescription":"PROJ-TECH EXP","Code":"SUBTYPE_INT"},{"CodeValue":"MINE CALL OUT","CodeDescription":"MINE CALL OUT-SPARWOOD","Code":"SUBTYPE_INT"},{"CodeValue":"MINE OR-IFS","CodeDescription":"MINE ORIENTATION - IFS","Code":"SUBTYPE_INT"},{"CodeValue":"MINE OR-PGFS","CodeDescription":"MINE ORIENTATION - PGFS","Code":"SUBTYPE_INT"},{"CodeValue":"MINE-ENG-REBUILD","CodeDescription":"Mine Engine Rebuilds","Code":"SUBTYPE_INT"},{"CodeValue":"MODDUTIES","CodeDescription":"MODIFIED DUTIES PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"MODDUTIES225","CodeDescription":"MODIFIED DUTIES PARTS FS","Code":"SUBTYPE_INT"},{"CodeValue":"MODDUTIES300","CodeDescription":"MODIFIED DUTIES 300","Code":"SUBTYPE_INT"},{"CodeValue":"MODDUTIES325","CodeDescription":"MODIFIED DUTIES 325","Code":"SUBTYPE_INT"},{"CodeValue":"MODDUTIES530","CodeDescription":"MODIFIED DUTIES 530","Code":"SUBTYPE_INT"},{"CodeValue":"MOUNTING","CodeDescription":"Mounting Adaptations","Code":"SUBTYPE_INT"},{"CodeValue":"MTG325","CodeDescription":"EMPLOYEE MEETING-325","Code":"SUBTYPE_INT"},{"CodeValue":"MTGPG","CodeDescription":"EMPLOYEE MEETING-PG SERVI","Code":"SUBTYPE_INT"},{"CodeValue":"MTGREB","CodeDescription":"Employee Meeting-REB","Code":"SUBTYPE_INT"},{"CodeValue":"MTGSC","CodeDescription":"Employee Meeting-SC","Code":"SUBTYPE_INT"},{"CodeValue":"NPL325","CodeDescription":"NON PRODUCT-LABOUR 325","Code":"SUBTYPE_INT"},{"CodeValue":"NPLESB","CodeDescription":"NON PRODUCT-LABOUR 340","Code":"SUBTYPE_INT"},{"CodeValue":"NPLIFS","CodeDescription":"NON PRODUCT-LABR FS SERV","Code":"SUBTYPE_INT"},{"CodeValue":"NPLIFS325","CodeDescription":"NON PRODUCT-LABR FS 325","Code":"SUBTYPE_INT"},{"CodeValue":"NPLPG","CodeDescription":"NON PRODUCT-LAB PG SERV","Code":"SUBTYPE_INT"},{"CodeValue":"NPLREB","CodeDescription":"Non Product-Labour Reb","Code":"SUBTYPE_INT"},{"CodeValue":"NPLRNT","CodeDescription":"NON PRODUCT-LAB RENTAL","Code":"SUBTYPE_INT"},{"CodeValue":"NPLSC","CodeDescription":"Non Product-Labour Svc Ct","Code":"SUBTYPE_INT"},{"CodeValue":"NPT","CodeDescription":"NON PRODUCTIVE TIME","Code":"SUBTYPE_INT"},{"CodeValue":"OB FSE","CodeDescription":"ONBOARDING FS ENGINE","Code":"SUBTYPE_INT"},{"CodeValue":"OB FSESB","CodeDescription":"ONBOARDING FS ESB","Code":"SUBTYPE_INT"},{"CodeValue":"OB FSPG","CodeDescription":"ONBOARDING FS POWER GEN","Code":"SUBTYPE_INT"},{"CodeValue":"OB IS","CodeDescription":"ONBOARDING IN SHOP","Code":"SUBTYPE_INT"},{"CodeValue":"OFFSUPP","CodeDescription":"OFFICE SUPPLIES DEPT 400","Code":"SUBTYPE_INT"},{"CodeValue":"ONANSALES","CodeDescription":"ONAN SALES","Code":"SUBTYPE_INT"},{"CodeValue":"OUTSIDE REPAIRS-PG","CodeDescription":"OUTSIDE REPAIRS - PG SERV","Code":"SUBTYPE_INT"},{"CodeValue":"PARTS WAGES","CodeDescription":"PTS WAGE WK DIF BR","Code":"SUBTYPE_INT"},{"CodeValue":"PARTS WRITE OFF","CodeDescription":"PARTS WRITE OFF","Code":"SUBTYPE_INT"},{"CodeValue":"PARTSADJ","CodeDescription":"Parts Adj for Ks W.O","Code":"SUBTYPE_INT"},{"CodeValue":"PG-START","CodeDescription":"PG - START UP FOR PROJECT","Code":"SUBTYPE_INT"},{"CodeValue":"PG-UPFIT","CodeDescription":"PG-UPFIT FOR PROJECTS","Code":"SUBTYPE_INT"},{"CodeValue":"PGONB","CodeDescription":"PG ONBOARDING TRAINING","Code":"SUBTYPE_INT"},{"CodeValue":"PMINTERNAL","CodeDescription":"Internal PM COS","Code":"SUBTYPE_INT"},{"CodeValue":"PROJ-ACK","CodeDescription":"Auto Cost/KM-Projects","Code":"SUBTYPE_INT"},{"CodeValue":"PROJ-CG","CodeDescription":"COGENERATION-PROJECTS","Code":"SUBTYPE_INT"},{"CodeValue":"PROJ-GS","CodeDescription":"Gen Sets-Projects","Code":"SUBTYPE_INT"},{"CodeValue":"PROJ-ICH","CodeDescription":"DO NOT USE","Code":"SUBTYPE_INT"},{"CodeValue":"PROJ-MACDON","CodeDescription":"MACDON","Code":"SUBTYPE_INT"},{"CodeValue":"QUICKSERVE","CodeDescription":"QUICKSERVE","Code":"SUBTYPE_INT"},{"CodeValue":"REB-CYL BLK","CodeDescription":"REBUILD CYLINDER BLOCK","Code":"SUBTYPE_INT"},{"CodeValue":"REB-FP-904","CodeDescription":"REBUILD FUEL PUMP - 904","Code":"SUBTYPE_INT"},{"CodeValue":"REB-STEAM/TEAR","CodeDescription":"REBUILD-STEAM/TEAR DOWN","Code":"SUBTYPE_INT"},{"CodeValue":"REBINT","CodeDescription":"REBUILD INTERNAL","Code":"SUBTYPE_INT"},{"CodeValue":"RECALEX","CodeDescription":"Recalibrate Exchange Prod","Code":"SUBTYPE_INT"},{"CodeValue":"REEFER-CORE","CodeDescription":"REEFER CORE RETURNS","Code":"SUBTYPE_INT"},{"CodeValue":"REEFER-EXCWARR","CodeDescription":"REEFER EX PARTS WARRANTY","Code":"SUBTYPE_INT"},{"CodeValue":"REEFERNEI","CodeDescription":"REEFER UNIT INSPECTIONS","Code":"SUBTYPE_INT"},{"CodeValue":"REEFERSALES","CodeDescription":"REEFER SALES","Code":"SUBTYPE_INT"},{"CodeValue":"REEFERWARR","CodeDescription":"REEFER WARRANTY PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"REM TRVL PG","CodeDescription":"REMOTE TRAVEL PG","Code":"SUBTYPE_INT"},{"CodeValue":"RENTAL ASSET","CodeDescription":"RENTAL ASSET IMPROVEMENT","Code":"SUBTYPE_INT"},{"CodeValue":"RENTAL CAPEX UPFIT","CodeDescription":"RENTAL CAPEX - UPFIT","Code":"SUBTYPE_INT"},{"CodeValue":"RENTAL CHECKIN/OUT","CodeDescription":"RENTAL UNIT CHECKIN/OUT","Code":"SUBTYPE_INT"},{"CodeValue":"RENTAL MAINT","CodeDescription":"RENTAL GENERAL MAINTENANC","Code":"SUBTYPE_INT"},{"CodeValue":"RENTAL MAJOR REPAIR","CodeDescription":"RENTAL MAJOR REPAIR","Code":"SUBTYPE_INT"},{"CodeValue":"RENTAL MINOR REPAIR","CodeDescription":"RENTAL MINOR REPAIR","Code":"SUBTYPE_INT"},{"CodeValue":"RENTAL UPFIT","CodeDescription":"RENTUPFIT/PREP FOR RENT","Code":"SUBTYPE_INT"},{"CodeValue":"RESPEC","CodeDescription":"Respec Internal to S.N.","Code":"SUBTYPE_INT"},{"CodeValue":"RESPECSC","CodeDescription":"RESPEC SC INTERNAL TO S/N","Code":"SUBTYPE_INT"},{"CodeValue":"RM100","CodeDescription":"REPAIRS/MAIN EQUIP-100","Code":"SUBTYPE_INT"},{"CodeValue":"RM225","CodeDescription":"REPAIRS/MAIN EQUIP-225","Code":"SUBTYPE_INT"},{"CodeValue":"RM325","CodeDescription":"REPAIRS/MAIN EQUIP-325","Code":"SUBTYPE_INT"},{"CodeValue":"RMADV","CodeDescription":"ADVERTISING/SHOWS-RM","Code":"SUBTYPE_INT"},{"CodeValue":"RMBM","CodeDescription":"BLDG MAINTENANCE-RM","Code":"SUBTYPE_INT"},{"CodeValue":"RMDW","CodeDescription":"DIST WARR-REMOTE MINING","Code":"SUBTYPE_INT"},{"CodeValue":"RMESB","CodeDescription":"REPAIRS/MAIN EQUIP-ESB","Code":"SUBTYPE_INT"},{"CodeValue":"RMFCS","CodeDescription":"FCS-REMOTE MINING","Code":"SUBTYPE_INT"},{"CodeValue":"RMMTG","CodeDescription":"EMPL MTGS- RM","Code":"SUBTYPE_INT"},{"CodeValue":"RMNPT","CodeDescription":"NON PRODUCTIVE TIME-RM","Code":"SUBTYPE_INT"},{"CodeValue":"RMOTH","CodeDescription":"Repairs/Main Equip-OTHER","Code":"SUBTYPE_INT"},{"CodeValue":"RMPG","CodeDescription":"REPAIRS/MAIN EQUIP-PG SER","Code":"SUBTYPE_INT"},{"CodeValue":"RMPRT","CodeDescription":"Repairs/Main Equip-PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"RMREB","CodeDescription":"Repairs/Main Equip-REB","Code":"SUBTYPE_INT"},{"CodeValue":"RMRM","CodeDescription":"REPAIRS/MAIN EQUIP-RM","Code":"SUBTYPE_INT"},{"CodeValue":"RMRNT","CodeDescription":"REPAIRS/MAIN EQUIP-RENTAL","Code":"SUBTYPE_INT"},{"CodeValue":"RMSAFETY","CodeDescription":"SAFETY EXP REMOTE MINING","Code":"SUBTYPE_INT"},{"CodeValue":"RMSC","CodeDescription":"Repairs/Main Equip-SC","Code":"SUBTYPE_INT"},{"CodeValue":"RMSU","CodeDescription":"SUPERVISION-RM","Code":"SUBTYPE_INT"},{"CodeValue":"RMSUP","CodeDescription":"SUPPLIES-REMOTE MINING","Code":"SUBTYPE_INT"},{"CodeValue":"RMSVC","CodeDescription":"REPAIRS/MAIN EQUIP-SERVIC","Code":"SUBTYPE_INT"},{"CodeValue":"RMTOOLS","CodeDescription":"EXPENDABLE TOOLS-RM","Code":"SUBTYPE_INT"},{"CodeValue":"RMTOOLS 325","CodeDescription":"EXPENDABLE TOOLS-325","Code":"SUBTYPE_INT"},{"CodeValue":"RMTRN","CodeDescription":"TRAINING-REMOTE MINING","Code":"SUBTYPE_INT"},{"CodeValue":"RMUPFIT","CodeDescription":"REPAIRS/MAIN EQUIP-UPFIT","Code":"SUBTYPE_INT"},{"CodeValue":"RMVM","CodeDescription":"VEHICLE MAINT-RM","Code":"SUBTYPE_INT"},{"CodeValue":"RNTL CPG BLT ASSET","CodeDescription":"RNTL CPG BLT ASSET IMPROV","Code":"SUBTYPE_INT"},{"CodeValue":"ROCKERS","CodeDescription":"Rocker Lever Assemblies","Code":"SUBTYPE_INT"},{"CodeValue":"SAFE 200","CodeDescription":"SAFETY EXP DEPT 200","Code":"SUBTYPE_INT"},{"CodeValue":"SAFE 300","CodeDescription":"SAFETY EXP DEPT 300","Code":"SUBTYPE_INT"},{"CodeValue":"SAFE 310","CodeDescription":"SAFETY EXP DEPT 310","Code":"SUBTYPE_INT"},{"CodeValue":"SAFE 325","CodeDescription":"SAFETY EXP DEPT 325","Code":"SUBTYPE_INT"},{"CodeValue":"SAFE 510","CodeDescription":"SAFETY EXP DEPT 510","Code":"SUBTYPE_INT"},{"CodeValue":"SAFE 530","CodeDescription":"SAFETY EXP DEPT 530","Code":"SUBTYPE_INT"},{"CodeValue":"SAFE 550","CodeDescription":"SAFETY EXP DEPT 550","Code":"SUBTYPE_INT"},{"CodeValue":"SAFETY","CodeDescription":"SAFETY EXP DEPT 400","Code":"SUBTYPE_INT"},{"CodeValue":"SHOPEQUIP","CodeDescription":"Shop Equip Fixed Asset","Code":"SUBTYPE_INT"},{"CodeValue":"SHOPEQUIP-WIP","CodeDescription":"SHOPEQUIP FIXED ASSET-WIP","Code":"SUBTYPE_INT"},{"CodeValue":"SHOW-O&G","CodeDescription":"SHOWS OIL AND GAS","Code":"SUBTYPE_INT"},{"CodeValue":"START UP","CodeDescription":"PG START UP","Code":"SUBTYPE_INT"},{"CodeValue":"STARTUP","CodeDescription":"Startup for pre-bp2000 wo","Code":"SUBTYPE_INT"},{"CodeValue":"STEAMBAY","CodeDescription":"STEAMBAY - EDMONTON","Code":"SUBTYPE_INT"},{"CodeValue":"STFS","CodeDescription":"PROJ-STARTUP FIELD SVC","Code":"SUBTYPE_INT"},{"CodeValue":"STOLEN GOODS UNDER DEDUCT","CodeDescription":"STOLEN GOODS UNDER DEDUCT","Code":"SUBTYPE_INT"},{"CodeValue":"SUFS","CodeDescription":"SUPERVISION-FS 325","Code":"SUBTYPE_INT"},{"CodeValue":"SUOOS","CodeDescription":"START-UP OUT OF SCOPE","Code":"SUBTYPE_INT"},{"CodeValue":"SUP FS PARTS","CodeDescription":"SUPPLIES - FS PARTS DEPT","Code":"SUBTYPE_INT"},{"CodeValue":"SUP PARTS","CodeDescription":"SUPPLIES - PARTS DEPT","Code":"SUBTYPE_INT"},{"CodeValue":"SUP325","CodeDescription":"SUPPLIES-325","Code":"SUBTYPE_INT"},{"CodeValue":"SUP535","CodeDescription":"SUPPLIES-535","Code":"SUBTYPE_INT"},{"CodeValue":"SUPADM","CodeDescription":"Supplies-Admin","Code":"SUBTYPE_INT"},{"CodeValue":"SUPAUTO","CodeDescription":"Supplies-AUTO/IND","Code":"SUBTYPE_INT"},{"CodeValue":"SUPESB","CodeDescription":"SUPPLIES-ESB","Code":"SUBTYPE_INT"},{"CodeValue":"SUPG","CodeDescription":"SUPERVISION-PG SERVICE","Code":"SUBTYPE_INT"},{"CodeValue":"SUPIND","CodeDescription":"SUPPLIES - INDUSTRIAL","Code":"SUBTYPE_INT"},{"CodeValue":"SUPMINE","CodeDescription":"Supplies-MINES","Code":"SUBTYPE_INT"},{"CodeValue":"SUPOS","CodeDescription":"Supplies-Onan Sales","Code":"SUBTYPE_INT"},{"CodeValue":"SUPPG","CodeDescription":"Supplies-PG SERV","Code":"SUBTYPE_INT"},{"CodeValue":"SUPPRT","CodeDescription":"Supplies-PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"SUPREB","CodeDescription":"Supplies-REBUILD","Code":"SUBTYPE_INT"},{"CodeValue":"SUPREEFER","CodeDescription":"SHOP SUPPLIES - REEFER","Code":"SUBTYPE_INT"},{"CodeValue":"SUPREN","CodeDescription":"SUPPLIES-RENTALS","Code":"SUBTYPE_INT"},{"CodeValue":"SUPSC","CodeDescription":"Supplies-SC","Code":"SUBTYPE_INT"},{"CodeValue":"SUPTRN","CodeDescription":"Supplies-Training Dept","Code":"SUBTYPE_INT"},{"CodeValue":"SUPUP","CodeDescription":"SUPPLIES - UPFIT","Code":"SUBTYPE_INT"},{"CodeValue":"SUREB","CodeDescription":"Supervision-REB","Code":"SUBTYPE_INT"},{"CodeValue":"SUREEFER","CodeDescription":"SUPERVISION - REEFER","Code":"SUBTYPE_INT"},{"CodeValue":"SURNT","CodeDescription":"SUPERVISION - RENTAL DEPT","Code":"SUBTYPE_INT"},{"CodeValue":"SUSC","CodeDescription":"Supervision-TS","Code":"SUBTYPE_INT"},{"CodeValue":"TEMPLOC","CodeDescription":"Tec charged to other loc","Code":"SUBTYPE_INT"},{"CodeValue":"TRN FSE","CodeDescription":"TRAINING FS ENGINE","Code":"SUBTYPE_INT"},{"CodeValue":"TRN FSESB","CodeDescription":"TRAINING FS ESB","Code":"SUBTYPE_INT"},{"CodeValue":"TRN FSPG","CodeDescription":"TRAINING FS POWER GEN","Code":"SUBTYPE_INT"},{"CodeValue":"TRN IS","CodeDescription":"TRAINING IN SHOP","Code":"SUBTYPE_INT"},{"CodeValue":"TRN-MISC","CodeDescription":"Mis Charg to trainingdept","Code":"SUBTYPE_INT"},{"CodeValue":"TRN325","CodeDescription":"TRAINING-325","Code":"SUBTYPE_INT"},{"CodeValue":"TRN560","CodeDescription":"TRAINING-560","Code":"SUBTYPE_INT"},{"CodeValue":"TRNPG","CodeDescription":"TRAINING-PG SERVICE","Code":"SUBTYPE_INT"},{"CodeValue":"TRNREB","CodeDescription":"Training-REB","Code":"SUBTYPE_INT"},{"CodeValue":"TRNREEFER","CodeDescription":"TRAINING - REEFER","Code":"SUBTYPE_INT"},{"CodeValue":"TRNRNT","CodeDescription":"TRAINING - RENTAL DEPT","Code":"SUBTYPE_INT"},{"CodeValue":"TRNSC","CodeDescription":"TRAINING-SERVICE CENTRE","Code":"SUBTYPE_INT"},{"CodeValue":"TRNUP","CodeDescription":"TRAINING-UPFIT","Code":"SUBTYPE_INT"},{"CodeValue":"TS","CodeDescription":"PROJ-TRANSFER SWITCH","Code":"SUBTYPE_INT"},{"CodeValue":"UPFS","CodeDescription":"PROJ-UPFIT FIELD SERVICE","Code":"SUBTYPE_INT"},{"CodeValue":"UPGRADE CORE FOR RETURN","CodeDescription":"UPGRADE CORE FOR RETURN","Code":"SUBTYPE_INT"},{"CodeValue":"UPIS","CodeDescription":"PROJ-UPFIT IN SHOP","Code":"SUBTYPE_INT"},{"CodeValue":"VM325","CodeDescription":"VEHICLE MAINT-325","Code":"SUBTYPE_INT"},{"CodeValue":"VM340","CodeDescription":"VEHICLE MAINT-340","Code":"SUBTYPE_INT"},{"CodeValue":"VMFS","CodeDescription":"VEHICLE MAINT-PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"VMPG","CodeDescription":"VEHICLE MAINT-PG SERV","Code":"SUBTYPE_INT"},{"CodeValue":"VMPTS","CodeDescription":"VEHICLE MAINT-PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"VMREB","CodeDescription":"Vehicle Maint-REB","Code":"SUBTYPE_INT"},{"CodeValue":"VMREEFER","CodeDescription":"VEHICLE MAINT. - REEFER","Code":"SUBTYPE_INT"},{"CodeValue":"VMRENT","CodeDescription":"VEHICLE MAINT-RENTALS","Code":"SUBTYPE_INT"},{"CodeValue":"VMSC","CodeDescription":"Vehicle Maint-SC","Code":"SUBTYPE_INT"},{"CodeValue":"WATERPG","CodeDescription":"WATER TREATMENT-PG SERV","Code":"SUBTYPE_INT"},{"CodeValue":"WATERREB","CodeDescription":"Water Treatment-Rebuild","Code":"SUBTYPE_INT"},{"CodeValue":"WATERSC","CodeDescription":"Water Treatment -ServiceC","Code":"SUBTYPE_INT"},{"CodeValue":"WCB-DAY OF INJURY","CodeDescription":"WCB DAY OF INJURY","Code":"SUBTYPE_INT"},{"CodeValue":"WD","CodeDescription":"USED DIESEL PARTS","Code":"SUBTYPE_INT"},{"CodeValue":"WESTERN STAR MARKETING","CodeDescription":"Western Star Marketing","Code":"SUBTYPE_INT"},{"CodeValue":"WTRN","CodeDescription":"WARRANTY TRAINING","Code":"SUBTYPE_INT"},{"CodeValue":"XLEASE","CodeDescription":"MACQUARIE LEASED UNITS","Code":"SUBTYPE_INT"},{"CodeValue":"BUS","CodeDescription":"BUS","Code":"UNIT_TYPE"},{"CodeValue":"R. E. BUS","CodeDescription":"R. E. BUS","Code":"UNIT_TYPE"},{"CodeValue":"100 TON DUMP","CodeDescription":"100 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"120 TON DUMP","CodeDescription":"120 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"130 TON DUMP","CodeDescription":"130 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"140 TON DUMP","CodeDescription":"140 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"150 TON DUMP","CodeDescription":"150 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"160 TON DUMP","CodeDescription":"160 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"170 TON DUMP","CodeDescription":"170 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"176 TON DUMP","CodeDescription":"176 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"190 TON DUMP","CodeDescription":"190 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"2 WD TRACTORS","CodeDescription":"2 WD TRACTORS","Code":"UNIT_TYPE"},{"CodeValue":"200 TON REAR DU","CodeDescription":"200 TON REAR DU","Code":"UNIT_TYPE"},{"CodeValue":"240 TON DUMP","CodeDescription":"240 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"28 TON DUMP","CodeDescription":"28 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"280 TON DUMP","CodeDescription":"280 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"2WD TRACTOR","CodeDescription":"2WD TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"35 TON DUMP","CodeDescription":"35 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"40 TON DUMP","CodeDescription":"40 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"4WD TRACTOR","CodeDescription":"4WD TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"50 TON DUMP","CodeDescription":"50 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"55 TON DUMP","CodeDescription":"55 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"60 TON DUMP","CodeDescription":"60 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"65 TON DUMP","CodeDescription":"65 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"75 TON DUMP","CodeDescription":"75 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":"85 TON DUMP","CodeDescription":"85 TON DUMP","Code":"UNIT_TYPE"},{"CodeValue":864,"CodeDescription":864,"Code":"UNIT_TYPE"},{"CodeValue":8780,"CodeDescription":8780,"Code":"UNIT_TYPE"},{"CodeValue":8810,"CodeDescription":8810,"Code":"UNIT_TYPE"},{"CodeValue":"8X8 TRUCK","CodeDescription":"8X8 TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"A/C EARTHMOVER","CodeDescription":"A/C EARTHMOVER","Code":"UNIT_TYPE"},{"CodeValue":"A/F TOW TRACTOR","CodeDescription":"A/F TOW TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"A/T","CodeDescription":"A/T","Code":"UNIT_TYPE"},{"CodeValue":"A/T CRANE","CodeDescription":"A/T CRANE","Code":"UNIT_TYPE"},{"CodeValue":"AC","CodeDescription":"AC","Code":"UNIT_TYPE"},{"CodeValue":"AERIAL LIFT","CodeDescription":"AERIAL LIFT","Code":"UNIT_TYPE"},{"CodeValue":"AERIAL PLATFORM","CodeDescription":"AERIAL PLATFORM","Code":"UNIT_TYPE"},{"CodeValue":"AGGREGATE SPRDR","CodeDescription":"AGGREGATE SPRDR","Code":"UNIT_TYPE"},{"CodeValue":"AGRICULTURE","CodeDescription":"AGRICULTURE","Code":"UNIT_TYPE"},{"CodeValue":"AIR COMPRESSOR","CodeDescription":"AIR COMPRESSOR","Code":"UNIT_TYPE"},{"CodeValue":"AIR CONDITIONER","CodeDescription":"AIR CONDITIONER","Code":"UNIT_TYPE"},{"CodeValue":"AIR GRND SUPPOR","CodeDescription":"AIR GRND SUPPOR","Code":"UNIT_TYPE"},{"CodeValue":"AIR GRND SUPRT","CodeDescription":"AIR GRND SUPRT","Code":"UNIT_TYPE"},{"CodeValue":"AIR GROUND SPRT","CodeDescription":"AIR GROUND SPRT","Code":"UNIT_TYPE"},{"CodeValue":"AIRCRAF TRACTOR","CodeDescription":"AIRCRAF TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"AIRCRAFT GD SUP","CodeDescription":"AIRCRAFT GD SUP","Code":"UNIT_TYPE"},{"CodeValue":"AIRCRAFT HEATER","CodeDescription":"AIRCRAFT HEATER","Code":"UNIT_TYPE"},{"CodeValue":"AIRCRAFT TRACTO","CodeDescription":"AIRCRAFT TRACTO","Code":"UNIT_TYPE"},{"CodeValue":"AIRCRAFTSTARTER","CodeDescription":"AIRCRAFTSTARTER","Code":"UNIT_TYPE"},{"CodeValue":"AIRPORT SWEEPER","CodeDescription":"AIRPORT SWEEPER","Code":"UNIT_TYPE"},{"CodeValue":"ALAMO STREETCAR","CodeDescription":"ALAMO STREETCAR","Code":"UNIT_TYPE"},{"CodeValue":"ALL","CodeDescription":"ALL","Code":"UNIT_TYPE"},{"CodeValue":"ALL CONFIG","CodeDescription":"ALL CONFIG","Code":"UNIT_TYPE"},{"CodeValue":"ALL TERR CRANE","CodeDescription":"ALL TERR CRANE","Code":"UNIT_TYPE"},{"CodeValue":"ALL TERRAIN","CodeDescription":"ALL TERRAIN","Code":"UNIT_TYPE"},{"CodeValue":"ALL TERRAIN TRK","CodeDescription":"ALL TERRAIN TRK","Code":"UNIT_TYPE"},{"CodeValue":"ALLIGATOR HOOD","CodeDescription":"ALLIGATOR HOOD","Code":"UNIT_TYPE"},{"CodeValue":"AMPHIB. ASSAULT","CodeDescription":"AMPHIB. ASSAULT","Code":"UNIT_TYPE"},{"CodeValue":"AMPHIBIOUS","CodeDescription":"AMPHIBIOUS","Code":"UNIT_TYPE"},{"CodeValue":"ANG/TLT DOZER","CodeDescription":"ANG/TLT DOZER","Code":"UNIT_TYPE"},{"CodeValue":"ARCTIC DUMP","CodeDescription":"ARCTIC DUMP","Code":"UNIT_TYPE"},{"CodeValue":"ARMORED VEHICLE","CodeDescription":"ARMORED VEHICLE","Code":"UNIT_TYPE"},{"CodeValue":"ARTICULATED BUS","CodeDescription":"ARTICULATED BUS","Code":"UNIT_TYPE"},{"CodeValue":"ASPHALT PAVING","CodeDescription":"ASPHALT PAVING","Code":"UNIT_TYPE"},{"CodeValue":"ASPHALT ROLLER","CodeDescription":"ASPHALT ROLLER","Code":"UNIT_TYPE"},{"CodeValue":"ATT","CodeDescription":"ATT","Code":"UNIT_TYPE"},{"CodeValue":"AUTO CARRIER","CodeDescription":"AUTO CARRIER","Code":"UNIT_TYPE"},{"CodeValue":"AUTOMOTIVE","CodeDescription":"AUTOMOTIVE","Code":"UNIT_TYPE"},{"CodeValue":"AX","CodeDescription":"AX","Code":"UNIT_TYPE"},{"CodeValue":"BACK HOE","CodeDescription":"BACK HOE","Code":"UNIT_TYPE"},{"CodeValue":"BACKHOE","CodeDescription":"BACKHOE","Code":"UNIT_TYPE"},{"CodeValue":"BACKHOE LOADER","CodeDescription":"BACKHOE LOADER","Code":"UNIT_TYPE"},{"CodeValue":"BAGGAGE BELT","CodeDescription":"BAGGAGE BELT","Code":"UNIT_TYPE"},{"CodeValue":"BAGGAGE LOADER","CodeDescription":"BAGGAGE LOADER","Code":"UNIT_TYPE"},{"CodeValue":"BAGGAGE TOW TRC","CodeDescription":"BAGGAGE TOW TRC","Code":"UNIT_TYPE"},{"CodeValue":"BOAT","CodeDescription":"BOAT","Code":"UNIT_TYPE"},{"CodeValue":"BOTTOM DUMP","CodeDescription":"BOTTOM DUMP","Code":"UNIT_TYPE"},{"CodeValue":"BRUSH CHIPPER","CodeDescription":"BRUSH CHIPPER","Code":"UNIT_TYPE"},{"CodeValue":"BUCKETWHEEL EX","CodeDescription":"BUCKETWHEEL EX","Code":"UNIT_TYPE"},{"CodeValue":"BULDOZER","CodeDescription":"BULDOZER","Code":"UNIT_TYPE"},{"CodeValue":"BULLDOZER","CodeDescription":"BULLDOZER","Code":"UNIT_TYPE"},{"CodeValue":"BULLDOZER","CodeDescription":"BULLDOZER","Code":"UNIT_TYPE"},{"CodeValue":"BUS","CodeDescription":"BUS","Code":"UNIT_TYPE"},{"CodeValue":"BUS","CodeDescription":"BUS","Code":"UNIT_TYPE"},{"CodeValue":"CAB OVER","CodeDescription":"CAB OVER","Code":"UNIT_TYPE"},{"CodeValue":"CAB OVER ENGIN","CodeDescription":"CAB OVER ENGIN","Code":"UNIT_TYPE"},{"CodeValue":"CAB OVER ENGINE","CodeDescription":"CAB OVER ENGINE","Code":"UNIT_TYPE"},{"CodeValue":"CAB OVER TRUCK","CodeDescription":"CAB OVER TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"CABOVER","CodeDescription":"CABOVER","Code":"UNIT_TYPE"},{"CodeValue":"CABOVER ENGINE","CodeDescription":"CABOVER ENGINE","Code":"UNIT_TYPE"},{"CodeValue":"CARGO","CodeDescription":"CARGO","Code":"UNIT_TYPE"},{"CodeValue":"CARGO VAN","CodeDescription":"CARGO VAN","Code":"UNIT_TYPE"},{"CodeValue":"CARRYLIFT","CodeDescription":"CARRYLIFT","Code":"UNIT_TYPE"},{"CodeValue":"CHIP HARVESTER","CodeDescription":"CHIP HARVESTER","Code":"UNIT_TYPE"},{"CodeValue":"CHIP SPREADER","CodeDescription":"CHIP SPREADER","Code":"UNIT_TYPE"},{"CodeValue":"CHIPPER","CodeDescription":"CHIPPER","Code":"UNIT_TYPE"},{"CodeValue":"CHIPSCREEN SYST","CodeDescription":"CHIPSCREEN SYST","Code":"UNIT_TYPE"},{"CodeValue":"CM","CodeDescription":"CM","Code":"UNIT_TYPE"},{"CodeValue":"COACH","CodeDescription":"COACH","Code":"UNIT_TYPE"},{"CodeValue":"COACH BUS","CodeDescription":"COACH BUS","Code":"UNIT_TYPE"},{"CodeValue":"COAL STRIPPER","CodeDescription":"COAL STRIPPER","Code":"UNIT_TYPE"},{"CodeValue":"COE","CodeDescription":"COE","Code":"UNIT_TYPE"},{"CodeValue":"COLD MILING MC","CodeDescription":"COLD MILING MC","Code":"UNIT_TYPE"},{"CodeValue":"COLD MILLING","CodeDescription":"COLD MILLING","Code":"UNIT_TYPE"},{"CodeValue":"COLD MILLING MC","CodeDescription":"COLD MILLING MC","Code":"UNIT_TYPE"},{"CodeValue":"COLD PLANER","CodeDescription":"COLD PLANER","Code":"UNIT_TYPE"},{"CodeValue":"COMBINE","CodeDescription":"COMBINE","Code":"UNIT_TYPE"},{"CodeValue":"COMMANDO CARS","CodeDescription":"COMMANDO CARS","Code":"UNIT_TYPE"},{"CodeValue":"COMPACTION EQ","CodeDescription":"COMPACTION EQ","Code":"UNIT_TYPE"},{"CodeValue":"COMPACTION EQIP","CodeDescription":"COMPACTION EQIP","Code":"UNIT_TYPE"},{"CodeValue":"COMPACTION ROLL","CodeDescription":"COMPACTION ROLL","Code":"UNIT_TYPE"},{"CodeValue":"COMPACTOR","CodeDescription":"COMPACTOR","Code":"UNIT_TYPE"},{"CodeValue":"COMPACTOR-ASPHA","CodeDescription":"COMPACTOR-ASPHA","Code":"UNIT_TYPE"},{"CodeValue":"COMPACTOR-SOIL","CodeDescription":"COMPACTOR-SOIL","Code":"UNIT_TYPE"},{"CodeValue":"COMPOST MACHINE","CodeDescription":"COMPOST MACHINE","Code":"UNIT_TYPE"},{"CodeValue":"COMPOST TURNER","CodeDescription":"COMPOST TURNER","Code":"UNIT_TYPE"},{"CodeValue":"COMPRESSOR","CodeDescription":"COMPRESSOR","Code":"UNIT_TYPE"},{"CodeValue":"CONC FLOATER","CodeDescription":"CONC FLOATER","Code":"UNIT_TYPE"},{"CodeValue":"CONCRETE CUTTER","CodeDescription":"CONCRETE CUTTER","Code":"UNIT_TYPE"},{"CodeValue":"CONCRETE EQUIP","CodeDescription":"CONCRETE EQUIP","Code":"UNIT_TYPE"},{"CodeValue":"CONCRETE PUMP","CodeDescription":"CONCRETE PUMP","Code":"UNIT_TYPE"},{"CodeValue":"CONCRETE TRANS","CodeDescription":"CONCRETE TRANS","Code":"UNIT_TYPE"},{"CodeValue":"CONSTR  CONV","CodeDescription":"CONSTR  CONV","Code":"UNIT_TYPE"},{"CodeValue":"CONSTR CONV","CodeDescription":"CONSTR CONV","Code":"UNIT_TYPE"},{"CodeValue":"CONSTRUCITON","CodeDescription":"CONSTRUCITON","Code":"UNIT_TYPE"},{"CodeValue":"CONSTRUCTION","CodeDescription":"CONSTRUCTION","Code":"UNIT_TYPE"},{"CodeValue":"CONT HANDLER","CodeDescription":"CONT HANDLER","Code":"UNIT_TYPE"},{"CodeValue":"CONTAINER CRANE","CodeDescription":"CONTAINER CRANE","Code":"UNIT_TYPE"},{"CodeValue":"CONTAINERIZED","CodeDescription":"CONTAINERIZED","Code":"UNIT_TYPE"},{"CodeValue":"CONV  MIXER","CodeDescription":"CONV  MIXER","Code":"UNIT_TYPE"},{"CodeValue":"CONV (MIXER)","CodeDescription":"CONV (MIXER)","Code":"UNIT_TYPE"},{"CodeValue":"CONV MIXER","CodeDescription":"CONV MIXER","Code":"UNIT_TYPE"},{"CodeValue":"CONVEN","CodeDescription":"CONVEN","Code":"UNIT_TYPE"},{"CodeValue":"CONVENTIONAL","CodeDescription":"CONVENTIONAL","Code":"UNIT_TYPE"},{"CodeValue":"CONVENTONAL","CodeDescription":"CONVENTONAL","Code":"UNIT_TYPE"},{"CodeValue":"CONVEYOR SYSTEM","CodeDescription":"CONVEYOR SYSTEM","Code":"UNIT_TYPE"},{"CodeValue":"CORN PICKER","CodeDescription":"CORN PICKER","Code":"UNIT_TYPE"},{"CodeValue":"COTTON LOADER","CodeDescription":"COTTON LOADER","Code":"UNIT_TYPE"},{"CodeValue":"CRANE","CodeDescription":"CRANE","Code":"UNIT_TYPE"},{"CodeValue":"CRANE (35 TON)","CodeDescription":"CRANE (35 TON)","Code":"UNIT_TYPE"},{"CodeValue":"CRANE (40 TON)","CodeDescription":"CRANE (40 TON)","Code":"UNIT_TYPE"},{"CodeValue":"CRANE (50 TON)","CodeDescription":"CRANE (50 TON)","Code":"UNIT_TYPE"},{"CodeValue":"CRANE (60 TON)","CodeDescription":"CRANE (60 TON)","Code":"UNIT_TYPE"},{"CodeValue":"CRANE (75 TON)","CodeDescription":"CRANE (75 TON)","Code":"UNIT_TYPE"},{"CodeValue":"CRANE (90 TON)","CodeDescription":"CRANE (90 TON)","Code":"UNIT_TYPE"},{"CodeValue":"CRANE CARRIER","CodeDescription":"CRANE CARRIER","Code":"UNIT_TYPE"},{"CodeValue":"CRANE CHASSIS","CodeDescription":"CRANE CHASSIS","Code":"UNIT_TYPE"},{"CodeValue":"CRANE TRUCK","CodeDescription":"CRANE TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"CRANE(130 TON)","CodeDescription":"CRANE(130 TON)","Code":"UNIT_TYPE"},{"CodeValue":"CRANE(150 TON)","CodeDescription":"CRANE(150 TON)","Code":"UNIT_TYPE"},{"CodeValue":"CRANE/SHOVEL","CodeDescription":"CRANE/SHOVEL","Code":"UNIT_TYPE"},{"CodeValue":"CRASHTENDER","CodeDescription":"CRASHTENDER","Code":"UNIT_TYPE"},{"CodeValue":"CRAWL/ROCKDRILL","CodeDescription":"CRAWL/ROCKDRILL","Code":"UNIT_TYPE"},{"CodeValue":"CRAWLER","CodeDescription":"CRAWLER","Code":"UNIT_TYPE"},{"CodeValue":"CRAWLER CRANE","CodeDescription":"CRAWLER CRANE","Code":"UNIT_TYPE"},{"CodeValue":"CRAWLER DOZER","CodeDescription":"CRAWLER DOZER","Code":"UNIT_TYPE"},{"CodeValue":"CRAWLER EXCAVAT","CodeDescription":"CRAWLER EXCAVAT","Code":"UNIT_TYPE"},{"CodeValue":"CRAWLER LOADER","CodeDescription":"CRAWLER LOADER","Code":"UNIT_TYPE"},{"CodeValue":"CRAWLER TACTOR","CodeDescription":"CRAWLER TACTOR","Code":"UNIT_TYPE"},{"CodeValue":"CRAWLER TRACTOR","CodeDescription":"CRAWLER TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"CRAWLR/EXCAVATR","CodeDescription":"CRAWLR/EXCAVATR","Code":"UNIT_TYPE"},{"CodeValue":"CREDO CITA 19","CodeDescription":"CREDO CITA 19","Code":"UNIT_TYPE"},{"CodeValue":"CURBER","CodeDescription":"CURBER","Code":"UNIT_TYPE"},{"CodeValue":"D313006BU04","CodeDescription":"D313006BU04","Code":"UNIT_TYPE"},{"CodeValue":"DELIMBER","CodeDescription":"DELIMBER","Code":"UNIT_TYPE"},{"CodeValue":"DOUBLE DECKER C","CodeDescription":"DOUBLE DECKER C","Code":"UNIT_TYPE"},{"CodeValue":"DOZER","CodeDescription":"DOZER","Code":"UNIT_TYPE"},{"CodeValue":"DRAGLINE","CodeDescription":"DRAGLINE","Code":"UNIT_TYPE"},{"CodeValue":"DRILL","CodeDescription":"DRILL","Code":"UNIT_TYPE"},{"CodeValue":"DRILL","CodeDescription":"DRILL","Code":"UNIT_TYPE"},{"CodeValue":"DRILL CARRIER","CodeDescription":"DRILL CARRIER","Code":"UNIT_TYPE"},{"CodeValue":"DRILL RIG","CodeDescription":"DRILL RIG","Code":"UNIT_TYPE"},{"CodeValue":"DRILLING","CodeDescription":"DRILLING","Code":"UNIT_TYPE"},{"CodeValue":"DRILLING EQUIP","CodeDescription":"DRILLING EQUIP","Code":"UNIT_TYPE"},{"CodeValue":"DRILLING RIG","CodeDescription":"DRILLING RIG","Code":"UNIT_TYPE"},{"CodeValue":"DRUM ROLLER","CodeDescription":"DRUM ROLLER","Code":"UNIT_TYPE"},{"CodeValue":"DUMP TRUCK","CodeDescription":"DUMP TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"DUMP TRUCK","CodeDescription":"DUMP TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"DUMPER","CodeDescription":"DUMPER","Code":"UNIT_TYPE"},{"CodeValue":"DUMPTRUCK","CodeDescription":"DUMPTRUCK","Code":"UNIT_TYPE"},{"CodeValue":"EN","CodeDescription":"EN","Code":"UNIT_TYPE"},{"CodeValue":"ENCLOSED","CodeDescription":"ENCLOSED","Code":"UNIT_TYPE"},{"CodeValue":"ENVIRON DRILL","CodeDescription":"ENVIRON DRILL","Code":"UNIT_TYPE"},{"CodeValue":"EXCAVATOR","CodeDescription":"EXCAVATOR","Code":"UNIT_TYPE"},{"CodeValue":"EXCAVATOR","CodeDescription":"EXCAVATOR","Code":"UNIT_TYPE"},{"CodeValue":"EXCAVATOR DRILL","CodeDescription":"EXCAVATOR DRILL","Code":"UNIT_TYPE"},{"CodeValue":"EXCAVATORS","CodeDescription":"EXCAVATORS","Code":"UNIT_TYPE"},{"CodeValue":"EXCAVLATOR","CodeDescription":"EXCAVLATOR","Code":"UNIT_TYPE"},{"CodeValue":"F E LOADER","CodeDescription":"F E LOADER","Code":"UNIT_TYPE"},{"CodeValue":"F/D MIXER","CodeDescription":"F/D MIXER","Code":"UNIT_TYPE"},{"CodeValue":"F/DIS MIXER","CodeDescription":"F/DIS MIXER","Code":"UNIT_TYPE"},{"CodeValue":"F/E LOADER","CodeDescription":"F/E LOADER","Code":"UNIT_TYPE"},{"CodeValue":"F/ELOADER","CodeDescription":"F/ELOADER","Code":"UNIT_TYPE"},{"CodeValue":"F/END LOADER","CodeDescription":"F/END LOADER","Code":"UNIT_TYPE"},{"CodeValue":"FARM TRACTOR","CodeDescription":"FARM TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"FE SCHOOL BUS","CodeDescription":"FE SCHOOL BUS","Code":"UNIT_TYPE"},{"CodeValue":"FEED LOT TRUCK","CodeDescription":"FEED LOT TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"FELLER BUNCHER","CodeDescription":"FELLER BUNCHER","Code":"UNIT_TYPE"},{"CodeValue":"FELLER/BUNCHER","CodeDescription":"FELLER/BUNCHER","Code":"UNIT_TYPE"},{"CodeValue":"FERRY BOAT","CodeDescription":"FERRY BOAT","Code":"UNIT_TYPE"},{"CodeValue":"FERT SPREADER","CodeDescription":"FERT SPREADER","Code":"UNIT_TYPE"},{"CodeValue":"FERTILIZER-SPRE","CodeDescription":"FERTILIZER-SPRE","Code":"UNIT_TYPE"},{"CodeValue":"FIGHTING VECH","CodeDescription":"FIGHTING VECH","Code":"UNIT_TYPE"},{"CodeValue":"FIRE PUMP","CodeDescription":"FIRE PUMP","Code":"UNIT_TYPE"},{"CodeValue":"FIRE TENDER","CodeDescription":"FIRE TENDER","Code":"UNIT_TYPE"},{"CodeValue":"FIRE TRUCK","CodeDescription":"FIRE TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"FIRE TRUCK PUMP","CodeDescription":"FIRE TRUCK PUMP","Code":"UNIT_TYPE"},{"CodeValue":"FIRE/CRASH TRK","CodeDescription":"FIRE/CRASH TRK","Code":"UNIT_TYPE"},{"CodeValue":"FIRETRUCK","CodeDescription":"FIRETRUCK","Code":"UNIT_TYPE"},{"CodeValue":"FORAGE HARVEST","CodeDescription":"FORAGE HARVEST","Code":"UNIT_TYPE"},{"CodeValue":"FORAGE HARVESTE","CodeDescription":"FORAGE HARVESTE","Code":"UNIT_TYPE"},{"CodeValue":"FORESTRY","CodeDescription":"FORESTRY","Code":"UNIT_TYPE"},{"CodeValue":"FORK LIFT","CodeDescription":"FORK LIFT","Code":"UNIT_TYPE"},{"CodeValue":"FORK LIFT","CodeDescription":"FORK LIFT","Code":"UNIT_TYPE"},{"CodeValue":"FORK TRUCK","CodeDescription":"FORK TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"FORKLIFT","CodeDescription":"FORKLIFT","Code":"UNIT_TYPE"},{"CodeValue":"FORKTRUCK","CodeDescription":"FORKTRUCK","Code":"UNIT_TYPE"},{"CodeValue":"FORLIFT","CodeDescription":"FORLIFT","Code":"UNIT_TYPE"},{"CodeValue":"FORWARDER","CodeDescription":"FORWARDER","Code":"UNIT_TYPE"},{"CodeValue":"FRACTURING RIG","CodeDescription":"FRACTURING RIG","Code":"UNIT_TYPE"},{"CodeValue":"FRACTURING RIG","CodeDescription":"FRACTURING RIG","Code":"UNIT_TYPE"},{"CodeValue":"FRONT END LOADE","CodeDescription":"FRONT END LOADE","Code":"UNIT_TYPE"},{"CodeValue":"FRONT ENG BUS","CodeDescription":"FRONT ENG BUS","Code":"UNIT_TYPE"},{"CodeValue":"FRONT ENGINE","CodeDescription":"FRONT ENGINE","Code":"UNIT_TYPE"},{"CodeValue":"FRONT ENGINE BU","CodeDescription":"FRONT ENGINE BU","Code":"UNIT_TYPE"},{"CodeValue":"FRT/END LOADER","CodeDescription":"FRT/END LOADER","Code":"UNIT_TYPE"},{"CodeValue":"FUEL TANKER","CodeDescription":"FUEL TANKER","Code":"UNIT_TYPE"},{"CodeValue":"GANTRY","CodeDescription":"GANTRY","Code":"UNIT_TYPE"},{"CodeValue":"GARBAGE COMPACT","CodeDescription":"GARBAGE COMPACT","Code":"UNIT_TYPE"},{"CodeValue":"GEN SET","CodeDescription":"GEN SET","Code":"UNIT_TYPE"},{"CodeValue":"GENERATOR","CodeDescription":"GENERATOR","Code":"UNIT_TYPE"},{"CodeValue":"GENSET","CodeDescription":"GENSET","Code":"UNIT_TYPE"},{"CodeValue":"GONDOLA LIFT RI","CodeDescription":"GONDOLA LIFT RI","Code":"UNIT_TYPE"},{"CodeValue":"GPU","CodeDescription":"GPU","Code":"UNIT_TYPE"},{"CodeValue":"GRADER","CodeDescription":"GRADER","Code":"UNIT_TYPE"},{"CodeValue":"GRAPPLE SKIDDER","CodeDescription":"GRAPPLE SKIDDER","Code":"UNIT_TYPE"},{"CodeValue":"GRAVEL BOOM, ST","CodeDescription":"GRAVEL BOOM, ST","Code":"UNIT_TYPE"},{"CodeValue":"GRAVEL BROOM","CodeDescription":"GRAVEL BROOM","Code":"UNIT_TYPE"},{"CodeValue":"GRAVEL SCREENER","CodeDescription":"GRAVEL SCREENER","Code":"UNIT_TYPE"},{"CodeValue":"GROUND SUPPORT","CodeDescription":"GROUND SUPPORT","Code":"UNIT_TYPE"},{"CodeValue":"GROUNDPOWER UT","CodeDescription":"GROUNDPOWER UT","Code":"UNIT_TYPE"},{"CodeValue":"HAMMERMILL","CodeDescription":"HAMMERMILL","Code":"UNIT_TYPE"},{"CodeValue":"HANDLER","CodeDescription":"HANDLER","Code":"UNIT_TYPE"},{"CodeValue":"HARBOUR CRANE","CodeDescription":"HARBOUR CRANE","Code":"UNIT_TYPE"},{"CodeValue":"HARVESTER","CodeDescription":"HARVESTER","Code":"UNIT_TYPE"},{"CodeValue":"HARVESTER","CodeDescription":"HARVESTER","Code":"UNIT_TYPE"},{"CodeValue":"HAUL TRUCK","CodeDescription":"HAUL TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"HEATER","CodeDescription":"HEATER","Code":"UNIT_TYPE"},{"CodeValue":"HEAVY HWY","CodeDescription":"HEAVY HWY","Code":"UNIT_TYPE"},{"CodeValue":"HERITAGE ST CAR","CodeDescription":"HERITAGE ST CAR","Code":"UNIT_TYPE"},{"CodeValue":"HESSTON WINDROW","CodeDescription":"HESSTON WINDROW","Code":"UNIT_TYPE"},{"CodeValue":"HIGH CAB OVER","CodeDescription":"HIGH CAB OVER","Code":"UNIT_TYPE"},{"CodeValue":"HIGH COE","CodeDescription":"HIGH COE","Code":"UNIT_TYPE"},{"CodeValue":"HIGHWAY CRANE","CodeDescription":"HIGHWAY CRANE","Code":"UNIT_TYPE"},{"CodeValue":"HNDLR","CodeDescription":"CONTAINER HANDLER","Code":"UNIT_TYPE"},{"CodeValue":"HOIST","CodeDescription":"HOIST","Code":"UNIT_TYPE"},{"CodeValue":"HVYHAUL TRACTOR","CodeDescription":"HVYHAUL TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"HYBRID","CodeDescription":"HYBRID","Code":"UNIT_TYPE"},{"CodeValue":"HYD  EXCAVATOR","CodeDescription":"HYD  EXCAVATOR","Code":"UNIT_TYPE"},{"CodeValue":"HYD EXCAVATOR","CodeDescription":"HYD EXCAVATOR","Code":"UNIT_TYPE"},{"CodeValue":"HYD LOG LOADER","CodeDescription":"HYD LOG LOADER","Code":"UNIT_TYPE"},{"CodeValue":"HYD TRK CRANE","CodeDescription":"HYD TRK CRANE","Code":"UNIT_TYPE"},{"CodeValue":"HYDRATION UNIT","CodeDescription":"HYDRATION UNIT","Code":"UNIT_TYPE"},{"CodeValue":"HYDRO-SCOP CRAN","CodeDescription":"HYDRO-SCOP CRAN","Code":"UNIT_TYPE"},{"CodeValue":"IN BUILDING","CodeDescription":"IN BUILDING","Code":"UNIT_TYPE"},{"CodeValue":"INDUST SWEEPER","CodeDescription":"INDUST SWEEPER","Code":"UNIT_TYPE"},{"CodeValue":"INDUSTRIAL","CodeDescription":"INDUSTRIAL","Code":"UNIT_TYPE"},{"CodeValue":"IRRIGATION PUMP","CodeDescription":"IRRIGATION PUMP","Code":"UNIT_TYPE"},{"CodeValue":"JET STARTER","CodeDescription":"JET STARTER","Code":"UNIT_TYPE"},{"CodeValue":"L1400","CodeDescription":"L1400","Code":"UNIT_TYPE"},{"CodeValue":"LABOURER","CodeDescription":"LABOURER","Code":"UNIT_TYPE"},{"CodeValue":"LANDFILL COMPAC","CodeDescription":"LANDFILL COMPAC","Code":"UNIT_TYPE"},{"CodeValue":"LANDING CRAFT","CodeDescription":"LANDING CRAFT","Code":"UNIT_TYPE"},{"CodeValue":"LGP DOZER","CodeDescription":"LGP DOZER","Code":"UNIT_TYPE"},{"CodeValue":"LIFT TRUCK","CodeDescription":"LIFT TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"LINK BELT","CodeDescription":"LINK BELT","Code":"UNIT_TYPE"},{"CodeValue":"LOADER","CodeDescription":"LOADER","Code":"UNIT_TYPE"},{"CodeValue":"LOADER","CodeDescription":"LOADER","Code":"UNIT_TYPE"},{"CodeValue":"LOADER BACKHOE","CodeDescription":"LOADER BACKHOE","Code":"UNIT_TYPE"},{"CodeValue":"LOADER/DOZER","CodeDescription":"LOADER/DOZER","Code":"UNIT_TYPE"},{"CodeValue":"LOADER/HANDLER","CodeDescription":"LOADER/HANDLER","Code":"UNIT_TYPE"},{"CodeValue":"LOADING SHOVEL","CodeDescription":"LOADING SHOVEL","Code":"UNIT_TYPE"},{"CodeValue":"LOCOMOTIVE","CodeDescription":"LOCOMOTIVE","Code":"UNIT_TYPE"},{"CodeValue":"LOG CHIPPER","CodeDescription":"LOG CHIPPER","Code":"UNIT_TYPE"},{"CodeValue":"LOG LOADER","CodeDescription":"LOG LOADER","Code":"UNIT_TYPE"},{"CodeValue":"LOG SHOVEL","CodeDescription":"LOG SHOVEL","Code":"UNIT_TYPE"},{"CodeValue":"LOG SKIDDER","CodeDescription":"LOG SKIDDER","Code":"UNIT_TYPE"},{"CodeValue":"LOG STACKER","CodeDescription":"LOG STACKER","Code":"UNIT_TYPE"},{"CodeValue":"LOGGER","CodeDescription":"LOGGER","Code":"UNIT_TYPE"},{"CodeValue":"LONG","CodeDescription":"LONG","Code":"UNIT_TYPE"},{"CodeValue":"LONG CONV","CodeDescription":"LONG CONV","Code":"UNIT_TYPE"},{"CodeValue":"LONG CONVENTION","CodeDescription":"LONG CONVENTION","Code":"UNIT_TYPE"},{"CodeValue":"LONG NOSE","CodeDescription":"LONG NOSE","Code":"UNIT_TYPE"},{"CodeValue":"LOW CAB","CodeDescription":"LOW CAB","Code":"UNIT_TYPE"},{"CodeValue":"LOW COE","CodeDescription":"LOW COE","Code":"UNIT_TYPE"},{"CodeValue":"LOW FL TRANSIT","CodeDescription":"LOW FL TRANSIT","Code":"UNIT_TYPE"},{"CodeValue":"MANLIFT","CodeDescription":"MANLIFT","Code":"UNIT_TYPE"},{"CodeValue":"MARINE INSTALL","CodeDescription":"MARINE INSTALL","Code":"UNIT_TYPE"},{"CodeValue":"MC","CodeDescription":"MC","Code":"UNIT_TYPE"},{"CodeValue":"MED  CONV","CodeDescription":"MED  CONV","Code":"UNIT_TYPE"},{"CodeValue":"MED CONV","CodeDescription":"MED CONV","Code":"UNIT_TYPE"},{"CodeValue":"MEDIUM","CodeDescription":"MEDIUM","Code":"UNIT_TYPE"},{"CodeValue":"MEDIUM CONV","CodeDescription":"MEDIUM CONV","Code":"UNIT_TYPE"},{"CodeValue":"MEDIUM CONV.","CodeDescription":"MEDIUM CONV.","Code":"UNIT_TYPE"},{"CodeValue":"MID ENGINE BUS","CodeDescription":"MID ENGINE BUS","Code":"UNIT_TYPE"},{"CodeValue":"MID-ENGINE","CodeDescription":"MID-ENGINE","Code":"UNIT_TYPE"},{"CodeValue":"MILITARY LIFT","CodeDescription":"MILITARY LIFT","Code":"UNIT_TYPE"},{"CodeValue":"MINE TRUCK","CodeDescription":"MINE TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"MINI-BUS","CodeDescription":"MINI-BUS","Code":"UNIT_TYPE"},{"CodeValue":"MINING","CodeDescription":"MINING","Code":"UNIT_TYPE"},{"CodeValue":"MINING TRUCK","CodeDescription":"MINING TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"MIX WAGON","CodeDescription":"MIX WAGON","Code":"UNIT_TYPE"},{"CodeValue":"MIXER","CodeDescription":"MIXER","Code":"UNIT_TYPE"},{"CodeValue":"MLRS","CodeDescription":"MLRS","Code":"UNIT_TYPE"},{"CodeValue":"MOBIL STAIRCASE","CodeDescription":"MOBIL STAIRCASE","Code":"UNIT_TYPE"},{"CodeValue":"MOBILE DRILLRIG","CodeDescription":"MOBILE DRILLRIG","Code":"UNIT_TYPE"},{"CodeValue":"MOTOR HOME","CodeDescription":"MOTOR HOME","Code":"UNIT_TYPE"},{"CodeValue":"MOTOR SCRAPER","CodeDescription":"MOTOR SCRAPER","Code":"UNIT_TYPE"},{"CodeValue":"MOTORHOME (REAR","CodeDescription":"MOTORHOME (REAR","Code":"UNIT_TYPE"},{"CodeValue":"MOTORHOME R","CodeDescription":"MOTORHOME R","Code":"UNIT_TYPE"},{"CodeValue":"MOTORHOME REAR","CodeDescription":"MOTORHOME REAR","Code":"UNIT_TYPE"},{"CodeValue":"MOTORHOME(REAR)","CodeDescription":"MOTORHOME(REAR)","Code":"UNIT_TYPE"},{"CodeValue":"MP","CodeDescription":"MP","Code":"UNIT_TYPE"},{"CodeValue":"MR","CodeDescription":"MR","Code":"UNIT_TYPE"},{"CodeValue":"MULCHER","CodeDescription":"MULCHER","Code":"UNIT_TYPE"},{"CodeValue":"MULTITASKER","CodeDescription":"MULTITASKER","Code":"UNIT_TYPE"},{"CodeValue":"OFFSET","CodeDescription":"OFFSET","Code":"UNIT_TYPE"},{"CodeValue":"OIL FIELD RIG","CodeDescription":"OIL FIELD RIG","Code":"UNIT_TYPE"},{"CodeValue":"ONVENTIONAL","CodeDescription":"ONVENTIONAL","Code":"UNIT_TYPE"},{"CodeValue":"ORCHARD WIND","CodeDescription":"ORCHARD WIND","Code":"UNIT_TYPE"},{"CodeValue":"P&D","CodeDescription":"P&D","Code":"UNIT_TYPE"},{"CodeValue":"PATCHER","CodeDescription":"PATCHER","Code":"UNIT_TYPE"},{"CodeValue":"PAVER","CodeDescription":"PAVER","Code":"UNIT_TYPE"},{"CodeValue":"PAVER CONCRETE","CodeDescription":"PAVER CONCRETE","Code":"UNIT_TYPE"},{"CodeValue":"PAVER/FINISHER","CodeDescription":"PAVER/FINISHER","Code":"UNIT_TYPE"},{"CodeValue":"PAVERS","CodeDescription":"PAVERS","Code":"UNIT_TYPE"},{"CodeValue":"PAVING EQ","CodeDescription":"PAVING EQ","Code":"UNIT_TYPE"},{"CodeValue":"PAVING EQUIP","CodeDescription":"PAVING EQUIP","Code":"UNIT_TYPE"},{"CodeValue":"PAVING EQUIPMEN","CodeDescription":"PAVING EQUIPMEN","Code":"UNIT_TYPE"},{"CodeValue":"PICKUP","CodeDescription":"PICKUP","Code":"UNIT_TYPE"},{"CodeValue":"PILE DRIVER","CodeDescription":"PILE DRIVER","Code":"UNIT_TYPE"},{"CodeValue":"PIPE LAYER","CodeDescription":"PIPE LAYER","Code":"UNIT_TYPE"},{"CodeValue":"PLEASURE BOAT","CodeDescription":"PLEASURE BOAT","Code":"UNIT_TYPE"},{"CodeValue":"PLOW TRUCK","CodeDescription":"PLOW TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"PNEUMATICTIRE T","CodeDescription":"PNEUMATICTIRE T","Code":"UNIT_TYPE"},{"CodeValue":"PO","CodeDescription":"PO","Code":"UNIT_TYPE"},{"CodeValue":"POD STRIPPER","CodeDescription":"POD STRIPPER","Code":"UNIT_TYPE"},{"CodeValue":"POTATO HARVEST","CodeDescription":"POTATO HARVEST","Code":"UNIT_TYPE"},{"CodeValue":"POWER UNIT","CodeDescription":"POWER UNIT","Code":"UNIT_TYPE"},{"CodeValue":"PR","CodeDescription":"PR","Code":"UNIT_TYPE"},{"CodeValue":"PRESSURE WASHER","CodeDescription":"PRESSURE WASHER","Code":"UNIT_TYPE"},{"CodeValue":"PRESSURE WASHR","CodeDescription":"PRESSURE WASHR","Code":"UNIT_TYPE"},{"CodeValue":"PUMPER","CodeDescription":"PUMPER","Code":"UNIT_TYPE"},{"CodeValue":"PUSH BACK TRACT","CodeDescription":"PUSH BACK TRACT","Code":"UNIT_TYPE"},{"CodeValue":"R. E. BUS","CodeDescription":"R. E. BUS","Code":"UNIT_TYPE"},{"CodeValue":"R.E. BUS","CodeDescription":"R.E. BUS","Code":"UNIT_TYPE"},{"CodeValue":"R/DUMP TRUCK","CodeDescription":"R/DUMP TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"R/T","CodeDescription":"R/T","Code":"UNIT_TYPE"},{"CodeValue":"R/T CRANE","CodeDescription":"R/T CRANE","Code":"UNIT_TYPE"},{"CodeValue":"R/T FORKLIFT","CodeDescription":"R/T FORKLIFT","Code":"UNIT_TYPE"},{"CodeValue":"R/T LIFT TRUCK","CodeDescription":"R/T LIFT TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"R/T ROLLER","CodeDescription":"R/T ROLLER","Code":"UNIT_TYPE"},{"CodeValue":"R/TIRE DOZER","CodeDescription":"R/TIRE DOZER","Code":"UNIT_TYPE"},{"CodeValue":"RAIL","CodeDescription":"RAIL","Code":"UNIT_TYPE"},{"CodeValue":"RAIL","CodeDescription":"RAIL","Code":"UNIT_TYPE"},{"CodeValue":"RAIL CAR","CodeDescription":"RAIL CAR","Code":"UNIT_TYPE"},{"CodeValue":"RAIL CRANE","CodeDescription":"RAIL CRANE","Code":"UNIT_TYPE"},{"CodeValue":"RAIL MAINT","CodeDescription":"RAIL MAINT","Code":"UNIT_TYPE"},{"CodeValue":"RAIL SERVICE","CodeDescription":"RAIL SERVICE","Code":"UNIT_TYPE"},{"CodeValue":"RAIL TAMPER","CodeDescription":"RAIL TAMPER","Code":"UNIT_TYPE"},{"CodeValue":"RAILCAR","CodeDescription":"RAILCAR","Code":"UNIT_TYPE"},{"CodeValue":"RAM TRACTOR","CodeDescription":"RAM TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"RC","CodeDescription":"RC","Code":"UNIT_TYPE"},{"CodeValue":"REACH STACKER","CodeDescription":"REACH STACKER","Code":"UNIT_TYPE"},{"CodeValue":"REAR DUMP","CodeDescription":"REAR DUMP","Code":"UNIT_TYPE"},{"CodeValue":"REAR DUMP TRUCK","CodeDescription":"REAR DUMP TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"REAR ENG BUS","CodeDescription":"REAR ENG BUS","Code":"UNIT_TYPE"},{"CodeValue":"REAR ENG. BUS","CodeDescription":"REAR ENG. BUS","Code":"UNIT_TYPE"},{"CodeValue":"REAR ENGINE","CodeDescription":"REAR ENGINE","Code":"UNIT_TYPE"},{"CodeValue":"REAR ENGINE BUS","CodeDescription":"REAR ENGINE BUS","Code":"UNIT_TYPE"},{"CodeValue":"REC MARINE","CodeDescription":"REC MARINE","Code":"UNIT_TYPE"},{"CodeValue":"RECYCLER","CodeDescription":"RECYCLER","Code":"UNIT_TYPE"},{"CodeValue":"RECYCLING/MILLI","CodeDescription":"RECYCLING/MILLI","Code":"UNIT_TYPE"},{"CodeValue":"REFUSE PACKER","CodeDescription":"REFUSE PACKER","Code":"UNIT_TYPE"},{"CodeValue":"REFUSE SIDE LDR","CodeDescription":"REFUSE SIDE LDR","Code":"UNIT_TYPE"},{"CodeValue":"REFUSE TRUCK","CodeDescription":"REFUSE TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"RIDE-ON TRACTOR","CodeDescription":"RIDE-ON TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"RIGID DUMP","CodeDescription":"RIGID DUMP","Code":"UNIT_TYPE"},{"CodeValue":"RM","CodeDescription":"RM","Code":"UNIT_TYPE"},{"CodeValue":"ROAD BROOM","CodeDescription":"ROAD BROOM","Code":"UNIT_TYPE"},{"CodeValue":"ROAD COMPACTOR","CodeDescription":"ROAD COMPACTOR","Code":"UNIT_TYPE"},{"CodeValue":"ROAD GRADER","CodeDescription":"ROAD GRADER","Code":"UNIT_TYPE"},{"CodeValue":"ROAD GRINDER","CodeDescription":"ROAD GRINDER","Code":"UNIT_TYPE"},{"CodeValue":"ROAD MILL","CodeDescription":"ROAD MILL","Code":"UNIT_TYPE"},{"CodeValue":"ROAD MILLER","CodeDescription":"ROAD MILLER","Code":"UNIT_TYPE"},{"CodeValue":"ROAD PLANER","CodeDescription":"ROAD PLANER","Code":"UNIT_TYPE"},{"CodeValue":"ROAD PLANER","CodeDescription":"ROAD PLANER","Code":"UNIT_TYPE"},{"CodeValue":"ROAD PLANNER","CodeDescription":"ROAD PLANNER","Code":"UNIT_TYPE"},{"CodeValue":"ROCK DRILL","CodeDescription":"ROCK DRILL","Code":"UNIT_TYPE"},{"CodeValue":"ROCK SPREADER","CodeDescription":"ROCK SPREADER","Code":"UNIT_TYPE"},{"CodeValue":"ROLLER","CodeDescription":"ROLLER","Code":"UNIT_TYPE"},{"CodeValue":"ROLLER","CodeDescription":"ROLLER","Code":"UNIT_TYPE"},{"CodeValue":"ROTARY COMBINE","CodeDescription":"ROTARY COMBINE","Code":"UNIT_TYPE"},{"CodeValue":"ROTARY DRILL","CodeDescription":"ROTARY DRILL","Code":"UNIT_TYPE"},{"CodeValue":"RUB-TIRE DOZER","CodeDescription":"RUB-TIRE DOZER","Code":"UNIT_TYPE"},{"CodeValue":"RV","CodeDescription":"RV","Code":"UNIT_TYPE"},{"CodeValue":"S/R ROLLER","CodeDescription":"S/R ROLLER","Code":"UNIT_TYPE"},{"CodeValue":"S/R ROLLERS","CodeDescription":"S/R ROLLERS","Code":"UNIT_TYPE"},{"CodeValue":"SANDBLASTER","CodeDescription":"SANDBLASTER","Code":"UNIT_TYPE"},{"CodeValue":"SCHOLL BUS","CodeDescription":"SCHOLL BUS","Code":"UNIT_TYPE"},{"CodeValue":"SCHOOL BUS","CodeDescription":"SCHOOL BUS","Code":"UNIT_TYPE"},{"CodeValue":"SCHOOL BUS(FE)","CodeDescription":"SCHOOL BUS(FE)","Code":"UNIT_TYPE"},{"CodeValue":"SCHOOL BUS(RE)","CodeDescription":"SCHOOL BUS(RE)","Code":"UNIT_TYPE"},{"CodeValue":"SCHOOL/TRANSIT","CodeDescription":"SCHOOL/TRANSIT","Code":"UNIT_TYPE"},{"CodeValue":"SCHOOLBUS","CodeDescription":"SCHOOLBUS","Code":"UNIT_TYPE"},{"CodeValue":"SCRAPER","CodeDescription":"SCRAPER","Code":"UNIT_TYPE"},{"CodeValue":"SHEAR","CodeDescription":"SHEAR","Code":"UNIT_TYPE"},{"CodeValue":"SHEAR BALER","CodeDescription":"SHEAR BALER","Code":"UNIT_TYPE"},{"CodeValue":"SHORT","CodeDescription":"SHORT","Code":"UNIT_TYPE"},{"CodeValue":"SHORT CONV","CodeDescription":"SHORT CONV","Code":"UNIT_TYPE"},{"CodeValue":"SHOVEL LOGGER","CodeDescription":"SHOVEL LOGGER","Code":"UNIT_TYPE"},{"CodeValue":"SHREDDER","CodeDescription":"SHREDDER","Code":"UNIT_TYPE"},{"CodeValue":"SHUTTLE","CodeDescription":"SHUTTLE","Code":"UNIT_TYPE"},{"CodeValue":"SIDE LOADER","CodeDescription":"SIDE LOADER","Code":"UNIT_TYPE"},{"CodeValue":"SIDE PORTER","CodeDescription":"SIDE PORTER","Code":"UNIT_TYPE"},{"CodeValue":"SIDELOADER","CodeDescription":"SIDELOADER","Code":"UNIT_TYPE"},{"CodeValue":"SITE PREP","CodeDescription":"SITE PREP","Code":"UNIT_TYPE"},{"CodeValue":"SKD/STR LOADER","CodeDescription":"SKD/STR LOADER","Code":"UNIT_TYPE"},{"CodeValue":"SKIDDER","CodeDescription":"SKIDDER","Code":"UNIT_TYPE"},{"CodeValue":"SLAG POT CARRIE","CodeDescription":"SLAG POT CARRIE","Code":"UNIT_TYPE"},{"CodeValue":"SLUDGE HAULER","CodeDescription":"SLUDGE HAULER","Code":"UNIT_TYPE"},{"CodeValue":"SLUDGE SPREADER","CodeDescription":"SLUDGE SPREADER","Code":"UNIT_TYPE"},{"CodeValue":"SNOW BLOWER","CodeDescription":"SNOW BLOWER","Code":"UNIT_TYPE"},{"CodeValue":"SNOW GROOMER","CodeDescription":"SNOW GROOMER","Code":"UNIT_TYPE"},{"CodeValue":"SP","CodeDescription":"SP","Code":"UNIT_TYPE"},{"CodeValue":"SPEC  UTILITY","CodeDescription":"SPEC  UTILITY","Code":"UNIT_TYPE"},{"CodeValue":"SPRAYER","CodeDescription":"SPRAYER","Code":"UNIT_TYPE"},{"CodeValue":"SPRAYER","CodeDescription":"SPRAYER","Code":"UNIT_TYPE"},{"CodeValue":"SPREADER/APPL","CodeDescription":"SPREADER/APPL","Code":"UNIT_TYPE"},{"CodeValue":"ST","CodeDescription":"ST","Code":"UNIT_TYPE"},{"CodeValue":"STANDARD HOOD","CodeDescription":"STANDARD HOOD","Code":"UNIT_TYPE"},{"CodeValue":"STEEL HAULER","CodeDescription":"STEEL HAULER","Code":"UNIT_TYPE"},{"CodeValue":"STEEL HOOD CONV","CodeDescription":"STEEL HOOD CONV","Code":"UNIT_TYPE"},{"CodeValue":"STEET SWEEPER","CodeDescription":"STEET SWEEPER","Code":"UNIT_TYPE"},{"CodeValue":"STEP VAN","CodeDescription":"STEP VAN","Code":"UNIT_TYPE"},{"CodeValue":"STRADDLE CARRY","CodeDescription":"STRADDLE CARRY","Code":"UNIT_TYPE"},{"CodeValue":"STRADDLE CRANE","CodeDescription":"STRADDLE CRANE","Code":"UNIT_TYPE"},{"CodeValue":"STRADDLECARRIER","CodeDescription":"STRADDLECARRIER","Code":"UNIT_TYPE"},{"CodeValue":"STREET SWEEPER","CodeDescription":"STREET SWEEPER","Code":"UNIT_TYPE"},{"CodeValue":"STUMP CUTTER","CodeDescription":"STUMP CUTTER","Code":"UNIT_TYPE"},{"CodeValue":"SUGAR CANE HARV","CodeDescription":"SUGAR CANE HARV","Code":"UNIT_TYPE"},{"CodeValue":"SWATHER","CodeDescription":"SWATHER","Code":"UNIT_TYPE"},{"CodeValue":"SWATHERS","CodeDescription":"SWATHERS","Code":"UNIT_TYPE"},{"CodeValue":"SWEEPER","CodeDescription":"SWEEPER","Code":"UNIT_TYPE"},{"CodeValue":"T-DRIVE TRANSIT","CodeDescription":"T-DRIVE TRANSIT","Code":"UNIT_TYPE"},{"CodeValue":"T/S FORKLIFT","CodeDescription":"T/S FORKLIFT","Code":"UNIT_TYPE"},{"CodeValue":"T3 DRILL","CodeDescription":"T3 DRILL","Code":"UNIT_TYPE"},{"CodeValue":"T4I","CodeDescription":"T4I","Code":"UNIT_TYPE"},{"CodeValue":"TAMPER/RAMMER","CodeDescription":"TAMPER/RAMMER","Code":"UNIT_TYPE"},{"CodeValue":"TANSIT BUS","CodeDescription":"TANSIT BUS","Code":"UNIT_TYPE"},{"CodeValue":"TELE EXCAVATOR","CodeDescription":"TELE EXCAVATOR","Code":"UNIT_TYPE"},{"CodeValue":"TELEHANDLER","CodeDescription":"TELEHANDLER","Code":"UNIT_TYPE"},{"CodeValue":"TERMINAL TRACK","CodeDescription":"TERMINAL TRACK","Code":"UNIT_TYPE"},{"CodeValue":"TERMINAL TRACT","CodeDescription":"TERMINAL TRACT","Code":"UNIT_TYPE"},{"CodeValue":"TERMINAL TRACTO","CodeDescription":"TERMINAL TRACTO","Code":"UNIT_TYPE"},{"CodeValue":"TERMINAL TRCTR","CodeDescription":"TERMINAL TRCTR","Code":"UNIT_TYPE"},{"CodeValue":"THIN SEAM MINER","CodeDescription":"THIN SEAM MINER","Code":"UNIT_TYPE"},{"CodeValue":"TILT HOOD","CodeDescription":"TILT HOOD","Code":"UNIT_TYPE"},{"CodeValue":"TOUR BUS","CodeDescription":"TOUR BUS","Code":"UNIT_TYPE"},{"CodeValue":"TOUR COACH","CodeDescription":"TOUR COACH","Code":"UNIT_TYPE"},{"CodeValue":"TOW TRACTOR","CodeDescription":"TOW TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"TRAC HOE","CodeDescription":"TRAC HOE","Code":"UNIT_TYPE"},{"CodeValue":"TRACK","CodeDescription":"TRACK","Code":"UNIT_TYPE"},{"CodeValue":"TRACKED TRANSP","CodeDescription":"TRACKED TRANSP","Code":"UNIT_TYPE"},{"CodeValue":"TRACTOR","CodeDescription":"TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"TRACTOR","CodeDescription":"TRACTOR","Code":"UNIT_TYPE"},{"CodeValue":"TRACTORS","CodeDescription":"TRACTORS","Code":"UNIT_TYPE"},{"CodeValue":"TRAILER","CodeDescription":"TRAILER","Code":"UNIT_TYPE"},{"CodeValue":"TRAILER/SKD MT","CodeDescription":"TRAILER/SKD MT","Code":"UNIT_TYPE"},{"CodeValue":"TRAILER/SKID MT","CodeDescription":"TRAILER/SKID MT","Code":"UNIT_TYPE"},{"CodeValue":"TRANS","CodeDescription":"TRANSMISSION","Code":"UNIT_TYPE"},{"CodeValue":"TRANSIT BUS","CodeDescription":"TRANSIT BUS","Code":"UNIT_TYPE"},{"CodeValue":"TRANSIT BUS -RE","CodeDescription":"TRANSIT BUS -RE","Code":"UNIT_TYPE"},{"CodeValue":"TRANSIT BUS(FE)","CodeDescription":"TRANSIT BUS(FE)","Code":"UNIT_TYPE"},{"CodeValue":"TRANSIT BUS(RE)","CodeDescription":"TRANSIT BUS(RE)","Code":"UNIT_TYPE"},{"CodeValue":"TRANSIT BUS-RE","CodeDescription":"TRANSIT BUS-RE","Code":"UNIT_TYPE"},{"CodeValue":"TRANSIT COACH","CodeDescription":"TRANSIT COACH","Code":"UNIT_TYPE"},{"CodeValue":"TRANSIT MIXER","CodeDescription":"TRANSIT MIXER","Code":"UNIT_TYPE"},{"CodeValue":"TRANSPORT","CodeDescription":"TRANSPORT","Code":"UNIT_TYPE"},{"CodeValue":"TRANSPORTER","CodeDescription":"TRANSPORTER","Code":"UNIT_TYPE"},{"CodeValue":"TRASH COMP","CodeDescription":"TRASH COMP","Code":"UNIT_TYPE"},{"CodeValue":"TREE CHOPPER","CodeDescription":"TREE CHOPPER","Code":"UNIT_TYPE"},{"CodeValue":"TRENCHER","CodeDescription":"TRENCHER","Code":"UNIT_TYPE"},{"CodeValue":"TRENCHER","CodeDescription":"TRENCHER","Code":"UNIT_TYPE"},{"CodeValue":"TRUCK","CodeDescription":"TRUCK","Code":"UNIT_TYPE"},{"CodeValue":"TRUCK CRANE","CodeDescription":"TRUCK CRANE","Code":"UNIT_TYPE"},{"CodeValue":"TUB GRINDER","CodeDescription":"TUB GRINDER","Code":"UNIT_TYPE"},{"CodeValue":"U.S. ARMY","CodeDescription":"U.S. ARMY","Code":"UNIT_TYPE"},{"CodeValue":"U.S. ARMY 5-TO","CodeDescription":"U.S. ARMY 5-TO","Code":"UNIT_TYPE"},{"CodeValue":"U.S. ARMY 5-TON","CodeDescription":"U.S. ARMY 5-TON","Code":"UNIT_TYPE"},{"CodeValue":"UG LOADER","CodeDescription":"UG LOADER","Code":"UNIT_TYPE"},{"CodeValue":"UGM","CodeDescription":"UGM","Code":"UNIT_TYPE"},{"CodeValue":"UGM SCOOP","CodeDescription":"UGM SCOOP","Code":"UNIT_TYPE"},{"CodeValue":"UNDRGND MINING","CodeDescription":"UNDRGND MINING","Code":"UNIT_TYPE"},{"CodeValue":"UNLISTED","CodeDescription":"UNLISTED","Code":"UNIT_TYPE"},{"CodeValue":"UT","CodeDescription":"UT","Code":"UNIT_TYPE"},{"CodeValue":"UTILITY","CodeDescription":"UTILITY","Code":"UNIT_TYPE"},{"CodeValue":"UTILITY PLANER","CodeDescription":"UTILITY PLANER","Code":"UNIT_TYPE"},{"CodeValue":"VACUUM SWEEPER","CodeDescription":"VACUUM SWEEPER","Code":"UNIT_TYPE"},{"CodeValue":"VAN","CodeDescription":"VAN","Code":"UNIT_TYPE"},{"CodeValue":"VIBRATORY ROLLE","CodeDescription":"VIBRATORY ROLLE","Code":"UNIT_TYPE"},{"CodeValue":"W/O ENCLOSURE","CodeDescription":"W/O ENCLOSURE","Code":"UNIT_TYPE"},{"CodeValue":"WATER BLASTER","CodeDescription":"WATER BLASTER","Code":"UNIT_TYPE"},{"CodeValue":"WATER JET","CodeDescription":"WATER JET","Code":"UNIT_TYPE"},{"CodeValue":"WATER JET CUTTE","CodeDescription":"WATER JET CUTTE","Code":"UNIT_TYPE"},{"CodeValue":"WATER JET PUMP","CodeDescription":"WATER JET PUMP","Code":"UNIT_TYPE"},{"CodeValue":"WATER WAGON","CodeDescription":"WATER WAGON","Code":"UNIT_TYPE"},{"CodeValue":"WATER WELL DRIL","CodeDescription":"WATER WELL DRIL","Code":"UNIT_TYPE"},{"CodeValue":"WELL DRILL RIG","CodeDescription":"WELL DRILL RIG","Code":"UNIT_TYPE"},{"CodeValue":"WHEEL DOZER","CodeDescription":"WHEEL DOZER","Code":"UNIT_TYPE"},{"CodeValue":"WHEEL LOADER","CodeDescription":"WHEEL LOADER","Code":"UNIT_TYPE"},{"CodeValue":"WINDROW TURNER","CodeDescription":"WINDROW TURNER","Code":"UNIT_TYPE"},{"CodeValue":"WINDROWER","CodeDescription":"WINDROWER","Code":"UNIT_TYPE"},{"CodeValue":"WITH ENCLOSURE","CodeDescription":"WITH ENCLOSURE","Code":"UNIT_TYPE"},{"CodeValue":"WOOD CHIPPER","CodeDescription":"WOOD CHIPPER","Code":"UNIT_TYPE"},{"CodeValue":"WORKBOAT","CodeDescription":"WORKBOAT","Code":"UNIT_TYPE"},{"CodeValue":"WORKBOAT/DREDGE","CodeDescription":"WORKBOAT/DREDGE","Code":"UNIT_TYPE"},{"CodeValue":"WORKOVER RIG","CodeDescription":"WORKOVER RIG","Code":"UNIT_TYPE"},{"CodeValue":"YARD JOCKEY","CodeDescription":"YARD JOCKEY","Code":"UNIT_TYPE"},{"CodeValue":"YARD SPOTTER","CodeDescription":"YARD SPOTTER","Code":"UNIT_TYPE"},{"CodeValue":"YARD SWITCHER","CodeDescription":"YARD SWITCHER","Code":"UNIT_TYPE"},{"CodeValue":"YARTSTER","CodeDescription":"YARTSTER","Code":"UNIT_TYPE"},{"CodeValue":"ZOOMBOOM","CodeDescription":"ZOOMBOOM","Code":"UNIT_TYPE"}],"Header":{"Status":"SUCCESS","Sender":{"ServiceName":"GetSubTypeUnitType","MessageID":"62c73856-439b-47e0-b571-6209051625a3","SenderID":"CSS"},"Target":{"TargetID":"BMS"},"Location":{"LocationID":"56270-56255"}}}';
        SubTypeDetails = (CSS_GetSubTypUnitTypResJ2A)JSON.deserialize(response,CSS_GetSubTypUnitTypResJ2A.class);
            //css_ws_bms.getSubTypesUnitTypesService(Location);
        CSS_WS_BMS bms = new CSS_WS_BMS();
        Test.startTest();
        bms.getSubTypesUnitTypesService(Location);
		bms.insertJobEvent(SubTypeDetails);
        //unittypeservice.insertJobEvent(response);
        Test.stopTest();    
        
        
    }
    static testmethod void testpartslist(){
        CSS_getPartsListBMSRequestJ2A getGSQParts = new CSS_getPartsListBMSRequestJ2A();
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator());
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CSS_BMS_SEND_PARTS';
        csInt.ApplicationName__c='CSS_BMS_SEND_PARTS';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://services-dev.cummins.com/csswarranty/';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        Test.startTest(); 
        CSS_WS_BMS.sendGSQParts(getGSQParts);
        Test.stopTest();
    } 
    static testmethod void testexceptionmethod (){
        Test.startTest();
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'OAGOAUTH';
        csInt.ApplicationName__c='OAGOAUTH';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://services-dev-oauth.cummins.com/api/oauth/token/css';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        try{
            CSS_WS_BMS.splreceiveToken(null);
        }catch(exception e){
            
        }
        Test.stopTest();
    }
    
    // method to Test unitInbound
    static TestMethod void testunitInbound1() {
        // Set mock callout class
        
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        Test.setMock(HttpCalloutMock.class, new CSS_CustOutBoundMock1());
        String custCode;
        String unitNumber;
        String unitDescription;
        String model;
        String VIN;
        String make;
        String application;
        String serviceModelName;
        String ESN;
        String engineFamily;
    //    String applicationCode;
        String applicationCode = '210';
        String location;
        String distanceType;
        String distance = 'DIST';
        String hours;
        String failureDate;
        String WarrantyStartDate;
        String jsonResponseBody;
        Http h1 = new Http();
        HttpResponse res1;
        HttpRequest req1 = new HttpRequest();
        // res1 = h1.send(req1);
        //c.BMS_Claim_ReqJSON__c='';
        
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'CSS_BMS_RequestPDF';
        csInt.ApplicationName__c='CSS_BMS_RequestPDF';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf-aw-ex.cummins.com/jobs/requestpdf';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='POST';
        insert csint;
        
        Test.startTest();
        CSS_WS_BMS.callUnitInbound(custCode,unitNumber,unitDescription,model,VIN,make,serviceModelName,ESN,engineFamily,'ApplicationCode', location,distanceType,distance,hours,failureDate,failureDate,application);
        CG_ReqPDFInbound_Req req= new CG_ReqPDFInbound_Req();
        CG_ReqPDFInbound_Resp res=CSS_WS_BMS.reqPDFInbound(req);
     
        list<CSS_JobHistory__c> jobHistoryToInsertList = new list<CSS_JobHistory__c>();
        CSS_JobHistory__c jh1=new CSS_JobHistory__c();
        jh1.CSS_Object_Name__c ='CSS_Claim__c';
        jobHistoryToInsertList.add(jh1);
        CSS_JobHistory__c jh2=new CSS_JobHistory__c();
        //jobHistoryToInsertList.add(jh1);
        jobHistoryToInsertList.add(jh2);
        
        List< CSS_Integration_Error__c> lsterror = new  List< CSS_Integration_Error__c>();
        CSS_Integration_Error__c ie1=new CSS_Integration_Error__c();
        ie1.Error_Description__c='Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'Submit Claims to BMS Webservice Execution failed';
        ie1.Source__c='Submit Claims to BMS';
        ie1.Processed_Data__c='CSS_WS_BMS-Submit Claims to BMS';
        //ie1.Response_Body__c ='submit claims';
        //insert ie1;
        lsterror.add(ie1);
        CSS_Integration_Error__c ie2=new CSS_Integration_Error__c();
        ie2.Error_Description__c='Submit Claims to BMS HttpResponse is null' + ' *** External Message ** ' + 'Submit Claims to BMS Webservice Execution failed';
        ie2.Source__c='Submit Claims to BMS';
        ie2.Processed_Data__c='CSS_WS_BMS-Submit Claims to BMS';
        lsterror.add(ie1);
        lsterror.add(ie2);
        //List<CSS_Integration_Details__c> lstdet = new List<CSS_Integration_Details__c>();
        
        CSS_Claim_Submission__c c1=new CSS_Claim_Submission__c();
        c1.BMS_Claim_ReqJSON__c='sucess';
        CSS_Claim_Submission__c c2=new CSS_Claim_Submission__c();
        CSS_Claim_Submission__c c3=new CSS_Claim_Submission__c();
        
        List<CSS_Claim_Submission__c> cs=new List<CSS_Claim_Submission__c>();
        cs.add(c1);
        cs.add(c2);
        cs.add(c3);

        Test.setMock(HttpCalloutMock.class , new SubmitClaimsmock_test());
        //CSS_WS_BMS.claimsInbound(cs);
        Test.stopTest();
        
    }
    
      static TestMethod void testCustomerOutboundService11() {
        // Set mock callout class
        
        //Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        Test.setMock(HttpCalloutMock.class, new CSS_CustOutBoundMock());
        
        //String custName = 'newcust2';
        //String custCode = '2223344';
       String custName = null;
       String custCode = null;
       String Location = 'Test';
        
        Test.startTest();
        //CSS_WS_BMS.callCustOutboundService(custName,custCode);
        css_ws_bms.callCustOutboundService(custName, custCode, Location);
        Test.stopTest();
    }
      static TestMethod void testWOQTInbountService121() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        CSS_Job_Order__c jobOrder = CSS_TestData.createJobOrder(true);
        String CSSJobID = jobOrder.Id;
        String DistributorCode = 'D001';
        String BranchCode = 'B001';
        String OrderType = 'Fresh';
        String custCode = 'C4455';
        String Inshop = 'Yes';
        String CreateDate = '20/09/2016';   
        String PromisedDate = '26/09/2016';   
        String BillType = 'bbtype';
        String ContactName = 'contact1';
        //String CustNamePhone = 'namephone';
        String CustomerPhone = '(1)-(541)-(754)-(3010)';
        //String SubType = jobOrder.sub_Type__c;
        String SubType = null;
        String UnitNumber = null;                             
        String Model = jobOrder.Model__c;
        String Make = jobOrder.Make__c;
        String ServiceModelName = null;
        String EngineFamily = null;
        String ESN = null;
        String Location = 'Test-test1-test2';
        String Application = jobOrder.Application__c;
        string contactId = 'testcon123';
        String EmailID = 'abc@example.com';
        String CreateUser = 'user1';
        String ChangeUser = 'user2';
        Test.startTest();
        css_ws_bms.callBMSWOQTInboundService(CSSJobID, OrderType, custCode, Inshop, CreateDate, PromisedDate, BillType, ContactName, CustomerPhone, SubType, UnitNumber, Model, Make, ServiceModelName, EngineFamily, ESN, Application, location,contactId,EmailID,CreateUser,ChangeUser);
        Test.stopTest();
    }  
    
    static testmethod void claimsInbound1(){
         
        
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'ClaimsInbound';
         cid.ApplicationName__c = 'ClaimsInbound';
         cid.End_Point__c = 'https://services-dev.cummins.com/csswarranty/bmsclaiminbound/';
         cid.logging__c = 'BOTH';
         cid.AuthEnv__c = 'MuleAuth';
         cid.Method_Type__c = 'POST';
         cid.Timeout__c = 120000;
         cid.IsActive__c = true;
         insert cid;
        
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(FALSE);
        JO.CSS_Channel_Code__c ='101';
        JO.Qsol_Engine_Family_Code__c ='122';
        JO.Territory_Class__c = '22';
        INSERT jO; 
        
        date d1 =system.today();
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        
        
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(false,null); 
            cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
            insert cj;
            
        }
       
       CSS_accountLanguage__c accLang = new CSS_accountLanguage__c();
       accLang.CSS_EDSLanguage__c = 'en';
       accLang.Name = 'en_US';
       accLang.CSS_QsolLanguage__c = 'en';
       accLang.CSS_userLanguage__c = 'English';
       insert accLang;
       
        CSS_PSN__c ps = new CSS_PSN__c();
        ps.Primary__c = true;
        ps.CSS_Claims__c = cj.id ;
        ps.Qsol_Engine_Family_Code__c ='100';
        ps.Failure_Date__c =d1;
        ps.Primary__c = true;
        ps.CSS_Claims__c =cj.id;
        ps.PSN__c = '73806085';
        insert ps;
        
		List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.CSS_Claims__c=cj.id;
        claimsSub.BMS_Claim_ReqJSON__c = '{"Header":{"Target":"CSSWarranty","Sender":{"ServiceName":"ClaimSubmission","SenderID":"CSS","MessageID":"UniqueID"}},"DataArea":{"WarrantyTrainedFlag":"Y","WarrantyStartDate":"09/1/2018","UnitNumber":"9800","TSRNumber":"","TechActualHrs":"2.0","SubmittedBy":"SPUSER","SRTPenaltyPercentage":"","SPTravelRate":"","SPLaborRate":"","SPInShopLaborRate":"","SPCertifiedFlag":"N","ServiceProviderCode":"03750","RONumber":"SO1234","RoadRelayWarrantyFlg":"N","RMAFlag":"N","RevisionBefore":"","ReviewAfter":"","ReplacementPart":"","RepairDescription":"","ReConPartsWarrantyFlg":"N","PolicyRequestID":"","PenaltyFlag":"N","PaccarFlag":"N","NewPartsWarrantyFlg":"N","MultiESNFlg":"N","ModelSeries":"T408","MissionDisablingFlag":"N","Manufacturer":"KENWORTH","manualAdjudicationFlag":"N","ListOfPromotionIds":{"PromotionIds":[{"PromotionID":"No Promotion Id"}]},"ListOfNotes":{"Notes":[{"NoteType":"SourceEnv","Note":"CGCDWTST"},{"NoteType":"Cause","Note":""},{"NoteType":"Correction","Note":"Failure Name =Engine Brake Rocker Lever Quantity =null Failure Name =Engine Brake Solenoid Valve Quantity =null Failure Name =Engine Control Module Cooling Plate Quantity =null Failure Name =Engine Intake Throttle Actuator Quantity =null Failure Name =Turbocharger Quantity =null "},{"NoteType":"Complaint","Note":null},{"NoteType":"99 Time Details","Note":"Test"},{"NoteType":"SRT","Note":""}]},"listOfFailureList":{"FailureList":[{"WarrantyId":"","SystemCode":"IN","SupportPlanID":"","PrimaryFailureFlag":"N","PayCode":"A","listOfTravelDetails":{"TravelDetails":[]},"listOfSRTs":{"SRTs":[{"SRTType":"Custom","SRTQty":"1","SRTPrcnt":"100","SRTHours":"0.5","SRTCode":"99-999","SRTAccessCode":"R","OverlapHrs":"","OutOfChasis":"Y","Offiste":"N","Justification":"Refer To Narrative","ExcludeOvrlpFlg":"N"}]},"listOfParts":{"Parts":[]},"listOfOtherClaimables":{"OtherClaimables":[]},"listOfFailureCylinder":{"FailureCylinder":[]},"FaultCode":"","FailMode":"2B","DeductibleAmount":"","CoveredTravelMiles":"0","CoveredTravelLabor":"0","CoveredTowingMiles":"0","CoveredPartsQuantity":"9999999","CoveredOCAmount":"9999999","CoveredMealsLodgingAmt":"0","CoveredLaborHours":"9999999","CoverageType":"","ComponentCode":"TD","CertificateNumber":"","CampaignTravelPrcnt":"0","CampaignTowingPrcnt":"0","CampaignPartsPrcnt":"0","CampaignOCPrcnt":"0","CampaignNumber":"","CampaignLabourPrcnt":"0","Bank":"","AuthorizationNum":"","ApproverCode":"","AccountCode":"62"}]},"ListOfComplaintCodes":{"ComplaintCodes":[{"ComplaintCode":"118"}]},"ListOfAdditionalESNs":{"AdditionalESNs":[]},"LicencePlateState":"","LastName":"","Justification":"","InfoOnlyFlag":"N","FirstName":"","FailurePoint":"10","FailureMeasure":"Miles","FailureDate":"09/6/2017","ESNCount":"1","EngineVIN":"1XKYA48X4GJ479251","EngineSerialNumber":"79812345","EngineApplicationCode":"130","ECMCalibBefore":"","ECMCalibAfter":"","DistributorCode":"03742","DISDNumber":"","DealerClaimNumber":"C0000090219-03","CustomerPossession":"No","CustomerName":"Butler Trucking- Only Failures","CSSJobID":"","Contact":"Miruthula Kanagaraj","ClaimSource":"Guidanz","ClaimFiledDate":"04/24/2019","CatastrophicFlag":"N","CampaignNumber":"","BISFlag":"N"}}';
        submID.add(claimsSub);
        insert submID;
        

        Test.StartTest(); 
        Test.setMock(HttpCalloutMock.class , new SubmitClaimsmock_test());
        //CSS_WS_BMS.claimsInbound(submID);
        test.stopTest();
    }
    
     static testmethod void ClaimsInbound2(){
         
        
         CSS_Integration_Details__c cid = CSS_TestData.createIntegrationDetails(false);
         cid.name = 'ClaimsInbound';
         cid.ApplicationName__c = 'ClaimsInbound';
         cid.End_Point__c = 'https://services-dev.cummins.com/csswarranty/bmsclaiminbound/';
         cid.logging__c = 'BOTH';
         cid.AuthEnv__c = 'OAGOAuthTest';
         cid.Method_Type__c = 'POST';
         cid.Timeout__c = 120000;
         cid.IsActive__c = true;
         insert cid;
        
        
        CSS_Job_Order__c JO = CSS_TestData.createJobOrder(FALSE);
        JO.CSS_Channel_Code__c ='101';
        JO.Qsol_Engine_Family_Code__c ='122';
        JO.Territory_Class__c = '22';
        INSERT jO; 
        
        date d1 =system.today();
        CSS_Claims__c cj = new CSS_Claims__c();
        cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
        
        
        
        String grpName = 'CQ'+'-'+'12345-12345';
        Group testQue = new Group(Name=grpName, type='Queue');
        insert testQue;
        
        system.runas(new User(Id=UserInfo.getUserId()))
        { 
            
            QueueSObject tq = new QueueSObject(SobjectType='CSS_Claims__c', QueueId=testQue.Id);
            insert tq;
            //Id recTyIdpart = Schema.SObjectType.CSS_Parts_Options__c.getRecordTypeInfosByName().get('BMS Parts').getRecordTypeId();
            css_job_order__c joorder = css_testdata.createJobOrder(true);
            cj = CSS_TestData.createclaims(false,null); 
            cj.CSS_Channel_Code__c='101';
        cj.Territory_Class__c='100';
        cj.ESN__c='73806085';
        cj.Location_Code__c='02850-02991';
        cj.CSS_Channel_Of_Distribution__c='101-DISTRIBUTOR-BRANCH';
        cj.Territory_Class_Name__c='UNITED STATES';
        cj.Territory__c='';
            insert cj;
            
        }
       
       CSS_accountLanguage__c accLang = new CSS_accountLanguage__c();
       accLang.CSS_EDSLanguage__c = 'en';
       accLang.Name = 'en_US';
       accLang.CSS_QsolLanguage__c = 'en';
       accLang.CSS_userLanguage__c = 'English';
       insert accLang;
        
        CSS_PSN__c ps = new CSS_PSN__c();
        ps.Primary__c = true;
        ps.CSS_Claims__c = cj.id ;
        ps.Qsol_Engine_Family_Code__c ='100';
        ps.Failure_Date__c =d1;
        ps.Primary__c = true;
        ps.CSS_Claims__c =cj.id;
        ps.PSN__c = '73806085';
        insert ps;
        
		List<CSS_Claim_Submission__c> submID = new List<CSS_Claim_Submission__c>();
        CSS_Claim_Submission__c claimsSub = new CSS_Claim_Submission__c();
        claimsSub.Type__c = 'ytes';
        claimsSub.Rejection_Reason__c='test';
        claimsSub.Status__c= 'Submitted';
        claimsSub.CSS_Claims__c=cj.id;
        claimsSub.BMS_Claim_ReqJSON__c = '{"Header":{"Target":"CSSWarranty","Sender":{"ServiceName":"ClaimSubmission","SenderID":"CSS","MessageID":"UniqueID"}},"DataArea":{"WarrantyTrainedFlag":"Y","WarrantyStartDate":"09/1/2018","UnitNumber":"9800","TSRNumber":"","TechActualHrs":"2.0","SubmittedBy":"SPUSER","SRTPenaltyPercentage":"","SPTravelRate":"","SPLaborRate":"","SPInShopLaborRate":"","SPCertifiedFlag":"N","ServiceProviderCode":"03750","RONumber":"SO1234","RoadRelayWarrantyFlg":"N","RMAFlag":"N","RevisionBefore":"","ReviewAfter":"","ReplacementPart":"","RepairDescription":"","ReConPartsWarrantyFlg":"N","PolicyRequestID":"","PenaltyFlag":"N","PaccarFlag":"N","NewPartsWarrantyFlg":"N","MultiESNFlg":"N","ModelSeries":"T408","MissionDisablingFlag":"N","Manufacturer":"KENWORTH","manualAdjudicationFlag":"N","ListOfPromotionIds":{"PromotionIds":[{"PromotionID":"No Promotion Id"}]},"ListOfNotes":{"Notes":[{"NoteType":"SourceEnv","Note":"CGCDWTST"},{"NoteType":"Cause","Note":""},{"NoteType":"Correction","Note":"Failure Name =Engine Brake Rocker Lever Quantity =null Failure Name =Engine Brake Solenoid Valve Quantity =null Failure Name =Engine Control Module Cooling Plate Quantity =null Failure Name =Engine Intake Throttle Actuator Quantity =null Failure Name =Turbocharger Quantity =null "},{"NoteType":"Complaint","Note":null},{"NoteType":"99 Time Details","Note":"Test"},{"NoteType":"SRT","Note":""}]},"listOfFailureList":{"FailureList":[{"WarrantyId":"","SystemCode":"IN","SupportPlanID":"","PrimaryFailureFlag":"N","PayCode":"A","listOfTravelDetails":{"TravelDetails":[]},"listOfSRTs":{"SRTs":[{"SRTType":"Custom","SRTQty":"1","SRTPrcnt":"100","SRTHours":"0.5","SRTCode":"99-999","SRTAccessCode":"R","OverlapHrs":"","OutOfChasis":"Y","Offiste":"N","Justification":"Refer To Narrative","ExcludeOvrlpFlg":"N"}]},"listOfParts":{"Parts":[]},"listOfOtherClaimables":{"OtherClaimables":[]},"listOfFailureCylinder":{"FailureCylinder":[]},"FaultCode":"","FailMode":"2B","DeductibleAmount":"","CoveredTravelMiles":"0","CoveredTravelLabor":"0","CoveredTowingMiles":"0","CoveredPartsQuantity":"9999999","CoveredOCAmount":"9999999","CoveredMealsLodgingAmt":"0","CoveredLaborHours":"9999999","CoverageType":"","ComponentCode":"TD","CertificateNumber":"","CampaignTravelPrcnt":"0","CampaignTowingPrcnt":"0","CampaignPartsPrcnt":"0","CampaignOCPrcnt":"0","CampaignNumber":"","CampaignLabourPrcnt":"0","Bank":"","AuthorizationNum":"","ApproverCode":"","AccountCode":"62"}]},"ListOfComplaintCodes":{"ComplaintCodes":[{"ComplaintCode":"118"}]},"ListOfAdditionalESNs":{"AdditionalESNs":[]},"LicencePlateState":"","LastName":"","Justification":"","InfoOnlyFlag":"N","FirstName":"","FailurePoint":"10","FailureMeasure":"Miles","FailureDate":"09/6/2017","ESNCount":"1","EngineVIN":"1XKYA48X4GJ479251","EngineSerialNumber":"79812345","EngineApplicationCode":"130","ECMCalibBefore":"","ECMCalibAfter":"","DistributorCode":"03742","DISDNumber":"","DealerClaimNumber":"C0000090219-03","CustomerPossession":"No","CustomerName":"Butler Trucking- Only Failures","CSSJobID":"","Contact":"Miruthula Kanagaraj","ClaimSource":"Guidanz","ClaimFiledDate":"04/24/2019","CatastrophicFlag":"N","CampaignNumber":"","BISFlag":"N"}}';
        submID.add(claimsSub);
        insert submID;
        

        Test.StartTest(); 
        Test.setMock(HttpCalloutMock.class , new SubmitClaimsmock_test());
        //CSS_WS_BMS.claimsInbound(submID);
        test.stopTest();
    }
    
}