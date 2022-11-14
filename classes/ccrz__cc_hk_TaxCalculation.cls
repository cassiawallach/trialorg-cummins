/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_TaxCalculation implements ccrz.cc_if_api {
    global ccrz__E_Cart__c cart {
        get;
        set;
    }
    global String encryptedCartId {
        get;
        set;
    }
    global static String HK_ID;
    global static String PARAM_CARTID;
    global static String PARAM_SHIPADDR;
    global static String PARAM_STOREFRONT;
    global Double shipAmount {
        get;
        set;
    }
    global cc_hk_TaxCalculation() {

    }
    global static ccrz.cc_hk_TaxCalculation getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual Double getTaxAmount() {
        return null;
    }
    global virtual Decimal getTaxAmount(Map<String,Object> inputData) {
        return null;
    }
    global virtual Boolean skipTaxCalculation() {
        return null;
    }
    global virtual Boolean skipTaxCalculation(Map<String,Object> inputData) {
        return null;
    }
}
