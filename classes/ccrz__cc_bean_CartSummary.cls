/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_bean_CartSummary {
    global Decimal adjustment {
        get;
        set;
    }
    global Boolean allowCheckout {
        get;
        set;
    }
    global ccrz.cc_bean_MockContactAddress billingAddress {
        get;
    }
    global Id buyerContactId {
        get;
    }
    global String buyerEmail {
        get;
    }
    global String buyerFirstName {
        get;
    }
    global String buyerLastName {
        get;
    }
    global String buyerPhone {
        get;
    }
    global List<ccrz.cc_bean_CartItem> cartItems {
        get;
        set;
    }
    global String ccEmailAddresses {
        get;
    }
    global String contractId {
        get;
    }
    global String couponName {
        get;
        set;
    }
    global String encryptedId {
        get;
    }
    global Map<String,String> extrinsic {
        get;
        set;
    }
    global Decimal grossTotal {
        get;
        set;
    }
    global Boolean hasCoupon {
        get;
    }
    global Boolean isActive {
        get;
    }
    global Boolean isValidated {
        get;
    }
    global String lastModifiedDateStr {
        get;
    }
    global List<ccrz.cc_bean_Message> messages;
    global ccrz.cc_bean_MockContact mockContact {
        get;
    }
    global String name {
        get;
    }
    global String note {
        get;
        set;
    }
    global List<ccrz.cc_bean_Payment> payments {
        get;
    }
    global String paymentType {
        get;
        set;
    }
    global String poNumber {
        get;
    }
    global Boolean preventBillingEdit {
        get;
    }
    global Boolean preventContactEdit {
        get;
    }
    global Boolean preventShippingEdit {
        get;
    }
    global Date requestedDate {
        get;
    }
    global String requestedDateStr {
        get;
    }
    global Id sfid {
        get;
        set;
    }
    global Boolean shipComplete {
        get;
    }
    global ccrz.cc_bean_MockContactAddress shippingAddress {
        get;
    }
    global Decimal shippingCharge {
        get;
    }
    global String shippingInst {
        get;
    }
    global String shippingMethod {
        get;
    }
    global List<ccrz.cc_ctrl_hlpr_ShippingOption> shippingMethods {
        get;
    }
    global Decimal subTotal {
        get;
        set;
    }
    global Decimal surchargeAmount {
        get;
        set;
    }
    global Decimal tax {
        get;
        set;
    }
    global List<ccrz.cc_bean_Terms> terms {
        get;
    }
    global Decimal totalDiscount {
        get;
        set;
    }
    global String totalInfo {
        get;
    }
    global cc_bean_CartSummary() {

    }
    global cc_bean_CartSummary(ccrz__E_Cart__c cart) {

    }
    global cc_bean_CartSummary(ccrz__E_Cart__c cart, Boolean fullData) {

    }
}
