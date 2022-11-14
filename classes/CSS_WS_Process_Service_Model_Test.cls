@istest
class CSS_WS_Process_Service_Model_Test {

    static testmethod void testProcessServiceModel() {               
        Test.startTest();   
        Test.setMock(HttpCalloutMock.class, new CSS_WS_WebServicesMock());
        // Schedule the test job
        String jobId = System.schedule(
            'CSS_WS_Process_Service_Model_Test',
            CSS_WS_Process_Service_Model.CRON_EXP,
            new CSS_WS_Process_Service_Model()
        );
        Test.stopTest();
    }
}