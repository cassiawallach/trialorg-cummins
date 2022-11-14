@isTest
private class IAM_JIT_Partner_ErrorPage_Test{
    
    /* Initialization Test 1 */
    static testmethod void initializeTest1() {       
        PageReference pg = Page.IAM_JIT_Error_Page;        
    Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        app.Back_page__c = 'testpage.com';
        update app;        
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentpage().getPArameters().put('ErrorDetails','Error in the page');
        Test.startTest();
        IAM_JIT_Partner_ErrorPage obj = new IAM_JIT_Partner_ErrorPage();       
        System.assertEquals(app.Id, obj.currentRecordId);       
        Test.stopTest();
    }
    
   
}