@isTest
private class IAM_Confirmation_Test{
    
    /* Initialization Test 1 */
    static testmethod void initializeTest1() {       
        PageReference pg = Page.IAM_NewRegistration;        
		Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        app.Back_page__c = 'testpage.com';
        update app;        
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        Test.startTest();
        IAM_Confirmation obj = new IAM_Confirmation();	   	
        System.assertEquals(app.Id, obj.currentRecordId);       
        Test.stopTest();
    }
    
    /* Initialization Test 2 */
    static testmethod void initializeTest2() {       
        PageReference pg = Page.IAM_Reclaim;        
		Test.setCurrentPage(pg);
        App_Mapping__c app = IAM_TestData.getCumpasApp();
        app.Login_Url__c = 'loginpage.com';
        app.Back_page__c = 'testpage.com';
        update app;
        ApexPages.currentPage().getParameters().put('appid',app.Id);
        ApexPages.currentPage().getParameters().put('recalim','true');
        Test.startTest();
        IAM_Confirmation obj = new IAM_Confirmation();	   	
        System.assertEquals(true, obj.RecalimMessage);
        PageReference retURL = obj.redirectBackpage();
        System.assertEquals(true, retURL != null);
        App_Mapping__c selectedApp = [SELECT Login_Url__c From App_Mapping__c WHERE Name = 'CUMPAS 2.0'];
        obj.url = selectedApp.Login_Url__c;
        PageReference loginURL = obj.Login();
        System.assertEquals(true, loginURL != null);
        obj.logouturl = 'logouturl.test';
        obj.Id = null;
        obj.SaveandClose();
        obj.logout();
        Test.stopTest();
    }
}