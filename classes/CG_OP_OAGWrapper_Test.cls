@istest
private class CG_OP_OAGWrapper_Test {
    static TestMethod void testOAGWrapper() {
        CG_OP_OAGWrapper CGTSR = new CG_OP_OAGWrapper();
        Test.startTest();
        CGTSR.accessToken = '';
        CGTSR.response = null;
        CGTSR.request = null;
       	CGTSR.requestBody = '';
        CGTSR.methodNameSLLayer = '';
        CGTSR.totalAuthCallTime = 1L;
        CGTSR.totalServiceCallTime = 1L;
        CGTSR.methodStarted = '';
		CGTSR.serviceName = 'Test'      ;
        CGTSR.endPoint = '';
        CGTSR.exceptionFlag = false;
        CGTSR.errorMessage = '';
        CGTSR.exceptionMessage = '';
        CGTSR.appName = '';
       
        Test.stopTest();
    }
    //this comments use for Deployment  and Add missing component
}