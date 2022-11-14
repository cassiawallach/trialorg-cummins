@isTest
public class CG_WS_OAG_Test {
    static testmethod void Method1()
    {
        //CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='TSR',ApplicationName__c='TSR',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/technicianservicerequest',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
         CSS_Integration_Details__c  itgDetails = new CSS_Integration_Details__c();
  itgDetails.Name = 'TSR';
 itgDetails.AuthEnv__c = 'OAGDev';
 itgDetails.ApplicationName__c = 'TSR';
 itgDetails.Username__c = 'HfL6S926+ZPvI5xOyy4VEZnCNhVtWWFyWx8tnH9xgqE=';
 itgDetails.End_Point__c = 'https://services-dev.cummins.com/css/technicianservicerequest';
 itgDetails.Method_Type__c = 'POST';
 itgDetails.Timeout__c = 2.0;
   
        insert itgDetails;
      
         Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        Test.setMock(HttpCalloutMock.class, new CG_TSRMock_Test());
       
        Test.startTest();
        CG_TSRReqJSONParser req = new CG_TSRReqJSONParser();
        CG_IP_OAGWrapper req2 = new CG_IP_OAGWrapper();
        req2.serviceName = 'TSR';
        req2.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CG_OP_OAGWrapper oagoutput = new CG_OP_OAGWrapper();
        oagoutput = CG_WS_OAG.getAccessToken('service1');
        //oagoutput = CG_WS_OAG.calloutTSRService(req);
        oagoutput = CG_WS_OAG.calloutGeneric(req2);
        oagoutput = CG_WS_OAG.getMISCChargeLOVs(req2);
        oagoutput = CG_WS_OAG.createBMSAccount(req2);
        oagoutput = CG_WS_OAG.calloutBMSCustomerService(req2);
            Test.stopTest();
    }
static testmethod void Method2()
    {
        CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='TSR',ApplicationName__c='TSR',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/technicianservicerequest',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
        insert itgDetails;
       Test.setMock(HttpCalloutMock.class, new CG_TSRMock_Test2());
        Test.startTest();
        CG_TSRReqJSONParser req = new CG_TSRReqJSONParser();
        CG_IP_OAGWrapper req2 = new CG_IP_OAGWrapper();
       req2.serviceName = 'TSR';
        req2.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
         CG_OP_OAGWrapper oagoutput = new CG_OP_OAGWrapper();
        oagoutput = CG_WS_OAG.getAccessToken('');
        //oagoutput = CG_WS_OAG.calloutTSRService(req);
        oagoutput = CG_WS_OAG.calloutGeneric(req2);
        oagoutput = CG_WS_OAG.getMISCChargeLOVs(req2);
        oagoutput = CG_WS_OAG.createBMSAccount(req2);
         oagoutput = CG_WS_OAG.calloutBMSCustomerService(req2);
            Test.stopTest();
    }
    static testmethod void Method3()
    {
        //CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='TSR',ApplicationName__c='TSR',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/technicianservicerequest',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
        //insert itgDetails;
       //Test.setMock(HttpCalloutMock.class, new CG_TSRMock_Test2());
        Test.startTest();
        CG_TSRReqJSONParser req = new CG_TSRReqJSONParser();
        CG_IP_OAGWrapper req2 = new CG_IP_OAGWrapper();
       //req2.serviceName = 'TSR';
        //req2.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
         CG_OP_OAGWrapper oagoutput = new CG_OP_OAGWrapper();
        oagoutput = CG_WS_OAG.getAccessToken('');
        //oagoutput = CG_WS_OAG.calloutTSRService(req);
        oagoutput = CG_WS_OAG.calloutGeneric(req2);
        oagoutput = CG_WS_OAG.getMISCChargeLOVs(req2);
        oagoutput = CG_WS_OAG.createBMSAccount(req2);
         oagoutput = CG_WS_OAG.calloutBMSCustomerService(req2);
            Test.stopTest();
    }
    static testmethod void Method4()
    {
        //CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='TSR',ApplicationName__c='TSR',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/technicianservicerequest',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
        //insert itgDetails;
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
       Test.setMock(HttpCalloutMock.class, new CG_CampaignMock_Test());
        Test.startTest();
        CSS_Integration_Details__c conDetails = new CSS_Integration_Details__c();
        conDetails.Name = 'GetCampaign';
        conDetails.AuthEnv__c = 'OAGOAUTH';
        conDetails.ApplicationName__c = 'GetCampaign';
        conDetails.End_Point__c = 'https://services-stg.cummins.com/css/getcampaigndetails';
        conDetails.Method_Type__c = 'POST';
        conDetails.Timeout__c = 2.0;
        insert conDetails;
        
        CG_TSRReqJSONParser req = new CG_TSRReqJSONParser();
        CG_IP_OAGWrapper req2 = new CG_IP_OAGWrapper();
        req2.servicename= 'GetCampaign';
        
        req2.jsonReqBody='{"Header":{"Target":"CSSWarranty","Sender":{"ServiceName":"GetCampaign","SenderID":"CSS","MessageID":"UniqueID"}},"DataArea":{"Territory":null,"Region":null,"FailureDate":"29-Dec-17","Esn":"33186363"}';
         CG_OP_OAGWrapper oagoutput = new CG_OP_OAGWrapper();
        oagoutput = CG_WS_OAG.getAccessToken('GetCampaign');
        //oagoutput = CG_WS_OAG.calloutTSRService(req);
        oagoutput = CG_WS_OAG.calloutGeneric(req2);
        oagoutput = CG_WS_OAG.getMISCChargeLOVs(req2);
        oagoutput = CG_WS_OAG.createBMSAccount(req2);
         oagoutput = CG_WS_OAG.calloutBMSCustomerService(req2);
            Test.stopTest();
    }
	
