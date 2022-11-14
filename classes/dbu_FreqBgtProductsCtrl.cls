public without sharing class dbu_FreqBgtProductsCtrl {
	
    public static String createCart(string StoreCountry, string StoreLanguage){
        
        String CartId = dbu_CallCCCartApi.createCart(storeCountry, storeLanguage);
        system.debug('dbu_FreqBgtProductsCtrl cart id created > ' + CartId);
        
        return CartId; 
    } 
    
    @AuraEnabled
    public static Map<string,object> insertOrUpdateMultipleCartitemsInFreqBgtProds(string ProductIdList, string CartId, string storeCountry, string storeLanguage){
        Map<string,object> retrunResponse = new Map<string,object>();
        try{
        system.debug('ENTERING IN insertOrUpdateMultipleCartitemsInFreqBgtProds > ');
        list<ccrz__E_CartItem__c> CartItemListToUpsert = new list<ccrz__E_CartItem__c>();
        //convert serialized to deserialized format
        list<object> ProductIDS = (list<object>)JSON.deserializeUntyped(ProductIdList);
        system.debug('ProductIDSet :: ' + ProductIDS);
         
        set<string> ProductIDSet= new set<string>();
        for(object o : ProductIDS){
            ProductIDSet.add(string.valueOf(o));
        } 
        
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
            if(Test.isRunningTest()){
                countryCurrencyMap.put('US','USD');
            }
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(storeCountry);        
        
		        
        //filter out crate engine and Core products.
        list<ccrz__E_Product__c> FilteredProductData = new list<ccrz__E_Product__c>();
        Map<string,double> productInventorymapping = new Map<string,double>();
        if(ProductIDSet.size() > 0){
            FilteredProductData = [select id,
                                   dbu_Available_to_ship__c,
                                   dbu_Pick_Up_Only__c,
                                   (select id,ccrz__Price__c from ccrz__E_PriceListItems__r Where ccrz__Pricelist__r.ccrz__CurrencyISOCode__c = :CurrencyISOcodeValue)	                                  
                                   from ccrz__E_Product__c 
                                   where dbu_Has_Core_Child__c = false 
                                   and dbu_Has_Core_Charge__c = false 
                                   and dbu_Crate_Engine__c = false 
                                   and DBU_Product_Location__c INCLUDES (:storeCountry) 
                                   and ccrz__Storefront__c = 'CSSNAStore'
                                   and id in : ProductIDSet];            
			
            //CHECK FOR INVENTORY        
            list<AggregateResult> productInventory = new list<AggregateResult>();
            productInventory = [select SUM(ccrz__QtyAvailable__c) TOTALQUANTITY, ccrz__ProductItem__c PRODUCTID
                                from ccrz__E_ProductInventoryItem__c 
                                where ccrz__ProductItem__c IN : ProductIDSet 
                                and CurrencyIsoCode =: CurrencyISOcodeValue 
                                and ccrz__ProductItem__c != null
                                GROUP BY ccrz__ProductItem__c];                           
            system.debug(productInventory);            
        
            if(productInventory.size() > 0){
                for(AggregateResult pi : productInventory){            
                    productInventorymapping.put((string)pi.get('PRODUCTID'),(double)pi.get('TOTALQUANTITY'));
                    system.debug('productInventorymapping > ' + productInventorymapping);
                }                 
            }                         
        }
        

        system.debug('productInventorymapping > ' + productInventorymapping);
        system.debug('productInventorymapping size > ' + productInventorymapping.size());         
        system.debug('FilteredProductData > ' + FilteredProductData );
		
        Map<string,boolean> deliveryMethodMap = new Map<string,boolean>();
        list<string> RefinedProductIDlist = new list<string>();  
        Map<string,double> ProductPricingMap = new Map<string,double>();            
            
            if(FilteredProductData.size() > 0){
                for(ccrz__E_Product__c eachProduct : FilteredProductData){
                    boolean shipboolean = false;
                    boolean shiponly = false;
                    boolean pickuponly = false; 
                    
                    if(eachProduct.dbu_Available_to_ship__c){
                        shiponly = true;
                    } 
                    if(eachProduct.dbu_Pick_Up_Only__c){
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
                    
                    deliveryMethodMap.put(eachProduct.id, shipboolean);
                    if((eachProduct.ccrz__E_PriceListItems__r).size() > 0){
                        if(eachProduct.ccrz__E_PriceListItems__r[0].ccrz__Price__c != null){
                            ProductPricingMap.put((string)eachProduct.id,eachProduct.ccrz__E_PriceListItems__r[0].ccrz__Price__c);    
                            RefinedProductIDlist.add((string)eachProduct.id);                        
                        }                    
                    }
                    
                }            
            }

        system.debug('ProductPricingMap > ' + ProductPricingMap);
		system.debug('RefinedProductIDlist > ' + RefinedProductIDlist);		
        
        //Check if cart is empty or not and check if any product already exists in the cart
        list<ccrz__E_CartItem__c> currenctCartData = new list<ccrz__E_CartItem__c>();      
        list<string> cartItemafterupdateorinsert = new list<string>();
        
        if(RefinedProductIDlist.size() > 0){
            
            //check if cartId is blank or not            
            if(CartId != ''){
            	system.debug('Cartid Not blank');
                currenctCartData = [select id,ccrz__Product__c,ccrz__Price__c,ccrz__Quantity__c,ccrz__SubAmount__c from ccrz__E_CartItem__c where ccrz__Cart__c =: CartId and ccrz__StoreID__c = 'CSSNAStore' and ccrz__Product__c in : RefinedProductIDlist];                    	
            }else{
                system.debug('Cartid blank');
                
                //Create Cart
                CartId = createCart(storeCountry, storeLanguage);                
            }
            
            list<string> ProductIncart = new list<string>();
            list<string> ProductsNotInCart = new List<string>();
            if(currenctCartData.size() > 0){
                //check if products exist in cart and if yes, then update the cartitem quantity and subamount
                for(ccrz__E_CartItem__c eachcartitem : currenctCartData){

                    //get product price
                    if(ProductPricingMap.get((string)eachcartitem.ccrz__Product__c)!= null){
                    	
                        ProductIncart.add((string)eachcartitem.ccrz__Product__c);
                    	RefinedProductIDlist.remove( RefinedProductIDlist.indexOf((string)eachcartitem.ccrz__Product__c) );                        
                        
                        eachcartitem.ccrz__Price__c = (double)ProductPricingMap.get((string)eachcartitem.ccrz__Product__c);
                        eachcartitem.ccrz__OriginalItemPrice__c = (double)ProductPricingMap.get((string)eachcartitem.ccrz__Product__c);
                        
                        //revise quantity
                        eachcartitem.ccrz__Quantity__c = eachcartitem.ccrz__Quantity__c + 1;
                        eachcartitem.ccrz__OriginalQuantity__c = eachcartitem.ccrz__Quantity__c + 1;
                        
                        //revise subamount
                        eachcartitem.ccrz__SubAmount__c = eachcartitem.ccrz__Price__c * eachcartitem.ccrz__Quantity__c;    
                        
                        boolean deliverymethodflag = false;
                        if(deliveryMethodMap.get(eachcartitem.ccrz__Product__c) != null){
                            deliverymethodflag = (boolean)deliveryMethodMap.get(eachcartitem.ccrz__Product__c);
                            eachcartitem.dbu_isShipTo__c = deliverymethodflag;
                        }
                        CartItemListToUpsert.add(eachcartitem);
                    }					
                }
                ProductsNotInCart.addall(RefinedProductIDlist);
            }else{
                //Perform Direct Insert of products in cart
                if(ProductsNotInCart.size() > 0){
                    for(string eachProduct : ProductsNotInCart){
                        //Check for Product Inventory
                        if(productInventorymapping.get(eachProduct) != null){
                            if(productInventorymapping.get(eachProduct) > 0){                                
                                if(ProductPricingMap.get(eachProduct)!= null){ 
                                boolean deliverymethodflag = false;
                                if(deliveryMethodMap.get(eachProduct) != null){
                                    deliverymethodflag = (boolean)deliveryMethodMap.get(eachProduct);
                                }                                    
                                    ccrz__E_CartItem__c NewCartIteminsert = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', 
                                                                                                    ccrz__UnitOfMeasure__c = 'Each', 
                                                                                                    ccrz__StoreID__c = 'CSSNAStore',
                                                                                                    ccrz__RequestDate__c = Date.today(),
                                                                                                    ccrz__OriginalItemPrice__c =  (double)ProductPricingMap.get(eachProduct) ,
                                                                                                    ccrz__OriginalQuantity__c = 1,
                                                                                                    ccrz__Cart__c = CartId,
                                                                                                    ccrz__Quantity__c= 1, 
                                                                                                    ccrz__Product__c = eachProduct, 
                                                                                                    ccrz__Price__c = (double)ProductPricingMap.get(eachProduct), 
                                                                                                    ccrz__SubAmount__c = (double)ProductPricingMap.get(eachProduct), 
                                                                                                    dbu_isShipTo__c = deliverymethodflag,
                                                                                                    CurrencyIsoCode =CurrencyISOcodeValue);   
                                    CartItemListToUpsert.add(NewCartIteminsert);                                    
                                }                                
                            }                            
                        }   
                    }                    
                }else if(ProductsNotInCart.size() == 0){
                    if(RefinedProductIDlist.size() > 0){
                        for(string eachProduct : RefinedProductIDlist){
                            if(productInventorymapping.get(eachProduct) != null){
                                if(productInventorymapping.get(eachProduct) > 0){                                
                                    if(ProductPricingMap.get(eachProduct)!= null){  
                                        boolean deliverymethodflag = false;
                                        if(deliveryMethodMap.get(eachProduct) != null){
                                            deliverymethodflag = (boolean)deliveryMethodMap.get(eachProduct);
                                        }                                        
                                        ccrz__E_CartItem__c NewCartIteminsert = new ccrz__E_CartItem__c(ccrz__ProductType__c = 'Product', 
                                                                                                        ccrz__UnitOfMeasure__c = 'Each', 
                                                                                                        ccrz__StoreID__c = 'CSSNAStore',
                                                                                                        ccrz__RequestDate__c = Date.today(),
                                                                                                        ccrz__OriginalItemPrice__c =  (double)ProductPricingMap.get(eachProduct) ,
                                                                                                        ccrz__OriginalQuantity__c = 1,
                                                                                                        ccrz__Cart__c = CartId,
                                                                                                        ccrz__Quantity__c= 1, 
                                                                                                        ccrz__Product__c = eachProduct, 
                                                                                                        ccrz__Price__c = (double)ProductPricingMap.get(eachProduct), 
                                                                                                        ccrz__SubAmount__c = (double)ProductPricingMap.get(eachProduct), 
                                                                                                        dbu_isShipTo__c = deliverymethodflag,
                                                                                                        CurrencyIsoCode =CurrencyISOcodeValue);   
                                        CartItemListToUpsert.add(NewCartIteminsert);                                    
                                    }                                
                                }                            
                            }                               
                        }
                    }
                }
            } 
            
            
            if(CartItemListToUpsert.size() > 0){
                try{
        			//check if coupon applied for cart            
                    ccrz__E_Cart__c currenctCart = [SELECT ID,(SELECT ID, ccrz__Coupon__r.ccrz__CouponCode__c FROM ccrz__E_CartCoupons__r) FROM ccrz__E_Cart__c WHERE ID =: cartId];
                    
                    if((currenctCart.ccrz__E_CartCoupons__r).size() > 0){
                        system.debug('coupon is applied');  
                        string CurrenctApliedCouponCode = (string)currenctCart.ccrz__E_CartCoupons__r[0].ccrz__Coupon__r.ccrz__CouponCode__c;
                        system.debug('CurrenctApliedCouponCode  > ' + CurrenctApliedCouponCode);   
                        
                        //Removing Existing Coupon
                        Boolean CouponRemovedStatus = dbu_CallCCCartApi.removeAppliedCoupon(cartId); 
                        
                        //perform cartitems Upsert
                        Database.UpsertResult [] srList = Database.upsert(CartItemListToUpsert, true);  
                        // Iterate through each returned result
                        for (Database.UpsertResult sr : srList) {
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Successfully inserted/update cartitem. cartitem ID: ' + sr.getId() );
                                cartItemafterupdateorinsert.add((string)sr.getId());
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Account fields that affected this error: ' + err.getFields());
                                }
                            }
                        }   
                        
                        //Reapplying the Coupon
                        Boolean CouponReapplyStatus = dbu_CallCCCartApi.reapplyCoupon(cartId,CurrenctApliedCouponCode);    

                    }else{
                        //perform cartitems Upsert
                        Database.UpsertResult [] srList = Database.upsert(CartItemListToUpsert, true);  
                        // Iterate through each returned result
                        for (Database.UpsertResult sr : srList) {
                            if (sr.isSuccess()) {
                                // Operation was successful, so get the ID of the record that was processed
                                System.debug('Successfully inserted/update cartitem. cartitem ID: ' + sr.getId() );
                                cartItemafterupdateorinsert.add((string)sr.getId());
                            }
                            else {
                                // Operation failed, so get all errors                
                                for(Database.Error err : sr.getErrors()) {
                                    System.debug('The following error has occurred.');                    
                                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                    System.debug('Account fields that affected this error: ' + err.getFields());
                                }
                            }
                        }   
                    }
                    

                        }catch(exception e){
							system.debug('error message > ' + e.getMessage());                            
                            system.debug('error cause > ' + e.getCause());
                            system.debug('error type > ' + e.getTypeName());
							system.debug('error at line number > ' + e.getLineNumber());                            
                            system.debug('error stack trace > ' + e.getStackTraceString());
                        }
                
            }
        }
  		
        list<string> ProductsInsertedorUpdated = new List<string>();
        list<string> ProductsNotInserted = new List<string>();        
        list<ccrz__E_CartItem__c> cartitemlst = new list<ccrz__E_CartItem__c>();
        if(cartItemafterupdateorinsert.size() > 0){
        	cartitemlst = [select ccrz__Product__c from ccrz__E_CartItem__c where id in : cartItemafterupdateorinsert];
            for(ccrz__E_CartItem__c eachcrtitem  : cartitemlst){
                if(ProductIDSet.contains((string)eachcrtitem.ccrz__Product__c)){
                    ProductsInsertedorUpdated.add((string)eachcrtitem.ccrz__Product__c);
                    ProductIDSet.remove((string)eachcrtitem.ccrz__Product__c);
                }
            }
            ProductsNotInserted.addall(ProductIDSet);
        }
        
        retrunResponse.put('CartId', CartId); 
        retrunResponse.put('ProductsInserted', ProductsInsertedorUpdated);
        retrunResponse.put('ProductsNotInserted', ProductsNotInserted);
        

            
        }catch(exception ex){
            system.debug('error message > ' + ex.getMessage());                            
            system.debug('error cause > ' + ex.getCause());
            system.debug('error type > ' + ex.getTypeName());
            system.debug('error at line number > ' + ex.getLineNumber());                            
            system.debug('error stack trace > ' + ex.getStackTraceString());            
        }
        return retrunResponse;
    }
    
}