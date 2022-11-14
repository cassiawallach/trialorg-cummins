@IsTest(isParallel=true)
//updated on 14th June by Sangeeta
//07/22/2021 MAR-1861 Subbu K 
//05-24-2022 -- MP-854 -Karthik Raj G
public class OSM_SW_Header_Ctrl_Test {
    
    static testMethod void tetsMethod1(){
        
        User loggedInUser=[Select id from User where id=:UserInfo.getUserId()];     
        //Test data setup
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
        
        System.assert(transecRes != null, 'Transaction Response is null');//Updated for User Story - 883
        System.assert(transecRes.invoice.Id != null, 'Invoice has been created');//Updated for User Story - 883
        System.runAs ( transecRes.objSetupDate.loggedInUser   ) {
            
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront='SoftwareStore';
            objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
            
            System.debug('transecRes.objSetupDate.account '+transecRes.objSetupDate.account );
            
            
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            //Create Spec
            ccrz__E_Spec__c spec = TestingUtils.insertSpec();
            
            
            Set<String> childProdId=new Set<String>();
            childProdId.add(transecRes.objSetupDate.compositeProduct.id);
            //Updated for User Story - 883
            //Create Product Media
            List<ccrz__E_ProductMedia__c> mlist = TestingUtils.insertProductMedia( transecRes.objSetupDate.compositeProduct.id ); 
            
            //Create Attachment
            Attachment att = TestingUtils.insertAttachment( mlist[0].id );
            
            List<String> relatedProductList=new List<String>();
            
            // Create Related Products
            ccrz__E_RelatedProduct__c rp = TestingUtils.insertRelatedProduct( transecRes.objSetupDate.compositeProduct.id );
            
            relatedProductList.add(rp.id);

            //Create Subscription
            ccrz__E_Subscription__c Sub = TestingUtils.insertSingleSubscription( transecRes.objSetupDate.compositeProduct.id, transecRes.objSetupDate.subProdTermList[0].id, transecRes.objSetupDate.account.id );
            
            //Create Composite Product
            ccrz__E_CompositeProduct__c compprod = TestingUtils.insertCompositeProduct( transecRes.objSetupDate.compositeProduct.id );

            //Create Composite Product
            ccrz__E_CompositeProduct__c compprod1 = TestingUtils.insertCompositeProduct( transecRes.objSetupDate.compositeProduct.id );
            
            //OSM_SW_Header_Ctrl headerCtrl = new OSM_SW_Header_Ctrl();
            OSM_SW_Header_Ctrl.invalidateCartItem(objRemotCtx);
            OSM_SW_Header_Ctrl.getCurrProratedTotal(objRemotCtx);
            OSM_SW_Header_Ctrl.getTermsConditionSelDate(objRemotCtx);
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            OSM_SW_Header_Ctrl.goToUSStore('US');
            OSM_SW_Header_Ctrl.goToCAStore('CANADA');

            //Create Maintenance Message
            OSM_Maintenance_Message__c om= TestingUtils.insertMaintenanceMessage();
        
            OSM_SW_Header_Ctrl obj = new OSM_SW_Header_Ctrl();
			
        }
    }  
}