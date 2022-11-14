/************************************************************
Name:  OSM_GOMS_Cancellation_Batch_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_GOMS_Cancellation_Batch class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -    Rupesh Ranjan     15/06/2020        INITIAL DEVELOPMENT    
2.0 -    Subbu K           07/28/2021        MAR-1861      
*****************************************************/
@isTest
public class OSM_GOMS_Cancellation_Batch_Test{
  static testMethod void OSM_GOMS_Cancellation_Batch_Test_BatchMethod(){
  ccrz__E_Invoice__c  invc = new ccrz__E_Invoice__c ();
        invc.Is_GOMS_Integration_Processed__c = true;
        invc.Is_GOMS_Intercompany_Invoice__c= true;
        invc.GOMS_Invoice_ID__c = '123';
        insert invc;
        //Test.startTest();
        //OSM_GOMS_Cancellation_Batch   batchIns = new OSM_GOMS_Cancellation_Batch  ();
       //database.executeBatch(batchIns);
        //Test.stopTest();
        //Test.startTest();
        OSM_GOMS_Cancellation_Batch batchtest= new OSM_GOMS_Cancellation_Batch();
          List<ccrz__E_Invoice__c > lstInv = [select id,Is_GOMS_Integration_Processed__c,Is_GOMS_Intercompany_Invoice__c,GOMS_Invoice_ID__c from ccrz__E_Invoice__c where id = :invc.id  ];

        Database.QueryLocator ql = batchtest.start(null);
        batchtest.execute(null,lstInv);
        batchtest.Finish(null);
        system.debug('test');
        //Test.stopTest();
        
        Test.startTest();
    GOMS_Integration_BaseClass BaseClass = new  GOMS_Integration_BaseClass();
    
     Test.stopTest();
   
}
}