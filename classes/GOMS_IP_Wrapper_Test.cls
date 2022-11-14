/************************************************************
Name:  GOMS_IP_Wrapper_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for GOMS_IP_Wrapper class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Rupesh Ranjan     15/06/2020        INITIAL DEVELOPMENT          
*****************************************************/
@isTest
    private class GOMS_IP_Wrapper_Test{
    
    private static testMethod void test() {
    GOMS_IP_Wrapper.InvoiceHeaders wrapper= new GOMS_IP_Wrapper.InvoiceHeaders();
       wrapper.transactionID = '123';
       wrapper.invoiceCode = '200';
       wrapper.createdBy = 'test';
       wrapper.updatedBy = 'test1';
       wrapper.createDate = '15 june';
       wrapper.recordDate  = '15 june';
       GOMS_IP_Wrapper.InvoiceLines wrapper1= new GOMS_IP_Wrapper.InvoiceLines();
       wrapper1.transactionID = '123';
       wrapper1.shipToAbbreviation = 'test';
       wrapper1.transactionLineNumber = 1234;
       wrapper1.invoiceQuantity = 2;
       wrapper1.unitPrice = 15;
       wrapper1.lineDescription = 'abc';
       wrapper1.financeBusinessCode = '12345';
       wrapper1.financeResponseCode = '400';
       wrapper1.financeSubBusinessCode = '200';
       wrapper1.createdBy = 'test1';
       wrapper1.updatedBy = 'test123';
       wrapper1.createDate = '15 june';
       wrapper1.recordDate  = '15 june';
       GOMS_IP_Wrapper.InvoiceHeaderNotes wrapper2= new GOMS_IP_Wrapper.InvoiceHeaderNotes();
       wrapper2.transactionID = '123';
       wrapper2.shipToAbbreviation = 'test';
       wrapper2.transactionLineNumber = 1234;
       wrapper2.noteNumber = 2;
       wrapper2.noteText = 'xyz';
       wrapper2.createdBu = 'test';
       wrapper2.updatedBy = 'test1';
       wrapper2.createDate = '15 june';
       wrapper2.recordDate = '15 june';
       GOMS_IP_Wrapper.InvoiceLineNotes  wrapper3= new GOMS_IP_Wrapper.InvoiceLineNotes ();
       wrapper3.transactionID = '123';
       wrapper3.shipToAbbreviation = 'test';
       wrapper3.noteNumber = 2;
       wrapper3.noteText = 'xyz';
      /* wrapper3.createdBy = 'test';
       wrapper3.updatedBy = 'test1';
       wrapper3.createDate = '15 june';
       wrapper3.recordDate = '15 june';*/
       GOMS_IP_Wrapper.Sender wrapper4= new GOMS_IP_Wrapper.Sender();
       wrapper4.ServiceName  = 'test';
       wrapper4.SenderID = '123';
       GOMS_IP_Wrapper.Target wrapper5= new GOMS_IP_Wrapper.Target ();
       wrapper5.TargetID = '123';
       Test.startTest();
    GOMS_IP_Wrapper objWarp = new GOMS_IP_Wrapper();
    Test.stopTest();
    System.assertEquals(null, objWarp.Header);
    System.assertEquals(null, objWarp.DataArea);
    system.debug('test');
       
       
    }
    
  
  
  }