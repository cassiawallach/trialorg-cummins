/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_ctrl_PaymentGateway {
    global ccrz__E_Cart__c cart {
        get;
        set;
    }
    global String currentCartID {
        get;
        set;
    }
    global Map<String,String> gatewayAttributes {
        get;
        set;
    }
    global String gatewayName {
        get;
        set;
    }
    global String ipAddressLocation {
        get;
        set;
    }
    global String ipAddressLocationKey {
        get;
        set;
    }
    global String paymentFlow {
        get;
        set;
    }
    global Boolean performImmediateSettlement {
        get;
        set;
    }
    global String storeId {
        get;
        set;
    }
    global cc_ctrl_PaymentGateway() {

    }
    global cc_ctrl_PaymentGateway(String gatewayName) {

    }
    global Map<String,String> buildAddressMap(ccrz__E_ContactAddr__c addr) {
        return null;
    }
    global virtual Double calculateAmountToCharge(Boolean includeShippingCharge, Boolean includeTax) {
        return null;
    }
    global Map<String,String> getBillingAddress() {
        return null;
    }
    global Map<String,String> getShippingAddress() {
        return null;
    }
}
