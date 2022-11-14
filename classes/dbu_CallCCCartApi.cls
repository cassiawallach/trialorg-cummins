public without sharing class dbu_CallCCCartApi {
    public static Set<String> InventoryLocationSet = new Set<String>();
    public static Boolean isPartialAvailability;
    
    public static List<dbu_Integration_Error_Log__c> lstIntegrationErrorLogWrapper = new List<dbu_Integration_Error_Log__c>();
    //@AuraEnabled(cacheable=true)
    public static List<dbu_CCCartApiResponseWrapper> fetchCartItemsByCartId(String cartId, String cartStr){
        Map<string,double> productAvailabilMapLocal = new  Map<string,double>();
        List<dbu_CCCartApiResponseWrapper> objlstCCCartApiResponseWrapper =new List<dbu_CCCartApiResponseWrapper>();
        dbu_CCCartApiResponseWrapper objCCCartApiResponseWrapper = new dbu_CCCartApiResponseWrapper();
        System.debug('dbu_CallCCCartApi=>fetchCartItemsByCartId=>cartId===\t'+cartId);
        List<ccrz__E_CartItem__c> lstCartItem = new List<ccrz__E_CartItem__c>();
        List<dbu_CartItemWrapper> lstCartItemWrapper = new List<dbu_CartItemWrapper>();
        
        
        
        // Calculating Shipping Cost
        Decimal estimatedShippingCost = 0.00;
        estimatedShippingCost = dbu_CheckOutCntrl.updateShippingAmountOnCart(true,cartId,'isEstimated');

        //Sandeep starts - Cart
        Decimal totalCostShipped = 0.00;
        totalCostShipped = dbu_CheckOutCntrl.calculateCostShipmentProduct(true,cartId,'isEstimated');
        //Sandeep ends - Cart
        
        //added by Ranadip for Security
        if(!dbu_UserValidation.validateUserForCart(cartId)){
            return new List<dbu_CCCartApiResponseWrapper>();
        }// end here 
        
        //List<dbu_PicklistOptions> objPicklistOptions = new List<dbu_PicklistOptions>();
        /*New Logic 27Aug2020*/
        /********************************************
        SetuP MAP for CartToFetch
        ********************************************/    
        Map<String, Object> cartToFetch = new Map<String, Object> {
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccApiCart.CART_ID => cartID,
            ccrz.ccAPI.SIZING => new Map<String, Object>{
                ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                }
            }
        };
        /********************************************
        
        Fire the ccrz.ccApiCart.fetch API
        
        ********************************************/        
        try {
            Boolean wasSuccessful = false;
            Map<String, Object> cartFetchResults = ccrz.ccApiCart.fetch(cartToFetch);
            system.debug(cartFetchResults);
            wasSuccessful = (Boolean)cartFetchResults.get(ccrz.ccApi.SUCCESS);
            system.debug(wasSuccessful);
            
            List<Map<String, Object>> outputCartList = (List<Map<String, Object>>) cartFetchResults.get(ccrz.ccAPICart.CART_OBJLIST);
            system.debug('key>>>' +JSON.serialize(outputCartList));
                       
            ccrz__E_Cart__c cartObj = new ccrz__E_Cart__c();
            cartObj = [select id, dbu_Total_Gift_Card_Amount__c,dbu_Free_Shipping__c,ccrz__BillTo__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__shipTo__c,ccrz__shipTo__r.ccrz__AddressFirstline__c,ccrz__shipTo__r.ccrz__City__c,ccrz__shipTo__r.ccrz__State__c,ccrz__shipTo__r.ccrz__Country__c,ccrz__shipTo__r.ccrz__PostalCode__c,ccrz__shipTo__r.ccrz__FirstName__c,ccrz__shipTo__r.ccrz__LastName__c,dbu_Pick_Up_From_Store__c,dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,dbu_Pick_Up_From_Store__r.ccrz__City__c,dbu_Pick_Up_From_Store__r.ccrz__State__c,dbu_Pick_Up_From_Store__r.ccrz__Country__c,dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c,dbu_Pick_Up_From_Store__r.dbu_PickUp_Store_Name__c,dbu_Pick_Up_From_Store__r.dbu_TimeZone__c,dbu_Pick_Up_From_Store__r.dbu_zone__c from ccrz__E_Cart__c where id =: cartId ];
            System.debug('cartObj========'+cartObj);
            /*Getting the Cart Details here*/
          		ccrz__E_Cart__c cartDetails = new ccrz__E_Cart__c();
                /*Setting up the address of ShipTo, BillTo and Pickup*/
               	setCCAddress(cartObj, cartDetails);
            	/*Ended here*/
                //System.debug('strKey===========\t'+strKey+'Value ====\t'+outputCartList[0].get(strKey));
                cartDetails.ccrz__CartId__c = (String)outputCartList[0].get('sfid');
                cartDetails.OwnerId =   (String)outputCartList[0].get('ownerId');
                //cartDetails.Name =        (String)outputCartList[0].get('sfdcName'); Not Writeable
                cartDetails.ccrz__EncryptedId__c =  (String)outputCartList[0].get('encryptedId');
                cartDetails.ccrz__ActiveCart__c = (Boolean)outputCartList[0].get('activeCart');
                cartDetails.ccrz__CartStatus__c = (String)outputCartList[0].get('cartStatus');
                cartDetails.ccrz__CartType__c = (String)outputCartList[0].get('cartType');
                cartDetails.lastModifiedDate = (Datetime)outputCartList[0].get('lastModifiedDate');
                //cartDetails.ccrz__SubtotalAmount__c = (String)outputCartList[0].get('subtotalAmount');Not Writable Need to create other field to hold
                cartDetails.ccrz__Name__c = (String)outputCartList[0].get('name');
                cartDetails.ccrz__TaxExemptFlag__c = (Boolean)outputCartList[0].get('taxExemptFlag');
                //cartDetails.ccrz__TotalAmount__c = (String)outputCartList[0].get('totalAmount');Not Writable Need to create other field to hold
                cartDetails.ccrz__CurrencyISOCode__c = (String)outputCartList[0].get('currencyISOCode');
                //cartDetails.ccrz__TaxSubTotalAmount__c = (String)outputCartList[0].get('taxSubTotalAmount');Not Writable Need to create other field to hold
                //cartDetails.ccrz__TotalQuantity__c = (String)outputCartList[0].get('totalQuantity');Not Writable Need to create other field to hold
                cartDetails.ccrz__Account__c = (String)outputCartList[0].get('account');
                cartDetails.ccrz__AnonymousId__c = (Boolean)outputCartList[0].get('anonymousId');
                cartDetails.ccrz__RepricedDate__c = (Datetime)outputCartList[0].get('repricedDate');
                cartDetails.ccrz__ShipComplete__c = (Boolean)outputCartList[0].get('shipComplete');
                cartDetails.ccrz__Storefront__c = (String)outputCartList[0].get('storefront');
                cartDetails.ccrz__User__c = (String)outputCartList[0].get('user');
            	cartDetails.ccrz__BuyerFirstName__c = (String)outputCartList[0].get('buyerFirstName');
				cartDetails.ccrz__BuyerLastName__c = (String)outputCartList[0].get('buyerLastName');
                cartDetails.dbu_StoreCode__c = (String)outputCartList[0].get('dbuStoreCode');
                cartDetails.dbu_Free_Shipping__c = cartObj.dbu_Free_Shipping__c;
                cartDetails.dbu_Cart_StoreCountry__c = (String)outputCartList[0].get('dbuCartStoreCountry');
                cartDetails.dbu_optEmailNotification__c =  (Boolean)outputCartList[0].get('dbuoptEmailNotification');
                objCCCartApiResponseWrapper.cartDetails = cartDetails;
                Decimal sbTotalAmt = (Decimal)outputCartList[0].get('subtotalAmount');
                sbTotalAmt = sbTotalAmt.setScale(2);
                objCCCartApiResponseWrapper.subtotalAmount = sbTotalAmt;
                objCCCartApiResponseWrapper.totalAmount = (Decimal)outputCartList[0].get('totalAmount');
                objCCCartApiResponseWrapper.taxSubTotalAmount = (Decimal)outputCartList[0].get('taxSubTotalAmount');
                objCCCartApiResponseWrapper.totalQuantity = (Decimal)outputCartList[0].get('totalQuantity');
                objCCCartApiResponseWrapper.totalGiftCardAmount = cartObj.dbu_Total_Gift_Card_Amount__c; // promotions Changes
            
            	// Shipping Cost Calculation shippingAmount
            	Decimal updatetdShipingAmount = 0.0;
            	updatetdShipingAmount = (Decimal)outputCartList[0].get('shipAmount');
            	if(updatetdShipingAmount > 0){
                	objCCCartApiResponseWrapper.totalShippingAmount = updatetdShipingAmount;
                }else {
                    objCCCartApiResponseWrapper.totalShippingAmount = updatetdShipingAmount;
                }
            	objCCCartApiResponseWrapper.shippingAmount = estimatedShippingCost;
                //Sandeep starts - Cart
                objCCCartApiResponseWrapper.costShippedProduct = totalCostShipped; 
                //Sandeep ends - Cart
            	//End Here
            /*Getting here CartItem Details*/
                
            System.debug('ECartItemsS===='+outputCartList[0].get('ECartItemsS'));
            List<Map<String, Object>> outputCartItemsList = (List<Map<String, Object>>) outputCartList[0].get('ECartItemsS');
            System.debug('outputCartItemsList===='+outputCartItemsList);
            
            /*Here getting the product lst by Iterationg*/
            List<String> lstProductIds = new List<String>();
            for(Map<String, Object> obj : outputCartItemsList){
                lstProductIds.add((String)obj.get('product'));
                 System.debug('obj====-------------------------------------------'+obj);
                System.debug('lstProductIds===='+(String)obj.get('product'));
            }
            /**22 Feb end 2021 */
            productAvailabilMapLocal =  getProductAvailabilMapLocal(lstProductIds,cartDetails.ccrz__CurrencyISOCode__c);
            System.debug('productAvailabilMapLocal==========\t'+productAvailabilMapLocal);
            System.debug('List of Product Id ==========\t'+lstProductIds);
            /* Fetching the List of Product Details by using Calling the cc api passing list of Product Id update CECI-960*/
            Map<String, dbu_CCApiCartRelatedResponseWrapper> mapOfIdProduct = getProductAndMedia(lstProductIds,cartDetails.ccrz__CurrencyISOCode__c);
            System.debug('getProductAndMedia===================\t'+mapOfIdProduct);
            /*Ended here*/
            
            for(Map<String, Object> obj : outputCartItemsList){
                    //System.debug('obj=====\t'+obj);
                    dbu_CartItemWrapper objCartItemWrapper = new dbu_CartItemWrapper();
                    //System.debug('strKey===========\t'+strKey+'Value ====\t'+outputCartList[0].get(strKey));
                    ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
                    cartItem.Id = (String)obj.get('sfid');
                    //cartItem.Name = (String)obj.get('sfdcNameValue');
                    //cartItem.ccrz__Cart__c = (String)obj.get('cart');
                     String productId = (String)obj.get('product');
                    System.debug('productValue===================\t'+productId);
                    cartItem.ccrz__Product__c = productId;
                    cartItem.ccrz__Quantity__c = (Decimal)obj.get('quantity');
                    //cartItem.ccrz__PrimaryAttr__c = obj.get('primaryAttrValue');
                    cartItem.ccrz__Price__c = (Decimal)obj.get('price');
                    cartItem.ccrz__ProductType__c = (String)obj.get('productType');
                    cartItem.ccrz__StoreID__c = (String)obj.get('storeID');
                    cartItem.ccrz__PricingType__c = (String)obj.get('pricingType');
                    //cartItem.ccrz__ItemTotal__c = (Decimal)obj.get('itemTotalValue');//Field is not writeable so have taken other one
                    cartItem.ccrz__cartItemType__c = (String)obj.get('cartItemType');
                    cartItem.ccrz__SubAmount__c = ((Decimal)obj.get('subAmount')).setScale(2);
                    cartItem.ccrz__UnitOfMeasure__c = (String)obj.get('unitOfMeasure');
                    cartItem.ccrz__ParentCartItem__c = (String)obj.get('parentCartItem');
                    cartItem.ccrz__ItemStatus__c = (String)obj.get('itemStatus');
                    cartItem.ccrz__Is_Subscription_Selected__c = (Boolean)obj.get('isSubscriptionSelected');
                    cartItem.ccrz__OriginalQuantity__c = (Decimal)obj.get('originalQuantity');
                    cartItem.ccrz__OriginalItemPrice__c = (Decimal)obj.get('originalItemPrice');
                    cartItem.ccrz__RequestDate__c = (Date)obj.get('requestDate');
                    cartItem.dbu_isShipTo__c = (Boolean)obj.get('dbuisShipTo');
                	cartItem.dbu_Estimated_Delivery__c = (string)obj.get('dbuEstimatedDelivery');
                	cartItem.dbu_Estimated_PickUp__c = (string)obj.get('dbuEstimatedPickUp');
                    objCartItemWrapper.cartItem = cartItem;
                    objCartItemWrapper.ItemTotal = (Decimal)obj.get('itemTotal');
                    System.debug('mapOfIdProduct.containsKey(productId)\t'+mapOfIdProduct.containsKey(productId));
                    if(mapOfIdProduct.containsKey(productId)){
                        objCartItemWrapper.cartItemProductDetailWrapper =  mapOfIdProduct.get(productId);
                        if(objCartItemWrapper.cartItemProductDetailWrapper.URI == null){
                            objCartItemWrapper.cartItemProductDetailWrapper.URI = system.label.dbu_DefaultProductImage;
                        }
                        /*new logic for options*/
                        System.debug('mapOfIdProduct.get(productId).qtyAvailable====='+mapOfIdProduct.get(productId).qtyAvailable);
                        //this will be uncommented once live inventory check will be happen  and below if conditon will be commented
                        //objCartItemWrapper.qtyAvailable = mapOfIdProduct.get(productId).qtyAvailable;
                        if(productAvailabilMapLocal.get(productId) != null){       
                            objCartItemWrapper.qtyAvailable = Integer.valueOf(productAvailabilMapLocal.get(productId));
                        }
                        /*ended here*/
                    }
                lstCartItemWrapper.add(objCartItemWrapper);
            }
            /*Here will be the logic of calling the check available quantity for the */
            System.debug('Before the instock and out stock check====>'+lstCartItemWrapper);
            /*Shriram:- Commented bcoz no live check now*/
            if(String.isNotBlank(cartStr)){
                getProductAvailabilMap(cartDetails,lstCartItemWrapper,lstProductIds,objCCCartApiResponseWrapper.cartDetails.ccrz__CurrencyISOCode__c);
            }
            System.debug('After the instock and out stock check====>'+lstCartItemWrapper);
            /*End of the logic*/
                  objCCCartApiResponseWrapper.lstCartItem = lstCartItemWrapper;
                  /*Temporary Logic*/
                  List<ccrz__E_Cart__c> lstCart = [select id,ccrz__TaxAmount__c,ccrz__TotalDiscount__c,Total_Cart_Discount__c,Original_Cart_Total__c from ccrz__E_Cart__c where id =: cartId];
                  if(lstCart.size() > 0 && lstCart[0].ccrz__TaxAmount__c != null)
                        objCCCartApiResponseWrapper.taxAmount = lstCart[0].ccrz__TaxAmount__c;
                  else{
                        objCCCartApiResponseWrapper.taxAmount = 0.00;
                  }
                  //Following Logic Modified by Malhar for Coupon related change - 17 March 2021 - begin
                    if(lstCart.size() > 0 && lstCart[0].ccrz__TotalDiscount__c != null){
                        if(lstCart[0].ccrz__TotalDiscount__c < 0){
                            objCCCartApiResponseWrapper.totalCartDiscount = ((lstCart[0].ccrz__TotalDiscount__c) * -1);
                        }else{
                            objCCCartApiResponseWrapper.totalCartDiscount = lstCart[0].ccrz__TotalDiscount__c;  
                        }              
                        
                    }else{
                        objCCCartApiResponseWrapper.totalCartDiscount = 0.00;
                    }                 
                  //Following Logic Modified by Malhar for Coupon related change - 17 March 2021 - end
            if(lstCart.size() > 0 && lstCart[0].Original_Cart_Total__c != null)
                objCCCartApiResponseWrapper.originalCartAmt = lstCart[0].Original_Cart_Total__c;
            else{
                objCCCartApiResponseWrapper.originalCartAmt = 0.00;
            }
            System.debug('isPartialAvailability==='+isPartialAvailability);
            objCCCartApiResponseWrapper.isPartialAvailability = isPartialAvailability;
            		/**/
                  objlstCCCartApiResponseWrapper.add(objCCCartApiResponseWrapper);

            decimal cartTotal = (Decimal) outputCartList[0].get('totalAmount');
            system.debug('cartTotal: '+cartTotal);
            } catch (Exception e) {
                // Error handling...
                system.debug('Error message in the dbu_CallCCCartApi'+e.getMessage()+'\tLineNumber\t'+e.getLineNumber());
            }
        /*Till here*/
		
        return objlstCCCartApiResponseWrapper;
      }
    
    public static void setCCAddress(ccrz__E_Cart__c cartObj,ccrz__E_Cart__c cartDetails){
        if(cartObj != null && cartObj.dbu_Pick_Up_From_Store__c != null){
            try{
                System.debug('cartObj.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c========'+cartObj.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c);
                ccrz__E_ContactAddr__c objContactAddr = new ccrz__E_ContactAddr__c();
                objContactAddr.ccrz__AddressFirstline__c = cartObj.dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c;
                objContactAddr.ccrz__City__c = cartObj.dbu_Pick_Up_From_Store__r.ccrz__City__c;
                objContactAddr.ccrz__State__c = cartObj.dbu_Pick_Up_From_Store__r.ccrz__State__c;
                objContactAddr.ccrz__Country__c = cartObj.dbu_Pick_Up_From_Store__r.ccrz__Country__c;
                objContactAddr.ccrz__PostalCode__c = cartObj.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c;
                objContactAddr.dbu_StartEndTimeOfStore__c = cartObj.dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c;
                objContactAddr.dbu_PickUp_Store_Name__c =  cartObj.dbu_Pick_Up_From_Store__r.dbu_PickUp_Store_Name__c;
                objContactAddr.dbu_TimeZone__c =  cartObj.dbu_Pick_Up_From_Store__r.dbu_TimeZone__c;
                objContactAddr.dbu_zone__c =  cartObj.dbu_Pick_Up_From_Store__r.dbu_zone__c;
                System.debug('objContactAddr===\t'+objContactAddr);
                cartDetails.dbu_Pick_Up_From_Store__r = objContactAddr;
                System.debug('cartDetails.dbu_Pick_Up_From_Store__r===\t'+cartDetails.dbu_Pick_Up_From_Store__r);
            }catch(exception ex){
                System.debug('Exception while settingup the pickup address in the setccaddress method\t'+ex.getMessage()+'Line No:- '+ex.getLineNumber());
            }
            
        }
        if(cartObj != null && cartObj.ccrz__BillTo__c != null){
            System.debug('cartObj.ccrz__BillTo__c.ccrz__AddressFirstline__c========'+cartObj.ccrz__BillTo__r.ccrz__AddressFirstline__c);
            ccrz__E_ContactAddr__c objContactAddr = new ccrz__E_ContactAddr__c();
            objContactAddr.ccrz__AddressFirstline__c = cartObj.ccrz__BillTo__r.ccrz__AddressFirstline__c;
            objContactAddr.ccrz__City__c = cartObj.ccrz__BillTo__r.ccrz__City__c;
            objContactAddr.ccrz__State__c = cartObj.ccrz__BillTo__r.ccrz__State__c;
            objContactAddr.ccrz__Country__c = cartObj.ccrz__BillTo__r.ccrz__Country__c;
            objContactAddr.ccrz__PostalCode__c = cartObj.ccrz__BillTo__r.ccrz__PostalCode__c;
            cartDetails.ccrz__BillTo__r = objContactAddr;
        }
        
        if(cartObj != null && cartObj.ccrz__shipTo__c != null){
            System.debug('cartObj.ccrz__shipTo__r.ccrz__AddressFirstline__c========'+cartObj.ccrz__shipTo__r.ccrz__AddressFirstline__c);
            ccrz__E_ContactAddr__c objContactAddr = new ccrz__E_ContactAddr__c();
            objContactAddr.ccrz__AddressFirstline__c = cartObj.ccrz__shipTo__r.ccrz__AddressFirstline__c;
            objContactAddr.ccrz__City__c = cartObj.ccrz__shipTo__r.ccrz__City__c;
            objContactAddr.ccrz__State__c = cartObj.ccrz__shipTo__r.ccrz__State__c;
            objContactAddr.ccrz__Country__c = cartObj.ccrz__shipTo__r.ccrz__Country__c;
            objContactAddr.ccrz__PostalCode__c = cartObj.ccrz__shipTo__r.ccrz__PostalCode__c;
            objContactAddr.ccrz__LastName__c = cartObj.ccrz__shipTo__r.ccrz__LastName__c;
            objContactAddr.ccrz__FirstName__c = cartObj.ccrz__shipTo__r.ccrz__FirstName__c;    
            cartDetails.ccrz__shipTo__r = objContactAddr;
        }
            	
    }

    //@AuraEnabled(cacheable=true)
    public static List<dbu_CCCartApiResponseWrapper> fetchCartItemsByCartId(String cartId){
        Map<string,double> productAvailabilMapLocal = new  Map<string,double>();
		List<dbu_CCCartApiResponseWrapper> objlstCCCartApiResponseWrapper =new List<dbu_CCCartApiResponseWrapper>();
        dbu_CCCartApiResponseWrapper objCCCartApiResponseWrapper = new dbu_CCCartApiResponseWrapper();
        System.debug('dbu_CallCCCartApi=>fetchCartItemsByCartId=>cartId===\t'+cartId);
        List<ccrz__E_CartItem__c> lstCartItem = new List<ccrz__E_CartItem__c>();
        List<dbu_CartItemWrapper> lstCartItemWrapper = new List<dbu_CartItemWrapper>();
        
        // Calculating Shipping Cost
        Decimal estimatedShippingCost = 0.00;
        estimatedShippingCost = dbu_CheckOutCntrl.updateShippingAmountOnCart(true,cartId,'isEstimated');

        //Sandeep starts - Cart
        Decimal totalCostShipped = 0.00;
        totalCostShipped = dbu_CheckOutCntrl.calculateCostShipmentProduct(true,cartId,'isEstimated');
        //Sandeep ends - Cart
        
        //added by Ranadip for Security
        if(!dbu_UserValidation.validateUserForCart(cartId)){
            return new List<dbu_CCCartApiResponseWrapper>();
        }// end here 
        
        //List<dbu_PicklistOptions> objPicklistOptions = new List<dbu_PicklistOptions>();
        /*New Logic 27Aug2020*/
        /********************************************
        SetuP MAP for CartToFetch
        ********************************************/    
        Map<String, Object> cartToFetch = new Map<String, Object> {
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccApiCart.CART_ID => cartID,
            ccrz.ccAPI.SIZING => new Map<String, Object>{
                ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                }
            }
        };
        /********************************************
        
        Fire the ccrz.ccApiCart.fetch API
        
        ********************************************/        
        try {
            Boolean wasSuccessful = false;
            Map<String, Object> cartFetchResults = ccrz.ccApiCart.fetch(cartToFetch);
            system.debug(cartFetchResults);
            wasSuccessful = (Boolean)cartFetchResults.get(ccrz.ccApi.SUCCESS);
            system.debug(wasSuccessful);
            
            List<Map<String, Object>> outputCartList = (List<Map<String, Object>>) cartFetchResults.get(ccrz.ccAPICart.CART_OBJLIST);
            system.debug('key>>>' +JSON.serialize(outputCartList));
                       
            ccrz__E_Cart__c cartObj = new ccrz__E_Cart__c();
            cartObj = [select id, dbu_Total_Gift_Card_Amount__c,dbu_Free_Shipping__c,ccrz__BillTo__c,ccrz__BillTo__r.ccrz__AddressFirstline__c,ccrz__BillTo__r.ccrz__City__c,ccrz__BillTo__r.ccrz__State__c,ccrz__BillTo__r.ccrz__Country__c,ccrz__BillTo__r.ccrz__PostalCode__c,ccrz__shipTo__c,ccrz__shipTo__r.ccrz__AddressFirstline__c,ccrz__shipTo__r.ccrz__City__c,ccrz__shipTo__r.ccrz__State__c,ccrz__shipTo__r.ccrz__Country__c,ccrz__shipTo__r.ccrz__PostalCode__c,ccrz__shipTo__r.ccrz__FirstName__c,ccrz__shipTo__r.ccrz__LastName__c,dbu_Pick_Up_From_Store__c,dbu_Pick_Up_From_Store__r.ccrz__AddressFirstline__c,dbu_Pick_Up_From_Store__r.ccrz__City__c,dbu_Pick_Up_From_Store__r.ccrz__State__c,dbu_Pick_Up_From_Store__r.ccrz__Country__c,dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,dbu_Pick_Up_From_Store__r.dbu_StartEndTimeOfStore__c,dbu_Pick_Up_From_Store__r.dbu_PickUp_Store_Name__c,dbu_Pick_Up_From_Store__r.dbu_TimeZone__c,dbu_Pick_Up_From_Store__r.dbu_zone__c from ccrz__E_Cart__c where id =: cartId ];
            System.debug('cartObj========'+cartObj);
            /*Getting the Cart Details here*/
          		ccrz__E_Cart__c cartDetails = new ccrz__E_Cart__c();
                /*Setting up the address of ShipTo, BillTo and Pickup*/
               	setCCAddress(cartObj, cartDetails);
            	/*Ended here*/
                //System.debug('strKey===========\t'+strKey+'Value ====\t'+outputCartList[0].get(strKey));
                cartDetails.ccrz__CartId__c = (String)outputCartList[0].get('sfid');
                cartDetails.OwnerId =   (String)outputCartList[0].get('ownerId');
                //cartDetails.Name =        (String)outputCartList[0].get('sfdcName'); Not Writeable
                cartDetails.ccrz__EncryptedId__c =  (String)outputCartList[0].get('encryptedId');
                cartDetails.ccrz__ActiveCart__c = (Boolean)outputCartList[0].get('activeCart');
                cartDetails.ccrz__CartStatus__c = (String)outputCartList[0].get('cartStatus');
                cartDetails.ccrz__CartType__c = (String)outputCartList[0].get('cartType');
                cartDetails.lastModifiedDate = (Datetime)outputCartList[0].get('lastModifiedDate');
                //cartDetails.ccrz__SubtotalAmount__c = (String)outputCartList[0].get('subtotalAmount');Not Writable Need to create other field to hold
                cartDetails.ccrz__Name__c = (String)outputCartList[0].get('name');
                cartDetails.ccrz__TaxExemptFlag__c = (Boolean)outputCartList[0].get('taxExemptFlag');
                //cartDetails.ccrz__TotalAmount__c = (String)outputCartList[0].get('totalAmount');Not Writable Need to create other field to hold
                cartDetails.ccrz__CurrencyISOCode__c = (String)outputCartList[0].get('currencyISOCode');
                //cartDetails.ccrz__TaxSubTotalAmount__c = (String)outputCartList[0].get('taxSubTotalAmount');Not Writable Need to create other field to hold
                //cartDetails.ccrz__TotalQuantity__c = (String)outputCartList[0].get('totalQuantity');Not Writable Need to create other field to hold
                cartDetails.ccrz__Account__c = (String)outputCartList[0].get('account');
                cartDetails.ccrz__AnonymousId__c = (Boolean)outputCartList[0].get('anonymousId');
                cartDetails.ccrz__RepricedDate__c = (Datetime)outputCartList[0].get('repricedDate');
                cartDetails.ccrz__ShipComplete__c = (Boolean)outputCartList[0].get('shipComplete');
                cartDetails.ccrz__Storefront__c = (String)outputCartList[0].get('storefront');
                cartDetails.ccrz__User__c = (String)outputCartList[0].get('user');
            	cartDetails.ccrz__BuyerFirstName__c = (String)outputCartList[0].get('buyerFirstName');
				cartDetails.ccrz__BuyerLastName__c = (String)outputCartList[0].get('buyerLastName');
                cartDetails.dbu_StoreCode__c = (String)outputCartList[0].get('dbuStoreCode');
                cartDetails.dbu_Free_Shipping__c = cartObj.dbu_Free_Shipping__c;
                cartDetails.dbu_Cart_StoreCountry__c = (String)outputCartList[0].get('dbuCartStoreCountry');
                objCCCartApiResponseWrapper.cartDetails = cartDetails;
                Decimal sbTotalAmt = (Decimal)outputCartList[0].get('subtotalAmount');
                sbTotalAmt = sbTotalAmt.setScale(2);
                objCCCartApiResponseWrapper.subtotalAmount = sbTotalAmt;
                objCCCartApiResponseWrapper.totalAmount = (Decimal)outputCartList[0].get('totalAmount');
                objCCCartApiResponseWrapper.taxSubTotalAmount = (Decimal)outputCartList[0].get('taxSubTotalAmount');
                objCCCartApiResponseWrapper.totalQuantity = (Decimal)outputCartList[0].get('totalQuantity');
            	// Estimated Shipping Cost Calculation
            	objCCCartApiResponseWrapper.shippingAmount = estimatedShippingCost;
                //Sandeep starts - Cart
                objCCCartApiResponseWrapper.costShippedProduct = totalCostShipped; 
                //Sandeep ends - Cart
            	// End here
                objCCCartApiResponseWrapper.totalGiftCardAmount = cartObj.dbu_Total_Gift_Card_Amount__c; // promotions Changes
            /*Getting here CartItem Details*/
            System.debug('cartDetails===='+cartDetails);    
            System.debug('ECartItemsS===='+outputCartList[0].get('ECartItemsS'));
            List<Map<String, Object>> outputCartItemsList = (List<Map<String, Object>>) outputCartList[0].get('ECartItemsS');
            System.debug('outputCartItemsList===='+outputCartItemsList);
            
            /*Here getting the product lst by Iterationg*/
            List<String> lstProductIds = new List<String>();
            for(Map<String, Object> obj : outputCartItemsList){
                lstProductIds.add((String)obj.get('product'));
                 System.debug('obj====-------------------------------------------'+obj);
                System.debug('lstProductIds===='+(String)obj.get('product'));
            }
            /**22 Feb end 2021 */
            productAvailabilMapLocal =  getProductAvailabilMapLocal(lstProductIds,cartDetails.ccrz__CurrencyISOCode__c);
            System.debug('productAvailabilMapLocal==========\t'+productAvailabilMapLocal);
            System.debug('List of Product Id ==========\t'+lstProductIds);
            /* Fetching the List of Product Details by using Calling the cc api passing list of Product Id*/
            Map<String, dbu_CCApiCartRelatedResponseWrapper> mapOfIdProduct = getProductAndMedia(lstProductIds,cartDetails.ccrz__CurrencyISOCode__c);
            System.debug('getProductAndMedia===================\t'+mapOfIdProduct);
            /*Ended here*/
            
            for(Map<String, Object> obj : outputCartItemsList){
                    //System.debug('obj=====\t'+obj);
                    dbu_CartItemWrapper objCartItemWrapper = new dbu_CartItemWrapper();
                    //System.debug('strKey===========\t'+strKey+'Value ====\t'+outputCartList[0].get(strKey));
                    ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
                    cartItem.Id = (String)obj.get('sfid');
                    //cartItem.Name = (String)obj.get('sfdcNameValue');
                    //cartItem.ccrz__Cart__c = (String)obj.get('cart');
                     String productId = (String)obj.get('product');
                    System.debug('productValue===================\t'+productId);
                    cartItem.ccrz__Product__c = productId;
                    cartItem.ccrz__Quantity__c = (Decimal)obj.get('quantity');
                    //cartItem.ccrz__PrimaryAttr__c = obj.get('primaryAttrValue');
                    cartItem.ccrz__Price__c = (Decimal)obj.get('price');
                    cartItem.ccrz__ProductType__c = (String)obj.get('productType');
                    cartItem.ccrz__StoreID__c = (String)obj.get('storeID');
                    cartItem.ccrz__PricingType__c = (String)obj.get('pricingType');
                    //cartItem.ccrz__ItemTotal__c = (Decimal)obj.get('itemTotalValue');//Field is not writeable so have taken other one
                    cartItem.ccrz__cartItemType__c = (String)obj.get('cartItemType');
                    cartItem.ccrz__SubAmount__c = ((Decimal)obj.get('subAmount')).setScale(2);
                    cartItem.ccrz__UnitOfMeasure__c = (String)obj.get('unitOfMeasure');
                    cartItem.ccrz__ParentCartItem__c = (String)obj.get('parentCartItem');
                    cartItem.ccrz__ItemStatus__c = (String)obj.get('itemStatus');
                    cartItem.ccrz__Is_Subscription_Selected__c = (Boolean)obj.get('isSubscriptionSelected');
                    cartItem.ccrz__OriginalQuantity__c = (Decimal)obj.get('originalQuantity');
                    cartItem.ccrz__OriginalItemPrice__c = (Decimal)obj.get('originalItemPrice');
                    cartItem.ccrz__RequestDate__c = (Date)obj.get('requestDate');
                    cartItem.dbu_isShipTo__c = (Boolean)obj.get('dbuisShipTo');
                	cartItem.dbu_Estimated_Delivery__c = (string)obj.get('dbuEstimatedDelivery');
                	cartItem.dbu_Estimated_PickUp__c = (string)obj.get('dbuEstimatedPickUp');
                    objCartItemWrapper.cartItem = cartItem;
                    objCartItemWrapper.ItemTotal = (Decimal)obj.get('itemTotal');
                    System.debug('mapOfIdProduct.containsKey(productId)\t'+mapOfIdProduct.containsKey(productId));
                    if(mapOfIdProduct.containsKey(productId)){
                        objCartItemWrapper.cartItemProductDetailWrapper =  mapOfIdProduct.get(productId);
                        if(objCartItemWrapper.cartItemProductDetailWrapper.URI == null){
                            objCartItemWrapper.cartItemProductDetailWrapper.URI = system.label.dbu_DefaultProductImage;
                        }
                        /*new logic for options*/
                        System.debug('mapOfIdProduct.get(productId).qtyAvailable====='+mapOfIdProduct.get(productId).qtyAvailable);
                        //this will be uncommented once live inventory check will be happen  and below if conditon will be commented
                        //objCartItemWrapper.qtyAvailable = mapOfIdProduct.get(productId).qtyAvailable;
                        if(productAvailabilMapLocal.get(productId) != null){       
                            objCartItemWrapper.qtyAvailable = Integer.valueOf(productAvailabilMapLocal.get(productId));
                        }
                        /*ended here*/
                    }
                lstCartItemWrapper.add(objCartItemWrapper);
            }
            /*Here will be the logic of calling the check available quantity for the */
            System.debug('Before the instock and out stock check====>'+lstCartItemWrapper);
            /*Shriram:- Commented bcoz no live check now*/
            // if(String.isNotBlank(cartStr)){
            //     getProductAvailabilMap(cartDetails,lstCartItemWrapper,lstProductIds,objCCCartApiResponseWrapper.cartDetails.ccrz__CurrencyISOCode__c);
            // }
            System.debug('After the instock and out stock check====>'+lstCartItemWrapper);
            /*End of the logic*/
            	  objCCCartApiResponseWrapper.lstCartItem = lstCartItemWrapper;
                  /*Temporary Logic*/
                  List<ccrz__E_Cart__c> lstCart = [select id,ccrz__TaxAmount__c,ccrz__TotalDiscount__c,Total_Cart_Discount__c,Original_Cart_Total__c from ccrz__E_Cart__c where id =: cartId];
             	  if(lstCart.size() > 0 && lstCart[0].ccrz__TaxAmount__c != null)
                        objCCCartApiResponseWrapper.taxAmount = lstCart[0].ccrz__TaxAmount__c;
                  else{
                        objCCCartApiResponseWrapper.taxAmount = 0.00;
                  }
            	  //Following Logic Modified by Malhar for Coupon related change - 17 March 2021 - begin
                    if(lstCart.size() > 0 && lstCart[0].ccrz__TotalDiscount__c != null){
                        if(lstCart[0].ccrz__TotalDiscount__c < 0){
                            objCCCartApiResponseWrapper.totalCartDiscount = ((lstCart[0].ccrz__TotalDiscount__c) * -1);
                        }else{
                            objCCCartApiResponseWrapper.totalCartDiscount = lstCart[0].ccrz__TotalDiscount__c;  
                        }              
                        
                    }else{
                        objCCCartApiResponseWrapper.totalCartDiscount = 0.00;
                    }            	  
            	  //Following Logic Modified by Malhar for Coupon related change - 17 March 2021 - end
            if(lstCart.size() > 0 && lstCart[0].Original_Cart_Total__c != null)
                objCCCartApiResponseWrapper.originalCartAmt = lstCart[0].Original_Cart_Total__c;
            else{
                objCCCartApiResponseWrapper.originalCartAmt = 0.00;
            }
            
            		/**/
                  objlstCCCartApiResponseWrapper.add(objCCCartApiResponseWrapper);

            decimal cartTotal = (Decimal) outputCartList[0].get('totalAmount');
            system.debug('cartTotal: '+cartTotal);
            } catch (Exception e) {
                // Error handling...
                system.debug('Error message in the dbu_CallCCCartApi'+e.getMessage()+'\tLineNumber\t'+e.getLineNumber());
            }
        /*Till here*/
        return objlstCCCartApiResponseWrapper;
      }
    
    /////////////////////////////////////////////////////////////////////@AuraEnabled(cacheable=true)
    // public static List<dbu_CCCartApiResponseWrapper> fetchCartItemsByCartId(String cartId){
	// 	List<dbu_CCCartApiResponseWrapper> objlstCCCartApiResponseWrapper =new List<dbu_CCCartApiResponseWrapper>();
    //     dbu_CCCartApiResponseWrapper objCCCartApiResponseWrapper = new dbu_CCCartApiResponseWrapper();
    //     System.debug('dbu_CallCCCartApi=>fetchCartItemsByCartId=>cartId===\t'+cartId);
    //     List<ccrz__E_CartItem__c> lstCartItem = new List<ccrz__E_CartItem__c>();
    //     List<dbu_CartItemWrapper> lstCartItemWrapper = new List<dbu_CartItemWrapper>();
    //     /*New Logic 27Aug2020*/
    //     /********************************************
    //     SetuP MAP for CartToFetch
    //     ********************************************/    
    //     Map<String, Object> cartToFetch = new Map<String, Object> {
    //         ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
    //         ccrz.ccApiCart.CART_ID => cartID,
    //         ccrz.ccAPI.SIZING => new Map<String, Object>{
    //             ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
    //                 ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
    //             }
    //         }
    //     };
    //     /********************************************
        
    //     Fire the ccrz.ccApiCart.fetch API
        
    //     ********************************************/        
    //     try {
    //         Boolean wasSuccessful = false;
    //         Map<String, Object> cartFetchResults = ccrz.ccApiCart.fetch(cartToFetch);
    //         system.debug(cartFetchResults);
    //         wasSuccessful = (Boolean)cartFetchResults.get(ccrz.ccApi.SUCCESS);
    //         system.debug(wasSuccessful);
            
    //         List<Map<String, Object>> outputCartList = (List<Map<String, Object>>) cartFetchResults.get(ccrz.ccAPICart.CART_OBJLIST);
    //         system.debug('key>>>' +JSON.serialize(outputCartList));
            
    //         /*Getting the Cart Details here*/
    //       		ccrz__E_Cart__c cartDetails = new ccrz__E_Cart__c();
    //             //System.debug('strKey===========\t'+strKey+'Value ====\t'+outputCartList[0].get(strKey));
    //             cartDetails.ccrz__CartId__c = (String)outputCartList[0].get('sfid');
    //             cartDetails.OwnerId = 	(String)outputCartList[0].get('ownerId');
    //             //cartDetails.Name =		(String)outputCartList[0].get('sfdcName'); Not Writeable
    //             cartDetails.ccrz__EncryptedId__c = 	(String)outputCartList[0].get('encryptedId');
    //             cartDetails.ccrz__ActiveCart__c = (Boolean)outputCartList[0].get('activeCart');
    //             cartDetails.ccrz__CartStatus__c = (String)outputCartList[0].get('cartStatus');
    //             cartDetails.ccrz__CartType__c = (String)outputCartList[0].get('cartType');
    //             cartDetails.lastModifiedDate = (Datetime)outputCartList[0].get('lastModifiedDate');
    //             //cartDetails.ccrz__SubtotalAmount__c = (String)outputCartList[0].get('subtotalAmount');Not Writable Need to create other field to hold
    //             cartDetails.ccrz__Name__c = (String)outputCartList[0].get('name');
    //             cartDetails.ccrz__TaxExemptFlag__c = (Boolean)outputCartList[0].get('taxExemptFlag');
    //             //cartDetails.ccrz__TotalAmount__c = (String)outputCartList[0].get('totalAmount');Not Writable Need to create other field to hold
    //             cartDetails.ccrz__CurrencyISOCode__c = (String)outputCartList[0].get('currencyISOCode');
    //             //cartDetails.ccrz__TaxSubTotalAmount__c = (String)outputCartList[0].get('taxSubTotalAmount');Not Writable Need to create other field to hold
    //             //cartDetails.ccrz__TotalQuantity__c = (String)outputCartList[0].get('totalQuantity');Not Writable Need to create other field to hold
    //             cartDetails.ccrz__Account__c = (String)outputCartList[0].get('account');
    //             cartDetails.ccrz__AnonymousId__c = (Boolean)outputCartList[0].get('anonymousId');
    //             cartDetails.ccrz__RepricedDate__c = (Datetime)outputCartList[0].get('repricedDate');
    //             cartDetails.ccrz__ShipComplete__c = (Boolean)outputCartList[0].get('shipComplete');
    //             cartDetails.ccrz__Storefront__c = (String)outputCartList[0].get('storefront');
    //             cartDetails.ccrz__User__c = (String)outputCartList[0].get('user');
    //             objCCCartApiResponseWrapper.cartDetails = cartDetails;
    //         	Decimal sbTotalAmt = (Decimal)outputCartList[0].get('subtotalAmount');
    //         	sbTotalAmt = sbTotalAmt.setScale(2);
    //             objCCCartApiResponseWrapper.subtotalAmount = sbTotalAmt;
    //             objCCCartApiResponseWrapper.totalAmount = (Decimal)outputCartList[0].get('totalAmount');
    //             objCCCartApiResponseWrapper.taxSubTotalAmount = (Decimal)outputCartList[0].get('taxSubTotalAmount');
    //             objCCCartApiResponseWrapper.totalQuantity = (Decimal)outputCartList[0].get('totalQuantity');
    //         /*Getting here CartItem Details*/
                
    //         System.debug('ECartItemsS===='+outputCartList[0].get('ECartItemsS'));
    //         List<Map<String, Object>> outputCartItemsList = (List<Map<String, Object>>) outputCartList[0].get('ECartItemsS');
    //         System.debug('outputCartItemsList===='+outputCartItemsList);
            
    //         /*Here getting the product lst by Iterationg*/
    //         List<String> lstProductIds = new List<String>();
    //         for(Map<String, Object> obj : outputCartItemsList){
    //             lstProductIds.add((String)obj.get('product'));
    //              System.debug('obj====-------------------------------------------'+obj);
    //             System.debug('lstProductIds===='+(String)obj.get('product'));
    //         }
            
    //         System.debug('List of Product Id ==========\t'+lstProductIds);
    //         /* Fetching the List of Product Details by using Calling the cc api passing list of Product Id*/
    //         Map<String, dbu_CCApiCartRelatedResponseWrapper> mapOfIdProduct = getProductAndMedia(lstProductIds);
    //         System.debug('getProductAndMedia===================\t'+mapOfIdProduct);
    //         /*Ended here*/
            
    //         for(Map<String, Object> obj : outputCartItemsList){
    //             	//System.debug('obj=====\t'+obj);
    //             	dbu_CartItemWrapper objCartItemWrapper = new dbu_CartItemWrapper();
    //             	//System.debug('strKey===========\t'+strKey+'Value ====\t'+outputCartList[0].get(strKey));
    //                 ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
    //                 cartItem.Id = (String)obj.get('sfid');
    //                 //cartItem.Name = (String)obj.get('sfdcNameValue');
    //                 //cartItem.ccrz__Cart__c = (String)obj.get('cart');
    //          	  	 String productId = (String)obj.get('product');
    //             	System.debug('productValue===================\t'+productId);
    //                 cartItem.ccrz__Product__c = productId;
    //                 cartItem.ccrz__Quantity__c = (Decimal)obj.get('quantity');
    //                 //cartItem.ccrz__PrimaryAttr__c = obj.get('primaryAttrValue');
    //                 cartItem.ccrz__Price__c = (Decimal)obj.get('price');
    //                 cartItem.ccrz__ProductType__c = (String)obj.get('productType');
    //                 cartItem.ccrz__StoreID__c = (String)obj.get('storeID');
    //                 cartItem.ccrz__PricingType__c = (String)obj.get('pricingType');
    //                 //cartItem.ccrz__ItemTotal__c = (Decimal)obj.get('itemTotalValue');//Field is not writeable so have taken other one
    //                 cartItem.ccrz__cartItemType__c = (String)obj.get('cartItemType');
    //                 cartItem.ccrz__SubAmount__c = ((Decimal)obj.get('subAmount')).setScale(2);
    //                 cartItem.ccrz__UnitOfMeasure__c = (String)obj.get('unitOfMeasure');
    //                 cartItem.ccrz__ParentCartItem__c = (String)obj.get('parentCartItem');
    //                 cartItem.ccrz__ItemStatus__c = (String)obj.get('itemStatus');
    //                 cartItem.ccrz__Is_Subscription_Selected__c = (Boolean)obj.get('isSubscriptionSelected');
    //                 cartItem.ccrz__OriginalQuantity__c = (Decimal)obj.get('originalQuantity');
    //                 cartItem.ccrz__OriginalItemPrice__c = (Decimal)obj.get('originalItemPrice');
    //                 cartItem.ccrz__RequestDate__c = (Date)obj.get('requestDate');
    //                 objCartItemWrapper.cartItem = cartItem;
    //                 objCartItemWrapper.ItemTotal = (Decimal)obj.get('itemTotal');
    //                 System.debug('mapOfIdProduct.containsKey(productId)\t'+mapOfIdProduct.containsKey(productId));
    //                 if(mapOfIdProduct.containsKey(productId)){
    //                     objCartItemWrapper.cartItemProductDetailWrapper =  mapOfIdProduct.get(productId); 
    //                 }
    //             lstCartItemWrapper.add(objCartItemWrapper);
    //         }
    //         /*Here will be the logic of calling the check available quantity for the */
    //         System.debug('Before the instock and out stock check====>'+lstCartItemWrapper);
    //         /*if(String.isNotBlank(cartStr)){
    //             getProductAvailabilMap(lstCartItemWrapper);
    //         }*/
    //         System.debug('After the instock and out stock check====>'+lstCartItemWrapper);
    //         /*End of the logic*/
    //         	  objCCCartApiResponseWrapper.lstCartItem = lstCartItemWrapper;
    //               List<ccrz__E_Cart__c> lstCart = [select id,ccrz__TaxAmount__c,ccrz__TotalDiscount__c,Original_Cart_Total__c,Total_Cart_Discount__c from ccrz__E_Cart__c where id =: cartId];
    //               if(lstCart.size() > 0 && lstCart[0].ccrz__TaxAmount__c != null)
    //                     objCCCartApiResponseWrapper.taxAmount = lstCart[0].ccrz__TaxAmount__c;
    //               else{
    //                 	objCCCartApiResponseWrapper.taxAmount = 0.00;
    //               }
    //         	//Following Logic Modified by Malhar for Coupon related change - 17 March 2021 - begin
    //             if(lstCart.size() > 0 && lstCart[0].ccrz__TotalDiscount__c != null){
    //                 if(lstCart[0].ccrz__TotalDiscount__c < 0){
    //                     objCCCartApiResponseWrapper.totalCartDiscount = ((lstCart[0].ccrz__TotalDiscount__c) * -1);       
    //                 }else{
    //                     objCCCartApiResponseWrapper.totalCartDiscount = lstCart[0].ccrz__TotalDiscount__c;       
    //                 }             	
    //             }                        
    //             else{
    //                 objCCCartApiResponseWrapper.totalCartDiscount = 0.00;
    //             }
    //         	//Following Logic Modified by Malhar for Coupon related change - 17 March 2021 - end
    //         if(lstCart.size() > 0 && lstCart[0].Original_Cart_Total__c != null)
    //             objCCCartApiResponseWrapper.originalCartAmt = lstCart[0].Original_Cart_Total__c;
    //         else{
    //             objCCCartApiResponseWrapper.originalCartAmt = 0.00;
    //         }
    //         system.debug('objCCCartApiResponseWrapper.totalCartDiscount' +objCCCartApiResponseWrapper.totalCartDiscount);

    //               objlstCCCartApiResponseWrapper.add(objCCCartApiResponseWrapper);

    //         decimal cartTotal = (Decimal) outputCartList[0].get('totalAmount');
    //         system.debug('cartTotal: '+cartTotal);
    //         } catch (Exception e) {
    //             // Error handling...
    //             system.debug('Error message in the dbu_CallCCCartApi'+e.getMessage()+'\tLineNumber\t'+e.getLineNumber());
    //         }
    //     /*Till here*/
    //     return objlstCCCartApiResponseWrapper;
    //   }
    
    
    /*Tax Calculation is going here*/
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> fetchCartItemsByCartIdAfterTax(String cartId){
        String cartStr;
        List<dbu_CCCartApiResponseWrapper> objlstCCCartApiResponseWrapper =new List<dbu_CCCartApiResponseWrapper>();
        dbu_CCCartApiResponseWrapper objCCCartApiResponseWrapper = new dbu_CCCartApiResponseWrapper();
        System.debug('dbu_CallCCCartApi=>fetchCartItemsByCartId=>cartId===\t'+cartId);
        List<ccrz__E_CartItem__c> lstCartItem = new List<ccrz__E_CartItem__c>();
        List<dbu_CartItemWrapper> lstCartItemWrapper = new List<dbu_CartItemWrapper>();
        /*New Logic 27Aug2020*/
        /********************************************
        SetuP MAP for CartToFetch
        ********************************************/    
        Map<String, Object> cartToFetch = new Map<String, Object> {
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccApiCart.CART_ID => cartID,
            ccrz.ccAPI.SIZING => new Map<String, Object>{
                ccrz.ccAPICart.ENTITYNAME => new Map<String, Object>{
                    ccrz.ccAPI.SZ_DATA => ccrz.ccAPI.SZ_XL
                }
            }
        };
        /********************************************
        
        Fire the ccrz.ccApiCart.fetch API
        
        ********************************************/        
        try {
            Boolean wasSuccessful = false;
            Map<String, Object> cartFetchResults = ccrz.ccApiCart.fetch(cartToFetch);
            system.debug(cartFetchResults);
            wasSuccessful = (Boolean)cartFetchResults.get(ccrz.ccApi.SUCCESS);
            system.debug(wasSuccessful);
            
            List<Map<String, Object>> outputCartList = (List<Map<String, Object>>) cartFetchResults.get(ccrz.ccAPICart.CART_OBJLIST);
            system.debug('key>>>' +JSON.serialize(outputCartList));
            
            /*Getting the Cart Details here*/
                ccrz__E_Cart__c cartDetails = new ccrz__E_Cart__c();
                //System.debug('strKey===========\t'+strKey+'Value ====\t'+outputCartList[0].get(strKey));
                cartDetails.ccrz__CartId__c = (String)outputCartList[0].get('sfid');
                cartDetails.OwnerId =   (String)outputCartList[0].get('ownerId');
                //cartDetails.Name =        (String)outputCartList[0].get('sfdcName'); Not Writeable
                cartDetails.ccrz__EncryptedId__c =  (String)outputCartList[0].get('encryptedId');
                cartDetails.ccrz__ActiveCart__c = (Boolean)outputCartList[0].get('activeCart');
                cartDetails.ccrz__CartStatus__c = (String)outputCartList[0].get('cartStatus');
                cartDetails.ccrz__CartType__c = (String)outputCartList[0].get('cartType');
                cartDetails.lastModifiedDate = (Datetime)outputCartList[0].get('lastModifiedDate');
                //cartDetails.ccrz__SubtotalAmount__c = (String)outputCartList[0].get('subtotalAmount');Not Writable Need to create other field to hold
                cartDetails.ccrz__Name__c = (String)outputCartList[0].get('name');
                cartDetails.ccrz__TaxExemptFlag__c = (Boolean)outputCartList[0].get('taxExemptFlag');
                //cartDetails.ccrz__TotalAmount__c = (String)outputCartList[0].get('totalAmount');Not Writable Need to create other field to hold
                cartDetails.ccrz__CurrencyISOCode__c = (String)outputCartList[0].get('currencyISOCode');
                //cartDetails.ccrz__TaxSubTotalAmount__c = (String)outputCartList[0].get('taxSubTotalAmount');Not Writable Need to create other field to hold
                //cartDetails.ccrz__TotalQuantity__c = (String)outputCartList[0].get('totalQuantity');Not Writable Need to create other field to hold
                cartDetails.ccrz__Account__c = (String)outputCartList[0].get('account');
                cartDetails.ccrz__AnonymousId__c = (Boolean)outputCartList[0].get('anonymousId');
                cartDetails.ccrz__RepricedDate__c = (Datetime)outputCartList[0].get('repricedDate');
                cartDetails.ccrz__ShipComplete__c = (Boolean)outputCartList[0].get('shipComplete');
                cartDetails.ccrz__Storefront__c = (String)outputCartList[0].get('storefront');
                cartDetails.ccrz__User__c = (String)outputCartList[0].get('user');
                objCCCartApiResponseWrapper.cartDetails = cartDetails;
                Decimal sbTotalAmt = (Decimal)outputCartList[0].get('subtotalAmount');
                sbTotalAmt = sbTotalAmt.setScale(2);
                objCCCartApiResponseWrapper.subtotalAmount = sbTotalAmt;
                objCCCartApiResponseWrapper.totalAmount = (Decimal)outputCartList[0].get('totalAmount');
                objCCCartApiResponseWrapper.taxSubTotalAmount = (Decimal)outputCartList[0].get('taxSubTotalAmount');
                objCCCartApiResponseWrapper.totalQuantity = (Decimal)outputCartList[0].get('totalQuantity');
            /*Getting here CartItem Details*/
                
            System.debug('ECartItemsS===='+outputCartList[0].get('ECartItemsS'));
            List<Map<String, Object>> outputCartItemsList = (List<Map<String, Object>>) outputCartList[0].get('ECartItemsS');
            System.debug('outputCartItemsList===='+outputCartItemsList);
            
            /*Here getting the product lst by Iterationg*/
            List<String> lstProductIds = new List<String>();
            for(Map<String, Object> obj : outputCartItemsList){
                lstProductIds.add((String)obj.get('product'));
                 System.debug('obj====-------------------------------------------'+obj);
                System.debug('lstProductIds===='+(String)obj.get('product'));
            }
            
            System.debug('List of Product Id ==========\t'+lstProductIds);
            /* Fetching the List of Product Details by using Calling the cc api passing list of Product Id*/
            Map<String, dbu_CCApiCartRelatedResponseWrapper> mapOfIdProduct = getProductAndMedia(lstProductIds,(String)outputCartList[0].get('currencyISOCode'));
            System.debug('getProductAndMedia===================\t'+mapOfIdProduct);
            /*Ended here*/
            
            /*for(Map<String, Object> obj : outputCartItemsList){
                    //System.debug('obj=====\t'+obj);
                    dbu_CartItemWrapper objCartItemWrapper = new dbu_CartItemWrapper();
                    //System.debug('strKey===========\t'+strKey+'Value ====\t'+outputCartList[0].get(strKey));
                    ccrz__E_CartItem__c cartItem = new ccrz__E_CartItem__c();
                    cartItem.Id = (String)obj.get('sfid');
                    //cartItem.Name = (String)obj.get('sfdcNameValue');
                    //cartItem.ccrz__Cart__c = (String)obj.get('cart');
                     String productId = (String)obj.get('product');
                    System.debug('productValue===================\t'+productId);
                    cartItem.ccrz__Product__c = productId;
                    cartItem.ccrz__Quantity__c = (Decimal)obj.get('quantity');
                    //cartItem.ccrz__PrimaryAttr__c = obj.get('primaryAttrValue');
                    cartItem.ccrz__Price__c = (Decimal)obj.get('price');
                    cartItem.ccrz__ProductType__c = (String)obj.get('productType');
                    cartItem.ccrz__StoreID__c = (String)obj.get('storeID');
                    cartItem.ccrz__PricingType__c = (String)obj.get('pricingType');
                    //cartItem.ccrz__ItemTotal__c = (Decimal)obj.get('itemTotalValue');//Field is not writeable so have taken other one
                    cartItem.ccrz__cartItemType__c = (String)obj.get('cartItemType');
                    cartItem.ccrz__SubAmount__c = (Decimal)obj.get('subAmount');
                    cartItem.ccrz__UnitOfMeasure__c = (String)obj.get('unitOfMeasure');
                    cartItem.ccrz__ParentCartItem__c = (String)obj.get('parentCartItem');
                    cartItem.ccrz__ItemStatus__c = (String)obj.get('itemStatus');
                    cartItem.ccrz__Is_Subscription_Selected__c = (Boolean)obj.get('isSubscriptionSelected');
                    cartItem.ccrz__OriginalQuantity__c = (Decimal)obj.get('originalQuantity');
                    cartItem.ccrz__OriginalItemPrice__c = (Decimal)obj.get('originalItemPrice');
                    cartItem.ccrz__RequestDate__c = (Date)obj.get('requestDate');
                    objCartItemWrapper.cartItem = cartItem;
                    objCartItemWrapper.ItemTotal = (Decimal)obj.get('itemTotal');
                    System.debug('mapOfIdProduct.containsKey(productId)\t'+mapOfIdProduct.containsKey(productId));
                    if(mapOfIdProduct.containsKey(productId)){
                        objCartItemWrapper.cartItemProductDetailWrapper =  mapOfIdProduct.get(productId); 
                    }
                lstCartItemWrapper.add(objCartItemWrapper);
            }*/
            /*Here will be the logic of calling the check available quantity for the */
            System.debug('Before the instock and out stock check====>'+lstCartItemWrapper);
            /*if(String.isNotBlank(cartStr)){
                getProductAvailabilMap(lstCartItemWrapper);
            }*/
            System.debug('After the instock and out stock check====>'+lstCartItemWrapper);
            /*End of the logic*/
                  objCCCartApiResponseWrapper.lstCartItem = lstCartItemWrapper;
                  
                   system.debug('objCCCartApiResponseWrapper.totalCartDiscount' +objCCCartApiResponseWrapper.totalCartDiscount);
                  /*Tax calculation is performing here*/
                    dbu_VertexCtrl.getVertexQuoteTax(cartId, null);
                 /*end here*/
                 List<ccrz__E_Cart__c> lstCart = [select id,ccrz__TaxAmount__c,Total_Cart_Discount__c,ccrz__TotalDiscount__c from ccrz__E_Cart__c where id =: cartId];
                  if(lstCart.size() > 0 && lstCart[0].ccrz__TaxAmount__c != null)
                        objCCCartApiResponseWrapper.taxAmount = lstCart[0].ccrz__TaxAmount__c;
                  else{
                        objCCCartApiResponseWrapper.taxAmount = 0.00;
                  }
                 objlstCCCartApiResponseWrapper.add(objCCCartApiResponseWrapper);

            decimal cartTotal = (Decimal) outputCartList[0].get('totalAmount');
            system.debug('cartTotal: '+cartTotal);
            } catch (Exception e) {
                // Error handling...
                system.debug('Error message in the dbu_CallCCCartApi'+e.getMessage()+'\tLineNumber\t'+e.getLineNumber());
            }
        /*Till here*/
        return objlstCCCartApiResponseWrapper;
      }
    /*End Here*/
    ////////////////////////////////////////////////////////////////////
    public static Map<String, dbu_CCApiCartRelatedResponseWrapper> getProductAndMedia(List<String> pids,String currencyCode){
                Map<String,dbu_CCApiCartRelatedResponseWrapper> objProductMap = dbu_callCCApiRelatedCart.getProductMap(pids,currencyCode);
                return objProductMap;
            }
    
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> insertCartItem(String sku ,String cartId,double itemPrice,double quantity){
                /*ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
                ctx.storefront = 'CSSNAStore';
                ccrz.cc_CallContext.initRemoteContext(ctx);
                //ccrz.cc_CallContext.currAccountId = '0011F00000fk3pHQAQ';
                ccrz.cc_CallContext.userCurrency = 'USD';
                //ccrz.cc_CallContext.effAccountId = '0011900000tVwv9AAC';
                //ccrz.cc_CallContext.currCartId = cartID;*/               
                               
                /********************************************
                Defining the Product SKU or ID, Quantity, CartID
                ********************************************/
                system.debug('sku==\t'+sku);
                system.debug('cartId==\t'+cartId);
                system.debug('itemPrice===\t'+itemPrice);
                system.debug('quantity===\t'+quantity);
                /********************************************
                SetuP MAP for CartItem LINEDATA
                ********************************************/
                Boolean wasSuccessful = false;
                Map<String, Object> newSKUToAdd = new Map<String, Object> {
                    ccrz.ccApiCart.LINE_DATA_SKU => sku,
                        ccrz.ccApiCart.LINE_DATA_QUANTITY => quantity,
                        //ccrz.ccApiCart.theNewLine.price = 1.00; 
                        ccrz.ccApiCart.LINE_DATA_PRICE => itemPrice,
                        ccrz.ccApiCart.LINE_DATA_ATTRIBUTE_LIST => null//new List<ID>{'a1r1F000000ofC8QAI'}
                };
                /********************************************
                SetuP MAP for CartItem lines
                ********************************************/    
                Map<String, Object> cartItemsToAdd = new Map<String, Object> {
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                        ccrz.ccApiCart.CART_ID => cartID,   
                        ccrz.ccApiCart.LINE_DATA => new List<Map<String, Object>> {newSKUToAdd}
                };
                /********************************************
                Fire the ccrz.ccApiCart.addTo API
                ********************************************/        
                try {
                    	
                        //Removing Existing Coupon
                        Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
                        //Perform Cartitems Update
                        Map<String, Object> addToCartResults = ccrz.ccApiCart.addTo(cartItemsToAdd);
                        system.debug(addToCartResults);
                        wasSuccessful = (Boolean)addToCartResults.get(ccrz.ccApi.SUCCESS);
                        system.debug(wasSuccessful);                        
                        
                        //Reapplying the Coupon
                        //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);                        

                } catch (Exception e) {
                    // Error handling...
                    system.debug(e.getMessage()+'\t'+e.getLineNumber());
                }
        return null;
    }
    
    @AuraEnabled
    public static String insertCartItem1(String sku ,String cartId,double itemPrice,double quantity, boolean shipvalue){
        		/*New Changes on 2ndSep2020*/
        		String accountId;
        		string userId;
				system.debug('UserInfo.getUserType====== in createCartCCApi method'+UserInfo.getUserType());
        		/*4th Oct 20202 Shriram*/
        		
        		/*Ended here*/
               /* if(UserInfo.getUserType() == 'Guest'){
                    accountName = System.Label.GuestAccountName;
                    //accountName = 'CCAnonymous';
                }else{
                     accountName = System.Label.UserAccountName;
                    //accountName = CSSNAStoreDefaultOwner
                }*/
                // Both Guest and Logged in customers should use separate account(with user record created for them)
                // Will update this code later when customer registration functionality is implemented.
                //accountName = CSSNAStoreDefaultOwner
                List<ccrz__E_Cart__c> cartList = [select id,ccrz__EncryptedId__c,dbu_Cart_StoreCountry__c from ccrz__E_Cart__c where Id =: cartId limit 1];
                string cartCountry; //Added by Malhar 14jan2020
                String cartIdencrypted;
                if(cartList.size() > 0){
                    cartIdencrypted = cartList[0].ccrz__EncryptedId__c;
                    cartCountry = cartList[0].dbu_Cart_StoreCountry__c; //Added by Malhar 14jan2020
                }
        
                //get the country cureency iso mapping from custom settings
                Map<string,string> countryCurrencyMap = new Map<string,string>();
                for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                    system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                    system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                    countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
                }
                system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
                string CurrencyISOcodeValue = (string)countryCurrencyMap.get(cartCountry);                      
        
                if(UserInfo.getUserType().equalsIgnoreCase('Guest')){
                        system.debug('FOR GUEST IN CALLCCCARTAPI');
                        String accountName;
                        accountName = System.Label.UserAccountName;
                        List<Account> acc = [select id from account where name =: accountName limit 1];
                        if(acc.size() > 0){
                            accountId = acc[0].id;
                            userId = UserInfo.getUserId();
                            system.debug('userId :: ' + userId );
                        }
                        system.debug('accountName:::' + accountName+'accountId==\t'+accountId);
                }else{
                    system.debug('FOR LOGGEDIN USER IN CALLCCCARTAPI');
                    List<User> u = [select id, name, contact.accountId from User where Id =: UserInfo.getUserId()];
                    system.debug('loggedIn user details ::' + u);
                    if(u.size() > 0 && u[0].contact.accountId != null){
                        accountId = u[0].contact.accountId;
                        userId = u[0].id;
                        system.debug('userId :: ' + userId );
                        system.debug('accountId for LoggedIn User :: ' + accountId);
                    }
                }
                /*Ended here*/
                ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
                ctx.storefront = 'CSSNAStore';
                ccrz.cc_CallContext.initRemoteContext(ctx);
                ccrz.cc_CallContext.currAccountId = accountId;//'0011F00000fk3pHQAQ';
                
                ccrz.cc_CallContext.userCurrency = CurrencyISOcodeValue;
        
                ccrz.cc_CallContext.currUserId = userId;
                ccrz.cc_CallContext.effAccountId = accountId;//'0011900000tVwv9AAC';
                if(UserInfo.getUserType() == 'Guest')
                {
                    ccrz.cc_CallContext.isGuest = true;
                }
                
                ccrz.cc_CallContext.currCartId = cartIdencrypted;
                /********************************************
                Defining the Product SKU or ID, Quantity, CartID
                ********************************************/
                system.debug('sku==\t'+sku);
                system.debug('cartId==\t'+cartId);
                system.debug('itemPrice===\t'+itemPrice);
                system.debug('quantity===\t'+quantity);
        
                list<ccrz__E_Product__c> fetechProductAttribs = [select ccrz__PrimaryAttr__c,ccrz__SecondaryAttr__c,ccrz__TertiaryAttr__c from ccrz__E_Product__c where ccrz__SKU__c =: sku];
                system.debug('fetechProductAttribs >> ' + fetechProductAttribs);
                
                list<ID> ProductAttribs = new list<ID>();
                
                for(ccrz__E_Product__c eachproduct : fetechProductAttribs){
                    if(eachproduct.ccrz__PrimaryAttr__c != null){
                        ProductAttribs.add(eachproduct.ccrz__PrimaryAttr__c);
                    }
                    
                    if(eachproduct.ccrz__SecondaryAttr__c != null){
                        ProductAttribs.add(eachproduct.ccrz__PrimaryAttr__c);
                    }
                
                    if(eachproduct.ccrz__TertiaryAttr__c != null){ 
                        ProductAttribs.add(eachproduct.ccrz__PrimaryAttr__c);
                    }    
                }
                
                system.debug('ProductAttribs :: ' + ProductAttribs);        
        
                String newCartId;
                String returnNewCartId;
                /********************************************
                SetuP MAP for CartItem LINEDATA
                ********************************************/
                Boolean wasSuccessful = false;
                Map<String, Object> newSKUToAdd = new Map<String, Object> {
                    ccrz.ccApiCart.LINE_DATA_SKU => sku,
                        ccrz.ccApiCart.LINE_DATA_QUANTITY => quantity,
                        //ccrz.ccApiCart.theNewLine.price = 1.00; 
                        ccrz.ccApiCart.LINE_DATA_PRICE => itemPrice,
                        ccrz.ccApiCart.LINE_DATA_ATTRIBUTE_LIST => ProductAttribs,
                        'dbuisShipTo' => shipvalue
                };
                /********************************************
                SetuP MAP for CartItem lines
                ********************************************/    
                Map<String, Object> cartItemsToAdd = new Map<String, Object> {
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                        //ccrz.ccApiCart.CART_ID => cartID,   
                        ccrz.ccApiCart.CART_ENCID => cartIdencrypted,
                        ccrz.ccApiCart.LINE_DATA => new List<Map<String, Object>> {newSKUToAdd}
                };
                /********************************************
                Fire the ccrz.ccApiCart.addTo API
                ********************************************/        
                try {
                    
                    ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: cartId];
                    
                    System.debug('Schema.sObjectType.ccrz__E_Cart__c.isAccessible)' + Schema.sObjectType.ccrz__E_Cart__c.isAccessible());
                    System.debug('Schema.sObjectType.ccrz__E_CartItem__c.isAccessible)'+ Schema.sObjectType.ccrz__E_CartItem__c.isAccessible());
                    
                    	
                        //Removing Existing Coupon
						Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
                        //Perform Cartitems insert
                        Map<String, Object> addToCartResults = ccrz.ccApiCart.addTo(cartItemsToAdd);
                        system.debug(addToCartResults);
                        system.debug('Old CartId===\t'+cartId);
                        system.debug('addToCartResults=>'+addToCartResults);
                        //system.debug('addToCartResults=>'+JSON.serialize(addToCartResults));
                        newCartId = (String)addToCartResults.get('cartId');
                        System.debug('New CartId===='+newCartId+'  Old CartId===\t'+cartId);
                        if(String.isNotBlank(newCartId) && newCartId != cartId){
                            returnNewCartId = newCartId;
                        }
                        //jlowenthal@salesforce.com adding this else because addTo can return encrypted id.
                        else if(String.isBlank(newCartId)){
                            String newCartEncId = (String) addToCartResults.get('cartEncId');
                            if(String.isNotBlank(newCartEncId)){
                                ccrz__E_Cart__c theCart = [SELECT Id FROM ccrz__E_Cart__c WHERE ccrz__EncryptedId__c =: newCartEncId LIMIT 1];
                                returnNewCartId = theCart.Id;
                            }
                        }
                        wasSuccessful = (Boolean)addToCartResults.get(ccrz.ccApi.SUCCESS);
                        system.debug('wasSuccessful======\t'+wasSuccessful);                        
                        //Reapplying the Coupon
                        //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);                                                

                } catch (Exception e) {
                    // Error handling...
                    system.debug(e.getMessage()+'\t'+e.getLineNumber());
                }
                System.debug('returnNewCartId===\t'+returnNewCartId);
        return returnNewCartId;
    }
    
    
      
    /* in case for crate engine */
    @AuraEnabled
    public static String insertCartItemForCrateEngine(String sku ,String cartId,double itemPrice,double quantity,string make,string model,string vin,string year,
                                                       boolean EmissionAgreement,boolean ExportAgreement,boolean ShippingAgreement,boolean TncAgreement,
                                                       boolean UnloadingAgreement,boolean WarrentyAggrement,string state,String vehiclePowered){
                /*New Changes on 2ndSep2020*/
                String accountName;
                system.debug('UserInfo.getUserType====== in createCartCCApi method'+UserInfo.getUserType());
               
                accountName = System.Label.UserAccountName;
                List<ccrz__E_Cart__c> cartList = [select id,ccrz__EncryptedId__c,dbu_Cart_StoreCountry__c from ccrz__E_Cart__c where Id =: cartId limit 1];
                String cartIdencrypted;
                string cartCountry; //Added by Malhar 14jan2020                                                           
                if(cartList.size() > 0){
                    cartIdencrypted = cartList[0].ccrz__EncryptedId__c;
                    cartCountry = cartList[0].dbu_Cart_StoreCountry__c; //Added by Malhar 14jan2020
                }
                
                //Added by Malhar 14jan2020                                                               
                //get the country cureency iso mapping from custom settings
                Map<string,string> countryCurrencyMap = new Map<string,string>();
                for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                    system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                    system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                    countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
                }
                system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
                string CurrencyISOcodeValue = (string)countryCurrencyMap.get(cartCountry);                                                           

                List<Account> acc = [select id from account where name =: accountName limit 1];
                String accountId;
                if(acc.size() > 0){
                    accountId = acc[0].id;
                }

                system.debug('accountName:::' + accountName+'accountId==\t'+accountId);
                /*Ended here*/
                ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
                ctx.storefront = 'CSSNAStore';
                ccrz.cc_CallContext.initRemoteContext(ctx);
                ccrz.cc_CallContext.currAccountId = accountId;//'0011F00000fk3pHQAQ';
                //ccrz.cc_CallContext.userCurrency = 'USD';
                ccrz.cc_CallContext.userCurrency = CurrencyISOcodeValue; //Added by Malhar 14jan2020    
                //ccrz.cc_CallContext.effAccountId = accountId//'0011900000tVwv9AAC';
                //ccrz.cc_CallContext.currCartId = cartID;
                if(UserInfo.getUserType() == 'Guest')
                {
                    ccrz.cc_CallContext.isGuest = true;
                }
                
                ccrz.cc_CallContext.currCartId = cartIdencrypted;
                /********************************************
                Defining the Product SKU or ID, Quantity, CartID
                ********************************************/
                system.debug('sku==\t'+sku);
                system.debug('cartId==\t'+cartId);
                system.debug('itemPrice===\t'+itemPrice);
                system.debug('quantity===\t'+quantity);
                String newCartId;
                String returnNewCartId;
                /********************************************
                SetuP MAP for CartItem LINEDATA
                ********************************************/
                Boolean wasSuccessful = false;
                Map<String, Object> newSKUToAdd = new Map<String, Object> {
                    ccrz.ccApiCart.LINE_DATA_SKU => sku,
                        ccrz.ccApiCart.LINE_DATA_QUANTITY => quantity,
                        //ccrz.ccApiCart.theNewLine.price = 1.00; 
                        ccrz.ccApiCart.LINE_DATA_PRICE => itemPrice,
                        ccrz.ccApiCart.LINE_DATA_ATTRIBUTE_LIST => null,
                        'IsCreatProduct' => true,
                        'CreatProductMap' => new Map<string,object>{
                            'dbuMake'           => make,
                                'dbuModel'      => model,
                                'dbuVIN'        => vin,
                                'dbuYear'       => year,
                                'dbuEmissionAgreement' => true,
                                'dbuExportAgreement' => true,
                                'dbuShippingAgreement' => true,
                                'dbuTncAgreement'       => true,
                                'dbuUnloadingAgreement' => true,
                                'dbuWarrentyAggrement'  => true,
                                'dbuState' =>state,
                                'dbuVehiclePowered' =>vehiclePowered
        			}      
				};
                
                /********************************************
                SetuP MAP for CartItem lines
                ********************************************/    
                Map<String, Object> cartItemsToAdd = new Map<String, Object> {
                    ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                        //ccrz.ccApiCart.CART_ID => cartID,   
                        ccrz.ccApiCart.CART_ENCID => cartIdencrypted,
                        ccrz.ccApiCart.LINE_DATA => new List<Map<String, Object>> {newSKUToAdd}
                };
                /********************************************
                Fire the ccrz.ccApiCart.addTo API
                ********************************************/        
                try {
                    
                    ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: cartId];
                    
                    System.debug('Schema.sObjectType.ccrz__E_Cart__c.isAccessible)'+ Schema.sObjectType.ccrz__E_Cart__c.isAccessible());
                    System.debug('Schema.sObjectType.ccrz__E_CartItem__c.isAccessible)'+ Schema.sObjectType.ccrz__E_CartItem__c.isAccessible());
                    
                    if((currenctCart.ccrz__E_CartCoupons__r).size() > 0){
                        system.debug('coupon is applied');                                
                        string CurrenctApliedCouponCode = (string)currenctCart.ccrz__E_CartCoupons__r[0].ccrz__Coupon__r.ccrz__CouponCode__c;
                        system.debug('CurrenctApliedCouponCode  > ' + CurrenctApliedCouponCode);
                        
                        //Removing Existing Coupon
                        Boolean CouponRemovedStatus = dbu_CallCCCartApi.removeAppliedCoupon(cartId);

                        //Perform Cartitems insert
                        Map<String, Object> addToCartResults = ccrz.ccApiCart.addTo(cartItemsToAdd);
                        //system.debug(addToCartResults);
                        system.debug('Old CartId===\t'+cartId);
                        system.debug('addToCartResults=>'+addToCartResults);
                        //system.debug('addToCartResults=>'+JSON.serialize(addToCartResults));
                        newCartId = (String)addToCartResults.get('cartId');
                        System.debug('New CartId===='+newCartId+'  Old CartId===\t'+cartId);
                        if(String.isNotBlank(newCartId) && newCartId != cartId){
                            returnNewCartId = newCartId;
                        }
                        wasSuccessful = (Boolean)addToCartResults.get(ccrz.ccApi.SUCCESS);
                        system.debug('wasSuccessful======\t'+wasSuccessful);

                        
                        //Reapplying the Coupon
                        Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);                        

                    }else{
                        system.debug('coupon is not applied');

                        Map<String, Object> addToCartResults = ccrz.ccApiCart.addTo(cartItemsToAdd);
                        //system.debug(addToCartResults);
                        system.debug('Old CartId===\t'+cartId);
                        system.debug('addToCartResults=>'+addToCartResults);
                        //system.debug('addToCartResults=>'+JSON.serialize(addToCartResults));
                        newCartId = (String)addToCartResults.get('cartId');
                        System.debug('New CartId===='+newCartId+'  Old CartId===\t'+cartId);
                        if(String.isNotBlank(newCartId) && newCartId != cartId){
                            returnNewCartId = newCartId;
                        }
                        wasSuccessful = (Boolean)addToCartResults.get(ccrz.ccApi.SUCCESS);
                        system.debug('wasSuccessful======\t'+wasSuccessful);
                    }                    



                } catch (Exception e) {
                    // Error handling...
                    system.debug(e.getMessage()+'\t'+e.getLineNumber());
                }
                System.debug('returnNewCartId===\t'+returnNewCartId);
        return returnNewCartId;
    }
    /* end crate engine*/
    
     /*This method will create New cart using CC API*/      
    @AuraEnabled
    public static String createCart(String storeCountry, string storeLanguage){
        Boolean wasSuccessful = false;
        String newCartID = createCartCCApi(storeCountry, storeLanguage); //*****MALHAR MODIFICATION FOR STORE TOGGLING
        /*Map<String, Object> cartToCreate = new Map<String, Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION
        };
        try{
            System.debug('????????/cartToCreate MAP\t'+cartToCreate);
            Map<String, Object> createdCart = ccrz.ccApiCart.addTo(cartToCreate);
            System.debug('????????/createdCart\t'+createdCart);
            wasSuccessful = (Boolean)createdCart.get(ccrz.ccApi.SUCCESS);
            newCartID = (String)createdCart.get('cartId');
            //
            System.debug('????????/CartId\t'+createdCart.get('cartId'));
            if(String.isBlank(newCartID)){
                wasSuccessful = false;
                // Consider adding more error checking for the new cart
            }
        }catch (Exception e) {
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }*/
        return newCartID;
    }
    
    /*This method will create New cart using CC API*/       
    @AuraEnabled
    public static String createCartCCApi(string storeCountry, string storeLanguage){ //MALHAR MODIFICATION FOR STORE TOGGLING
        
        //string storeLanguage = 'FR';
        //get the country cureency iso mapping from custom settings - Malhar added following code 14/1/2021
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);        
        
        /********************************************
        Defining the CallContext & initialization
        --------------------------------------------
        Findings : Give System Null Pointer exception
           if not defined if account not 
           defined.
        ********************************************/ 
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        ctx.storefront = 'CSSNAStore';
        ccrz.cc_CallContext.initRemoteContext(ctx);
        String accountName;
        system.debug('UserInfo.getUserType====== in createCartCCApi method'+UserInfo.getUserType());
        if(UserInfo.getUserType() == 'Guest'){
            accountName = System.Label.GuestAccountName;
            //accountName = 'CCAnonymous';
        }else{
            List<User> userList = [Select Id,Contact.Account.Name from user where Id = :UserInfo.getUserId()];
            if(!userList.isEmpty()){
                accountName = userList[0].Contact.Account.Name;
            }
            else{
                accountName = System.Label.UserAccountName;
            }            
            //accountName = CSSNAStoreDefaultOwner
        }
        List<Account> acc = [select id from account where name =: accountName limit 1];
        String accountId;
        if(acc.size() > 0){
            accountId = acc[0].id;
        }
       
        system.debug('accountName:::' + accountName+'accountId==\t'+accountId);
        ccrz.cc_CallContext.currAccountId = accountId;
        ccrz.cc_CallContext.userCurrency = 'USD';
        //New changes ShriRam: 25Jan2021
        ccrz.cc_CallContext.effAccountId = accountId;
        //ccrz.cc_CallContext.currCartId = cartID;
        system.debug('felix');
        
        String cartId;
        Boolean wasSuccessful = false;
        // currencyISOCode added by Malhar - 14/1/2021
        Map<String, Object> cartToCreate = new Map<String, Object> {
            'cartType' => 'Cart',
            'activeCart' => true,
            'name' => 'My Cart',
            'storefront' => 'CSSNAStore',
            'account' => accountId,
            'dbuCartStoreCountry' => storeCountry,
            'dbustoreLanguage' => storeLanguage,    
            'currencyISOCode' => CurrencyISOcodeValue   
        };
            
        system.debug('cartToCreate > ' + cartToCreate); 
        
        Map<String, Object> cartCreateInputData = new Map<String, Object> {
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION, 
            ccrz.ccApiCart.CART_OBJLIST => new List<Map<String, Object>> {cartToCreate},
            ccrz.ccApi.SIZING => new Map<String, Object> {
                ccrz.ccApiCart.ENTITYNAME => new Map<String, Object> {
                    ccrz.ccApi.SZ_REFETCH => true
                }
            }
        };
            
        try {
            //Map<String, Object> createCartResults = ccrz.ccApiCart.create(cartCreateInputData);
            Map<String, Object> createCartResults;
            try{
                createCartResults = ccrz.ccApiCart.create(cartCreateInputData);   
                

                list<ccrz__E_Cart__c> cartstallyapiresp = [select id, ccrz__ActiveCart__c, dbu_Cart_StoreCountry__c 
                                                                    from ccrz__E_Cart__c 
                                                                    where Ownerid =: userinfo.getUserId() 
                                                                    and ccrz__CartType__c = 'Cart'];    
        
                system.debug('cartstallyapiresp >>>>>>>>>>>>>>>>>>>>> ' + cartstallyapiresp);                
                
                }catch(Exception ex){
                    System.debug('ex.getMessage()\t'+ex.getMessage()+'Line Number\t'+ex.getLineNumber());
                } 
            /*cc api is not working here since 2nd Nov 2020 in CSO
            /*Shriram: Commented code bcoz cc api is not working:*/
            wasSuccessful = (Boolean)createCartResults.get(ccrz.ccApi.SUCCESS);
            List<Object> createdCartList = (List<Object>) createCartResults.get(ccrz.ccApiCart.CART_OBJLIST);
            //Map<String, Object> createdCart = (Map<String, Object>) createdCartList[0];
            system.debug('createCartResults ::: ' + createCartResults);
            cartId = (String)createCartResults.get('cartId');
            /*Putting the new logic here
            List<ccrz__E_Cart__c> lstCart = [select id from ccrz__E_Cart__c order by createdDate desc limit 1];
            System.debug('lstCart==================>\t'+lstCart);
            if(lstCart.size() > 0)
                cartId = lstCart[0].Id;*/
            // Do something with the created car 
        } catch (Exception e) {
            // Error handling...
            system.debug(e.getMessage()+'LineNumber\t'+e.getLineNumber());
            system.debug('e.stacktracke > ' + e.getStackTraceString());
        }
        return cartId;
    }
    
    @AuraEnabled
    public static void deleteCartItemCCApi(String cartIItemID, String cartID){
        
        //BEGIN - Before Deleting check if Cart has Coupon Appiled - Added by Malhar - 18 Feb 2021
        //ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: cartID];
        
        	// Calculating Shipping Cost
            //dbu_CheckOutCntrl.updateShippingAmountOnCart(true,cartId,'');
            //Removing Existing Coupon
            dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
            //Perform cartitems Delete operation
            system.debug('Deleting CartItem => ' + cartIItemID + 'Beloonging To Cart => ' + cartID); 
            list<ccrz__E_CartItem__c> CartItemFetched = [select ID from ccrz__E_CartItem__c Where ID =: cartIItemID];            
            
            list<Database.DeleteResult> DeletedList = Database.delete(CartItemFetched, true);
            
            for(Database.DeleteResult dltResult : DeletedList){
                if(dltResult.isSuccess()){
                    System.debug('Successfully delete the CartItem with ID:> ' + dltResult.getId());
                }else{
                    for(Database.Error err : dltResult.getErrors()){
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                        System.debug('CartItem fields that affected this error:> ' + err.getFields());                    
                    }
                }
            }            
            
            //Reapplying the Coupon
            //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);//shriram on 18th June 2021
            
        //END - Before Updating check if Cart has Coupon Appiled - Added by Malhar - 18 Feb 2021
        
        //######################### Custom Code to Delete CartItem - Malhar - 1st oct 2020 #############################

        
        /*********************************************
        Code :  Remove cartitems from cart using 
        ccrz.ccApiCart.removefrom API
        
        tested on : CSODEV
        *********************************************/
        
        //string cartID = 'a1y1F0000011i2sQAA';
        //id cartIItemID = 'a1x1F000000gyKlQAI';
        
        //########################### FORMULATE LINE_DATA #################################
        /*
        ccrz.ccApiCart.LineData eachcartlineobjectdetail = new ccrz.ccApiCart.LineData();
        eachcartlineobjectdetail.sfid = cartIItemID;    
        List<ccrz.ccApiCart.LineData> cartlinesobjectlist = new List<ccrz.ccApiCart.LineData>();
        cartlinesobjectlist.add( eachcartlineobjectdetail );
        */
        //########################### FORMULATE INPUT DATA #################################
        /*
        Map<String, Object> cartItemsToRemove = new Map<String, Object> {
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccApiCart.CART_ID => cartID,   
                ccrz.ccApiCart.LINE_DATA => cartlinesobjectlist
        };
            
        system.debug(cartItemsToRemove);    
        */
        //########################### FIRE THE REMOVEFROM() API #################################
        /*
        try{
            Map<String, Object> CartRemoveResponse = ccrz.ccApiCart.removeFrom(cartItemsToRemove);
            system.debug(JSON.serializePretty('RemoveResponse::::: ' + CartRemoveResponse));              
            Boolean SuccessResponse = (Boolean)CartRemoveResponse.get(ccrz.ccApi.SUCCESS);
            system.debug('SuccessResponse :::'+ SuccessResponse);
            String CartRemovedENCID = (String)CartRemoveResponse.get(ccrz.ccApiCart.CART_ENCID);
            system.debug('CartRemovedENCID:::' + CartRemovedENCID);
        }catch(exception e){
            system.debug(e);
        } 
        */
    }
    
    //  @AuraEnabled
    // public static String getProductAvailability(dbu_CartItemWrapper cartItemWrapper, String location,Map<string,double> productAvailabilMapLocal,String CurrencyISOcodeValue){
    //     List<Dbu_InventoryWrapper> lstInventoryWrapper;
    //     if(String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.FullPartNumber)){
    //     	//lstInventoryWrapper = dbu_Invetory_Callout.getInventory(cartItemWrapper.cartItemProductDetailWrapper.FullPartNumber,location);
    //     	lstInventoryWrapper = dbu_Integration_InventoryCheck.getInventory(cartItemWrapper.cartItemProductDetailWrapper.FullPartNumber,location);
    //     }else if(String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.partNumber)){
    //         //lstInventoryWrapper = dbu_Invetory_Callout.getInventory(cartItemWrapper.cartItemProductDetailWrapper.partNumber,location);
    //         lstInventoryWrapper = dbu_Integration_InventoryCheck.getInventory(cartItemWrapper.cartItemProductDetailWrapper.partNumber,location);
    //     }
    //     Integer totalItemInInventory = 0;
    //     String ItemAvailabilityMessage;
    //     if(productAvailabilMapLocal != null && productAvailabilMapLocal.size() > 0){
    //         if((double)productAvailabilMapLocal.get(cartItemWrapper.cartItemProductDetailWrapper.sfid) != null){       
    //             cartItemWrapper.qtyAvailable = Integer.valueOf(productAvailabilMapLocal.get(cartItemWrapper.cartItemProductDetailWrapper.sfid));
    //         }
    //     }
    //     if(lstInventoryWrapper != null && lstInventoryWrapper.size() > 0){
    //         for(Dbu_InventoryWrapper.Item item: lstInventoryWrapper[0].Inventory.items.item){
    //             if(String.isNotBlank(item.errors)){
    //                 break;
    //             }
    //             if(String.isNotBlank(item.availableQuantity)){
    //                 //Shrirma: 16Feb 2021 commented bcoz we are not checking for ware house in local inventory if(InventoryLocationSet!=null && InventoryLocationSet.contains(item.warehouse)){
    //                     if(CurrencyISOcodeValue == 'USD' && item.warehouse != 'PRD'){
    //                         totalItemInInventory = totalItemInInventory + Integer.valueOf(item.availableQuantity);
    //                     }else if(CurrencyISOcodeValue == 'CAD' && item.warehouse == 'PRD'){
    //                         totalItemInInventory = totalItemInInventory + Integer.valueOf(item.availableQuantity);
    //                     }
    //                 //}
    //             }
    //         }
    //     }else if(productAvailabilMapLocal != null && productAvailabilMapLocal.size() > 0){
    //         	System.debug('productAvailabilMapLocal===\t'+productAvailabilMapLocal);
    //         	if((double)productAvailabilMapLocal.get(cartItemWrapper.cartItemProductDetailWrapper.sfid) != null){       
    //                 totalItemInInventory = Integer.valueOf(productAvailabilMapLocal.get(cartItemWrapper.cartItemProductDetailWrapper.sfid));
    //         	}
    //     }
    //     if( cartItemWrapper.cartItem.ccrz__Quantity__c != null && totalItemInInventory >= cartItemWrapper.cartItem.ccrz__Quantity__c){
    //         ItemAvailabilityMessage = 'In Stock';
    //     }else{
    //         ItemAvailabilityMessage = 'Out of Stock';
    //     }
    //     System.debug('ItemAvailabilityMessage in getProductAvailability====>'+ItemAvailabilityMessage);
    //     return ItemAvailabilityMessage;
    // }
    // @AuraEnabled
    // public static void getProductAvailabilMap(List<dbu_CartItemWrapper> lstCartItemWrapper,List<String> ProductIDSet, String CurrencyISOcodeValue){
    //     System.debug('lstCartItemWrapper in getProductAvailabilMap method=>'+lstCartItemWrapper);
    //     String ItemAvailabilityMessage;
    //     Map<string,double> productAvailabilMapLocal =  getProductAvailabilMapLocal(ProductIDSet,CurrencyISOcodeValue);
    //     for(dbu_CartItemWrapper cartItemWrapper: lstCartItemWrapper){
    //         if(cartItemWrapper.cartItemProductDetailWrapper != null && (String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.partNumber) || String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.FullPartNumber))){
    //             ItemAvailabilityMessage = getProductAvailability(cartItemWrapper, 'GOMSUS', productAvailabilMapLocal,CurrencyISOcodeValue);
    //             cartItemWrapper.ItemAvailabilityMessage = ItemAvailabilityMessage;
    //             System.debug('ItemAvailabilityMessage in getProductAvailabilMap====>'+ItemAvailabilityMessage);
    //         }            
    //     }
    // }
    
    @AuraEnabled
    public static dbu_InventoryUtilWrapper  getProductAvailability(ccrz__E_Cart__c cartDetails,dbu_CartItemWrapper cartItemWrapper,Map<string,double> productAvailabilMapLocal,String CurrencyISOcodeValue,Map<String,dbu_InventoryCheck_Result__c> objProductVsInventoryRespose){
        List<Dbu_InventoryWrapper> lstInventoryWrapper;
        dbu_InventoryUtilWrapper objInventoryUtilWrapper = new dbu_InventoryUtilWrapper();
        try{
            //if(cartItemWrapper.cartItemProductDetailWrapper != null && cartDetails.dbu_Pick_Up_From_Store__r != null && (String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.partNumber) && String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.FullPartNumber) && String.isNotBlank(cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c))){
            if(cartItemWrapper.cartItemProductDetailWrapper != null && cartDetails.dbu_Pick_Up_From_Store__r != null && String.isNotBlank(cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c)){
                if(CurrencyISOcodeValue.equalsIgnoreCase('USD') || CurrencyISOcodeValue.equalsIgnoreCase('US') || CurrencyISOcodeValue.equalsIgnoreCase('USa')){
                    CurrencyISOcodeValue = 'US';
                }else{
                    CurrencyISOcodeValue = 'CA';
                }
                if(objProductVsInventoryRespose != null && objProductVsInventoryRespose.size() > 0 && objProductVsInventoryRespose.containsKey(cartItemWrapper.cartItemProductDetailWrapper.sfid) && objProductVsInventoryRespose.get(cartItemWrapper.cartItemProductDetailWrapper.sfid).API_response__c != null && (objProductVsInventoryRespose.get(cartItemWrapper.cartItemProductDetailWrapper.sfid).Postal_Code__c == cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c)){
                    //objProductVsInventoryRespose.get(cartItemWrapper.cartItemProductDetailWrapper.sfid).API_response__c
                    lstInventoryWrapper = Dbu_InventoryWrapper.parse(objProductVsInventoryRespose.get(cartItemWrapper.cartItemProductDetailWrapper.sfid).API_response__c);
                }else{
                    if(String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.FullPartNumber) && String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.partNumber)){
                        lstInventoryWrapper = dbu_Integration_InventoryCheck.getInventory(cartItemWrapper.cartItemProductDetailWrapper.FullPartNumber,cartItemWrapper.cartItemProductDetailWrapper.partNumber,cartItemWrapper.cartItemProductDetailWrapper.productCode,cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c,CurrencyISOcodeValue);
                    }else{
                        lstInventoryWrapper = null;
                    }
                    //objInventoryUtilWrapper.inventoryResult = new dbu_InventoryCheck_Result__c(API_response__c = JSON.serialize(lstInventoryWrapper),product__c = cartItemWrapper.cartItemProductDetailWrapper.sfid, Cart__c = cartDetails.ccrz__CartId__c);
                    if(lstInventoryWrapper != null){
                        objInventoryUtilWrapper.inventoryResult = new dbu_InventoryCheck_Result__c(API_response__c = JSON.serialize(lstInventoryWrapper),product__c = cartItemWrapper.cartItemProductDetailWrapper.sfid, Cart__c = cartDetails.ccrz__CartId__c,Postal_Code__c = cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
                    }else{
                        //objInventoryUtilWrapper.inventoryResult = new dbu_InventoryCheck_Result__c(API_response__c = 'N',product__c = cartItemWrapper.cartItemProductDetailWrapper.sfid, Cart__c = cartDetails.ccrz__CartId__c);
                    }
                }
                system.debug('lstInventoryWrapper==='+lstInventoryWrapper);
                dbu_CartItemWrapper cartItemWrapperToUpdate = dbu_CalculateDates.estimatedPickUpDateCalculate(cartItemWrapper,lstInventoryWrapper,cartDetails);
                System.debug('cartItemWrapperToUpdate====\t'+cartItemWrapperToUpdate);
                System.debug('cartItemWrapper===\t'+cartItemWrapper);
                System.debug('objInventoryUtilWrapper.dbu_InventoryCheck_Result__c===\t'+objInventoryUtilWrapper.inventoryResult);
            }
        }catch (Exception e) {
            // Error handling...
            system.debug('Inside getProductAvailability\t'+e.getMessage()+'LineNumber\t'+e.getLineNumber());
            system.debug('e.stacktracke > ' + e.getStackTraceString());
        }
        
        return objInventoryUtilWrapper;
    }


    @AuraEnabled
    public static void getProductAvailabilMap(ccrz__E_Cart__c cartDetails,List<dbu_CartItemWrapper> lstCartItemWrapper,List<String> ProductIDSet, String CurrencyISOcodeValue){
        System.debug('lstCartItemWrapper.size()\t'+lstCartItemWrapper.size()+'\tlstCartItemWrapper in getProductAvailabilMap method=>'+lstCartItemWrapper);
        String ItemAvailabilityMessage;
        List<dbu_InventoryCheck_Result__c> lstInventoryCheckResponseForInsertion = new List<dbu_InventoryCheck_Result__c>();
        dbu_InventoryUtilWrapper objInventoryUtilWrapper   = new dbu_InventoryUtilWrapper();
        List<ccrz__E_CartItem__c> lstCartItemForUpdation = new List<ccrz__E_CartItem__c>();
        List<dbu_InventoryCheck_Result__c> lstInventoryCheckResponse = new List<dbu_InventoryCheck_Result__c>();
        Map<String,dbu_InventoryCheck_Result__c> objProductVsInventoryRespose = new Map<String,dbu_InventoryCheck_Result__c>();
        
        try{
            lstInventoryCheckResponse = [select id, API_response__c, Cart__c, product__c,Time_Interval__c,Postal_Code__c from dbu_InventoryCheck_Result__c where Cart__c =: cartDetails.ccrz__CartId__c order by createdDate asc];
            System.debug('lstInventoryCheckResponse\t'+lstInventoryCheckResponse);
            if((lstInventoryCheckResponse.size() > 0 && lstInventoryCheckResponse[0].Time_Interval__c < Integer.valueOf(system.label.dbu_InventoryCheck_TimeInterval))){
                System.debug('lstInventoryCheckResponse===\t'+lstInventoryCheckResponse[0].Time_Interval__c);
                System.debug('cartDetails.dbu_Pick_Up_From_Store__r\t'+cartDetails.dbu_Pick_Up_From_Store__r);
                for(dbu_InventoryCheck_Result__c objResult : lstInventoryCheckResponse){
                    objProductVsInventoryRespose.put(objResult.product__c,objResult);
                }
            }
            //System.debug('lstInventoryCheckResponse.size()\t'+lstInventoryCheckResponse.size()+'\tlstInventoryCheckResponse[0].Time_Interval__c\t'+lstInventoryCheckResponse[0].Time_Interval__c+'\tsystem.label.dbu_InventoryCheck_TimeInterval\t'+system.label.dbu_InventoryCheck_TimeInterval+'objProductVsInventoryRespose.get(lstCartItemWrapper[0].cartItemProductDetailWrapper.sfid).Postal_Code__c\t'+objProductVsInventoryRespose.get(lstCartItemWrapper[0].cartItemProductDetailWrapper.sfid).Postal_Code__c+'\tcartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c\t'+cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c);
            for(dbu_CartItemWrapper cartItemWrapper: lstCartItemWrapper){
                //if(cartItemWrapper.cartItemProductDetailWrapper != null && cartDetails.dbu_Pick_Up_From_Store__r != null && (!cartItemWrapper.cartItemProductDetailWrapper.isCoreProduct && !cartItemWrapper.cartItem.dbu_isShipTo__c && String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.partNumber) && String.isNotBlank(cartItemWrapper.cartItemProductDetailWrapper.FullPartNumber) && String.isNotBlank(cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c))){
                if(cartItemWrapper.cartItemProductDetailWrapper != null && cartDetails.dbu_Pick_Up_From_Store__r != null && !cartItemWrapper.cartItemProductDetailWrapper.isCoreProduct && !cartItemWrapper.cartItem.dbu_isShipTo__c && String.isNotBlank(cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c)){
                    objInventoryUtilWrapper = getProductAvailability(cartDetails,cartItemWrapper,null,CurrencyISOcodeValue,objProductVsInventoryRespose);
                    System.debug('cartItemWrapper after setup of the availability details===\t'+cartItemWrapper);
                    // Below is the case for when time interval for api call is not expired
                    //if(lstInventoryCheckResponse.size() > 0 && (lstInventoryCheckResponse[0].Time_Interval__c < Integer.valueOf(system.label.dbu_InventoryCheck_TimeInterval)) && objProductVsInventoryRespose != null && objProductVsInventoryRespose.size() > 0 && (objProductVsInventoryRespose.get(lstCartItemWrapper[0].cartItemProductDetailWrapper.sfid).Postal_Code__c == cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c)){
                      if(lstInventoryCheckResponse.size() > 0 && (lstInventoryCheckResponse[0].Time_Interval__c < Integer.valueOf(system.label.dbu_InventoryCheck_TimeInterval)) && objProductVsInventoryRespose != null && objProductVsInventoryRespose.size() > 0 && (lstInventoryCheckResponse[0].Postal_Code__c == cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c)){
                        //Below is the case when additional items is added in the cart 
                        //Means existing Inventory object have not record for this project
                        if(objProductVsInventoryRespose != null && objProductVsInventoryRespose.size() > 0 && !objProductVsInventoryRespose.containsKey(cartItemWrapper.cartItemProductDetailWrapper.sfid)){
                            //Belwo condition checking whether Inventory api is called successfully and gett
                            if(objInventoryUtilWrapper != null && objInventoryUtilWrapper.inventoryResult != null){
                                lstInventoryCheckResponseForInsertion.add(objInventoryUtilWrapper.inventoryResult);
                                //lstCartItemForUpdation.add(cartItemWrapper.cartItem); 
                            }
                        }
                    }
                    else {
                        if(objInventoryUtilWrapper != null && objInventoryUtilWrapper.inventoryResult != null){
                            System.debug('adding Item in the lstInventoryCheckResponseForInsertion');
                            lstInventoryCheckResponseForInsertion.add(objInventoryUtilWrapper.inventoryResult);
                            //lstCartItemForUpdation.add(cartItemWrapper.cartItem); 
                        }
                    }
                    lstCartItemForUpdation.add(cartItemWrapper.cartItem);
                } else{//this changes is done on 1st Nov 2021
                    cartItemWrapper.cartItem.dbu_Estimated_Delivery__c = dbu_CalculateDates.FetchEstimatedDelivery();
                    cartItemWrapper.ItemAvailabilityMessage = 'In-Stock';
                    lstCartItemForUpdation.add(cartItemWrapper.cartItem);
                }           
            }
            System.debug('lstCartItemWrapper====\t'+lstCartItemWrapper);
            System.debug('lstCartItemForUpdation===\t'+lstCartItemForUpdation);
            System.debug('lstInventoryCheckResponseForInsertion===\t'+lstInventoryCheckResponseForInsertion);
            if(lstCartItemForUpdation != null && lstCartItemForUpdation.size() > 0){
                update lstCartItemForUpdation;
            }
            if(lstInventoryCheckResponseForInsertion != null && lstInventoryCheckResponseForInsertion.size() > 0){
                System.debug('Going to Insert new Inventory Check result'+lstInventoryCheckResponse);
                insert lstInventoryCheckResponseForInsertion;
            }
            //If the time Interval is exceeded then deleting the previous stored result
            if(lstInventoryCheckResponse.size() > 0 && (lstInventoryCheckResponse[0].Time_Interval__c > Integer.valueOf(system.label.dbu_InventoryCheck_TimeInterval) || (objProductVsInventoryRespose.get(lstCartItemWrapper[0].cartItemProductDetailWrapper.sfid).Postal_Code__c != cartDetails.dbu_Pick_Up_From_Store__r.ccrz__PostalCode__c))){
                System.debug('Going to delete the existing Inventory Check result'+lstInventoryCheckResponse);
                delete lstInventoryCheckResponse;
            }
            dbu_Integration_Error_Log.createErrorLog(lstIntegrationErrorLogWrapper);
            
        }catch (Exception e) {
            // Error handling...
            system.debug('Inside getProductAvailabilMap\t'+e.getMessage()+'LineNumber\t'+e.getLineNumber());
            system.debug('e.stacktracke > ' + e.getStackTraceString());
        }
        
    }

    public static Map<string,double> getProductAvailabilMapLocal(List<String> ProductIDSet, String CurrencyISOcodeValue){
        //CHECK FOR INVENTORY
        Map<string,double> productInventorymapping = new Map<string,double>();
        try{
            list<AggregateResult> productInventory = new list<AggregateResult>();
            productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                                from ccrz__E_ProductInventoryItem__c
                                where ccrz__ProductItem__c IN : ProductIDSet
                                and CurrencyIsoCode =: CurrencyISOcodeValue
                                GROUP BY ccrz__ProductItem__c];
            system.debug(productInventory);
            
            if(productInventory.size() > 0){
                for(AggregateResult pi : productInventory){
                    productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
                system.debug('productInventorymapping > ' + productInventorymapping);
            }
            system.debug('productInventorymapping > ' + productInventorymapping);
            system.debug('productInventorymapping size > ' + productInventorymapping.size());
            }

            /*Shrirma: 16Feb 2021 commented bcoz we are not checking for ware house in local inventory List<ccrz__E_ProductInventoryItem__c> lstProductInventoryItemForLocation = [select id,ccrz__InventoryLocationCode__c from ccrz__E_ProductInventoryItem__c
            where ccrz__ProductItem__c IN : ProductIDSet and CurrencyIsoCode =: CurrencyISOcodeValue];
            System.debug('lstProductInventoryItemForLocation======\t'+lstProductInventoryItemForLocation);
            for(ccrz__E_ProductInventoryItem__c InventoryItem : lstProductInventoryItemForLocation){
                InventoryLocationSet.add(InventoryItem.ccrz__InventoryLocationCode__c);
            }
            System.debug('InventoryLocationSet======\t'+InventoryLocationSet);*/
        }catch (Exception e) {
            // Error handling...
            system.debug(e.getMessage()+'LineNumber\t'+e.getLineNumber());
            system.debug('e.stacktracke > ' + e.getStackTraceString());
        }
         return productInventorymapping;
    }
    
    //APPLYING COUPON TO CART - ADDED BY MALHAR - 18 FEB 2021 - FOR CART RECALULATION
    public static Boolean reapplyCoupon(Id CartId, string couponCode){
        Decimal totalCartDiscount;
        decimal originalCartTotal;
        Boolean couponApplied;
        system.debug('CartId' +CartId);
        system.debug('couponCode' +couponCode);
        
        //################## SETUP INPUT DATA #################################### 
        Map<String, Object> couponToApplyToCart = new Map<String, Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiCart.CART_ID => CartId,
                ccrz.ccApiCoupon.CODE => couponCode
                };
                    
                    //################## FIRE CC COUPON API APPLY METHOD ####################################  
                    try {
                        Map<String, Object> applyCouponResult = ccrz.ccApiCoupon.apply(couponToApplyToCart);
                        couponApplied = (Boolean)applyCouponResult.get(ccrz.ccApi.SUCCESS);
                        system.debug('SUCCESS FLAG >>> ' +  (Boolean)applyCouponResult.get(ccrz.ccApi.SUCCESS));
                        system.debug('couponApplied' +couponApplied);
                    } catch (Exception e) {
                        system.debug(e);
                        // Error handling...
                    }
        return couponApplied;
        
    }  
    
    //REMOVING APPLIED CART COUPON  - ADDED BY MALHAR - 18 FEB 2021 - FOR CART RECALULATION
    public static Boolean removeAppliedCoupon(String CartIdRmv){
        Boolean removeCoupon;
        if(CartIdRmv != ''){

        String cartID = CartIdRmv;
        system.debug('cartID > ' + cartID);
        Map<string, object> RemoveCouponInputData = new Map<string, object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
            ccrz.ccApiCart.CART_ID => cartID,
            ccrz.ccApiCoupon.REPRICE_CART => true
        };
        system.debug('RemoveCouponInputData > ' + RemoveCouponInputData);
        try{
            Map<String, Object> removeCouponResponse = ccrz.ccApiCoupon.remove(RemoveCouponInputData);
            system.debug('removeCouponResponse > ' + JSON.serializePretty(removeCouponResponse));
            removeCoupon = (Boolean)removeCouponResponse.get(ccrz.ccApi.SUCCESS);
            system.debug((Boolean)removeCouponResponse.get(ccrz.ccApi.SUCCESS)); 
            system.debug('removeCoupon' +removeCoupon);
        }catch(Exception e){
            system.debug(e);
        }  
        }
    
    return removeCoupon;

    }
}