//updated by Sangeeta 28th July
//updated by Sharad 04th Oct
@isTest
private class OSM_SW_CancelRevokeOrderQueueable_Test{
     static testMethod void testMethod1() {
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';          
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = 'CG-Lite-004';
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
        
        Test.startTest();
        OSM_SW_CancelRevokeOrderQueueable obj11 = new OSM_SW_CancelRevokeOrderQueueable(new Set<Id>(), new Set<Id>(), new Set<Id>{transecRes.order.Id}, true);      
        ID jobID = System.enqueueJob(obj11);        
        Test.stopTest();
    }
    
    static testMethod void testMethod2() {
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';          
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = 'CG-Lite-004';
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
        
        Test.startTest();
        Set<Id> steid = new Set<Id>();
        steid.add(transecRes.order.Id);
        OSM_SW_CancelRevokeOrderQueueable obj11 = new OSM_SW_CancelRevokeOrderQueueable(steid, new Set<Id>(), new Set<Id>(), true);
        ID jobID = System.enqueueJob(obj11);        
        Test.stopTest();
    }
    
    static testMethod void testMethod3() {

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
            pro.Product_Class_Code__c = 'SW-Web Access';
            pro.Product_Class_Code__c='Fluidwatch';
            insert pro;

            ccrz__E_Order__c ordr = new ccrz__E_Order__c();
            ordr.ccrz__Storefront__c = 'SoftwareStore';
            ordr.ccrz__Account__c = account.Id;
            ordr.OrderProcessedforFSD__c = true;
            ordr.IsInterCompanyProcessSuccess__c = false;
            ordr.ccrz__CurrencyISOCode__c = 'USD';
            ordr.ccrz__OrderStatus__c = 'Order Submitted';
            ordr.ccrz__TotalDiscount__c=12;
            ordr.ccrz__BillTo__c=contctadd.id;
            ordr.ccrz__ShipTo__c=contctadd1.id;
            insert ordr;

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
            oi1.IsCancelPending__c = true;
            oi1.ccrz__OrderItemStatus__c = 'Order Submitted';
            insert oi1;
            
            ccrz__E_Invoice__c objInv1 = new ccrz__E_Invoice__c();            
            objInv1.ccrz__CCOrder__c=ordr.id;
            objInv1.ccrz__OriginalAmount__c =234;
            objInv1.Sub_Status__c = 'Open';
            objInv1.Recurring_Invoice__c=true;
            objInv1.Invoice_Type__c='Credit Memo';
            objInv1.ccrz__Status__c = 'Pending Refund';
            objInv1.CreditMemo_Number__c = objInv1.Name+'C';
            objInv1.OSM_SW_Vertex_Invoice_Reversal_Request__c=true;
            insert objInv1;
        
            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
            objInv.Id = transecRes.invoice.Id;
            objInv.ccrz__CCOrder__c=ordr.id;
            objInv.ccrz__OriginalAmount__c =234;
            objInv.Sub_Status__c = 'Open';
            objInv.Recurring_Invoice__c=true;
            objInv.Invoice_Type__c='Credit Memo';
            objInv.ccrz__Status__c = 'Pending Refund';
            objInv.CreditMemo_Number__c = objInv.Name+'C';
            objInv.OSM_SW_Vertex_Invoice_Reversal_Request__c=true;
            objInv.Original_Sales_Order_Invoice_Number__c =objInv1.id;
            update objInv;
            
            ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
            invoiceItem_Item.ccrz__OriginalAmount__c = 1000;
            invoiceItem_Item.ccrz__Invoice__c = objInv.id;
            invoiceItem_Item.Quantity__c = 1;
            invoiceItem_Item.ccrz__Status__c = 'Open';
            invoiceItem_Item.ccrz__Type__c = 'Tax';
            invoiceItem_Item.IsCredited__c= true;
            invoiceItem_Item.ccrz__OriginalAmount__c=123;
            invoiceItem_Item.OSM_Bypass_Flow__c = true;
            insert invoiceItem_Item;
            
            OSM_Orders_In_Invoice__c obj =new  OSM_Orders_In_Invoice__c();
            obj.Vertex_Call_Status__c='Success';
            obj.CC_Invoice__c=objInv.id;
            obj.CC_Order__c=ordr.id;
            obj.OSM_Vertex_Invoice_Failed_Count__c=1;
            obj.Vertex_Refund_Call_Status__c='Success';
            insert obj;
            
            OSM_InvoiceLine_And_OrderLine__c obj1 = new OSM_InvoiceLine_And_OrderLine__c();            
            obj1.CC_Invoice_Item__c=invoiceItem_Item.id;
            obj1.CC_Order_Item__c=oi1.id;
            obj1.OSM_Orders_In_Invoice__c=obj.id;
            obj1.Quantity__c=1;
            obj1.Sales_Amount__c=123;
            obj1.Vertex_Tax__c=45;
            insert obj1;
            
            try {
                List<Id> LstOrdersInvoiceID = new List<Id>();
                LstOrdersInvoiceID.add(obj.Id);
                
                List<Id> orderitmidlist = new List<Id>();
                orderitmidlist.add(oi1.Id);
                List<Id> ss = new List<Id>();
                ss.add(transecRes.invoice.Id);
                Test.startTest();
                OSM_SW_CancelRevokeOrderQueueable obj11 = new OSM_SW_CancelRevokeOrderQueueable(new Set<Id>(), new Set<Id>{ordr.Id}, new Set<Id>(), true);
        
                ID jobID = System.enqueueJob(obj11);
                Test.stopTest();
            } 
            catch (Exception ex) {
                //do ntohing
            }
        }
    }
}