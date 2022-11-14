//Test by Pooja
//Test class for the class OSM_Email_ProductLine_Ctrl
// Updated by Singaiah for MAR-1565
// Update by Subbu 22nd July 2021 for MAR-1861
//Update by Sangeeta 10th Jan 2022
//Test class
//update
//Update by Swetha 21st Feb 2022
// Update by Subbu new changes
// Update by Subbu
// updated by swetha
// updated by navas again
@isTest(seeAllData=false)
private class OSM_Email_ProductLine_Ctrl_Test {
  
    //Updated for User Story - 883
    @testSetup
    static void testData() {

        // Create Account Group
        ccrz__E_AccountGroup__c accGrp = TestingUtils.inertAccountGroup();

        // Create Portal Account Under Group
        Account portalAccount2 = TestingUtils.inertPortalAccountUnderGroup( accGrp.Id );

        // CReate Contact
        Contact contact1 = TestingUtils.inertContact( portalAccount2.Id ); 

        // Create Product
        ccrz__E_Product__c prod = TestingUtils.insertProduct();
        
        // Create Orders
        List<ccrz__E_Order__c> ordList = TestingUtils.insertOrderList();
        
        // Create Order Items
        List<ccrz__E_OrderItem__c> ordItemLst = TestingUtils.insertOrderItemList( ordList, prod );
        
        // Create Order Items
        List<ccrz__E_OrderItem__c> childOrdItemLst = TestingUtils.insertChildOrderItemList( ordList, prod, ordItemLst[0].id );
         
        // Create Subscriptions
        List<ccrz__E_Subscription__c> subList = TestingUtils.insertSubscriptionList( ordItemLst, prod );
        
        // Create Request Quotes 
        List<ccrz__E_RequestForQuote__c> quoteList = TestingUtils.insertRequestQuote( prod );

        // Create Product Media
        List<ccrz__E_ProductMedia__c> mlist = TestingUtils.insertProductMediaList( quoteList );
    
        // Create Sub Prod Term
        ccrz__E_SubProdTerm__c spt = TestingUtils.insertSubProdTerm( prod );
        
        // Create Invoice
        List<ccrz__E_Invoice__c> invList = TestingUtils.insertInvoiceList( contact1 );
        
        // Create Invoice Items
        List<ccrz__E_InvoiceItem__c> invitemList = TestingUtils.insertInvoiceItemList( invList, ordList[0].id, ordItemLst[0].id );
        
        // Create Order Item License
        OSM_Order_Item_License__c ParentActivationKey = TestingUtils.insertOILParentActivationKey( ordItemLst[0].Id );
        
        // Create Order Item License
        OSM_Order_Item_License__c orderItemLicense2 = TestingUtils.insertOrderItemLicense( ordItemLst[0].Id, ParentActivationKey.Id );
        
        // Integration Log
        OSM_Integration_Log__c objIntLog = TestingUtils.insertIntegrationLog( invList[0].Id);
    }
    
    static testMethod void OSM_Email_ProductLine() {
      
        
        Test.startTest();

        List<ccrz__E_Order__c> ordList = [ SELECT Id FROM ccrz__E_Order__c LIMIT 5];
        List<ccrz__E_OrderItem__c> ordItemLst = [ SELECT Id FROM ccrz__E_OrderItem__c  WHERE ccrz__Order__c =: ordList[0].Id LIMIT 5];
        List<OSM_Integration_Log__c> objIntLogList = [ SELECT Id FROM OSM_Integration_Log__c LIMIT 1];
        List<ccrz__E_Subscription__c> subList = [ SELECT Id FROM ccrz__E_Subscription__c  WHERE ccrz__CCOrderItem__c =: ordItemLst[0].Id LIMIT 5];
        List<ccrz__E_RequestForQuote__c> quoteList = [ SELECT Id FROM ccrz__E_RequestForQuote__c  LIMIT 1];
        List<ccrz__E_Invoice__c> invList = [ SELECT Id FROM ccrz__E_Invoice__c LIMIT 1];



        List<OSM_Email_ProductLine_Ctrl.OerderLineItemDetail> wraplist = new List<OSM_Email_ProductLine_Ctrl.OerderLineItemDetail>();
        OSM_Email_ProductLine_Ctrl.OerderLineItemDetail wrap = new OSM_Email_ProductLine_Ctrl.OerderLineItemDetail();
        wrap.name = 'Connected Advisor'; 
        wrap.uri = 'test11';
        wrap.imageUrl = 'test1';
        wrap.Quantity = 20;
        wrap.shortDec = 'test';
        wrap.Price = 20.0;
        wrap.Total = 10.0;
        wrap.tax= 2;
        wrap.status = 'Requested';
        wrap.freetrial = true;
        wrap.expiredmonthName = 'september';
        wrap.subLength = 'Monthly';
        wrap.billingPeriod = ' yearly';
        wrap.activationKey='key';
        wrap.licenseName='licensename';
        wrap.productGroup='productGroup';
        wrap.FunActivationKey='FunActivationKey';
        wrap.BasicActivationKey='BasicActivationKey';
        wrap.CouponCode='CouponCode';
        wrap.DiscountTotal=0.1;
        wrap.shouldSendEmailtoBranch=true;
        wrap.shouldIncludePrice=true;
        wrap.isDistributorPurchased=true;
        wrap.isOnBehalfOf=true;
        wrap.expiredDate = system.now()+3;
        wraplist.add(wrap);
        
        OSM_Email_ProductLine_Ctrl obj1 = new OSM_Email_ProductLine_Ctrl();
      
        obj1.headQuaterName='Test Head';
        obj1.headQuaterEmail='TestHead@test.com';
        obj1.shouldShowPrice=true;
        obj1.isInSubscription=true;
        obj1.activationKeyErrorMessage=true;
        obj1.mediaList=new list<ccrz__E_ProductMedia__c>();
        obj1.expiredmonthName='Test ';
        obj1.osmIntegrationLog= new OSM_Integration_Log__c();
        obj1.incalSubIds = ordItemLst[0].id;
        obj1.osmIntegerationId = objIntLogList[0].Id;
        obj1.setOrderIds(string.valueof(ordList[0].id));
        Obj1.getOrder();
        obj1.handleOrderSubmitEmail(string.valueof(ordList[0].id));
        obj1.fetchOrderInfo(string.valueof(ordList[0].id));
        obj1.handleCancelOrderEmail(string.valueof(ordList[0].id));
        
        obj1.getOrderSubsList();  
        
        obj1.getIncalSubscriptionList();
        
        ordList[0].ccrz__OrderStatus__c = 'Cancelled';
        update ordList[0];
        obj1.setOrderIds(string.valueof(ordList[0].id));
        
        // Case 1.1
        ordList[0].ccrz__OrderStatus__c = 'Partially Cancelled';
        update ordList[0];
        obj1.setOrderIds(string.valueof(ordList[0].id));
        
        //Updated for User Story - 883
        // Case 2
        System.assert( subList[0].Id != null, 'No Subscription Records!');
        obj1.SubsriptionIds = subList[0].Id;
        obj1.getSubscriptionList();
        
        // Case 3
        System.assert( quoteList[0].Id != null, 'No Quote Request Records!');
        obj1.requestQuoteIds = quoteList[0].Id;
        obj1.getRequestQuoteList();
        
          // Case 4
        System.assert( invList[0].Id != null, 'No Invoice Records!');
        obj1.invoiceIds  = invList[0].Id;
        obj1.getinvoiceItemList();
        Test.stopTest();
    }
    
}