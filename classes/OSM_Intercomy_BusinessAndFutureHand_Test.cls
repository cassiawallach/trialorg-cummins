//1.0 -   Singaiah           29/04/2021     Updated Test classs for MAR-1633 
//2.0 -   Singaiah           22/10/2021     Updated Test classs for MP-328
//Updated By Singaiah for MAR-1994 27-09-2021
//Updated for US-867
@isTest
private class OSM_Intercomy_BusinessAndFutureHand_Test {

    private static testMethod void intercompany_BusinessLayerHandler_Test() {
        Account objAccount = new Account(Name = 'Test Account',
                                         BMS_Customer_ID__c  = '12345',
                                         CSS_DistributorCode__c  = '12345',
                                         BMS_Customer_ID_Junction__c = '12345');
        insert objAccount;
        
        ccrz__E_Product__c product=new ccrz__E_Product__c();
        product.ccrz__SKU__c='123lk';
        insert product;
         
        ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
        testCart.ccrz__Storefront__c = 'Software';
        testCart.ccrz__CartType__c = 'Cart';
        testCart.ccrz__ActiveCart__c = true;
        testCart.ccrz__CartStatus__c = 'Open';
        testCart.ccrz__User__c = UserInfo.getUserId();
        testCart.ccrz__EncryptedId__c = 'encrypt';
        testCart.Third_Party_BMS_Customer_ID__c = '12345';
        testCart.OSM_SW_Is_third_Party_BMS_Payment__c = true;
        insert testCart;
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true,
                                                      Order_Source_Type__c = 'OSM',
                                                      ccrz__OriginatedCart__c = testCart.id,
                                                      BMS_OrderRefNumber__c = 12345,
                                                      BMS_BranchLocation__c = 'test',
                                                      OSM_SW_Refund_Order_Source_Type__c = 'OSM',
                                                      BMS_Order_reference_number_Refund__c = 12345);
        insert order;
        
        ccrz__E_OrderItem__c orderItem=new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c = order.ID;
        orderItem.ccrz__Quantity__c = 1;
        orderItem.ccrz__Product__c =product.id;
        orderItem.ccrz__DisplayProduct__c = null;
        orderItem.Number_of_Bundles__c = 0;
        orderItem.Number_of_Counts__c = 0;
        orderItem.ccrz__Price__c = 15.00;
        orderItem.ccrz__SubAmount__c = 15.00;
        orderItem.Dn_Price__c=110;
        orderItem.ccrz__OriginalQuantity__c=1;
        insert orderItem;
        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
        ccInvoices.ccrz__CCOrder__c = order.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        //ccInvoices.ccrz__AccountNumber__c='123456';
        ccInvoices.BMS_InvoiceNumber__c=123456;
        ccInvoices.OSM_Child_Account__c = objAccount.Id;
        ccInvoices.BMS_PONumber__c='1234';
        ccInvoices.ICInvoice_Date__c = date.today();
        insert ccInvoices;
        
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 1000;
        invoiceItem_Item.ccrz__Invoice__c = ccInvoices.id;
        invoiceItem_Item.ccrz__CCOrderItem__c = orderItem.id;
        invoiceItem_Item.ccrz__CCOrder__c = order.id;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        insert invoiceItem_Item;
        
