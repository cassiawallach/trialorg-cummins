/************************************************************
Name:  GOMS_OP_Wrapper_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for GOMS_OP_Wrapper class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Rupesh Ranjan     15/06/2020        INITIAL DEVELOPMENT          
*****************************************************/

    @isTest
    private class GOMS_OP_Wrapper_Test{
    
    private static testMethod void test() {
    Test.startTest();
    GOMS_OP_Wrapper objWarp = new GOMS_OP_Wrapper();
    Test.stopTest();
       GOMS_OP_Wrapper.Header wrapper= new GOMS_OP_Wrapper.Header();
       wrapper.ReturnCodeDescription = 'Test Wrapper';
       wrapper.Status = '200';
       System.assertEquals(null, objWarp.accessToken);
       System.assertEquals(null, objWarp.MessageIdentifier );
       System.assertEquals(null, objWarp.ReturnCode );
       System.assertEquals(null, objWarp.ReturnCodeDescription );
       System.assertEquals(null, objWarp.Status);
       System.assertEquals(null, objWarp.MessageType);
       System.assertEquals(null, objWarp.Request);
       System.assertEquals(null, objWarp.Response);
       System.assertEquals(null, objWarp.totalAuthCallTime);
       System.assertEquals(null, objWarp.totalServiceCallTime);
       System.assertEquals(null, objWarp.errorMessage);
       System.assertEquals(null, objWarp.exceptionFlag);
       System.assertEquals(null, objWarp.exceptionMessage);
       
    
    }
    }