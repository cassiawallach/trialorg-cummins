/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_bean_MockOrder {
    global ccrz.cc_bean_MockContactAddress billTo {
        get;
        set;
    }
    global String buyerCompanyName {
        get;
        set;
    }
    global String buyerEmail {
        get;
        set;
    }
    global String buyerFirstName {
        get;
        set;
    }
    global String buyerLastName {
        get;
        set;
    }
    global String buyerMobilePhone {
        get;
        set;
    }
    global String buyerPhone {
        get;
        set;
    }
    global Boolean canAmend {
        get;
        set;
    }
    global Boolean canCancel {
        get;
        set;
    }
    global Boolean canReOrder {
        get;
        set;
    }
    global String cartId {
        get;
        set;
    }
    global String currencyIsoCode {
        get;
        set;
    }
    global String encryptedId {
        get;
        set;
    }
    global String externalOrderId {
        get;
        set;
    }
    global Map<String,String> extrinsic {
        get;
        set;
    }
    global Boolean isLLI {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global Map<String,String> orderAccountData {
        get;
        set;
    }
    global Date orderDate {
        get;
        set;
    }
    global String orderDateStr {
        get;
        set;
    }
    global List<ccrz.cc_bean_MockOrder.OrderItemGroup> orderItemGroups {
        get;
        set;
    }
    global Decimal orderNumber {
        get;
        set;
    }
    global String orderNumberAsString {
        get;
        set;
    }
    global String orderShipAmount {
        get;
    }
    global String orderSubTotal {
        get;
    }
    global String orderTaxAmount {
        get;
    }
    global String orderTotalAmount {
        get;
    }
    global String orderTotalSurcharge {
        get;
    }
    global String ownerName {
        get;
        set;
    }
    global String paymentMethod {
        get;
        set;
    }
    global List<ccrz.cc_bean_Payment> payments {
        get;
        set;
    }
    global String poNumber {
        get;
        set;
    }
    global String requestDate {
        get;
        set;
    }
    global Date requestDateVal {
        get;
        set;
    }
    global Id sfid {
        get;
        set;
    }
    global Double shipAmount {
        get;
        set;
    }
    global Boolean shipComplete {
        get;
        set;
    }
    global String shippingMethod {
        get;
        set;
    }
    global ccrz.cc_bean_MockContactAddress shipTo {
        get;
        set;
    }
    global String shipTrackNo {
        get;
        set;
    }
    global String status {
        get;
        set;
    }
    global Double subTotalAmount {
        get;
        set;
    }
    global Double taxAmount {
        get;
        set;
    }
    global Double totalAmount {
        get;
        set;
    }
    global Double totalSurcharge {
        get;
        set;
    }
    global List<Map<String,Object>> transactionPayments {
        get;
        set;
    }
    global cc_bean_MockOrder() {

    }
    global cc_bean_MockOrder(ccrz__E_Order__c order) {

    }
global class OrderItemGroup {
    global String groupName {
        get;
        set;
    }
    global String note {
        get;
        set;
    }
    global String requestDate {
        get;
        set;
    }
    global String sfid {
        get;
        set;
    }
    global Decimal shipAmount {
        get;
        set;
    }
    global String shipMethod {
        get;
        set;
    }
    global ccrz.cc_bean_MockContactAddress shipTo {
        get;
        set;
    }
}
}