        ccrz__E_TransactionPayment__c  ctpayment = new ccrz__E_TransactionPayment__c();
        ctpayment.ccrz__AccountType__c = 'po';
        ctpayment.Transaction_Status__c = 'Order Placed Success';
        ctpayment.ccrz__Storefront__c = 'SoftwareStore';
        ctpayment.ccrz__CCOrder__c = order.id;
        ctpayment.ccrz__InvoiceAppliedTo__c = ccInvoices.id;
        ctpayment.ccrz__AccountNumber__c='po1000';
        insert ctpayment;
        Test.startTest();
        ccrz__E_Invoice__c objInvoice = [SELECT Id,Name, OSM_Child_Account__r.Customer_BMS_number__c, 
                                                OSM_Child_Account__r.OSM_Location_ID__c,
                                                ccrz__CCOrder__r.BMS_OrderRefNumber__c,
                                                ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c,
                                                ccrz__CCOrder__r.BMS_BranchLocation__c,
                                                ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c,
                                                ccrz__CCOrder__r.Order_Source_Type__c,
                                                ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c,
                                                BMS_PONumber__c, BMS_InvoiceNumber__c,
                                                ccrz__SoldTo__r.OSM_Location_ID__c,
                                                ccrz__SoldTo__r.CSS_DBCode__c,
                                                 ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c,
                                                ccrz__CCOrder__r.OSM_BMS_Customer_Number__c,
                                                ICInvoice_Number__c, ICInvoice_Date__c,
                                                (Select id,Name,ccrz__CCOrderItem__c from ccrz__InvoiceItems__r where ccrz__Type__c='Item')
                                           FROM ccrz__E_Invoice__c
                                           WHERE Id =: ccInvoices.Id];
       OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, false,false,null);
       OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true,false,'12345');
       OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(null, null, true,false,null);
       OSM_Intercompany_FutureLayerHandler.callIntercompanyInvoiceAPI(new set<id>{objInvoice.Id},false,false);
       List<ccrz__E_Invoice__c> objInvoiceList = [SELECT Id,IntercompanyCalled__c FROM ccrz__E_Invoice__c WHERE Id =: ccInvoices.Id];
       Test.stopTest();
    }

    private static testMethod void intercompany_BusinessLayerHandler_TestRefund() {
        
        Account objAccount = new Account(Name = 'Test Account',
                                         BMS_Customer_ID__c  = '12345',
                                         CSS_DistributorCode__c  = '12345',
                                         BMS_Customer_ID_Junction__c = '12345');
        insert objAccount;
        
        ccrz__E_Product__c product=new ccrz__E_Product__c();
        product.ccrz__SKU__c='123lk';
        insert product;
        ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
        testCart.ccrz__Storefront__c = 'Software';
        testCart.ccrz__CartType__c = 'Cart';
        testCart.ccrz__ActiveCart__c = true;
        testCart.ccrz__CartStatus__c = 'Open';
        testCart.ccrz__User__c = UserInfo.getUserId();
        testCart.ccrz__EncryptedId__c = 'encrypt';
        insert testCart;
        ccrz__E_Order__c order = new ccrz__E_Order__c(ByPassFlow__c = true,
                                                      Order_Source_Type__c = 'OSM',
                                                      BMS_OrderRefNumber__c = 12345,
                                                      ccrz__OriginatedCart__c = testCart.id,
                                                      BMS_BranchLocation__c = 'test',
                                                      OSM_SW_Refund_Order_Source_Type__c = 'OSM',
                                                      BMS_Order_reference_number_Refund__c = 12345);
        insert order;
        
        ccrz__E_OrderItem__c orderItem=new ccrz__E_OrderItem__c();
        orderItem.ccrz__Order__c = order.ID;
        orderItem.ccrz__Quantity__c = 1;
        orderItem.ccrz__Product__c =product.id;
        orderItem.ccrz__DisplayProduct__c = null;
        orderItem.Number_of_Bundles__c = 0;
        orderItem.Number_of_Counts__c = 0;
        orderItem.ccrz__Price__c = 15.00;
        orderItem.ccrz__SubAmount__c = 15.00;
        insert orderItem;
                                                                
            
        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
        ccInvoices.ccrz__CCOrder__c = order.id;
        // ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c='123456';
        ccInvoices.BMS_InvoiceNumber__c=123456;
        ccInvoices.OSM_Child_Account__c = objAccount.Id;
        //ccInvoices.ICInvoice_Date__c = date.today();
        insert ccInvoices;
        ccrz__E_InvoiceItem__c invoiceItem_Item = new ccrz__E_InvoiceItem__c();
        invoiceItem_Item.ccrz__OriginalAmount__c = 1000;
        invoiceItem_Item.ccrz__Invoice__c = ccInvoices.id;
        invoiceItem_Item.ccrz__CCOrderItem__c = orderItem.id;
        invoiceItem_Item.ccrz__CCOrder__c = order.id;
        invoiceItem_Item.Quantity__c = 1;
        invoiceItem_Item.ccrz__Status__c = 'Open';
        invoiceItem_Item.ccrz__Type__c = 'Item';
        insert invoiceItem_Item;
        Test.startTest();
        
        ccrz__E_Invoice__c objInvoice = [SELECT Id,Name, OSM_Child_Account__r.Customer_BMS_number__c, 
                                                OSM_Child_Account__r.OSM_Location_ID__c,
                                                ccrz__CCOrder__r.BMS_OrderRefNumber__c,
                                                ccrz__CCOrder__r.BMS_Order_reference_number_Refund__c,
                                                ccrz__CCOrder__r.BMS_BranchLocation__c,
                                                ccrz__CCOrder__r.Order_Source_Type__c,
                                                ccrz__CCOrder__r.Third_Party_BMS_Customer_ID__c,
                                                ccrz__CCOrder__r.OSM_SW_Refund_Order_Source_Type__c,
                                                BMS_PONumber__c, BMS_InvoiceNumber__c,
                                                ccrz__SoldTo__r.OSM_Location_ID__c,
                                                ccrz__SoldTo__r.CSS_DBCode__c,
                                                 ccrz__CCOrder__r.OSM_SW_Is_third_Party_BMS_Payment__c,
                                         ccrz__CCOrder__r.OSM_BMS_Customer_Number__c,
                                                ICInvoice_Number__c, ICInvoice_Date__c,
                                                (Select id,Name,ccrz__CCOrderItem__c from ccrz__InvoiceItems__r where ccrz__Type__c='Item')
                                           FROM ccrz__E_Invoice__c
                                           WHERE Id =: ccInvoices.Id];
        
        OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true,false,'12345');
        OSM_Intercompany_BusinessLayerHandler.getInvoiceInfo(objInvoice.Id, new Map<Id,ccrz__E_Invoice__c>{objInvoice.Id => objInvoice}, true,true,null);
       
        Test.stopTest();
    }

}