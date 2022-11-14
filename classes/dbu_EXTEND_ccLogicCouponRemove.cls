global without sharing class dbu_EXTEND_ccLogicCouponRemove extends ccrz.ccLogicCouponRemove {
    
    global virtual override Map<String, Object> remove(Map<String, Object> inputData) {
		system.debug('INPUTDATA KEYS > ' +  inputData.keySet());
        system.debug('inputData VALUES > ' + inputData.values());
        
        Map<string,object> RetMap = super.remove(inputData);
        
        system.debug('RETMAP KEYS > ' + RetMap.keySet());
        system.debug('RETMAP VALUES > ' + RetMap.values());
        
        return RetMap;
    }
    
    global virtual override Map<String, Object> performDML(Map<String, Object> inputData) {
		system.debug('INPUTDATA PERFROM DML  KEYS > ' +  inputData.keySet());
        system.debug('inputData PERFROM DML VALUES > ' + inputData.values());      
        
        //##################### Logic for Absolute carttotal discount - begins 
        //get cartid
        string currentCartidBef = (string)inputData.get('cartId');
        
        //get cartCoupon for current cartCoupon
        //list<ccrz__E_CartCoupon__c> currentCartCoupon = new list<ccrz__E_CartCoupon__c>();
        //currentCartCoupon = [select ID,ccrz__Cart__c from ccrz__E_CartCoupon__c where ccrz__Cart__c =: currentCartidBef and ccrz__Coupon__r.ccrz__CouponType__c = 'Absolute' and ccrz__Coupon__r.ccrz__RuleType__c = 'CartTotal'];
        
        /*
        if(currentCartCoupon.size() > 0){
            list<ccrz__E_Cart__c> CurrentCartToUpdate = new list<ccrz__E_Cart__c>();
            CurrentCartToUpdate = [select id, ccrz__AdjustmentAmount__c, ccrz__AdjustmentReason__c from ccrz__E_Cart__c where id =: currentCartidBef];
            if(CurrentCartToUpdate.size() > 0){
                for(ccrz__E_Cart__c eachCart : CurrentCartToUpdate){
                    eachCart.ccrz__AdjustmentAmount__c = 0;
                    eachCart.ccrz__AdjustmentReason__c = '';
                }
                
                //Update Cart - AdjustmentAmount and Reson
                try{
                    Database.SaveResult[] updatedCartIDList = Database.update(CurrentCartToUpdate, true);
                     
                    // Iterate through each returned result
                    for (Database.SaveResult sr : updatedCartIDList) {
                        if (sr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully updated Cart. Cart ID: ' + sr.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : sr.getErrors()) {
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('Cart fields that affected this error: ' + err.getFields());
                            }
                        }
                    }			
                }catch(Exception e){
                    system.debug('Exception while updating Cart > '  + e.getMessage());
                }		
            }
            
        }   
		*/
        //#################### Logic for Absolute carttotal discount - ends 
       
        
        Map<string,object> RetMap = super.performDML(inputData);
		
        system.debug('RETMAP PERFROM DML KEYS > ' + RetMap.keySet());
        system.debug('RETMAP PERFROM DML VALUES > ' + RetMap.values());
        
        for(String eachkey :  RetMap.keySet()){
            system.debug('KEY > ' + eachkey + ' VALUE > ' + RetMap.get(eachkey));
        }
        
        //getting current cart
        ccrz__E_Cart__c currentCart = new ccrz__E_Cart__c();
        currentCart = (ccrz__E_Cart__c)RetMap.get('ccLogicCouponRemove.fetchCartData');
        system.debug('currentCart > ' + currentCart);                
        
        string currentCartID =  currentCart.id;
        system.debug('currentCartID > ' + currentCartID);
        
        string currentCartStoreLocation = currentCart.dbu_Cart_StoreCountry__c;
        system.debug('currentCartStoreLocation > ' + currentCartStoreLocation);
                                
        //get the country cureency iso mapping from custom settings
        Map<string,string> countryCurrencyMap = new Map<string,string>();
        for(dbu_CountryCurrencyMapping__c eachsetting : (list<dbu_CountryCurrencyMapping__c>)dbu_CountryCurrencyMapping__c.getall().values()){
            system.debug('dbuCountryCode__c > ' + (string)eachsetting.get('dbuCountryCode__c'));
            system.debug('dbuCurrencyCode__c > ' + (string)eachsetting.get('dbuCurrencyCode__c'));
            countryCurrencyMap.put((string)eachsetting.get('dbuCountryCode__c'), (string)eachsetting.get('dbuCurrencyCode__c'));
        }
        system.debug('countryCurrencyMap > ' + countryCurrencyMap);   
        string CurrencyISOcodeValue = (string)countryCurrencyMap.get(currentCartStoreLocation);        
        if(Test.isRunningTest() == true){
            CurrencyISOcodeValue = 'USD';
        }
        system.debug('CurrencyISOcodeValue > ' + CurrencyISOcodeValue);
        
        list<ccrz__E_CartItem__c> currentCartCartitems = new list<ccrz__E_CartItem__c>();
		currentCartCartitems = 	(list<ccrz__E_CartItem__c>)RetMap.get('ccLogicCouponRemove.dmlCartItems');
        system.debug('currentCartCartitems > ' + currentCartCartitems);
        
        list<string> ProductIds = new List<string>();
        list<string> CartitemIds = new list<string>();
        for(ccrz__E_CartItem__c eachcartitem : currentCartCartitems){
            ProductIds.add(eachcartitem.ccrz__Product__c); 
            CartitemIds.add(eachcartitem.id);
        }
        
        list<ccrz__E_CartItem__c> cartitemdetails = new list<ccrz__E_CartItem__c>();
        cartitemdetails=   [select id, 
                            ccrz__Product__c,
                            ccrz__ItemStatus__c, 
                            ccrz__Quantity__c,
                            ccrz__OriginalItemPrice__c, 
                            ccrz__Price__c, 
                            ccrz__SubAmount__c 
                            from ccrz__E_CartItem__c 
                            where id in : CartitemIds];
        
        
        system.debug('cartitemdetails > ' + cartitemdetails);
        
        Map<string,double> pricingofproducts = new Map<string,double>();
        for(ccrz__E_PriceListItem__c eachpricelistitem : [select ccrz__Price__c,ccrz__Product__c from ccrz__E_PriceListItem__c where CurrencyIsoCode =: CurrencyISOcodeValue and ccrz__Product__c in : ProductIds]){
            pricingofproducts.put((string)eachpricelistitem.ccrz__Product__c, eachpricelistitem.ccrz__Price__c);            
        }
        system.debug('pricingofproducts > ' + pricingofproducts);
        
        
        for(ccrz__E_CartItem__c eachcartitem : cartitemdetails){
            eachcartitem.ccrz__Price__c = (double)pricingofproducts.get((string)eachcartitem.ccrz__Product__c);
            eachcartitem.ccrz__OriginalItemPrice__c = (double)pricingofproducts.get((string)eachcartitem.ccrz__Product__c);
            eachcartitem.ccrz__SubAmount__c = eachcartitem.ccrz__Price__c * eachcartitem.ccrz__Quantity__c;
            eachcartitem.ccrz__ItemStatus__c = 'Available';            
        }
        
        update cartitemdetails;
        
        
        
        return RetMap;        
    }
    
}