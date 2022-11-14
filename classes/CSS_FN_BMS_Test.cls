@isTest(SeeAllData=false)
public class CSS_FN_BMS_Test {
   
    static TestMethod void createNewQuote(){
        /*CSS_Job_Order__c SerRec1 = CSS_TestData.createJobOrder(True);*/
        
        CSS_Job_Order__c SerRec = new CSS_Job_Order__c();
                Date d = Date.Today();
       // System.debug('date');
                SerRec.DSID__c='12345';
                SerRec.DSID_Status__c='open';
                SerRec.ESN__c ='79464647';
                SerRec.Customer_Name__c='ABC';
                SerRec.Failure_Date__c =d;
                SerRec.Failure_Point__c=2.2;
                SerRec.Unit_Number__c='1234';
                SerRec.Service_Model__c='ESN';
                SerRec.Service_Model_N__c = 445566;
                SerRec.Make__c='test';
                SerRec.Model__c='test1';
                SerRec.VIN__c='1XKAD49X6CJ305490';
                SerRec.Customer_Name__c='ABC';
                SerRec.Warranty_Start_Date__c=d;
                SerRec.Failure_Point_Measure__c = 'MI'; 
                SerRec.Application__c='Automotive'; 
                SerRec.sub_Type__c='cedan'; 
                insert SerRec;
         String nameId =[select id,name from CSS_Job_Order__c where id = :SerRec.Id ].name;
        system.debug('nameId>>>>'+nameId);
        
         CSS_Quote__c quoteObj =  new CSS_Quote__c();
          quoteObj.Service_Job__c = SerRec.Id;
                 insert quoteObj;
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON wrapobj2 = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea Req1 = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea();
          
          Req1.CustomerNumber = '123';
          Req1.BranchCode = '123';
          Req1.CustomerNumber = 'lo';
          Req1.DiagnosticCharges = '1235';
          Req1.DistributorCode = '325';
          Req1.ItemBillable = '78';
          Req1.ItemGrossSell = '123';
          Req1.ItemWarranty = '123';
          Req1.LaborBillable = '321';
          Req1.LaborGrossSell = '123';
          Req1.LaborWarranty = '351';
          Req1.MiscBillable = '456';
          Req1.MiscGrossSell = '456';
          Req1.MiscWarranty = '456';
          Req1.OrderReference = 'sxc';
          Req1.QuoteTotal = '123';
          Req1.Surcharge = '546';
          Req1.Taxes = '123';
          Req1.TransactionType = 'ddd';
          //Req1.CSSJobID = '123';
          Req1.CSSJobID =nameId;
          wrapobj2.DataArea= Req1;
           /*CSS_Quote__c quoteObj =  new CSS_Quote__c();
          quoteObj.Service_Job__c = SerRec1.Id;
                 insert quoteObj;*/
        
          CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Header head = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Header();
          CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Sender send = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Sender();
          CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Target trget = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Target();
          CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Location location = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Location();
          wrapobj2.Header = head;
       
        send.SenderID='ugdfhg';
        send.ServiceName='uigfiddf';
        head.Sender=send;
        trget.TargetID ='123';
        head.Target=trget;
        location.LocationID='345';
        head.Location=location;
    
         
       
                
      
        
    
          CSS_FN_BMS BMSClass= new CSS_FN_BMS();
          Test.startTest();
          BMSClass.createNewQuote(wrapobj2);
          Test.stopTest();        
    }  
    
