/************************************************************
Name:  OSM_Email_InvoiceForBoltEntry_Ctrl_test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_Email_InvoiceForBoltEntry_Ctrl class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Neha Sharma      21/02/2019     INITIAL DEVELOPMENT          

*************************************************************/

@isTest
global class OSM_Email_InvoiceForBoltEntry_Ctrl_test{
    
    public static testmethod void testMethod1() {
   
    
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
                
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
    
    
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
     
    
            test.StartTest();
                
                OSM_Email_InvoiceForBoltEntry_Ctrl objCal = new OSM_Email_InvoiceForBoltEntry_Ctrl();
                objCal.setInvoiceId(transecRes.invoice.Id);
                
            test.StopTest();
        }
    }
    
    public static testmethod void testMethod2() {
   
    
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
                
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
    
        
        ccrz__E_OrderItem__c ordrItem = new ccrz__E_OrderItem__c();
        ordrItem.Id = transecRes.orderItem.Id;
        ordrItem.Vertex_Tax__c = 5;
        ordrItem.ccrz__DisplayProduct__c = transecRes.objSetupDate.compositeProduct.Id;
        //ordrItem.ccrz__ItemTotal__c = 5;
        update ordrItem;
        
        list<ccrz__E_ProductMedia__c>mlist = new list<ccrz__E_ProductMedia__c>(); 
        ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
        media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.Id ;
        media.ccrz__MediaType__c = 'Product Image Thumbnail';
        mlist.add(media);
        insert mlist;
        
        Attachment objAtch = new Attachment();
        objAtch.Name = 'test';
        objAtch.ParentId = mlist[0].Id;
        objAtch.Body = Blob.valueof('');
        insert objAtch;
    
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
     
    
            test.StartTest();
                
                OSM_Email_InvoiceForBoltEntry_Ctrl objCal = new OSM_Email_InvoiceForBoltEntry_Ctrl();
                objCal.setInvoiceId(transecRes.invoice.Id);
                OSM_Email_InvoiceForBoltEntry_Ctrl.OerderLineItemDetail OerderLineItemDetail = new OSM_Email_InvoiceForBoltEntry_Ctrl.OerderLineItemDetail();
                OerderLineItemDetail = objCal.orderLineItem;
                objCal.isSandbox();
                objCal.getOrderNumbers();
                List<ccrz__E_ProductMedia__c> testf = objCal.mediaList;
                Id invoiceId = objCal.invoiceId;
                
            test.StopTest();
        }
    }
    
}