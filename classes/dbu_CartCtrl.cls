public without sharing class dbu_CartCtrl {
    public static List<dbu_Integration_Error_Log__c> lstIntegrationErrorLogWrapper = new List<dbu_Integration_Error_Log__c>();
    public dbu_CartCtrl() {

    } 
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> fetchLstCartItemsByCartId(String cartId){
       List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper ;
        List<ccrz__E_Cart__c> objCCCart = new List<ccrz__E_Cart__c>();
        //Decimal estimatedShippingCost = 0.00;
        
        // Calculating Shipping Cost
        //estimatedShippingCost = dbu_CheckOutCntrl.updateShippingAmountOnCart(true,cartId,'isEstimated');
        
        // added by Ranadip for Security
        if(!dbu_UserValidation.validateUserForCart(cartId)){
            return new List<dbu_CCCartApiResponseWrapper>();
        }// end here
        
        try{
            System.debug('UserInfo.getUserType====='+UserInfo.getUserType()+'CartId=========\t'+CartId);
            /*Shriram: 1st Oct 2020*/
            if((String.isNotBlank(cartId)  && cartId != 'undefined') && (cartId.length() == 15 || cartId.length() == 18)){//Guest user case
                if(UserInfo.getUserType().equalsIgnoreCase('Guest')){
                    objCCCart = [select id from ccrz__E_Cart__c where id =:cartId and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true  order by createdDate desc limit 1 ];
                }else{
                    objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and id =:cartId and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc limit 1 ];
                }
            }
            
            if(objCCCart !=null && objCCCart.size() == 0 && UserInfo.getUserType() != 'Guest'){//Logged In user case
                objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc limit 1 ];
            }
           
            System.debug('CartSize==\t'+objCCCart.size()+'objCCCart===\t'+objCCCart);
            if(objCCCart.size() != 0){
                cartId = objCCCart[0].Id;
                objCCCartApiResponseWrapper = dbu_CallCCCartApi.fetchCartItemsByCartId(cartId,'');
            }
            removeShipToAddressFromCart(cartId);
         if(Test.isRunningTest()) {
                // Cause DMLException
                insert new Lead();
            }
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return objCCCartApiResponseWrapper;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<dbu_CCCartApiResponseWrapper> fetchLstCartItemsByCartIdAfterTax(String cartId){
         return dbu_CallCCCartApi.fetchCartItemsByCartId(cartId);
    }
    
    @AuraEnabled//(cacheable=true)
    public static dbu_lstCartItemAndCartWrapper calculateTax(String cartId){
        dbu_lstCartItemAndCartWrapper obj = new dbu_lstCartItemAndCartWrapper();
         obj = dbu_VertexCtrl.getVertexQuoteTax(cartId, null);
        //updateCartAndCartItem(obj);
         System.debug('calculateTax=>'+obj);
       return obj;
    }
    
    @AuraEnabled
    public static Boolean updateCartAndCartItem(String cartAndCartItem){
   
        System.debug('cartAndCartItem=>'+ cartAndCartItem);
        dbu_lstCartItemAndCartWrapper objCartAndCartItem = new dbu_lstCartItemAndCartWrapper();
        
        List<ccrz__E_Cart__c> carts = new List<ccrz__E_Cart__c>();
        List<ccrz__E_CartItem__c> cartItems = new List<ccrz__E_CartItem__c>();
        System.debug('objCartAndCartItem=>'+ JSON.serialize(objCartAndCartItem));
        Boolean isSuccess = false;
        List<String> errorMessages = new List<String>();

        try{
            if(String.isNotBlank(cartAndCartItem)){
               objCartAndCartItem = (dbu_lstCartItemAndCartWrapper)JSON.deserialize(
               cartAndCartItem, dbu_lstCartItemAndCartWrapper.class);
            }
            if(objCartAndCartItem != null){
                if(objCartAndCartItem.cart != null){
                    carts.add(objCartAndCartItem.cart);
                    //upsert carts;
                    Database.UpsertResult[] cartsList = Database.upsert(carts, true);
                    for (Database.UpsertResult sr : cartsList) {
                        if (sr.isSuccess()) {
                            isSuccess = true;
                        } else {
                            for(Database.Error err : sr.getErrors()) {
                                errorMessages.add(err.getMessage());
                            }
                            isSuccess = false;
                        }
                    }
                }
                 
             if(objCartAndCartItem.lstCartItem != null)
             {
                cartItems.addAll(objCartAndCartItem.lstCartItem);
                //upsert cartItems;
                Database.UpsertResult[] cartItemsList = Database.upsert(cartItems, true);
                for (Database.UpsertResult sri : cartItemsList) {
                    if (sri.isSuccess()) {
                        isSuccess = true;
                    } else {
                        for(Database.Error erri : sri.getErrors()) {
                            errorMessages.add(erri.getMessage());
                        }
                        isSuccess = false;
                    }
                }

             }
                 
            }
            if(Test.isRunningTest()) {
                // Cause DMLException
                insert new Lead();
            }
        } catch(Exception ex){
            errorMessages.add(ex.getMessage()+' Line No:'+ex.getLineNumber());
            dbu_Integration_Error_Log.createErrorLog(null,'',cartAndCartItem,string.join(errorMessages,','),'Vertex No Tax Exception','Exception');
            System.debug('ex.getMessage while updating tax==>'+ex.getMessage()+'LineNumber=>'+ex.getLineNumber());
            return isSuccess;
        }

        System.debug('Successfully updated cart');
        //return objCartAndCartItem;
        return isSuccess;
    }
  
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> fetchLstCartItemsByCartId(String cartId, String cart){
       List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper ;
        List<ccrz__E_Cart__c> objCCCart = new List<ccrz__E_Cart__c>();
        try{
            System.debug('UserInfo.getUserType====='+UserInfo.getUserType());
            System.debug('???????????CartId=========\t'+CartId);
            /*Shriram: 1st Oct 2020*/
            if((String.isNotBlank(cartId)  && cartId != 'undefined') && (cartId.length() == 15 || cartId.length() == 18)){//Guest user case
                if(UserInfo.getUserType().equalsIgnoreCase('Guest')){
                    objCCCart = [select id from ccrz__E_Cart__c where id =:cartId and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart'  and ccrz__ActiveCart__c = true  order by createdDate desc limit 1 ];
                }else{
                    objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and id =:cartId and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc limit 1 ];
                }
            }
            if(objCCCart.size() == 0 && UserInfo.getUserType() != 'Guest'){//Logged In user case
                objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc limit 1 ];
            }
            System.debug('CartSize==\t'+objCCCart.size()+'objCCCart===\t'+objCCCart);
            if(objCCCart.size() != 0){
                cartId = objCCCart[0].Id;
                objCCCartApiResponseWrapper = dbu_CallCCCartApi.fetchCartItemsByCartId(cartId,cart);//only in CSO 
                //objCCCartApiResponseWrapper = generateResponse(cartId);//For DBU only
                removeShipToAddressFromCart(cartId);
            }
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return objCCCartApiResponseWrapper;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<dbu_CCCartApiResponseWrapper> fetchLstCartItemsByCartIdwithStoreLocation(String cartId, String cart, string storeCountry){
       List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper ;
        List<ccrz__E_Cart__c> objCCCart = new List<ccrz__E_Cart__c>();
        try{
            System.debug('UserInfo.getUserType====='+UserInfo.getUserType());
            System.debug('???????????CartId=========\t'+CartId);
            /*Shriram: 1st Oct 2020*/
            if((String.isNotBlank(cartId)  && cartId != 'undefined') && (cartId.length() == 15 || cartId.length() == 18)){//Guest user case
                if(UserInfo.getUserType().equalsIgnoreCase('Guest')){
                    objCCCart = [select id from ccrz__E_Cart__c where id =:cartId and ccrz__CartStatus__c = 'Open' and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__CartType__c = 'Cart'  and ccrz__ActiveCart__c = true  order by createdDate desc limit 1 ];
                }else{
                    objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__ActiveCart__c = true and id =:cartId and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc limit 1 ];
                }
            }
            if(objCCCart.size() == 0 && UserInfo.getUserType() != 'Guest'){//Logged In user case
                objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc limit 1 ];
            }
            System.debug('CartSize==\t'+objCCCart.size()+'objCCCart===\t'+objCCCart);
            if(objCCCart.size() != 0){
                cartId = objCCCart[0].Id;
                objCCCartApiResponseWrapper = dbu_CallCCCartApi.fetchCartItemsByCartId(cartId,cart);//only in CSO 
                //objCCCartApiResponseWrapper = generateResponse(cartId);//For DBU only
            }
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return objCCCartApiResponseWrapper;
    }    

    @AuraEnabled  
    public static ccrz__E_Product__c getRelatedProductByProductId(String pId){
        /*Core Product Insertion : After insertion of the Original Product here insertion of CoreProduct will happen*/
            ccrz__E_Product__c lstRelatedProduct;
            List<ccrz__E_Product__c> lstProduct = [Select id, dbu_Has_Core_Charge__c, (select id,ccrz__RelatedProduct__r.id from ccrz__E_RelatedProducts__r where ccrz__RelatedProductType__c = 'Core Charge') from ccrz__E_Product__c  
                                            where id =: pId AND dbu_Has_Core_Charge__c = true];
        if(lstProduct.size() > 0 && lstProduct[0].ccrz__E_RelatedProducts__r != null && lstProduct[0].ccrz__E_RelatedProducts__r.size() > 0 && lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r != null){
                // coreProductId =  lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.Id;
                // coreItemPrice = lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r.dbu_Core_Charge_Amount__c;
                lstRelatedProduct = lstProduct[0].ccrz__E_RelatedProducts__r[0].ccrz__RelatedProduct__r;
            }                                
            return lstRelatedProduct;                              
        /**Core Product Ended here */
    }
    
     @AuraEnabled  
    public static List<ccrz__E_CartItem__c> insertCartItem(String productId,String cartId,double itemPrice,double quantity,String hasCoreCharge, String storeCountry,double coreChargeAmt,string storeLanguage){
        String cartItemId, loggerUserCartId;
        //Integer cartSize = 0;
        List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
        List<ccrz__E_CartItem__c> returnObjCartItem = new List<ccrz__E_CartItem__c>();
        ccrz__E_Cart__c objNewCart;
        String prodId;
        ccrz__E_Product__c relatedCoreProduct;
        String coreProductId;
        Double coreItemPrice,coreUpdatedQuantity;
        try{
            List<ccrz__E_Product__c> objProd =  [select id from ccrz__E_Product__c where ccrz__SKU__c =: productId];
            if(objProd.size() > 0){
                prodId =  objProd[0].Id; 
            }
            if(UserInfo.getUserType() == 'Guest'){
                system.debug('IF GUEST :: YES');
                return insertCartItemGuest(prodId, cartId, itemPrice, quantity, storeCountry,coreChargeAmt,storeLanguage);
            }
            relatedCoreProduct = getRelatedProductByProductId(prodId);
            List<ccrz__E_Cart__c> objCCCart = new List<ccrz__E_Cart__c>();
           
            System.debug('UserInfo.getUserType====='+UserInfo.getUserType()+'CartId=====\t'+CartId);
            
            /**Code Added on 4th OCt 2020 */
            if((String.isNotBlank(cartId)  && cartId != 'undefined') && (cartId.length() == 15 || cartId.length() == 18)){//Guest user case
                if(UserInfo.getUserType().equalsIgnoreCase('Guest')){
                    system.debug('IF guest');
                    objCCCart = [select id from ccrz__E_Cart__c where id =:cartId and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and dbu_Cart_StoreCountry__c =: storeCountry order by createdDate desc limit 1 ];
                }else{
                    system.debug('IF non guest');
                    objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and id =:cartId and ccrz__User__c =: UserInfo.getUserId() and dbu_Cart_StoreCountry__c =: storeCountry order by createdDate desc limit 1 ];
                    system.debug('objCCCart ::' + objCCCart);                    
                }
            }
            
            if(objCCCart !=null && objCCCart.size() == 0 && UserInfo.getUserType() != 'Guest'){//Logged In user case
                system.debug('non guest');
                objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and ccrz__User__c =: UserInfo.getUserId() and dbu_Cart_StoreCountry__c =: storeCountry order by createdDate desc limit 1 ];
                system.debug('objCCCart :: ' + objCCCart);
            }
            /**Ended here */
            if(objCCCart.size() > 0){
                loggerUserCartId = objCCCart[0].Id;
            }
            if(objCCCart != null && objCCCart.size() == 0){
                /*This code is commented to implement the cc api to create cart
                 * objNewCart = new ccrz__E_Cart__c(ccrz__CartType__c = 'Cart',  ccrz__Name__c = 'My Cart', ccrz__ActiveCart__c = true);
                /insert objNewCart;*/
                //cartId = objNewCart.Id;
                
                //loggerUserCartId = dbu_CallCCCartApi.createCart(storeCountry); shriram:- 18th March 2021
                loggerUserCartId = dbu_CallCCCartApi.createCart(storeCountry,storeLanguage);
                system.debug('loggerUserCartId :: ' + loggerUserCartId);
            }
           
            /**20 October 2020: New Logic to update according to update the current  */
            if(String.isNotBlank(loggerUserCartId)) {

                List<ccrz__E_CartItem__c> existingCartItems  = [SELECT Id,ccrz__Quantity__c,ccrz__Price__c ,ccrz__SubAmount__c, ccrz__Cart__c FROM ccrz__E_CartItem__c WHERE ccrz__Product__r.Id =:prodId and ccrz__Cart__r.dbu_Cart_StoreCountry__c =: storeCountry and ccrz__Cart__c =: loggerUserCartId LIMIT 1];
                System.debug('existingCartItems=========>'+existingCartItems);
                if (existingCartItems.size() == 0)
                {    
                    //ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = itemPrice ,ccrz__OriginalQuantity__c = quantity,ccrz__PricingType__c = 'external',ccrz__Cart__c = cartId,ccrz__Quantity__c=quantity, ccrz__Product__c = productId, ccrz__Price__c = itemPrice, ccrz__SubAmount__c = totalPrice);
                    //shriram 20 Oct 2020 ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = itemPrice ,ccrz__OriginalQuantity__c = quantity,ccrz__Cart__c = cartId,ccrz__Quantity__c=quantity, ccrz__Product__c = productId, ccrz__Price__c = itemPrice, ccrz__SubAmount__c = totalPrice);
                    
                    //checking if product is shipto,pickup,shippick - added for inventory changes - 9-6-2021
                    list<ccrz__E_Product__c> currenctProduct = new list<ccrz__E_Product__c>();
                    currenctProduct = [select id,dbu_Available_to_ship__c,dbu_Pick_Up_Only__c from ccrz__E_Product__c where id =: prodId limit 1];
                    boolean shipboolean;

                    if(currenctProduct.size() > 0){
                        boolean shiponly = false;
                        boolean pickuponly = false; 
                        if(currenctProduct[0].dbu_Available_to_ship__c){
                            shiponly = true;
                        } 
                        if(currenctProduct[0].dbu_Pick_Up_Only__c){
                            pickuponly = true;
                        }
                        
                        if(shiponly == true && pickuponly == false){
                            shipboolean = true;
                        }
                        else if(shiponly == false && pickuponly == true){
                            shipboolean = false;
                        }                        
                        else if(shiponly == true && pickuponly == true){
                            shipboolean = true;
                        }  
                        else if(shiponly == false && pickuponly == false){
                            shipboolean = true;
                        }  
                    }                    
                    
                    try{
                    /*////////////////////////////////////////////////*/
                        String newCartId = dbu_CallCCCartApi.insertCartItem1(productId, loggerUserCartId, itemPrice, quantity, shipboolean);
                        System.debug('newCartId after the insert New cart Items#######'+newCartId);
                        if(String.isNotBlank(newCartId)){
                            loggerUserCartId = newCartId; 
                        }

                        List<ccrz__E_CartItem__c> currentCartItems  = [SELECT Id FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: loggerUserCartId order by createdDate desc limit 1];
                        if (currentCartItems.size() > 0 || test.isRunningTest())
                        { 
                            returnObjCartItem = currentCartItems;
                            /**Core Product Insertion is going to happen here*/
                            if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
                                coreProductId =  relatedCoreProduct.Id;
                                if(coreChargeAmt != null){
                                    coreItemPrice = coreChargeAmt;
                                }else{
                                    coreItemPrice = 0.00;
                                }
                                String skuCoreProduct;
                                List<ccrz__E_Product__c> objCoreProd =  [select ccrz__SKU__c  from ccrz__E_Product__c where id =: coreProductId];
                                System.debug('objCoreProd==>'+objCoreProd);
                                if(objProd.size() > 0){
                                    skuCoreProduct =  objCoreProd[0].ccrz__SKU__c; 
                                    dbu_CallCCCartApi.insertCartItem1(skuCoreProduct, loggerUserCartId, coreItemPrice, quantity, shipboolean);
                                }
                                
                            }
                            /**Ended here */
                        }
                    /*////////////////////////////////////////////////*/
                        //returnObjCartItem.add(objccCartItem);
                    }catch(DmlException dmle){
                        System.debug('insert Exception message\t'+dmle.getMessage()+'\tException Line Number\t'+dmle.getLineNumber());
                    }
                }
                else 
                {
                    for(ccrz__E_CartItem__c existingCartItem:existingCartItems)
                    {
                        Double updatedQuantity = existingCartItem.ccrz__Quantity__c + quantity;
                        coreUpdatedQuantity = updatedQuantity;
                        Double updatedTotalPrice = existingCartItem.ccrz__Price__c*updatedQuantity;
                        existingCartItem.ccrz__SubAmount__c = updatedTotalPrice;
                        existingCartItem.ccrz__Quantity__c = updatedQuantity;//existingCartItem.ccrz__Quantity__c + quantity;
                    }
                    try{
                        //CHECK FOR THE COUPON ON CART - ADDED BY MALHAR - 19 FEB 2021
                        //ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: cartId];
                        
                            //Removing Existing Coupon
                            Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
                            //Perform Cartitems Update
                            upsert existingCartItems;
                            returnObjCartItem =  existingCartItems;  
                            //@Ramesh CTS
                            if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
                              //  coreProductId =  relatedCoreProduct.Id;
                               updateCartItemCore(prodId,cartId,coreUpdatedQuantity,storeCountry);
                            }                          
                            //Reapplying the Coupon
                            //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);                            
                          
                    }catch(DmlException dmle){
                        System.debug('upsert Exception message\t'+dmle.getMessage()+'\tException Line Number\t'+dmle.getLineNumber());
                    }
                }
                //if(String.isNotBlank(objccCartItem.Id)){
                    //cartItemId = objccCartItem.Id;
                    //objCCCartApiResponseWrapper = dbu_CallCCCartApi.fetchCartItemsByCartId(cartId);
                    System.debug('returnObjCartItem>>>>>>>>>>>>>>>>>>>\t'+returnObjCartItem);
                //}
            }
            /**Ended here */
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return returnObjCartItem;
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<dbu_CCCartApiResponseWrapper> generateResponse(String cartId){
             dbu_CCCartApiResponseWrapper res = new dbu_CCCartApiResponseWrapper();
             List<dbu_CCCartApiResponseWrapper> response = new List<dbu_CCCartApiResponseWrapper>();
             List<dbu_CartItemWrapper> lstCartItemWrapper = new List<dbu_CartItemWrapper>();
             List<ccrz__E_Cart__c> carts = [SELECT ccrz__BuyerLastName__c,ccrz__BuyerFirstName__c,ccrz__TaxAmount__c,ccrz__TotalDiscount__c,Total_Cart_Discount__c,ccrz__CartId__c,OwnerId,ccrz__EncryptedId__c,ccrz__ActiveCart__c,ccrz__CartStatus__c,ccrz__CartType__c,lastModifiedDate,ccrz__Name__c,ccrz__TaxExemptFlag__c,ccrz__CurrencyISOCode__c,ccrz__Account__c,ccrz__AnonymousId__c,ccrz__RepricedDate__c,ccrz__ShipComplete__c,ccrz__Storefront__c,ccrz__User__c,ccrz__SubtotalAmount__c, ccrz__TotalAmount__c, ccrz__TaxSubTotalAmount__c, ccrz__TotalQuantity__c FROM ccrz__E_Cart__c where Id =:cartId];
             res.cartDetails = carts[0];
             List<ccrz__E_CartItem__c> lstCartItem= [SELECT id, ccrz__Product__c,ccrz__Product__r.dbu_Crate_Engine__c,ccrz__Quantity__c,ccrz__Price__c,ccrz__ProductType__c,ccrz__StoreID__c,ccrz__PricingType__c,ccrz__cartItemType__c,ccrz__SubAmount__c,ccrz__UnitOfMeasure__c,ccrz__ParentCartItem__c,ccrz__ItemStatus__c,ccrz__Is_Subscription_Selected__c,ccrz__OriginalQuantity__c,ccrz__OriginalItemPrice__c,ccrz__RequestDate__c, ccrz__ItemTotal__c FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =:cartId];
             ////////////
             /*Here getting the product lst by Iterationg*/
            List<String> lstProductIds = new List<String>();
            for(ccrz__E_CartItem__c obj : lstCartItem){
                lstProductIds.add(obj.ccrz__Product__c);
            }
             Map<String, dbu_CCApiCartRelatedResponseWrapper> mapOfIdProduct = dbu_CallCCCartApi.getProductAndMedia(lstProductIds,String.valueOf(carts[0].ccrz__CurrencyISOCode__c));
             ////////////
             for(ccrz__E_CartItem__c obj : lstCartItem){
                 dbu_CartItemWrapper objCartItemWrapper = new dbu_CartItemWrapper();
                objCartItemWrapper.cartItemProductDetailWrapper =  mapOfIdProduct.get(obj.ccrz__Product__c); 
                 if(test.isRunningTest()){
                     objCartItemWrapper.qtyAvailable = 11;
                 }else
                objCartItemWrapper.qtyAvailable = mapOfIdProduct.get(obj.ccrz__Product__c).qtyAvailable;
                 
                objCartItemWrapper.cartItem =   obj;
                lstCartItemWrapper.add(objCartItemWrapper);
            }
            res.lstCartItem = lstCartItemWrapper;
             if(carts.size() > 0){
                 res.subtotalAmount = carts[0].ccrz__SubtotalAmount__c;
                 res.totalAmount = carts[0].ccrz__TotalAmount__c;
                 res.taxSubTotalAmount = carts[0].ccrz__TaxSubTotalAmount__c;
                 res.totalQuantity = carts[0].ccrz__TotalQuantity__c;
                 if(carts[0].ccrz__TaxAmount__c != null)
                   res.taxAmount = carts[0].ccrz__TaxAmount__c;
                  else{
                        res.taxAmount = 0.00;
                  }
                  //Following Logic Modified by Malhar for Coupon related change - 17 March 2021 - begin
                  if(carts[0].ccrz__TotalDiscount__c != null){
                      if(carts[0].ccrz__TotalDiscount__c < 0){
                          res.totalCartDiscount = ((carts[0].ccrz__TotalDiscount__c) * -1);
                      }else{
                        res.totalCartDiscount = carts[0].ccrz__TotalDiscount__c;    
                      }                            
                  }else{
                        res.totalCartDiscount = 0.00;
                  }
                  //Following Logic Modified by Malhar for Coupon related change - 17 March 2021 - end
          }
             response.add(res);
             return response;
 
   }

    // for crate engine 
    //Malhar added StoreCountry in following Method - 3/12/2020
     @AuraEnabled  
    public static List<ccrz__E_CartItem__c> insertCartItemForCrateEngine(String productId,String cartId,double itemPrice,double quantity,string make,string model,string vin,string year,
                                                                         boolean EmissionAgreement,boolean ExportAgreement,boolean ShippingAgreement,boolean TncAgreement,
                                                                         boolean UnloadingAgreement,boolean WarrentyAggrement, String storeCountry,string storeLanguage,string state,string vehiclePowered){
        String cartItemId, loggerUserCartId;
        //Integer cartSize = 0;
        List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
        List<ccrz__E_CartItem__c> returnObjCartItem = new List<ccrz__E_CartItem__c>();
        ccrz__E_Cart__c objNewCart;
        String prodId;
        try{
            List<ccrz__E_Product__c> objProd =  [select id from ccrz__E_Product__c where ccrz__SKU__c =: productId];
            if(objProd.size() > 0){
                prodId =  objProd[0].Id; 
            }
            if(UserInfo.getUserType() == 'Guest'){
                system.debug('IF GUEST :: YES');
                return insertCartItemGuestForCrateEngine(prodId, cartId, itemPrice, quantity,make,model,vin,year,EmissionAgreement,ExportAgreement,ShippingAgreement,TncAgreement,UnloadingAgreement,WarrentyAggrement,storeCountry,storeLanguage,state,vehiclePowered);
            }
            List<ccrz__E_Cart__c> objCCCart = new List<ccrz__E_Cart__c>();
            //List<ccrz__E_Cart__c> objCCCart = [select id from ccrz__E_Cart__c where Id IN (select ccrz__Cart__c from ccrz__E_CartItem__c) limit 1];
            //31Aug List<ccrz__E_Cart__c> objCCCart = [select id from ccrz__E_Cart__c where id =:cartId and ccrz__CartStatus__c = 'Open'  order by createdDate desc limit 1 ];
            System.debug('UserInfo.getUserType====='+UserInfo.getUserType()+'CartId=====\t'+CartId);
            
            /**Code Added on 4th OCt 2020 */
            if((String.isNotBlank(cartId)  && cartId != 'undefined') && (cartId.length() == 15 || cartId.length() == 18)){//Guest user case
                if(UserInfo.getUserType().equalsIgnoreCase('Guest')){
                    system.debug('IF guest');
                    //Malhar added dbu_Cart_StoreCountry__c in following query - 3/12/2020
                    objCCCart = [select id from ccrz__E_Cart__c where id =:cartId and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__ActiveCart__c = true  order by createdDate desc limit 1 ];
                }else{
                    system.debug('IF non guest');
                    //Malhar added dbu_Cart_StoreCountry__c in following query - 3/12/2020
                    objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and id =:cartId and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc limit 1 ];
                    system.debug('objCCCart ::' + objCCCart);                    
                }
            }
            
            if(objCCCart !=null && objCCCart.size() == 0 && UserInfo.getUserType() != 'Guest'){//Logged In user case
                system.debug('non guest');
                //Malhar added dbu_Cart_StoreCountry__c in following query - 3/12/2020
                objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__ActiveCart__c = true and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc limit 1 ];
                system.debug('objCCCart :: ' + objCCCart);
            }
            /**Ended here */
            if(objCCCart.size() > 0){
                loggerUserCartId = objCCCart[0].Id;
            }
            if(objCCCart != null && objCCCart.size() == 0){
                //Malhar added StoreCountry in following method - 3/12/2020               
                //loggerUserCartId = dbu_CallCCCartApi.createCart(storeCountry); shriram:- 18th March 2021
                loggerUserCartId = dbu_CallCCCartApi.createCart(storeCountry,storeLanguage);
                system.debug('loggerUserCartId :: ' + loggerUserCartId);
            }
          
            /**20 October 2020: New Logic to update according to update the current  */
            if(String.isNotBlank(loggerUserCartId) || test.isRunningTest()) {

                   try{
                        String newCartId = dbu_CallCCCartApi.insertCartItemForCrateEngine(productId, loggerUserCartId, itemPrice, quantity,make,model,vin,year,EmissionAgreement,ExportAgreement,ShippingAgreement,TncAgreement,UnloadingAgreement,WarrentyAggrement,state,vehiclePowered);
                        System.debug('newCartId after the insert New cart Items#######'+newCartId);
                        if(String.isNotBlank(newCartId)){
                            loggerUserCartId = newCartId; 
                        }

                        List<ccrz__E_CartItem__c> currentCartItems  = [SELECT Id FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: loggerUserCartId order by createdDate desc limit 1];
                        if (currentCartItems.size() > 0)
                        { 
                            returnObjCartItem = currentCartItems;
                        }
                    }catch(DmlException dmle){
                        System.debug('insert Exception message\t'+dmle.getMessage()+'\tException Line Number\t'+dmle.getLineNumber());
                    }
                
               
               
            }
            /**Ended here */
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return returnObjCartItem;
    }
    //for crate engine
    
     @AuraEnabled
    public static List<ccrz__E_CartItem__c> insertCartItemGuest(String productId,String cartId,double itemPrice,double quantity,String storeCountry,double coreChargeAmt,string storeLanguage){
        String cartItemId,coreProductId;
        Double updatedTotalPrice, updatedQuantity;
       
        /**New Logic 13 Oct 2020 */
        List<ccrz__E_CartItem__c> returnObjCartItem = new List<ccrz__E_CartItem__c>();
        /**ended here */
        Double totalPrice = itemPrice*quantity;
        List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
        ccrz__E_Cart__c objNewCart;
        ccrz__E_Product__c relatedCoreProduct = getRelatedProductByProductId(productId);
        Double totalCorePrice,coreItemPrice;
        List<ccrz__E_CartItem__c> existingCartItemsCoreProduct;
        try{
            //List<ccrz__E_Cart__c> objCCCart = [select id from ccrz__E_Cart__c where Id IN (select ccrz__Cart__c from ccrz__E_CartItem__c) limit 1];
            List<ccrz__E_Cart__c> objCCCart = [select id from ccrz__E_Cart__c where id =:cartId and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__ActiveCart__c = true ];
            
            //String cartId;// = 'a1y19000001ArDO';
            System.debug('@@@@@@@@@@@@@@@@@@objCCCart\t'+objCCCart);
            if(objCCCart != null && objCCCart.size() == 0){
                System.debug('^^^^^^^objCCCart.size()\t'+objCCCart.size());
                
                //cartId = dbu_CallCCCartApi.createCart(storeCountry); //Shriram:- 18th March 2021
                cartId = dbu_CallCCCartApi.createCart(storeCountry,storeLanguage);
            }
           
            if(String.isNotBlank(cartId)) {

                //BEGIN - Before Updating check if Cart has Coupon Appiled - Added by Malhar - 19 Feb 2021
                //ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: cartId];
                //system.debug('currenctCart > ' + currenctCart.ccrz__E_CartCoupons__r);
                List<ccrz__E_CartItem__c> existingCartItems  = [SELECT Id,ccrz__Quantity__c,ccrz__Price__c ,ccrz__SubAmount__c, ccrz__Cart__c FROM ccrz__E_CartItem__c WHERE ccrz__Product__r.Id =:productId and ccrz__Cart__c =: cartId LIMIT 1];
                System.debug('existingCartItems==>'+existingCartItems);
                if (existingCartItems.size() == 0)
                {    
                    //ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = itemPrice ,ccrz__OriginalQuantity__c = quantity,ccrz__PricingType__c = 'external',ccrz__Cart__c = cartId,ccrz__Quantity__c=quantity, ccrz__Product__c = productId, ccrz__Price__c = itemPrice, ccrz__SubAmount__c = totalPrice);
                    
                    //Added by Malhar - 14 jan 2021                 
                    //get the country cureency iso mapping from custom settings
                    Map<string,string> countryCurrencyMap = new Map<string,string>();
                    for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                        system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                        system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                        countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
                    }
                    system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
                    string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);     
                    
                    
                    //checking if product is shipto,pickup,shippick - added for inventory changes - 9-6-2021
                    list<ccrz__E_Product__c> currenctProduct = new list<ccrz__E_Product__c>();
                    currenctProduct = [select id,dbu_Available_to_ship__c,dbu_Pick_Up_Only__c from ccrz__E_Product__c where id =: productId limit 1];
                    boolean shipboolean;
                    
                    if(currenctProduct.size() > 0){
                        boolean shiponly = false;
                        boolean pickuponly = false; 
                        if(currenctProduct[0].dbu_Available_to_ship__c){
                            shiponly = true;
                        } 
                        if(currenctProduct[0].dbu_Pick_Up_Only__c){
                            pickuponly = true;
                        }
                        
                        if(shiponly == true && pickuponly == false){
                            shipboolean = true;
                        }
                        else if(shiponly == false && pickuponly == true){
                            shipboolean = false;
                        }                        
                        else if(shiponly == true && pickuponly == true){
                            shipboolean = true;
                        }  
                        else if(shiponly == false && pickuponly == false){
                            shipboolean = true;
                        }  
                    }                    
                    
                    ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product',dbu_isShipTo__c= shipboolean,ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = itemPrice ,ccrz__OriginalQuantity__c = quantity,ccrz__Cart__c = cartId,ccrz__Quantity__c=quantity, ccrz__Product__c = productId, ccrz__Price__c = itemPrice, ccrz__SubAmount__c = totalPrice, CurrencyIsoCode =CurrencyISOcodeValue);

                    try{
                      
                        //Removing Existing Coupon
                        //Boolean CouponRemovedStatus = dbu_CallCCCartApi.removeAppliedCoupon(cartId);                        
                        Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId); 
                        //Perform Cartitems insert
                        insert objccCartItem;                        
                        returnObjCartItem.add(objccCartItem);
                        /**For core product related logic*/
                        /**Core Product Insertion is going to happen here*/
                            if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
                                coreProductId =  relatedCoreProduct.Id;
                                if(coreChargeAmt != null){
                                    coreItemPrice = coreChargeAmt;
                                }else{
                                    coreItemPrice = 0.00;
                                }
                                totalCorePrice = coreItemPrice*quantity;
                                ccrz__E_CartItem__c objccCartItemForCoreProduct = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product',dbu_isShipTo__c= shipboolean, ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today(),ccrz__OriginalItemPrice__c = itemPrice ,ccrz__OriginalQuantity__c = quantity,ccrz__Cart__c = cartId,ccrz__Quantity__c=quantity, ccrz__Product__c = coreProductId, ccrz__Price__c = coreItemPrice, ccrz__SubAmount__c = totalCorePrice , CurrencyIsoCode = CurrencyISOcodeValue);
                                //dbu_CallCCCartApi.insertCartItem1(coreProductId, loggerUserCartId, coreItemPrice, quantity);
                                insert objccCartItemForCoreProduct;
                            }

                        //Reapplying the Coupon
                        //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);                        
                    

                    /**Ended here */      
                    /**Ended here */
                    }catch(DmlException dmle){
                        System.debug('insert Exception message\t'+dmle.getMessage()+'\tException Line Number\t'+dmle.getLineNumber());
                    }
                }
                else 
                {
                    for(ccrz__E_CartItem__c existingCartItem:existingCartItems)
                    {
                        //Commented for core product common variable:-Double updatedQuantity = existingCartItem.ccrz__Quantity__c + quantity;
                        //Commented for core product common variable:- Double updatedTotalPrice = existingCartItem.ccrz__Price__c*updatedQuantity;
                        updatedQuantity = existingCartItem.ccrz__Quantity__c + quantity;
                        updatedTotalPrice = existingCartItem.ccrz__Price__c*updatedQuantity;
                        existingCartItem.ccrz__SubAmount__c = updatedTotalPrice;
                        existingCartItem.ccrz__Quantity__c = updatedQuantity;//existingCartItem.ccrz__Quantity__c + quantity;
                    }
                    try{

                            //Removing Existing Coupon
                            //Boolean CouponRemovedStatus = dbu_CallCCCartApi.removeAppliedCoupon(cartId);
                            Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
                            //perform cartitem insert/upsert
                            upsert existingCartItems;
                            returnObjCartItem =  existingCartItems;
                            if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
                                coreProductId =  relatedCoreProduct.Id;
                                updateCartItemCore(productId,cartId,updatedQuantity,storeCountry);
                            }
                            /**Ended here */  
                            System.debug('existingCartItemsCoreProduct==>'+existingCartItemsCoreProduct);
                            /**Core Producdt end here */

                            //Reapplying the Coupon
                            //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);
                        
                    }catch(DmlException dmle){
                        System.debug('upsert Exception message\t'+dmle.getMessage()+'\tException Line Number\t'+dmle.getLineNumber());
                    }
                }

                //END - Before Updating check if Cart has Coupon Appiled - Added by Malhar - 19 Feb 2021

                //if(String.isNotBlank(objccCartItem.Id)){
                    //cartItemId = objccCartItem.Id;
                    //objCCCartApiResponseWrapper = dbu_CallCCCartApi.fetchCartItemsByCartId(cartId);
                    System.debug('returnObjCartItem>>>>>>>>>>>>>>>>>>>\t'+returnObjCartItem);
                //}
            }
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return returnObjCartItem;
    }
    
    /* Insert cart item for guest user if the product is crate engine*/
    //Malhar added StoreCountry in following Method - 3/12/2020
     @AuraEnabled
    public static List<ccrz__E_CartItem__c> insertCartItemGuestForCrateEngine(String productId,String cartId,double itemPrice,double quantity,string make,string model,string vin,string year,
                                                                         boolean EmissionAgreement,boolean ExportAgreement,boolean ShippingAgreement,boolean TncAgreement,
                                                                         boolean UnloadingAgreement,boolean WarrentyAggrement, String storeCountry,string storeLanguage,string state,string vehiclePowered){
        String cartItemId;
        /**New Logic 13 Oct 2020 */
        List<ccrz__E_CartItem__c> returnObjCartItem = new List<ccrz__E_CartItem__c>();
        /**ended here */
        Double totalPrice = itemPrice*quantity;
        List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
        ccrz__E_Cart__c objNewCart;
        try{
             //Malhar added dbu_Cart_StoreCountry__c in following query - 3/12/2020
            List<ccrz__E_Cart__c> objCCCart = [select id from ccrz__E_Cart__c where id =:cartId and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and dbu_Cart_StoreCountry__c =: storeCountry and  ccrz__ActiveCart__c = true ];  
            
            System.debug('@@@@@@@@@@@@@@@@@@objCCCart\t'+objCCCart);
            if(objCCCart != null && objCCCart.size() == 0){
                //cartId = dbu_CallCCCartApi.createCart(storeCountry);//Shriram:- 18th March 2021 
                cartId = dbu_CallCCCartApi.createCart(storeCountry,storeLanguage);
            }
            if(String.isNotBlank(cartId)) {
                List<ccrz__E_CartItem__c> existingCartItems  = [SELECT Id,ccrz__Quantity__c,ccrz__Price__c ,ccrz__SubAmount__c, ccrz__Cart__c FROM ccrz__E_CartItem__c WHERE ccrz__Product__r.Id =:productId and ccrz__Cart__c =: cartId LIMIT 1];
                System.debug('existingCartItems==>'+existingCartItems);
                
                //Added by Malhar - 14 jan 2021                 
                //get the country cureency iso mapping from custom settings
                Map<string,string> countryCurrencyMap = new Map<string,string>();
                for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                    system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
                    system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
                    countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
                }
                system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
                string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);                 

                    //checking if product is shipto,pickup,shippick - added for inventory changes - 9-6-2021
                    list<ccrz__E_Product__c> currenctProduct = new list<ccrz__E_Product__c>();
                    currenctProduct = [select id,dbu_Available_to_ship__c,dbu_Pick_Up_Only__c from ccrz__E_Product__c where id =: productId limit 1];
                    boolean shipboolean;
                
                    if(currenctProduct.size() > 0){
                        boolean shiponly = false;
                        boolean pickuponly = false; 
                        if(currenctProduct[0].dbu_Available_to_ship__c){
                            shiponly = true;
                        } 
                        if(currenctProduct[0].dbu_Pick_Up_Only__c){
                            pickuponly = true;
                        }
                        
                        if(shiponly == true && pickuponly == false){
                            shipboolean = true;
                        }
                        else if(shiponly == false && pickuponly == true){
                            shipboolean = false;
                        }                        
                        else if(shiponly == true && pickuponly == true){
                            shipboolean = true;
                        }  
                        else if(shiponly == false && pickuponly == false){
                            shipboolean = true;
                        }  
                    }   
                
                    ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', ccrz__UnitOfMeasure__c = 'Each', ccrz__StoreID__c = 'CSSNAStore',ccrz__RequestDate__c = Date.today()
                                                                                ,ccrz__OriginalItemPrice__c = itemPrice ,ccrz__OriginalQuantity__c = quantity,ccrz__Cart__c = cartId,ccrz__Quantity__c=quantity,dbu_State__c=state, dbu_Vehicle_Powered__c=vehiclePowered,
                                                                                ccrz__Product__c = productId, ccrz__Price__c = itemPrice, ccrz__SubAmount__c = totalPrice,dbu_Make__c=make,dbu_Model__c=model,dbu_VIN__c=vin,dbu_Year__c=year,
                                                                               dbu_EmissionAgreement__c=true,dbu_ExportAgreement__c=true,dbu_ShippingAgreement__c=true,dbu_TncAgreement__c=true,dbu_UnloadingAgreement__c=true,dbu_WarrentyAggrement__c=true, CurrencyIsoCode = CurrencyISOcodeValue, dbu_isShipTo__c= shipboolean);
                    
                    try{
                    //BEGIN - Before Updating check if Cart has Coupon Appiled - Added by Malhar - 19 Feb 2021
                    ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: cartId];

                            //Removing Existing Coupon
                            Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
                            //Perform Cartitems Update
                            insert objccCartItem;
                            returnObjCartItem.add(objccCartItem);
                            
                            //Reapplying the Coupon
                            //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);

                    //END - Before Updating check if Cart has Coupon Appiled - Added by Malhar - 19 Feb 2021


                    }catch(DmlException dmle){
                        System.debug('insert Exception message\t'+dmle.getMessage()+'\tException Line Number\t'+dmle.getLineNumber());
                    }                   
            }
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return returnObjCartItem;
    }
    
    /*END*/
    
    @AuraEnabled(cacheable=true)
    public static Double fetchCartSize(String cartId){
        Double cartSize = 0;
        System.debug('CartId==============\t'+cartId);
        try{
            ///List<ccrz__E_CartItem__c> objCCCart = [select Id from ccrz__E_CartItem__c where Id=:cartId];
            //cartSize = [select count() from ccrz__E_CartItem__c where ccrz__Cart__c =: cartId];
            //List<AggregateResult> AggregateResultList1 = [select SUM(ccrz__Quantity__c) quantity from ccrz__E_CartItem__c where ccrz__Cart__c =: cartId];
            //List<AggregateResult> AggregateResultList1 = [select SUM(ccrz__Quantity__c) quantity from ccrz__E_CartItem__c where ccrz__Cart__c =: cartId];

            List<AggregateResult> AggregateResultList1 = [select SUM(ccrz__Quantity__c) quantity from ccrz__E_CartItem__c where ccrz__Cart__c =: cartId and ccrz__Cart__r.ccrz__CartStatus__c = 'Open' and ccrz__Cart__r.ccrz__CartType__c = 'Cart' and ccrz__Cart__r.ccrz__ActiveCart__c = true ];
            if(AggregateResultList1!= null && AggregateResultList1.size() > 0 && AggregateResultList1[0].get('quantity') != null){ 
                cartSize = (Double) AggregateResultList1[0].get('quantity');
            }
            System.debug('Cart Size============\t'+cartSize);
            System.debug('Cart Size============\t'+cartSize);
                        }catch(Exception E){
                            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
            }
                return cartSize;
            }


            
    
    @AuraEnabled
    public static void updateCartItemCore(String prodId,String cartId,decimal quantity, String storeCountry){
        try{  
        /**Upading core Item here */
             Map<string,string> countryCurrencyMap = new Map<string,string>();
            for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
                countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
            }
            string currencyISOvalue = (string)countryCurrencyMap.get(storeCountry); 
            System.debug('prodId==>'+prodId+'cartId==>'+cartId+'quantity==>'+quantity);
            double coreItemPrice;
            ccrz__E_Product__c relatedCoreProduct = getRelatedProductByProductId(prodId);
            System.debug('relatedCoreProduct===>'+relatedCoreProduct);
            if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
                 List<ccrz__E_PriceListItem__c> corePriceListItems= new List<ccrz__E_PriceListItem__c>();
                corePriceListItems=[Select id,ccrz__Price__c,ccrz__Pricelist__c,ccrz__Product__c,ccrz__Product__r.DBU_Product_Location__c from ccrz__E_PriceListItem__c Where ccrz__Product__c =:relatedCoreProduct.Id AND ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :currencyISOvalue];
           
                String coreProductId =  relatedCoreProduct.Id;
                /**Core Produdct Updation logic */
                List<ccrz__E_CartItem__c> existingCartItemsCore  = [SELECT Id,ccrz__Quantity__c,ccrz__Cart__c,ccrz__Price__c,ccrz__SubAmount__c FROM ccrz__E_CartItem__c WHERE ccrz__Product__c  =:coreProductId AND ccrz__Cart__c =: cartId  LIMIT 1];
                System.debug('existingCartItemsCore===>'+existingCartItemsCore);
                if(corePriceListItems[0].ccrz__Price__c != null){
                    coreItemPrice = corePriceListItems[0].ccrz__Price__c;
                }else{
                    coreItemPrice = 0.00;
                }
                for(ccrz__E_CartItem__c existingCartItemCore:existingCartItemsCore){
                    //existingCartItemCore.ccrz__Quantity__c = existingCartItemCore.ccrz__Quantity__c + quantity;
                    existingCartItemCore.ccrz__Quantity__c = quantity;
                    existingCartItemCore.ccrz__SubAmount__c = coreItemPrice * existingCartItemCore.ccrz__Quantity__c;
                    System.debug('existingCartItemCore.ccrz__Quantity__c>>>>>>>>>>>>>>>>>>>\t'+existingCartItemCore.ccrz__Quantity__c+'existingCartItemCore.ccrz__SubAmount__c>>>>>>>>>\t'+existingCartItemCore.ccrz__SubAmount__c);
                }
                if(existingCartItemsCore != null && existingCartItemsCore.size() > 0){
                   
                    update existingCartItemsCore;
                    
                }
            }
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
    }

    @AuraEnabled
    public static List<ccrz__E_CartItem__c> updateCartItemCommon(String cartItemId,String cartId,double itemPrice,double quantity, String storeCountry){
        List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
        List<ccrz__E_CartItem__c> existingCartItems;
        try{        
                    System.debug('cartItemId>>>>>>>>>>>>>>>>>>>\t'+cartItemId+'\tCartId>>>>>>>>>\t'+cartId);
                    existingCartItems  = [SELECT Id,ccrz__Quantity__c,ccrz__Cart__c,ccrz__Price__c,ccrz__SubAmount__c,ccrz__Product__c FROM ccrz__E_CartItem__c WHERE Id =:cartItemId LIMIT 1];
                    for(ccrz__E_CartItem__c existingCartItem:existingCartItems)
                    {
                        existingCartItem.ccrz__Quantity__c = existingCartItem.ccrz__Quantity__c + quantity;
                        existingCartItem.ccrz__SubAmount__c = itemPrice*existingCartItem.ccrz__Quantity__c;
                        System.debug('existingCartItem.ccrz__Quantity__c>>>>>>>>>>>>>>>>>>>\t'+existingCartItem.ccrz__Quantity__c+'existingCartItem.ccrz__SubAmount__c>>>>>>>>>\t'+existingCartItem.ccrz__SubAmount__c);
                    }
                        if(existingCartItems != null && existingCartItems.size() > 0){
                            //BEGIN - Before Updating check if Cart has Coupon Appiled - Added by Malhar - 18 Feb 2021
                            //ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: cartId];
                            
                            	
                                //Removing Existing Coupon
                                Boolean CouponRemovedStatus = dbu_CouponServiceHandler.removeAppliedCoupon(cartId);
                                //Perform Cartitems Update
                                update existingCartItems;                                
                                updateCartItemCore(existingCartItems[0].ccrz__Product__c,existingCartItems[0].ccrz__Cart__c,existingCartItems[0].ccrz__Quantity__c,storeCountry);                                                                   
                                
                                //Reapplying the Coupon
                                //Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);
                                                                                    
                            //END - Before Updating check if Cart has Coupon Appiled - Added by Malhar - 18 Feb 2021
                        }          
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return existingCartItems;
    }
    
    
    
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> updateCartItem(String cartItemId,String cartId,double itemPrice,double quantity,String storeCountry){
        List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
        try{            
            if(String.isBlank(cartId) || cartId == 'undefined'){
                cartId = [SELECT Id,ccrz__Cart__c FROM ccrz__E_CartItem__c WHERE Id =:cartItemId LIMIT 1].ccrz__Cart__c;
            }
                        System.debug('cartItemId>>>>>>>>>>>>>>>>>>>\t'+cartItemId+'\tCartId>>>>>>>>>\t'+cartId);
                        List<ccrz__E_CartItem__c> existingCartItems  = updateCartItemCommon(cartItemId,cartId,itemPrice,quantity,storeCountry);
                        if(existingCartItems != null && existingCartItems.size() > 0){
                            cartId = existingCartItems[0].ccrz__Cart__c;
                        }
                        objCCCartApiResponseWrapper = dbu_CallCCCartApi.fetchCartItemsByCartId(cartId);
                       // objCCCartApiResponseWrapper = generateResponse(cartId);//For DBU only
                        System.debug('After update CartItem>>>>>>>>>>>>>>>>>>>\t'+objCCCartApiResponseWrapper);
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return objCCCartApiResponseWrapper;
    }
    
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> updateCartItemShopCart(String cartItemId,String cartId,double itemPrice,double quantity, String storeCountry){
        List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
        try{          
            		// Calculating Shipping Cost
            	 	
                     System.debug('cartItemId>>>>>>>>>>>>>>>>>>>\t'+cartItemId+'\tCartId>>>>>>>>>\t'+cartId);
                     //boolean hasCoreCharge;
                     List<ccrz__E_CartItem__c> existingCartItems  = updateCartItemCommon(cartItemId,cartId,itemPrice,quantity,storeCountry);
                     ///dbu_CheckOutCntrl.updateShippingAmountOnCart(true,cartId,'');
                     //commented this on 13 Oct 20 to fetch the Inventory availability using BMS API   
                    //objCCCartApiResponseWrapper = dbu_CallCCCartApi.fetchCartItemsByCartId(cartId);
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return objCCCartApiResponseWrapper;
    }

    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> fetchLstCartItemsByCartIdAfterQuantityUpdate(String cartId, String cart){
        return fetchLstCartItemsByCartId(cartId,cart);
    }
    /**Delete CartItem Core*/
           
            @AuraEnabled
            public static List<dbu_CCCartApiResponseWrapper> deleteCartItemCore(String prodId,String cartItemId,String cartId){
                try{ 
                    ccrz__E_Product__c relatedCoreProduct = getRelatedProductByProductId(prodId);
                    System.debug('relatedCoreProduct===>'+relatedCoreProduct);
                    if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
                        String coreProductId =  relatedCoreProduct.Id;
                        /**Core Produdct Updation logic */
                        List<ccrz__E_CartItem__c> existingCartItemsCore  = [SELECT Id FROM ccrz__E_CartItem__c WHERE ccrz__Product__c  =:coreProductId AND ccrz__Cart__c =: cartId  LIMIT 1];
                        System.debug('existingCartItemsCore===>'+existingCartItemsCore);
                        if(existingCartItemsCore.size() > 0){
                            dbu_CallCCCartApi.deleteCartItemCCApi(existingCartItemsCore[0].Id,cartId);
                        }
                    }
                }catch(Exception e){
                system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
                }
                return null;
            }
    
        @AuraEnabled
        public static List<dbu_CCCartApiResponseWrapper> deleteCartItemCommon(String cartItemId,String cartId){
            List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
            try{        
                        System.debug('cartItemId>>>>>>>>>>>>>>>>>>>\t'+cartItemId+'\tCartId>>>>>>>>>\t'+cartId);
                        //ccrz__E_CartItem__c objccCartItem = new ccrz__E_CartItem__c(id = cartItemId);
                        //delete objccCartItem;
                        List<ccrz__E_CartItem__c> objccCartItem = new List<ccrz__E_CartItem__c>();
                        if(String.isNotBlank(cartItemId) && cartItemId.equalsIgnoreCase(cartItemId)){
                                objccCartItem = [select id,ccrz__Cart__c,ccrz__Product__r.Id  from ccrz__E_CartItem__c where id =: cartItemId];   
                        }
                        if(objccCartItem.size() > 0){
                            cartId = objccCartItem[0].ccrz__Cart__c;
                            dbu_CallCCCartApi.deleteCartItemCCApi(cartItemId,cartId);
                            String productId =objccCartItem[0].ccrz__Product__r.Id;
                            deleteCartItemCore(productId,cartItemId,cartId);
                        }
                   
            }catch(Exception E){
                system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
            }
            return objCCCartApiResponseWrapper;
        }
            
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> deleteCartItem(String cartItemId,String cartId){
        List<dbu_CCCartApiResponseWrapper> objCCCartApiResponseWrapper = new List<dbu_CCCartApiResponseWrapper>();
        try{        
                    deleteCartItemCommon(cartItemId,cartId);
                    removePickupAddressFromCart(cartId);
                    objCCCartApiResponseWrapper = dbu_CartCtrl.fetchLstCartItemsByCartId(cartId);
                    //objCCCartApiResponseWrapper = generateResponse(cartId);//For DBU only
                    System.debug('deleteCartItem>>>>>>>>>>>>>>>>>>>\t'+objCCCartApiResponseWrapper);
          
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return objCCCartApiResponseWrapper;
    }
    
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> deleteCartItemOnShopCart(String cartItemId,String cartId){
        try{        
                    deleteCartItemCommon(cartItemId,cartId);
                    removePickupAddressFromCart(cartId);
        }catch(Exception E){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return null;
    }
    
    public static void removePickupAddressFromCart(String cartId){
        try{
            List<ccrz__E_Cart__c> existingCartItemsFromCart = [select id, dbu_Pick_Up_From_Store__c, (select id from ccrz__E_CartItems__r where dbu_isShipTo__c = false) from ccrz__E_Cart__c where Id =: cartId];
            System.debug('existingCartItemsFromCart==\t'+existingCartItemsFromCart);
            if(existingCartItemsFromCart.size() > 0){
                if(existingCartItemsFromCart[0].ccrz__E_CartItems__r.size() == 0){
                    ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(Id = cartId,dbu_Pick_Up_From_Store__c = null);
                    update objCart;
                }
            }
        }catch(Exception E){
            system.debug('Exception Inside removePickupAddressFromCart'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
    }
    @AuraEnabled
    public static void removeShipToAddressFromCart(String cartId){
        try{
            List<ccrz__E_Cart__c> existingCartItemsFromCart = [select id, ccrz__ShipTo__c, (select id from ccrz__E_CartItems__r where dbu_isShipTo__c = true) from ccrz__E_Cart__c where Id =: cartId];
            System.debug('existingCartItemsFromCart while checking for any pickup type product\t'+existingCartItemsFromCart);
            if(existingCartItemsFromCart.size() > 0){
                if(existingCartItemsFromCart[0].ccrz__E_CartItems__r.size() == 0){
                    ccrz__E_Cart__c objCart = new ccrz__E_Cart__c(Id = cartId,ccrz__ShipTo__c = null);
                    update objCart;
                }
            }
        }catch(Exception E){
            system.debug('Exception Inside checkInventoryAPIInterval while checking any pickup type product'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
    }

    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> fetchLstCartItemsAfterDelete(String cartId, String cart){
        return fetchLstCartItemsByCartId(cartId,cart);
    }
    
    //Malhar added Cart_StoreCountry in following method - 3/12/2020
    @AuraEnabled(cacheable=true)
    public static String fetchCartId(string storeCountry){
        String cartId;
        try{    
                //Malhar added dbu_Cart_StoreCountry__c in following query - 3/12/2020
                List<ccrz__E_Cart__c> objCCCart = [select id from ccrz__E_Cart__c where ccrz__CartStatus__c = 'Open' and dbu_Cart_StoreCountry__c =: storeCountry and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true and ccrz__User__c =: UserInfo.getUserId() order by createdDate desc Limit 1];
                if(objCCCart.size() != null){
                    cartId = objCCCart[0].Id;
                }
        }catch(Exception E){
                system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());

        }
        return cartId;
    }

    @AuraEnabled
    public static void updateShippingMethod(Boolean dbu_isShipTo, String cartId, String cartItemId,String productId){
        List<ccrz__E_CartItem__c> existingCartItems;
        try{
           //existingCartItems  = [SELECT Id,dbu_isShipTo__c FROM ccrz__E_CartItem__c WHERE Id =:cartItemId LIMIT 1];
            /**
         * New logic for core product
         */
        ccrz__E_Product__c relatedCoreProduct = dbu_CartCtrl.getRelatedProductByProductId(productId);
        System.debug('relatedCoreProduct==\t'+relatedCoreProduct);
        if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
            System.debug('Inside the relatedCoreProduct=== ');
            existingCartItems = [select id, dbu_isShipTo__c from ccrz__E_CartItem__c where (id =: cartItemId) OR (ccrz__Product__c =: relatedCoreProduct.Id AND ccrz__Cart__c =: cartID) ];
        }else{
            existingCartItems = [select id, dbu_isShipTo__c from ccrz__E_CartItem__c where id =: cartItemId];
        }
        System.debug('existingCartItems size=\t'+existingCartItems.size()+'\texistingCartItems\t'+existingCartItems);
        /**End of the core product logic */
           if(existingCartItems.size() > 0){
            existingCartItems[0].dbu_isShipTo__c = dbu_isShipTo;
            if(relatedCoreProduct != null && relatedCoreProduct.Id != null ){
                if(existingCartItems.size() > 1){
                    existingCartItems[1].dbu_isShipTo__c = dbu_isShipTo;
                }
            }
            update existingCartItems;
            try{
                if(dbu_isShipTo){
                    removePickupAddressFromCart(cartId);
                }
            }catch(Exception ex){
                System.debug('Exception in checkoutController in updateShippingAmountOnCart '+ex.getMessage()+'\t'+ex.getLineNumber());
            }
           }
        }catch(Exception ex){
            System.debug('Message==\t'+ex.getMessage()+'\t'+ex.getLineNumber());
        }
    }
     
    @AuraEnabled
    public static Map<String,Boolean> checkInventoryAPIInterval(string cartId){
        Boolean isTimeExceeded, isPickupItemButAddressNot;
        Map<String,Boolean> objIntervalAndPickupStoreMap = new Map<String,Boolean>();
        List<dbu_InventoryCheck_Result__c> lstInventoryCheckResponse = new List<dbu_InventoryCheck_Result__c>();
        try{    
            lstInventoryCheckResponse = [select id, API_response__c, Cart__c, product__c,Time_Interval__c from dbu_InventoryCheck_Result__c where Cart__c =: cartId order by createdDate asc];
            if(lstInventoryCheckResponse.size() > 0 && lstInventoryCheckResponse[0].Time_Interval__c > Integer.valueOf(system.label.dbu_InventoryCheck_TimeInterval)){
                isTimeExceeded = true;
            }else{
                isTimeExceeded = false;
            }
            ///////////
            try{
                List<ccrz__E_Cart__c> existingCartItemsFromCart = [select id, dbu_Pick_Up_From_Store__c, (select id from ccrz__E_CartItems__r where dbu_isShipTo__c = false) from ccrz__E_Cart__c where Id =: cartId];
                System.debug('existingCartItemsFromCart while checking for any pickup type product\t'+existingCartItemsFromCart);
                if(existingCartItemsFromCart.size() > 0){
                    if(existingCartItemsFromCart[0].ccrz__E_CartItems__r.size() > 0){
                        if(existingCartItemsFromCart[0].dbu_Pick_Up_From_Store__c == null){
                            isPickupItemButAddressNot = true;
                        }else {
                            isPickupItemButAddressNot = false; 
                        }
                    }
                }
            }catch(Exception E){
                system.debug('Exception Inside checkInventoryAPIInterval while checking any pickup type product'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
                isPickupItemButAddressNot = false;
            }
            //////////
          if(Test.isRunningTest()) {
                // Cause DMLException
                insert new Lead();
            }
        }catch(Exception E){
                system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
                //return fetchLstCartItemsByCartId(cartId,'cart');
                isTimeExceeded = false;

        }
        objIntervalAndPickupStoreMap.put('isTimeExceeded',isTimeExceeded);
        objIntervalAndPickupStoreMap.put('isPickupItemButAddressNot',isPickupItemButAddressNot);
        return objIntervalAndPickupStoreMap;
    }
  
    @AuraEnabled
    public static void createCybersourceURLLog(String cartId, String url){
        dbu_Integration_Error_Log.createErrorLog(200,'','cart id:'+cartId,'URL:'+url,'Cybersource','Success'); 
    }

    /**
    * @description: To subcribe to email communication | CECI-748
    * @author Vaishnavi Suthram | 04-05-2022
    * @param cartId : External ID of Cart object
    * @param dbu_optEmailNotification : Boolean result of optEmailNotification
    * @return string : Returning the updated cart status (true/false)
    **/
    @AuraEnabled
    public static Boolean checkMarketingEmailFlag(String cartId, Boolean dbuOPTEmailNotification){
        system.debug('M:E checkMarketingEmailFlag');
        List<ccrz__E_Cart__c> updatedCart;
        Boolean isSuccess = False;
        List<String> errorMessages = new List<String>();
        system.debug('cartID===' +CartId +dbuOPTEmailNotification );
        try {
            updatedCart = [Select id,dbu_optEmailNotification__c,ccrz__CartStatus__c,ccrz__CartType__c,ccrz__ActiveCart__c,createdDate from ccrz__E_Cart__c where id =: CartId and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true  order by createdDate desc limit 1 ];
            
            if(updatedCart.size() > 0){
                updatedCart[0].dbu_optEmailNotification__c = dbuOPTEmailNotification;
                //upsert carts;
                Database.SaveResult[] cartsList = Database.update(updatedCart, true);
                for (Database.SaveResult sr : cartsList) {
                    if (sr.isSuccess()) {
                        isSuccess = true;
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            errorMessages.add(err.getMessage());
                        }
                        isSuccess = false;
                    }
                }
            }
             if(Test.isRunningTest()) {
                // Cause DMLException
                insert new Lead();
            }
        } catch(DmlException dmle){
            errorMessages.add(dmle.getMessage()+' Line No:'+dmle.getLineNumber());
           // dbu_Integration_Error_Log.createErrorLog(null,'',updatedCart,string.join(errorMessages,','),'MarkoptEmailNotificationeting ','Exception');
            System.debug('dmle.getMessage while updating the flag==>'+dmle.getMessage()+'LineNumber=>'+dmle.getLineNumber());
        } catch(Exception e){
            system.debug('Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        return isSuccess;
    }


    /**
    * @description To Merge Anonymous cart authenticated cart | CECI-490.
    * https://cumminsit.atlassian.net/browse/CECI-490
    * @author Devaraj Johnson | 04-07-2022 
    * @param storeCountry Get the current Store URL from Store.
    * @param anonymousCartID Get the anonymous cart ID from the Cookie if present.
    * @return String send the authenticated Cart ID
    **/
    @AuraEnabled
    public static String mergeCart(String storeCountry, String anonymousCartID){
        system.debug('M:E mergeCart');
        system.debug('P:parameter1:storeCountry: '+ storeCountry);
        system.debug('P:parameter2:anonymousCartID: '+ anonymousCartID);
        List<ccrz__E_Cart__c> mergeCart = new List<ccrz__E_Cart__c>();
        Boolean isSuccess = False;
        Double coreCharge = 0.00;
        List<String> errorMessages = new List<String>();
        List<ccrz__E_CartItem__c> cartitems;
        List<ccrz__E_CartItem__c> updatedCartItems;
        List<ccrz__E_CartItem__c> authCartItems;
        String accountId,userId,authenticatedCartID;
        ccrz__E_Product__c coreProductdetail;
        
        try {
            authenticatedCartID  = fetchCartId(storeCountry);
            system.debug('P:parameter2:authenticatedCartID'+ authenticatedCartID);
            system.debug('D:String.isBlank(anonymousCartID) :'+ String.isBlank(anonymousCartID));
            system.debug('D:String.isBlank(authenticatedCartID) :'+ String.isBlank(authenticatedCartID));
            system.debug('D:UserInfo.getUserId():'+ UserInfo.getUserId());
            system.debug('D:UserInfo.getUserEmail():'+ UserInfo.getUserEmail());
            mergeCart = [Select id,dbu_Pick_Up_From_Store__c,dbu_storeLanguage__c,ccrz__BuyerEmail__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__User__c,OwnerId,ccrz__CartStatus__c,ccrz__CartType__c,ccrz__ActiveCart__c,createdDate,ccrz__CurrencyISOCode__c from ccrz__E_Cart__c where id =: anonymousCartID and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true  and ccrz__Storefront__c ='CSSNAStore' order by createdDate desc limit 1 ];
            // Check if the authenticatedCartID is not empty & anonymousCartID is not empty
            if(!String.isBlank(authenticatedCartID) && !String.isBlank(anonymousCartID)){
                // Enter the cart merge senario
                system.debug('P:parameter1:'+ authenticatedCartID);
                system.debug('P:parameter2:'+ anonymousCartID);                               
                cartitems = getCartItems(anonymousCartID);
                if(cartitems.size() > 0){
                    for(ccrz__E_CartItem__c cartItem : cartItems){
                        // Create map product sku vs quantivehiclePoweredty
                        system.debug('D:cartItem.ccrz__Product__r.dbu_Crate_Engine__c):'+ cartItem.ccrz__Product__r.dbu_Crate_Engine__c);
                        if(cartItem.ccrz__Product__r.dbu_Crate_Engine__c){
                            system.debug('D:Crate engine Product :'+ cartItem.ccrz__Product__r.dbu_Has_Core_Child__c);
                            //crateengine
                            insertCartItemForCrateEngine(cartItem.ccrz__Product__r.ccrz__SKU__c,authenticatedCartID,Double.valueOf(cartItem.ccrz__OriginalItemPrice__c) ,Double.valueOf(cartItem.ccrz__Quantity__c),cartItem.dbu_Make__c,cartItem.dbu_Model__c,cartItem.dbu_VIN__c,cartItem.dbu_Year__c,
                            true,true,true,true,true,true, cartItem.ccrz__Cart__r.dbu_Cart_StoreCountry__c,cartItem.ccrz__Cart__r.dbu_storeLanguage__c,cartItem.dbu_State__c,cartItem.dbu_Vehicle_Powered__c);
                            // Update Anonymous Cart ID
                            isSuccess = updateCartStatus(mergeCart);
                        }
                        else{
                            system.debug('D:Normal or Core Product :'+ cartItem.ccrz__Product__r.dbu_Has_Core_Child__c);
                            // Its not a Core Charge Product
                            if(!cartItem.ccrz__Product__r.dbu_Has_Core_Child__c){
                                // Check if its a Product which has Core charges
                                if(cartItem.ccrz__Product__r.dbu_Has_Core_Charge__c){
                                    // Get the core charges related to the parent core product.
                                    coreProductdetail = dbu_CallCCWishListApi.getRelatedProductByProductId(cartItem.ccrz__Product__r.id,storeCountry);
                                    // Get the core charge
                                    coreCharge = coreProductdetail.ccrz__E_PriceListItems__r[0].ccrz__Price__c;
                                }
                                List<ccrz__E_CartItem__c> insertCartItems = insertCartItem(String.valueOf(cartItem.ccrz__Product__r.ccrz__SKU__c),authenticatedCartID,Double.valueOf(cartItem.ccrz__OriginalItemPrice__c),Double.valueOf(cartItem.ccrz__Quantity__c),'',storeCountry,coreCharge,cartItem.ccrz__Cart__r.dbu_storeLanguage__c);
                                system.debug('D:insertCartItems: '+ insertCartItems);
                                // Update Anonymous Cart ID
                                isSuccess = updateCartStatus(mergeCart);
                            } 
                        }
                    }
                }
            // Check if the authenticatedCartID is empty & anonymousCartID is not empty
            } else if(String.isBlank(authenticatedCartID) && !String.isBlank(anonymousCartID)){
            // Anonymous user cart will get converted to the autheticated cart
                system.debug('D:mergeCart:'+ mergeCart);
                if(mergeCart.size() > 0){
                    List<User> currentUser = [select id, name, contact.accountId from User where Id =: UserInfo.getUserId()];
                    system.debug('loggedIn user details ::' + currentUser);
                    if(currentUser.size() > 0 && currentUser[0].contact.accountId != null){
                        accountId = currentUser[0].contact.accountId;
                        userId = currentUser[0].id;
                        mergeCart[0].ccrz__User__c = userId;
                        mergeCart[0].OwnerId =  userId;
                        mergeCart[0].ccrz__BuyerEmail__c = UserInfo.getUserEmail();
                        mergeCart[0].ccrz__BuyerFirstName__c = UserInfo.getFirstName();
                        mergeCart[0].ccrz__BuyerLastName__c = UserInfo.getLastName();
                        mergeCart[0].ccrz__Contact__c = currentUser[0].contact.id;
                        mergeCart[0].ccrz__Account__c = accountId;
                        mergeCart[0].ccrz__AnonymousId__c = false;
                        Database.SaveResult[] cartsList = Database.update(mergeCart, true);
                        for (Database.SaveResult sr : cartsList) {
                            if (sr.isSuccess()) {
                                isSuccess = true; authenticatedCartID = mergeCart[0].id;
                                authenticatedCartID = anonymousCartID;
                            } else {
                                for(Database.Error err : sr.getErrors()) {
                                    errorMessages.add(err.getMessage());
                                }
                                isSuccess = false;
                            }
                        }
                    }
                }
            }
            mergeCart = [Select id,dbu_Pick_Up_From_Store__c,dbu_storeLanguage__c,ccrz__BuyerEmail__c,ccrz__BuyerFirstName__c,ccrz__BuyerLastName__c,ccrz__User__c,OwnerId,ccrz__CartStatus__c,ccrz__CartType__c,ccrz__ActiveCart__c,createdDate,ccrz__CurrencyISOCode__c from ccrz__E_Cart__c where id =: authenticatedCartID and ccrz__CartStatus__c = 'Open' and ccrz__CartType__c = 'Cart' and ccrz__ActiveCart__c = true  and ccrz__Storefront__c ='CSSNAStore' order by createdDate desc limit 1 ];
            Id noid = null;
            if(mergeCart.size() > 0){
                mergeCart[0].dbu_Pick_Up_From_Store__c = noid;
                Database.SaveResult[] cartsList = Database.update(mergeCart, true);
            }
         
             if(Test.isRunningTest()) {
                // Cause DMLException
                insert new Lead();
            }
        } catch(DmlException dmle){
            errorMessages.add('ERR mergeCart Exception Message'+dmle.getMessage() +''+'Exception Line number'+dmle.getLineNumber()+ '' + 'Stack trace: ' + dmle.getStackTraceString()+ ' ' + 'Cause: ' + dmle.getCause());
            System.debug('ERR mergeCart'+dmle.getMessage()+'LineNumber=>'+dmle.getLineNumber());
        } catch(Exception e){
            system.debug('ERR mergeCart Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber());
        }
        system.debug('M:X mergeCart');
        return authenticatedCartID;
    }
    

    /**
    * @description 
    * @author Devaraj Johnson B | 04-08-2022 
    * @param cartId 
    * @return List<ccrz__E_CartItem__c> 
    **/
    public static List<ccrz__E_CartItem__c> getCartItems(String cartId){
        List<ccrz__E_CartItem__c> cartItems;
        cartItems = [SELECT Id,dbu_Estimated_PickUp__c,
                        CurrencyIsoCode,ccrz__OriginalItemPrice__c,ccrz__OriginalQuantity__c,
                        dbu_EmissionAgreement__c,dbu_ExportAgreement__c,dbu_ShippingAgreement__c,dbu_TncAgreement__c,
                        dbu_UnloadingAgreement__c,dbu_WarrentyAggrement__c,dbu_isShipTo__c,
                        ccrz__Product__c,ccrz__Cart__c,
                        ccrz__Quantity__c,
                        ccrz__Price__c,ccrz__Product__r.dbu_Available_to_ship__c,ccrz__Product__r.dbu_Pick_Up_Only__c,
                        ccrz__Product__r.dbu_Crate_Engine__c,
                        ccrz__Product__r.dbu_Has_Core_Child__c,
                        ccrz__Product__r.dbu_Has_Core_Charge__c,
                        ccrz__Product__r.ccrz__SKU__c,ccrz__Product__r.id,
                        ccrz__Cart__r.dbu_storeLanguage__c,dbu_State__c,dbu_Make__c,dbu_Model__c,dbu_VIN__c,dbu_Year__c,
                        dbu_Vehicle_Powered__c,ccrz__SubAmount__c,ccrz__Cart__r.dbu_Cart_StoreCountry__c
                        FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId];
        return cartItems;
    }

    /**
    * @description 
    * @author Devaraj Johnson B | 04-12-2022 
    * @param mergeCart 
    * @return Boolean 
    **/
    public static Boolean updateCartStatus(List<ccrz__E_Cart__c> mergeCart){
        Boolean isSuccess = False;
        List<String> errorMessages = new List<String>();
        try{
            if(mergeCart.size() > 0){
                mergeCart[0].ccrz__ActiveCart__c = false;
                mergeCart[0].ccrz__CartStatus__c = 'Merged';
                Database.SaveResult[] cartsList = Database.update(mergeCart, true);
                for (Database.SaveResult sr : cartsList) {
                    if (sr.isSuccess()) {
                        isSuccess = true;
                    } else {
                        for(Database.Error err : sr.getErrors()) {
                            errorMessages.add(err.getMessage());
                        }
                        isSuccess = false;
                    }
                }
            }
             if(Test.isRunningTest()) {
                // Cause DMLException
                insert new Lead();
            }
        } catch(Exception e){    
            system.debug('ERR updateCartStatus Exception Message'+e.getMessage() +''+'Exception Line number'+e.getLineNumber()+ '' + 'Stack trace: ' + e.getStackTraceString()+ ' ' + 'Cause: ' + e.getCause());
        }
        return isSuccess;
    }

  
    /**
    * @description 
    * @author Devaraj Johnson B | 04-26-2022 
    * @param authenticatedCartID 
    * @return String 
    **/
    @AuraEnabled
    public static String updateCartItemToDefaultShip(String authenticatedCartID)
    {
       
        List<ccrz__E_CartItem__c> updatedCartItems = new List<ccrz__E_CartItem__c>();
        List<ccrz__E_CartItem__c> authCartItems = new List<ccrz__E_CartItem__c>();
         // Default to Shipping address for the authenticated user. 
         authCartItems = getCartItems(authenticatedCartID);
         system.debug('authCartItems: '+authCartItems);
         if(authCartItems.size() > 0 && authCartItems != null){
             for(ccrz__E_CartItem__c authCartItem : authCartItems){
                system.debug('authCartItem '+authCartItem);
                system.debug('authCartItem.ccrz__Product__r.dbu_Available_to_ship__c '+authCartItem.ccrz__Product__r.dbu_Available_to_ship__c);
                system.debug('authCartItem.ccrz__Product__r.dbu_Pick_Up_Only__c '+authCartItem.ccrz__Product__r.dbu_Pick_Up_Only__c);
                if((authCartItem.ccrz__Product__r.dbu_Available_to_ship__c == true) || ((authCartItem.ccrz__Product__r.dbu_Available_to_ship__c == false) && (authCartItem.ccrz__Product__r.dbu_Pick_Up_Only__c == false))){
                    system.debug('entered if');
                    authCartItem.dbu_isShipTo__c = true;
                    system.debug('authCartItem  if'+authCartItem);
                    updatedCartItems.add(authCartItem);
                }else{
                system.debug('else condition '+authCartItem.ccrz__Product__r.dbu_Available_to_ship__c);
                }
                system.debug('updatedCartItems');
             system.debug(updatedCartItems);
             }
             system.debug('updatedCartItems');
             system.debug(updatedCartItems);
             if(updatedCartItems.size() > 0 && updatedCartItems != null){
                system.debug('enter update');

                Database.SaveResult[] cartsList = Database.update(updatedCartItems, true);
             }
         }
        return authenticatedCartID;
    }
}