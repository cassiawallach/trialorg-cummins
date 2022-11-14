/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class cc_hlpr_Payment {
    global cc_hlpr_Payment() {

    }
    global static ccrz__E_PaymentDetail__c createPayment(ccrz.cc_bean_Payment bean, Boolean performSave) {
        return null;
    }
    global static ccrz__E_PaymentDetail__c createPayment(String cartId, String paymentMethod, String accountNumber, Boolean performSave) {
        return null;
    }
    global static ccrz__E_PaymentDetail__c createPayment(String cartId, String paymentMethod, String accountNumber, Datetime transactionDate, Decimal amount) {
        return null;
    }
    global static ccrz__E_PaymentDetail__c createPayment(String cartId, String token, String cardType, String cardNumber, String expMonth, String expYear) {
        return null;
    }
    global static ccrz__E_PaymentDetail__c createPayment(String cartId, String token, String cardType, String cardNumber, String expMonth, String expYear, Boolean performSave) {
        return null;
    }
    global static ccrz__E_PaymentDetail__c createPayment(String cartId, String token, String cardType, String cardNumber, String expMonth, String expYear, Datetime transactionDate, String transactionCode, Decimal amount) {
        return null;
    }
    global static void deletePayment(String cartId, String token) {

    }
    global static ccrz__E_PaymentDetail__c getPayment(String cartId, String token) {
        return null;
    }
    global static ccrz__E_PaymentDetail__c getPaymentByMethod(String cartId, String method) {
        return null;
    }
    global static List<ccrz__E_PaymentDetail__c> getPayments(String cartId) {
        return null;
    }
    global static List<ccrz__E_PaymentDetail__c> getPayments(String cartId, String token) {
        return null;
    }
    global static void setTransactionData(ccrz__E_PaymentDetail__c payment, String transactionCode, Datetime transactionDate, Decimal amount) {

    }
    global static void updatePaymentWithTransaction(String cartId, String token, String transactionCode, Datetime transactionDate, Decimal amount) {

    }
}
