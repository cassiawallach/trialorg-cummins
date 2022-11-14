/*************************************************************************************
Name:  IAM_ErrorHandling_Queueable_Test
Copyright © 2022  Cummins
**************************************************************************************
Purpose: Test Class for IAM_ErrorHandling_Queueable
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION       AUTHOR                      DATE               DETAIL                                
1.0      Suresh Rathod Nanavath       22/02/2022        INITIAL DEVELOPMENT
**************************************************************************************
**************************************************************************************/
@isTest
public class IAM_ErrorHandling_Queueable_Test {
    
    @isTest
    public static void testQueueable()
    {
        Test.startTest();
        Id jobId= System.enqueueJob(new IAM_ErrorHandling_Queueable('test','test','test','test','test@test.com'));
        Test.stopTest();
        IAM_Identity_Management_Errors__c errorObj= [select id,IAM_Error_Source__c,IAM_Error_Description__c,IAM_Processed_Data__c,IAM_Class_Name__c from IAM_Identity_Management_Errors__c LIMIT 1];
        System.assertEquals('test', errorObj.IAM_Class_Name__c);

}
}