//Test class for the class OSM_SW_OrderDetailView_Ctrl
//updated on 2nd Dec 2020
//Updated on 2nd March 2021 by Sharad
//Updated on 12th May bu Sangeeta
// Updated Singaiah 05 Aug 2021
// Updated Sangeeta
// updated by sharad 23 july 21
// Updated Sangeeta
// updated by Sangeeta 23 july 21
// updated by sharad 28 july 21
//updated by sangeeta 29 july 21
// updated by sharad 03 Aug 21 
// updated by Sangeeta 16 Aug 21
// updated by Singaiah 17 Aug 21
// updated by Sharad 19 Aug 21
// updated by Sharad 23 Aug 21
// updated by Sharad 26 Aug 21
// updated by Sharad 26 Aug 21
 // update by sharad
//22/07/2021 MAR -1861  Subbu K
// updated by Sangeeta Sept 21
// updated by Sangeeta 08 Oct 21
// updated by Sharad 21 Oct 21
// updated by Sangeeta 08 Oct 21
// updated by Sharad 21 Oct 21
// updated by Sharad 29 Oct 21
// updated by Ashish 01 Feb 22
// update Swetha 01 Feb 2022
// updated by Ashish 01 Feb 22
// updated by Ashish 03 Feb 22
// update by Swetha on 10th Feb 2022
// reupdate
// reupdated
// updated by Sangeeta 22 Mar 22
//  updated by swetha 22 Mar 22
//  Updated on 12/04/2022.
@isTest
public class OSM_SW_OrderDetailView_Ctrl_Test{
    @testSetup
    static void setup(){
        IAMDistributorCodeGroupEmail__c customSettingIAM = new IAMDistributorCodeGroupEmail__c();
        customSettingIAM.Group_Email__c = 'test@testtt.com';
        customSettingIAM.Distributor_Code__c = '02850';
        customSettingIAM.Name = '02850';
        insert customSettingIAM;
    }    

