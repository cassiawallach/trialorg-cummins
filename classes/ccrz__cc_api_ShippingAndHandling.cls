/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_api_ShippingAndHandling implements ccrz.cc_if_ShippingAndHandling {
    global cc_api_ShippingAndHandling() {

    }
    global static ccrz.cc_api_ShippingAndHandling getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual List<ccrz.cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName) {
        return null;
    }
    global virtual Map<String,Object> getStorefrontSettings() {
        return null;
    }
global class fixedShippingFive extends ccrz.cc_api_ShippingAndHandling {
    global fixedShippingFive() {

    }
    global override List<ccrz.cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName) {
        return null;
    }
}
global class fixedShippingThreeOptions extends ccrz.cc_api_ShippingAndHandling {
    global fixedShippingThreeOptions() {

    }
    global override List<ccrz.cc_ctrl_hlpr_ShippingOption> getShippingOptions(String zipCode, String stateCode, String countryCode, Id cartId, String storeName) {
        return null;
    }
}
}
