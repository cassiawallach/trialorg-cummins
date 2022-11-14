//Made chnges as part of MAR-1548
@isTest 
public class OSM_SW_SalesRepInActiveTrigger_Test {

    static testMethod void testOSM_SW_SalesRepInActiveTrigger(){
        
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
    User usr=[Select id from User where id=:UserInfo.getUserId()];
        //For remote action context 
    System.runas(usr){
    ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
        

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
         
        
        // Start Test
        Test.startTest();
        
        List<ccrz__E_RequestForQuote__c> listRequestForQuote;
        List<ccrz__E_RequestForQuote__c> updtListRequestForQuote = new List<ccrz__E_RequestForQuote__c>();
        
        //Create Request for Quote
        listRequestForQuote = TestingUtils.createRequestForQuote(1,'Sent',12,450,550,'Send', 'test Sales Comments',transecRes.objSetupDate.compositeProduct.Id,transecRes.objSetupDate.contact.Id,true);
      //  System.debug('=====Request for quote inserted : '+listRequestForQuote );
          
        //Create Order
        ccrz__E_Order__c testOrder = TestingUtils.createOrder(transecRes.objSetupDate.contact.Id,'test order',true);
        
        //Create Order Item
        ccrz__E_OrderItem__c testOrderItem = TestingUtils.createOrderItems(transecRes.order.Id,transecRes.objSetupDate.compositeProduct.Id,true);
            
       
        // Stop Test
        Test.stopTest();
        }
    }
    static testMethod void testMethod2() {

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
        System.debug('transecRes: ' + transecRes);

        PermissionSet objPer = [SELECT Id FROM PermissionSet WHERE Name = 'OSM_Support_Admin'Limit 1];
   

        // Creating address
        System.runAs(transecRes.objSetupDate.loggedInUser) {


            Attachment attachment = new Attachment();
            attachment.Body = Blob.valueOf('test data');
            attachment.Name = String.valueOf('FSDInvoice.txt');
            attachment.ParentId = transecRes.invoice.Id;
            insert attachment;

Account account = transecRes.objSetupDate.account;
            account.Bolt_Customer_Account_Status__c = 'Active';
           
            account.BillingCountry='United States';
            update account;
            
            ccrz__E_ContactAddr__c contctadd = new ccrz__E_ContactAddr__c();
            contctadd.ccrz__AddressFirstline__c= 'test';
            contctadd.ccrz__AddressSecondline__c='test';
            contctadd.ccrz__City__c='test';
            contctadd.ccrz__StateISOCode__c='test';
            contctadd.ccrz__State__c='test';
            contctadd.ccrz__Country__c='test';
            contctadd.ccrz__PostalCode__c='test';
            insert contctadd;
            
            ccrz__E_ContactAddr__c contctadd1 = new ccrz__E_ContactAddr__c();
            contctadd1.ccrz__AddressFirstline__c= 'test1';
            contctadd1.ccrz__AddressSecondline__c='test1';
            contctadd1.ccrz__City__c='test1';
            contctadd1.ccrz__StateISOCode__c='test1';
            contctadd1.ccrz__State__c='test1';
            contctadd1.ccrz__Country__c='test1';
            contctadd1.ccrz__PostalCode__c='test1';
            insert contctadd1;
            
ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Name = 'CA Base-OHT';
        pro.ccrz__SKU__c = '5678902-OHT';
        pro.ccrz__Quantityperunit__c = 1;
        pro.Group_Name__c = 'DA';
        //pro.ccrz__ParentProduct__c = parentpro.id;
        pro.Product_Class_Code__c = 'SW-Web Access';
        pro.Product_Class_Code__c='Fluidwatch';
        insert pro;


ccrz__E_Order__c ordr = new ccrz__E_Order__c();
        ordr.ccrz__Storefront__c = 'SoftwareStore';
        ordr.ccrz__Account__c = account.Id;
        ordr.OrderProcessedforFSD__c = true;
        ordr.IsInterCompanyProcessSuccess__c = false;
        //o1.ccrz__AbsoluteDiscount__c = 
        ordr.ccrz__CurrencyISOCode__c = 'USD';
        ordr.ccrz__OrderStatus__c = 'Order Submitted';
        ordr.ccrz__TotalDiscount__c=12;
        ordr.ccrz__BillTo__c=contctadd.id;
        ordr.ccrz__ShipTo__c=contctadd1.id;
        insert ordr;
List<ccrz__E_OrderItem__c> listorderitem= new List<ccrz__E_OrderItem__c> ();
ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = ordr.id;
        oi1.ccrz__Product__c = pro.id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c = pro.id;
        oi1.ccrz__Product__c=pro.id;
        oi1.Vertex_Tax__c=11;
        insert oi1;
       listorderitem.add(oi1);
        
            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
            objInv.Id = transecRes.invoice.Id;
            objInv.ccrz__CCOrder__c=ordr.id;
           // objInv.ccrz__Status__c = 'Revoked';
            objInv.Sub_Status__c = 'Open';
            objInv.Recurring_Invoice__c=true;
            objInv.Invoice_Type__c='Credit Memo';
            objInv.ccrz__Status__c = 'Pending Refund';
            objInv.CreditMemo_Number__c = objInv.Name+'C';
             objInv.OSM_SW_Vertex_Invoice_Reversal_Request__c=true;
            update objInv;
            
             ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 1000;
        invoiceItem_Item.ccrz__Invoice__c = objInv.id;
        //invoiceItem_Item.ccrz__CCOrderItem__c = oi11.id;
        //invoiceItem_Item.ccrz__CCOrder__c = o1.id;
        invoiceItem_Item.Quantity__c = 1;
        //invoiceItem_Item.CC_Subscription__c = subscriptionID;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
       invoiceItem_Item.IsCredited__c= true;
        insert invoiceItem_Item;
            
     OSM_Orders_In_Invoice__c obj =new  OSM_Orders_In_Invoice__c();
        obj.Vertex_Call_Status__c='Success';
        //obj.Name=0001;
        obj.CC_Invoice__c=objInv.id;
        obj.CC_Order__c=ordr.id;
        obj.OSM_Vertex_Invoice_Failed_Count__c=1;
        obj.Vertex_Refund_Call_Status__c='Success';
       
        
insert obj;

List<ccrz__E_RequestForQuote__c> RequestForQuoteList = new List<ccrz__E_RequestForQuote__c>();
ccrz__E_RequestForQuote__c objRequestForQuote =new  ccrz__E_RequestForQuote__c();
objRequestForQuote.Status__c='InActive';
objRequestForQuote.Operation__c='InActive';
objRequestForQuote.Discounted_Percentage__c=10;
objRequestForQuote.Discounted_Price__c=100;
objRequestForQuote.CCOrderItem__c=oi1.id;
objRequestForQuote.Status__c ='Requested';
objRequestForQuote.CC_Product__c=pro.id;
insert objRequestForQuote;
        
        
            Map < String, Object > inputMap = new Map < String, Object > ();
            inputMap.put('searchData', '{\"ascending\":\"true\"}');
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            objRemotCtx.storefront = 'SoftwareStore';
            objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
            objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

            try {
                ccrz.cc_CallContext.initRemoteContext(objRemotCtx);

List<Id> LstOrdersInvoiceID = new List<Id>();
                LstOrdersInvoiceID.add(obj.Id);
                
                List<Id> orderitmidlist = new List<Id>();
                orderitmidlist.add(oi1.Id);
                
                List<Id> ss = new List<Id>();
                ss.add(transecRes.invoice.Id);
                Set<Id> orderitmidset = new set<Id>();
                orderitmidset.add(oi1.Id);

                Test.startTest();
               
                OSM_SW_SalesRepInActiveTriggerhandler.quoteUpdate(orderitmidset);
                OSM_SW_SalesRepInActiveTriggerhandler.onAfterInsert(listorderitem);
               
                Test.stopTest();
            } catch (Exception ex) {}
        }
    }

}