// Update by Subbu new changes
@isTest
public class OSM_Email_ProductLine_Ctrl1_Test {
    
    

    static testMethod void OSM_Email_ProductLine(){
            ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c();
            accGrp.Name = 'US/CAN_EBU_SIR_ACCGRP';
            insert accGrp ;
            Account portalAccount2 = new Account();
            portalAccount2.Name = 'TestAccount2';
            portalAccount2.OwnerId = UserInfo.getUserId();
            portalAccount2.OSM_Preferred_Billing_Frequency_Lock__c=false;
            portalAccount2.BMS_Customer_ID__c='1234';
            portalAccount2.OSM_Preferred_Payment_Method__c='cc';
            portalAccount2.OSM_Preferred_Payment_IsBolt_PO__c=false;
            portalAccount2.ccrz__E_AccountGroup__c=accGrp.id;
         insert portalAccount2;
        Contact contact1 = new Contact();
            contact1.FirstName = 'Test';
            contact1.Lastname = 'McTesty';
            contact1.IAM_Contact_Status__c='Pending';
            contact1.Username__c = 'testUserName9980@gmail.com';
            contact1.AccountId = portalAccount2.Id;
            contact1.Email ='test@test.com';
            insert contact1; 
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        
        ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = Label.VOTECH100OFFINSITE;
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 12;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c ='Price';
            coupon.ccrz__DiscountType__c  ='Price';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 5;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__TargetProduct__c = prod.Id;
            //coupon.OSM_Coupon_Discount_Target_Type__c='MSRP';
            //coupon.Subscription_Migration_Coupon__c = false;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;
        
        List<ccrz__E_Order__c> ordList = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        //ord.ccrz__TotalAmount__c = 20;
        ord.ccrz__OrderStatus__c = 'Order Submitted' ;
        //ord.Partial_Cancellation__c = 3;
        ord.ByPassFlow__c = true;
        ordList.add(ord);
         ord.ccrz__User__c=UserInfo.getUserId();
        ord.ccrz__Contact__c=contact1.id;
        insert ordList;
        
        List<ccrz__E_OrderItem__c> ordItemLst = new List<ccrz__E_OrderItem__c>();
        ccrz__E_OrderItem__c orditem = new ccrz__E_OrderItem__c();
        orditem.ccrz__Quantity__c = 1;
        orditem.ccrz__DisplayProduct__c  = prod.id;
        orditem.ccrz__Price__c = 30;
        orditem.ccrz__SubAmount__c = 50;
        orditem.ccrz__AdjustmentAmount__c =100;
        ordItem.ccrz__Coupon__c = coupon.id;
        ordItem.OSM_SW_Coupon_Applied__c=true;
        orditem.Vertex_Tax__c = 2;
        orditem.ccrz__OrderItemStatus__c ='Cancelled';
        orditem.Date_Revoke__c = date.today();
        orditem.ccrz__Product__c = prod.id;
        //orditem.ccrz__ItemTotal__c = 2;
        orditem.ccrz__Order__c  = ordList[0].Id;
        orditem.ccrz__OrderLineType__c ='Major';
        ordItemLst.add(orditem);
       // insert ordItemLst;
        
      //  List<ccrz__E_OrderItem__c> ordItemLst1 = new List<ccrz__E_OrderItem__c>();
        ccrz__E_OrderItem__c orditem1 = new ccrz__E_OrderItem__c();
        orditem1.ccrz__Quantity__c = 1;
        orditem1.ccrz__DisplayProduct__c  = prod.id;
        orditem1.ccrz__Price__c = 30;
        orditem1.ccrz__SubAmount__c = 50;
         orditem.ccrz__AdjustmentAmount__c =200;
        orditem1.Vertex_Tax__c = 2;
        orditem1.ccrz__OrderItemStatus__c ='Cancelled';
        orditem1.Date_Revoke__c = date.today();
        orditem1.ccrz__Product__c = prod.id;
         ordItem.ccrz__Coupon__c = coupon.id;
         ordItem.OSM_SW_Coupon_Applied__c=true;
        orditem1.ccrz__Order__c  = ordList[0].Id;
        orditem1.ccrz__OrderLineType__c ='Major';
        ordItemLst.add(orditem1);
        insert ordItemLst;
         
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__SubscriptionProduct__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        //sub.ccrz__SPT__c = spt.Billing_Display_Name__c;
        sub.ccrz__Storefront__c = 'SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.ccrz__CCOrderItem__c = ordItemLst[0].Id;
        sub.OSM_Subscription_End_Date__c = system.now()+2;
        //sub.OSM_Free_Trial__c =true;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
        subList.add(sub);
        insert subList;
        
        List<ccrz__E_RequestForQuote__c>quoteList = new List<ccrz__E_RequestForQuote__c>();
        ccrz__E_RequestForQuote__c req = new ccrz__E_RequestForQuote__c();
        //req.ccrz__Account__c = objResponseProductSetup.account.id;
        req.ccrz__Storefront__c = 'SoftwareStore';
        req.Display_Product__c = prod.id;
        req.Status__c = 'Requested';
        req.Expired_Date__c = system.today();
        req.Quantity__c = 2;
        //req.CC_Product__c = objResponseProductSetup.compositeProduct.id;
        quoteList.add(req);
        insert quoteList;
        
        list<ccrz__E_ProductMedia__c>mlist = new list<ccrz__E_ProductMedia__c>(); 
        ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
        media.ccrz__Product__c = quoteList[0].Display_Product__c ;
        media.ccrz__MediaType__c = 'Product Image Thumbnail';
        mlist.add(media);
        insert mlist;
    
        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'Monthly';
        spt.ccrz__CCProduct__c = prod.id;
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now()+2;
        insert spt;
        
        List<ccrz__E_Invoice__c> invList = new List<ccrz__E_Invoice__c>();
        ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c();
        inv.BMS_InvoiceDate__c = system.today();
        inv.IntercompanyCalled__c = true;
        inv.OSM_SW_IsIntercompanyInvoice__c = true;
        inv.ccrz__Contact__c=contact1.id;
        invList.add(inv);
        insert invList;
        
        List<ccrz__E_InvoiceItem__c> invitemList = new list<ccrz__E_InvoiceItem__c>();
        ccrz__E_InvoiceItem__c invitem = new ccrz__E_InvoiceItem__c();
        invitem.ccrz__Invoice__c = invList[0].id;
        invitem.ccrz__CCOrder__c = ordList[0].id;
        invitem.ccrz__CCOrderItem__c = ordItemLst[0].id;
        invitem.OSM_Bypass_Flow__c=true;
        invitemList.add(invitem);
        insert invitemList;
        
        List<OSM_Order_Item_License__c> oItemLst = new List<OSM_Order_Item_License__c>();
        OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
        ParentActivationKey.Activation_Key__c         = 'testActivationKey';
        ParentActivationKey.CC_Order_Item__c          = ordItemLst[0].id;
        ParentActivationKey.Parent_Activation_Key__c  = null;
        ParentActivationKey.OMS_Item_Id__c            = '1234';
        ParentActivationKey.Tool_Instance_Key__c      = '12345';
        ParentActivationKey.Status__c                 = 'Revoke Intitiated';
        ParentActivationKey.type__c                   = 'Tool instance';
        //insert ParentActivationKey;
        oItemLst.add(ParentActivationKey);
        
        OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
        orderItemLicense2.Activation_Key__c         = 'testActivationKey';
        orderItemLicense2.CC_Order_Item__c          = ordItemLst[0].id;
        orderItemLicense2.Parent_Activation_Key__c  = ParentActivationKey.id;
        orderItemLicense2.OMS_Item_Id__c            = '1234';
        orderItemLicense2.Tool_Instance_Key__c      = '12345';
        orderItemLicense2.Status__c                 = 'Revoked/ReIssue';
        orderItemLicense2.type__c                   = 'Tool instance';
        //insert orderItemLicense2;
        oItemLst.add(orderItemLicense2);
        insert oItemLst;
        
        OSM_Integration_Log__c objIntLog = new OSM_Integration_Log__c();
        objIntLog.Service_Name__c = 'test';
        objIntLog.Status__c = 'Failure';
        objIntLog.Target__c = 'OSM';
        objIntLog.Invoice__c = invList[0].Id;
        insert objIntLog;
        
        
        List<OSM_Email_ProductLine_Ctrl1.OerderLineItemDetail> wraplist = new List<OSM_Email_ProductLine_Ctrl1.OerderLineItemDetail>();
        OSM_Email_ProductLine_Ctrl1.OerderLineItemDetail wrap = new OSM_Email_ProductLine_Ctrl1.OerderLineItemDetail();
        wrap.name = 'Connected Advisor'; 
        wrap.uri = 'test11';
        wrap.imageUrl = 'test1';
        wrap.Quantity = 20;
        wrap.shortDec = 'test';
        wrap.Price = 20.0;
        wrap.Total = 10.0;
        wrap.tax= 2;
        wrap.status = 'Requested';
        wrap.freetrial = true;
        wrap.expiredmonthName = 'september';
        wrap.subLength = 'Monthly';
        wrap.billingPeriod = ' yearly';
        wrap.activationKey='key';
        wrap.licenseName='licensename';
        wrap.productGroup='productGroup';
        wrap.FunActivationKey='FunActivationKey';
        wrap.BasicActivationKey='BasicActivationKey';
        wrap.CouponCode='CouponCode';
        wrap.DiscountTotal=0.1;
        wrap.shouldSendEmailtoBranch=true;
        wrap.shouldIncludePrice=true;
        wrap.isDistributorPurchased=true;
        wrap.isOnBehalfOf=true;
        wrap.expiredDate = system.now()+3;
        wraplist.add(wrap);
        
        OSM_Email_ProductLine_Ctrl1 obj1 = new OSM_Email_ProductLine_Ctrl1();
        obj1.orderLineItem=wrap;
        obj1.headQuaterName='Test Head';
        obj1.headQuaterEmail='TestHead@test.com';
        obj1.shouldShowPrice=true;
        obj1.isInSubscription=true;
        obj1.activationKeyErrorMessage=true;
        obj1.mediaList=new list<ccrz__E_ProductMedia__c>();
        obj1.expiredmonthName='Test ';
        obj1.osmIntegrationLog= new OSM_Integration_Log__c();
        obj1.incalSubIds = ordItemLst[0].id;
        obj1.osmIntegerationId = objIntLog.Id;
        obj1.setOrderIds(string.valueof(ordList[0].id));
        Obj1.getOrder();
        obj1.handleOrderSubmitEmail(string.valueof(ordList[0].id));
        obj1.fetchOrderInfo(string.valueof(ordList[0].id));
         obj1.fetchOrderInfo1(string.valueof(ordList[0].id));
        obj1.handleCancelOrderEmail(string.valueof(ordList[0].id));
        
        obj1.getOrderSubsList();  
        
        obj1.getIncalSubscriptionList();
        
        ordList[0].ccrz__OrderStatus__c = 'Cancelled';
        update ordList[0];
        obj1.setOrderIds(string.valueof(ordList[0].id));
        
        Test.startTest();
        
        // Case 1.1
        ordList[0].ccrz__OrderStatus__c = 'Partially Cancelled';
        update ordList[0];
        obj1.setOrderIds(string.valueof(ordList[0].id));
        
        // Case 2
        obj1.SubsriptionIds = sub.ID;
        obj1.getSubscriptionList();
        
        // Case 3
        obj1.requestQuoteIds = req.ID;
        obj1.getRequestQuoteList();
        
          // Case 4
        obj1.invoiceIds  = inv.ID;
        obj1.getinvoiceItemList();
        
        Test.stopTest();
    }
    static testMethod void OSM_Email_ProductLine1(){
    
    
        ccrz__E_AccountGroup__c accGrp = new ccrz__E_AccountGroup__c();
            accGrp.Name = 'US/CAN_EBU_SIR_ACCGRP';
            insert accGrp ;
       
       
        Account portalAccount2 = new Account();
            portalAccount2.Name = 'TestAccount2';
            portalAccount2.OwnerId = UserInfo.getUserId();
            portalAccount2.OSM_Preferred_Billing_Frequency_Lock__c=false;
            portalAccount2.BMS_Customer_ID__c='1234';
            portalAccount2.OSM_Preferred_Payment_Method__c='cc';
            portalAccount2.OSM_Preferred_Payment_IsBolt_PO__c=false;
            portalAccount2.ccrz__E_AccountGroup__c=accGrp.id;
         insert portalAccount2;
  
  
        Contact contact1 = new Contact();
            contact1.FirstName = 'Test';
            contact1.Lastname = 'McTesty';
            contact1.IAM_Contact_Status__c='Pending';
            contact1.Username__c = 'testUserName9980@gmail.com';
            contact1.AccountId = portalAccount2.Id;
            contact1.Email ='test@test.com';
            insert contact1; 
    
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Connected Advisor';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        insert prod;
        
        ccrz__E_Coupon__c coupon = new ccrz__E_Coupon__c();
            coupon.ccrz__CouponCode__c = Label.VOTECH100OFFINSITE;
            coupon.ccrz__CouponName__c = 'testName';
            coupon.ccrz__MaxUse__c = 12;
            coupon.ccrz__TotalUsed__c = 1;
            coupon.ccrz__DiscountAmount__c = 10;
            coupon.ccrz__CouponType__c ='Price';
            coupon.ccrz__DiscountType__c  ='Price';
            coupon.ccrz__RuleType__c = 'General';
            coupon.ccrz__TargetQty__c = 5;
            coupon.ccrz__TargetRelation__c = 'Product';
            coupon.ccrz__TargetProduct__c = prod.Id;
            //coupon.OSM_Coupon_Discount_Target_Type__c='MSRP';
            //coupon.Subscription_Migration_Coupon__c = false;
            coupon.ccrz__Storefront__c='SoftwareStore';
            insert coupon;
        
        List<ccrz__E_Order__c> ordList = new List<ccrz__E_Order__c>();
        ccrz__E_Order__c ord = new ccrz__E_Order__c();
        //ord.ccrz__TotalAmount__c = 20;
        ord.ccrz__OrderStatus__c = 'Order Submitted' ;
        ord.ByPassFlow__c = true;
        ordList.add(ord);
        insert ordList;
        
        List<ccrz__E_OrderItem__c> ordItemLst = new List<ccrz__E_OrderItem__c>();
        ccrz__E_OrderItem__c orditem = new ccrz__E_OrderItem__c();
        orditem.ccrz__Quantity__c = 1;
        orditem.ccrz__DisplayProduct__c  = prod.id;
        orditem.ccrz__Price__c = 30;
        orditem.ccrz__SubAmount__c = 50;
        orditem.ccrz__AdjustmentAmount__c =300;
        orditem.Vertex_Tax__c = 2;
        orditem.Date_Revoke__c = date.today();
        orditem.ccrz__Product__c = prod.id;
        ordItem.ccrz__Coupon__c = coupon.id;
        ordItem.OSM_SW_Coupon_Applied__c=true;
        orditem.ccrz__Order__c  = ordList[0].Id;
        orditem.ccrz__OrderLineType__c ='Major';
        ordItemLst.add(orditem);
        insert ordItemLst;
         
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__SubscriptionProduct__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        //sub.ccrz__SPT__c = spt.Billing_Display_Name__c;
        sub.ccrz__Storefront__c = 'SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.ccrz__CCOrderItem__c = ordItemLst[0].Id;
        sub.OSM_Subscription_End_Date__c = system.now()+2;
        //sub.OSM_Free_Trial__c =true;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
        subList.add(sub);
        insert subList;
        
        List<ccrz__E_RequestForQuote__c>quoteList = new List<ccrz__E_RequestForQuote__c>();
        ccrz__E_RequestForQuote__c req = new ccrz__E_RequestForQuote__c();
        //req.ccrz__Account__c = objResponseProductSetup.account.id;
        req.ccrz__Storefront__c = 'SoftwareStore';
        req.Display_Product__c = prod.id;
        req.Status__c = 'Requested';
        req.Expired_Date__c = system.today();
        req.Quantity__c = 2;
        //req.CC_Product__c = objResponseProductSetup.compositeProduct.id;
        quoteList.add(req);
        insert quoteList;
        
        list<ccrz__E_ProductMedia__c>mlist = new list<ccrz__E_ProductMedia__c>(); 
        ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
        media.ccrz__Product__c = quoteList[0].Display_Product__c ;
        media.ccrz__MediaType__c = 'Product Image Thumbnail';
        mlist.add(media);
        insert mlist;
    
        ccrz__E_SubProdTerm__c spt = new ccrz__E_SubProdTerm__c();
        spt.Billing_Display_Name__c = 'Monthly';
        spt.ccrz__CCProduct__c = prod.id;
        spt.ccrz__EffectiveEnd__c = system.now();
        spt.ccrz__EffectiveStart__c = system.now()+2;
        insert spt;
        
        List<ccrz__E_Invoice__c> invList = new List<ccrz__E_Invoice__c>();
        ccrz__E_Invoice__c inv = new ccrz__E_Invoice__c();
        inv.BMS_InvoiceDate__c = system.today();
        inv.IntercompanyCalled__c = true;
        inv.OSM_SW_IsIntercompanyInvoice__c = true;
        inv.ccrz__Contact__c=contact1.id;
        invList.add(inv);
        insert invList;
        
        List<ccrz__E_InvoiceItem__c> invitemList = new list<ccrz__E_InvoiceItem__c>();
        ccrz__E_InvoiceItem__c invitem = new ccrz__E_InvoiceItem__c();
        invitem.ccrz__Invoice__c = invList[0].id;
        invitem.ccrz__CCOrder__c = ordList[0].id;
        invitem.ccrz__CCOrderItem__c = ordItemLst[0].id;
        invitem.OSM_Bypass_Flow__c=true;
        invitemList.add(invitem);
        insert invitemList;
        
        OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
        ParentActivationKey.Activation_Key__c         = 'testActivationKey';
        ParentActivationKey.CC_Order_Item__c          = ordItemLst[0].id;
        ParentActivationKey.Parent_Activation_Key__c  = null;
        ParentActivationKey.OMS_Item_Id__c            = '1234';
        ParentActivationKey.Tool_Instance_Key__c      = '12345';
        ParentActivationKey.Status__c                 = 'Revoke Intitiated';
        ParentActivationKey.type__c                   = 'Tool instance';
        insert ParentActivationKey;
        
        OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
        orderItemLicense2.Activation_Key__c         = 'testActivationKey';
        orderItemLicense2.CC_Order_Item__c          = ordItemLst[0].id;
        orderItemLicense2.Parent_Activation_Key__c  = ParentActivationKey.id;
        orderItemLicense2.OMS_Item_Id__c            = '1234';
        orderItemLicense2.Tool_Instance_Key__c      = '12345';
        orderItemLicense2.Status__c                 = 'Revoked/ReIssue';
        orderItemLicense2.type__c                   = 'Tool instance';
        insert orderItemLicense2;
        
        OSM_Integration_Log__c objIntLog = new OSM_Integration_Log__c();
        objIntLog.Service_Name__c = 'test';
        objIntLog.Status__c = 'Failure';
        objIntLog.Target__c = 'OSM';
        objIntLog.Invoice__c = invList[0].Id;
        insert objIntLog;
        
        
        List<OSM_Email_ProductLine_Ctrl1.OerderLineItemDetail> wraplist = new List<OSM_Email_ProductLine_Ctrl1.OerderLineItemDetail>();
        
        OSM_Email_ProductLine_Ctrl1.OerderLineItemDetail wrap = new OSM_Email_ProductLine_Ctrl1.OerderLineItemDetail();
        wrap.name = 'Connected Advisor'; 
        wrap.uri = 'test11';
        wrap.imageUrl = 'test1';
        wrap.Quantity = 20;
        wrap.shortDec = 'test';
        wrap.Price = 20.0;
        wrap.Total = 10.0;
        wrap.tax= 2;
        wrap.status = 'Requested';
        wrap.freetrial = true;
        wrap.expiredmonthName = 'september';
        wrap.subLength = 'Monthly';
        wrap.billingPeriod = ' yearly';
        wrap.activationKey='key';
        wrap.licenseName='licensename';
        wrap.productGroup='productGroup';
        wrap.FunActivationKey='FunActivationKey';
        wrap.BasicActivationKey='BasicActivationKey';
        wrap.CouponCode='CouponCode';
        wrap.DiscountTotal=0.1;
        wrap.shouldSendEmailtoBranch=true;
        wrap.shouldIncludePrice=true;
        wrap.isDistributorPurchased=true;
        wrap.isOnBehalfOf=true;
        wrap.expiredDate = system.now()+3;
        wraplist.add(wrap);
        
        OSM_Email_ProductLine_Ctrl1 obj1 = new OSM_Email_ProductLine_Ctrl1();
        obj1.orderLineItem=wrap;
       // obj1.OrderIds= ordList[0].id;
        obj1.orderitemCancelled=false;
        obj1.IsFWProd=false;
        obj1.isGoms=false;
        
        obj1.headQuaterName='Test Head';
        obj1.headQuaterEmail='TestHead@test.com';
        obj1.shouldShowPrice=true;
        obj1.isInSubscription=true;
        obj1.activationKeyErrorMessage=true;
        obj1.mediaList=new list<ccrz__E_ProductMedia__c>();
        obj1.expiredmonthName='Test ';
        obj1.osmIntegrationLog= new OSM_Integration_Log__c();
        obj1.incalSubIds = ordItemLst[0].id;
        obj1.osmIntegerationId = objIntLog.Id;
        obj1.setOrderIds(string.valueof(ordList[0].id));
        Obj1.getOrder();
        obj1.handleOrderSubmitEmail(string.valueof(ordList[0].id));
        obj1.fetchOrderInfo(string.valueof(ordList[0].id));
        obj1.handleCancelOrderEmail(string.valueof(ordList[0].id));
        
        obj1.getOrderSubsList();  
        
        obj1.getIncalSubscriptionList();
        
        ordList[0].ccrz__OrderStatus__c = 'Cancelled';
        update ordList[0];
        obj1.setOrderIds(string.valueof(ordList[0].id));
        
        // Case 1.1
        ordList[0].ccrz__OrderStatus__c = 'Partially Cancelled';
        update ordList[0];
        obj1.setOrderIds(string.valueof(ordList[0].id));
        
        // Case 2
        obj1.SubsriptionIds = sub.ID;
        obj1.getSubscriptionList();
        
        // Case 3
        obj1.requestQuoteIds = req.ID;
        obj1.getRequestQuoteList();
        
          // Case 4
        obj1.invoiceIds  = inv.ID;
        obj1.getinvoiceItemList();
    }
    
}