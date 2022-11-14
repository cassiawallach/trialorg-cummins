@istest
private class CG_IP_OAGWrapper_Test {
    static TestMethod void testOAGWrapper() {
        CG_IP_OAGWrapper CGTSR = new CG_IP_OAGWrapper();
        Test.startTest();
       	CGTSR.jsonReqBody = '{"Header":{"Target":{"TargetID":"TSR"},"Sender":{"ServiceName":"UpsertTSR","SenderID":"GUIDANZ"}},"DataArea":{"UOM":"","TechID":null,"Symptom":"559","SupportLevel":"Cummins CARE Level 1","Status":"Open","SRNumber":"","SPCode":"21933","ShopWO":"","RepeatVisit":"N","PSN":"79464646","MileageValue":"","GeneralSymptoms":"test v","FaultCodeStatus":null,"FaultCode":null,"FailureDate":"11/7/2017","EscalationText":"","EscalationGroup":"HMLD","CustomerName":"test","CSSJobID":"CSS-00070849","ContactPhoneNumber":"","ContactLastName":"Anirudh","ContactFirstName":"Pesari","ContactEmail":"pesari.anirudhcummins.com","ComplaintCode":"101","AttachmentURL":""}}';
        CGTSR.methodType = '';
        CGTSR.timeOut = 1;
		CGTSR.serviceName = 'Test'      ;
        Test.stopTest();
    }
}