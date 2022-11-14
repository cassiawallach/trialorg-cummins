/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_svc_ShippingAndHandlingGeneric implements ccrz.cc_svc_IShippingAndHandling {
    global ccrz.cc_bean_ShippingOptionsRequest shippingOptionsRequest {
        get;
        set;
    }
    global cc_svc_ShippingAndHandlingGeneric() {

    }
    global cc_svc_ShippingAndHandlingGeneric(Map<String,Object> storefront) {

    }
    global virtual ccrz.cc_bean_ShippingOptions getShippingAndHandlingRates(ccrz.cc_bean_ShippingOptionsRequest shippingRequest) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
}
