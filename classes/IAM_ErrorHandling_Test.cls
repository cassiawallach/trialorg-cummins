/*Added Comment*/
@isTest
public class IAM_ErrorHandling_Test {
    
    static testMethod void testCase(){
        Test.StartTest();
        IAM_ErrorHandling.IAMerrorCapture('Test','Test','Test');
        IAM_ErrorHandling.IAMerrorCapture('Test','Test','Test','Test');
        Test.stopTest();
    }
}