/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_bean_Subscription {
    global Decimal absoluteDiscount {
        get;
        set;
    }
    global ccrz.cc_bean_MockContactAddress billingAddress {
        get;
        set;
    }
    global Boolean canCancel {
        get;
        set;
    }
    global String disclaimer {
        get;
        set;
    }
    global String displayProductName {
        get;
        set;
    }
    global Decimal duration {
        get;
        set;
    }
    global Date endDate {
        get;
        set;
    }
    global String endDateStr {
        get;
        set;
    }
    global Decimal frequency {
        get;
        set;
    }
    global Boolean isAutoRenewal {
        get;
        set;
    }
    global Id itemID {
        get;
        set;
    }
    global Decimal itemTotal {
        get;
        set;
    }
    global ccrz.cc_bean_MediaWrapper mediaWrapper {
        get;
        set;
    }
    global ccrz.cc_bean_MockProduct mockProduct {
        get;
        set;
    }
    global Date nextSubscriptionDate {
        get;
        set;
    }
    global String nextSubscriptionDateStr {
        get;
        set;
    }
    global Id orderID {
        get;
        set;
    }
    global List<ccrz.cc_bean_Payment> payments {
        get;
        set;
    }
    global Decimal percentDiscount {
        get;
        set;
    }
    global Decimal price {
        get;
        set;
    }
    global String productName {
        get;
        set;
    }
    global Integer quantity {
        get;
        set;
    }
    global ccrz.cc_bean_MockContactAddress shippingAddress {
        get;
        set;
    }
    global String sku {
        get;
        set;
    }
    global Date startDate {
        get;
        set;
    }
    global String subscriptionId {
        get;
        set;
    }
    global String subscriptionStatus {
        get;
        set;
    }
    global cc_bean_Subscription() {

    }
}
