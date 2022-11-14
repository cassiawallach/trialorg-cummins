/************************************************************
Name:  GOMS_IP_IntegrationRequestWrapper_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for GOMS_IP_IntegrationRequestWrapper class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Rupesh Ranjan     17/06/2020        INITIAL DEVELOPMENT          
*****************************************************/
@isTest
    private class GOMS_IP_IntegrationRequestWrapper_Test{
        private static testMethod void test() {
        Test.startTest();
        GOMS_IP_IntegrationRequestWrapper  objWarp = new GOMS_IP_IntegrationRequestWrapper();
        Test.stopTest();
        System.assertEquals(null, objWarp.jsonReqBody);
        System.assertEquals(null, objWarp.methodType);
        System.assertEquals(null, objWarp.timeOut);
        System.assertEquals(null, objWarp.serviceName);
 
        
        }
    
}