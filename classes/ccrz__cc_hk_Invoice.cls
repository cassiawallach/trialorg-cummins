/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_Invoice implements ccrz.cc_if_api {
    global static String HK_ID;
    global static String PARAM_AVAILABLETOPAY;
    global static String PARAM_CART;
    global static String PARAM_CART_ITEMS;
    global static String PARAM_CURRENCY_CODE;
    global static String PARAM_ENC_CART_ID;
    global static String PARAM_INVOICE;
    global static String PARAM_INVOICE_CURRENCIES;
    global static String PARAM_INVOICE_ITEMS;
    global static String PARAM_INVOICE_PAYMENTS;
    global static String PARAM_INVOICE_PAYMENTSJSON;
    global static String PARAM_INVOICEID;
    global static String PARAM_INVOICES;
    global static String PARAM_MESSAGES;
    global static String PARAM_ORDER;
    global static String PARAM_ORDER_CHILD_ITEMS;
    global static String PARAM_ORDER_ID;
    global static String PARAM_ORDER_ITEM_TIERS;
    global static String PARAM_ORDER_ITEMS;
    global static String PARAM_ORDER_TERMS;
    global static String PARAM_ORDER_W_STATUS;
    global static String PARAM_PAYAMOUNT;
    global static String PARAM_PAYMENT;
    global static String PARAM_PAYMENT_VALID;
    global static String PARAM_PAYMENTCTX;
    global static String PARAM_PAYMENTJSON;
    global static String PARAM_SEARCH_DATA;
    global static String PARAM_STOREDPAYMENTID;
    global static String PARAM_STOREFRONT;
    global static String PARAM_TXN_MASTER_PAYMENT;
    global static String STATUS_CLOSED;
    global static String STATUS_OPEN;
    global static String TYPE_ADJUSTMENT;
    global static String TYPE_CREDIT;
    global static String TYPE_DEBIT;
    global static String TYPE_ITEM;
    global static String TYPE_SHIPPING;
    global static String TYPE_SHIPPINGDISCOUNT;
    global static String TYPE_SUMMARY;
    global static String TYPE_SURCHARGE;
    global static String TYPE_TAX;
    global cc_hk_Invoice() {

    }
    global virtual Map<String,Object> applyPayment(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Object> convertContactAddressToMap(ccrz__E_ContactAddr__c theAddress) {
        return null;
    }
    global static Map<String,Object> convertInvoiceItemToMap(ccrz__E_InvoiceItem__c theInvoiceItem) {
        return null;
    }
    global static Map<String,Object> convertInvoiceToMap(ccrz__E_Invoice__c theInvoice) {
        return null;
    }
    global static ccrz.cc_hk_Invoice.InvoiceSearchParams deserializeSearchParams(String params) {
        return null;
    }
    global virtual Map<String,Object> fetchInvoice(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> fetchInvoicesForPayment(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> fetchInvoices(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_hk_Invoice getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> handleListCase(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> handleSingleCase(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> handleSummaryCase(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> onOrder(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> parseFetchPaymentData(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processInvoicePayment(Map<String,Object> inputData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
    global virtual Map<String,Object> validatePayment(Map<String,Object> inputData) {
        return null;
    }
global class InvoiceSearchParams {
    global String fromDateStr {
        get;
        set;
    }
    global String nullHandling {
        get;
        set;
    }
    global String searchInvoiceInput {
        get;
        set;
    }
    global String searchInvoiceStatus {
        get;
        set;
    }
    global String searchInvoiceType {
        get;
        set;
    }
    global String sortCriteria {
        get;
        set;
    }
    global String sortDir {
        get;
        set;
    }
    global String toDateStr {
        get;
        set;
    }
    global InvoiceSearchParams() {

    }
}
}
