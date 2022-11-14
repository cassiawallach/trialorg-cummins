/************************************************************
Name:  OSM_ActivationKeyError_Handling_Test
Copyright © 2019  Cummins
=============================================================
=============================================================
Purpose:                                                            
This is test class for OSM_ActivationKeyError_Handling class.                          
=============================================================
=============================================================
History                                                            
-------                                                            
VERSION  AUTHOR                   DATE              DETAIL                                
1.0 -    Sudhendrasimha Pappu     23/04/2020        INITIAL DEVELOPMENT          
*****************************************************/

@isTest
global class OSM_SW_ActivationKeyError_Handling_Test {
    public static testmethod void testActivationKeyError() {
        
        User usr=OSM_TestDataCreationUtility.getPortalUser();
        
        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Sir Incal';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'Sir Incal2';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        
        OSM_Order_Subscription__c objSubsc = new OSM_Order_Subscription__c();
        objSubsc.CC_Order_Item__c = transecRes.orderItem.Id;
        objSubsc.OSM_CCSubscription__c = transecRes.subscription.Id;
        objSubsc.OSM_CCOrder__c = transecRes.order.Id;
        objSubsc.Billing_Frequency__c = 'Monthly';
        insert objSubsc;
        System.debug('transecRes.orderSubscriptionjunction: '+objSubsc);
        
        
        ccrz__E_Order__c objOrdr = new ccrz__E_Order__c();
        objOrdr.ccrz__OrderStatus__c = 'Order Submitted';
        objOrdr.Id = transecRes.order.Id;
        objOrdr.ByPassFlow__c = true;
        objOrdr.ccrz__OrderDate__c = system.today();
        update objOrdr;
        
        
        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.IsRevokeLicenseSucess__c = false;
        objItem.Revocation_Status__c = '';
        objItem.Id = transecRes.orderItem.Id;
        update objItem;
        
        
        OSM_Order_Item_License__c objLsc1 = new OSM_Order_Item_License__c();
        objLsc1.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc1.Activation_Key__c = 'ABCDEF';
        objLsc1.Status__c = 'New';
        insert objLsc1;
        
        ccrz__E_OrderItem__c ordrItem2 = new ccrz__E_OrderItem__c();
        ordrItem2.ccrz__DisplayProduct__c = transecRes.orderItem.ccrz__DisplayProduct__c;
        ordrItem2.ccrz__Order__c = transecRes.orderItem.ccrz__Order__c;
        ordrItem2.ccrz__Price__c = transecRes.orderItem.ccrz__Price__c;
        ordrItem2.ccrz__SubAmount__c = transecRes.orderItem.ccrz__SubAmount__c;
        ordrItem2.ccrz__Product__c = transecRes.orderItem.ccrz__Product__c;
        ordrItem2.ccrz__Quantity__c = transecRes.orderItem.ccrz__Quantity__c;
        ordrItem2.ccrz__ParentOrderItem__c = objItem.Id;
        
        insert ordrItem2;
        
        OSM_Order_Item_License__c objLsc2 = new OSM_Order_Item_License__c();
        objLsc2.Status__c = 'New';
        objLsc2.CC_Order_Item__c = ordrItem2.Id;
        objLsc2.Tool_Instance_Key__c = 'test2';
        objLsc2.Parent_Activation_Key__c = objLsc1.Id;
        insert objLsc2;
        
        
         Account acc = new Account();
    acc.name = 'OSM_Test_Acc';
    acc.OSM_Preferred_Payment_Method__c = 'PO';
    insert acc;
    //tstAcc.add(acc);
            //insert tstAcc;
            set<string> prodid = new set<string>();
            ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.name = 'Guidanz';
            prod.ccrz__SKU__c = '15458776';
            prod.ccrz__Quantityperunit__c = 3343;
            prod.ccrz__StartDate__c = system.today();
            prod.ccrz__EndDate__c = system.today()+1;
            prod.ccrz__ShortDesc__c = 'testing';
            insert prod;
            String prodidstring = String.valueof(prod.id);
            prodid.add(prodidstring); 
            
            list<ccrz__E_ProductMedia__c>mlist = new list<ccrz__E_ProductMedia__c>(); 
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__Product__c = prod.id;
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            mlist.add(media);
            insert mlist;
            
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
            
            List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
            ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
            sub.OSM_Display_Product__c = prod.id;
            sub.ccrz__Quantity__c = 10;
            sub.ccrz__Sequence__c = 2;
            sub.ccrz__Account__c = acc.id;
            sub.ccrz__Storefront__c ='storefront';
            //sub.ccrz__Storefront__c = 'SoftwareStore';
            sub.ccrz__SubscriptionStartDate__c  = system.today();
            sub.OSM_Subscription_End_Date__c  = System.today()+1;
            sub.ccrz__SubscriptionStatus__c = 'Active';
            sub.ccrz__SubscriptionProduct__c = prod.id;
            sub.OSM_Free_Trial__c =false;
            //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
            subList.add(sub);
            insert subList;
        
        OSM_Integration_Log__c objIntLog = new OSM_Integration_Log__c();
        objIntLog.Service_Name__c = 'test';
        objIntLog.Status__c = 'Failure';
        objIntLog.Target__c = 'OSM';
        objIntLog.Service_Name__c='OMS_GetOrder_Service';
        objIntLog.CC_Order__c=objOrdr.Id;
        //objIntLog.Invoice__c = invList[0].Id;
        insert objIntLog;
        
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.Id;
            objRemoteClass.portalUserId = transecRes.objSetupDate.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
            
            string ord=objOrdr.Id;
            List<string> ols= new List<string>();
            string ss=ordrItem2.Id;
            ols.add(ss);
            OSM_SW_ActivationKeyError_Handling.activationkeycheck(ord,ols);
            
            OSM_SW_Manage_Subscription_Ctrl obsubsc = new OSM_SW_Manage_Subscription_Ctrl();
           // OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, transecRes.subscription.Id);
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            
            
        }
    } 
 
 public static testmethod void testActivationKeyError2() {
        
        User usr=OSM_TestDataCreationUtility.getPortalUser();
        
        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Sir Incal';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'Sir Incal2';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        
        OSM_Order_Subscription__c objSubsc = new OSM_Order_Subscription__c();
        objSubsc.CC_Order_Item__c = transecRes.orderItem.Id;
        objSubsc.OSM_CCSubscription__c = transecRes.subscription.Id;
        objSubsc.OSM_CCOrder__c = transecRes.order.Id;
        objSubsc.Billing_Frequency__c = 'Monthly';
        insert objSubsc;
        System.debug('transecRes.orderSubscriptionjunction: '+objSubsc);
        
        
        ccrz__E_Order__c objOrdr = new ccrz__E_Order__c();
        objOrdr.ccrz__OrderStatus__c = 'Order Submitted';
        objOrdr.Id = transecRes.order.Id;
        objOrdr.ByPassFlow__c = true;
        objOrdr.ccrz__OrderDate__c = system.today();
        update objOrdr;
        
        
        
         Account acc = new Account();
    acc.name = 'OSM_Test_Acc';
    acc.OSM_Preferred_Payment_Method__c = 'PO';
    insert acc;
    //tstAcc.add(acc);
            //insert tstAcc;
            set<string> prodid = new set<string>();
            ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.name = 'Guidanz';
            prod.ccrz__SKU__c = '15458776';
            prod.ccrz__Quantityperunit__c = 3343;
            prod.ccrz__StartDate__c = system.today();
            prod.ccrz__EndDate__c = system.today()+1;
            prod.ccrz__ShortDesc__c = 'testing';
            insert prod;
            String prodidstring = String.valueof(prod.id);
            prodid.add(prodidstring); 
            
            list<ccrz__E_ProductMedia__c>mlist = new list<ccrz__E_ProductMedia__c>(); 
            ccrz__E_ProductMedia__c media = new ccrz__E_ProductMedia__c();
            media.ccrz__Product__c = prod.id;
            media.ccrz__MediaType__c = 'Product Image Thumbnail';
            mlist.add(media);
            insert mlist;
            
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
            
            List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
            ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
            sub.OSM_Display_Product__c = prod.id;
            sub.ccrz__Quantity__c = 10;
            sub.ccrz__Sequence__c = 2;
            sub.ccrz__Account__c = acc.id;
            sub.ccrz__Storefront__c ='storefront';
            //sub.ccrz__Storefront__c = 'SoftwareStore';
            sub.ccrz__SubscriptionStartDate__c  = system.today();
            sub.OSM_Subscription_End_Date__c  = System.today()+1;
            sub.ccrz__SubscriptionStatus__c = 'Active';
            sub.ccrz__SubscriptionProduct__c = prod.id;
            sub.OSM_Free_Trial__c =false;
            //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
            subList.add(sub);
            insert subList;
        
        OSM_Integration_Log__c objIntLog = new OSM_Integration_Log__c();
        objIntLog.Service_Name__c = 'test';
        objIntLog.Status__c = 'Failure';
        objIntLog.Target__c = 'OSM';
        objIntLog.Service_Name__c='OMS_GetOrder_Service';
        objIntLog.CC_Order__c=objOrdr.Id;
        //objIntLog.Invoice__c = invList[0].Id;
        insert objIntLog;
        
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.Id;
            objRemoteClass.portalUserId = transecRes.objSetupDate.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
            
            string ord=objOrdr.Id;
           List<string> ols= new List<string>();
           // string ss=ordrItem2.Id;
           // ols.add(ss);
            OSM_SW_ActivationKeyError_Handling.activationkeycheck(ord,ols);
            
            OSM_SW_Manage_Subscription_Ctrl obsubsc = new OSM_SW_Manage_Subscription_Ctrl();
           // OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, transecRes.subscription.Id);
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            
            
        }
    } 
 
}