    static testMethod void getOrderInfo_test()
    {        
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';        
        testReq.accountGroupName = 'TestingAccountGroup Test';
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
        
        Test.StartTest();
        User usr = [Select id from User where Id =: UserInfo.getUserId()];


        Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
        //Id   roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 

        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);

        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        
         //Creating user record    
        User portalAccountOwner2 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = 'test24446@test.com',
            Alias = 'batman',
            Email = 'bruce.wayne@wayneenterprises.com',
            EmailEncodingKey = 'UTF-8',
            Firstname = 'Bruce',
            Lastname = 'Wayne',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            TimeZoneSidKey = 'America/Chicago'
        );
        Database.insert(portalAccountOwner2);
        
         System.runAs(portalAccountOwner2) {
        Account portalAccount1 = new Account(
            Name = 'TestAccount1',
            OwnerId = portalAccountOwner2.Id,
            OSM_Preferred_Billing_Frequency_Lock__c = true,
            BMS_Customer_ID__c = '1234',
            OSM_Preferred_Payment_Method__c = 'po',
            OSM_Preferred_Payment_IsBolt_PO__c = false,
            type = 'Dealer Account'
            
            
        );
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront='SoftwareStore';
        objRemotCtx.currentCartId=transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId=transecRes.objSetupDate.objUserID;
         ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
       
        ccrz__E_Cart__c cart = transecRes.cart;
        cart.OSM_Payment_Method__c = 'po';
        cart.ccrz__Account__c = portalAccount1.id;
        cart.ccrz__EncryptedId__c = objRemotCtx.currentCartId;
        cart.OSM_SW_Is_third_Party_BMS_Payment__c = true;
        update cart;
        
        ccrz__E_Product__c product = transecRes.objSetupDate.compositeProduct;
        
        ccrz__E_CartItem__c cartItem = transecRes.cartItem;
        //cartItem.ccrz__ParentCartItem__c=childCart.id;
        cartItem.ccrz__Product__c = product.id;
        cartItem.ccrz__Quantity__c = 2;
        // cartItem.ccrz__ItemTotal__c=10;
        cartItem.ccrz__Price__c = 10;
        cartItem.ccrz__ProductType__c = 'Bundle';
        update cartItem;
        
        ccrz__E_CartItem__c cartItemChild = new ccrz__E_CartItem__c();
        cartItemChild.ccrz__Cart__c = cart.id;
        cartItemChild.OSM_SW_AddOn_Product_Of__c = cartItem.id;
        cartItemChild.ccrz__Product__c = product.id;
        cartItemChild.ccrz__ParentCartItem__c = cartItem.id;
        cartItemChild.ccrz__Quantity__c = 2;
        cartItemChild.ccrz__Price__c = 10;
        cartItemChild.ccrz__ProductType__c = 'Bundle';
        insert cartItemChild;
        
        ccrz__E_Order__c newOrdr = new ccrz__E_Order__c();
        newOrdr = transecRes.order.clone(false, true);
        newOrdr.ccrz__OrderStatus__c = 'Approved';
        newOrdr.Original_Sales_Order__c = transecRes.order.Id;
        newOrdr.OSM_Bill_From__c='Cummins Inc';
        insert newOrdr;
        newOrdr.ccrz__EncryptedId__c=newOrdr.id;
             
        update  newOrdr;
             system.debug('Order Id'+newOrdr.id);
             
       /* ccrz__E_SubProdTerm__c testSubProdTerm = new ccrz__E_SubProdTerm__c();
        testSubProdTerm.name = 'SubProd';
        testSubProdTerm.ccrz__EffectiveStart__c = System.today().addMonths(-1);
        testSubProdTerm.ccrz__EffectiveEnd__c = System.today().addMonths(4);
        testSubProdTerm.ccrz__CCProduct__c = product.id;
        testSubProdTerm.Operation__c = '*';
        testSubProdTerm.ccrz__Enabled__c = true;
        testSubProdTerm.ccrz__Storefront__c = 'SoftwareStore';
        testSubProdTerm.Billing_Display_Name__c = 'Monthly';
        insert testSubProdTerm;
             
        ccrz__E_OrderItem__c testOrderItem = new ccrz__E_OrderItem__c();
        testOrderItem.ccrz__Order__c = newOrdr.id;
        testOrderItem.ccrz__Product__c = product.id;
        testOrderItem.ccrz__Price__c = 450;
        testOrderItem.ccrz__Quantity__c = 2;
        testOrderItem.ccrz__SubAmount__c = 200;
        testOrderItem.ccrz__SubProdTerm__c = testSubProdTerm.id;
        
        insert testOrderItem;
             
         ccrz__E_Subscription__c Sub = new ccrz__E_Subscription__c();
            Sub.ccrz__Sequence__c = 3;
            Sub.ccrz__Storefront__c = 'SoftwareStore';
            Sub.ccrz__SubscriptionStartDate__c = System.now().adddays(-2);
            Sub.OSM_Subscription_End_Date__c = System.now().adddays(5);
            Sub.ccrz__SubscriptionStatus__c = 'Active';
            Sub.ccrz__InstallmentLastDate__c = System.now();
            Sub.ccrz__SPT__c = transecRes.objSetupDate.subProdTermList[0].id;
            Sub.OSM_Free_Trial__c = false;
            Sub.ccrz__SubscriptionProduct__c = transecRes.objSetupDate.compositeProduct.Id;
            Sub.ccrz__RecurringPrice__c = 200;
            Sub.ccrz__OrderLastDate__c = System.now() + 10;
            Sub.ccrz__CurrencyISOCode__c = 'USD';
            Sub.ccrz__Quantity__c = 3;
            Sub.ccrz__Account__c = portalAccount1.id;
            Sub.Subsequent_Next_Invoice_Due_Dt__c = System.now() + 15;
            Sub.Subsequent_Next_Invoice_Generation_Dt__c = System.now() + 15;
            Sub.OSM_Display_Product__c = transecRes.objSetupDate.compositeProduct.id;
            Insert Sub;
        */
        ccrz__E_Invoice__c newInvoice = new ccrz__E_Invoice__c();
        newInvoice = transecRes.invoice.clone(false, true);
        newInvoice.ccrz__CCOrder__c = newOrdr.Id;
        newInvoice.Original_Sales_Order_Invoice_Number__c = transecRes.invoice.Id;
        insert newInvoice;
        
        ccrz__E_TransactionPayment__c newTP = new ccrz__E_TransactionPayment__c();
        newTP = transecRes.transactionPayment.clone(false, true);
        newTP.ccrz__CCOrder__c = newOrdr.Id;
        newTP.ccrz__InvoiceAppliedTo__c = newInvoice.Id;
        newTP.ccrz__AccountType__c='cc';
        newTP.ccrz__AccountType__c='po';
        insert newTP;
        OSM_Features_Maintenance__c osmFeaMaint = new OSM_Features_Maintenance__c();
        osmFeaMaint.Name='Partial_Cancellation';
        osmFeaMaint.PO_Partial_Cancellation__c='ON';
        osmFeaMaint.CC_Partial_Cancellation__c='ON';
        insert osmFeaMaint;
        Test.setCurrentPageReference(new PageReference('Page.myPage')); 
        System.currentPageReference().getParameters().put('o', newOrdr.ID);   
        //Test.StartTest();
        OSM_SW_OrderDetailView_Ctrl orderDetailView = new OSM_SW_OrderDetailView_Ctrl();
        OSM_SW_OrderDetailView_Ctrl.getOrderInfo(objRemotCtx, transecRes.order.ID);
         OSM_SW_OrderDetailView_Ctrl.getOrderInfo(objRemotCtx, newOrdr.ID);
         
             
        Test.StopTest();
      }
        
        
    }
    static testMethod void myOrders_Comp_Ctrl_Test() {

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
        Test.startTest(); 
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName7789@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test2@test.com';
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
        // Creating address
        System.runAs(portalAccountOwner2) {
        OSM_Application_Feature__mdt lstAppFeature = [SELECT MasterLabel, Label, DeveloperName, Product_Name__c, 
                                                                        Role_Feature__c, User_Type__c 
                                                                 FROM OSM_Application_Feature__mdt 
                                                                 WHERE DeveloperName='Guidanz_Mobile_SIR_GZ_Mobile_P_002' limit 1];
          
            Contact contact = transecRes.objSetupDate.contact;
            contact.CMI_Contact_Type__c= 'Primary';
            //update contact;
            
            Account account = transecRes.objSetupDate.account;
            RecordType recid =[select id from recordType where name='WWSPS' limit 1]; 
            account.RecordTypeId= recid.id;
            account.Type = 'Distributor Account';
            account.OSM_Service_Level__c= 'asdAccount';
             account.Name= 'sdf';
             account.EBU_Channel_of_Distribution__c= 'BUS OEM';
               account.PSBU_Channel_of_Distribution__c= 'EXPORT HOUSE';
           account.BillingCountry = 'United States';
        account.CMI_Region__c = 'India';
        account.CSS_Locale__c = 'English(India)';
             account.OSM_HHP_Dealer__c= true;
              account.CMI_Region__c= 'India';
              account.BUSINESS_UNIT__c= 'India';
            account.DTNA__c = true;
            account.CMI_CId__c = 'Test';
            account.CSS_DBCode__c = 'Test';
            account.CSS_DealerCode__c = 'Test';
            account.Type = 'Distributor Account';
            account.CMI_Account_Status__c='Expired';
            account.CSS_DistributorCode__c = '10010';
            account.IAM_Service_Provider_Code__c = '1339';
            account.CMI_CDA_Status__c='New Customer Request';
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.CHANNEL_OF_DISTRIBUTION__c = Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0];
            //update account;
             //Test.startTest(); 
            ccrz__E_Order__c order = new ccrz__E_Order__c();
            order.Id = transecRes.order.id;
            order.ccrz__OrderStatus__c = 'Order Submitted';
            update order;
            
            ccrz__E_Product__c pro = new ccrz__E_Product__c();
            pro.Group_Name__c = 'DA';
            pro.Name = 'Service Tech Kit';
            pro.ccrz__SKU__c = 'INS-Pro-P-02300';
            pro.ccrz__Quantityperunit__c = 1;
            pro.ccrz__ProductType__c = 'Product';
            pro.Product_Range__c = 'Service Plus';
            pro.isIAMProvisioningRequired__c = true;
            pro.Product_Class_Code__c = 'SW-Web Access';
            pro.LicenseName__c = 'Service Plus Basic';
            pro.Id = transecRes.objSetupDate.compositeProduct.Id;
            update pro;
            
            ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
            objItem.Id = transecRes.orderItem.Id;
            objItem.OMS_Product__c = true;
            objItem.ccrz__Product__c = pro.Id;
            objItem.ccrz__DisplayProduct__c = pro.Id;
            update objItem;
            ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
            oi1.ccrz__Price__c = 500;
            oi1.ccrz__OriginalItemPrice__c = 400;
            oi1.ccrz__Quantity__c = 1;
            oi1.ccrz__SubAmount__c = 123;
            oi1.ccrz__Order__c = order.id;
            oi1.ccrz__Product__c = pro.id;
            oi1.ccrz__Subscription_Auto_Renewal__c = true;
            oi1.ccrz__DisplayProduct__c = pro.id;
            oi1.ccrz__OrderItemStatus__c ='Cancelled';
            oi1.OMS_Product__c = true;
            oi1.Vertex_Tax__c=11;
            insert oi1;
            
            OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
            ParentActivationKey.Activation_Key__c         = 'testActivationKey';
            ParentActivationKey.CC_Order_Item__c          = transecRes.orderItem.Id;
            ParentActivationKey.Parent_Activation_Key__c  = null;
            ParentActivationKey.OMS_Item_Id__c            = '1234';
            ParentActivationKey.Tool_Instance_Key__c      = '12345';
            ParentActivationKey.Status__c                 = 'New';
            ParentActivationKey.type__c                   = 'Basic';
            insert ParentActivationKey;
            
            OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
            orderItemLicense2.Activation_Key__c         = 'testActivationKey';
            orderItemLicense2.CC_Order_Item__c          = transecRes.orderItem.Id;
            orderItemLicense2.Parent_Activation_Key__c  = ParentActivationKey.Id;
            orderItemLicense2.OMS_Item_Id__c            = '1234';
            orderItemLicense2.Tool_Instance_Key__c      = '12345';
            orderItemLicense2.Status__c                 = 'New';
            orderItemLicense2.type__c                   = 'Functional';
            insert orderItemLicense2;

            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testUser.id;
            
            objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
         try{   
            Map<String,OSM_Application_Feature__mdt> appF = new Map<String,OSM_Application_Feature__mdt>();
            appF.put('key', lstAppFeature);
            
            String orderItm =objItem.id;
            List<String> listOrderItems=new List<String>();
            listOrderItems.add(orderItm);
            OSM_SW_OrderDetailView_Ctrl.getOrderInformation(objRemotCtx, orderItm,'','');
            OSM_SW_OrderDetailView_Ctrl.checkIAMUserProvisionedCount(objRemotCtx, orderItm);
            OSM_SW_OrderDetailView_Ctrl.createOsmIamProvisioningDetail('test', 1, account, new Map<String, OSM_Application_Feature__mdt>{'test' => lstAppFeature}, 'EBU',pro.ccrz__SKU__c);
            OSM_SW_OrderDetailView_Ctrl.callFSDAPI(objRemotCtx, listOrderItems,listOrderItems);
            Test.stopTest();
          }
        Catch(Exception ex) {

        }  
        }
    }
     static testMethod void myOrders_Comp_Ctrl_Test1() {

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
        Test.startTest(); 
          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName7789@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test2@test.com';
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
        // Creating address
        System.runAs(portalAccountOwner2) {
        OSM_Application_Feature__mdt lstAppFeature = [SELECT MasterLabel, Label, DeveloperName, Product_Name__c, 
                                                                        Role_Feature__c, User_Type__c 
                                                                 FROM OSM_Application_Feature__mdt 
                                                                 WHERE DeveloperName='Guidanz_Mobile_SIR_GZ_Mobile_P_002' limit 1];
          
            Contact contact = transecRes.objSetupDate.contact;
            contact.CMI_Contact_Type__c= 'Primary';
            //update contact;
            
            Account account = transecRes.objSetupDate.account;
            RecordType recid =[select id from recordType where name='WWSPS' limit 1]; 
            account.RecordTypeId= recid.id;
            account.Type = 'Distributor Account';
            account.OSM_Service_Level__c= 'asdAccount';
             account.Name= 'sdf';
             account.EBU_Channel_of_Distribution__c= 'BUS OEM';
               account.PSBU_Channel_of_Distribution__c= 'EXPORT HOUSE';
           account.BillingCountry = 'United States';
        account.CMI_Region__c = 'India';
        account.CSS_Locale__c = 'English(India)';
             account.OSM_HHP_Dealer__c= true;
              account.CMI_Region__c= 'India';
              account.BUSINESS_UNIT__c= 'India';
            account.DTNA__c = true;
            account.CMI_CId__c = 'Test';
            account.CSS_DBCode__c = 'Test';
            account.CSS_DealerCode__c = 'Test';
            account.Type = 'Distributor Account';
            account.CMI_Account_Status__c='Expired';
            account.CSS_DistributorCode__c = '10010';
            account.IAM_Service_Provider_Code__c = '1339';
            account.CMI_CDA_Status__c='New Customer Request';
            account.Bolt_Customer_Account_Status__c = 'Active';
            account.CHANNEL_OF_DISTRIBUTION__c = Label.COD_CIHR_List.split(',')[0].substring(0,4) + Label.COD_CIHR_List.split(',')[0];
            //update account;
             //Test.startTest(); 
            ccrz__E_Order__c order = new ccrz__E_Order__c();
            order.Id = transecRes.order.id;
            order.ccrz__OrderStatus__c = 'Order Submitted';
            update order;
            
            OSM_Order_Item_License__c ParentActivationKey = new OSM_Order_Item_License__c();
            ParentActivationKey.Activation_Key__c         = 'testActivationKey';
            ParentActivationKey.CC_Order_Item__c          = transecRes.orderItem.Id;
            ParentActivationKey.Parent_Activation_Key__c  = null;
            ParentActivationKey.OMS_Item_Id__c            = '1234';
            ParentActivationKey.Tool_Instance_Key__c      = '12345';
            ParentActivationKey.Status__c                 = 'New';
            ParentActivationKey.type__c                   = 'Basic';
            insert ParentActivationKey;
            
            OSM_Order_Item_License__c orderItemLicense2 = new OSM_Order_Item_License__c();
            orderItemLicense2.Activation_Key__c         = 'testActivationKey';
            orderItemLicense2.CC_Order_Item__c          = transecRes.orderItem.Id;
            orderItemLicense2.Parent_Activation_Key__c  = ParentActivationKey.Id;
            orderItemLicense2.OMS_Item_Id__c            = '1234';
            orderItemLicense2.Tool_Instance_Key__c      = '12345';
            orderItemLicense2.Status__c                 = 'New';
            orderItemLicense2.type__c                   = 'Functional';
            insert orderItemLicense2;

            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testUser.id;
            objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            
            Map<String,OSM_Application_Feature__mdt> appF = new Map<String,OSM_Application_Feature__mdt>();
            appF.put('key', lstAppFeature);
            ccrz__E_Product__c pro = new ccrz__E_Product__c();
            
            
           ccrz__E_Product__c comp = new ccrz__E_Product__c();
            comp.QSOLType__c = 'EBU';
            comp.isIAMProvisioningRequired__c = true;
            comp.Id = transecRes.objSetupDate.componentList[0].Id;
            update comp;
            
            pro.QSOLType__c = 'EBU';
            pro.Name = 'Guidanz Mobile (Includes Immediate Assessment)';
            pro.Id = transecRes.objSetupDate.compositeProduct.Id;
            pro.ccrz__ProductType__c = 'Product';
            update pro;
            ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
            objItem.Id = transecRes.orderItem.Id;
            objItem.OMS_Product__c = true;
            objItem.ccrz__Product__c = pro.Id;
            objItem.ccrz__DisplayProduct__c = pro.Id;
            update objItem;
            
            ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
            oi1.ccrz__Price__c = 500;
            oi1.ccrz__OriginalItemPrice__c = 400;
            oi1.ccrz__Quantity__c = 1;
            oi1.ccrz__SubAmount__c = 123;
            oi1.ccrz__Order__c = order.id;
            oi1.ccrz__Product__c = pro.id;
            oi1.ccrz__Subscription_Auto_Renewal__c = true;
            oi1.ccrz__DisplayProduct__c = pro.id;
            oi1.ccrz__OrderItemStatus__c ='Cancelled';
            oi1.OMS_Product__c = true;
            oi1.Vertex_Tax__c=11;
            insert oi1;
            String orderItm =objItem.id;
            IAM_Application__c app = new IAM_Application__c(IAM_Status__c='Active',
                                                            IAM_Role__c='PrimaryContact',
                                                            IAM_Source__c = 'Marketplace',
                                                            IAM_Subscription_Count__c= 10,
                                                            IAM_Provisioned_User_Count__c=1,
                                                            IAM_Free_Subscription__c= False,
                                                            IAM_Account_Name__c = account.ID,
                                                            IAM_Subscription_Name__c='TestSubscription1',
                                                            IAM_Subscription_Start_Date__c=System.today(),
                                                            IAM_Reject_Reason__c = 'Cancellation Comments',
                                                            IAM_Subscription_End_Date__c= System.today() + 5,
                                                            IAM_Application_Name__c = 'Cummins Service Training');
            
            insert app;
            
            IAM_Application__c app2 = new IAM_Application__c(IAM_Status__c='Active',
                                                            IAM_swregExpire__c = 'test',
                                                            IAM_Role__c='PrimaryContact',
                                                            IAM_Source__c = 'Marketplace',
                                                            IAM_Subscription_Count__c= 10,
                                                            IAM_Free_Subscription__c= False,
                                                            IAM_Provisioned_User_Count__c=1,
                                                            IAM_Account_Name__c = account.ID,
                                                            IAM_Application_Name__c = 'Guidanz Mobile',
                                                            IAM_Subscription_Name__c='TestSubscription1',
                                                            IAM_Subscription_Start_Date__c=System.today(),
                                                            IAM_Reject_Reason__c = 'Cancellation Comments',
                                                            IAM_Subscription_End_Date__c= System.today() + 5);
            
            insert app2;
            
            OSM_Subscription_Account_Provision__c objSAP = new OSM_Subscription_Account_Provision__c(Subscription_Status__c = 'Active',
                                                                                                     Account_Features_Access__c = app.Id,User_Count__c=1,
                                                                                                     CC_Subscription__c = transecRes.subscription.Id);
            insert objSAP;
            
            OSM_Subscription_Account_Provision__c objSAP2 = new OSM_Subscription_Account_Provision__c(Subscription_Status__c = 'Active',
                                                                                                     Account_Features_Access__c = app2.Id,User_Count__c=1,
                                                                                                     CC_Subscription__c = transecRes.subscription.Id);
            insert objSAP2;
            
            OSM_SW_OrderDetailView_Ctrl.checkIAMUserProvisionedCount(objRemotCtx, orderItm);
            
            OSM_SW_OrderDetailView_Ctrl.createOsmIamProvisioningDetail('test',6,account,appF,'CPG','test');
            Test.stopTest();
            
        }
    }
    static testMethod void tetsMethod4() {

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

        test.StartTest();
        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.Id = transecRes.orderItem.Id;
        objItem.OMS_Product__c = true;
        objItem.OMS_Item_ID__c = 'testId';
        objItem.OMS_Activation_Key__c = 'testId';
        objItem.OSM_Tool_Instance_Key__c = 'testId';
        objItem.ccrz__Quantity__c = 5;
        objItem.Number_of_Bundles__c= 6;

        update objItem;
        //For remote action context 
        test.StopTest();
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;

        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //System.debug(ccrz.cc_CallContext.currAccountId);
        try {
            //test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();

            // Call Apex Class Methods
            //OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemoteClass, transecRes.order.id,'','');

            List < String > setId = new List < String > ();
            setId.add(transecRes.orderItem.Id);
            //OSM_SW_OrderDetailView_Ctrl.callCancelOrder(transecRes.order.id);
            OSM_SW_OrderDetailView_Ctrl.callCancelAPI(objRemoteClass, setId);
            OSM_SW_OrderDetailView_Ctrl.callRevokeAPI(objRemoteClass, setId);

            // Stop Test
            //test.StopTest();
        }
        Catch(Exception ex) {

        }
    }
    static testMethod void tetsMethod5() {

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
        test.StartTest();      
        ccrz__E_Order__c order = new ccrz__E_Order__c();
        order.Id = transecRes.order.id;
        order.ccrz__OrderStatus__c = 'Order Submitted';
        //order.Is_OMS_Revoke_and_Cancel_Not_Done_Count__c=0;
        order.OrderProcessedforFSD__c=False;
        update order;
        
        ccrz__E_Product__c pro = new ccrz__E_Product__c();
        pro.Group_Name__c = 'SES';
        pro.Name = 'Guidanz Mobile';
        pro.ccrz__SKU__c = 'INS-Pro-P-02300';
        pro.ccrz__Quantityperunit__c = 1;
        pro.ccrz__ProductType__c = 'Product';
        pro.Product_Range__c = 'Service Plus';
        pro.isIAMProvisioningRequired__c = true;
        pro.Product_Class_Code__c = 'SW-Web Access';
        pro.LicenseName__c = 'Service Plus Basic';
        pro.Id = transecRes.objSetupDate.compositeProduct.Id;
        update pro;
        ccrz__E_OrderItem__c objItem = new ccrz__E_OrderItem__c();
        objItem.Id = transecRes.orderItem.Id;
        objItem.OMS_Product__c = true;
        objItem.OMS_Item_ID__c = 'testId';
        objItem.OMS_Activation_Key__c = 'testId';
        objItem.OSM_Tool_Instance_Key__c = 'testId';
        objItem.ccrz__Quantity__c = 5;
        objItem.Number_of_Bundles__c= 6;

        update objItem;
        
        ccrz__E_OrderItem__c oi1 = new ccrz__E_OrderItem__c();
        oi1.ccrz__Price__c = 500;
        oi1.ccrz__OriginalItemPrice__c = 400;
        oi1.ccrz__Quantity__c = 1;
        oi1.ccrz__SubAmount__c = 123;
        oi1.ccrz__Order__c = order.id;
        oi1.ccrz__Product__c = transecRes.objSetupDate.compositeProduct.Id;
        oi1.ccrz__Subscription_Auto_Renewal__c = true;
        oi1.ccrz__DisplayProduct__c =transecRes.objSetupDate.compositeProduct.Id;
        oi1.ccrz__OrderItemStatus__c ='Cancelled';
        oi1.OMS_Product__c = true;
        oi1.Vertex_Tax__c=11;
        insert oi1;
    
        //test.StopTest();
    
        //For remote action context 
        set<id> lstOrderItem = new set<id>();
        lstOrderItem.add(oi1.id);
        ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
        objRemotCtx.storefront = 'SoftwareStore';
        objRemotCtx.currentCartId = transecRes.cart.ccrz__EncryptedId__c;
        objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
        String orderItm =objItem.id;
        ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
        //System.debug(ccrz.cc_CallContext.currAccountId);
        try {
           // test.StartTest();
            // Create RemoteActionContext Class Data 
            ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
            OSM_SW_OrderDetailView_Ctrl.getOrderInformation(objRemotCtx, orderItm,'','');
            // Call Apex Class Methods
            //OSM_SW_MyOrders_Comp_Ctrl.getOrderInfo(objRemoteClass, transecRes.order.id,'','');

            List < String > setId = new List < String > ();
            setId.add(transecRes.orderItem.Id);
            //OSM_SW_OrderDetailView_Ctrl.callCancelOrder(transecRes.order.id);
            //OSM_SW_OrderDetailView_Ctrl.callCancelAPI(objRemoteClass, setId);
            //OSM_SW_OrderDetailView_Ctrl.callRevokeAPI(objRemoteClass, setId);
            OSM_SW_OrderDetailView_Ctrl.callCancelOrderItem(lstOrderItem);
            ccrz__E_Product__c prod = new ccrz__E_Product__c();
            prod.QSOLType__c = 'EBU';
            prod.Name = 'Guidanz Mobile (Includes Immediate Assessment)';
            prod.Id = transecRes.objSetupDate.compositeProduct.Id;
            prod.ccrz__ProductType__c = 'Product';
            prod.Group_Name__c = 'FluidWatch' ;
            update prod;
            ccrz__E_OrderItem__c objItem1 = new ccrz__E_OrderItem__c();
            objItem1.Id = transecRes.orderItem.Id;
            objItem1.OMS_Product__c = true;
            objItem1.OMS_Item_ID__c = 'testId';
            objItem1.OMS_Activation_Key__c = 'testId';
            objItem1.OSM_Tool_Instance_Key__c = 'testId';
            objItem1.ccrz__Quantity__c = 5;
            objItem1.Number_of_Bundles__c= 6;
            objItem1.ccrz__Product__c=prod.id;
            update objItem1;
            List < String > setId1 = new List < String > ();
            setId1.add(objItem1.Id);
            OSM_SW_OrderDetailView_Ctrl.callCancelAPI(objRemoteClass, setId1);
            test.StopTest();
        }
        Catch(Exception ex) {

        }
    }
    
    
    static testMethod void tetsMethod6() {
        OSM_SW_OrderDetailView_Ctrl.TransactionDetail trns = new OSM_SW_OrderDetailView_Ctrl.TransactionDetail();
        trns.transactionId = 'abc';
        trns.cancelTransactionId = 'abc';
        trns.paymentMethod = 'abc';
        trns.refundStatus = 'abc';
        trns.orderStatus = 'abc';
        trns.activationKey = 'abc';
        trns.accountName = 'abc';
        OSM_SW_OrderDetailView_Ctrl.OSM_IAMProvisioningDetails ismP = new OSM_SW_OrderDetailView_Ctrl.OSM_IAMProvisioningDetails();
        Id abcId = '01p610000094po7';
        ismP.accountID = abcId ;
        ismP.subscriptionID = abcId ;
        ismP.productName = 'defg';
        ismP.status = 'defg';
        ismP.accountGroupName = 'defg';
        ismP.accountType = 'defg';
        ismP.roleFeature = 'defg';
        ismP.applicationName = 'defg';
        ismP.subscriptionName = 'defg';
        ismP.qsolType = 'defg';
        ismP.roleFeatureList = new List<String>{'ashish'};
        ismP.userCount = 1;
        ismP.startDate = System.today().addDays(-2);
        ismP.endDate = System.today().addDays(2);
        OSM_SW_OrderDetailView_Ctrl.OrderDetail ord = new OSM_SW_OrderDetailView_Ctrl.OrderDetail();
    }
    
    static testMethod void testMthd7(){
        Account testaccount = new Account();
        testAccount.Name = 'testacc';
        testAccount.BillingStreet = 'Street';
        testAccount.BillingCity = 'City';
        testAccount.BillingState = '';
        testAccount.BOLT_Account_Number__c = '999';
        testAccount.BillingPostalCode = '11000';
        testAccount.BillingCountry = 'United States';
        testAccount.CMI_Region__c = 'India';
        testAccount.CSS_Locale__c = 'English(India)';
        testAccount.RecordTypeId = OSM_TestDataCreationUtility.getAccountRecordTypeID();
        testAccount.OwnerId = OSM_TestDataCreationUtility.getSystemAdministratorID();
        testAccount.CSS_Timezone__c = '(GMT+05:30) India Standard Time (Asia/Kolkata)';
        testAccount.CSS_DistributorCode__c = '02850';
        testAccount.CSS_DBCode__c = '020400';
        testAccount.BMS_Customer_ID__c = '22925';
        testAccount.Customer_Location_Code__c = '123';

        insert testAccount;

        Contact contact1 = new Contact(
            FirstName = 'Test',
            Lastname = 'McTesty',
            AccountId = testAccount.Id, Username__c = 'testqwerty123@gmail.com',
            Email = System.now().millisecond() + 'test@test.com',
            recordtypeid=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('IAM').getRecordTypeId()
        );
        insert contact1;
        ccrz__E_Product__c product = new ccrz__E_Product__c();

        product.name = 'CA Base-DEF';
        product.ccrz__ProductStatus__c = 'Released';
        product.ccrz__Quantityperunit__c = 1;
        product.ccrz__SKU__c = '5678901-DEF';
        product.ccrz__StartDate__c = System.today().addMonths(-1);
        product.ccrz__EndDate__c = System.today().addMonths(4);
        product.Group_Name__c = 'FluidWatch';
        product.ccrz__LongDesc__c = 'Long Description';
        product.ccrz__ProductType__c = 'Product';
        product.Product_Class_Code__c = 'SW-Web Access';

        insert product;

        ccrz__E_SubProdTerm__c testSubProdTerm = new ccrz__E_SubProdTerm__c();
        testSubProdTerm.name = 'SubProd';
        testSubProdTerm.ccrz__EffectiveStart__c = System.today().addMonths(-1);
        testSubProdTerm.ccrz__EffectiveEnd__c = System.today().addMonths(4);
        testSubProdTerm.ccrz__CCProduct__c = product.id;
        testSubProdTerm.Operation__c = '*';
        testSubProdTerm.ccrz__Enabled__c = true;
        testSubProdTerm.ccrz__Storefront__c = 'SoftwareStore';
        testSubProdTerm.Billing_Display_Name__c = 'Monthly';
        insert testSubProdTerm;

        ccrz__E_PriceList__c testPriceList = new ccrz__E_PriceList__c();
        testPriceList.Name = 'DEF_PL';
        testPriceList.ccrz__StartDate__c = System.today().addMonths(-1);
        testPriceList.ccrz__EndDate__c = System.today().addMonths(5);
        testPriceList.ccrz__CurrencyISOCode__c = 'USD';
        testPriceList.ccrz__Enabled__c = true;
        testPriceList.ccrz__Storefront__c = 'SoftwareStore';
        insert testPriceList;

        ccrz__E_PriceListItem__c priceListItem = new ccrz__E_PriceListItem__c();
        priceListItem.ccrz__SubProdTerm__c = testSubProdTerm.id;
        priceListItem.ccrz__Product__c = product.id;
        priceListItem.ccrz__Price__c = 10;
        priceListItem.Distributor_Price__c = 0;
        priceListItem.ccrz__Pricelist__c = testPriceList.id;
        priceListItem.ccrz__RecurringPrice__c = false;
        insert priceListItem;

        List < ccrz__E_Cart__c > lstECart = new List < ccrz__E_Cart__c > ();
        ccrz__E_Cart__c testCart = new ccrz__E_Cart__c();
        testCart.ccrz__Storefront__c = 'Software';
        testCart.ccrz__CartType__c = 'Cart';
        testCart.ccrz__ActiveCart__c = true;
        testCart.ccrz__CartStatus__c = 'Open';
        testCart.ccrz__User__c = UserInfo.getUserId();
        testCart.ccrz__EncryptedId__c = 'encrypt';
        testCart.Third_Party_BMS_Customer_ID__c = '12345';
        testCart.OSM_SW_Is_third_Party_BMS_Payment__c = true;
        lstECart.add(testCart);
        insert lstECart;

        ccrz__E_CartItem__c testCartItem = new ccrz__E_CartItem__c();
        testCartItem.ccrz__Cart__c = lstECart[0].id;
        testCartItem.ccrz__Quantity__c = 10;
        testCartItem.ccrz__OriginalQuantity__c = 11;
        testCartItem.ccrz__Product__c = Product.id;
        testCartItem.ccrz__SubProdTerm__c = testSubProdTerm.id;
        testCartItem.ccrz__Price__c = 15;
        testCartItem.ccrz__RecurringPrice__c = 25;
        testCartItem.ccrz__RecurringPriceSubAmt__c = 12;
        testCartItem.ccrz__StoreID__c = 'SoftwareStore';
        testCartItem.ccrz__OriginalItemPrice__c = 100;
        testCartItem.ccrz__DisplayProduct__c = Product.Id;
        testCartItem.ccrz__ProductType__c = 'Product';
        testCartItem.ccrz__cartItemType__c = 'Major';
        testCartItem.ccrz__SubAmount__c = 10;
        testCartItem.ccrz__Subscription_Duration__c = 12;
        testCartItem.ccrz__Subscription_Frequency__c = 4;
        testCartItem.ccrz__UnitOfMeasure__c = 'EA';
        insert testCartItem;

        CC_Tax__c tax = new CC_Tax__c();
        tax.CalculatedTax__c = '10';
        tax.CC_Cart_Item__c = testCartItem.id;
        tax.EffectiveRate__c = '10';
        tax.JurisdictionId__c = '1112';
        tax.JurisdictionLevel__c = 'CITY';
        tax.NonTaxable__c = '123';
        tax.Taxable__c = '123';
        tax.Discount_Amount__c = 1;
        insert tax;

        ccrz__E_ContactAddr__c contactAddress = new ccrz__E_ContactAddr__c();
        contactAddress.Account__c = testAccount.id;
        contactAddress.ccrz__AddressFirstline__c = '1460 N National Rd';
        contactAddress.ccrz__City__c = 'Scottsdale';
        contactAddress.ccrz__State__c = 'Arizona';
        contactAddress.ccrz__StateISOCode__c = 'AZ';
        contactAddress.ccrz__PostalCode__c = '85259';
        contactAddress.ccrz__CountryISOCode__c = 'US';
        insert contactAddress;

        ccrz__E_Order__c testOrder = new ccrz__E_Order__c();
        testOrder.ccrz__Name__c = 'TestOrder';
        testOrder.ccrz__Contact__c = contact1.id;
        testOrder.ccrz__Account__c = testAccount.Id;
        testOrder.BMS_BranchLocation__c = 'E4';
        testOrder.Order_Source_Type__c = 'OSM';
        testOrder.BMS_OrderRefNumber__c = 12345;
        
        testOrder.ccrz__OriginatedCart__c = testCart.id;
        testOrder.ccrz__BillTo__c = contactAddress.id;
        testOrder.ccrz__ShipTo__c = contactAddress.id;
        insert testOrder;

        List < ccrz__E_OrderItem__c > testOrderItemList = new List < ccrz__E_OrderItem__c > ();
        ccrz__E_OrderItem__c testOrderItem = new ccrz__E_OrderItem__c();
        testOrderItem.ccrz__Order__c = testOrder.id;
        testOrderItem.ccrz__Product__c = product.id;
        testOrderItem.ccrz__Price__c = 450;
        testOrderItem.ccrz__Quantity__c = 2;
        testOrderItem.ccrz__SubAmount__c = 200;
        testOrderItem.ccrz__SubProdTerm__c = testSubProdTerm.id;
        testOrderItemList.add(testOrderItem);
        insert testOrderItemList;

        ccrz__E_Invoice__c ccInvoices = new ccrz__E_Invoice__c();
        ccInvoices.ccrz__CCOrder__c = testOrder.id;
        ccInvoices.ccrz__Contact__c = contact1.id;
        ccInvoices.ccrz__CurrencyCode__c = 'USD';
        ccInvoices.ccrz__Status__c = 'Open';
        ccInvoices.ccrz__Storefront__c = 'Software';
        ccInvoices.ccrz__DateIssued__c = System.today().addMonths(2);
        ccInvoices.ccrz__OriginalAmount__c = 200;
        ccInvoices.ccrz__Terms__c = 'TestDataTerms';
        ccInvoices.BMS_PONumber__c = '123456';
        ccInvoices.BMS_InvoiceNumber__c = 123456;
        insert ccInvoices;
        
        Test.startTest();        
        ccrz.cc_RemoteActionContext objRemoteClass = new ccrz.cc_RemoteActionContext();
        OSM_SW_OrderDetailView_Ctrl.callRefundReq(objRemoteClass, new List<String>{testOrderItemList.get(0).Id}, new List<String>());
        OSM_SW_OrderDetailView_Ctrl.callCreateCreditMemo(objRemoteClass, new List<String>{testOrderItemList.get(0).Id},new List<String>{testOrderItemList.get(0).Id},new List<String>{testOrderItemList.get(0).Id});
        Test.stopTest();
    }
        static testMethod void tetsMethod90() {  
        TestProductSetupReq testReq = new TestProductSetupReq();
        testReq.permissionSetName = 'OSM_Support_Admin';
        testReq.accountGroupName = 'TestingAccountGroup';
        testReq.accountName = 'TestingAccount';
        testReq.compositeProductName = 'Connected Diagnostics';
        testReq.compositeProductSKU = '1234567-BUS';
        testReq.compositeProductGroupName = 'SES';
        testReq.compositeProductProductType = 'Aggregated';
        testReq.componentProductName = 'CD Base-BUS';
        testReq.componentProductStatus = 'Released';
        testReq.componentProductSKU = '1301298-BUS';
        testReq.componentProductGroupName = 'SES';
        testReq.componentProductPackageName = 'Base';
        testReq.priceListName = 'TestPriceList';
        testReq.specName = 'TestName';

        TestCompletedTransactionSetUpRes transecRes = new TestCompletedTransactionSetUpRes();
        transecRes = OSM_TestDataCreationUtility.createProductSetUp(testReq);

          Id portal_PROFILE_ID = [SELECT Id FROM Profile WHERE Name = 'IAM_Site_Admin_Community' Limit 1 ].Id;
          //Id roleId=[select id,name from UserRole where name='CumminsFleetsCustomerUser' limit 1].id; 
           
         UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
          system.debug('portalRole is ' + portalRole);

          Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
          User portalAccountOwner2 = new User(
          UserRoleId = portalRole.Id,
          ProfileId = profile1.Id,
          Username ='test24446@test.com',
          Alias = 'batman',
          Email='bruce.wayne@wayneenterprises.com',
          EmailEncodingKey='UTF-8',
          Firstname='Bruce',
          Lastname='Wayne',
          LanguageLocaleKey='en_US',
          LocaleSidKey='en_US',
          TimeZoneSidKey='America/Chicago'
          );
          Database.insert(portalAccountOwner2);
          Account portalAccount2 = new Account(
          Name = 'TestAccount2',
          OwnerId = portalAccountOwner2.Id,
          OSM_Preferred_Billing_Frequency_Lock__c=false,
          BMS_Customer_ID__c='1234',
          OSM_Preferred_Payment_Method__c='po',
          OSM_Preferred_Payment_IsBolt_PO__c=false
          );
          System.runAs(portalAccountOwner2){
              Database.insert(portalAccount2);
          }

          //Create contact
          Contact contact1 = new Contact(
          FirstName = 'Test',
          Lastname = 'McTesty',
          Username__c = 'testUserName7789@gmail.com',
          AccountId = portalAccount2.Id,
          IAM_Contact_Status__c='Pending',
          Email ='test@test.com'
          );
          System.runAs(portalAccountOwner2){
              Database.insert(contact1);
          } 
          
          User testUser = new User();
          testUser.FirstName = 'Testttt';
          testUser.LastName = 'lasttt';
          testUser.UserName = 'test2@test.com';
          testUser.Email = 'bruce.wayne@wayneenterprises.com';
          testUser.Alias = 'batman';
          testUser.ContactId = contact1.Id;
          testUser.CommunityNickname = 'test12345h';
          testUser.ProfileId =portal_PROFILE_ID;
          testUser.TimeZoneSidKey = 'America/Los_Angeles';
          testUser.isActive = true;
          testUser.LocaleSidKey = 'en_US';
          testUser.LanguageLocaleKey = 'en_US';
          testUser.EmailEncodingKey = 'ISO-8859-1';
            System.runAs(portalAccountOwner2){
                  insert testUser;
            
          }
        // Creating address
        System.runAs(portalAccountOwner2) {
           
            ccrz__E_Order__c order = new ccrz__E_Order__c();
            order.Id = transecRes.order.id;
            order.ccrz__OrderStatus__c = 'Order Submitted';
            update order;
            ccrz__E_Product__c pro = new ccrz__E_Product__c();
            pro.Group_Name__c = 'SES';
            pro.Name = 'Service Tech Kit';
            pro.ccrz__SKU__c = 'INS-Pro-P-02300';
            pro.ccrz__Quantityperunit__c = 1;
            pro.ccrz__ProductType__c = 'Product';
            pro.Product_Range__c = 'Service Plus';
            pro.isIAMProvisioningRequired__c = true;
            pro.Product_Class_Code__c = 'SW-Web Access';
            pro.LicenseName__c = 'Service Plus Basic';
            //pro.Id = transecRes.objSetupDate.compositeProduct.Id;
            insert pro;
			
			
			
            ccrz__E_Product__c pro1 = new ccrz__E_Product__c();
            pro1.Group_Name__c = 'SES';
            pro1.ccrz__SKU__c = 'INS-Pro-P-023002';
            pro1.ccrz__Quantityperunit__c = 1;
            pro1.ccrz__ProductType__c = 'Bundle';
            pro1.Id = transecRes.objSetupDate.componentList[0].Id;
            update pro1;
			
			ccrz__E_RelatedProduct__c relObj = new ccrz__E_RelatedProduct__c();
			relObj.ccrz__Product__c = transecRes.objSetupDate.componentList[0].Id;
			relObj.ccrz__RelatedProduct__c = pro.Id;
			relObj.ccrz__RelatedProductType__c = 'Accessories';
			relObj.ccrz__StartDate__c = System.Today();
			relObj.ccrz__EndDate__c = System.Today()+1;
			relObj.ccrz__Enabled__c = true;
			
			insert relObj;
			
			
            
            ccrz.cc_RemoteActionContext objRemotCtx = new ccrz.cc_RemoteActionContext();
            //objRemotCtx.portalUserId = transecRes.objSetupDate.objUserID;
            objRemotCtx.portalUserId = testUser.id;
             objRemotCtx.effAccountId = transecRes.objSetupDate.account.Id;
            ccrz.cc_CallContext.initRemoteContext(objRemotCtx);
            
            List<String> orderItemIdlst = new List<String>();
            List<String> orderItemIdlst2 = new List<String>();
            orderItemIdlst.add(transecRes.orderItem.Id);
            
            Test.startTest();
            
				List<String> lstStr = new List<String>();
				lstStr.add(transecRes.orderItem.Id);
				OSM_SW_OrderDetailView_Ctrl.checkAddOnSubscription(objRemotCtx,transecRes.orderItem.Id);

            Test.stopTest();
           
            
        }
          
    
    } 
}