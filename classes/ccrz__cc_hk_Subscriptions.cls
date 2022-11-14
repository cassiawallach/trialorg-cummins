/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_Subscriptions implements ccrz.cc_if_api {
    global static String DATE_UOM_DAY;
    global static String DATE_UOM_HOUR;
    global static String DATE_UOM_MINUTE;
    global static String DATE_UOM_MONTH;
    global static String DATE_UOM_WEEK;
    global static String DATE_UOM_YEAR;
    global static Integer DAYS_IN_WEEK;
    global static String HK_ID;
    global static String PARAM_ADDRMAP;
    global static String PARAM_BAD_SUBS;
    global static String PARAM_BILL_ADDR;
    global static String PARAM_CONTEXT_RECURR;
    global static String PARAM_CONTEXT_RECURR_COMBINED_ONLY;
    global static String PARAM_CONTEXT_RECURR_INSTALL_ONLY;
    global static String PARAM_CONTEXT_RECURR_ORDER_ONLY;
    global static String PARAM_COUNT;
    global static String PARAM_EXCEPTION;
    global static String PARAM_FREQUENCY;
    global static String PARAM_FREQUENCY_UOM;
    global static String PARAM_GOOD_ORDERS;
    global static String PARAM_GOOD_SUBS;
    global static String PARAM_GOOD_SUBS_NO_TXN;
    global static String PARAM_GOOD_TXN;
    global static String PARAM_MIN_ITEMS;
    global static String PARAM_MINOR_ORDER_ITEMS;
    global static String PARAM_NAME_NEXT_SUBSCRIPTION_DATE;
    global static String PARAM_NAME_PROD_ID;
    global static String PARAM_NAME_RENEWAL_RESULTS;
    global static String PARAM_NAME_RENEWAL_SUBSCRIPTIONS;
    global static String PARAM_NAME_REORDER_RESULTS;
    global static String PARAM_NAME_REORDER_SUBSCRIPTIONS;
    global static String PARAM_NAME_SPT_SUBQUERY;
    global static String PARAM_NAME_SUBPRODTERMS;
    global static String PARAM_NAME_SUBSCRIPTION_CANCANCEL_RESULT;
    global static String PARAM_NAME_SUBSCRIPTION_DATA;
    global static String PARAM_NAME_SUBSCRIPTION_FREQUENCY;
    global static String PARAM_NAME_SUBSCRIPTION_IDS;
    global static String PARAM_NAME_SUBSCRIPTION_OBJ;
    global static String PARAM_NO_SPT_FILTER;
    global static String PARAM_ORDER;
    global static String PARAM_ORDER_ID;
    global static String PARAM_ORDER_ITEM;
    global static String PARAM_ORIG_SUBDATA;
    global static String PARAM_PAY_PROCESSORS;
    global static String PARAM_PAYMENT_DATA;
    global static String PARAM_PROCESS_SUBSCRIPTIONS;
    global static String PARAM_PROCESS_SUBSCRIPTIONS_LOCATOR;
    global static String PARAM_RENEWAL_SUBSCRIPTIONS_LOCATOR;
    global static String PARAM_SAVERESULT;
    global static String PARAM_SEARCH_DATA;
    global static String PARAM_SHIP_ADDR;
    global static String PARAM_SPT_ID;
    global static String PARAM_SPT_PARENT;
    global static String PARAM_SPT_PRICING_MAP;
    global static String PARAM_START_DATE;
    global static String PARAM_STATUS_ACTIVE;
    global static String PARAM_STATUS_CANCELLED;
    global static String PARAM_STATUS_ERROR;
    global static String PARAM_STATUS_EXPIRED;
    global static String PARAM_STATUS_RENEWED;
    global static String PARAM_STOREDPAYMENTID;
    global static String PARAM_STOREFRONT;
    global static String PARAM_SUB_PAYDATA;
    global static String PARAM_SUB_PROD_TERM;
    global static String PARAM_SUBSCRIPTION;
    global static String PARAM_SUBSCRIPTION_OBJ;
    global static String PARAM_SUBSCRIPTIONID;
    global static String PARAM_SUBSCRIPTIONS;
    global static String PARAM_TARGET_DATE;
    global static String PARAM_TRANSACTION_DATA;
    global static String PARAM_TXN_PAYMENT;
    global static String RECURR_BASE_FIELDS;
    global static String RECURR_BASE_QL;
    global static String RECURR_COMBINED_QL;
    global static String RECURR_INSTALLMENT_QL;
    global static String RECURR_ORD_IT;
    global static String RECURR_ORDERS_QL;
    global static String RENEWAL_BASE_QL;
    global cc_hk_Subscriptions() {

    }
    global virtual Map<String,Object> calculateTargetDate(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> canCancel(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> cancelSubscription(Map<String,Object> inpData) {
        return null;
    }
    global virtual Map<String,Object> cancelSubscriptions(Map<String,Object> inpData) {
        return null;
    }
    global static List<Map<String,Object>> convertModifierSubProdTermsToMap(List<ccrz__E_SubProdTerm__c> spts) {
        return null;
    }
    global static Map<String,Object> convertSubProdTermToMap(ccrz__E_SubProdTerm__c spt) {
        return null;
    }
    global static Map<String,Object> convertSubscriptionToMap(ccrz__E_Subscription__c theSubscription) {
        return null;
    }
    global virtual Map<String,Object> createSubscription(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> createTransactionPayment(Map<String,Object> inputData) {
        return null;
    }
    global virtual Boolean eligibleForCancellation(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> fetchSubProdTerms(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> fetchSubscriptionOptions(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> fetchSubscription(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> fetchSubscriptions(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> filterSubscriptionOptions(Map<String,Object> params) {
        return null;
    }
    global static ccrz.cc_hk_Subscriptions getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> getNextSubscriptionDate(Map<String,Object> inpData) {
        return null;
    }
    global virtual Map<String,Object> getSubscriptionProcessQuery(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> getSubscriptionRenewalQuery(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> handleSubscriptionRenewalsAndExpirations(Map<String,Object> inpData) {
        return null;
    }
    global virtual Map<String,Object> onOrder(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> parsePaymentData(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> postProcessSubscriptions(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> preProcessSubscriptions(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processRecurrCombined(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processRecurrErrors(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processRecurrInstallments(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processRecurrOrders(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processRenewals(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processSubscriptions(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> procressRecurrInstallments(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> querySubscriptionsForRenewal(Map<String,Object> inpData) {
        return null;
    }
    global virtual Map<String,Object> querySubscriptionsForReorder(Map<String,Object> inpData) {
        return null;
    }
    global virtual Map<String,Object> recurrOrderAddrInfo(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> recurrOrder(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> renewAddrInfo(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> renewSubscription(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> reorder(Map<String,Object> inpData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
    global virtual Map<String,Object> updateSubscriptionPayment(Map<String,Object> inputData) {
        return null;
    }
global class DateUOMNotSpecifiedException extends Exception {
}
global class cc_hk_RecurrBreakTestSubscriptions extends ccrz.cc_hk_Subscriptions {
    global cc_hk_RecurrBreakTestSubscriptions() {

    }
    global override Map<String,Object> calculateTargetDate(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> createTransactionPayment(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> parsePaymentData(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> recurrOrderAddrInfo(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> recurrOrder(Map<String,Object> inputData) {
        return null;
    }
}
}
