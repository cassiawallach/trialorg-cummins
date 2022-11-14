public without sharing class dbu_CouponCtrl {
   /* @Auraenabled(cacheable = true)
    public static List<boolean> couponVerified(String couponData){
        return new List<boolean>();
    }
    @Auraenabled
    public static Boolean updateCartwithCouponDetails(Id CartId, string couponCode)
    {
        return true;
    }
    
    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> fetchLstCartItemsByCartIdAfterCoupon(String cartId)
    {
        return new List<dbu_CCCartApiResponseWrapper>();
    }
    @AuraEnabled
    public static Boolean removeAppliedCoupon(String CartIdRmv)
    {
        return true;
    }*/
    
    @Auraenabled(cacheable = true)
    public static List<boolean> couponVerified(String couponData){
        system.debug('coming to cls' +couponData);
        List<Boolean> couponVerifiedList = new List<Boolean>();
        Boolean validCouponFrmCC = false;
        boolean inValidCouponFrmCC = false;
        
        Map<String, Object> FetchInputData = new Map<String, Object>{
            ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,
                ccrz.ccApiCoupon.CODES => new Set<String>{couponData},
                    ccrz.ccApiCoupon.ISENABLED => true,
                    ccrz.ccApiCoupon.STOREFRONT => 'CSSNAStore'    
                    };
                        
                        
                        // ################ FIRE COUPON API FETCH METHOD ######################################################   
                        try{
                            Map<String, Object> CouponFetchOutPutData = ccrz.ccApiCoupon.fetch(FetchInputData);  
                            system.debug('CouponFetchOutPutData >>> ' + CouponFetchOutPutData);
                            if(!((List<Map<String, Object>>)CouponFetchOutPutData.get(ccrz.ccApiCoupon.COUPONLIST)).isEmpty()){
                                validCouponFrmCC = true;
                                if(validCouponFrmCC == true){
                                    inValidCouponFrmCC = false;
                                }
                                List<Map<String, Object>> CouponList = (List<Map<String, Object>>)CouponFetchOutPutData.get(ccrz.ccApiCoupon.COUPONLIST);    
                                system.debug('Coupon SFID>>> ' + (string)CouponList[0].get('sfid'));   
                                couponVerifiedList.add(validCouponFrmCC);
                                couponVerifiedList.add(inValidCouponFrmCC);
                            }else{
                                system.debug('validCouponFrmCCin false con' +validCouponFrmCC);

                                inValidCouponFrmCC = true;
                                validCouponFrmCC = false;
                                couponVerifiedList.add(validCouponFrmCC);
                                couponVerifiedList.add(inValidCouponFrmCC);

                            }
                            system.debug('validCouponFrmCC >>> '+ validCouponFrmCC);
                            system.debug('inValidCouponFrmCC>>' +inValidCouponFrmCC);
                            system.debug('booleanlist' +couponVerifiedList);
                        }catch(Exception e){
                            system.debug(e);
                        }
        return couponVerifiedList;
    }
    
   @Auraenabled
    public static Boolean updateCartwithCouponDetails(Id CartId, string couponCode){
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
    
      

    @AuraEnabled
    public static List<dbu_CCCartApiResponseWrapper> fetchLstCartItemsByCartIdAfterCoupon(String cartId){
       
       //return dbu_CallCCCartApi.fetchCartItemsByCartId(cartId);
       //return dbu_CartCtrl.fetchLstCartItemsByCartId(cartId);
       return dbu_CartCtrl.fetchLstCartItemsByCartId(cartId, 'cart');
    }
    
    @AuraEnabled
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