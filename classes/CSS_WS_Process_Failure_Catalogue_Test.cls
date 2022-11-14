@istest
class CSS_WS_Process_Failure_Catalogue_Test {

    static testmethod void testProcessFailureCatalogue() {               
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        // Schedule the test job
        String jobId = System.schedule(
            'CSS_WS_Process_Failure_Catalogue_Test',
            CSS_WS_Process_Failure_Catalogue.CRON_EXP,
            new CSS_WS_Process_Failure_Catalogue()
        );
        Test.stopTest();
    }
}