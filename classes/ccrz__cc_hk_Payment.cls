/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_Payment implements ccrz.cc_if_api {
    global static String HK_ID;
    global static String PARAM_ACCOUNT_NUMBER;
    global static String PARAM_ACCOUNT_TYPE;
    global static String PARAM_ACCOUNT_TYPE_PO;
    global static String PARAM_APPL_PAYMENT_TYPES;
    global static String PARAM_CART;
    global static String PARAM_CURRENCY_CODE;
    global static String PARAM_CURRENT_PAGE;
    global static String PARAM_DISPLAY_NAME;
    global static String PARAM_ERROR;
    global static String PARAM_EXP_MONTH;
    global static String PARAM_EXP_YEAR;
    global static String PARAM_INQUIRY_ID;
    global static String PARAM_INVOICE_CURRENCIES;
    global static String PARAM_INVOICEID;
    global static String PARAM_INVOICES;
    global static String PARAM_ORDER_ID;
    global static String PARAM_PAYMENT;
    global static String PARAM_PAYMENT_CTX;
    global static String PARAM_PAYMENT_CTX_CHECKOUT;
    global static String PARAM_PAYMENT_CTX_INSTALLMENT;
    global static String PARAM_PAYMENT_CTX_INVOICE;
    global static String PARAM_PAYMENT_CTX_SUBSCRIPTION;
    global static String PARAM_PAYMENT_CTX_WALLET;
    global static String PARAM_PAYMENT_PROCESSOR;
    global static String PARAM_PAYMENT_TYPE;
    global static String PARAM_PAYMENT_TYPES;
    global static String PARAM_PAYMENTID;
    global static String PARAM_PRIMARY_TRANSACTION_RESULTS;
    global static String PARAM_STORED_PAYMENT;
    global static String PARAM_STORED_PAYMENT_ID;
    global static String PARAM_STORED_PAYMENTS;
    global static String PARAM_STOREFRONT;
    global static String PARAM_SUBS_RESULTS;
    global static String PARAM_SUCCESS;
    global static String PARAM_TOTAL_AMOUNT;
    global static String PARAM_TRANSACTION_CREATED;
    global static String PARAM_TRANSACTION_DATA;
    global static String PARAM_TRANSACTION_PROCESSED_DATA;
    global static String PAYMENT_CTX_CHECKOUT;
    global static String PAYMENT_CTX_INVOICE;
    global static String PAYMENT_CTX_WALLET;
    global cc_hk_Payment() {

    }
    global static Map<String,Object> convertStoredPaymentToMap(ccrz__E_StoredPayment__c payment) {
        return null;
    }
    global static Map<String,Object> convertTxnPaymentRefToMap(ccrz__E_TransactionPayment__c thePayment) {
        return null;
    }
    global static Map<String,Object> convertTxnPaymentToMap(ccrz__E_TransactionPayment__c thePayment) {
        return null;
    }
    global virtual Map<String,Object> createStoredPayment(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_hk_Payment.TransactionPaymentParams deserializeTransactionParams(String params) {
        return null;
    }
    global virtual Map<String,Object> fetchPaymentTypes(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> fetchStoredPayments(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> fetchTransactionPayment(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> getApplicablePaymentTypes(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_hk_Payment getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> getPaymentProcessor(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processPayment(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> removeStoredPayment(Map<String,Object> inputData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
global class TransactionPaymentParams {
    global String accountNumber {
        get;
        set;
    }
    global String accountType {
        get;
        set;
    }
    global Decimal ammount {
        get;
        set;
    }
    global Decimal amount {
        get;
        set;
    }
    global String comments {
        get;
        set;
    }
    global String displayName {
        get;
        set;
    }
    global Decimal expirationMonth {
        get;
        set;
    }
    global Decimal expirationYear {
        get;
        set;
    }
    global Boolean isEnabled {
        get;
        set;
    }
    global String paymentType {
        get;
        set;
    }
    global Decimal requestAmount {
        get;
        set;
    }
    global Boolean saveAsStoredPayment {
        get;
        set;
    }
    global String storedPaymentId {
        get;
        set;
    }
    global String storefront {
        get;
        set;
    }
    global String subAccountNumber {
        get;
        set;
    }
    global String token {
        get;
        set;
    }
    global String transactionCode {
        get;
        set;
    }
    global String transactionPaymentId {
        get;
        set;
    }
    global String transactionSubcode {
        get;
        set;
    }
    global String transactionType {
        get;
        set;
    }
    global String verificationCode {
        get;
        set;
    }
    global TransactionPaymentParams() {

    }
}
}
