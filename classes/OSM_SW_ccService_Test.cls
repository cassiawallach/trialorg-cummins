/**********************************************/
//Test Class for the class OSM_SW_ccServiceOrder
// Date        Updated By
//2.0      02/03/2021   Sharad Sahu
//3.0      07/22/2021   MAR 1861 Subbu K
//4.0      1/31/2022    Updated Swetha
//updated
/**********************************************/
/**********************************************/
@IsTest(SeeAllData=true)
    public class OSM_SW_ccService_Test 
    {
        static testMethod void testmethod1() 
        {
            
            Account acc = IAM_TestData.createAccount();
        	Contact con = IAM_TestData.createContact(acc.Id);
        
        	TestProductSetupReq testReq = new TestProductSetupReq();
            testReq.permissionSetName = 'OSM_Support_Admin';
            testReq.accountGroupName = 'TestingAccountGroup';
            testReq.accountName = acc.Name;
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

        System.debug('transecRes: '+transecRes);
            
            
            
            
            Map<String, Object> inputMap = new Map<String, Object>();
            
            inputMap.put('version: ','7');
            
            
            List<Id> lstAccId = new List<Id>();
            
            lstAccId.add(transecRes.objSetupDate.account.Id);
            
            inputMap.put('addressIdList: ',lstAccId);
            
            List<Id> lstCartId = new List<Id>();
            
            lstCartId.add(transecRes.cart.Id);
            
            inputMap.put('cartIdList: ',lstCartId);
            
            List<Id> lstInvoiceId = new List<Id>();
            
            lstInvoiceId.add(transecRes.invoice.Id);
            
            inputMap.put('invoiceIdList: ',lstInvoiceId);
            
            List<Id> lstOrderId = new List<Id>();
            
            lstOrderId.add(transecRes.order.Id);
            
            inputMap.put('orderIdList: ',lstOrderId);
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            objRemotCtx.currentPageName='ccrz__MyAccount';
            

            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            string orderOperation = 'OrderCancel';
        
            //System.debug(ccrz.cc_CallContext.currAccountId);//LL-21 & LL-22 - Added Number_of_Bundles__c
            
            Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new OMS_SubmitOrder_Mock());
            
            OSM_SW_ccServiceAddress ss=new OSM_SW_ccServiceAddress();
            ss.getFieldsMap(inputMap);
            OSM_SW_ccServiceCart sst=new OSM_SW_ccServiceCart();
            sst.getDirectQueryMap(inputMap);
            
            OSM_SW_ccServiceInvoice ServiceInvoice=new OSM_SW_ccServiceInvoice();
            ServiceInvoice.getFieldsMap(inputMap);
            
            OSM_SW_ccServiceOrder objOrderService = new OSM_SW_ccServiceOrder();
            // objOrderService.getFilterMap(inputMap);
            objOrderService.getDirectQueryMap(inputMap);
            objOrderService.getFieldsMap(inputMap);
            OSM_SW_ccServiceOrder.orderOperation = 'OrderCancel';
            
            OSM_SW_ccServiceCartItem objorderitemService = new OSM_SW_ccServiceCartItem ();
            objorderitemService.getFieldsMap(inputMap);
              
            OSM_SW_ccServiceProduct productService = new OSM_SW_ccServiceProduct();
            productService.getFieldsMap(inputMap);
            
            OSM_SW_ccServiceSubscription subscService = new OSM_SW_ccServiceSubscription();
            subscService.getFieldsMap(inputMap);
            
           // OSM_SW_ccServiceOrder.orderOperation = 'OrderCancel';
           // objOrderService.getFilterMap(inputMap);
           
           OSM_SW_ccServiceOrderItem item = new OSM_SW_ccServiceOrderItem();
           item.getFieldsMap(inputMap);
           item.getSubQueryMap(inputMap);
           
           
           ccrz.cc_RemoteActionContext objRemotCtx1 = new ccrz.cc_RemoteActionContext();
            objRemotCtx1.storefront='SoftwareStore';
            objRemotCtx1.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx1.portalUserId=transecRes.objSetupDate.objUserID;
            objRemotCtx1.currentPageName='ccrz__MyAccount';
            

            ccrz.cc_CallContext.initRemoteContext(objRemotCtx1);
            
            
            OSM_SW_ccServiceOrder.orderOperation = 'OrderSubmit';
            objOrderService.getFilterMap(inputMap);
            
            Test.stopTest(); 
            
            
            
        }
    }