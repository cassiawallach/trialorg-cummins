/*************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          11/08/2021      Test Class Fixes
 2.0        Ashish          13/10/2021      Test Class Fixes
 3.0        Ashish          19/10/2021      Test Class Fixes
 3.1        Ashish          02/11/2021      Test Class Fixes
 3.2        Ashish          02/11/2021      Test Class Fixes
 3.3        Ashish          02/11/2021      Test Class Fixes
 3.3        Ashish          02/11/2021      Test Class Fixes
 3.4        Ashish          08/11/2021      Test Class Fixes
 3.4        Ashish          08/11/2021      Test Class Fixes
**/
@isTest
public class OSM_BAMS_RefundOrderItemCancelBatch_Test {
   
    static testMethod void refundOnOrderItemCancelBatch_Test(){
   
    User usr=OSM_TestDataCreationUtility.getPortalUser();
   

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
         System.Runas(transecRes.objSetupDate.loggedInUser){
         ccrz__E_Order__c order1=transecRes.order;
         List<String> orderIdsList1=new List<String>();
         List<ccrz__E_Order__c> orderList=new List<ccrz__E_Order__c>();
         List<ccrz__E_OrderItem__c> orderItemList=new List<ccrz__E_OrderItem__c>();
        //List<String> orderIdsList2=new List<String>();
    
        //updating order fields as per batch class requirement
        order1.Refund_status__c='Pending Refund';
        order1.ccrz__OrderStatus__c='Order Submitted';
        order1.OrderProcessedforFSD__c =false;
        update order1;
    

        //creating transactionPayment record
        ccrz__E_TransactionPayment__c transactionPayment1=transecRes.transactionPayment;
        transactionPayment1.ccrz__AccountType__c='cc';
        update transactionPayment1;
        
        //adding orders into list
        
        orderList.add(order1);
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        //pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        insert pro;
        
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = order1.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        oi1.ccrz__OrderItemStatus__c ='Cancelled';
        oi1.Vertex_Tax__c=11;
        insert oi1;
        orderItemList.add(oi1);
        orderIdsList1.add(oi1.Id);
         //calling batch class 
            //Test.StartTest();
            
            OSM_BAMS_RefundOnOrderItemCancelBatch refundOrderItem= new OSM_BAMS_RefundOnOrderItemCancelBatch(orderIdsList1);
            //OSM_BAMS_RefundOnOrderItemCancelBatch refundOrderItem1= new OSM_BAMS_RefundOnOrderItemCancelBatch();
            DataBase.executeBatch(refundOrderItem);
            //Test.stopTest();
        
        //Calling processRefundForFailedOrderCreation method
             OSM_BAMS_BL_Operations.processRefundForFailedOrderCreation(transactionPayment1.id);
             
             transactionPayment1.ccrz__CCOrder__c=null;
             update transactionPayment1;
             OSM_BAMS_BL_Operations.processRefundForFailedOrderCreation(transactionPayment1.id);
             
             //OSM_BAMS_BL_Operations.processRefundForCancelledOrders(orderList);
             
             //List<ccrz__E_Invoice__c> lstInvoice = [SELECT id, ccrz__CurrencyCode__c,                                                    ccrz__OriginalAmount__c, ccrz__CCOrder__c FROM ccrz__E_Invoice__c WHERE ccrz__CCOrder__c =:orderList[0].ID];

             //delete lstInvoice;
             
             OSM_Orders_In_Invoice__c objJun = new OSM_Orders_In_Invoice__c();
             objJun.CC_Order__c = transecRes.order.Id;
             objJun.CC_Invoice__c = transecRes.invoice.Id;
             insert objJun;
             
             transactionPayment1.ccrz__CCOrder__c=transecRes.order.Id;
             update transactionPayment1;
             
             OSM_BAMS_BL_Operations.processRefundForCancelledOrderItems(orderItemList);
             
             OSM_BAMS_BL_Operations.testCase1= true;
             
             OSM_BAMS_BL_Operations.processRefundForCancelledOrderItems(orderItemList);
             //ccrz__E_Invoice__c  objInv = new ccrz__E_Invoice__c ();
             //objInv.Id = transecRes.invoice.Id;
             
             //delete objInv;
             
             OSM_BAMS_BL_Operations.testCase1= true;
             OSM_BAMS_BL_Operations.processRefundForCancelledOrders(orderList);
             
             OSM_BAMS_BL_Operations.testCase1= False;
             OSM_BAMS_BL_Operations.processRefundForCancelledOrderItems(orderItemList);
             
             OSM_BAMS_BL_Operations.testCase1= False;
             OSM_BAMS_BL_Operations.processRefundForCancelledOrders(orderList);
             
          }
        
    }
     
}