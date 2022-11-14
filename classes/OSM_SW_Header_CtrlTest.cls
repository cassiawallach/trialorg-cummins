@IsTest(isParallel=true)
public class OSM_SW_Header_CtrlTest {
    
    static testMethod void testOSM_SW_Header_Ctrl(){
        // create cart
        //List<ccrz__E_Cart__c> lstECart = TestingUtils.CreateCart(1, 'SoftwareStore', 'Cart', UserInfo.UserInfo(), true, 'Closed', true);
        
        // add to cart items
        //List<ccrz__E_CartItem__c> lstECartItem = TestingUtils.createCartItem(1, 'SoftwareStore', lstECart[0].Id, 'Cart', 1, testProductSetupRes.compositeProduct.ID, testProductSetupRes.subProdTermList[0].Id, 500, true);
        
        test.startTest();
        OSM_SW_Header_Ctrl obj = new OSM_SW_Header_Ctrl();
        test.stopTest();
    }
    
    
    static testMethod void tetsMethod1(){
        
        User loggedInUser=[Select id from User where id=:UserInfo.getUserId()];     
        
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
        ccrz__E_Product__c prod=transecRes.objSetupDate.componentList[0];
        Account a =transecRes.objSetupDate.account;
        Contact c=transecRes.objSetupDate.contact;
        Set<String> idSet=new Set<String>();
        idSet.add(prod.id);
        
        System.debug('transecRes: '+transecRes);
        
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            
            System.debug('transecRes.objSetupDate.account '+transecRes.objSetupDate.account );
            
            
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            ccrz__E_Spec__c spec=new ccrz__E_Spec__c();
            spec.name='CA Base';
            spec.imageText__c='test';
            spec.ccrz__Sequence__c =500;
            insert spec;
            
            
            Set<String> childProdId=new Set<String>();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);
            
            list<ccrz__E_ProductMedia__c>mlist = new list<ccrz__E_ProductMedia__c>(); 
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            //media.ccrz__Product__c = quoteList[0].Display_Product__c ;
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            media.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            mlist.add(media);
            insert mlist;
            Attachment att = new Attachment();
            att.name = 'MediaAttachment';
            att.parentId = mlist[0].id;
            att.Body = Blob.valueof('test');
            insert att;
            List<String> relatedProductList=new List<String>();
            //Neha Sharma Code added here
            ccrz__E_RelatedProduct__c rp = new ccrz__E_RelatedProduct__c();
            rp.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProduct__c=transecRes.objSetupDate.compositeProduct.id;
            rp.ccrz__RelatedProductType__c='Accessories';
            rp.ccrz__EndDate__c=System.today() +1;
            insert rp;
            relatedProductList.add(rp.id);
            ccrz__E_Subscription__c Sub=new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c=3;
            Sub.ccrz__Storefront__c='SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c=System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c=System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c= 'Active';
            Sub.ccrz__InstallmentLastDate__c=System.now();
            Sub.ccrz__SPT__c=transecRes.objSetupDate.subProdTermList[0].id;
            // Sub.ccrz__CCOrder__c=o1.Id;
            // Sub.ccrz__CCOrderItem__c=oi1.Id;
            Sub.OSM_Free_Trial__c=false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = transecRes.objSetupDate.account.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c=transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
            
            ccrz__E_CompositeProduct__c compprod = new ccrz__E_CompositeProduct__c();
            compprod.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            
            insert compprod;
            
            ccrz__E_CompositeProduct__c compprod1 = new ccrz__E_CompositeProduct__c();
            compprod1.ccrz__Component__c = transecRes.objSetupDate.compositeProduct.id;
            compprod1.ccrz__Composite__c = transecRes.objSetupDate.compositeProduct.id;
            insert compprod1;    
            //OSM_SW_Header_Ctrl headerCtrl = new OSM_SW_Header_Ctrl();
            OSM_SW_Header_Ctrl.invalidateCartItem(objRemotCtx);
            OSM_SW_Header_Ctrl.getCurrProratedTotal(objRemotCtx);
            
        }
    }  
}