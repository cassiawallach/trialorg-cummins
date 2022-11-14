/*----------------------------------------------------------------------------------------
Name:CSS_Jobclosure_Email_Test
Purpose: 70322: Test Class for CSS_Jobclosure_Email
Author: Sai Krishna 10/13/2016; V1
------------------------------------------------------------------------------------------*/
@isTest(SeeAllData=true)
private class CSS_Jobclosure_Email_Test {
    public  Id sJobId='a052C000000J30S';
    static testmethod void testSolMethod(){
        Test.startTest();
        CSS_Jobclosure_Email tmpJob = new CSS_Jobclosure_Email();
        tmpJob.sJobId = 'a052C000000J30S';		       
        tmpJob.getSolutions();
        Test.stopTest();             
    }
    static testmethod void testPartCompMethod(){
        Test.startTest();
        CSS_Jobclosure_Email tmpJob = new CSS_Jobclosure_Email();
        tmpJob.sJobId = 'a052C000000J30S';
        tmpJob.getPartsComp();
        Test.stopTest();
    }
}