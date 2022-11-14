public without sharing class dbu_CouponServiceHandler{
    @AuraEnabled
    public static CouponWrapper updateCartwithCouponDetails(Id cartId, String couponCode){
        List<Ecom_Coupon__c> couponData;
        List<ccrz__E_CartItem__c> cartItems;
        String couponMsg = System.Label.dbu_Coupon_Invalid;
        CouponWrapper couponWrapper = new CouponWrapper();
        String CouponName =  couponCode.deleteWhitespace();
        System.debug('cartId == ' + cartId);
        // Coupon Data
        couponData = [SELECT Id,
                      Ecom_Active__c,
                      Ecom_Gift_Card_Balance__c,
                    //  Ecom_Used_Balance__c,
                      Ecom_Gift_Card_Remaining_Balance__c,
                      Ecom_Min_Weight__c,
                      Ecom_Max_Weight__c,
                      Ecom_Coupon_Used__c,
                      Ecom_Coupon_Max_Usage__c,
                      Ecom_Type__c,
                      Ecom_Cart_Total_Amount__c,
                      Ecom_Coupon_Type__c,
                      Ecom_Min_Quantity__c,
                      CurrencyIsoCode,
                      Ecom_Include_All_Register_Customers__c,
                      Ecom_Include_Guest_Customers__c,
                      Ecom_Rule_Type__c,
                      Ecom_Start_Date__c,
                      Ecom_End_Date__c,
                      Ecom_Store__c,
                      Ecom_Discount_Amount__c,
                      Ecom_Customer_Groups__c,
                      Ecom_Discount_On_Each_Quantity__c,
                      (SELECT Id,Ecom_Source_Product__c,Ecom_Source_Quantity__c,Ecom_Target_Product__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Product_Type__c,Ecom_Product_Discount_Amount__c,Ecom_Product_Cart_Amount__c  FROM Ecom_Coupon_Products__r),
                      (SELECT Id, Ecom_Source_Category__c,Ecom_Target_Category__c,Ecom_Source_Quantity__c,Ecom_Target_Quantity__c,Ecom_Rule_Type__c,Ecom_Coupon_Category_Type__c,Ecom_Category_Discount_Amount__c,Ecom_Category_Cart_Amount__c FROM Ecom_Coupon_Categories__r),
                      (SELECT Id,Contact__c,Contact__r.Email,Ecom_Coupon_Contact_Type__c,Ecom_Coupon__c,Ecom_Max_Number_Of_Use__c FROM Ecom_Coupon_Contacts__r)
                      FROM Ecom_Coupon__c 
                      WHERE Name =:CouponName AND Ecom_Active__c = true];
        System.debug('couponData == '+ couponData);
        System.debug('couponData.size() == '+ couponData.size());
        if(couponData.size() == 0){
            couponWrapper.couponMsg = System.Label.dbu_Coupon_Invalid;
            couponWrapper.isCouponApplied = false;
            return couponWrapper;
        }
        if(couponData[0].Ecom_Coupon_Used__c >= couponData[0].Ecom_Coupon_Max_Usage__c){
            couponWrapper.couponMsg = System.Label.dbu_Coupon_Msg_CriteriaDidNotMatch;
            couponWrapper.isCouponApplied = false;
            return couponWrapper;
        }
        
        if(couponData.size()> 0 && couponData[0].Ecom_Type__c == 'Coupon'){
            if(couponData[0].Ecom_Start_Date__c <=  Datetime.now() && couponData[0].Ecom_End_Date__c >=  Datetime.now()){
                System.debug('inside date == ');
                // apllicable for all the products with exclusion
                if(couponData[0].Ecom_Rule_Type__c == 'Cart Total' &&
                   couponData[0].Ecom_Discount_Amount__c != null &&
                   cartId != null){
                       if(((couponData[0].Ecom_Include_All_Register_Customers__c == true && couponData[0].Ecom_Include_Guest_Customers__c == true) ||
                          (couponData[0].Ecom_Include_All_Register_Customers__c == true && couponData[0].Ecom_Include_Guest_Customers__c == false)) && 
                          couponData[0].Ecom_Customer_Groups__c == null){
                              couponMsg = dbu_CouponUtility.getCartTotalCoupon(cartId,couponData[0]);
                              
                          }else if(couponData[0].Ecom_Include_All_Register_Customers__c == false && couponData[0].Ecom_Include_Guest_Customers__c == true && couponData[0].Ecom_Customer_Groups__c == null){
                              couponMsg = dbu_CouponUtility.getCartTotalCouponGuest(cartId,couponData[0]);
                              
                          }else if(couponData[0].Ecom_Include_All_Register_Customers__c == false && couponData[0].Ecom_Include_Guest_Customers__c == false && couponData[0].Ecom_Customer_Groups__c == null){
                              couponMsg = dbu_CouponUtility.getCartTotalCouponIncludedCust(cartId,couponData[0]);
                          }
                   }
                if(couponData[0].Ecom_Rule_Type__c == 'General' &&
                   couponData[0].Ecom_Customer_Groups__c == null &&
                   couponData[0].Ecom_Discount_Amount__c != null &&
                   cartId != null){
                       couponMsg = dbu_CouponUtility.getGeneralTypeCoupon(cartId,couponData[0]);
                   }
                if(couponData[0].Ecom_Rule_Type__c == 'Shipping' &&
                   couponData[0].Ecom_Customer_Groups__c == null &&
                   cartId != null){
                       couponMsg = dbu_CouponUtility.getGeneralTypeCoupon(cartId,couponData[0]);
                   }
                if(couponData[0].Ecom_Rule_Type__c == 'Shipping' &&
                   couponData[0].Ecom_Customer_Groups__c != null &&
                   cartId != null && UserInfo.getUserType() != 'Guest'){
                       couponMsg = dbu_CouponUtility.getAbandonedCartIds(cartId,couponData[0]);
                   }
                
                 if(couponData[0].Ecom_Customer_Groups__c != null && UserInfo.getUserType() != 'Guest'){
                     System.debug('=======getAbandonedCartIds Method called========');
                              couponMsg = dbu_CouponUtility.getAbandonedCartIds(cartId,couponData[0]);
                     System.debug('couponMsg >>>>>>>>>>>>'+couponMsg);
                          }
                // BOGO
                if(couponData[0].Ecom_Rule_Type__c == 'BOGO' &&
                   couponData[0].Ecom_Customer_Groups__c == null &&
                   cartId != null){
                      // couponMsg = dbu_CouponUtility.getGeneralTypeCoupon(cartId,couponData[0]);// need to implement method
                   }
                couponWrapper = getCouponMessgage(couponMsg,couponWrapper);
            }else {
                couponWrapper.couponMsg = System.Label.dbu_Coupon_Expired;
                couponWrapper.isCouponApplied = false;
                return couponWrapper;
            }
        } /*else if(couponData.size()> 0 && couponData[0].Ecom_Type__c == 'Gift Card'){
            if((couponData[0].Ecom_Start_Date__c <=  Datetime.now() && couponData[0].Ecom_End_Date__c >=  Datetime.now())|| (couponData[0].Ecom_Start_Date__c <=  Datetime.now() && couponData[0].Ecom_End_Date__c == null)){
                 couponMsg = dbu_CouponUtility.applyGiftCardNew(cartId,couponData[0]);
            }
           else{
               System.debug('ELSE PART IN GIFT CARD');
                couponWrapper.couponMsg = System.Label.dbu_Gift_Cart_Expired;
                couponWrapper.isCouponApplied = false;
                return couponWrapper;
            }
            couponWrapper = getCouponMessgage(couponMsg,couponWrapper);
        }*/
        return couponWrapper;
    }
    @AuraEnabled
    public static Boolean removeAppliedCoupon(String CartIdRmv){
        Boolean isCouponRemoved = false;
        System.debug('CartIdRmv ' + CartIdRmv);
        ccrz__E_Cart__c cartObj = [SELECT Id,dbu_Free_Shipping__c FROM ccrz__E_Cart__c WHERE Id = : CartIdRmv];
        if(cartObj.dbu_Free_Shipping__c){
           cartObj.dbu_Free_Shipping__c = false;
            Decimal shipAmt = 0.00;
            update cartObj;
            shipAmt =  dbu_CheckOutCntrl.updateShippingAmountOnCart(true,CartIdRmv,'');
            //cartObj.ccrz__ShipAmount__c = shipAmt;
           
        }
        List<Ecom_Cart_Coupon__c> cartCoupon = [SELECT Id,Ecom_Coupon__r.Ecom_Coupon_Used__c FROM Ecom_Cart_Coupon__c WHERE CC_Cart__c =: CartIdRmv];
        System.debug('cartCoupon.size ' + cartCoupon.size());
        if(cartCoupon.size() > 0){
            Delete cartCoupon;
            System.debug('deleted');
            //=====Deleting Gift card if applied====
          /*  List<Ecom_Gift_Card__c> gcList = new List<Ecom_Gift_Card__c>();
            gcList = [SELECT Id FROM Ecom_Gift_Card__c WHERE CC_Cart__c =: CartIdRmv];
            if(gcList.size() > 0){
                Delete gcList;
            }*/
            //======================================
            if(cartCoupon[0].Ecom_Coupon__r.Ecom_Coupon_Used__c != null){
                Ecom_Coupon__c coupon = new Ecom_Coupon__c();
                coupon.id = cartCoupon[0].Ecom_Coupon__c;
                coupon.Ecom_Coupon_Used__c = cartCoupon[0].Ecom_Coupon__r.Ecom_Coupon_Used__c - 1;
                update coupon;
            }
            
            List<ccrz__E_CartItem__c> cartItems = new List<ccrz__E_CartItem__c>();
            
            cartItems = dbu_CouponUtility.getCartItems(CartIdRmv);
            for(ccrz__E_CartItem__c cartItemObj : cartItems){
                cartItemObj.ccrz__SubAmount__c = cartItemObj.ccrz__Quantity__c * cartItemObj.ccrz__Price__c;
                if(cartItemObj.ccrz__PercentDiscount__c != null || cartItemObj.ccrz__AbsoluteDiscount__c != null){
                    cartItemObj.ccrz__AbsoluteDiscount__c = null;
                    cartItemObj.ccrz__PercentDiscount__c = null; 
                    isCouponRemoved = true;
                }
            }
            update cartItems;
        }   
        return isCouponRemoved;
    }
    
    // ========Remove Gift card ====
   /*  @AuraEnabled
    public static Boolean removeAppliedGiftCard(String CartIdRmv, String giftCardCode){
        Boolean isDeleted = false;
        List<Ecom_Gift_Card__c> giftCardList = new List<Ecom_Gift_Card__c>();
        if(String.isEmpty(giftCardCode)){
            giftCardList = [SELECT Id FROM Ecom_Gift_Card__c WHERE CC_Cart__c =: CartIdRmv];
        }else{
            giftCardList = [SELECT Id FROM Ecom_Gift_Card__c WHERE CC_Cart__c =: CartIdRmv AND Ecom_Gift_Card_Coupon__r.Name =: giftCardCode];
        }
        try{
            if(giftCardList.size() > 0){
                delete giftCardList;
                isDeleted = true;
            }
             } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
           
        }
        return isDeleted;
    }*/
    // get message after coupon applied
    private static CouponWrapper getCouponMessgage(String couponMsg,CouponWrapper couponWrapper){
        couponWrapper.couponMsg = couponMsg;
        String couponMsgExpected = System.Label.dbu_Coupon_Success;
        if(couponMsg == couponMsgExpected || couponMsg == 'Gift Card Applied Successfully'){
            couponWrapper.isCouponApplied = true;
        }else{
            couponWrapper.isCouponApplied = false;
        }
        return couponWrapper;
    }
    public class CouponWrapper{
        @AuraEnabled
        public boolean isCouponApplied;
        @AuraEnabled
        public String couponMsg;
    }
}