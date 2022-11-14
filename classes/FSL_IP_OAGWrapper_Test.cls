/*
* Test Class for Apex Controller - FSL_IP_OAGWrapper
* Author - Piyush Rani
*/ 
@isTest
public class FSL_IP_OAGWrapper_Test {
	@isTest
    private static void testFSLOAGWrapper() {
        FSL_IP_OAGWrapper OAGWrapperObj = new FSL_IP_OAGWrapper();
        Test.startTest();
        OAGWrapperObj.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        OAGWrapperObj.methodType = '';
        OAGWrapperObj.timeOut = 2;
		OAGWrapperObj.serviceName = 'TestService';
        Test.stopTest();
    }
}