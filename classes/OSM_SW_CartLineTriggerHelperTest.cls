@IsTest
public class OSM_SW_CartLineTriggerHelperTest{
     static testMethod void setPrimaryitem_Test(){
     TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'SES';
        testReq.compositeProductProductType = 'Bundle';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'SES';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        ccrz__E_Product__c ccCompositeProduct1 = new ccrz__E_Product__c();
       
        ccCompositeProduct1.name = 'testProd1';
        ccCompositeProduct1.ccrz__ProductStatus__c = 'Released';
        ccCompositeProduct1.ccrz__Quantityperunit__c = 1;
        ccCompositeProduct1.ccrz__SKU__c = '1301298-BUS';
        ccCompositeProduct1.ccrz__StartDate__c = System.today().addMonths(-1);
        ccCompositeProduct1.ccrz__EndDate__c = System.today().addMonths(4);
        ccCompositeProduct1.Group_Name__c = 'SES';
        ccCompositeProduct1.ccrz__LongDesc__c = 'Long Description';
        ccCompositeProduct1.ccrz__ProductType__c = 'Bundle';
        ccCompositeProduct1.Product_Class_Code__c = 'SW-Web Access';
        insert ccCompositeProduct1;
		
         
         
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
         
        ccrz__E_CartItem__c testCartItem1 = new ccrz__E_CartItem__c();
            testCartItem1.ccrz__Cart__c = transecRes.cart.id;
            testCartItem1.ccrz__Quantity__c = 100;
            testCartItem1.ccrz__OriginalQuantity__c = 100;
            testCartItem1.ccrz__Product__c =ccCompositeProduct1.id ;
            testCartItem1.ccrz__SubProdTerm__c =transecRes.objSetupDate.subProdTermList[0].id;
            testCartItem1.ccrz__Price__c = 100;
            testCartItem1.ccrz__RecurringPrice__c = 100;
            testCartItem1.ccrz__RecurringPriceSubAmt__c = 100;
            //testCartItem1.ccrz__StoreID__c = storefront;
            testCartItem1.ccrz__OriginalItemPrice__c = 100;
            testCartItem1.ccrz__DisplayProduct__c = ccCompositeProduct1.id;
            testCartItem1.ccrz__ProductType__c = 'Product';
            testCartItem1.ccrz__cartItemType__c = 'Cart';
            testCartItem1.ccrz__SubAmount__c = 100;
            testCartItem1.ccrz__Subscription_Duration__c = 12;
            testCartItem1.ccrz__Subscription_Frequency__c = 4;
            testCartItem1.ccrz__UnitOfMeasure__c = 'cm';
            testCartItem1.ccrz__StoreID__c = 'SoftwareStore';
         	insert testCartItem1;
         
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
        
        System.debug('transecRes: '+transecRes);

        //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
         
        //System.debug(ccrz.cc_CallContext.currAccountId);
      //  List<ccrz__E_CartItem__c> lstCartLineItem =new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> lstCartLineItem=new List<ccrz__E_CartItem__c>();
        lstCartLineItem.add(transecRes.cartItem);
        lstCartLineItem.add(testCartItem1);
        List<Id> lstCartId=new List<Id>();
        lstCartId.add(transecRes.cart.id);
        OSM_SW_CartLineTriggerHelper helper=new OSM_SW_CartLineTriggerHelper();
        Map<Id,ccrz__E_CartItem__c> mapCartLineItem= new Map<Id,ccrz__E_CartItem__c>();
        mapCartLineItem.put(transecRes.cartItem.id,transecRes.cartItem);
        System.debug('transecRes___'+transecRes.cartItem);
        Test.StartTest();
            OSM_SW_CartLineTriggerHelper.setPrimaryitem(lstCartLineItem);
            OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLineItem(lstCartLineItem);
            helper.deleteDuplicateCartLine(transecRes.objSetupDate.compositeProduct.Id,lstCartId);
            //OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLine()
             OSM_SW_CartLineTriggerHelper.deleteAddonProduct(lstCartLineItem);
            OSM_SW_CartLineTriggerHelper.updateRemoveAccountPreferredBillFre(mapCartLineItem);
            OSM_SW_CartLineTriggerHelper.updateTotalPrice(lstCartLineItem,mapCartLineItem);
           OSM_SW_CartLineTriggerHelper.deleteDuplicateCartLineItemBefore(lstCartLineItem);
           //OSM_SW_CartPg_Ctrl.callOneBMS(objRemotCtx);
        Test.StopTest();
        }
     }
    
    static testMethod void updateOriginalQtyTest(){
     TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Bundle';
        
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
                                
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
        
        System.debug('transecRes: '+transecRes);

        //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
         
        //System.debug(ccrz.cc_CallContext.currAccountId);
      //  List<ccrz__E_CartItem__c> lstCartLineItem =new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> lstCartLineItem=new List<ccrz__E_CartItem__c>();
        lstCartLineItem.add(transecRes.cartItem);
        List<Id> lstCartId=new List<Id>();
        lstCartId.add(transecRes.cart.id);
        OSM_SW_CartLineTriggerHelper helper=new OSM_SW_CartLineTriggerHelper();
        Map<Id,ccrz__E_CartItem__c> mapCartLineItem= new Map<Id,ccrz__E_CartItem__c>();
        mapCartLineItem.put(transecRes.cartItem.id,transecRes.cartItem);
        Test.StartTest();
            for(Id lineId : mapCartLineItem.keySet())
            {
               ccrz__E_CartItem__c line =  mapCartLineItem.get(lineId);
                line.ccrz__PricingType__c ='external';
                line.ccrz__OriginalQuantity__c=13;
                //line.ccrz__DisplayProduct__c = 'Connected Diagnostics';
                line.ccrz__Price__c=500;
            }
            update mapCartLineItem.values();
        Test.StopTest();
        }
     }
}