    static TestMethod void updateExistingQuote(){
       
           
        CSS_Job_Order__c SerRec1 = CSS_TestData.createJobOrder(True);    
         CSS_Quote__c quoteObj =  CSS_TestData.createquoteObj(True); 
          system.debug('SerRec1>>>>>'+SerRec1);
         String nameId =[select id,name from CSS_Job_Order__c where id = :SerRec1.Id ].name;
        system.debug('nameId>>>>'+nameId);
                    
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON wrapobj = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea Req = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea();
        //CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Header HeaderReq = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Header();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Header head = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Header();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Sender send = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Sender();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Target trget = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Target();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Location location = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Location();
        
          wrapobj.DataArea= Req;
          wrapobj.Header = head;
        
        //wrapobj.Header = HeaderReq;
        
        
             
            
        //wrapobj.Sender = send;
        //wrapobj.Target = trget;
        
        
          Req.CustomerNumber = '123';
        
          Req.BranchCode = '123';
          Req.CustomerNumber = '123';
          Req.DiagnosticCharges = '123';
          Req.DistributorCode = '123';
          Req.ItemBillable = '123';
          Req.ItemGrossSell = '123';
          Req.ItemWarranty = '123';
          Req.LaborBillable = '123';
          Req.LaborGrossSell = '123';
          Req.LaborWarranty = '123';
          Req.MiscBillable = '123';
          Req.MiscGrossSell = '123';
          Req.MiscWarranty = '213';
          Req.OrderReference = '123';
          Req.QuoteTotal = '123';
          Req.Surcharge = '123';
          Req.TransactionType = '2345';
    
          Req.Taxes = '123';
          Req.TransactionType = '123';
          Req.CSSJobID = nameId ;
        
           head.Sender=send;
           send.SenderID='sendert';
           send.ServiceName='intake';
           head.Target=trget;
           trget.TargetID ='Piuytr';
           head.Location=location;
           location.LocationID='Southe';

          /*quoteObj.Service_Job__c = SerRec1.Id;
        
            insert quoteObj;*/
        CSS_FN_BMS BMSClass= new CSS_FN_BMS();
         Test.startTest();
       BMSClass.updateExistingQuote(wrapobj,quoteObj);
          Test.stopTest();        
    }
    static TestMethod void createQuoteAttachment(){
        
 CSS_Quote__c quoteObj = new CSS_Quote__c();
            quoteObj.BranchCode__c =    '123';
            quoteObj.CustomerNumber__c =  '123';
        insert quoteObj;
         Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        
        attach.parentId=quoteObj.id;
        
        
        attach.Description = 'Test'; 
    
        insert attach;
        
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:quoteObj.id];
        System.assertEquals(1, attachments.size());

