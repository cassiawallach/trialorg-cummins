/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_util_Order {
    global ccrz.cc_ctrl_CloudCraze CCController {
        get;
        set;
    }
    global Boolean orderComplete {
        get;
        set;
    }
    global Id orderID {
        get;
        set;
    }
    global Boolean orderOnHold {
        get;
    }
    global String orderShipAmount {
        get;
    }
    global String orderSubTotal {
        get;
    }
    global String orderSurchargeAmount {
        get;
    }
    global String orderTaxAmount {
        get;
    }
    global String orderTotalAmount {
        get;
    }
    global Map<String,String> pageLabelMap {
        get;
        set;
    }
    global Boolean showShipping {
        get;
    }
    global cc_util_Order() {

    }
    global cc_util_Order(ApexPages.StandardController c) {

    }
    global Integer getItemsSize() {
        return null;
    }
    global ccrz.cc_bean_MockOrder getMockOrder() {
        return null;
    }
    global List<ccrz.cc_bean_MockOrderItem> getMockOrderItems() {
        return null;
    }
}
