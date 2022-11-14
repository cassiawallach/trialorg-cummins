global without sharing class dbu_EXTEND_ccLogicCouponApply extends ccrz.ccLogicCouponApply{
    
    global virtual override Map<String, Object> performDML(Map<String, Object> InputData){
    		
        for(string key : InputData.keyset()){
            system.debug('IP key > ' + key + ' IP Value > ' + InputData.get(key));
        }
        	
        	Map<string, object> RetMap = super.performDML(InputData);
        
        for(string key : RetMap.keyset()){
            system.debug('OP key > ' + key + ' OP Value > ' + RetMap.get(key));
        }   
        
        //Logic for handling Absolute CartTotal coupons - Malhar - 11/3/2021
        string CurrentApliedCouponCode = (string)RetMap.get('ccApiCouponCode');
        
        list<ccrz__E_Coupon__c> CurrentAppliedCoupon = new list<ccrz__E_Coupon__c>();
        CurrentAppliedCoupon = [SELECT ID, ccrz__CouponName__c, ccrz__CartTotalAmount__c,ccrz__DiscountAmount__c FROM ccrz__E_Coupon__c WHERE ccrz__CouponType__c = 'Absolute' and ccrz__RuleType__c = 'CartTotal' and ccrz__StartDate__c <= Today and ccrz__EndDate__c >= Today and ccrz__CouponCode__c =: CurrentApliedCouponCode]; 
        
        if(CurrentAppliedCoupon.size() > 0){
            
            string CouponAppliedCartId = (string)RetMap.get('cartId');
            string CurrentAppliedCouponID = (string)CurrentAppliedCoupon[0].id;
            string CouponAppliedName = CurrentAppliedCoupon[0].ccrz__CouponName__c;
            double couponDiscountAmt = CurrentAppliedCoupon[0].ccrz__DiscountAmount__c;
            system.debug('couponDiscountAmt > ' + couponDiscountAmt);
            double CouponMinimumCartTotal;
            if(CurrentAppliedCoupon[0].ccrz__CartTotalAmount__c != null){
            	CouponMinimumCartTotal = CurrentAppliedCoupon[0].ccrz__CartTotalAmount__c;    
            }else{
                CouponMinimumCartTotal = 0;
            }
            system.debug('CouponMinimumCartTotal > ' + CouponMinimumCartTotal);
            list<ccrz__E_CartItem__c> CouponCartItem = new list<ccrz__E_CartItem__c>();	
            CouponCartItem = [select id, ccrz__Price__c from ccrz__E_CartItem__c where ccrz__Cart__c =: CouponAppliedCartId and ccrz__Coupon__c =: CurrentAppliedCouponID and ccrz__ProductType__c = 'Coupon' and ccrz__StoreID__c = 'CSSNAStore' and ccrz__cartItemType__c = 'Coupon'];
            system.debug('CouponCartItem > ' + CouponCartItem);
            
            if(CouponCartItem.size() > 0){
                double CouponAmount = CouponCartItem[0].ccrz__Price__c;		
                if(CouponAmount < 0){
                   CouponAmount = (CouponAmount)*(-1); 
                }
                list<ccrz__E_Cart__c> CurrentCartList = new list<ccrz__E_Cart__c>();
                ccrz__E_Cart__c CurrentCart = [select id,ccrz__TotalAmount__c  from ccrz__E_Cart__c where id =: CouponAppliedCartId];		
                system.debug('CurrentCart > ' + CurrentCart);
                

                
                if(CurrentCart.ccrz__TotalAmount__c > couponDiscountAmt){
                    
                    //get all cartItems except the coupon item
                    list<ccrz__E_CartItem__c> OtherCartItems = new list<ccrz__E_CartItem__c>();	
                    OtherCartItems = [select id, ccrz__SubAmount__c,ccrz__AbsoluteDiscount__c from ccrz__E_CartItem__c where ccrz__Cart__c =: CouponAppliedCartId and ccrz__ProductType__c = 'Product' and ccrz__StoreID__c = 'CSSNAStore' and ccrz__cartItemType__c = 'Major'];
                    system.debug('OtherCartItems > ' + OtherCartItems);
                    
                    double TotalCartitemsValue = 0;
                    //if other cartitems not empty then loop
                    if(OtherCartItems.size() > 0){
                        for(ccrz__E_CartItem__c eachCartitem : OtherCartItems){
                            TotalCartitemsValue = TotalCartitemsValue + eachCartitem.ccrz__SubAmount__c;
                        }
                        system.debug('TotalCartitemsValue >  ' + TotalCartitemsValue);
                        
                        
                        for(ccrz__E_CartItem__c eachCartitem : OtherCartItems){
                            long DiscountValue = (((eachCartitem.ccrz__SubAmount__c)/(TotalCartitemsValue))*(CouponAmount)).round(System.RoundingMode.HALF_DOWN);
                            system.debug('DiscountValue > ' + DiscountValue);
                            double NewSubAmountforCartItem = eachCartitem.ccrz__SubAmount__c - DiscountValue;
                            eachCartitem.ccrz__AbsoluteDiscount__c = DiscountValue;
                            eachCartitem.ccrz__SubAmount__c = NewSubAmountforCartItem;
                        }
                        system.debug('Modifified OtherCartItems > ' + OtherCartItems);
                        
                        
                        //Update Cartitem - absolute discount & new subamountValues
                        try{
                            Database.SaveResult[] srList = Database.update(OtherCartItems, true);
                            
                            // Iterate through each returned result
                            for (Database.SaveResult sr : srList) {
                                if (sr.isSuccess()) {
                                    // Operation was successful, so get the ID of the record that was processed
                                    System.debug('Successfully updated Cartitems. Cartitem ID: ' + sr.getId());
                                }
                                else {
                                    // Operation failed, so get all errors                
                                    for(Database.Error err : sr.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('Cartitem fields that affected this error: ' + err.getFields());
                                    }
                                }
                            }			
                        }catch(Exception e){
                            system.debug('Exception while updating Cartitem > '  + e.getMessage());
                            system.debug('Exception while updating Cartitem > '  + e.getCause());
                            system.debug('Exception while updating Cartitem > '  + e.getTypeName());
                            system.debug('Exception while updating Cartitem > '  + e.getLineNumber());
                        }                    
                                        
                        //coupon success set
                        RetMap.put('success', true);                                            
                    }                    
                                                           
                }else if(CurrentCart.ccrz__TotalAmount__c < couponDiscountAmt){
                    //delete cart coupon 
                    list<ccrz__E_CartCoupon__c> currentCartCoupon = new list<ccrz__E_CartCoupon__c>();
                    currentCartCoupon = [select id from ccrz__E_CartCoupon__c where ccrz__Cart__c =: CouponAppliedCartId and ccrz__Coupon__c =: CurrentAppliedCouponID and ccrz__Enabled__c = false limit 1];
                    system.debug('currentCartCoupon > ' + currentCartCoupon);
                    
                    if(currentCartCoupon.size() > 0){
                        //Delete coupon Cartitem
                        try{
                            Database.DeleteResult[] drList = Database.delete(currentCartCoupon, true);
                            for(Database.DeleteResult dr : drList) {
                                if (dr.isSuccess()) {
                                    // Operation was successful, so get the ID of the record that was processed
                                    System.debug('Successfully deleted cartcoupon ID: ' + dr.getId());
                                }
                                else {
                                    // Operation failed, so get all errors                
                                    for(Database.Error err : dr.getErrors()) {
                                        System.debug('The following error has occurred.');                    
                                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                        System.debug('cartcoupon fields that affected this error: ' + err.getFields());
                                    }
                                }
                            }		
                        }catch(exception e){
                            system.debug('Exception while deleting CartItem > ' + e.getmessage());			
                        }                        
                    }
                    //coupon success set
                    system.debug('RetMap d> '  + RetMap.get('success'));
                    RetMap.put('success', false);   
                    RetMap.PUT('abosolute coupon success', false);
                    RetMap.remove('ccApiCouponCode'); 
                    system.debug('RetMap d2> '  + RetMap.get('success'));
                    
                }
 
                
                
                

                
                //Delete coupon Cartitem
                try{
                    Database.DeleteResult[] drList = Database.delete(CouponCartItem, true);
                    for(Database.DeleteResult dr : drList) {
                        if (dr.isSuccess()) {
                            // Operation was successful, so get the ID of the record that was processed
                            System.debug('Successfully deleted cartitem with ID: ' + dr.getId());
                        }
                        else {
                            // Operation failed, so get all errors                
                            for(Database.Error err : dr.getErrors()) {
                                System.debug('The following error has occurred.');                    
                                System.debug(err.getStatusCode() + ': ' + err.getMessage());
                                System.debug('cartitem fields that affected this error: ' + err.getFields());
                            }
                        }
                    }		
                }catch(exception e){
                    system.debug('Exception while deleting CartItem > ' + e.getmessage());			
                }
                
            }
            
        }
        
        for(string key : RetMap.keyset()){
            system.debug('OP FINAL key > ' + key + ' OP FINAL Value > ' + RetMap.get(key));
        } 		      	
        return RetMap;
        
    	}
    
    global virtual override Map<string, object> prepReturn(Map<string,object> InputData){
        system.debug('PREPRETRUN METHOD');
        
         

        if(InputData.get('abosolute coupon success') != null){
            InputData.put('success', false);
        }

        
        
        for(string key : InputData.keyset()){
            system.debug('IP key > ' + key + ' IP Value > ' + InputData.get(key));
        }
        	
        	Map<string, object> RetMap = super.prepReturn(InputData);
        
        for(string key : RetMap.keyset()){
            system.debug('OP key > ' + key + ' OP Value > ' + RetMap.get(key));
        }   
        
        return RetMap;
        
    }
    }