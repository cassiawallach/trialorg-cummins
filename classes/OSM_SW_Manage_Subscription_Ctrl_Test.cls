/*************************************************
 History
 --------
 VERSION    AUTHOR          DATE            DETAILS
 1.0        Ashish          01/03/2022      Test Class Fixes
 2.0        Sangeeta        27/01/2022      Class update
 2.1        Ashish G        22/02/2022      MP-662
 2.2        Sangeetas        07/03/2022      Class update
 	3.0      Swethas				08/02/2022	    Added test method for Get Tool Instance coverage
3.1         Suresh          22/07/2022      Added Product to OrderLine item for coverage of LL-24 code change
***/
@isTest
public class OSM_SW_Manage_Subscription_Ctrl_Test
{
   
    static testMethod void testMethod1_Test()
    {
        User usr=OSM_TestDataCreationUtility.getPortalUser();
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';//LL24
        
        
        testReq.compositeProductName = 'Guidanz';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'Guidanz 12';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        //Insert account record
        Account acc = new Account();
        acc.name = 'OSM_Test_Acc';
        acc.OSM_Preferred_Payment_Method__c = 'PO';
        insert acc;
        //Insert Product record
        set<string> prodid = new set<string>();
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Guidanz';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        prod.ccrz__ProductStatus__c='Released';
        insert prod;
        String prodidstring = String.valueof(prod.id);
        prodid.add(prodidstring); 
        //Insert SubProdTerm record
        ccrz__E_SubProdTerm__c subProdTermObj = new ccrz__E_SubProdTerm__c();
        subProdTermObj.ccrz__CCProduct__c = prodidstring;
        subProdTermObj.ccrz__DisplayName__c = 'Test SubProdTerm';
        subProdTermObj.ccrz__EffectiveEnd__c = system.today() + 50;
        subProdTermObj.ccrz__EffectiveStart__c = system.today();
        insert subProdTermObj;
        
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        sub.ccrz__Account__c = transecRes.objSetupDate.account.Id;
        sub.ccrz__Storefront__c ='SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.OSM_Subscription_End_Date__c  = System.today()+50;
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.ccrz__SubscriptionProduct__c = prod.id;
        sub.OSM_Free_Trial__c =false;
        sub.ccrz__SPT__c = subProdTermObj.Id;
        //sub.OSM_Display_Product__r.ccrz__ShortDesc__c = 'test description';
        subList.add(sub);
        insert subList;
        System.debug('SubList ' + subList[0].id);
        
        OSM_Order_Subscription__c objSubsc = new OSM_Order_Subscription__c();
        objSubsc.CC_Order_Item__c = transecRes.orderItem.Id;
        objSubsc.OSM_CCSubscription__c = subList[0].id;
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
        objItem.OSM_SW_Product_Link__c = transecRes.orderItem.ccrz__Product__c; // @Suresh Added this Line for test coverage for code written in LL-24
        objItem.Id = transecRes.orderItem.Id;
        update objItem;
        
        
        OSM_Order_Item_License__c objLsc1 = new OSM_Order_Item_License__c();
        objLsc1.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc1.Activation_Key__c = 'ABCDEF';
        objLsc1.Status__c = 'New';
        objLsc1.Type__c = 'Basic';
        insert objLsc1;
        
        OSM_Order_Item_License__c objLsc2 = new OSM_Order_Item_License__c();
        objLsc2.Status__c = 'New';
        objLsc2.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc2.Tool_Instance_Key__c = 'test2';
        objLsc2.Parent_Activation_Key__c = objLsc1.Id;
        insert objLsc2;
        
        
        OSM_Order_Item_License__c objLsc12 = new OSM_Order_Item_License__c();
        objLsc12.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc12.Activation_Key__c = 'ABCDEF';
        objLsc12.Status__c = 'New';
        objLsc12.Type__c = 'Functional';
        insert objLsc12;
        
        OSM_Order_Item_License__c objLsc21 = new OSM_Order_Item_License__c();
        objLsc21.Status__c = 'New';
        objLsc21.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc21.Tool_Instance_Key__c = 'test2';
        objLsc21.Parent_Activation_Key__c = objLsc12.Id;
        insert objLsc21;
        OSM_ReturnWrapper OSMreturn = new OSM_ReturnWrapper();
        OSMreturn.exceptionFlag = False;
        
        OSM_OMS_SW_RevokeAPIUtility.revokeAPIcallSingleInstance(transecRes.orderItem.Id,'licenseId');
        
        OSM_Order_Item_License__c objLsc22 = new OSM_Order_Item_License__c();
        objLsc22.Status__c = 'Revoked/ReIssue';
        objLsc22.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc22.Tool_Instance_Key__c = 'test2';
        objLsc22.Parent_Activation_Key__c = objLsc12.Id;
        insert objLsc22;
        
        ccrz__E_OrderItem__c ordrItem2 = new ccrz__E_OrderItem__c();
        ordrItem2.ccrz__DisplayProduct__c = transecRes.orderItem.ccrz__DisplayProduct__c;
        ordrItem2.ccrz__Order__c = transecRes.orderItem.ccrz__Order__c;
        ordrItem2.ccrz__Price__c = transecRes.orderItem.ccrz__Price__c;
        ordrItem2.ccrz__SubAmount__c = transecRes.orderItem.ccrz__SubAmount__c;
        ordrItem2.ccrz__Product__c = transecRes.orderItem.ccrz__Product__c;
        ordrItem2.ccrz__Quantity__c = transecRes.orderItem.ccrz__Quantity__c;
        ordrItem2.ccrz__ParentOrderItem__c = objItem.Id;
        insert ordrItem2;
           
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.Id;
            objRemoteClass.portalUserId = transecRes.objSetupDate.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
            
            Test.StartTest();
            OSM_SW_Manage_Subscription_Ctrl obsubsc = new OSM_SW_Manage_Subscription_Ctrl();
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            prod.name = 'Zap-It';// Navas M -08-07-22- LL1 - Added sort by desc logic in query 
            update prod;
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            prod.name = 'Zap-It OEM';
            update prod;
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            prod.name = 'Fleet Count';
            update prod;
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            prod.name = 'Fleetcount';
            update prod;
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            prod.name = 'Insite';
            update prod;
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            prod.name = 'QSOL';
            update prod;
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            prod.name = 'Incal';
            update prod;
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            prod.name = 'QuickServe';
            update prod;
            sub.ccrz__SubscriptionStatus__c = 'Renew';
            //Update sub;
            subList.add(sub);
            OSM_SW_Manage_Subscription_Ctrl.initSubscriptionData(objRemoteClass, subList[0].Id);
            test.StopTest();
        }
        
    }
        
    static testMethod void testMethod11_Test()
    {

        User usr=OSM_TestDataCreationUtility.getPortalUser();
   
        

        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Zap-It OEM';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'Zap-It OEM2';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';
        
        
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';
        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        //Insert order Subscription data insert
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
        objLsc1.Activation_Key__c = objLsc1.Id;
        objLsc1.Status__c = 'New';
        insert objLsc1;
        
        OSM_Order_Item_License__c objLsc2 = new OSM_Order_Item_License__c();
        objLsc2.Status__c = 'Revoked/ReIssue';
        objLsc2.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc2.Tool_Instance_Key__c = 'test2';
        objLsc2.Parent_Activation_Key__c = objLsc1.Id;
        insert objLsc2;
        
        ccrz__E_OrderItem__c ordrItem2 = new ccrz__E_OrderItem__c();
        ordrItem2.ccrz__DisplayProduct__c = transecRes.orderItem.ccrz__DisplayProduct__c;
        ordrItem2.ccrz__Order__c = transecRes.orderItem.ccrz__Order__c;
        ordrItem2.ccrz__Price__c = transecRes.orderItem.ccrz__Price__c;
        ordrItem2.ccrz__SubAmount__c = transecRes.orderItem.ccrz__SubAmount__c;
        ordrItem2.ccrz__Product__c = transecRes.orderItem.ccrz__Product__c;
        ordrItem2.ccrz__Quantity__c = transecRes.orderItem.ccrz__Quantity__c;
        ordrItem2.ccrz__ParentOrderItem__c = objItem.Id;
        insert ordrItem2;
        
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.Id;
            objRemoteClass.portalUserId = transecRes.objSetupDate.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
            
            String input = '{"licenseId":"'+objLsc2.Id+'","OrderItem":"'+objItem.Id+'","Order":"'+transecRes.orderItem.ccrz__Order__c+'"}';
            OSM_SW_Manage_Subscription_Ctrl.revokeAndReIssueSubscription(objRemoteClass, input);
            String input1 = '{"licenseId":"'+objLsc1.Id+'","OrderItem":"'+objItem.Id+'","Order":"'+transecRes.orderItem.ccrz__Order__c+'"}';
            OSM_SW_Manage_Subscription_Ctrl.revokeAndReIssueSubscription(objRemoteClass, input1);
            
        }
        
    }
    
    static testMethod void testMethod12_Test()
    {

        User usr=OSM_TestDataCreationUtility.getPortalUser();
   

        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Zap-It OEM';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'Zap-It OEM2';
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
        objLsc1.Activation_Key__c = objLsc1.Id;
        objLsc1.Status__c = 'New';
        insert objLsc1;
        
        OSM_Order_Item_License__c objLsc2 = new OSM_Order_Item_License__c();
        objLsc2.Status__c = 'Revoke Initiated';
        objLsc2.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc2.Tool_Instance_Key__c = 'test2';
        objLsc2.Parent_Activation_Key__c = objLsc1.Id;
        insert objLsc2;
        
        ccrz__E_OrderItem__c ordrItem2 = new ccrz__E_OrderItem__c();
        ordrItem2.ccrz__DisplayProduct__c = transecRes.orderItem.ccrz__DisplayProduct__c;
        ordrItem2.ccrz__Order__c = transecRes.orderItem.ccrz__Order__c;
        ordrItem2.ccrz__Price__c = transecRes.orderItem.ccrz__Price__c;
        ordrItem2.ccrz__SubAmount__c = transecRes.orderItem.ccrz__SubAmount__c;
        ordrItem2.ccrz__Product__c = transecRes.orderItem.ccrz__Product__c;
        ordrItem2.ccrz__Quantity__c = transecRes.orderItem.ccrz__Quantity__c;
        ordrItem2.ccrz__ParentOrderItem__c = objItem.Id;
        insert ordrItem2;
        
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.Id;
            objRemoteClass.portalUserId = transecRes.objSetupDate.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
            
            String input = '{"licenseProduct":true,"licenseId":"'+objLsc2.Id+'","OrderItem":"'+objItem.Id+'","subscId":"'+transecRes.subscription.Id+'"}';
            OSM_SW_Manage_Subscription_Ctrl.revokeSubscription(objRemoteClass, input);
            String input1 = '{"licenseProduct":true,"licenseId":"'+objLsc1.Id+'","OrderItem":"'+objItem.Id+'","subscId":"'+transecRes.subscription.Id+'"}';
            OSM_SW_Manage_Subscription_Ctrl.revokeSubscription(objRemoteClass, input1);
        }
        
    }
    
    
    static testMethod void testMethod14_Test()
    {

        User usr=OSM_TestDataCreationUtility.getPortalUser();
   

        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Zap-It OEM';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'Zap-It OEM2';
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
        
        OSM_Order_Item_License__c objLsc2 = new OSM_Order_Item_License__c();
        objLsc2.Status__c = 'New';
        objLsc2.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc2.Tool_Instance_Key__c = 'test2';
        objLsc2.Parent_Activation_Key__c = objLsc1.Id;
        insert objLsc2;
        
        ccrz__E_OrderItem__c ordrItem2 = new ccrz__E_OrderItem__c();
        ordrItem2.ccrz__DisplayProduct__c = transecRes.orderItem.ccrz__DisplayProduct__c;
        ordrItem2.ccrz__Order__c = transecRes.orderItem.ccrz__Order__c;
        ordrItem2.ccrz__Price__c = transecRes.orderItem.ccrz__Price__c;
        ordrItem2.ccrz__SubAmount__c = transecRes.orderItem.ccrz__SubAmount__c;
        ordrItem2.ccrz__Product__c = transecRes.orderItem.ccrz__Product__c;
        ordrItem2.ccrz__Quantity__c = transecRes.orderItem.ccrz__Quantity__c;
        ordrItem2.ccrz__ParentOrderItem__c = objItem.Id;
        insert ordrItem2;
        
        ccrz__E_Product__c prod = new ccrz__E_Product__c();
        prod.name = 'Add-on';
        prod.ccrz__SKU__c = '15458776';
        prod.ccrz__Quantityperunit__c = 3343;
        prod.ccrz__StartDate__c = system.today();
        prod.ccrz__EndDate__c = system.today()+1;
        prod.ccrz__ShortDesc__c = 'testing';
        prod.ccrz__ProductStatus__c='Released';
        insert prod;
       
        ccrz__E_SubProdTerm__c subProdTermObj = new ccrz__E_SubProdTerm__c();
        subProdTermObj.ccrz__CCProduct__c = prod.id;
        subProdTermObj.ccrz__DisplayName__c = 'Test SubProdTerm';
        subProdTermObj.ccrz__EffectiveEnd__c = system.today() + 50;
        subProdTermObj.ccrz__EffectiveStart__c = system.today();
        insert subProdTermObj;
        
        ccrz__E_OrderItem__c ordrItem3 = new ccrz__E_OrderItem__c();
        ordrItem3.ccrz__DisplayProduct__c = prod.id;
        ordrItem3.ccrz__Order__c = transecRes.orderItem.ccrz__Order__c;
        ordrItem3.ccrz__Price__c = transecRes.orderItem.ccrz__Price__c;
        ordrItem3.ccrz__SubAmount__c = transecRes.orderItem.ccrz__SubAmount__c;
        ordrItem3.ccrz__Product__c = prod.id;
        ordrItem3.ccrz__Quantity__c = transecRes.orderItem.ccrz__Quantity__c;
        //ordrItem2.ccrz__ParentOrderItem__c = objItem.Id;
        insert ordrItem3;
        
        List<ccrz__E_Subscription__c> subList = new List<ccrz__E_Subscription__c>();
        ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
        sub.OSM_Display_Product__c = prod.id;
        sub.ccrz__Quantity__c = 10;
        sub.ccrz__Sequence__c = 2;
        sub.ccrz__Account__c = transecRes.objSetupDate.account.Id;
        sub.ccrz__Storefront__c ='SoftwareStore';
        sub.ccrz__SubscriptionStartDate__c  = system.today();
        sub.OSM_Subscription_End_Date__c  = System.today()+50;
        sub.ccrz__SubscriptionStatus__c = 'Active';
        sub.ccrz__SubscriptionProduct__c = prod.id;
        sub.OSM_Free_Trial__c =false;
        sub.ccrz__SPT__c = subProdTermObj.Id;
        sub.ccrz__CCOrderItem__c=ordrItem3.id;
        subList.add(sub);
        
        ccrz__E_Subscription__c sub1 = new ccrz__E_Subscription__c();
        sub1.OSM_Display_Product__c = prod.id;
        sub1.ccrz__Quantity__c = 10;
        sub1.ccrz__Sequence__c = 2;
        sub1.ccrz__Account__c = transecRes.objSetupDate.account.Id;
        sub1.ccrz__Storefront__c ='SoftwareStore';
        sub1.ccrz__SubscriptionStartDate__c  = system.today();
        sub1.OSM_Subscription_End_Date__c  = System.today()+50;
        sub1.ccrz__SubscriptionStatus__c = 'Renew';
        sub1.ccrz__SubscriptionProduct__c = prod.id;
        sub1.OSM_Free_Trial__c =false;
        sub1.ccrz__SPT__c = subProdTermObj.Id;
        subList.add(sub1);
        insert subList;
        
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.Id;
            objRemoteClass.portalUserId = transecRes.objSetupDate.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
            try
            {
                String input = '{"licenseProduct":false,"OrderItem":"'+objItem.Id+'","subscId":"'+transecRes.subscription.Id+'"}';
                OSM_SW_Manage_Subscription_Ctrl.renewSubscription(objRemoteClass, input);
                
            }
            Catch(Exception ex){}
            try{
                String input1 = '{"licenseProduct":false,"OrderItem":"'+objItem.Id+'","subscId":"'+subList[0].Id+'"}';
                OSM_SW_Manage_Subscription_Ctrl.renewSubscription(objRemoteClass, input1);
            }Catch(Exception ex){}
        }
        
    }
    
    static testMethod void testMethod15_Test()
    {

        User usr=OSM_TestDataCreationUtility.getPortalUser();
   

        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        
        
        testReq.compositeProductName = 'Zap-It OEM';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';
        
        testReq.componentProductName = 'Zap-It OEM2';
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
        objItem.Revocation_Status__c = 'Revoked';
        objItem.Id = transecRes.orderItem.Id;
        update objItem;
        
        ccrz__E_OrderItem__c objItem1 = new ccrz__E_OrderItem__c();
        objItem1.IsRevokeLicenseSucess__c = false;
        objItem1.Revocation_Status__c = '';
        objItem1.Id = transecRes.orderItem.Id;
        update objItem1;
        
        OSM_Order_Item_License__c objLsc1 = new OSM_Order_Item_License__c();
        objLsc1.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc1.Activation_Key__c = objLsc1.Id;
        objLsc1.Status__c = 'New';
        insert objLsc1;
        
        OSM_Order_Item_License__c objLsc2 = new OSM_Order_Item_License__c();
        objLsc2.Status__c = 'Revoked';
        objLsc2.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc2.Tool_Instance_Key__c = 'test2';
        objLsc2.Parent_Activation_Key__c = objLsc1.Id;
        insert objLsc2;
        
        ccrz__E_OrderItem__c ordrItem2 = new ccrz__E_OrderItem__c();
        ordrItem2.ccrz__DisplayProduct__c = transecRes.orderItem.ccrz__DisplayProduct__c;
        ordrItem2.ccrz__Order__c = transecRes.orderItem.ccrz__Order__c;
        ordrItem2.ccrz__Price__c = transecRes.orderItem.ccrz__Price__c;
        ordrItem2.ccrz__SubAmount__c = transecRes.orderItem.ccrz__SubAmount__c;
        ordrItem2.ccrz__Product__c = transecRes.orderItem.ccrz__Product__c;
        ordrItem2.ccrz__Quantity__c = transecRes.orderItem.ccrz__Quantity__c;
        ordrItem2.ccrz__ParentOrderItem__c = objItem.Id;
        ordrItem2.Revocation_Status__c = 'Revoked';
        insert ordrItem2;
        
        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.Id;
            objRemoteClass.portalUserId = transecRes.objSetupDate.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';
            try
            {
                String input = '{"licenseProduct":false,"OrderItem":"'+objItem.Id+'","subscId":"'+transecRes.subscription.Id+'"}';
                OSM_SW_Manage_Subscription_Ctrl.revokeSubscriptionForNonLic(objRemoteClass, input);
                String input1 = '{"licenseProduct":false,"OrderItem":"'+objItem1.Id+'","subscId":"'+transecRes.subscription.Id+'"}';
                OSM_SW_Manage_Subscription_Ctrl.revokeSubscriptionForNonLic(objRemoteClass, input1);
            }
            Catch(Exception ex){}
            
        }
        
    }
    
    static testMethod void getToolInstance_Test()
    {
      //Create 
        User usr=OSM_TestDataCreationUtility.getPortalUser();
        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';    
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        testReq.compositeProductName = 'Zap-It OEM';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'DA';
        testReq.compositeProductProductType = 'Aggregated';        
        testReq.componentProductName = 'Zap-It OEM2';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'DA';
        testReq.componentProductPackageName = 'Base';  
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';        
        
        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);
        
        //Create Test Subscription
        OSM_Order_Subscription__c objSubsc = new OSM_Order_Subscription__c();
        objSubsc.CC_Order_Item__c = transecRes.orderItem.Id;
        objSubsc.OSM_CCSubscription__c = transecRes.subscription.Id;
        objSubsc.OSM_CCOrder__c = transecRes.order.Id;
        objSubsc.Billing_Frequency__c = 'Monthly';
        insert objSubsc;
        System.debug('transecRes.orderSubscriptionjunction: '+objSubsc);
        
        //Create Test Order
        ccrz__E_Order__c objOrdr = new ccrz__E_Order__c();
        objOrdr.ccrz__OrderStatus__c = 'Order Submitted';
        objOrdr.Id = transecRes.order.Id;
        objOrdr.ByPassFlow__c = true;
        objOrdr.ccrz__OrderDate__c = system.today();
        update objOrdr;
        
        //Create Test order Item
        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.IsRevokeLicenseSucess__c = false;
        objItem.Revocation_Status__c = '';
        objItem.Id = transecRes.orderItem.Id;
        update objItem;
        
         ccrz__E_OrderItem__c ordrItem2 = new ccrz__E_OrderItem__c();
        ordrItem2.ccrz__DisplayProduct__c = transecRes.orderItem.ccrz__DisplayProduct__c;
        ordrItem2.ccrz__Order__c = transecRes.orderItem.ccrz__Order__c;
        ordrItem2.ccrz__Price__c = transecRes.orderItem.ccrz__Price__c;
        ordrItem2.ccrz__SubAmount__c = transecRes.orderItem.ccrz__SubAmount__c;
        ordrItem2.ccrz__Product__c = transecRes.orderItem.ccrz__Product__c;
        ordrItem2.ccrz__Quantity__c = transecRes.orderItem.ccrz__Quantity__c;
        ordrItem2.ccrz__ParentOrderItem__c = objItem.Id;
        insert ordrItem2;
        
        //Create Test Order Item Licenses
        OSM_Order_Item_License__c objLsc1 = new OSM_Order_Item_License__c();
        objLsc1.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc1.Activation_Key__c = objLsc1.Id;
        objLsc1.Status__c = 'New';
        insert objLsc1;
        
        OSM_Order_Item_License__c objLsc2 = new OSM_Order_Item_License__c();
        objLsc2.Status__c = 'Revoked/ReIssue';
        objLsc2.CC_Order_Item__c = transecRes.orderItem.Id;
        objLsc2.Tool_Instance_Key__c = 'test2';
        objLsc2.Parent_Activation_Key__c = objLsc1.Id;
        insert objLsc2;

        System.Runas(transecRes.objSetupDate.loggedInUser)
        {
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            objRemoteClass.storefront = 'SoftwareStore';
            objRemoteClass.currentCartId = transecRes.cart.Id;
            objRemoteClass.portalUserId = transecRes.objSetupDate.loggedInUser.Id;
            objRemoteClass.userLocale = 'en_US';     
            
                 
            String input = '{"OrderItem":"'+transecRes.orderItem.Id+'","subscId":"'+transecRes.subscription.Id+'"}';
            OSM_SW_Manage_Subscription_Ctrl.getToolInstance(objRemoteClass,input);  

        }        
    }
      
}