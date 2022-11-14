/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_bean_EffectiveAccount {
    global String accountNumber {
        get;
        set;
    }
    global String accountType {
        get;
        set;
    }
    global ccrz.cc_bean_MockContactAddress billingAddress {
        get;
        set;
    }
    global Map<String,Object> deliveryDateData {
        get;
        set;
    }
    global Map<String,Object> extrinsic {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String nextDelivery {
        get;
        set;
    }
    global String sfid {
        get;
        set;
    }
    global ccrz.cc_bean_MockContactAddress shippingAddress {
        get;
        set;
    }
    global cc_bean_EffectiveAccount() {

    }
    global cc_bean_EffectiveAccount(Account acct) {

    }
    global cc_bean_EffectiveAccount(Account acct, ccrz__E_ContactAddr__c shipAddr, ccrz__E_ContactAddr__c billAddr) {

    }
}
