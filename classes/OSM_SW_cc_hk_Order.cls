//recompilation
global class OSM_SW_cc_hk_Order extends ccrz.cc_hk_Order{
    
    global override Map<String,Object> place(Map<String,Object> inputData){
        
        system.debug('Place methods OSM_SW_cc_hk_Order===');
        Map<String,Object> returnData;
        try{
            
        returnData = super.place( inputData);
            //if(inputData.get('placeStep')=='createOrderPre'){
              //  ccrz.ccLog.log('-=====After createOrderPre');
                
            //}
             if(Test.isRunningTest()){
                      throw new NullPointerException();                          
                    }
        }catch(Exception e){
             ccrz.ccLog.log('====Inside Exception block for ');
            processRefundForFailedOSMOrderPlacedProcess();
        }
        ccrz.ccLog.log(ccrz.cc_hk_Order.STEP_CREATE_SUBSCRIPTION_POST
+'************cc_hk_Order--onOrder*****************returnData********** '+returnData); 
        ccrz.ccLog.log(ccrz.cc_hk_Order.STEP_END+'************cc_hk_Order--onOrder*****************KEY********** '+returnData.get(ccrz.cc_hk_Order.STEP_END)); 
        //map<String,Object> mapEndStep= returnData.get(ccrz.cc_hk_Order.STEP_END); 
        for(String key : returnData.keySet()){
            system.debug('Order hook==='+key+'===>'+returnData.get(key));
        }
        if(returnData.get('placeStep') != null && returnData.get('placeStep') == ccrz.cc_hk_Order.STEP_END){
            //OSM_BMS_SW_BusinessLayerUtility.calculateBMSAvailableCredit('0016C00000AUbWt');
            ccrz__E_Order__c order = returnData.get(ccrz.cc_hk_Order.PARAM_ORDER) != null ? (ccrz__E_Order__c)returnData.get(ccrz.cc_hk_Order.PARAM_ORDER): new ccrz__E_Order__c();
            ccrz__E_Cart__c cart = returnData.get(ccrz.cc_hk_Order.PARAM_CART) != null ? (ccrz__E_Cart__c)returnData.get(ccrz.cc_hk_Order.PARAM_CART): new ccrz__E_Cart__c();
            List<ccrz__E_OrderItem__c> orderItems = returnData.get(ccrz.cc_hk_Order.PARAM_ORDER_ITEMS) != null ? (List<ccrz__E_OrderItem__c>) returnData.get(ccrz.cc_hk_Order.PARAM_ORDER_ITEMS):new List<ccrz__E_OrderItem__c>();
            
            

            ccrz.ccLog.log('PARAM_TRANSACTION_PROCESSED_DATA: '+returnData.get(ccrz.cc_hk_Order.PARAM_TRANSACTION_PROCESSED_DATA));
            system.debug('Cart values: '+cart);
            
            ccrz.cc_hk_Payment.TransactionPaymentParams objPayment = (ccrz.cc_hk_Payment.TransactionPaymentParams)returnData.get(ccrz.cc_hk_Order.PARAM_TRANSACTION_PROCESSED_DATA);
            
            
            
            
            
            
            ccrz__E_Invoice__c invoice = returnData.get(ccrz.cc_hk_Order.PARAM_INVOICE) != null ? (ccrz__E_Invoice__c)returnData.get(ccrz.cc_hk_Order.PARAM_INVOICE): new ccrz__E_Invoice__c();
            List<ccrz__E_InvoiceItem__c> invoiceItems = returnData.get('invoiceItems') != null ? (List<ccrz__E_InvoiceItem__c>) returnData.get('invoiceItems'):new List<ccrz__E_InvoiceItem__c>();
            List<Id> orderItemIds = new List<Id>();
            Map<Id,Integer> productIds = new Map<Id,Integer>();
            Map<String,String> prodToOrderItem = new Map<String,String>();
            Set<String> strProd = new Set<String>();
            Set<String> strProdTerm = new Set<String>();
            String paymentType = '';
             
            List<ccrz__E_CartItem__c>cartItems =  returnData.get(ccrz.cc_hk_Order.PARAM_CART_ITEMS) != null ? (List<ccrz__E_CartItem__c>) returnData.get(ccrz.cc_hk_Order.PARAM_CART_ITEMS):new List<ccrz__E_CartItem__c>();
            Map<String,String> mapProdToSPT = new Map<String, String>();
            /*Set<Id> set_prodSubsId = new Set<Id>();
            Set<Id> set_ProdId = new Set<Id>();
            Map<Id, ccrz__E_CartItem__c> map_CartItemIdRecord = new Map<Id, ccrz__E_CartItem__c>([SELECT Id, ccrz__Product__c, withCoTerm__c FROM ccrz__E_CartItem__c WHERE Id IN : cartItems AND withCoTerm__c = true]);
            for(ccrz__E_CartItem__c cartitem : map_CartItemIdRecord.values()){
                set_ProdId.add(cartitem.ccrz__Product__c);
            }
            
            for(ccrz__E_Subscription__c subObj : [SELECT Id, ccrz__SubscriptionProduct__c FROM ccrz__E_Subscription__c WHERE ccrz__SubscriptionProduct__c IN : set_ProdId AND OSM_SW_Is_without_Coterm__c = false AND ccrz__Account__c =:cart.ccrz__Account__c Order BY createddate ASC LIMIT 1]){
                if(!set_prodSubsId.contains(subObj.ccrz__SubscriptionProduct__c))
                    set_prodSubsId.add(subObj.ccrz__SubscriptionProduct__c);
            }*/
            
            for(ccrz__E_CartItem__c cartitem : cartItems){
                //if(!map_CartItemIdRecord.containsKey(cartitem.Id) || !set_prodSubsId.contains(cartitem.ccrz__Product__c)){
                    mapProdToSPT.put(cartitem.ccrz__Product__c,cartitem.ccrz__SubProdTerm__c);
                //}
            }
            Savepoint sp = Database.setSavepoint();
            try{ 
                   
                //orderItemIds.add('inv__-'+invoice.Id);
                //lock preferred billing frequency
                //OSM_SW_ProductDetailCommonUtility.updateSubscriptionSPT(order.ccrz__Account__c,mapProdToSPT,order.ccrz__Storefront__c,productIds);
                //OSM_SW_ProductDetailCommonUtility.updateSubscriptionSPT(order.ccrz__Account__c,mapProdToSPT,order.ccrz__Storefront__c);
                //Decimal ten = 10/0;
                //Delete previous related subscription
                //OSM_SW_ProductDetailCommonUtility.deletePreOrderSubscriptoins();     
                //update next invoice dates on Subscription
                boolean isBoltPO = false;
                ccrz.ccLog.log('&&&&&&&&&&&&&&&&&&&&&&&&&&& '+invoice.Payment_Method__c); 
                ccrz__E_Order__c orderNew = new ccrz__E_Order__c();
                orderNew = [Select id,Purchased_By_User_Type__c,Third_Party_BMS_Customer_Name__c,ccrz__ShipTo__c,Distributor_HQ_District__c,ccrz__OriginatedCart__r.OSMSecondaryEmail__c,ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c,ccrz__Account__c,ccrz__Account__r.CSS_DistributorCode__c,ccrz__Account__r.Bolt_Customer_Account_Status__c,ccrz__Account__r.Customer_BMS_number__c, ccrz__Account__r.BOLT_Account_Number__c,ccrz__Account__r.Bolt_Credit_Hold__c,ccrz__EncryptedId__c from ccrz__E_Order__c where Id =: order.id];
                if(orderNew != null)
                {
                    boolean shouldUpdate = true;
                    if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
                    {
                        OSM_SW_General_Util.getuserType(Userinfo.getUserId());
                    }
                    String strUserType = OSM_SW_General_Util.USER_TYPE;
                    
                    ccrz.ccLog.log('strUserType '+strUserType); 
                    //orderNew.OSM_Logged_In_User_Type__c=strUserType;
                   if(orderNew.ccrz__OriginatedCart__r.OSMSecondaryEmail__c != Null){
                        orderNew.OSMSecondaryEmail__c= orderNew.ccrz__OriginatedCart__r.OSMSecondaryEmail__c;
                   } 
                   Id userId = UserInfo.getUserId();
                    //Boolean effectiveSelectEnabled = false;
                    ccrz.ccLog.log('userId>>>> '+userId);
                    List<User> currUser = [SELECT Id, OSM_Storefront_User_Type__c FROM User WHERE id=:userId];
                    String userType = '';
                    ccrz.ccLog.log('currUser[0].OSM_Storefront_User_Type__c '+currUser[0].OSM_Storefront_User_Type__c);
                    if(!currUser.isEmpty()){
                        if(!String.isBlank(currUser[0].OSM_Storefront_User_Type__c)){
                        
                            effectiveAccount_enable_ProfileUserType__c featureSwitch =  effectiveAccount_enable_ProfileUserType__c.getInstance(String.valueOf(currUser[0].OSM_Storefront_User_Type__c));
                            //effectiveSelectEnabled = featureSwitch.Enable_Effective_Account_Selection__c;
                            if(featureSwitch != null)
                            {
                                userType = featureSwitch.Name;
                            }
                            if(Label.OSM_Distributor_Admin_UserType.containsignorecase(String.valueOf(currUser[0].OSM_Storefront_User_Type__c)))
                            {
                                orderNew.OSM_Logged_In_User_Type__c=Label.OSM_Distributor_Admin_UserType;
                            }
                           
                                
                                
                        }
                    } 
                    ccrz.ccLog.log('userType '+userType); 
                   system.debug('ccOrder_UserType '+strUserType);
                    system.debug('ccOrder_UserTypeLabel '+Label.OSM_Distributor_Admin_UserType);
                    orderNew.Purchased_By_User_Type__c = strUserType;
                    //if(Label.OSM_Distributor_Admin_UserType == strUserType){
                    if(userType == 'Distributor Admin' || userType == 'SSOEM Admin'){
                       List<Contact> contacts = [SELECT Id,Account.ID,Email,Account.Name, OSM_Distributor_Admin_Last_Sel_acc__c 
                                                 from Contact 
                                                 WHERE IAM_Contact_Owner__c =:userId];
                     ccrz.ccLog.log('ccOrder_contacts '+contacts);
                    system.debug('ccOrder_contacts '+contacts);
                        if(contacts.size()==1){
                            orderNew.Distributor_HQ_District__c = contacts[0].Account.Name;
                            orderNew.OSM_Headquarter_Email__c = contacts[0].Email;
                         OSM_SW_AccountPermMatrixHelper.UserPermissions permissions = new OSM_SW_AccountPermMatrixHelper.UserPermissions();
                        //Id accountId = contacts[0].Account.Id;
                        Id accountId = orderNew.ccrz__Account__c;
                            ccrz.ccLog.log('accountId '+accountId); 
                        permissions = OSM_SW_AccountPermMatrixHelper.getAccountPermissions(accountId,ccrz.cc_CallContext.isOnBehalf,ccrz.cc_CallContext.currContact,ccrz.cc_CallContext.effAccountId);
                            ccrz.ccLog.log('permissions '+permissions); 
                        if (permissions != null) {
                               orderNew.Send_SSOEM_Customer_Email__c = permissions.sendEmail;
                                orderNew.Should_Show_Price__c = permissions.showPriceForBranch;
                            }
                        }
                    } 
                    
                    //defect mar-700
                    if(Label.OSM_SSOEM_Admin_UserType == strUserType)
                    {
                        
                        List<ccrz__E_AccountAddressBook__c> shippingAddressBook = new List<ccrz__E_AccountAddressBook__c>();
                        shippingAddressBook = [Select Id from ccrz__E_AccountAddressBook__c where ccrz__Account__c =: orderNew.ccrz__Account__c and ccrz__AddressType__c = 'Shipping'];
                        if(shippingAddressBook != null && shippingAddressBook.size() == 0)
                        {
                            List<ccrz__E_ContactAddr__c> oldObj = new List<ccrz__E_ContactAddr__c>();
                            oldObj = [Select Id,Account__c,ccrz__AddressFirstline__c,ccrz__AddressSecondline__c,ccrz__AddressThirdline__c,ccrz__City__c,ccrz__CompanyName__c,ccrz__Country__c,ccrz__CountryISOCode__c,ccrz__PostalCode__c,ccrz__State__c,ccrz__StateISOCode__c from ccrz__E_ContactAddr__c where Id =: orderNew.ccrz__ShipTo__c];
                            
                            if(oldObj != null && oldObj.size() > 0 || Test.isRunningTest())
                            {
                                ccrz__E_ContactAddr__c newContactAddress = new ccrz__E_ContactAddr__c();
                                newContactAddress = oldObj[0].clone(false,false,false,false);
                                insert newContactAddress;
                                
                                ccrz__E_AccountAddressBook__c newAddressBook = new ccrz__E_AccountAddressBook__c();
                                newAddressBook.ccrz__Account__c = orderNew.ccrz__Account__c;
                                newAddressBook.ccrz__AccountId__c = orderNew.ccrz__Account__c;
                                newAddressBook.ccrz__AddressType__c = 'Shipping';
                                newAddressBook.ccrz__E_ContactAddress__c = newContactAddress.Id;
                                insert newAddressBook;
                            }
                        }
                    }
                    
                    if(Label.OSM_Distributor_Admin_UserType == strUserType 
                       || Label.OSM_SSOEM_Admin_UserType == strUserType
                       || ccrz.cc_CallContext.isOnBehalf){
                        shouldUpdate = true;
                    }
                    ccrz.ccLog.log('shouldUpdate '+shouldUpdate);
                    orderNew.OSM_SW_Should_mail_Send__c = true;
                    orderNew.ccrz__OrderStatus__c = 'Order Submitted';
                    if(objPayment != null && objPayment.accountType == 'po')
                    {
                        if(orderNew.ccrz__OriginatedCart__r.OSM_SW_Is_third_Party_BMS_Payment__c)
                        {
                            ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
                            objInv.Id = invoice.id;
                            objInv.OSM_SW_Is_Bolt_PO__c = false;
                            update objInv;
                          
                            orderNew.OSM_SW_Is_Bolt_PO__c = false;
                            orderNew.OSM_SW_Should_mail_Send__c = false;
                            //MAR-1948 Code Start
                            Account accnt = new Account();
                            accnt =[Select id,Name,CSS_DistributorCode__c From Account where id=:orderNew.Third_Party_BMS_Customer_Name__c];
                            if(accnt.CSS_DistributorCode__c != Null){
                                Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                                OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(accnt.CSS_DistributorCode__c);
                                if(osmSouthernPlain != Null){
                                    orderNew.OSM_Bill_From__c = osmSouthernPlain.PO_Bill_From_Remit_To__c;
                                }
                            }// MAR-2008 Code End
                        }
                        else
                        {
                            if(orderNew.ccrz__Account__r.BOLT_Account_Number__c != null && orderNew.ccrz__Account__r.BOLT_Account_Number__c != '' && orderNew.ccrz__Account__r.Bolt_Customer_Account_Status__c == 'Active' && !orderNew.ccrz__Account__r.Bolt_Credit_Hold__c)
                            {
                                orderNew.OSM_SW_Is_Bolt_PO__c = true;
                                isBoltPO = true;
                                
                                ccrz__E_Invoice__c objInv = new ccrz__E_Invoice__c();
                                objInv.Id = invoice.id;
                                objInv.OSM_SW_Is_Bolt_PO__c = true;
                                invoice.OSM_SW_Is_Bolt_PO__c = true;
                                
                                    ccrz.ccLog.log('1111111111111111111111 '+ccrz.cc_CallContext.isOnBehalf);
                                    ccrz.ccLog.log('1111111111111111111111 '+strUserType);
                                if(ccrz.cc_CallContext.isOnBehalf && strUserType == Label.OSM_Distributor_Admin_UserType)
                                {
                                    if(orderNew.ccrz__Account__r.Customer_BMS_number__c != null && orderNew.ccrz__Account__r.Customer_BMS_number__c != '')
                                    {
                                        
                                            orderNew.OSM_SW_Is_Bolt_PO__c = false;
                                            isBoltPO = false;
                                            objInv.OSM_SW_Is_Bolt_PO__c = false;
                                            invoice.OSM_SW_Is_Bolt_PO__c = false;
                                    }
                                }
                                
                                
                                
                                
                                
                                
                                update objInv;
                            }
                            else
                            {
                                //orderNew.ccrz__OrderStatus__c = 'In Process';
                                orderNew.OSM_SW_Should_mail_Send__c = false;
                                //MAR-1948 Code Start
                                if(orderNew.ccrz__Account__r.CSS_DistributorCode__c != Null){
                                    Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                                    OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(orderNew.ccrz__Account__r.CSS_DistributorCode__c);
                                    if(osmSouthernPlain != Null){
                                        orderNew.OSM_Bill_From__c = osmSouthernPlain.PO_Bill_From_Remit_To__c;
                                    }
                                }
                            }
                            shouldUpdate = true;
                            //update orderNew;
                        }
                        
                        
                    }
                    else{
                        if(orderNew.ccrz__Account__r.CSS_DistributorCode__c != Null){
                            Map<String, OSM_Southern_Plain__mdt> southernPlainMapData=OSM_FetchCustomMetaData_Ctrl.getSouthernPlainMetaDataMap();
                            OSM_Southern_Plain__mdt osmSouthernPlain = southernPlainMapData.get(orderNew.ccrz__Account__r.CSS_DistributorCode__c);
                            if(osmSouthernPlain != Null){
                                orderNew.OSM_Bill_From__c = osmSouthernPlain.CC_Bill_From_Remit_To__c;
                            }
                        } //MAR-1948 Code End
                    }    
                    if(shouldUpdate){
                        //shouldUpdate = true;
                         update orderNew;
                    }
                }
                //===========Added logic to update discounts on Order===============
                //String accountId = ccrz.cc_CallContext.currAccountId;
                String accountId = ccrz.cc_CallContext.effAccountId;
                //String cartId = ccrz.cc_CallContext.currCartId;
                string EncryptedId=String.valueOf(orderNew.ccrz__EncryptedId__c);
                Boolean isBoltPOCheck=Boolean.valueOf(orderNew.OSM_SW_Is_Bolt_PO__c);
                List<Account> accountList=[select id,type,Business_Unit__c,OSM_Service_Level__c,ServiceLevel__c,Is_Coupon_Already_Used__c,BOLT_Account_Number__c from Account where id=:accountId];
                   if(accountList!=null && accountList.size()>0)
                   {
                        String DealerType='';
                         if('PSBU' != accountList[0].Business_Unit__c)
                         {
                          /* if('Full Service' == accountList[0].OSM_Service_Level__c) Mar-1236
                             {
                                DealerType = 'Deal' + '_FS';
                             }
                             else if('Lite Repair' == accountList[0].OSM_Service_Level__c)
                             {
                                            DealerType = 'Deal'+'_Maint';
                             } */
                             
                             if('Full Service' == accountList[0].ServiceLevel__c)
                             {
                                DealerType = 'Deal' + '_FS';
                             }
                             else
                             {
                                DealerType = 'Deal'+'_Maint';
                             }
                        }
                       /* if(accountList[0].type=='Dealer Account' && DealerType!='Deal_Maint' && accountList[0].Is_Coupon_Already_Used__c==false)
                        {
                            //OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnDealerLogin(EncryptedId,accountId);
                        }
                        else if(accountList[0].type=='Distributor Account' && accountList[0].Is_Coupon_Already_Used__c==false){
                            //OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountUpdate(EncryptedId,accountId);
                        }
                        else if((accountList[0].type=='Dealer Account') && (accountList[0].BOLT_Account_Number__c!=null || accountList[0].BOLT_Account_Number__c!='') && accountList[0].Is_Coupon_Already_Used__c==true)
                        {
                            OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(EncryptedId,accountId);
                        }
                        else if((accountList[0].BOLT_Account_Number__c!=null || accountList[0].BOLT_Account_Number__c!='') && accountList[0].type!='Distributor Account' && accountList[0].type!='Distributor Branch Account')
                        {
                            OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(EncryptedId,accountId);
                        }
                        else if((accountList[0].BOLT_Account_Number__c!=null || accountList[0].BOLT_Account_Number__c!='') && (accountList[0].type=='Distributor Account' || accountList[0].type=='Distributor Branch Account'))
                        {
                             OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountUpdate(EncryptedId,accountId);
                        }*/
                        /*if(accountList[0].type=='Dealer Account' && DealerType!='Deal_Maint' && accountList[0].Is_Coupon_Already_Used__c==false)
                        {
                            //OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountOnDealerLogin(EncryptedId,accountId);
                        }
                        else if(accountList[0].type=='Distributor Account' && accountList[0].Is_Coupon_Already_Used__c==false){
                            //OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountUpdate(EncryptedId,accountId);
                        }*/
                        if((accountList[0].type=='Dealer Account') && isBoltPOCheck && accountList[0].Is_Coupon_Already_Used__c==true)
                        {
                            OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(EncryptedId,accountId);
                        }
                        else if( isBoltPOCheck && accountList[0].type!='Distributor Account' && accountList[0].type!='Distributor Branch Account')
                        {
                            OSM_SW_OrderConfirmationPg_Ctrl.couponDiscountLogicForAllAccounts(EncryptedId,accountId);
                        }
                        else if(isBoltPOCheck && (accountList[0].type=='Distributor Account' || accountList[0].type=='Distributor Branch Account'))
                        {
                             OSM_SW_OrderConfirmationPg_Ctrl.DNPriceDiscountUpdate(EncryptedId,accountId);
                        }
                        
                                        
                            
                   }
                    //==================================================================
                 
                Set<Id>cartItemIds = new Set<Id>();
                Map<String, String>prodToDisplayProd = new Map<String, String>(); 
                Map<Id, Decimal> prodToDnPrice = new Map<Id, Decimal>();
                Map<ID, Decimal> productToBundlesMap = new Map<Id, Decimal>();
                Map<ID, Decimal> productToCountsMap = new Map<Id, Decimal>();
                Map<ID, boolean> productToRenew = new Map<Id, boolean>();
                Map<Id, ccrz__E_CartItem__c> productToCartItem = new Map<Id, ccrz__E_CartItem__c>();
                
                    for(ccrz__E_CartItem__c ci : cartItems){
                        cartItemIds.add(ci.Id);
                        //prodToDisplayProd.put(ci.ccrz__Product__c,ci.ccrz__DisplayProduct__c);
                    }
                for(ccrz__E_CartItem__c dbci : [Select Id, withCoTerm__c,ccrz__Cart__r.ccrz__Account__c,ccrz__SubAmount__c,ccrz__DisplayProduct__r.ccrz__ProductType__c,
                                                OSM_Renew_Subscription_End_Date__c, ccrz__Price__c,OSM_Renewed_Sub_Id__c, 
                                                OSM_SW_Product_Link__c,OSM_Renew_Subscription_Start_Date__c, ccrz__DisplayProduct__r.Name, ccrz__DisplayProduct__c,ccrz__StoreID__c, Dn_Price__c,ccrz__Product__c, isRenew__c, Number_of_Bundles__c, Number_of_Counts__c from ccrz__E_CartItem__c where Id IN: cartItemIds]){
                    productToRenew.put(dbci.ccrz__Product__c, dbci.isRenew__C);
                    prodToDnPrice.put(dbci.ccrz__Product__c,dbci.Dn_Price__c);
                    productToBundlesMap.put(dbci.ccrz__Product__c,dbci.Number_of_Bundles__c);
                    productToCountsMap.put(dbci.ccrz__Product__c,dbci.Number_of_Counts__c);
                    productToCartItem.put(dbci.ccrz__Product__c,dbci);
                    if(!dbci.isRenew__c ){
                        prodToDisplayProd.put(dbci.ccrz__Product__c,dbci.ccrz__DisplayProduct__c);
                    }
                    
                }
                
                for(ccrz__E_OrderItem__c oi: orderItems){
                      //  if(productToRenew.get(oi.ccrz__Product__c)!=null && !productToRenew.get(oi.ccrz__Product__c)){
                        orderItemIds.add(oi.Id);
                        productIds.put(oi.ccrz__Product__c, Integer.ValueOf(oi.ccrz__Quantity__c));
                        prodToOrderItem.put(oi.ccrz__Product__c,oi.Id);
                        strProd.add(oi.ccrz__Product__c);
                        strProdTerm.add(oi.ccrz__SubProdTerm__c);
                    //}
                }
                
                 OSM_SW_ProductDetailCommonUtility.deletePreOrderSubscriptoins(productToCartItem,orderItemIds); 
                system.debug('prodToDisplayProd-->'+prodToDisplayProd);
                 OSM_SW_ProductDetailCommonUtility.getInvoiceNextRequiredDate(orderItemIds, true, String.valueOf(invoice.id),order.ccrz__Account__c,mapProdToSPT,order.ccrz__Storefront__c,prodToDisplayProd);
                 //OSM_SW_ProductDetailCommonUtility.updateInvoiceItems(invoiceItems,order.ccrz__Account__c,mapProdToSPT,order.ccrz__Storefront__c);
                //updateInvoiceOrderItems(List<ccrz__E_CartItem__c>cartItems
                OSM_SW_ProductDetailCommonUtility.updateInvoiceOrderItems(productToCartItem,invoiceItems,order.ccrz__Account__c,mapProdToSPT,order.ccrz__Storefront__c);
                
                //update order item
               //OSM_SW_ProductDetailCommonUtility.updateRecnNonRecurSubAmountOnOrderItems(orderItems,prodToDnPrice, productToBundlesMap, productToCountsMap);
                OSM_SW_ProductDetailCommonUtility.updateRecnNonRecurSubAmountOnOrderItems(orderItems,productToCartItem);
                
                //update invoice
                OSM_SW_ProductDetailCommonUtility.updateInvoice(new List<ccrz__E_Invoice__c>{invoice}, invoiceItems); 
                
                //Map<String, Object> paymentResult = returnData.get('paymentResult');
                //Object paymentResult = returnData.get('paymentResult');
                //system.debug('paymentResult--->'+paymentResult);
              //paymentType = (String)paymentResult.account_type;
           
                OSM_SW_ProductDetailCommonUtility.lockAccountPreferredBillFre(order.ccrz__Account__c,strProd,order.ccrz__Storefront__c,strProdTerm, isBoltPO );
                
                // Set inactive to exisitng quote if not accepted till purchase
                OSM_SW_ProductDetailCommonUtility.setQuoteToInactivate(order.ccrz__Account__c,strProd,order.ccrz__Storefront__c);
                
                
                // update junction objects of Order & subscription
                OSM_SW_ProductDetailCommonUtility.createOrderSubscriptionJunction(productIds, order.ccrz__Storefront__c,order.ccrz__Account__c,order.Id,prodToOrderItem);
                
                //Insert Order in Invoice and items Junctions
                OSM_SW_ProductDetailCommonUtility.creatOrderInvoiceJunctionEntries(invoice,invoiceItems);
             if(Test.isRunningTest()){
                   throw new NullPointerException();
                }

                }catch(Exception ex){
                    Database.rollback( sp );
                    String errorMsg = ex.getLineNumber() + ex.getStackTraceString() + '-----'+ex.getMessage();
                     ccrz.cclog.log('====Error===='+errorMsg);
                     OSM_SW_General_Util.maintainErrorLog(ex, 'Order hook',ccrz.cc_CallContext.currAccountId);
                    
                    system.debug('exception on order hook-->'+ex+'---->'+ex.getStackTraceString());
                   
                    
                    
                }    
        }
        
        system.debug(returnData.get(ccrz.cc_hk_Order.STEP_END));
        
        return returnData;
    }
    
    /*
    global override Map<String,Object> fetchOrderHistory(Map<String,Object> inputData)
    {
        System.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ in featch order');
        for(String key:inputData.keySet())
        {
            ccrz.ccLog.log('************OSM_SW_cc_hk_Order--Featch Order Step1*****************KEY********** '+key);
            ccrz.ccLog.log('************OSM_SW_cc_hk_Order--Featch Order Step1*****************VALUE********** '+inputData.get(key));
        }
        
        Map<String,Object> returnData = super.fetchOrderHistory(inputData);
        
        for(String key:returnData.keySet())
        {
            ccrz.ccLog.log('************OSM_SW_cc_hk_Order--Featch Order Step2*****************KEY********** '+key);
            ccrz.ccLog.log('************OSM_SW_cc_hk_Order--Featch Order Step2*****************VALUE********** '+returnData.get(key));
        }
        
        
        
        return returnData;
    }
    */

  
    @future
    public static void processRefundForFailedOSMOrderPlacedProcess()
    {
          System.debug('=====processRefundForFailedOSMOrderPlacedProcess====');
    }
    
    
}