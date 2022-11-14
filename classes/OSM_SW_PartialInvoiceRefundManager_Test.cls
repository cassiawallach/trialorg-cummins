// Updated by Singaiah for MAR-1665
// Updated by Sangeeta 28thJuly
// Updated by Sangeeta Rani 29thJuly
// updated Sharad 2-Aug 21
// updated Sharad 13-Aug 21
// updated Sharad 31-Aug 21
// updated Sharad 16-Sept 21  
// updated Sharad 23-Sept 21  
// updated Sharad 04-Oct 21 
// updated Sharad 18-Oct 21   
@isTest
public class OSM_SW_PartialInvoiceRefundManager_Test {
      /*  static testMethod void testMethod1() {

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
        List<ccrz__E_OrderItem__c> orderItemList=new List<ccrz__E_OrderItem__c>();
        ccrz__E_Order__c order1=transecRes.order;
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
        oi1.Vertex_Tax__c=11;
        insert oi1;
        orderItemList.add(oi1);
        
 
        
        
        
            try {
                    
                List<Id> ss = new List<Id>();
                ss.add(transecRes.invoice.Id);
                List<Id> orderitmidlist = new List<Id>();
                orderitmidlist.add(oi1.Id);
                //OSM_SW_PartialInvoiceRefundManager.createCreditMemo(ss,Null);
               // OSM_SW_PartialInvoiceRefundManager.createCreditMemo(ss,orderitmidlist);
            } catch (Exception ex) {}
        
    }*/
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
        
        ccrz__E_Invoice__c objInv1 = new ccrz__E_Invoice__c();
            
            objInv1.ccrz__CCOrder__c=ordr.id;
           // objInv.ccrz__Status__c = 'Revoked';
           objInv1.ccrz__OriginalAmount__c =234;
            objInv1.Sub_Status__c = 'Open';
            objInv1.Recurring_Invoice__c=true;
            objInv1.Invoice_Type__c='Credit Memo';
            objInv1.ccrz__Status__c = 'Pending Refund';
            objInv1.CreditMemo_Number__c = objInv1.Name+'C';
             objInv1.OSM_SW_Vertex_Invoice_Reversal_Request__c=true;
            //objInv1.Original_Sales_Order_Invoice_Number__c
            insert objInv1;
        
            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
            objInv.Id = transecRes.invoice.Id;
            objInv.ccrz__CCOrder__c=ordr.id;
           // objInv.ccrz__Status__c = 'Revoked';
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
        //invoiceItem_Item.ccrz__CCOrderItem__c = oi11.id;
        //invoiceItem_Item.ccrz__CCOrder__c = o1.id;
        invoiceItem_Item.Quantity__c = 1;
        //invoiceItem_Item.CC_Subscription__c = subscriptionID;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Tax';
        invoiceItem_Item.IsCredited__c= false;
       invoiceItem_Item.ccrz__OriginalAmount__c=124;
       invoiceItem_Item.OSM_Bypass_Flow__c = true;
        insert invoiceItem_Item;
            
     OSM_Orders_In_Invoice__c obj =new  OSM_Orders_In_Invoice__c();
        obj.Vertex_Call_Status__c='Success';
        //obj.Name=0001;
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
                

                Test.startTest();
               // OSM_SW_PartialInvoiceRefundManager invoiceCls = new OSM_SW_PartialInvoiceRefundManager();
                OSM_SW_PartialInvoiceRefundManager.getVertexInvoiceTax(LstOrdersInvoiceID,orderitmidlist);
                OSM_SW_PartialInvoiceRefundManager.createCreditMemo(ss,orderitmidlist,'test');
                Test.stopTest();
            } catch (Exception ex) {}
        }
    }

}