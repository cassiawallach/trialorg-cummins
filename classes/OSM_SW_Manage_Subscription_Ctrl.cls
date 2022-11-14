/**********************************************************************
Name:  OSM_SW_Manage_Subscription_Ctrl
Copyright © 2019  Cummins
======================================================
======================================================
Purpose:                                                            
The purpose of this class to revoke and ressiue the Order item.                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                                
1.0 -   Sharad            05/5/2019     INITIAL DEVELOPMENT          
1.1 -   Ronnie            11/01/2021    Chnages added as part of MP-133 to add Subscription Length 
1.2 - Swetha       07/07/2022  Changes added as part of Jira-941 to add the Get Tool Instance value.  
1.3 -   Charlynn          20/07/2022    Changes added as part of LL-24 to add Number of Bundles column
*****************************************************/

global with sharing class OSM_SW_Manage_Subscription_Ctrl
{
    /*----------------------------------------------------------------------------------
    1. initSubscriptionData
    Description: Used to initate the data for subscription manage page
    Input: ccrz.cc_RemoteActionContext ctx, Subscription Id
    Output: 
    Returns instance of SubscriptionData
    
    ccrz.cc_RemoteActionResult
    ------------------------------------------------------------------------------------ */
    @RemoteAction
    global static ccrz.cc_RemoteActionResult initSubscriptionData(ccrz.cc_RemoteActionContext ctx, String subscId)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        Map<String,String> licenceToOrderItem = new Map<String,String>();
        Map<String,String> orderItemToOrder = new Map<String,String>();
        boolean accountGroupChange = false;
        boolean prodStatusActive= false;
        /*MP-133 Code Start*/
        String subsLength;
        /*MP-133 Code End*/
        List<ccrz__E_Subscription__c> subscObject = new List<ccrz__E_Subscription__c>();
        /*MP-133 Code Start*/
        subscObject = [Select Id, OSM_Subscription_Length__c, ccrz__SPT__c, Name,ccrz__CCOrder__c,ccrz__Account__r.ccrz__E_AccountGroup__c, ccrz__Account__c, ccrz__SubscriptionProduct__r.ccrz__SKU__c,OSM_Display_Product__c,ccrz__Quantity__c,ccrz__SubscriptionStartDate__c, OSM_Subscription_End_Date__c, ccrz__SubscriptionProduct__c,ccrz__SubscriptionProduct__r.ccrz__ProductStatus__c, ccrz__SubscriptionProduct__r.Name, OSM_Display_Product__r.Name,OSM_Display_Product__r.ccrz__SKU__c,OSM_Display_Product__r.OSM_SW_Can_Renew__c,OSM_Display_Product__r.OSM_SW_Can_Revoke_And_Ressiue__c,OSM_Display_Product__r.OSM_SW_Can_Revoke__c from ccrz__E_Subscription__c where Id =: subscId];
        ccrz__E_SubProdTerm__c subProdTermObj = [SELECT id, ccrz__DisplayName__c FROM ccrz__E_SubProdTerm__c WHERE id=:subscObject[0].ccrz__SPT__c];
        /*MP-133 Code End*/
        if(String.isBlank(OSM_SW_General_Util.USER_TYPE))
        {
            OSM_SW_General_Util.getuserType(Userinfo.getUserId());
            
        }
        
        String usertType = OSM_SW_General_Util.USER_TYPE;
        System.debug('user type: '+usertType );
        //MAR-231 Code Start
         if(subscObject[0].ccrz__Account__c != Null && subscObject[0].ccrz__Account__r.ccrz__E_AccountGroup__c != Null){
        
            Map < String, Object > returnData = new Map < String, Object >();
            Set<id> prodIds = new Set<id>();
            prodIds.Add(subscObject[0].ccrz__SubscriptionProduct__c);
            
            if(subscObject[0].ccrz__SubscriptionProduct__r.ccrz__ProductStatus__c =='Released'){
                prodStatusActive=True;
            }
            
            returnData = ccrz.ccApiPriceList.fetch(new Map < String, Object > {
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccApiPriceList.STOREFRONT => 'SoftwareStore',
            ccrz.ccApiPriceList.EFFACCTID => subscObject[0].ccrz__Account__c,
            ccrz.ccApiPriceList.PRODUCTIDS => prodIds
            });
            
            System.debug('returnData---->'+returnData);
            Map < String, Object > priceListItems = new Map < String, Object >();
            
            priceListItems =(Map<String,Object>) returnData.get(ccrz.ccApiPriceList.PRICELISTITEMS);
            System.debug('priceListItems---->'+priceListItems);
            If(priceListItems != Null){
                accountGroupChange = True;
            }else{
                accountGroupChange = False;
            }
        }
        // MAR-231 Code End
        if(subscObject.size() > 0)
        {
            
            boolean isSubscRenewfromThis = false;
            boolean itsAddOn = false;
            
            SubscriptionData objData = new SubscriptionData();
            objData.isRenewed = false;
            
            List<ccrz__E_Subscription__c> lstRenewsubscObject = new List<ccrz__E_Subscription__c>();
            lstRenewsubscObject = getRenewSubsc(subscObject[0].Id);
            
            if( lstRenewsubscObject != null && lstRenewsubscObject.size() > 0)
            {
                isSubscRenewfromThis = true;
                objData.isRenewed = true;
                objData.renewedSubscEndDate = lstRenewsubscObject[0].OSM_Subscription_End_Date__c.getTime();
                //objData.renewedSubscEndDate = String.valueOf(lstRenewsubscObject[0].OSM_Subscription_End_Date__c.format('MM/dd/yyyy'));
            }
            
            
            
            objData.qty = subscObject[0].ccrz__Quantity__c;
            objData.subscName = subscObject[0].Name;
            /*MP-133 Code Start*/
            subsLength = subProdTermObj.ccrz__DisplayName__c;              
            /*MP-133 Code End*/
            objData.subscSFID = subscObject[0].Id;
            objData.startDate = String.valueOf(subscObject[0].ccrz__SubscriptionStartDate__c.format('MM/dd/yyyy'));
            objData.endDate = String.valueOf(subscObject[0].OSM_Subscription_End_Date__c.format('MM/dd/yyyy'));
            objData.productType = 'Type1';
            objData.canRenew = false;
            objData.canRenewForAddOn = false;
            
            
            
            boolean isDateRenew = false;
            boolean isProductRenew = false;
            //boolean isWithCoterm = true;
            boolean isUserRenew = false;
            //MP-654 Commenting for allowing the renew button if you uncheck the coterm subscriptions - 18-02-2022 
            /*if(subscObject[0].OSM_SW_Is_without_Coterm__c)
                isWithCoterm = false;*/
            
             List<Id> lstItemId = new List<Id>();
            
            
            
            //check for addon
            if(subscObject[0].OSM_Display_Product__c != null)
            {
                List<ccrz__E_Subscription__c> subscObject2 = new List<ccrz__E_Subscription__c>();
                Datetime myDT3 = Datetime.now();
                subscObject2 = [Select Id, Name, ccrz__Account__c, Is_Renewal_Subscription__c,OSM_Display_Product__c,ccrz__SubscriptionStartDate__c, OSM_Subscription_End_Date__c, ccrz__SubscriptionProduct__c, OSM_Display_Product__r.Name from ccrz__E_Subscription__c where ccrz__Account__c =: subscObject[0].ccrz__Account__c and ccrz__SubscriptionProduct__c =: subscObject[0].OSM_Display_Product__c and ccrz__SubscriptionStatus__c =: Label.OSM_Subscription_Status_Renew ];
                
                if(subscObject2.size() > 0)
                {
                    for(ccrz__E_Subscription__c subscobj : subscObject2)
                    {
                        if(subscobj.Is_Renewal_Subscription__c )
                        {
                            objData.canRenewForAddOn = true;
                            break;
                        }
                    }
                }
                
                subscObject2 = [Select Id, Name, ccrz__Account__c, Is_Renewal_Subscription__c,OSM_Display_Product__c,ccrz__SubscriptionStartDate__c, OSM_Subscription_End_Date__c, ccrz__SubscriptionProduct__c, OSM_Display_Product__r.Name from ccrz__E_Subscription__c where ccrz__Account__c =: subscObject[0].ccrz__Account__c and ccrz__SubscriptionProduct__c =: subscObject[0].OSM_Display_Product__c and ccrz__SubscriptionStatus__c =: 'Active' ];
                
                if(subscObject2.size() > 0)
                {
                    itsAddOn = true;
                }
            }
            
            
            if(System.now().addDays(30) >= subscObject[0].OSM_Subscription_End_Date__c)
            {
                isDateRenew = true;
            }
            
            if(isDateRenew == false)
            {
                string subscriptiondate = label.OSM_Subscription_Date;
                List<String> lstStr = subscriptiondate.split(',');
                List<Integer> intervalValues = new List<Integer>();
                for(String strValue : lstStr)
                {
                   intervalValues.add(Integer.ValueOf(strValue));
                }
                if(intervalValues != null && intervalValues.size() > 0)
                {
                    intervalValues.sort();
                    System.debug(intervalValues[intervalValues.size() - 1]);
                    DateTime systemDate =  system.now();
                    integer intDays =  systemDate.date().daysBetween(subscObject[0].OSM_Subscription_End_Date__c.date());
                    if(intDays <= intervalValues[intervalValues.size() - 1])
                    {
                        isDateRenew = true;
                    }
                }
            }
            
                objData.productType = 'Type1';
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Guidanz'))
                {
                    objData.productType = 'Type1';
                }
                    
                
                if(subscObject[0].ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Add on') || itsAddOn)
                {
                    objData.productType = 'Type2';
                }
                     
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Komatsu'))
                {
                    objData.productType = 'Type5';
                }
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Zap-It'))
                {
                    objData.productType = 'Type3';
                }
                    
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Zap-It OEM'))
                {
                    objData.productType = 'Type3';
                }
                
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Fleet Count'))
                {
                    objData.productType = 'Type3';
                }
                
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Fleetcount'))
                {
                    objData.productType = 'Type3';
                }
                
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Insite'))
                {
                    objData.productType = 'Type5';
                }
                
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('QSOL'))
                {
                    objData.productType = 'Type4';
                }
                   
                
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Incal'))
                {
                    objData.productType = 'Type4';
                }
                
                if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('QuickServe'))
                {
                    objData.productType = 'Type4';
                }
            
            
             if(!(label.SES_OMSCreateOrder_SubscriptionProduct_List.containsIgnoreCase(subscObject[0].OSM_Display_Product__r.ccrz__SKU__c) || label.OMS_ProductList_OriginalList.containsIgnoreCase(subscObject[0].ccrz__SubscriptionProduct__r.ccrz__SKU__c)))                 
             objData.productType = 'Type4';
            
            
            List<OSM_Order_Subscription__c> lstOrderSubsc = new List<OSM_Order_Subscription__c>();
            lstOrderSubsc = [Select Id,CC_Order_Item__c from OSM_Order_Subscription__c where OSM_CCSubscription__c =: subscId];
            
            if(lstOrderSubsc != null && lstOrderSubsc.size() > 0)
            {
              
                for(OSM_Order_Subscription__c objOrdrSubsc : lstOrderSubsc)
                {
                    lstItemId.add(objOrdrSubsc.CC_Order_Item__c);
                }
                
                List<ccrz__E_OrderItem__c> lstOrderItem = new List<ccrz__E_OrderItem__c>();
                List<ccrz__E_OrderItem__c> lstOrderItemIncludedProduct = new List<ccrz__E_OrderItem__c>();
                /* LL-24: added Number_of_Bundles__c and OSM_SW_Product_Link__r.Name to query */
                lstOrderItem = [
                                Select 
                            
                                Id,ccrz__Product__r.Name,ccrz__Quantity__c,ccrz__Order__r.ccrz__OrderDate__c,ccrz__ProductType__c,ccrz__Product_Name__c,
                                    ccrz__Order__c,ccrz__Order__r.Name, Tool_Instance_Key__c, OMS_Activation_Key__c,Number_of_Bundles__c, OSM_SW_Product_Link__r.Name,
                                    (Select 
                                        Id,Activation_Key__c,CC_Order_Item__c,Type__c,Parent_Activation_Key__c,Tool_Instance_Key__c from OSM_Oreder_Item_Licenses__r where Status__c = 'New' order by CreatedDate asc  )  
                                from ccrz__E_OrderItem__c 
                                where Id IN: lstItemId and ccrz__Order__r.ccrz__OrderStatus__c = 'Order Submitted' and Revocation_Status__c != 'Revoke Initiated' and Revocation_Status__c != 'Revoked' and ccrz__ParentOrderItem__c = null and ccrz__OrderItemStatus__c != 'Cancelled' AND IsCancelPending__c = false order by ccrz__Order__r.ccrz__OrderDate__c desc];// Navas M -08-07-22- LL1 - Added sort by desc logic in query
                // and  IsRevokeLicenseSucess__c = false
                Set<Id> parentId = new Set<Id>();
                
                for(ccrz__E_OrderItem__c ojbOrdrIte : lstOrderItem)
                {
                    parentId.add(ojbOrdrIte.Id);
                }
                
                
                lstOrderItemIncludedProduct = [Select Id, ccrz__Product_Name__c,ccrz__ParentOrderItem__c,ccrz__Quantity__c from ccrz__E_OrderItem__c where ccrz__ParentOrderItem__c IN: parentId];
                
                Map<Id, List<ccrz__E_OrderItem__c>> mapParentIdToLstIncludedItem = new Map<Id, List<ccrz__E_OrderItem__c>>();
                
                for(ccrz__E_OrderItem__c objItem : lstOrderItemIncludedProduct)
                {
                    if(!mapParentIdToLstIncludedItem.containsKey(objItem.ccrz__ParentOrderItem__c))
                        mapParentIdToLstIncludedItem.put(objItem.ccrz__ParentOrderItem__c, new List<ccrz__E_OrderItem__c>());
                    mapParentIdToLstIncludedItem.get(objItem.ccrz__ParentOrderItem__c).add(objItem);
                }
                
                // LL-24 Code Start
                boolean showNumOfBundlesValue = false;
                List<String> OSM_ShowNumberofBundlesChkValues = String.isBlank(label.OSM_ShowNumberofBundlesValue) ? new List<String>() : (List<String>) label.OSM_ShowNumberofBundlesValue.split(',');
                // LL-24 Code End
                for(ccrz__E_OrderItem__c ojbOrdrItem : lstOrderItem)
                {
                    SubscriptionItem objItem = new SubscriptionItem();
                    objItem.productName = ojbOrdrItem.ccrz__Product__r.Name;
                    objItem.orderItemId = ojbOrdrItem.Id;
                    objItem.quantity = String.valueOf(ojbOrdrItem.ccrz__Quantity__c);
                    /* LL-24 Code Start */
                    objItem.numberOfBundles = '';
                    showNumOfBundlesValue = false;
                    for(String valChk: OSM_ShowNumberofBundlesChkValues) {
                        if(ojbOrdrItem.OSM_SW_Product_Link__r.Name.equalsIgnoreCase(valChk)) {
                            showNumOfBundlesValue = true;
                        }
                    }
                    if(ojbOrdrItem.Number_of_Bundles__c != null && showNumOfBundlesValue) {
                        objItem.numberOfBundles = String.valueOf(ojbOrdrItem.Number_of_Bundles__c);
                    }
                    /* LL-24 Code End */
                    /*MP-133 Code Start*/
                    objItem.subscriptionLength = subsLength;
                    /*MP-133 Code End*/
                    objItem.expireDate = String.valueOf(subscObject[0].OSM_Subscription_End_Date__c.format('MM/dd/yyyy'));
                    objItem.orderDate = ''+ojbOrdrItem.ccrz__Order__r.ccrz__OrderDate__c.month()+'/'+ojbOrdrItem.ccrz__Order__r.ccrz__OrderDate__c.day()+'/'+ojbOrdrItem.ccrz__Order__r.ccrz__OrderDate__c.year();//String.valueOf(ojbOrdrItem.ccrz__Order__r.ccrz__OrderDate__c.format('MM/dd/yyyy'));
                    objItem.orderNumber = ojbOrdrItem.ccrz__Order__r.Name;
                    objItem.orderid = ojbOrdrItem.ccrz__Order__c;
                    objItem.includedItem = '';
                    objItem.canRevokeAndReissue = false;
                    objItem.canRevoke = false;
                    objItem.actionsEnableForBasic = false;
                    objItem.actionsEnableForFunc = false;
                    objItem.Producttype=ojbOrdrItem.ccrz__ProductType__c;
                    
                    if(mapParentIdToLstIncludedItem.containsKey(ojbOrdrItem.Id) && mapParentIdToLstIncludedItem.get(ojbOrdrItem.Id) != null && mapParentIdToLstIncludedItem.get(ojbOrdrItem.Id).size() > 0)
                    {
                        for(ccrz__E_OrderItem__c includedItem : mapParentIdToLstIncludedItem.get(ojbOrdrItem.Id))
                        {
                            IncludedProduct newObj = new IncludedProduct();
                            newObj.productname = includedItem.ccrz__Product_Name__c;
                            newObj.productQuantiy = Integer.valueOf(includedItem.ccrz__Quantity__c);
                            objItem.lstIncludedProduct.add(newObj);
                        }
                        
                        
                    }
                    
                    orderItemToOrder.put(ojbOrdrItem.Id, ojbOrdrItem.ccrz__Order__c);
                    
                    
                    
                    boolean isProductRevokeable = false;
                    boolean isUserRevokeable = false;
                    boolean isProductRevokeAndRessiueable = false;
                    boolean isUserRevokeAndRessiueable = false;
                    System.debug('product name : '+subscObject[0].OSM_Display_Product__r.Name);
                    
                    
                    if(objItem.Producttype=='Bundle' && objItem.productName.contains('Cummins Guidanz™ Service Package')){
                        objItem.Showincludedlink=true;
                     }

                    /*
                    if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Guidanz'))
                    {
                        System.debug('product name of gud ');
                        isProductRevokeable = true;
                        isProductRevokeAndRessiueable = true;
                        isProductRenew = true;
                    }
                    
                    if(subscObject[0].ccrz__SubscriptionProduct__r.Name.containsIgnoreCase('Add on') || itsAddOn)
                    {
                        
                        isProductRevokeable = true;
                        isProductRevokeAndRessiueable = true;
                        isProductRenew = true;
                    }
                    
                    if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Insite'))
                    {
                        
                        isProductRevokeable = true;
                        isProductRevokeAndRessiueable = true;
                        isProductRenew = true;
                    }
                    
                   if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('QSOL'))
                    {
                            isProductRevokeable = true;
                            isProductRevokeAndRessiueable = false;
                            isProductRenew = true;
                        
                    }
                    
                    if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('QuickServe'))
                    {
                            isProductRevokeable = true;
                            isProductRevokeAndRessiueable = false;
                            isProductRenew = true;
                        
                    }
                    
                    
                    
                    if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Incal'))
                    {
                        
                        isProductRevokeable = true;
                        isProductRevokeAndRessiueable = false;
                        isProductRenew = true;
                    }
                    
                    if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Fleetcount'))
                    {
                        isProductRevokeable = true;
                        isProductRevokeAndRessiueable = true;
                        isProductRenew = false;
                    }
                    if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Fleet Count'))
                    {
                        isProductRevokeable = true;
                        isProductRevokeAndRessiueable = true;
                        isProductRenew = false;
                    }
                    
                    if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Zap-It'))
                    {
                        isProductRevokeable = true;
                        isProductRevokeAndRessiueable = true;
                        isProductRenew = false;
                    }
                    if(subscObject[0].OSM_Display_Product__r.Name.containsIgnoreCase('Zap-It OEM'))
                    {
                        isProductRevokeable = true;
                        isProductRevokeAndRessiueable = true;
                        isProductRenew = false;
                    }
                    
                    if(label.OSM_SW_Product_List_Non_renew.containsIgnoreCase(subscObject[0].OSM_Display_Product__r.Name))
                        isProductRenew = false;
                    
                    */
                    
                    if(subscObject[0].OSM_Display_Product__r.OSM_SW_Can_Revoke__c)
                    {
                        isProductRevokeable = true;
                    }
                    if(subscObject[0].OSM_Display_Product__r.OSM_SW_Can_Revoke_And_Ressiue__c)
                    {
                        isProductRevokeAndRessiueable = true;
                    }
                    if(subscObject[0].OSM_Display_Product__r.OSM_SW_Can_Renew__c)
                    {
                        isProductRenew = true;
                    }
                    
                    if(usertType == Label.OSM_Fleet_Admin_UserType)
                    {
                        
                        isUserRevokeable = false;
                        isUserRevokeAndRessiueable = false;
                        isUserRenew = true;
                    }
                    
                    if(usertType == Label.OSM_Distributor_Admin_UserType)
                    {
                        isUserRevokeable = true;
                        isUserRevokeAndRessiueable = true;
                        isUserRenew = true;
                    }
                    
                    if(usertType == Label.OSM_Support_Admin_UserType)
                    {
                        isUserRevokeable = true;
                        isUserRevokeAndRessiueable = true;
                        isUserRenew = true;
                    }
                    if(usertType == Label.OSM_Sales_Admin_UserType)
                    {
                        isUserRevokeable = false;
                        isUserRevokeAndRessiueable = false;
                        isUserRenew = false;
                    }
                    if(usertType == Label.OSM_Sales_UserType)
                    {
                        isUserRevokeable = false;
                        isUserRevokeAndRessiueable = false;
                        isUserRenew = false;
                    }
                    
                    if(usertType == Label.OSM_SSOEM_Admin_UserType)
                    {
                        isUserRevokeable = true;
                        isUserRevokeAndRessiueable = true;
                        isUserRenew = true;
                    }
                    if(usertType == Label.OSM_Business_Admin_UserType)
                    {
                        isUserRevokeable = true;
                        isUserRevokeAndRessiueable = true;
                        isUserRenew = true;
                    }
                    
                    System.debug('isUserRevokeAndRessiueable: '+isUserRevokeAndRessiueable);
                    System.debug('isProductRevokeAndRessiueable: '+isProductRevokeAndRessiueable);
                    System.debug('isProductRevokeable: '+isProductRevokeable);
                    System.debug('isUserRevokeable: '+isUserRevokeable);
                    //MAR-231 added extra condition 
                    if(isUserRevokeAndRessiueable && isProductRevokeAndRessiueable && prodStatusActive && accountGroupChange)
                    {
                        objItem.canRevokeAndReissue = true;
                    }
                    
                    if(isUserRevokeable && isProductRevokeable)
                    {
                        objItem.canRevoke = true;
                    }
                    //objItem.canRevoke = true;// for testing 
                    //objItem.canRevokeAndReissue = true;// for testing
                    Map<Id,List<OSM_Order_Item_License__c>> mapActivationKeyListTIK = new Map<Id,List<OSM_Order_Item_License__c>>();
                    Map<Id,List<OSM_Order_Item_License__c>> mapActivationBasicKeyListTIK = new Map<Id,List<OSM_Order_Item_License__c>>();
                    List<OSM_Order_Item_License__c> lstTollIK = new List<OSM_Order_Item_License__c>();
                    List<keys> funcationalKeyLocalLst = new List<keys>();
                    List<keys> basicKeyLocalLst = new List<keys>();
                    Map<Id,OSM_Order_Item_License__c> mapOfLicense = new Map<Id,OSM_Order_Item_License__c>();
                    for(OSM_Order_Item_License__c objLis : ojbOrdrItem.OSM_Oreder_Item_Licenses__r)
                    {
                        mapOfLicense.put(objLis.Id,objLis);
                        
                        if(objLis.Parent_Activation_Key__c != null)
                        {
                            licenceToOrderItem.put(objLis.Id, objLis.CC_Order_Item__c);
                            lstTollIK.add(objLis);
                            
                        }
                        else
                        {
                            
                            
                            if(objLis.Type__c == 'Basic')
                            {
                                keys objKey =  new keys();
                                objKey.keyId = objLis.Id;
                                objKey.valueStr = objLis.Activation_Key__c;
                                if(basicKeyLocalLst.size() == 0)
                                {
                                    objKey.isSelected = true;
                                }
                                basicKeyLocalLst.add(objKey);
                                mapActivationBasicKeyListTIK.put(objLis.Id, new List<OSM_Order_Item_License__c>());
                            }
                                
                            if(objLis.Type__c == 'Functional')
                            {
                                keys objKey =  new keys();
                                objKey.keyId = objLis.Id;
                                objKey.valueStr = objLis.Activation_Key__c;
                                if(funcationalKeyLocalLst.size() == 0)
                                {
                                    objKey.isSelected = true;
                                }
                                funcationalKeyLocalLst.add(objKey);
                                mapActivationKeyListTIK.put(objLis.Id, new List<OSM_Order_Item_License__c>());
                            }
                        }
                        
                    }
                    
                    if(basicKeyLocalLst.size() == 0)
                    {
                        keys objKey =  new keys();
                        objKey.keyId = '--None--';
                        objKey.valueStr = '--None--';
                        objKey.isSelected = true;
                        basicKeyLocalLst.add(objKey);
                    }
                    if(funcationalKeyLocalLst.size() == 0)
                    {
                        keys objKey =  new keys();
                        objKey.keyId = '--None--';
                        objKey.valueStr = '--None--';
                        objKey.isSelected = true;
                        funcationalKeyLocalLst.add(objKey);
                    }
                    
                    system.debug('lstTollIK: '+lstTollIK);
                    system.debug('mapActivationKeyListTIK: '+mapActivationKeyListTIK);
                    
                    for(OSM_Order_Item_License__c obj : lstTollIK)
                    {
                        if(mapActivationKeyListTIK.containsKey(obj.Parent_Activation_Key__c))
                        {
                            mapActivationKeyListTIK.get(obj.Parent_Activation_Key__c).add(obj);
                        }
                        
                        if(mapActivationBasicKeyListTIK.containsKey(obj.Parent_Activation_Key__c))
                        {
                            mapActivationBasicKeyListTIK.get(obj.Parent_Activation_Key__c).add(obj);
                        }
                    }
                    
                    System.debug('mapActivationKeyListTIK: '+mapActivationKeyListTIK);
                    System.debug('mapActivationBasicKeyListTIK: '+mapActivationBasicKeyListTIK);
                    

                    if(mapActivationKeyListTIK != null && mapActivationKeyListTIK.size() > 0 )
                    {
                        boolean checked = false;
                        for(String key : mapActivationKeyListTIK.keySet())
                        {
                            productLicenseInfo ObjL = new productLicenseInfo();
                            ObjL.activationKey = mapOfLicense.get(key).Activation_Key__c;
                            ObjL.activationKeyId = key;
                            ObjL.orderItemId = ojbOrdrItem.Id;
                            
                            if(!checked)
                            {
                                if( mapActivationKeyListTIK.get(key).size()  > 0)
                                {
                                    for(OSM_Order_Item_License__c tik : mapActivationKeyListTIK.get(key))
                                    {
                                        
                                        ToolItem newToolObj2 = new ToolItem();
                                        newToolObj2.toolInstanceKey = tik.Tool_Instance_Key__c;
                                        newToolObj2.sfId = tik.Id;
                                        newToolObj2.isSelected = false;
                                        if(objItem.funcationalToolIdLst.size() == 0 )
                                        {
                                            newToolObj2.isSelected = true;
                                            objItem.selectedFuncToolIncId = tik.Id;
                                        }
                                        objItem.funcationalToolIdLst.add(newToolObj2);
                                    }
                                }
                                else
                                {
                                    ToolItem newToolObj2 = new ToolItem();
                                    newToolObj2.toolInstanceKey = '--None--';
                                    newToolObj2.sfId = '--None--';
                                    newToolObj2.isSelected = true;
                                    objItem.selectedFuncToolIncId = '--None--';
                                    objItem.funcationalToolIdLst.add(newToolObj2);
                                }
                                checked = true;
                            }
                                
                            for(OSM_Order_Item_License__c tik : mapActivationKeyListTIK.get(key))
                            {
                                
                                ToolItem newToolObj2 = new ToolItem();
                                newToolObj2.toolInstanceKey = tik.Tool_Instance_Key__c;
                                newToolObj2.sfId = tik.Id;
                                newToolObj2.isSelected = false;
                                ObjL.toolInstanceKey.add(newToolObj2);
                            }
                            
                            objItem.linceseFuncInfoLst.add(ObjL);
                        }
                        
                    }
                    else
                    {
                        ToolItem newToolObj2 = new ToolItem();
                        newToolObj2.toolInstanceKey = '--None--';
                        newToolObj2.sfId = '--None--';
                        newToolObj2.isSelected = true;
                        objItem.selectedFuncToolIncId = '--None--';
                        objItem.funcationalToolIdLst.add(newToolObj2);
                    }
                    
                    if(mapActivationBasicKeyListTIK != null && mapActivationBasicKeyListTIK.size() > 0 )
                    {
                        boolean checked = false;
                        for(String key : mapActivationBasicKeyListTIK.keySet())
                        {
                            productLicenseInfo ObjL = new productLicenseInfo();
                            ObjL.activationKey = mapOfLicense.get(key).Activation_Key__c;
                            ObjL.activationKeyId = key;
                            ObjL.orderItemId = ojbOrdrItem.Id;
                            
                            if(!checked)
                            {
                                if(mapActivationBasicKeyListTIK.get(key).size() > 0)
                                {
                                    for(OSM_Order_Item_License__c tik : mapActivationBasicKeyListTIK.get(key))
                                    {
                                        
                                        ToolItem newToolObj2 = new ToolItem();
                                        newToolObj2.toolInstanceKey = tik.Tool_Instance_Key__c;
                                        newToolObj2.sfId = tik.Id;
                                        newToolObj2.isSelected = false;
                                        if(objItem.baiscToolIdLst.size() == 0)
                                        {
                                            newToolObj2.isSelected = true;
                                            objItem.selectedBasicToolIncId = tik.Id;
                                        }
                                        objItem.baiscToolIdLst.add(newToolObj2);
                                    }
                                }
                                else
                                {
                                    ToolItem newToolObj2 = new ToolItem();
                                    newToolObj2.toolInstanceKey = '--None--';
                                    newToolObj2.sfId = '--None--';
                                    newToolObj2.isSelected = true;
                                    objItem.selectedBasicToolIncId = '--None--';
                                    
                                    objItem.baiscToolIdLst.add(newToolObj2);
                                }
                                checked = true;
                            }
                            
                            for(OSM_Order_Item_License__c tik : mapActivationBasicKeyListTIK.get(key))
                            {
                                ToolItem newToolObj2 = new ToolItem();
                                newToolObj2.toolInstanceKey = tik.Tool_Instance_Key__c;
                                newToolObj2.sfId = tik.Id;
                                newToolObj2.isSelected = false;
                                ObjL.toolInstanceKey.add(newToolObj2);
                            }
                            
                            
                            objItem.linceseBasicInfoLst.add(ObjL);
                        }
                        
                    }
                    else
                    {
                        ToolItem newToolObj2 = new ToolItem();
                        newToolObj2.toolInstanceKey = '--None--';
                        newToolObj2.sfId = '--None--';
                        newToolObj2.isSelected = true;
                        objItem.selectedBasicToolIncId = '--None--';
                        
                        objItem.baiscToolIdLst.add(newToolObj2);
                    }
                    
                    objItem.basicKeyLst = basicKeyLocalLst;
                    objItem.funcationalKeyLst = funcationalKeyLocalLst;
                    
                    if(objItem.funcationalKeyLst.size() > 0 &&  objItem.funcationalToolIdLst.size() > 0)
                    {
                        objItem.actionsEnableForFunc = true;
                    }
                    if(objItem.basicKeyLst.size() > 0 &&  objItem.baiscToolIdLst.size() > 0)
                    {
                        objItem.actionsEnableForBasic = true;
                    }
                    
                    
                    objData.subscriptionItemList.add(objItem);
                    
                    
                }
                
                
            }
            System.debug('isDateRenew: '+isDateRenew);
            System.debug('isProductRenew: '+isProductRenew);
            System.debug('isUserRenew: '+isUserRenew);
            System.debug('isSubscRenewfromThis: '+isSubscRenewfromThis);
            System.debug('prodStatusActive: '+prodStatusActive);
            System.debug('accountGroupChange: '+accountGroupChange);
            //System.debug('isWithCoterm: '+isWithCoterm);
            //MP-654 Removing isWithCoterm condition for allowing the renew button if you uncheck the coterm subscriptions - 18-02-2022
            if(isDateRenew && isProductRenew && isUserRenew && !isSubscRenewfromThis && prodStatusActive && accountGroupChange)
            {
                objData.canRenew = true;
            }
            
            if(OSM_SW_ActivationKeyError_Handling.activationkeycheck(subscObject[0].ccrz__CCOrder__c,lstItemId)){
                       objData.activationKeyErrorMessage=true;
             }else  objData.activationKeyErrorMessage=false;
            
            objData.licenceToOrderItem = licenceToOrderItem;
            objData.orderItemToOrder = orderItemToOrder;
            returnMap.put('orderItemToOrder', orderItemToOrder);
            returnMap.put('licenceToOrderItem', licenceToOrderItem);
            returnMap.put('SubscDate', objData);
            
                
            
        }
        
        
        res.data = returnMap;
        res.success=true;
        return res;
    }
    
    
    public static List<ccrz__E_Subscription__c> getRenewSubsc(Id subscId)
    {
        return [Select Id, Renewed_From_Subscription__c, OSM_Subscription_End_Date__c from ccrz__E_Subscription__c where Renewed_From_Subscription__c =: subscId and ccrz__SubscriptionStatus__c =: Label.OSM_Subscription_Status_Renew];
    }
    
    // Added By Swetha for Jira-941 - Story On 7th July, 2022
     /*----------------------------------------------------------------------------------
        2. getToolInstance
        Description: Used to get the tool instance key license for order items
        Input: ccrz.cc_RemoteActionContext ctx, Order Item Id
        
        Output: 
        ccrz.cc_RemoteActionResult
    Ticket: Jira-941 
    ------------------------------------------------------------------------------------ */
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getToolInstance(ccrz.cc_RemoteActionContext ctx, String selectedOrder)
    {
       // System.debug('selectedOrder: '+selectedOrder);
        //Data sent from visualforce page to controller. Deserialize it.
        Map < String, Object > SubscriptionDetails = (Map < String, Object >) JSON.deserializeUntyped(selectedOrder);
        
        //Initialize the remote context and store response value.
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        
        //Variable to store the response of the method
        Map<String,Object> returnMap = new Map<String,Object>();
        
        
        system.debug(SubscriptionDetails);
        List<OSM_ReturnWrapper> objReturnList=new List<OSM_ReturnWrapper>();
       OSM_ReturnWrapper objReturn;  
        
        try{
        
        //OrderItem  
        Id OrderItemId = (Id)SubscriptionDetails.get('OrderItem');   
        system.debug(OrderItemId);  

        Set<Id> setOrderItemIds = new Set<Id>(); 
        
    List<ccrz__E_OrderItem__c> lOrderItemRecords = [Select ID,OSM_GetTI_Success__c,OMS_Item_ID__c, OMS_Product__c,ccrz__DisplayProduct__c,Tool_Instance_Count__c,OSM_Tool_Instance_Key__c,OMS_Instance_ID__c, OMS_Activation_Key__c, Tool_Instance_Key__c, ccrz__Order__c,ccrz__Order__r.ccrz__Account__c From ccrz__E_OrderItem__c where Id =:OrderItemId];
         system.debug(lOrderItemRecords);       
            
        for(ccrz__E_OrderItem__c orderItem : lOrderItemRecords)
        {
             setOrderItemIds.add(orderItem.ID);
             System.debug('setOrderItemIds_____________'+setOrderItemIds);
        }
            
        List<OSM_Order_Item_License__c>  lItemLicenses = new List<OSM_Order_Item_License__c>();
        lItemLicenses = [Select Id, Type__c,Activation_Key__c, CC_Order_Item__c, Parent_Activation_Key__c, OMS_Item_Id__c,Tool_Instance_Key__c, Status__c
                       from OSM_Order_Item_License__c where CC_Order_Item__c = :OrderItemId];
            system.debug(lItemLicenses);  
            
        Map<Id,ccrz__E_OrderItem__c> orderItemRecordMap=new  Map<Id,ccrz__E_OrderItem__c>();
        Set<String>uniqueKey = new Set<String>();
         
        for(ccrz__E_OrderItem__c orderItem : lOrderItemRecords)
        {
           orderItemRecordMap.put(orderItem.Id, orderItem);
          system.debug(orderItemRecordMap);      
            
           for(OSM_Order_Item_License__c itemLicense : lItemLicenses){
               if(orderItem.Id == itemLicense.CC_Order_Item__c && !uniqueKey.Contains(itemLicense.Activation_Key__c)){
                   uniqueKey.add(itemLicense.Activation_Key__c);
                    objReturn=OSM_GetTI_BusinessHandler.updateOMSToolInstance(orderItem.Id,orderItemRecordMap,itemLicense, null);
                    objReturnList.add(objReturn);
               }
           }
        }
            
           system.debug(objReturnList);
            
            //OMG-943 Id condition added
            if(objReturn.exceptionFlag){
                if(objReturn.exceptionMessage =='NoActiveToolInstance') returnMap.put('error','NoActiveToolInstance');
                res.success = false;
            }
           updateOrderItemRecords(objReturnList,setOrderItemIds);
           
           returnMap.put('SubscriptionDetails',SubscriptionDetails);  

        }
        Catch(Exception ex){ 
                res.data = ex;
               returnMap.put('ex',ex);
            } 

        res.data = returnMap;
        return res;
    }
    
     // Added By Swetha for Jira-941 
     // This method is used to update the order item records and display the licenses on the main subscription page post update.
    public static void updateOrderItemRecords(List<OSM_ReturnWrapper> objReturnList, Set<Id> setOrderItemId)
    {
        //system.debug('objReturnList' + objReturnList);
        //system.debug('setOrderItemId'+setOrderItemId);
        
        Map<String, Set<String>> activationKeyToToolIns = new Map<String, Set<String>>();
        
        for(OSM_Order_Item_License__c itemLicense : [Select 
                            Id, Activation_Key__c, CC_Order_Item__c, Parent_Activation_Key__c, OMS_Item_Id__c,Tool_Instance_Key__c, Status__c
                        From OSM_Order_Item_License__c 
                        where CC_Order_Item__c IN: setOrderItemId  and (Status__c=: 'New'  or Status__c =: 'Revoked' or Status__c=:'Revoke/ReIssue Pending' or Status__c=:'Revoke Initiated')])
        {
            if(!activationKeyToToolIns.keySet().contains(itemLicense.Activation_Key__c)){               
                activationKeyToToolIns.put(itemLicense.Activation_Key__c, new Set<String>{itemLicense.Tool_Instance_Key__c} );  
            }else{
                Set<String> tools = activationKeyToToolIns.get(itemLicense.Activation_Key__c);
                tools.add(itemLicense.Tool_Instance_Key__c);
                activationKeyToToolIns.put(itemLicense.Activation_Key__c, tools);   
            }
        }        
        
        //system.debug(activationKeyToToolIns);

        Savepoint sp = Database.setSavepoint();
         try{
                     for(OSM_ReturnWrapper objReturnToSave:objReturnList){
                 //Update Records
                 if (objReturnToSave.updateOrderItemList.size()>0)
                 {  
                     Database.update(objReturnToSave.updateOrderItemList,false);
                 } 
                         system.debug('objReturnToSave.updateOrderItemList'+objReturnToSave.updateOrderItemList);
                 if(objReturnToSave.orderItemLicenseList.size()>0){
                     Set<String> existingToolLi = new Set<String>();
                   
                      List<OSM_Order_Item_License__c> toInsert = new List<OSM_Order_Item_License__c>();   
                     
                         for(OSM_Order_Item_License__c newTool : objReturnToSave.orderItemLicenseList){
                             if((activationKeyToToolIns == null || activationKeyToToolIns.get(newTool.Activation_Key__c) == null 
                                   || (activationKeyToToolIns.get(newTool.Activation_Key__c) != null && !activationKeyToToolIns.get(newTool.Activation_Key__c).Contains(newTool.Tool_Instance_Key__c)))){
                                   toInsert.add(newTool);
                             }
                         }
                     if(toInsert.size()>0){
                        Database.upsert(toInsert) ;
                     }
                 }
             }
             if(Test.isRunningTest()){
                 throw new NullPointerException();
             }
         }
        catch(Exception ex)
        {
            System.debug('Exception in DML>>>>'+ex);
            Database.rollback(sp);
            
            for(OSM_ReturnWrapper objReturnToSave:objReturnList)
            {
                for(OSM_Integration_Log__c objLog : objReturnToSave.lstToInsertLog)
                {
                    objLog.Status__c = 'Failure'; 
                    
                    String oldMsg = '';
                    if(objLog.Error_Description__c != null && objLog.Error_Description__c != '')
                    oldMsg = objLog.Error_Description__c;
                    String msg  = oldMsg+ ' Message - '+ex.getMessage();
                    msg=msg+ 'Stacktrace - ' + ex.getStackTraceString();
                    objLog.Error_Description__c = msg;
                    objLog.Account__c = getAccountId();  // Added By Dhiraj for MAR-1621 - Story On 21st April 2021
                }
          }
        }
        finally 
        {
            List<OSM_Integration_Log__c> logList=new List<OSM_Integration_Log__c>();
            
            for(OSM_ReturnWrapper objReturnToSave:objReturnList)
            {
                if(objReturnToSave.lstToInsertLog !=  null && objReturnToSave.lstToInsertLog.size() > 0 && !objReturnToSave.lstToInsertLog.isEmpty()){
                    for(OSM_Integration_Log__c log:objReturnToSave.lstToInsertLog){
                       logList.add(log);
                     }
                }
             }
                insert logList;
       }  
    }
    
    // Added By Swetha for Jira-941 
    public static String getAccountId()
    {
        String strAccId;
        User objUser = new User();
        objUser = [SELECT Contact.Account.Id FROM User WHERE Id = : UserInfo.getUserId()];
        strAccId = objUser.Contact.Account.Id;
        System.debug('strAccId+++' + strAccId);
        return strAccId;
    }
    //Code Ended.

    
     /*----------------------------------------------------------------------------------
    3. revokeAndReIssueSubscription
    Description: Used to revoke and ressiue of a License Instance key
    Input: ccrz.cc_RemoteActionContext ctx, License Id
    
    Output: 
    ccrz.cc_RemoteActionResult
    ------------------------------------------------------------------------------------ */
    
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult revokeAndReIssueSubscription(ccrz.cc_RemoteActionContext ctx, String selectedItem)
    {
        System.debug('selectedItem: '+selectedItem);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map<String,Object> returnMap = new Map<String,Object>();
        Map < String, Object > SubscriptionDetails = (Map < String, Object > ) JSON.deserializeUntyped(selectedItem);
        try{
        Id OrderItemId = (Id)SubscriptionDetails.get('OrderItem');
        String insctanceId = (String)SubscriptionDetails.get('licenseId');
        //Order  
        
        OSM_Order_Item_License__c  ojLis = new OSM_Order_Item_License__c();
        ojLis = [Select Id,Status__c from OSM_Order_Item_License__c where Id =: insctanceId];
        if(ojLis.Status__c == 'Revoked/ReIssue' || ojLis.Status__c == 'Revoke/ReIssue Pending')
        {
            res.success = false;
            Map<String,Object> returnMap2 = new Map<String,Object>();
            returnMap2.put('error','Subscription is already being revoked and reissue.');
            returnMap2.put('alreadyDone',true);
            res.data = returnMap2;
        }
        else
        {
            OSM_ReturnWrapper returnWrapper = OSM_OMS_SW_RevokeAPIUtility.revokeAPIcallSingleInstance(OrderItemId,insctanceId);
             
            if(returnWrapper.exceptionFlag == false){
                OSM_Order_Item_License__c updateOitl = new OSM_Order_Item_License__c();
                updateOitl.id=insctanceId;
                updateOitl.Status__c = 'Revoked/ReIssue';
                update updateOitl;
                OSM_SW_CreateGetOrder_ON_ReIssueBatch objCreateAndGetOrder = new OSM_SW_CreateGetOrder_ON_ReIssueBatch();
                Database.executeBatch(objCreateAndGetOrder,1);
                //OMG-1090 Code Start
               List<OSM_Order_Item_License__c> osmOIL = new List<OSM_Order_Item_License__c>();
               osmOIL=[Select id,Name,Status__c from OSM_Order_Item_License__c where id=:insctanceId AND Status__c != 'ReIssued'];
                if(osmOIL.size()>0){
                    returnMap.put('error','ReIssueFailed');
                    res.success = false;
                    //res.data = returnMap; 
                } //OMG-1090 Code End
            }else{
                 OSM_Order_Item_License__c updateOitl = new OSM_Order_Item_License__c();
                updateOitl.id=insctanceId;
                updateOitl.Status__c = 'Revoke/ReIssue Pending';
                update updateOitl;
                //OMG-1090 Code Start
                returnMap.put('error','RevokeFailed');
                res.success = false; 
                //res.data = returnMap;  
                //OMG-1090 Code End
            }
            
            returnMap.put('selectedItem',selectedItem);
            returnMap.put('SubscriptionDetails',SubscriptionDetails);
               
        }
        }Catch(Exception ex){ 
                res.data = ex;
               returnMap.put('ex',ex);
            } 
        //returnMap.put('returnWrapper',returnWrapper); 
        //res.data = returnMap;
        return res;
    }
    
     /*----------------------------------------------------------------------------------
    4. revokeSubscription
    Description: Used to revoke order item
    Input: ccrz.cc_RemoteActionContext ctx, Item Id
    
    Output: 
    ccrz.cc_RemoteActionResult
    ------------------------------------------------------------------------------------ */
     @RemoteAction
    global static ccrz.cc_RemoteActionResult revokeSubscription(ccrz.cc_RemoteActionContext ctx, String selectedItem)
    {
        System.debug(selectedItem);
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        Map < String, Object > SubscriptionDetails = (Map < String, Object > ) JSON.deserializeUntyped(selectedItem);
        String licenseId = (String)SubscriptionDetails.get('licenseId');
        boolean licenseProduct = (boolean)SubscriptionDetails.get('licenseProduct');
         
        
        OSM_Order_Item_License__c  ojLis = new OSM_Order_Item_License__c();
        List<OSM_Order_Item_License__c> ojLiscenses = [Select 
                                            Id, Activation_Key__c, CC_Order_Item__c, Parent_Activation_Key__c, 
                                            OMS_Item_Id__c, Tool_Instance_Key__c, Status__c
                                        From OSM_Order_Item_License__c 
                                        where Id =: licenseId];
                                        /*Parent_Activation_Key__c <>:null 
                                         and (Status__c =: 'Revoke/ReIssue Pending' 
                                             OR Status__c =: 'Revoke Intitiated')
                                         and type__c = 'Tool instance'];*/
      if(ojLiscenses.size()==1){ 
          ojLis = ojLiscenses[0];
        if(ojLis.Status__c == 'Revoke Initiated' || ojLis.Status__c == 'Revoked')
        {
            res.success = false;
            Map<String,Object> returnMap = new Map<String,Object>();
            returnMap.put('error','Subscription is already being revoked.');
            returnMap.put('alreadyDone',true);
            res.data = returnMap;
        }
        else
        {
            
                ojLis.Status__c = 'Revoke Intitiated';    
                 OSM_ReturnWrapper returnWrapper = OSM_OMS_SW_RevokeAPIUtility.revokeAPIcallSingleInstance(ojLis.CC_Order_Item__c,ojLis.Id);
                 if(!returnWrapper.exceptionFlag){
                        ojLis.Status__c = 'Revoked';
                    }else{ //OMG-1001 Code Start
                        res.success = false;
                    } //OMG-1001 Code End
               update ojLis;
            }
        }
        
        return res;
    }   

    /*----------------------------------------------------------------------------------
    5. revokeSubscription
    Description: Used to renew order item
    Input: ccrz.cc_RemoteActionContext ctx, Item Id
    
    Output: 
    ccrz.cc_RemoteActionResult
    ------------------------------------------------------------------------------------ */
     @RemoteAction
    global static ccrz.cc_RemoteActionResult renewSubscription(ccrz.cc_RemoteActionContext ctx, String selectedItem)
    {  
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        ccrz.cc_CallContext.initRemoteContext(ctx);
        Map < String, Object > SubscriptionDetails = (Map < String, Object > ) JSON.deserializeUntyped(selectedItem);
        
            String subscId = (String)SubscriptionDetails.get('subscId'); 
        
        
        List<ccrz__E_Subscription__c> lstRenewsubscObject = new List<ccrz__E_Subscription__c>();
        lstRenewsubscObject = getRenewSubsc(subscId);
            
        if(lstRenewsubscObject != null && lstRenewsubscObject.size() > 0)
        {
            res.success = false;
            Map<String,Object> returnMap = new Map<String,Object>();
            returnMap.put('error','Subscription is already being renewed.');
            returnMap.put('alreadyDone',true);
            res.data = returnMap;
        }
        else
        {
        
            String storefront = ccrz.cc_CallContext.storefront;
            Id userId = ccrz.cc_CallContext.currUserId;
            String currCartId = ccrz.cc_CallContext.currCartId;
            //String accId = ccrz.cc_CallContext.currAccountId;
            String displayProductSku;
            String productSku;
            String addOn;
            String subProdTerm;
            String subid;
            //List<ccrz__E_OrderItem__c> orderItems = OSM_SW_ProdDetailUtils_Ctrl.getOrderItems(new List<String>{selectedItem});
            List<ccrz__E_Subscription__c> subscriptions = OSM_SW_ProdDetailUtils_Ctrl.getSubscriptionRecords(new List<Id> {subscId});
            if(subscriptions.size()>0){
                String store = subscriptions[0].ccrz__Storefront__c; 
                String productId = subscriptions[0].ccrz__SubscriptionProduct__c;
                //ccrz__SubAmount__c, 
                subProdTerm = subscriptions[0].ccrz__SPT__c;
                String displayProductId = subscriptions[0].ccrz__CCOrderItem__r.ccrz__DisplayProduct__c; 
                    
                Integer quantity = (Integer)subscriptions[0].ccrz__Quantity__c;
                productSku = subscriptions[0].ccrz__SubscriptionProduct__r.ccrz__SKU__c;
                //MP-476 code start
                ccrz__E_Subscription__c addOnSub = new ccrz__E_Subscription__c ();
                Set<id> subProdIds = new Set<id>();
                
              //MP-593 Add OR condition for QSOL products should go to cart when we renew          
        if(subscriptions[0].ccrz__CCOrderItem__r.ccrz__Product__r.Name.containsIgnoreCase('Add-on') || label.OSM_QuickServeSkus.contains(productSku)){
                    //MP-593 Add else condition for QSOL products should go to cart when we renew    
                    if(subscriptions[0].ccrz__CCOrderItem__r.ccrz__Product__r.Name.containsIgnoreCase('Add-on')){
                        addOnSub = [Select id,name,ccrz__SPT__r.ccrz__DisplayName__c,ccrz__SubscriptionStatus__c,OSM_Display_Product__r.ccrz__SKU__c,ccrz__SPT__r.ccrz__CCProduct__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:subscriptions[0].ccrz__Account__c AND ccrz__SubscriptionProduct__c =: subscriptions[0].ccrz__CCOrderItem__r.ccrz__DisplayProduct__c AND ccrz__SubscriptionStatus__c='Renew' and ccrz__Storefront__c =: storefront];
                    }else{
                        addOnSub = [Select id,name,ccrz__SPT__r.ccrz__DisplayName__c,ccrz__SubscriptionStatus__c,OSM_Display_Product__r.ccrz__SKU__c,ccrz__SPT__r.ccrz__CCProduct__r.ccrz__SKU__c,ccrz__SubscriptionProduct__c,ccrz__SPT__c from ccrz__E_Subscription__c where ccrz__Account__c=:subscriptions[0].ccrz__Account__c AND ccrz__SubscriptionProduct__r.ccrz__SKU__c =: productSku AND ccrz__SubscriptionStatus__c='Active' AND ccrz__Storefront__c =: storefront];
                    }
                    //displayProductSku = addOnSub.OSM_Display_Product__r.ccrz__SKU__c;
                    displayProductSku = subscriptions[0].ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__SKU__c;
                    subid=subscriptions[0].id;
                    
                    if(subscriptions[0].ccrz__Account__c != Null && subscriptions[0].ccrz__Account__r.ccrz__E_AccountGroup__c != Null){
        
                        Map < String, Object > returnData = new Map < String, Object >();
                        Set<id> prodIds = new Set<id>();
                        prodIds.Add(productId);
                        
                        returnData = ccrz.ccApiPriceList.fetch(new Map < String, Object > {
                        ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                        ccrz.ccApiPriceList.STOREFRONT => 'SoftwareStore',
                        ccrz.ccApiPriceList.EFFACCTID => subscriptions[0].ccrz__Account__c,
                        ccrz.ccApiPriceList.PRODUCTIDS => prodIds
                        });
                        
                        System.debug('returnData---->'+returnData);
                        Map < String, Object > priceListItems = new Map < String, Object >();
                        
                        priceListItems =(Map<String,Object>) returnData.get(ccrz.ccApiPriceList.PRICELISTITEMS);
                        if(priceListItems != Null){
                        for(String str : priceListItems.keyset()){
                           Map<String, Object> Objvalues = (Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(priceListItems.get(str)));
                               subProdIds.Add((Id)Objvalues.get('subProdTerm'));
                           }
                        }
                        system.debug('subProdIds--->>'+subProdIds);
                    }
                    
                    ccrz__E_SubProdTerm__c ccSubProdTerm = new ccrz__E_SubProdTerm__c();
                    ccSubProdTerm=[Select id,name from ccrz__E_SubProdTerm__c where ccrz__DisplayName__c=:addOnSub.ccrz__SPT__r.ccrz__DisplayName__c AND ccrz__CCProduct__r.ccrz__SKU__c=:productSku AND id IN:subProdIds Limit 1];
                    
                    subProdTerm = ccSubProdTerm.id;
                    addOn = 'Add-On';
                }else{
                    displayProductSku = subscriptions[0].ccrz__CCOrderItem__r.ccrz__DisplayProduct__r.ccrz__SKU__c;
                    subid=subscriptions[0].id;
                }//MP-476 Code End
                //Integer counts = Number_of_Counts__c;
                //Integer bundles = Number_of_Bundles__c;
                Decimal dnPrice = 0;
                Decimal price = 0;
                List<ccrz__E_PriceListItem__c> recurringPrices = OSM_SW_ProdDetailUtils_Ctrl.getProductRecurringPrices(new Set<String>{subProdTerm},new Set<String>{store});
                for(ccrz__E_PriceListItem__c pl : recurringPrices){
                     dnPrice = pl.Distributor_Price__c;
                    price = pl.ccrz__Price__c;
                    break;
                }
                
                ccrz.ccApiCart.LineData theNewLine = new ccrz.ccApiCart.LineData();
                theNewLine.sku = productSku;
                theNewLine.parentSku = displayProductSku;
                theNewLine.parentProductId = displayProductId;
                theNewLine.quantity = Decimal.ValueOf(quantity);
                theNewLine.subProdTermId = subProdTerm;
                
                List<ccrz.ccApiCart.LineData> theNewLines = new List<ccrz.ccApiCart.LineData>();
                    theNewLines.add( theNewLine );
                 String theCartSFID = currCartId;          
                if(currCartId == null){
                    ccrz__E_Cart__c eCart = OSM_SW_ProductDetailCommonUtility.createNewCart();
                    for(ccrz__E_Cart__c cartRefetch:[select id,ccrz__EncryptedId__c from ccrz__E_Cart__c where id=:eCart.id]){
                        System.debug('===Cart from newCart is==='+eCart);
                        theCartSFID = cartRefetch.Id;
                        currCartId = cartRefetch.ccrz__EncryptedId__c;
                    }
                    
                }else{
                    ccrz__E_Cart__c cart = OSM_SW_ProdDetailUtils_Ctrl.getUsersCart(currCartId);
                    theCartSFID = cart.Id;
                    currCartId = cart.ccrz__EncryptedId__c;
                }

                //MP-662 Added by Ashish Goyal                
                update new ccrz__E_Cart__c(Id=theCartSFID, ccrz__Account__c = ccrz.cc_CallContext.effAccountId);
                
                List< ccrz__E_CartItem__c >existingCartItems = OSM_SW_ProdDetailUtils_Ctrl.getCartItems(currCartId, productSku);
                if(existingCartItems.size() == 1){
                    delete existingCartItems;
                }
        //MP-476- Code Start - 27-12-2021
            if(addOn=='Add-On'){
            
               Map<String,Object> addResults = ccrz.ccApiCart.addTo(new Map<String,Object>{
                                    ccrz.ccApi.API_VERSION => ccrz.ccAPI.CURRENT_VERSION,
                                        ccrz.ccApiCart.CART_ID => theCartSFID,
                                        ccrz.ccApiCart.LINE_DATA => theNewLines,
                                        ccrz.ccApiCart.ISREPRICE => true
                                        });
                system.debug('addResults --->>'+addResults );
                boolean wasSuccessful = (Boolean)addResults.get(ccrz.ccApi.SUCCESS);
               if(wasSuccessful){
                    List<ccrz__E_CartItem__c> newCartItems = OSM_SW_ProdDetailUtils_Ctrl.getCartItems(currCartId, productSku);
                    if(newCartItems.size()==1){
                        newCartItems[0].Dn_Price__c = dnPrice * Decimal.ValueOf(quantity);
                        newCartItems[0].Unit_Dn_Price__c = dnPrice;
                        newCartItems[0].isRenew__c = true;
                        newCartItems[0].OSM_Renewed_Sub_Id__c=subscriptions[0].id;//MP-573 changes
                        newCartItems[0].Prorated_Price__c = newCartItems[0].ccrz__Price__c;
                        //changes for INC3436464
                        newCartItems[0].Custom_Proration_Price__c = newCartItems[0].ccrz__Price__c;
                        newCartItems[0].OSM_Renew_Subscription_End_Date__c = OSM_SW_ProductDetailCommonUtility.getRenewedSubscriptionEndDate(addOnSub.ccrz__SPT__r.ccrz__DisplayName__c, subscriptions[0].OSM_Subscription_End_Date__c);
                        newCartItems[0].OSM_Renew_Subscription_Start_Date__c = subscriptions[0].OSM_Subscription_End_Date__c;
                        newCartItems[0].OSM_SW_Product_Link__c  = subscriptions[0].OSM_SW_Product_Link__c;
                        newCartItems[0].withCoTerm__c  = true;
                        Database.update(newCartItems, false);
                    }
                }
                
                res.success = true;
                if(!wasSuccessful){
                    //Database.rollback(sp);
                    res.success = false;
                }
              }//MP-476- Code End - 27-12-2021  
                //res.success = true;                                                                    
            }
            Map<String,Object> returnMap = new Map<String,Object>();
            returnMap.put('cartId',currCartId);
      //MP-135 - Start -16-11-2021
            returnMap.put('displayProductSku',displayProductSku);
            returnMap.put('productSku',productSku);
            returnMap.put('renewAddOn',addOn);
            returnMap.put('subid',subid);
        //MP-135 - End -16-11-2021
            res.data = returnMap;
            //res.success=true;
        }
        return res;
    }
    
     /*----------------------------------------------------------------------------------
    6. revokeSubscriptionForNonLic
    Description: Used to revoke order item
    Input: ccrz.cc_RemoteActionContext ctx, Item Id
    
    Output: 
    ccrz.cc_RemoteActionResult
    ------------------------------------------------------------------------------------ */
    @RemoteAction
    global static ccrz.cc_RemoteActionResult revokeSubscriptionForNonLic(ccrz.cc_RemoteActionContext ctx, String selectedItem)
    {
        ccrz.cc_CallContext.initRemoteContext(ctx);
        ccrz.cc_RemoteActionResult res = new ccrz.cc_RemoteActionResult();
        //OSM_ReturnWrapper returnWrapper = OSM_OMS_SW_RevokeAPIUtility.revokeAPIcallSingleInstance(itemLicense.CC_Order_Item__c,itemLicense.Id);
             
        Map < String, Object > SubscriptionDetails = (Map < String, Object > ) JSON.deserializeUntyped(selectedItem);
        String orderItemId = (String)SubscriptionDetails.get('OrderItem');
        
        ccrz__E_OrderItem__c  ojLis = new ccrz__E_OrderItem__c();
        ojLis = [Select Id,Revocation_Status__c from ccrz__E_OrderItem__c where Id =: orderItemId];
        if(ojLis.Revocation_Status__c == 'Revoke Initiated' || ojLis.Revocation_Status__c == 'Revoked')
        {
            res.success = false;
            Map<String,Object> returnMap = new Map<String,Object>();
            returnMap.put('error','Subscription is already being revoked.');
            returnMap.put('alreadyDone',true);
            res.data = returnMap;
        }
        else
        {
            try
            {
                ccrz__E_OrderItem__c  obj = new ccrz__E_OrderItem__c();
                obj.Revocation_Status__c = 'Revoked';
                obj.ccrz__OrderItemStatus__c = 'Revoked';
                obj.Id = orderItemId;
                update obj;
            
                List<ccrz__E_Subscription__c> subs = new List<ccrz__E_Subscription__c>();
                List<OSM_Order_Subscription__c> orderSubscriptions = [Select Id, OSM_CCSubscription__c,OSM_CCSubscription__r.ccrz__Quantity__c, CC_Order_Item__r.Revocation_Status__c,CCQuantity__c, CC_Order_Item__r.ccrz__Quantity__c From OSM_Order_Subscription__c where CC_Order_Item__c =:orderItemId and CC_Order_Item__r.Revocation_Status__c =:'Revoked'];
              
                for(OSM_Order_Subscription__c os : orderSubscriptions)
                {
                    ccrz__E_Subscription__c sub = new ccrz__E_Subscription__c();
                    sub.ccrz__Quantity__c = os.OSM_CCSubscription__r.ccrz__Quantity__c - os.CC_Order_Item__r.ccrz__Quantity__c;
                    sub.Id = os.OSM_CCSubscription__c;
                    subs.add(sub);
                    if(sub.ccrz__Quantity__c==0)
                    {
                        sub.ccrz__SubscriptionStatus__c = 'Revoked';
                    }
                }

                if(subs.size()>0)
                {
                    update subs;
                }
            }
            Catch(Exception ex)
            {
                System.debug('On catch block of revokeSubscriptionForNonLic: '+ex);
            }
                
        }
        return res;
    } 
    
    public class SubscriptionData
    {
        String subscName{get;set;}
        Decimal qty{get;set;}
        String startDate{get;set;}
        String endDate{get;set;}
        String subscSFID{get;set;}
        boolean isRenewed{get;set;}
        long renewedSubscEndDate{get;set;}
        boolean canRenew{get;set;}
        boolean canRenewForAddOn{get;set;}
        String productType{get;set;}
        Map<String,String> licenceToOrderItem{get;set;}
        Map<String,String> orderItemToOrder {get;set;}
        List<SubscriptionItem> subscriptionItemList{get;set;}
        boolean activationKeyErrorMessage{get;set;}
        public SubscriptionData(){
            subscriptionItemList = new List<SubscriptionItem>();
            activationKeyErrorMessage=false;
        }
        
    }
    
    public class SubscriptionItem
    {
        String productName{get;set;}
        String orderItemId{get;set;}
        /* LL-24 Code Start */
        String numberOfBundles{get;set;}
        /* LL-24 Code End */
        String quantity{get;set;}
        String orderDate{get;set;}
        String expireDate{get;set;}
        String orderNumber{get;set;}
    /*MP-133 Code Start*/
        String subscriptionLength{get;set;}
        /*MP-133 Code End*/ 
        String orderid{get;set;}
        String includedItem{get;set;}
        String selectedBasicToolIncId{get;set;}
        String selectedFuncToolIncId{get;set;}
        boolean notHideStdRevoke{get;set;}
        boolean canRevokeAndReissue{get;set;}
        boolean canRevoke{get;set;}
        boolean actionsEnableForBasic{get;set;}
        boolean actionsEnableForFunc{get;set;}
        
        String Producttype;
        Boolean Showincludedlink =false;
        
        List<keys> funcationalKeyLst{get;set;}
        List<keys> basicKeyLst{get;set;}
        List<ToolItem> funcationalToolIdLst{get;set;}
        List<ToolItem> baiscToolIdLst{get;set;}
        
        List<IncludedProduct> lstIncludedProduct {get;set;}
        List<productLicenseInfo> linceseBasicInfoLst{get;set;}
        List<productLicenseInfo> linceseFuncInfoLst{get;set;}
         public SubscriptionItem(){
            notHideStdRevoke = true;
            linceseBasicInfoLst = new List<productLicenseInfo>();
            linceseFuncInfoLst = new List<productLicenseInfo>();
            lstIncludedProduct = new List<IncludedProduct>();
            funcationalToolIdLst = new List<ToolItem>();
            baiscToolIdLst = new List<ToolItem>();
            funcationalKeyLst = new List<keys>();
            basicKeyLst = new List<keys>();
        }
        
    }
    
    public class keys
    {
        String keyId{get;set;}
        String valueStr{get;set;}
        boolean isSelected{get;set;}
        public keys(){
            isSelected = false;
        }
    }
    
    
    public class productLicenseInfo
    {
        String activationKey{get;set;}
        String activationKeyId{get;set;}
        String orderItemId{get;set;}
        String selectedTIK{get;set;}
        List<ToolItem> toolInstanceKey{get;set;}
        public productLicenseInfo(){
            toolInstanceKey = new List<ToolItem>();
        }
        
    }
    
    public class ToolItem
    {
        String toolInstanceKey{get;set;}
        String sfId{get;set;}
        boolean isSelected{get;set;}
        public ToolItem()
        {
            isSelected = false;
        }
    }
    
    public class IncludedProduct{
        String productname{get;set;}
        Integer productQuantiy{get;set;}
    }
    
}