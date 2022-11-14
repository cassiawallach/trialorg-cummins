/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-15-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class dbu_CouponUtility {
    private static String couponAppliedMsg = System.Label.dbu_Coupon_Msg_CriteriaDidNotMatch;
    private static List<ccrz__E_CartItem__c> updatedCartItems;
    //get CartItems
    public static List<ccrz__E_CartItem__c> getCartItems(String cartId){
        List<ccrz__E_CartItem__c> cartItems;
        cartItems = [SELECT Id,
                     CurrencyIsoCode,
                     ccrz__Product__c,
                     ccrz__SubAmount__c,
                     ccrz__Quantity__c,
                     ccrz__Price__c,
                     ccrz__Product__r.dbu_Crate_Engine__c,
                     ccrz__Product__r.dbu_Has_Core_Child__c,
                     ccrz__Product__r.dbu_Has_Core_Charge__c,
                     ccrz__Cart__r.ccrz__TotalAmount__c,
                     ccrz__Cart__r.ccrz__SubtotalAmount__c,
                     ccrz__Cart__r.dbu_storeLanguage__c,
                     ccrz__Cart__r.dbu_Free_Shipping__c,
                     ccrz__Cart__r.dbu_Total_Gift_Card_Amount__c,
                     ccrz__Cart__r.ccrz__ShipAmount__c,
                     ccrz__Cart__r.ccrz__TaxAmount__c,
                     ccrz__AbsoluteDiscount__c,
                     ccrz__PercentDiscount__c
                     FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c =: cartId];
        return cartItems;
    }
    public static String getCartTotalCoupon(String cartId, Ecom_Coupon__c coupon){
        Map<String,Boolean> contactMap;
        if(coupon.Ecom_Coupon_Contacts__r.size()>0){
            contactMap = dbu_CouponContactUtility.getCouponContacts(coupon.Ecom_Coupon_Contacts__r);
        }
        
        if(contactMap != null && contactMap.get('isExcluded')){
            return couponAppliedMsg;
        }
        getCouponHelper( cartId, coupon);
        return couponAppliedMsg;
    }
    
    public static String getCouponHelper(String cartId, Ecom_Coupon__c coupon){
        if(getUserAlreadyAppliedCoupon(coupon,cartId)){
            couponAppliedMsg = System.Label.dbu_CouponReedemed;
            return couponAppliedMsg;
        }
        system.debug('coupon ' + coupon);
        List<ccrz__E_CartItem__c> cartItems = getCartItems(cartId);
        Set<String> exclusionProductIds = new Set<String>();
        Set<String> inclusionProductIds = new Set<String>();
        Map<String,Set<String>> productIdMap;
        Set<String> exclusionProductIdsFromCategories = new Set<String>();
        Map<String,Set<String>> categoryProductIdMap;
        system.debug('cartItems ' + cartItems);
        if((coupon.Ecom_Store__c.contains('United States') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'US') ||
           (coupon.Ecom_Store__c.contains('Canada') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'EN') || 
           (coupon.Ecom_Store__c.contains('Canada') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'FR')){
               system.debug('coupon.Ecom_Coupon_Products__r ' + coupon.Ecom_Coupon_Products__r.size());
               if(coupon.Ecom_Coupon_Products__r.size() > 0){
                   productIdMap = dbu_CouponProductUtility.getCouponProducts(coupon.Ecom_Coupon_Products__r);
                   exclusionProductIds = productIdMap.get('Exclusion');
               }
               if(coupon.Ecom_Coupon_Categories__r.size()>0){
                   categoryProductIdMap = dbu_CouponCategoryUtility.getCouponCategories(coupon.Ecom_Coupon_Categories__r,cartItems);
                   exclusionProductIds.addAll(categoryProductIdMap.get('Exclusion'));
               }
               Integer productCount = 0;
               for(ccrz__E_CartItem__c cartItem : cartItems){
                   if(cartItem.ccrz__Product__r.dbu_Has_Core_Child__c && cartItem.ccrz__Product__r.dbu_Has_Core_Charge__c){
                       exclusionProductIds.add(cartItem.ccrz__Product__c);
                   }
                   if(!exclusionProductIds.contains(cartItem.ccrz__Product__c)){
                       productCount = productCount + Integer.valueOf(cartItem.ccrz__Quantity__c);
                   }
               }
               Decimal totalCartAmnt = getUpdatedCartAmnt(cartItems,exclusionProductIds);
               system.debug('totalCartAmnt ' + totalCartAmnt);
               if((cartItems.size() > 0 && totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && productCount >= coupon.Ecom_Min_Quantity__c)
                  || (cartItems.size() > 0 && totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && coupon.Ecom_Min_Quantity__c == null) 
                  || (cartItems.size() > 0 && coupon.Ecom_Cart_Total_Amount__c == null && productCount >= coupon.Ecom_Min_Quantity__c)){
                      buildUpdatedCartItemList(coupon,totalCartAmnt,cartItems,exclusionProductIds,cartId);
                  }
           }
        return couponAppliedMsg;
    }
    
    
    //----------Only for Guest -----------
    public static String getCartTotalCouponGuest(String cartId, Ecom_Coupon__c coupon){
        Map<String,Boolean> contactMap  = dbu_CouponContactUtility.getCouponContacts(coupon.Ecom_Coupon_Contacts__r);
        system.debug('contactMap ' + contactMap);
        if(UserInfo.getUserType() == 'Guest' || contactMap != null){
            if(contactMap != null){
                if(contactMap.get('isExcluded')){
                    return couponAppliedMsg;
                }else if(contactMap.get('isIncluded')){
                    couponAppliedMsg = getCouponHelper( cartId, coupon);
                }else if(contactMap.get('isExcluded') == false && contactMap.get('isIncluded') == false && UserInfo.getUserType() == 'Guest'){
                    couponAppliedMsg =  getCouponHelper( cartId, coupon);
                }
            }
        }
        return couponAppliedMsg;
    }
    // both check boxes are unchecked 
    public static String getCartTotalCouponIncludedCust(String cartId, Ecom_Coupon__c coupon){
        Map<String,Boolean> contactMap  = dbu_CouponContactUtility.getCouponContacts(coupon.Ecom_Coupon_Contacts__r);
        System.debug('contactMap======'+contactMap);
        if(contactMap.get('isExcluded')){
            return couponAppliedMsg;
        }else if(contactMap.get('isIncluded')){
            getCouponHelper( cartId, coupon);
        }
        return couponAppliedMsg;
    }
    // Rule type General
    public static String getGeneralTypeCoupon(String cartId, Ecom_Coupon__c coupon){
        
        Map<String,Boolean>  contactMap  = dbu_CouponContactUtility.getCouponContacts(coupon.Ecom_Coupon_Contacts__r);
        system.debug('contactMap in ' + contactMap);
        if(contactMap.get('isExcluded')){
            return couponAppliedMsg;
        }else if(contactMap.get('isIncluded')){
            if(coupon.Ecom_Rule_Type__c != 'BOGO'){
                getCouponInclusionExclusionIds( cartId, coupon); 
            }else{
              //  getBOGOTypeCoupon(coupon,cartId);
            }
            
        }else if(contactMap.get('isExcluded') == false && contactMap.get('isIncluded') == false && UserInfo.getUserType() == 'Guest' && coupon.Ecom_Include_Guest_Customers__c){
            if(coupon.Ecom_Rule_Type__c != 'BOGO'){
                getCouponInclusionExclusionIds( cartId, coupon); 
            }else{
              //  getBOGOTypeCoupon(coupon,cartId);
            }
            
        }else if(contactMap.get('isExcluded') == false && contactMap.get('isIncluded') == false && UserInfo.getUserType() != 'Guest' && coupon.Ecom_Include_All_Register_Customers__c){
            if(coupon.Ecom_Rule_Type__c != 'BOGO'){
                getCouponInclusionExclusionIds( cartId, coupon); 
            }else{
              //  getBOGOTypeCoupon(coupon,cartId);
            }
            
        }
        
        
        return couponAppliedMsg;
    }
    // Get Coupon Inclusion and Exclusion Product and Category IDs
    public static String getCouponInclusionExclusionIds(String cartId, Ecom_Coupon__c coupon){
        if(getUserAlreadyAppliedCoupon(coupon,cartId)){
            couponAppliedMsg = System.Label.dbu_CouponReedemed;
            return couponAppliedMsg;
        }
        List<ccrz__E_CartItem__c> cartItems = getCartItems(cartId);
        Set<String> exclusionProductIds = new Set<String>();
        Set<String> inclusionProductIds = new Set<String>();
        Set<String> allInclusionPids = new Set<String>();
        Map<String,Set<String>> productIdMap;
        Map<String,Set<String>> categoryProductIdMap;
        Set<String> pIds = new Set<String>();
        Integer productCount = 0 ;
        if((coupon.Ecom_Store__c.contains('United States') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'US') ||
           (coupon.Ecom_Store__c.contains('Canada') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'EN') || 
           (coupon.Ecom_Store__c.contains('Canada') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'FR')){
               if(coupon.Ecom_Coupon_Products__r.size() > 0){
                   productIdMap = dbu_CouponProductUtility.getCouponProducts(coupon.Ecom_Coupon_Products__r);
                   exclusionProductIds = productIdMap.get('Exclusion');
                   inclusionProductIds = productIdMap.get('Inclusion');
               }
               if(coupon.Ecom_Coupon_Categories__r.size()>0){
                   categoryProductIdMap = dbu_CouponCategoryUtility.getCouponCategories(coupon.Ecom_Coupon_Categories__r,cartItems);
                   exclusionProductIds.addAll(categoryProductIdMap.get('Exclusion'));
                   inclusionProductIds.addAll(categoryProductIdMap.get('Inclusion'));
               }
               for(ccrz__E_CartItem__c cartItem : cartItems){
                   if(cartItem.ccrz__Product__r.dbu_Has_Core_Child__c && cartItem.ccrz__Product__r.dbu_Has_Core_Charge__c){
                       exclusionProductIds.add(cartItem.ccrz__Product__c);
                   }
                   if(inclusionProductIds.contains(cartItem.ccrz__Product__c) && !exclusionProductIds.contains(cartItem.ccrz__Product__c)){
                       productCount = productCount + Integer.valueOf(cartItem.ccrz__Quantity__c);
                   }else if(inclusionProductIds.isEmpty() && !exclusionProductIds.contains(cartItem.ccrz__Product__c)){
                       productCount = productCount + Integer.valueOf(cartItem.ccrz__Quantity__c);
                   }else if(inclusionProductIds.isEmpty() && exclusionProductIds.isEmpty()){
                       productCount = productCount + Integer.valueOf(cartItem.ccrz__Quantity__c);
                   }
               }
               if(exclusionProductIds.size() > 0){
                   for(String inclusionIds : inclusionProductIds){
                       if(!exclusionProductIds.contains(inclusionIds)){
                           pIds.add(inclusionIds);
                       }
                   }
               }else{
                   pIds.addAll(inclusionProductIds);
               }
               System.debug('inclusionProductIds===='+inclusionProductIds);
               System.debug('exclusionProductIds===='+exclusionProductIds);
               if(coupon.Ecom_Rule_Type__c == 'Shipping'){
                   Boolean isFreeShipping = false;
                   Decimal totalCartAmnt = 0.00;
                   Decimal cartTotalWeight = calculateFreeShippingWeight(inclusionProductIds,exclusionProductIds,cartId);
                   if(coupon.Ecom_Max_Weight__c != null && coupon.Ecom_Min_Weight__c != null && coupon.Ecom_Cart_Total_Amount__c == null && coupon.Ecom_Min_Quantity__c == null){
                       System.debug('cartTotalWeight======'+cartTotalWeight);
                       System.debug('Ecom_Min_Weight__c======'+coupon.Ecom_Min_Weight__c);
                       System.debug('Ecom_Max_Weight__c======'+coupon.Ecom_Max_Weight__c);
                       if(cartTotalWeight >= coupon.Ecom_Min_Weight__c &&  cartTotalWeight <= coupon.Ecom_Max_Weight__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c !=null && coupon.Ecom_Min_Weight__c == null && coupon.Ecom_Cart_Total_Amount__c == null && coupon.Ecom_Min_Quantity__c == null){
                       if(cartTotalWeight <= coupon.Ecom_Max_Weight__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c ==null && coupon.Ecom_Min_Weight__c != null && coupon.Ecom_Cart_Total_Amount__c == null && coupon.Ecom_Min_Quantity__c == null){
                       if(cartTotalWeight >= coupon.Ecom_Min_Weight__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c ==null && coupon.Ecom_Min_Weight__c == null && coupon.Ecom_Cart_Total_Amount__c != null && coupon.Ecom_Min_Quantity__c == null){
                       totalCartAmnt = getTotalAmount(inclusionProductIds,exclusionProductIds,pIds,coupon,cartItems);
                       if(totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c !=null && coupon.Ecom_Min_Weight__c == null && coupon.Ecom_Cart_Total_Amount__c != null && coupon.Ecom_Min_Quantity__c == null){
                       totalCartAmnt = getTotalAmount(inclusionProductIds,exclusionProductIds,pIds,coupon,cartItems);
                       if(totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && cartTotalWeight <= coupon.Ecom_Max_Weight__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c ==null && coupon.Ecom_Min_Weight__c != null && coupon.Ecom_Cart_Total_Amount__c != null && coupon.Ecom_Min_Quantity__c == null){
                       totalCartAmnt = getTotalAmount(inclusionProductIds,exclusionProductIds,pIds,coupon,cartItems);
                       if(totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && cartTotalWeight >= coupon.Ecom_Min_Weight__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c !=null && coupon.Ecom_Min_Weight__c != null && coupon.Ecom_Cart_Total_Amount__c != null && coupon.Ecom_Min_Quantity__c == null){
                       totalCartAmnt = getTotalAmount(inclusionProductIds,exclusionProductIds,pIds,coupon,cartItems);
                       if(totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && cartTotalWeight >= coupon.Ecom_Min_Weight__c && cartTotalWeight <= coupon.Ecom_Max_Weight__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c !=null && coupon.Ecom_Min_Weight__c != null && coupon.Ecom_Cart_Total_Amount__c != null && coupon.Ecom_Min_Quantity__c != null){
                       totalCartAmnt = getTotalAmount(inclusionProductIds,exclusionProductIds,pIds,coupon,cartItems);
                       if(totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && cartTotalWeight >= coupon.Ecom_Min_Weight__c && cartTotalWeight <= coupon.Ecom_Max_Weight__c && productCount>=coupon.Ecom_Min_Quantity__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c ==null && coupon.Ecom_Min_Weight__c == null && coupon.Ecom_Cart_Total_Amount__c != null && coupon.Ecom_Min_Quantity__c != null){
                       totalCartAmnt = getTotalAmount(inclusionProductIds,exclusionProductIds,pIds,coupon,cartItems);
                       if(totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && productCount>=coupon.Ecom_Min_Quantity__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c !=null && coupon.Ecom_Min_Weight__c != null && coupon.Ecom_Cart_Total_Amount__c == null && coupon.Ecom_Min_Quantity__c != null){
                       if(cartTotalWeight >= coupon.Ecom_Min_Weight__c && cartTotalWeight <= coupon.Ecom_Max_Weight__c && productCount>=coupon.Ecom_Min_Quantity__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c !=null && coupon.Ecom_Min_Weight__c == null && coupon.Ecom_Cart_Total_Amount__c == null && coupon.Ecom_Min_Quantity__c != null){
                       if(cartTotalWeight <= coupon.Ecom_Max_Weight__c && productCount>=coupon.Ecom_Min_Quantity__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c ==null && coupon.Ecom_Min_Weight__c != null && coupon.Ecom_Cart_Total_Amount__c == null && coupon.Ecom_Min_Quantity__c != null){
                       if(cartTotalWeight >= coupon.Ecom_Min_Weight__c && productCount>=coupon.Ecom_Min_Quantity__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c ==null && coupon.Ecom_Min_Weight__c == null && coupon.Ecom_Cart_Total_Amount__c == null && coupon.Ecom_Min_Quantity__c != null){
                       if(productCount>=coupon.Ecom_Min_Quantity__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c !=null && coupon.Ecom_Min_Weight__c == null && coupon.Ecom_Cart_Total_Amount__c != null && coupon.Ecom_Min_Quantity__c != null){
                       totalCartAmnt = getTotalAmount(inclusionProductIds,exclusionProductIds,pIds,coupon,cartItems);
                       if(cartTotalWeight <= coupon.Ecom_Max_Weight__c && productCount>=coupon.Ecom_Min_Quantity__c && totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c){
                           isFreeShipping= true;
                       }
                   }else if(coupon.Ecom_Max_Weight__c ==null && coupon.Ecom_Min_Weight__c != null && coupon.Ecom_Cart_Total_Amount__c != null && coupon.Ecom_Min_Quantity__c != null){
                       totalCartAmnt = getTotalAmount(inclusionProductIds,exclusionProductIds,pIds,coupon,cartItems);
                       if(cartTotalWeight >= coupon.Ecom_Min_Weight__c && productCount>=coupon.Ecom_Min_Quantity__c && totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c){
                           isFreeShipping= true;
                       }
                   }
                   System.debug('isFreeShipping====='+isFreeShipping);
                   if(isFreeShipping){
                       ccrz__E_Cart__c cartObj = [Select id, ccrz__ShipAmount__c,dbu_Free_Shipping__c from ccrz__E_Cart__c where id =: cartId ];
                       cartObj.dbu_Free_Shipping__c = true;
                       cartObj.ccrz__ShipAmount__c = 0.00;
                       try {
                           update cartObj;
                           couponAppliedMsg = System.Label.dbu_Coupon_Success; 
                           createEcomCartCoupon(coupon,cartId);
                       } catch(DmlException e) {
                           System.debug('The following exception has occurred: ' + e.getMessage());
                       }
                       
                   }
               }else {
                   Decimal totalCartAmnt = getUpdatedCartAmnt(cartItems,pIds);
                   totalCartAmnt = cartItems[0].ccrz__Cart__r.ccrz__SubtotalAmount__c - totalCartAmnt;
                   system.debug('totalCartAmnt ' + totalCartAmnt);
                   if((cartItems.size() > 0 && totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && productCount >= coupon.Ecom_Min_Quantity__c)
                      || (cartItems.size() > 0 && totalCartAmnt >= coupon.Ecom_Cart_Total_Amount__c && coupon.Ecom_Min_Quantity__c == null) 
                      || (cartItems.size() > 0 && coupon.Ecom_Cart_Total_Amount__c== null && productCount >= coupon.Ecom_Min_Quantity__c)){
                          system.debug('before UpdateCartItemList');
                          //buildUpdatedCartItemList(coupon,totalCartAmnt,cartItems,exclusionProductIds,cartId);
                          UpdateCartItemList(coupon,totalCartAmnt,cartItems,exclusionProductIds,inclusionProductIds,cartId);
                      }
               }
           }
        return couponAppliedMsg;
    }
    private static Decimal getTotalAmount(Set<String> inclusionProductIds, Set<String> exclusionProductIds,Set<String> pIds,Ecom_Coupon__c coupon,List<ccrz__E_CartItem__c> cartItems){
        Decimal totalCartAmnt = 0.00;
        System.debug('====inclusionProductIds size==='+inclusionProductIds.size());
        System.debug('====inclusionProductIds==='+inclusionProductIds);
        if(inclusionProductIds.isEmpty() && exclusionProductIds.isEmpty()){
            totalCartAmnt = cartItems[0].ccrz__Cart__r.ccrz__SubtotalAmount__c;
        }else if(inclusionProductIds.isEmpty() && !exclusionProductIds.isEmpty()){
            totalCartAmnt = getUpdatedCartAmnt(cartItems,exclusionProductIds);
            System.debug('totalCartAmnt  '+totalCartAmnt);
        }else if(!inclusionProductIds.isEmpty() && exclusionProductIds.isEmpty()){
            totalCartAmnt = getUpdatedCartAmnt(cartItems,inclusionProductIds);
            totalCartAmnt = cartItems[0].ccrz__Cart__r.ccrz__SubtotalAmount__c - totalCartAmnt;
        }else if(!inclusionProductIds.isEmpty() && !exclusionProductIds.isEmpty()){
            totalCartAmnt = getUpdatedCartAmnt(cartItems,pIds);
            totalCartAmnt = cartItems[0].ccrz__Cart__r.ccrz__SubtotalAmount__c - totalCartAmnt;
        }
        return totalCartAmnt;
    }
    // Dicount Calculation for general type
    private static String UpdateCartItemList(Ecom_Coupon__c coupon, Decimal totalCartAmnt, List<ccrz__E_CartItem__c> cartItems, Set<String> exclusionProductIds,Set<String> InclusionProductIds,String cartId){
        List<ccrz__E_CartItem__c> updatedCartItems = new List<ccrz__E_CartItem__c>();
        Set<String> pIds = new Set<String>();
        if(exclusionProductIds.size()>0 && InclusionProductIds.size()>0){
            for(String inclusionPId : InclusionProductIds){
                if(!exclusionProductIds.contains(inclusionPId)){
                    pIds.add(inclusionPId);
                }
            }
        }else if(InclusionProductIds.size()>0 && exclusionProductIds.isEmpty()){
            pIds.addAll(InclusionProductIds);
        }
        system.debug('pIds ' + pIds);
        if(pIds.size()>0){
            updatedCartItems = getDiscountOnCartItems(coupon,totalCartAmnt,cartItems,pIds);
        }
        
        if(updatedCartItems.size() > 0){
            couponAppliedMsg = updateCartItemsDataWithDiscount(updatedCartItems,coupon,cartId);
        }
        return couponAppliedMsg;
    }   
    
    // Discount calculation for General Rule Type
    private static List<ccrz__E_CartItem__c> getDiscountOnCartItems(Ecom_Coupon__c coupon,Decimal totalCartAmnt,List<ccrz__E_CartItem__c> cartItems,Set<String> InclusionProductIds){
        updatedCartItems = new List<ccrz__E_CartItem__c>();
        Decimal discountValue = 0.00;
         Decimal totalDis = 0.00;
        for(ccrz__E_CartItem__c eachCartitem : cartItems){
            if(InclusionProductIds.contains(eachCartitem.ccrz__Product__c)){
                if(!coupon.Ecom_Discount_On_Each_Quantity__c){
                    if(coupon.Ecom_Coupon_Type__c == 'Absolute'){
                        discountValue = (((eachCartitem.ccrz__SubAmount__c)/(totalCartAmnt))*(coupon.Ecom_Discount_Amount__c)).setScale(2);
                    }else if(coupon.Ecom_Coupon_Type__c == 'Percentage'){
                        discountValue = (eachCartitem.ccrz__SubAmount__c * (coupon.Ecom_Discount_Amount__c/100)).setScale(2);
                    }
                }else{
                    if(coupon.Ecom_Coupon_Type__c == 'Absolute'){
                        discountValue =  (eachCartitem.ccrz__Quantity__c * coupon.Ecom_Discount_Amount__c).setScale(2);
                        //discountValue = (((eachCartitem.ccrz__SubAmount__c)/(totalCartAmnt))*(coupon.Ecom_Discount_Amount__c)).setScale(2);
                    }else if(coupon.Ecom_Coupon_Type__c == 'Percentage'){
                        discountValue =  (eachCartitem.ccrz__SubAmount__c * (coupon.Ecom_Discount_Amount__c/100)).setScale(2);
                        //discountValue = (eachCartitem.ccrz__SubAmount__c * (coupon.Ecom_Discount_Amount__c/100)).setScale(2);
                    }
                }
                System.debug('discountValue======'+discountValue);
                totalDis = totalDis + discountValue;
                double NewSubAmountforCartItem = eachCartitem.ccrz__SubAmount__c - discountValue;
                eachCartitem.ccrz__AbsoluteDiscount__c = discountValue;
                eachCartitem.ccrz__SubAmount__c = NewSubAmountforCartItem;
                updatedCartItems.add(eachCartitem);
            }
        }
        //CECI - 1207 - Added "!coupon.Ecom_Discount_On_Each_Quantity__c" to bypass below code if Ecom_Discount_On_Each_Quantity__c is checked - Abhilash - Start
        if(!coupon.Ecom_Discount_On_Each_Quantity__c && coupon.Ecom_Discount_Amount__c != totalDis && coupon.Ecom_Coupon_Type__c == 'Absolute'  && coupon.Ecom_Type__c == 'Coupon'){
            if(coupon.Ecom_Discount_Amount__c > totalDis){
                updatedCartItems[0].ccrz__AbsoluteDiscount__c = (coupon.Ecom_Discount_Amount__c - totalDis) + updatedCartItems[0].ccrz__AbsoluteDiscount__c;
                updatedCartItems[0].ccrz__SubAmount__c = updatedCartItems[0].ccrz__SubAmount__c - (coupon.Ecom_Discount_Amount__c - totalDis);
            }else if(coupon.Ecom_Discount_Amount__c < totalDis){
                updatedCartItems[0].ccrz__AbsoluteDiscount__c =   updatedCartItems[0].ccrz__AbsoluteDiscount__c - (totalDis - coupon.Ecom_Discount_Amount__c );
                updatedCartItems[0].ccrz__SubAmount__c = updatedCartItems[0].ccrz__SubAmount__c + (totalDis - coupon.Ecom_Discount_Amount__c );
            }
            
        }
        //CECI - 1207 - Abhilash - End
        return updatedCartItems;
    }
    // Calculation of Discount Amount on Cart, Rule Type- Cart Total
    private static String buildUpdatedCartItemList(Ecom_Coupon__c coupon, Decimal totalCartAmnt, List<ccrz__E_CartItem__c> cartItems, Set<String> exclusionProductIds,String cartId){
        List<ccrz__E_CartItem__c> updatedCartItems = new List<ccrz__E_CartItem__c>();
        Decimal discountValue = 0.00;
        Decimal totalDis = 0.00;
         Decimal appliedDiscount = 0.00;
        for(ccrz__E_CartItem__c eachCartitem : cartItems){
            if(exclusionProductIds.size() > 0){
                System.debug('exclusionProductIds='+exclusionProductIds);
                if(!exclusionProductIds.contains(eachCartitem.ccrz__Product__c)){
                    if(!coupon.Ecom_Discount_On_Each_Quantity__c){
                        if(coupon.Ecom_Coupon_Type__c == 'Absolute' && coupon.Ecom_Type__c == 'Coupon'){ // added for gift card
                            discountValue = (((eachCartitem.ccrz__SubAmount__c)/(totalCartAmnt))*(coupon.Ecom_Discount_Amount__c)).setScale(2);
                        }else if(coupon.Ecom_Coupon_Type__c == 'Percentage'  && coupon.Ecom_Type__c == 'Coupon'){
                            discountValue = (eachCartitem.ccrz__SubAmount__c * (coupon.Ecom_Discount_Amount__c/100)).setScale(2);
                        }
                    }else{
                        if(coupon.Ecom_Coupon_Type__c == 'Absolute'  && coupon.Ecom_Type__c == 'Coupon'){
                            discountValue =  (eachCartitem.ccrz__Quantity__c * coupon.Ecom_Discount_Amount__c).setScale(2);
                        }else if(coupon.Ecom_Coupon_Type__c == 'Percentage'  && coupon.Ecom_Type__c == 'Coupon'){
                            discountValue =  (eachCartitem.ccrz__SubAmount__c * (coupon.Ecom_Discount_Amount__c/100)).setScale(2);
                        }
                    }
                    totalDis = totalDis + discountValue;
                    double NewSubAmountforCartItem = eachCartitem.ccrz__SubAmount__c - discountValue;
                    eachCartitem.ccrz__AbsoluteDiscount__c = discountValue;
                    eachCartitem.ccrz__SubAmount__c = NewSubAmountforCartItem;
                    updatedCartItems.add(eachCartitem);
                }
            }else{
                System.debug('======ELSE CONDITION=====');
                if(!coupon.Ecom_Discount_On_Each_Quantity__c){
                    if(coupon.Ecom_Coupon_Type__c == 'Absolute'  && coupon.Ecom_Type__c == 'Coupon' ){
                        discountValue = (((eachCartitem.ccrz__SubAmount__c)/(totalCartAmnt))*(coupon.Ecom_Discount_Amount__c)).setScale(2);
                    }else if(coupon.Ecom_Coupon_Type__c == 'Percentage'  && coupon.Ecom_Type__c == 'Coupon'){
                        System.debug('===Percentage====');
                        discountValue = (eachCartitem.ccrz__SubAmount__c * (coupon.Ecom_Discount_Amount__c/100)).setScale(2);
                        System.debug('discountValue===='+discountValue);
                    } /*else if(coupon.Ecom_Type__c == 'Gift Card'){  // Added for Gift card logic
                        System.debug('Entering Gift card Case');
                       
                        if(totalCartAmnt > coupon.Ecom_Gift_Card_Remaining_Balance__c){
                            appliedDiscount =  coupon.Ecom_Gift_Card_Remaining_Balance__c;
                        }else{
                            appliedDiscount =   totalCartAmnt;
                           
                        }
                         discountValue = (((eachCartitem.ccrz__SubAmount__c)/(totalCartAmnt))*(appliedDiscount)).setScale(2);
                         System.debug('discountValue gift=='+discountValue);
                    }*/
                }else{
                    if(coupon.Ecom_Coupon_Type__c == 'Absolute'  && coupon.Ecom_Type__c == 'Coupon'){
                        discountValue =  (eachCartitem.ccrz__Quantity__c * coupon.Ecom_Discount_Amount__c).setScale(2);
                    }else if(coupon.Ecom_Coupon_Type__c == 'Percentage'  && coupon.Ecom_Type__c == 'Coupon'){
                        discountValue =  (eachCartitem.ccrz__SubAmount__c * (coupon.Ecom_Discount_Amount__c/100)).setScale(2);
                    }
                }
                
                System.debug('SubAmount====='+eachCartitem.ccrz__SubAmount__c);
                System.debug('discount====='+discountValue);
                totalDis = totalDis + discountValue;
                // discountValue = (((eachCartitem.ccrz__SubAmount__c)/(totalCartAmnt))*(coupon.Ecom_Discount_Amount__c)).setScale(2);
                double NewSubAmountforCartItem = eachCartitem.ccrz__SubAmount__c - discountValue;
                System.debug('NewSubAmountforCartItem====='+NewSubAmountforCartItem);
                eachCartitem.ccrz__AbsoluteDiscount__c = discountValue;
                eachCartitem.ccrz__SubAmount__c = NewSubAmountforCartItem;
                updatedCartItems.add(eachCartitem);
            }
            
        }
        //CECI - 1207 - Added "!coupon.Ecom_Discount_On_Each_Quantity__c" to bypass below code if Ecom_Discount_On_Each_Quantity__c is checked - Abhilash - Start
        if(!coupon.Ecom_Discount_On_Each_Quantity__c && coupon.Ecom_Discount_Amount__c != totalDis && coupon.Ecom_Coupon_Type__c == 'Absolute'  && coupon.Ecom_Type__c == 'Coupon'){
            if(coupon.Ecom_Discount_Amount__c > totalDis){
                updatedCartItems[0].ccrz__AbsoluteDiscount__c = (coupon.Ecom_Discount_Amount__c - totalDis) + updatedCartItems[0].ccrz__AbsoluteDiscount__c;
                updatedCartItems[0].ccrz__SubAmount__c = updatedCartItems[0].ccrz__SubAmount__c - (coupon.Ecom_Discount_Amount__c - totalDis);
            }else if(coupon.Ecom_Discount_Amount__c < totalDis){
                updatedCartItems[0].ccrz__AbsoluteDiscount__c =   updatedCartItems[0].ccrz__AbsoluteDiscount__c - (totalDis - coupon.Ecom_Discount_Amount__c );
                updatedCartItems[0].ccrz__SubAmount__c = updatedCartItems[0].ccrz__SubAmount__c + (totalDis - coupon.Ecom_Discount_Amount__c );
            }
            
        }
        //CECI - 1207 - Abhilash - End
        if(updatedCartItems.size() > 0){
            couponAppliedMsg = updateCartItemsDataWithDiscount(updatedCartItems,coupon,cartId);
          /*  if(coupon.Ecom_Type__c == 'Gift Card'){ // logic for gift card
          updateGiftCard(coupon,appliedDiscount);
            }*/
        }
        return couponAppliedMsg;
    }    
    
    
    
    // get the Total Amount of Cart after Exclusion
    public static Decimal getUpdatedCartAmnt(List<ccrz__E_CartItem__c> cartItems,set<String> coupnPIds){
        Map<String,Decimal> cartitemMap = new Map<String,Decimal>();
        if(cartItems.size()>0){
            for(ccrz__E_CartItem__c eachCartitem : cartItems){
                cartitemMap.put(eachCartitem.ccrz__Product__c,eachCartitem.ccrz__SubAmount__c);
            }
        }
        system.debug('cartitemMap ' + cartitemMap);
        Decimal TotalAmntExclusion = 0.00;
        System.debug('coupnPIds size==='+coupnPIds);
        if(coupnPIds != null){
            for(String pId : coupnPIds){
                if(cartitemMap.containskey(pId)){
                    TotalAmntExclusion += cartitemMap.get(pId);
                }
            }  
        }
        system.debug('TotalAmntExclusion ' + TotalAmntExclusion);
        System.debug('ShipAmount = '+cartItems[0].ccrz__Cart__r.ccrz__ShipAmount__c);
        System.debug('Tax Amoiunt = '+cartItems[0].ccrz__Cart__r.ccrz__TaxAmount__c);
        Decimal shipAmount = cartItems[0].ccrz__Cart__r.ccrz__ShipAmount__c;
        Decimal taxAmount = cartItems[0].ccrz__Cart__r.ccrz__TaxAmount__c;
        Decimal shipAndTaxAmt = 0.00;
        if(shipAmount == null){
            shipAmount = 0.00;
        }
        if(taxAmount == null){
            taxAmount = 0.00;
        }
         shipAndTaxAmt = shipAmount + taxAmount;  // Promotion Changes
        Decimal totalCartAmnt = cartItems[0].ccrz__Cart__r.ccrz__TotalAmount__c - (TotalAmntExclusion + shipAndTaxAmt);
        System.debug('totalCartAmnt=='+totalCartAmnt);
        return totalCartAmnt;
    }
    
    //-------Customer Groups Can be - Abandoned Cart, Email Subscribers etc-------
    public static String getAbandonedCartIds(String cartId, Ecom_Coupon__c coupon){
        Boolean isApplicable = false;
        if(coupon.Ecom_Customer_Groups__c.Contains('Abandoned Cart') && isApplicable == false){
            System.debug('======True=====');
            List<ccrz__E_Cart__c> cartObj = new List<ccrz__E_Cart__c>();
            cartObj = [SELECT Id,createdDate FROM  ccrz__E_Cart__c WHERE Id =: cartId AND ccrz__CartStatus__c = 'Open' AND ccrz__ActiveCart__c = true];
            Long cartCreatedDateTime = cartObj[0].CreatedDate.getTime();
            System.debug('cartCreatedDateTime===='+cartCreatedDateTime);
            Long milliseconds = DateTime.now().getTime() - cartCreatedDateTime;
            Long seconds = milliseconds / 1000;
            Long minutes = seconds / 60;
            Long hours = minutes / 60;
            System.debug('hours==='+hours);
            Long days = hours / 24;
            if(hours >= 8){//custom label
                isApplicable = true;
            }
        }
        if(coupon.Ecom_Customer_Groups__c.Contains('New') && isApplicable == false){
            List<ccrz__E_Order__c> orderObj = new List<ccrz__E_Order__c>();
            User currentUser = [SELECT Id,ContactId FROM User WHERE id =: UserInfo.getUserId()];
            orderObj = [Select Id,ccrz__Contact__c from ccrz__E_Order__c where ccrz__Contact__c =: currentUser.ContactId];
            if(orderObj.isEmpty()){
                isApplicable = true;
            }
        }
        if(coupon.Ecom_Customer_Groups__c.Contains('Returning') && isApplicable == false){
            List<ccrz__E_Order__c> orderObj = new List<ccrz__E_Order__c>();
            User currentUser = [SELECT Id,ContactId FROM User WHERE id =: UserInfo.getUserId()];
            orderObj = [Select Id,ccrz__Contact__c from ccrz__E_Order__c where ccrz__Contact__c =: currentUser.ContactId];
            if(orderObj.size() >= 2){
                isApplicable = true;
            }
        }
        if(coupon.Ecom_Customer_Groups__c.Contains('Email Subscribers') && isApplicable == false){
            List<Contact> UserContact = new List<Contact>();
            User currentUser = [SELECT Id,ContactId FROM User WHERE id =: UserInfo.getUserId()];
            UserContact = [select id,Ecom_Email_Subscriber__c FROM Contact Where Id =:currentUser.ContactId AND Ecom_Email_Subscriber__c = true];
            if(!UserContact.isEmpty()){
                isApplicable = true;
            }
        }
        if(isApplicable){
            if(coupon.Ecom_Rule_Type__c == 'Cart Total'){
                couponAppliedMsg = getCartTotalCoupon(cartId,coupon);
            }else if(coupon.Ecom_Rule_Type__c == 'General' || coupon.Ecom_Rule_Type__c == 'Shipping'){
                couponAppliedMsg = getCouponInclusionExclusionIds(cartId,coupon);
            }
        }
        
        return couponAppliedMsg;
    }
    //checking the User if the User already availed the offer 
    public static boolean getUserAlreadyAppliedCoupon(Ecom_Coupon__c coupon,String cartId){
        if(UserInfo.getUserType() != 'Guest'){
            List<Ecom_Cart_Coupon__c> cartCouponList = new List<Ecom_Cart_Coupon__c>();
            List<ccrz__E_Cart__c > cartList = new List<ccrz__E_Cart__c >();
            List<String> cartIds = new List<String>();
            Integer couponCount = 0;
            Integer maxNoUse = 0;
            boolean isInclued = false;
            List<String> cartCouponIdList = new List<String>();
            
            User currentUser = [SELECT Id,  CompanyName,ContactId FROM User WHERE id =: UserInfo.getUserId()];
            Contact currentUserContact = new Contact();
            
            cartList = [select id, ccrz__Contact__c from ccrz__E_Cart__c where ccrz__Contact__c =: currentUser.ContactId];
            for(ccrz__E_Cart__c cartObj : cartList){
                cartIds.add(cartObj.id);
            }
            cartCouponList = [SELECT Id, CC_Cart__c,Ecom_Coupon__c FROM Ecom_Cart_Coupon__c WHERE CC_Cart__c IN: cartIds];
            for(Ecom_Cart_Coupon__c cartCouponObj : cartCouponList){
                cartCouponIdList.add(cartCouponObj.Ecom_Coupon__c);
            }
            system.debug('coupon.Ecom_Coupon_Contacts__r ' + coupon.Ecom_Coupon_Contacts__r);
            if(coupon.Ecom_Coupon_Contacts__r.size() > 0){
                
                for(Ecom_Coupon_Contact__c contactObj : coupon.Ecom_Coupon_Contacts__r){
                    system.debug('contactObj.Ecom_Max_Number_Of_Use__c ' + contactObj.Ecom_Max_Number_Of_Use__c);
                    system.debug('contactObj.Contact__c ' + contactObj.Contact__c);
                    system.debug('currentUser.ContactId ' + currentUser.ContactId);
                    system.debug('cartCouponIdList.contains(coupon.Id) ' + cartCouponIdList.contains(coupon.Id));
                    if(contactObj.Ecom_Coupon_Contact_Type__c == 'Inclusion'){
                        if(contactObj.Contact__c  == currentUser.ContactId && contactObj.Ecom_Max_Number_Of_Use__c != null){
                            isInclued = true;
                            maxNoUse = Integer.valueOf(contactObj.Ecom_Max_Number_Of_Use__c);
                            break;
                        }else if (contactObj.Ecom_Max_Number_Of_Use__c == null && contactObj.Contact__c  == currentUser.ContactId){
                            if(cartCouponIdList.contains(coupon.Id)){
                                return true;
                            }else{
                                return false;
                            }
                            //system.debug('in else if');
                            // return true;
                        }
                    }
                }
                if(isInclued){
                    for(Ecom_Cart_Coupon__c cartCouponObj : cartCouponList){
                        if(cartCouponObj.Ecom_Coupon__c == coupon.Id){
                            couponCount ++;
                        }
                    }
                }
                if(couponCount >= maxNoUse){
                    return true;
                }
            }else if(cartCouponIdList.contains(coupon.Id)){
                return true;
            }
        }
        return false;
    }
    // calculate the shipping weight
    private static Decimal calculateFreeShippingWeight(Set<String> inclusionIds,Set<String> exclusionProductIds,String cartId){
        Map<String,Decimal> productQuantityMap = new Map<String,Decimal>();
        List<ccrz__E_CartItem__c> cartItemObj = new List<ccrz__E_CartItem__c>();
        Set<String> incIds = new Set<String>();
        cartItemObj =[SELECT ID,ccrz__Product__c,ccrz__Product__r.dbu_Crate_Engine__c,ccrz__Quantity__c,dbu_isShipTo__c FROM ccrz__E_CartItem__c  WHERE dbu_isShipTo__c = true AND ccrz__Cart__c =:cartId];
        
        for(ccrz__E_CartItem__c obj : cartItemObj){
            system.debug('dbu_Crate_Engine__c======= ' + obj.ccrz__Product__r.dbu_Crate_Engine__c);
            System.debug('exclutions====='+exclusionProductIds.contains(obj.ccrz__Product__c));
            if(!obj.ccrz__Product__r.dbu_Crate_Engine__c && !exclusionProductIds.contains(obj.ccrz__Product__c)){
                productQuantityMap.put(obj.ccrz__Product__c,obj.ccrz__Quantity__c);
            }
            
            if(inclusionIds.isEmpty()){
                incIds.addAll(productQuantityMap.keySet());
            }else{
                incIds.addAll(inclusionIds);
            }
            
        }
        list<ccrz__E_ProductSpec__c > productSpecList = [select  id,ccrz__Spec__r.Name,ccrz__SpecValue__c,ccrz__Product__c from ccrz__E_ProductSpec__c where ccrz__Product__c IN :incIds AND ccrz__Spec__r.Name = 'Shipment Weight' AND ccrz__Product__r.dbu_Crate_Engine__c = false];
        decimal weight =0.00;
        if(productSpecList != NULL){
            for(ccrz__E_ProductSpec__c obj: productSpecList){
                if(productQuantityMap.containsKey(obj.ccrz__Product__c)){
                    system.debug('weight ' + obj.ccrz__SpecValue__c + 'quantuty ' + productQuantityMap.get(obj.ccrz__Product__c));
                    Decimal weightValue = 0.00;
                    if(obj.ccrz__SpecValue__c.contains('')){
                        weightValue = Decimal.valueOf(obj.ccrz__SpecValue__c.substringBefore(' '));
                    }else{
                        weightValue = Decimal.valueOf(obj.ccrz__SpecValue__c);
                    }
                    if(productQuantityMap.get(obj.ccrz__Product__c) != Null){
                        weightValue = weightValue * productQuantityMap.get(obj.ccrz__Product__c);
                    }
                    System.debug('weightValue ' + weightValue);
                    weight = weight + weightValue;
                }
            }
        }
        system.debug('Weight total ' + weight);
        return weight;
    }
    // BOGO
 /*   private static void getBOGOTypeCoupon(Ecom_Coupon__c coupon,String cartId){
        List<ccrz__E_CartItem__c> cartItems = new List<ccrz__E_CartItem__c>();
        cartItems  = getCartItems(cartId);
        Map<String,ccrz__E_CartItem__c> cartProductMap = new Map<String,ccrz__E_CartItem__c>();
        List<dbu_CouponProductUtility.BogoProducts> bogoProductsList = new List<dbu_CouponProductUtility.BogoProducts>();
        List<dbu_CouponProductUtility.BogoProducts> bogoProductsDataList = new List<dbu_CouponProductUtility.BogoProducts>();
       // bogoProductsList = dbu_CouponProductUtility.getBOGOProducts(coupon.Ecom_Coupon_Products__r);
      //  bogoProductsList.addAll(dbu_CouponCategoryUtility.getBOGOCategories(coupon.Ecom_Coupon_Categories__r,cartItems));
       // system.debug('bogoProductsList ' + bogoProductsList);
        for(ccrz__E_CartItem__c cartItem : cartItems){
            cartProductMap.put(cartItem.ccrz__Product__c,cartItem);
        }
        List<ccrz__E_CartItem__c> updatedCartItemList = new List<ccrz__E_CartItem__c>();
        for(dbu_CouponProductUtility.BogoProducts bogoProducts : bogoProductsList){
            if(cartProductMap.containskey(bogoProducts.sourceProductId)&& cartProductMap.containskey(bogoProducts.targetProductId)&&
               cartProductMap.get(bogoProducts.sourceProductId).ccrz__Quantity__c >= bogoProducts.sourceProductQty &&
               cartProductMap.get(bogoProducts.targetProductId).ccrz__Quantity__c >= bogoProducts.targetProductQty && bogoProducts.productCartAmnt == null){
                   
                   ccrz__E_CartItem__c cartItem = cartProductMap.get(bogoProducts.targetProductId);
                   if(coupon.Ecom_Coupon_Type__c == 'Absolute'){
                       cartItem.ccrz__SubAmount__c = (cartItem.ccrz__SubAmount__c - bogoProducts.discount).setScale(2);
                       cartItem.ccrz__AbsoluteDiscount__c =  bogoProducts.discount;
                   }else if(coupon.Ecom_Coupon_Type__c == 'Percentage'){
                       Decimal discount = ((cartItem.ccrz__SubAmount__c * bogoProducts.discount) / 100).setScale(2);
                       cartItem.ccrz__SubAmount__c = cartItem.ccrz__SubAmount__c -  discount;
                       cartItem.ccrz__AbsoluteDiscount__c = discount;
                   }else if(coupon.Ecom_Coupon_Type__c == 'Free Products'){
                       cartItem.ccrz__AbsoluteDiscount__c = cartItem.ccrz__SubAmount__c;
                       cartItem.ccrz__SubAmount__c = 0.00;
                   }
                   
                   updatedCartItemList.add(cartItem);
               }else if(cartProductMap.containskey(bogoProducts.sourceProductId)&& cartProductMap.containskey(bogoProducts.targetProductId)&&
                        (cartProductMap.get(bogoProducts.sourceProductId).ccrz__Quantity__c >= bogoProducts.sourceProductQty || bogoProducts.sourceProductQty == null) &&
                        cartProductMap.get(bogoProducts.targetProductId).ccrz__Quantity__c >= bogoProducts.targetProductQty && bogoProducts.productCartAmnt != null){
                            ccrz__E_CartItem__c sourceCartItem = cartProductMap.get(bogoProducts.sourceProductId);
                            if(sourceCartItem.ccrz__Price__c * sourceCartItem.ccrz__Quantity__c >= bogoProducts.productCartAmnt){
                                ccrz__E_CartItem__c cartItem = cartProductMap.get(bogoProducts.targetProductId);
                                if(coupon.Ecom_Coupon_Type__c == 'Absolute'){
                                    cartItem.ccrz__SubAmount__c = (cartItem.ccrz__SubAmount__c - bogoProducts.discount).setScale(2);
                                    cartItem.ccrz__AbsoluteDiscount__c =  bogoProducts.discount;
                                }else if(coupon.Ecom_Coupon_Type__c == 'Percentage'){
                                    Decimal totalAmount  = bogoProducts.targetProductQty * cartItem.ccrz__Price__c;
                                    Decimal discount = ((totalAmount * bogoProducts.discount) / 100).setScale(2);
                                    cartItem.ccrz__SubAmount__c = cartItem.ccrz__SubAmount__c -  discount;
                                    cartItem.ccrz__AbsoluteDiscount__c = discount;
                                }else if(coupon.Ecom_Coupon_Type__c == 'Free Products'){
                                    cartItem.ccrz__AbsoluteDiscount__c = cartItem.ccrz__SubAmount__c;
                                    cartItem.ccrz__SubAmount__c = 0.00;
                                }
                                updatedCartItemList.add(cartItem);
                            }
                            
                        }
        }
        if(updatedCartItemList.size() > 0){
            updateCartItemsDataWithDiscount(updatedCartItemList,coupon,cartId);
        }
    }*/
    
    // update the CartItem Objects
    private static String updateCartItemsDataWithDiscount(List<ccrz__E_CartItem__c> cartItems,Ecom_Coupon__c coupon,String cartId){
        Boolean isCouponApplied = false;
        try{
            Database.SaveResult[] srList = Database.update(cartItems, true);
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    couponAppliedMsg = System.Label.dbu_Coupon_Success;   
                    isCouponApplied = true;
                    System.debug('updated successfully');
                }
                else {
                    couponAppliedMsg = 'Error';   
                    for(Database.Error err : sr.getErrors()) {
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
        if(isCouponApplied){
            //------- Call to create Ecom Cart Coupon Record----------
            createEcomCartCoupon(coupon,cartId);
        }
        return couponAppliedMsg;
    }
    
    // Create Ecom Cart Coupon
    private static void createEcomCartCoupon(Ecom_Coupon__c coupon,String cartId){
        List<Ecom_Cart_Coupon__c>  ecomCartCouponList = new List<Ecom_Cart_Coupon__c>();
        Ecom_Cart_Coupon__c  ecomCartCouponObj = new Ecom_Cart_Coupon__c();
        ecomCartCouponObj.CC_Cart__c = cartId;
        ecomCartCouponObj.Ecom_Coupon__c = coupon.Id;
        try{
            insert ecomCartCouponObj;
            ecomCartCouponList = [SELECT Id, CC_Cart__c,Ecom_Coupon__c FROM Ecom_Cart_Coupon__c WHERE Ecom_Coupon__c =: coupon.Id];
            coupon.Ecom_Coupon_Used__c = ecomCartCouponList.size();
            update coupon;
        }catch(Exception e){
            system.debug('Exception while Creating Ecom Cart Coupon > '  + e.getLineNumber() +' '+ e.getMessage()+' '+ e.getTypeName()+' '+e.getCause());
        }
    }
    
    // Gift cart logic---no need to use this 
 /*   public static String applyGiftCard(String cartId, Ecom_Coupon__c coupon){
        Set<String> exclusionProductIds = new Set<String>();
        List<ccrz__E_CartItem__c> cartItems = getCartItems(cartId);
        if((coupon.Ecom_Store__c.contains('United States') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'US') ||
           (coupon.Ecom_Store__c.contains('Canada') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'EN') || 
           (coupon.Ecom_Store__c.contains('Canada') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'FR')){
               
               for(ccrz__E_CartItem__c cartItem : cartItems){
                   if(cartItem.ccrz__Product__r.dbu_Has_Core_Child__c && cartItem.ccrz__Product__r.dbu_Has_Core_Charge__c){
                       exclusionProductIds.add(cartItem.ccrz__Product__c);
                   }
               }
               Decimal totalCartAmnt = getUpdatedCartAmnt(cartItems,exclusionProductIds);
               System.debug('totalCartAmnt Gift Card==='+totalCartAmnt);
               if(coupon.Ecom_Gift_Card_Remaining_Balance__c > 0.00){
                   couponAppliedMsg =  buildUpdatedCartItemList(coupon,totalCartAmnt,cartItems,exclusionProductIds,cartId);
               }else{
                   couponAppliedMsg = 'Insufficient Balance in Gift Card';
               }               
           }
        
        return couponAppliedMsg;
    }*/
    
  /*  public static void updateGiftCard(Ecom_Coupon__c coupon, Decimal usedAmount){
        coupon.Ecom_Used_Balance__c = usedAmount;
        update coupon;
    }*/
    
   /* public static String applyGiftCardNew(String cartId, Ecom_Coupon__c coupon){
        Decimal usedAmount = 0.00;
        List<ccrz__E_CartItem__c> cartItems = getCartItems(cartId);
        if((coupon.Ecom_Store__c.contains('United States') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'US') ||
           (coupon.Ecom_Store__c.contains('Canada') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'EN') || 
           (coupon.Ecom_Store__c.contains('Canada') && cartItems[0].ccrz__Cart__r.dbu_storeLanguage__c == 'FR')){
               Decimal totalCartAmount = cartItems[0].ccrz__Cart__r.ccrz__TotalAmount__c;
               Decimal rollupAmount = cartItems[0].ccrz__Cart__r.dbu_Total_Gift_Card_Amount__c;
               System.debug('totalCartAmount==='+totalCartAmount);
                System.debug('rollupAmount==='+rollupAmount);
               System.debug('remaining balance==='+coupon.Ecom_Gift_Card_Remaining_Balance__c);
               if(coupon.Ecom_Gift_Card_Remaining_Balance__c >=  totalCartAmount){
                     if(rollupAmount != 0.00){
                       Decimal amt = totalCartAmount - rollupAmount;
                       usedAmount = amt;
                   }else{
                       usedAmount = totalCartAmount;
                   }
               }else if(coupon.Ecom_Gift_Card_Remaining_Balance__c <  totalCartAmount && coupon.Ecom_Gift_Card_Remaining_Balance__c != 0.00){
                    if(rollupAmount != 0.00){
                       Decimal amt = totalCartAmount - rollupAmount;
                        if(amt >= coupon.Ecom_Gift_Card_Remaining_Balance__c){
                            usedAmount = coupon.Ecom_Gift_Card_Remaining_Balance__c;
                        }else{
                            usedAmount = amt;
                        }
                       
                   }else{
                       usedAmount = coupon.Ecom_Gift_Card_Remaining_Balance__c;
                   }
                 
               }else if(coupon.Ecom_Gift_Card_Remaining_Balance__c == 0.00){
                   System.debug('==LOw balance==='+coupon.Ecom_Gift_Card_Remaining_Balance__c);
                   couponAppliedMsg =  'Insufficient Balance in Gift Card';
                   return couponAppliedMsg;
               }
               System.debug('usedAmount==='+usedAmount);
              couponAppliedMsg = createEcomGiftCard(cartId,coupon,usedAmount);
           }
        return couponAppliedMsg;
    }
    
    public static String createEcomGiftCard(String cartId, Ecom_Coupon__c coupon,Decimal usedAmount){
        try {
            Ecom_Gift_Card__c giftCardObj = new Ecom_Gift_Card__c();
            giftCardObj.CC_Cart__c = cartId;
            giftCardObj.Ecom_Gift_Card_Coupon__c = coupon.Id;
            giftCardObj.Applied_Amount__c = usedAmount;
            insert giftCardObj;
            couponAppliedMsg = 'Gift Card Applied Successfully';   
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            couponAppliedMsg = e.getMessage();
        }
        return couponAppliedMsg;
    }*/
    
}