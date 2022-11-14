/*
* Test Class for Apex Controller - FSL_OP_OAGWrapper
* Author - Piyush Rani
*/ 
@isTest
public class FSL_OP_OAGWrapper_Test {
	@isTest
    private static void testFSLOAGWrapper() {
        FSL_OP_OAGWrapper OAGWrapperObj = new FSL_OP_OAGWrapper();
        Test.startTest();
        OAGWrapperObj.accessToken = '';
        OAGWrapperObj.response = null;
        OAGWrapperObj.request = null;
       	OAGWrapperObj.requestBody = '';
        OAGWrapperObj.methodNameSLLayer = '';
        OAGWrapperObj.totalAuthCallTime = 1L;
        OAGWrapperObj.totalServiceCallTime = 1L;
        OAGWrapperObj.methodStarted = '';
		OAGWrapperObj.serviceName = 'TestService'      ;
        OAGWrapperObj.endPoint = '';
        OAGWrapperObj.bmsStatus = 'new';
        OAGWrapperObj.exceptionFlag = false;
        OAGWrapperObj.errorMessage = '';
        OAGWrapperObj.exceptionMessage = '';
        OAGWrapperObj.appName = '';
        Test.stopTest();
    }
}