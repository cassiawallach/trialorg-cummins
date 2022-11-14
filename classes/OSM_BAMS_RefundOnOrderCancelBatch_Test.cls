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
 3.4        Ashish          08/11/2021      Test Class Fixes
 3.4        Ashish          08/11/2021      Test Class Fixes
**/
@isTest
public class OSM_BAMS_RefundOnOrderCancelBatch_Test {
   // public static User loggedInUser=OSM_TestDataCreationUtility.getPortalUser();
   
    static testMethod void refundOnOrderCancelBatch_Test(){
    //Creating test data transaction 1 
  /*  TestProductSetupReq testProductSetupReq1=OSM_TestDataCreationUtility.populatedTestProductSetupReq();
    TestProductSetupRes testProductSetupRes1=OSM_TestDataCreationUtility.createProductSetUp(testProductSetupReq1);
    TestCompletedTransactionSetUpRes testCompletedTransactionSetUpRes1=OSM_TestDataCreationUtility.createCompletedTransactionFlowTestData(testProductSetupRes1,20000.0, 10.0);
    ccrz__E_Order__c order1=testCompletedTransactionSetUpRes1.order;*/
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
        //List<String> orderIdsList2=new List<String>();
    
        //updating order fields as per batch class requirement
        order1.Refund_status__c='Pending Refund';
        order1.ccrz__OrderStatus__c='Cancelled';
        update order1;
    

        //creating transactionPayment record
        ccrz__E_TransactionPayment__c transactionPayment1=transecRes.transactionPayment;
        transactionPayment1.ccrz__AccountType__c='cc';
        update transactionPayment1;
        
        //adding orders into list
        orderIdsList1.add(order1.Id);
        orderList.add(order1);//LL39
    
        List<ccrz__E_OrderItem__c> list_OI = new List<ccrz__E_OrderItem__c>();
        for(ccrz__E_OrderItem__c oi1 : [SELECT Id,Is_Refund_Initiated__c,ccrz__OrderItemStatus__c, Vertex_Tax__c FROM ccrz__E_OrderItem__c]){
            oi1.Is_Refund_Initiated__c = false;
            oi1.ccrz__OrderItemStatus__c ='Order Submitted';
            oi1.Vertex_Tax__c = 11;
            list_OI.add(oi1);
        }
        if(list_OI.size() > 0){
            update list_OI;
        }
         //calling batch class 
            //Test.StartTest();
            OSM_BAMS_RefundOnOrderCancelBatch obj1 = new OSM_BAMS_RefundOnOrderCancelBatch(orderIdsList1);
            OSM_BAMS_RefundOnOrderCancelBatch obj2 = new OSM_BAMS_RefundOnOrderCancelBatch();
             OSM_BAMS_RefundOnOrderCancelBatch obj3 = new OSM_BAMS_RefundOnOrderCancelBatch('Select id, Refund_status__c,BAMS_Merchant_Reference_Number__c,ccrz__CurrencyISOCode__c,Order_Cancellation_Date__c from ccrz__E_Order__c where Refund_status__c=\'Pending Refund\' and OrderProcessedforFSD__c = false and Is_OMS_Revoke_and_Cancel_Not_Done_Count__c = 0 and  ccrz__OrderStatus__c=\'Cancelled\' and id in :orderIdLst');
            DataBase.executeBatch(obj1); 
            
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
             
             OSM_BAMS_BL_Operations.processRefundForCancelledOrders(orderList);
             OSM_BAMS_BL_Operations.testCase1= true;
             OSM_BAMS_BL_Operations.processRefundForCancelledOrders(orderList);
             
             //ccrz__E_Invoice__c  objInv = new ccrz__E_Invoice__c ();
             //objInv.Id = transecRes.invoice.Id;
             
             //delete objInv;
             
             OSM_BAMS_BL_Operations.testCase1= true;
             OSM_BAMS_BL_Operations.processRefundForCancelledOrders(orderList);
             
             
          }
        
    }
 
    
}