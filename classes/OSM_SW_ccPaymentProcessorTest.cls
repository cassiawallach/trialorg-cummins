@isTest
public class OSM_SW_ccPaymentProcessorTest {


static testMethod void OSM_SW_ccPaymentProcessorTest(){
      TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '123456-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '130129-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
       
        
        System.debug('transecRes: '+transecRes);
        System.Runas(transecRes.objSetupDate.loggedInUser){
            test.starttest();
             Map<String,Object> cartItemMap=new Map<String,object>{ccrz.cc_hk_Payment.PARAM_SUCCESS => false};
             //cartItemMap.put(ccrz.cc_hk_Payment.PARAM_PAYMENT_CTX,transecRes.invoice.id);
             //cartItemMap.put(ccrz.cc_hk_Payment.PARAM_PAYMENT_CTX,'co');
             cartItemMap.put(ccrz.cc_hk_Payment.PARAM_PAYMENT_CTX,'inv');
             
             OSM_SW_ccPaymentProcessor cls = new OSM_SW_ccPaymentProcessor();
             Map<String,Object> mapObjClass = cls.postProcess(cartItemMap);
             
             cartItemMap.put('invoiceId',transecRes.invoice.id);
                         
             Decimal amount=transecRes.invoice.ccrz__OriginalAmount__c;
             Map<String,Object> amountMap=new Map<String,object>();
             amountMap.put('amount',amountMap);
             
             //cartItemMap.put('invoicePay',amountMap);
             
             Map<String,Object> mapObjClass0 = cls.postProcess(cartItemMap);
             
             cls.testNumber = 'test1';
             Map<String,Object> mapObjClass1 = cls.postProcess(cartItemMap);
             
             cls.testNumber = 'test2';
             Map<String,Object> mapObjClass2 = cls.postProcess(cartItemMap);
             
             cls.testNumber = 'test4';
             Map<String,Object> mapObjClass3 = cls.postProcess(cartItemMap);
             
             cls.testNumber = 'test3';
             Map<String,Object> mapObjClass4 = cls.postProcess(cartItemMap);
             
             cls.testNumber = 'test5';
             Map<String,Object> mapObjClass5 = cls.postProcess(cartItemMap);
             
            //cls.createWishListItems();
            test.stoptest();
        }    
            
    }
    static testMethod void OSM_SW_ccPaymentProcessorElseBlockTest(){
      TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '123456-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '130129-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
       
        
        System.debug('transecRes: '+transecRes);
        System.Runas(transecRes.objSetupDate.loggedInUser){
            test.starttest();
             Map<String,Object> cartItemMap=new Map<String,object>{ccrz.cc_hk_Payment.PARAM_SUCCESS => true};
             //cartItemMap.put(ccrz.cc_hk_Payment.PARAM_PAYMENT_CTX,transecRes.invoice.id);
             cartItemMap.put(ccrz.cc_hk_Payment.PARAM_PAYMENT_CTX,'co');
             //cartItemMap.put(ccrz.cc_hk_Payment.PARAM_TRANSACTION_PROCESSED_DATA,ccrz.cc_hk_Payment.TransactionPaymentParams);
             //cartItemMap.put('invoiceId',transecRes.invoice.id);
                         
             Decimal amount=transecRes.invoice.ccrz__OriginalAmount__c;
             Map<String,Object> amountMap=new Map<String,object>();
             amountMap.put('amount',amountMap);
             
             //cartItemMap.put('invoicePay',amountMap);

             
             OSM_SW_ccPaymentProcessor cls = new OSM_SW_ccPaymentProcessor();
             Map<String,Object> mapObjClass = cls.postProcess(cartItemMap);
            //cls.createWishListItems();
            test.stoptest();
        }    
            
    }

}