    static testmethod void Method5()
    {
        //CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='TSR',ApplicationName__c='TSR',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/technicianservicerequest',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
         CSS_Integration_Details__c  itgDetails = new CSS_Integration_Details__c();
          itgDetails.Name = 'TSR';
        itgDetails.IsActive__c=true;
         itgDetails.AuthEnv__c = 'MuleAuth';
         itgDetails.ApplicationName__c = 'TSR';
         itgDetails.Username__c = 'ndWJnw4WfTtDRszdxkg4kL9IBfp9AbGjyLJzTsd3HiRCAtU7fxpHLIW/VP9wsu3xr/iaJ8ENrwycU0LRe7qPpQ==';
         itgDetails.End_Point__c = 'https://api-ue-devnf2-aw-ex.cummins.com/cmi-services/technician/servicerequest';
        itgDetails.Key__c='al1ufLm+eGhMQGBP8LNDxP5pPZpbHDAAxeqrz3m3jVc=';
         itgDetails.Method_Type__c = 'POST';
        itgDetails.Passcode__c='6GLMcxFesBuQ7drSJilxiFA1IpFhvJ8f8i1DPR+pMwOm+yoNtl9/Gt0sI3hCVkedHrJU/Vc8b0PM0jJi5mnSnA==';
         itgDetails.Timeout__c = 2.0;
   
        insert itgDetails;
      
         Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        Test.setMock(HttpCalloutMock.class, new CG_TSRMock_Test());
       
        Test.startTest();
        CG_TSRReqJSONParser req = new CG_TSRReqJSONParser();
        CG_IP_OAGWrapper req2 = new CG_IP_OAGWrapper();
        req2.serviceName = 'TSR';
        req2.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CG_OP_OAGWrapper oagoutput = new CG_OP_OAGWrapper();
        oagoutput = CG_WS_OAG.calloutTSRService(req);
            Test.stopTest();
    }
	
    static testmethod void Method6()
    {
        //CSS_Integration_Details__C itgDetails = new CSS_Integration_Details__c(Name='TSR',ApplicationName__c='TSR',AuthEnv__c='OAGDev',End_Point__c='https://services-dev.cummins.com/css/technicianservicerequest',IsActive__c=true,Key__c='b0QfgPgFJRwt0xwYgr97QE2cfWVuIa1UR96ot+uKp4M=',Method_Type__c='POST',Passcode__c='K6FYOp/RdbTZ1NixD44NYHuX0m9cpk/VCucdeUVPNEY=',Timeout__c=120);
        CSS_Integration_Details__c  itgDetails = new CSS_Integration_Details__c();
        itgDetails.Name = 'TSR';
        itgDetails.AuthEnv__c = 'OAGDev';
        itgDetails.ApplicationName__c = 'TSR';
        itgDetails.Username__c = 'HfL6S926+ZPvI5xOyy4VEZnCNhVtWWFyWx8tnH9xgqE=';
        itgDetails.End_Point__c = 'https://services-dev.cummins.com/css/technicianservicerequest';
        itgDetails.Method_Type__c = 'POST';
        itgDetails.Timeout__c = 2.0;
        
        insert itgDetails;
        
        Test.setMock(HttpCalloutMock.class, new CSS_MockHttpResponseGenerator()); 
        Test.setMock(HttpCalloutMock.class, new CG_TSRMock_Test());
        
        Test.startTest();
        CG_OP_OAGWrapper req = new CG_OP_OAGWrapper();
        req = CG_WS_OAG.getAccessToken(null);
        Test.stopTest();
    }
}