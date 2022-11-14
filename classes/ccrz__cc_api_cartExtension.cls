/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_api_cartExtension implements ccrz.cc_if_api {
    global ccrz__E_Cart__c cart {
        get;
        set;
    }
    global List<ccrz__E_CartItem__c> cartItems {
        get;
        set;
    }
    global Decimal cartTotal {
        get;
    }
    global String currentCartId {
        get;
        set;
    }
    global static String HK_ID;
    global static String PARAM_CART;
    global static String PARAM_CARTBEAN;
    global static String PARAM_CARTITEMS;
    global static String PARAM_STOREFRONT;
    global static String PARAM_USERID;
    global cc_api_cartExtension() {

    }
    global virtual Boolean allowCheckout() {
        return null;
    }
    global virtual Boolean allowCheckout(Map<String,Object> inputData) {
        return null;
    }
    global virtual List<ccrz.cc_bean_Message> getCartMessages() {
        return null;
    }
    global virtual List<ccrz.cc_bean_Message> getCartMessages(Map<String,Object> inputData) {
        return null;
    }
    global virtual Component.apex.outputpanel getDynamicCustomizedMessage() {
        return null;
    }
    global virtual Object getDynamicMessageComponent() {
        return null;
    }
    global static ccrz.cc_api_cartExtension getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> prepareForSave(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> preprocess(Map<String,Object> inputData) {
        return null;
    }
    global virtual void resetExtension() {

    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
global class alwaysFail extends ccrz.cc_api_cartExtension {
    global alwaysFail() {

    }
    global override Boolean allowCheckout() {
        return null;
    }
    global override Boolean allowCheckout(Map<String,Object> inputData) {
        return null;
    }
    global override List<ccrz.cc_bean_Message> getCartMessages() {
        return null;
    }
    global override List<ccrz.cc_bean_Message> getCartMessages(Map<String,Object> inputData) {
        return null;
    }
}
global class bump extends ccrz.cc_api_cartExtension {
    global bump() {

    }
    global override Boolean allowCheckout() {
        return null;
    }
    global override List<ccrz.cc_bean_Message> getCartMessages() {
        return null;
    }
    global override void resetExtension() {

    }
}
global class evenOdd extends ccrz.cc_api_cartExtension {
    global evenOdd() {

    }
    global override Boolean allowCheckout() {
        return null;
    }
    global override Boolean allowCheckout(Map<String,Object> inputData) {
        return null;
    }
    global override List<ccrz.cc_bean_Message> getCartMessages() {
        return null;
    }
    global override List<ccrz.cc_bean_Message> getCartMessages(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> prepareForSave(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> preprocess(Map<String,Object> inputData) {
        return null;
    }
    global override void resetExtension() {

    }
}
global class helloWorld extends ccrz.cc_api_cartExtension {
    global helloWorld() {

    }
    global override List<ccrz.cc_bean_Message> getCartMessages() {
        return null;
    }
    global override List<ccrz.cc_bean_Message> getCartMessages(Map<String,Object> inputData) {
        return null;
    }
}
global class rainbow extends ccrz.cc_api_cartExtension {
    global rainbow() {

    }
    global override List<ccrz.cc_bean_Message> getCartMessages() {
        return null;
    }
    global override List<ccrz.cc_bean_Message> getCartMessages(Map<String,Object> inputData) {
        return null;
    }
}
}
