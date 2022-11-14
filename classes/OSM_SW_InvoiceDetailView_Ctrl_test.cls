//Test Class for the class OSM_SW_InvoiceDetailView_Ctrl
//Adding this class to deploy OSM_SW_InvoiceDetailView_Ctrl
//Added for Mar-1684 - Pratima
//Added for Mar-1957 - Sharad
//Added for Mar-1948& 2008& Demo Changes - Singaiah
//Subbu changes to fix MP-702
// OMG-1092
//reupdated
@isTest
public class OSM_SW_InvoiceDetailView_Ctrl_test{

static testMethod void tetsMethod1(){
 
 User loggedInUser=[Select id from User where id=:UserInfo.getUserId()];    

    
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        //LL23
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
        System.debug('transecRes: '+transecRes);
        
        
            ccrz__E_SubProdTerm__c newObj = new ccrz__E_SubProdTerm__c();
            newObj.ccrz__DisplayName__c = '99 Year';
            newObj.ccrz__CCProduct__c = transecRes.orderItem.ccrz__Product__c;
            newObj.ccrz__EffectiveEnd__c = System.now()+1;
            newObj.ccrz__EffectiveStart__c = System.now();
            
        
            insert newObj;
            
            ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
            objItem.Id = transecRes.orderItem.Id;
    		objItem.OSM_SW_Product_Link__c = transecRes.orderItem.ccrz__Product__c; // @Suresh Added this Line for test coverage for code written in LL-23
            objItem.ccrz__SubProdTerm__c = newObj.Id;
            
            update objItem;
        RecordType recid =[select id from recordType where name='wwsps' limit 1];  
        Account acc = new Account();
        acc.RecordTypeId= recid.id;
        acc.Name = 'Test Account';
        //acc.CMI_Account_Status__c = 'Active'; //This is commented
        acc.CMI_CDA_Status__c = 'New Customer Request';
        acc.IAM_WWSPS_Regions__c  = 'US and Canada';
        acc.CSS_Language__c = 'English';
        acc.DTNA__c = true;
        acc.Business_Unit__c = 'EBU';
        acc.CSS_DistributorCode__c='12345';
        acc.EBU_Channel_of_Distribution__c = 'DISTRIBUTOR-BRANCH';
        acc.BillingCity = 'Sunnyvale'; 
        acc.Billingstate = 'California'; 
        acc.BillingPostalCode = '94085'; 
        acc.BillingCountry='United States';
        acc.BillingStreet='351 test street';
        insert acc;
        
         test.StartTest();
         //For remote action context 

        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
         
        // Call Apex Class Methods
        OSM_SW_InvoiceDetailView_Ctrl.fetchInvoiceDetails(objRemotCtx,transecRes.invoice.Id);
         //transecRes.invoice.ccrz__CCOrder__r.ccrz__Account__r.type='Distributor Account';
         //transecRes.invoice.ccrz__CCOrder__r.ccrz__Account__r.BillingCountry='Australia';
         transecRes.invoice.Invoice_Type__c='Credit Memo';
         transecRes.invoice.ccrz__BillTo__c=acc.id;
       update transecRes.invoice;
     OSM_SW_InvoiceDetailView_Ctrl.fetchInvoiceDetails(objRemotCtx,transecRes.invoice.Id);
    
        
        
        // Stop Test
        test.StopTest();
}
	/* Start - @Suresh 22/07/2022 LL-23 Added below method for test coverage */
    static testMethod void tetsMethod2(){
 
 		User loggedInUser=[Select id from User where id=:UserInfo.getUserId()];    

    
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
        System.debug('transecRes: '+transecRes);
        
        
            ccrz__E_SubProdTerm__c newObj = new ccrz__E_SubProdTerm__c();
            newObj.ccrz__DisplayName__c = '99 Year';
            newObj.ccrz__CCProduct__c = transecRes.orderItem.ccrz__Product__c;
            newObj.ccrz__EffectiveEnd__c = System.now()+1;
            newObj.ccrz__EffectiveStart__c = System.now();
            
            insert newObj;
            
            ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
            objItem.Id = transecRes.orderItem.Id;
    		objItem.OSM_SW_Product_Link__c = transecRes.orderItem.ccrz__Product__c;
            objItem.ccrz__SubProdTerm__c = newObj.Id;
            
            update objItem;
         test.StartTest();
         //For remote action context 
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        transecRes.invoice.Invoice_Type__c='Credit Memo';
       	update transecRes.invoice;
     	OSM_SW_InvoiceDetailView_Ctrl.fetchInvoiceDetails(objRemotCtx,transecRes.invoice.Id);
        System.assertEquals('Credit Memo',transecRes.invoice.Invoice_Type__c);
        test.StopTest();
}
    /* End - @Suresh 22/07/2022 LL-23 Added below method for test coverage */
    }