/**************************************************************************************
Name:  Iam_ExistingSubscriptionQueueable_Test
Copyright © 2019  Cummins
**************************************************************************************
Purpose: Test class for Iam_ExistingSubscriptionQueueable
**************************************************************************************
History
--------------------------------------------------------------------------------------
VERSION         AUTHOR            DATE              DETAIL                                
1.0      Karthik Golakaram      10/12/2019      INITIAL DEVELOPMENT 
1.1      Shubhangi Sardar       09/23/2021      Assigned Value from Label to IAM_Subscription_Count__c
**************************************************************************************
**************************************************************************************/
@isTest
public class Iam_ExistingSubscriptionQueueable_Test {

     /* Create QSOL Bundle Subdcription - No Existing Account Access Feature */
    static testmethod void createQSOLBundleSubTest1() {
        Account acc = IAM_TestData.createAccount();
        Test.startTest();
        Test.stopTest();
    }
    
}