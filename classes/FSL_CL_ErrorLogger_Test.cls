@isTest
public class FSL_CL_ErrorLogger_Test {
    @isTest static void test1() {
        FSL_CL_ErrorLogger el = new FSL_CL_ErrorLogger();
        FSL_CL_ErrorLogger.insertApplicationErrorLog(userInfo.getUserId(), 'className','stackTraceString', 'errMsg', 1, 'methodName', 'errRecId');
        FSL_CL_ErrorLogger.insertIntegrationErrorLog(userInfo.getUserId(), 'request', 'response', 'serviceName', 'status', 'serviceVersion', 'toolId', 'senderId');
    }
}