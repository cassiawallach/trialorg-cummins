/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_api_PriceAdjustment implements ccrz.cc_if_PriceAdjustment {
    global static String HK_ID;
    global static String PARAM_CART;
    global static String PARAM_CARTBEAN;
    global static String PARAM_CARTITEMS;
    global static String PARAM_CURRENCYCODE;
    global static String PARAM_EXTRINSIC;
    global static String PARAM_STOREFRONT;
    global static String PARAM_USERID;
    global cc_api_PriceAdjustment() {

    }
    global virtual Map<String,Object> computePricingCart(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> computePricingReview(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_api_PriceAdjustment getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual List<ccrz__E_CartItem__c> setDiscount(List<ccrz__E_CartItem__c> cartItems, String currencyCode) {
        return null;
    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
global class failBeanMessage extends ccrz.cc_api_PriceAdjustment {
    global failBeanMessage() {

    }
    global override List<ccrz__E_CartItem__c> setDiscount(List<ccrz__E_CartItem__c> cartItems, String currencyCode) {
        return null;
    }
    global override Map<String,Object> setDiscount(Map<String,Object> inputData) {
        return null;
    }
}
global class one extends ccrz.cc_api_PriceAdjustment {
    global one() {

    }
    global override List<ccrz__E_CartItem__c> setDiscount(List<ccrz__E_CartItem__c> cartItems, String currencyCode) {
        return null;
    }
    global override Map<String,Object> setDiscount(Map<String,Object> inputData) {
        return null;
    }
}
global class qty extends ccrz.cc_api_PriceAdjustment {
    global qty() {

    }
    global override List<ccrz__E_CartItem__c> setDiscount(List<ccrz__E_CartItem__c> cartItems, String currencyCode) {
        return null;
    }
    global override Map<String,Object> setDiscount(Map<String,Object> inputData) {
        return null;
    }
}
global class tenPercentWithSurcharge extends ccrz.cc_api_PriceAdjustment {
    global tenPercentWithSurcharge() {

    }
    global override Map<String,Object> computePricingCart(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> computePricingReview(Map<String,Object> inputData) {
        return null;
    }
}
}
