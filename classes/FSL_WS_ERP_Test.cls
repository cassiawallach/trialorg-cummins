@isTest
public class FSL_WS_ERP_Test {
    
    // method to Test WOQT inbound
    static TestMethod void testWOQTInbountService() {
        
        WorkOrder jobOrder = new WorkOrder();
        String CSSJobID = jobOrder.Id;
        String DistributorCode = 'D001';
        String BranchCode = 'B001';
        String OrderType = 'Fresh';
        String custCode = 'C4455';
        String Inshop = 'Yes';
        String CreateDate = '20/09/2016';   
        String PromisedDate = '26/09/2016';   
        String ScheduledDate= 'jobOrder.Available_for_Service__c';
        String BillType = 'bbtype';
        String ContactName = 'contact1';
        //String CustNamePhone = 'namephone';
        String CustomerPhone = '(1)-(541)-(754)-(3010)';
        //String SubType = jobOrder.sub_Type__c;
        String SubType = null;
        String UnitNumber = null;
        String Model = null;
        String Make = null;
        String ServiceModelName = null;
        String EngineFamily = null;
        String ESN = null;
        String Source = 'Siebel';
        String Location = 'Test-test1-test2';
        String Application = '130';
        //may**
        string contactId = 'testcon123';
        String EmailID = 'abc@example.com';
        String CreateUser = null;
        String ChangeUser = null;
        String CustomersPO = null;
        String SiteID = null;
        String Planned = 'No';
        String Notes = 'test';
        String PayerID = null;
        String individualItemNumber = '123456789';
        String PayerContactID = null;
        string strconMunerMPnumber ='MP-111';
        string DistanceType ='MILES';
        string Distance ='100';
        string Hours ='200.0';
        
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FSL_MockTest());
        
        //String Application,String location,String ContactID,String EmailID,String CreateUser,String ChangeUser,
        //String Planned, String SiteID, String CustomersPO, String PayerID, String Notes,String Source,String individualItemNumber) {
        
         //Start - Added by Naveen - PHOEN-271
            FSL_WS_ERP.inputWrapperParams ERPwrParams = new FSL_WS_ERP.inputWrapperParams();
            
            ERPwrParams.CSSJobID=   CSSJobID;
            ERPwrParams.OrderType=  OrderType;
            ERPwrParams.custCode=   custCode; /*accountnumber*/ /*customer code replace*/
            ERPwrParams.Inshop= Inshop;
            ERPwrParams.CreateDate= CreateDate;
            ERPwrParams.PromisedDate=   PromisedDate;//PromisedDate
            ERPwrParams.ScheduledDate=  ScheduledDate;//ScheduledDate
            ERPwrParams.BillType=   BillType;//BillType
            ERPwrParams.ContactName=    ContactName;
            ERPwrParams.CustomerPhone=  CustomerPhone; /*Cstmr_Contacts_Phone__c*/
            ERPwrParams.SubType=    SubType; // get it from WO SubType field - first 2 chars
            ERPwrParams.UnitNumber= UnitNumber;
            ERPwrParams.Model=  Model;
            ERPwrParams.Make=   Make;
            ERPwrParams.ServiceModelName=   ServiceModelName; // get it from WO - SMN //wo.Asset.Service_Model__c /*Service_Model__c*/
            ERPwrParams.EngineFamily=   EngineFamily; //wo.Asset.Engine_Family_Code__c, //wo.Qsol_Engine_Family_Code__c
            ERPwrParams.ESN=    ESN;
            ERPwrParams.Application=    Application; /*wo.Application_Desc__c*/
            ERPwrParams.location=   location;
            ERPwrParams.ContactID=  ContactID; //(con.FSL_Contact_Id__c == null ? '' : con.FSL_Contact_Id__c),
            ERPwrParams.EmailID=    EmailID; /*wo.Email_Address__c*/
            ERPwrParams.CreateUser= CreateUser;//(String)Cache.Session.get('local.CSSPartition.UserFederationIdentifier'),
            ERPwrParams.ChangeUser= ChangeUser;//ChangeUser
            ERPwrParams.Planned=    Planned; //Planned
            ERPwrParams.SiteID= SiteID; //SiteID
            ERPwrParams.CustomersPO=    CustomersPO; //CustomersPO
            ERPwrParams.PayerID=    PayerID;
            ERPwrParams.Notes=  Notes;
            ERPwrParams.Source= Source;
            ERPwrParams.individualItemNumber=   individualItemNumber;
            ERPwrParams.PayerContactID= PayerContactID;
            ERPwrParams.strconMunerMPnumber=    strconMunerMPnumber;
            ERPwrParams.DistanceType=   DistanceType;
            ERPwrParams.Distance=   Distance;
            ERPwrParams.Hours=  Hours;
        
        FSL_WS_ERP.callBMSWOQTInboundService(ERPwrParams);
        String json = '{"DataArea": {"CSSJobID": "00002745","ContactID": 1921,"WOReferenceNumber": 6393191},"Header": {"Sender": {"ServiceName": "CreateWorkOrder","SenderID": "CSS","MessageID": "98e74b0b-6a8e-47d1-b4b2-5916e4de0291"},"Status": "SUCCESS","Target": {"TargetID": "MOVEX"},"ReturnCodeDescription": "WO/WOQT 6393191 updated successfully","Location": {"LocationID": ""}}}';                
        FSL_BMSWOQTInboundJSON2APEX obj = FSL_BMSWOQTInboundJSON2APEX.parse(json);
        FSL_WS_ERP.CSS_CustomException cs = new FSL_WS_ERP.CSS_CustomException();
        Test.stopTest();
    }
    
}