         CSS_WPR_BMS_WOQTOutboundQuoteReqJSON Req = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
         CSS_FN_BMS BMSClass= new CSS_FN_BMS();
        Test.startTest();
         id response = BMSClass.createQuoteAttachment(Req, quoteObj.Id);
        Test.stopTest();
    }
    
    static TestMethod void prepareWOQTOutboundQuoteResWrapper() {
        


         String status = 'sucess';
         String returnCodeDescription = 'ERT';
         String locationID = 'ASD';
        
       
      
         //CSS_WPR_BMS_WOQTOutboundQuoteReqJSON Req = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
         CSS_FN_BMS BMSClass= new CSS_FN_BMS();
         CSS_WPR_BMS_WOQTOutboundQuoteResJSON Res = new  CSS_WPR_BMS_WOQTOutboundQuoteResJSON();
         CSS_WPR_BMS_WOQTOutboundQuoteResJSON.Header resheader = new CSS_WPR_BMS_WOQTOutboundQuoteResJSON.Header();
         //CSS_WPR_BMS_WOQTOutboundQuoteResJSON.Location location = new  CSS_WPR_BMS_WOQTOutboundQuoteResJSON.Location();
         Res.Header = resheader;
         //resheader.Status = 'sucess';
         //resheader.ReturnCodeDescription = 'ERT';
         //resheader.Location =  location;
         //location.LocationID = 'ASD';
         Test.startTest();
         BMSClass.prepareWOQTOutboundQuoteResWrapper(status,returnCodeDescription,locationID);
         Test.stopTest();
        
    }
    static TestMethod void performValidations() {
        
     /* RestRequest req = new RestRequest();   
        req.httpMethod = 'GET';
        req.requestURI = 'SAlesforce.com';*/
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON wrapobj1 = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Body bdy = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Body();
         
      
        req.requestURI = '/services/apexrest/Accounts';  
        req.addParameter('page', '0');
        req.addParameter('time', '1390296387');
        req.addParameter('hash', '1wer2547');

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
         String jSONRequestBody;
        String status;
        String returnCodeDescription;
        
        req.requestBody = Blob.valueOf(JSON.serializePretty(bdy));
        jSONRequestBody = null;
        jSONRequestBody = '';
                status = 'Error';
                returnCodeDescription = 'Requested input is invalid';
        
       CSS_WPR_BMS_WOQTOutboundQuoteReqJSON wrp = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
         CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea ar  = new  CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea();
        wrp.DataArea = ar;
        ar.OrderReference ='234';
        
         status = 'Error';
         returnCodeDescription = 'Requested OrderReference is invalid';
        ar.CSSJobID = '123';
        ar.CustomerNumber = '123';
        ar.QuoteDoc = null;
         status = 'Error';
            returnCodeDescription = 'Invalid JSON Format';
        CSS_FN_BMS BMSClass= new CSS_FN_BMS();
        Test.startTest();
        BMSClass.performValidations(req);
        Test.stopTest();
        
    }
    
    
    private static CSS_WPR_BMS_WOQTOutboundQuoteReqJSON setupData()
    {
           
           
           
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Sender sender = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Sender();
           sender.ServiceName='Test Service';
           sender.SenderID='Test Sender';
           
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Target target = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Target();
           target.TargetId = 'Test Target';
           
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Location location = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Location();
           location.LocationID='Test Location';
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Header headerData = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Header();
           headerData.Sender = sender;
           headerData.Target = target;
           headerData.Location = location;
           
           
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.RealBlobValue blobVal = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.RealBlobValue();
           blobVal.asByteArray='Test Byte Array';
           
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Body body = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Body();
           body.realBlobValue = blobVal;
           
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.QuoteDoc quote = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.QuoteDoc();
           quote.Body=body;
           quote.ContentType = 'text/plain';
           
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea dataArea = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea();
           dataArea.QuoteTotal='200';
           dataArea.MiscWarranty='2 yrs';
           dataArea.ItemGrossSell='10';
           dataArea.BranchCode='ABC';
           dataArea.LaborWarranty='10';
           dataArea.TransactionType='Test';
           dataArea.MiscBillable='20';
           dataArea.Surcharge='1';
           dataArea.ItemBillable='2';
           dataArea.MiscGrossSell='10';
           dataArea.Taxes='20';
           dataArea.DistributorCode='ABC';
           dataArea.CustomerNumber='Test CUST';
           dataArea.LaborBillable='10';
           dataArea.LaborGrossSell='11';
           dataArea.ItemWarranty='11';
           dataArea.OrderReference='123';
           dataArea.GrandTotal='1111';
           dataArea.DiagnosticCharges='1111';
           dataArea.CSSJobID='CS-100';
           dataArea.QuoteDoc=quote;
           
           CSS_WPR_BMS_WOQTOutboundQuoteReqJSON jsonData = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
           jsonData.DataArea=dataArea;
           jsonData.Header = headerData;
           
           return  jsonData;
    }
    
    
    @isTest static void performValidationsTest1() {
        
    
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        CSS_WPR_BMS_WOQTOutboundQuoteReqJSON jsonTestData = setupData();
        
         
      
        req.requestURI = '/services/apexrest/Accounts';  
        req.addParameter('page', '0');
        req.addParameter('time', '1390296387');
        req.addParameter('hash', '1wer2547');

        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response = res;
        
         String jSONRequestBody;
       
        
        
       
        CSS_FN_BMS BMSClass= new CSS_FN_BMS();
        Test.startTest();
        jsonTestData.DataArea.OrderReference=null;
        req.requestBody = Blob.valueOf(JSON.serializePretty(jsonTestData));
        BMSClass.performValidations(req);
        
        jsonTestData.DataArea.OrderReference='1009';
        jsonTestData.DataArea.CSSJobID=null;
        req.requestBody = Blob.valueOf(JSON.serializePretty(jsonTestData));
        BMSClass.performValidations(req);
        
        
        jsonTestData.DataArea.CSSJobID='100098';
        jsonTestData.DataArea.CustomerNumber=null;
        req.requestBody = Blob.valueOf(JSON.serializePretty(jsonTestData));
        BMSClass.performValidations(req);
        
        jsonTestData.Header.Location=null;
        jsonTestData.DataArea.CustomerNumber='1234';
        req.requestBody = Blob.valueOf(JSON.serializePretty(jsonTestData));
        BMSClass.performValidations(req);
        
        jsonTestData.DataArea.QuoteDoc=null;
        jsonTestData.Header.Location = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.Location();
        jsonTestData.Header.Location.LocationID='12345';
        req.requestBody = Blob.valueOf(JSON.serializePretty(jsonTestData));
        BMSClass.performValidations(req);
        
        Test.stopTest();
        
    }
    
    
    @isTest static void getBMSContactDetailsTest1() {
        Test.setMock(HttpCalloutMock.class, new BMSContactLookupMock_Mule());
    
        CSS_FN_BMS BMSClass= new CSS_FN_BMS();
        CSS_Integration_Details__c csInt = new CSS_Integration_Details__c();
        csInt.name = 'BMSContactOutbound';
        csInt.ApplicationName__c='BMSContactOutbound';
        csInt.AuthEnv__c='Test';
        //csInt.End_Point__c='https://Test-services-dev.cummins.com/css/';
        csInt.End_Point__c='https://api-ue-devnf2-aw-ex.cummins.com/cmi-customers/contact';
        csInt.IsActive__c=true;
        csInt.Key__c='/Q0w11SmTDJ11dPRgzYfGjycs+HZbtT8sezi/jkT7Ag=';
        csInt.Passcode__c='u9pf3rdOE0SCjXDCgmzRbUlwWQWen7B9993Eh61KI1E=';
        csInt.Username__c='6dpW6v5ekUR2HzkTePJXwgNaMDgo0t53tZgmixV4rfU=';
        csInt.Method_Type__c='GET';
        insert csint;
        system.debug('csint**'+csint);
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new BMSMockHttpResponseGenerator());BMSContactLookupMock_Mule
         
        BMSClass.getBMSContactDetails('test','test');
        BMSClass.getBMSUnitLookupDetails('100','1001','100','1001');
        Test.stopTest();
        
    }
    @isTest static void getBMSUnitDetailsTest1() {
        Test.setMock(HttpCalloutMock.class, new CSS_BMS_UnitOutboundMockup_Test());
    
        CSS_FN_BMS BMSClass= new CSS_FN_BMS();
        CSS_BMSUnitLookupRequestJ2A bu = new CSS_BMSUnitLookupRequestJ2A();
        BMSClass.prepareRqWrapperBMSContactLookup('100', '1001');
bu = BMSClass.prepareRqWrapperBMSUnitLookup('100', '79464646', '101', '1001');
        CSS_UnitOutboundJSON2Apex ub = new CSS_UnitOutboundJSON2Apex();
        BMSClass.restrictUnitLookupResultsToHundred(ub);
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
        csInt.Method_Type__c='GET';
        insert csint;
        system.debug('csint**'+csint);
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new BMSMockHttpResponseGenerator());BMSContactLookupMock_Mule
         
        //BMSClass.getBMSContactDetails('test','test');
        BMSClass.getBMSUnitLookupDetails('100','1001','100','1001');
        Test.stopTest();
        
    }
   
    
    static TestMethod void updateQuote() {
        
               
         CSS_WPR_BMS_WOQTOutboundQuoteReqJSON Req = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
         //CSS_WPR_BMS_WOQTOutboundQuoteReqJSON wrapobj = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON();
         CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea Req1 = new CSS_WPR_BMS_WOQTOutboundQuoteReqJSON.DataArea();
        //Req1.OrderReference = '123';
          CSS_Quote__c quoteObj =  CSS_TestData.createquoteObj(True); 
         Req.DataArea= Req1;
        Req1.OrderReference =quoteObj.OrderReference__c ;
        system.debug(' Req1.OrderReference>>>>'+ Req1.OrderReference);
        //insert quoteObj;
        CSS_FN_BMS BMSClass1= new CSS_FN_BMS();
       
          //Boolean updateFlag =  BMSClass1.updateExistingQuote(wrapobj,quoteObj);
        string quoteId ;
        quoteId = quoteObj.Id;
         CSS_FN_BMS BMSClass= new CSS_FN_BMS();
        Test.startTest();
        BMSClass.updateQuote(Req);
        Test.stopTest();
        
    }
    
        static TestMethod void restrictUnitLookupResultsToHundred() {
        
               
         CSS_UnitOutboundJSON2Apex Req = new CSS_UnitOutboundJSON2Apex();
         CSS_UnitOutboundJSON2Apex.DataArea dataAreaReq = new CSS_UnitOutboundJSON2Apex.DataArea();
         CSS_Quote__c quoteObj =  CSS_TestData.createquoteObj(True); 
         CSS_FN_BMS BMSClass= new CSS_FN_BMS();
         Test.startTest();
           BMSClass.restrictUnitLookupResultsToHundred(Req);
         Test.stopTest();
        
    }
  
}