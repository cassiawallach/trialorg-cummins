@istest
public class FSL_DeleteSuccessErrorLogs_Test {
    
    public static testMethod void DeleteSucessLogs()
    {
        FSL_Integration_Error_Log__c objIntegrationErrorLog = new FSL_Integration_Error_Log__c();
        //objIntegrationErrorLog.Request__c = 'tet';
        objIntegrationErrorLog.Response__c = 'test';
        objIntegrationErrorLog.Service_Name__c = 'testing';
        objIntegrationErrorLog.Service_Version__c = 'test';
        objIntegrationErrorLog.Status__c = 'Success';
        insert objIntegrationErrorLog;
        test.starttest();
        FSL_DeleteErrorlogscheduledBatchable  fslDeleteErrorlog = new FSL_DeleteErrorlogscheduledBatchable();
         String sch = '0 0 23 * * ?';
        System.schedule('check',sch ,fslDeleteErrorlog);
        test.stoptest();
    }
}