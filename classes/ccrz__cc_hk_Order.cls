/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_Order implements ccrz.cc_if_api {
    global static String HK_ID;
    global static String PARAM_ASCENDING;
    global static String PARAM_BILLING_ADDR;
    global static String PARAM_CART;
    global static String PARAM_CART_ID;
    global static String PARAM_CART_ITEMS;
    global static String PARAM_COUPONS;
    global static String PARAM_CURR_PAGE;
    global static String PARAM_ENC_CART_ID;
    global static String PARAM_INVOICE;
    global static String PARAM_INVOICE_ITEMS;
    global static String PARAM_NUM_PER_PAGE;
    global static String PARAM_ORDER;
    global static String PARAM_ORDER_CHILD_ITEMS;
    global static String PARAM_ORDER_ID;
    global static String PARAM_ORDER_ITEM_TIERS;
    global static String PARAM_ORDER_ITEMS;
    global static String PARAM_ORDER_TERMS;
    global static String PARAM_ORDER_W_STATUS;
    global static String PARAM_ORDERS;
    global static String PARAM_PAYMENT_RESULT;
    global static String PARAM_PLACE_STEP;
    global static String PARAM_PLACE_TARGET;
    global static String PARAM_SEARCH_FROM_DATE;
    global static String PARAM_SEARCH_ORDER_INPUT;
    global static String PARAM_SEARCH_ORDER_STATUS;
    global static String PARAM_SEARCH_TO_DATE;
    global static String PARAM_SHIPPING_ADDR;
    global static String PARAM_SORT_CRITERIA;
    global static String PARAM_STOREFRONT;
    global static String PARAM_TRANSACTION_DATA;
    global static String PARAM_TRANSACTION_PROCESSED_DATA;
    global static String STEP_CART_CLOSE_POST;
    global static String STEP_CART_CLOSE_PRE;
    global static String STEP_CREATE_ADDRESSES_POST;
    global static String STEP_CREATE_ADDRESSES_PRE;
    global static String STEP_CREATE_ORDER_CHILD_ITEMS_POST;
    global static String STEP_CREATE_ORDER_CHILD_ITEMS_PRE;
    global static String STEP_CREATE_ORDER_ITEM_TIERS_POST;
    global static String STEP_CREATE_ORDER_ITEM_TIERS_PRE;
    global static String STEP_CREATE_ORDER_ITEMS_POST;
    global static String STEP_CREATE_ORDER_ITEMS_PRE;
    global static String STEP_CREATE_ORDER_POST;
    global static String STEP_CREATE_ORDER_PRE;
    global static String STEP_CREATE_ORDER_TERMS_POST;
    global static String STEP_CREATE_ORDER_TERMS_PRE;
    global static String STEP_CREATE_STORED_PAYMENT_POST;
    global static String STEP_CREATE_STORED_PAYMENT_PRE;
    global static String STEP_CREATE_SUBSCRIPTION_POST;
    global static String STEP_CREATE_SUBSCRIPTION_PRE;
    global static String STEP_CREATE_TRANSACTION_POST;
    global static String STEP_CREATE_TRANSACTION_PRE;
    global static String STEP_END;
    global static String STEP_FETCH_CART;
    global static String STEP_FETCH_CART_ITEMS;
    global static String STEP_FETCH_COUPONS;
    global static String STEP_INVOICE_CREATE_POST;
    global static String STEP_INVOICE_CREATE_PRE;
    global static String STEP_PAYMENT_PROCESS_POST;
    global static String STEP_PAYMENT_PROCESS_PRE;
    global static String STEP_START;
    global static String STEP_UPDATE_ORDER_STATUS_POST;
    global static String STEP_UPDATE_ORDER_STATUS_PRE;
    global cc_hk_Order() {

    }
    global virtual Map<String,Object> createTransaction(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> fetchOrderHistory(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_hk_Order getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> placeTarget(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> place(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> reorder(Map<String,Object> inputData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
global class cc_hk_AllThrows extends ccrz.cc_hk_Order {
    global cc_hk_AllThrows() {

    }
    global override Map<String,Object> fetchOrderHistory(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> placeTarget(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> place(Map<String,Object> inputData) {
        return null;
    }
    global override Map<String,Object> reorder(Map<String,Object> inputData) {
        return null;
    }
}
global class cc_hk_JumpToOrderHistory extends ccrz.cc_hk_Order {
    global cc_hk_JumpToOrderHistory() {

    }
    global override Map<String,Object> placeTarget(Map<String,Object> inputData) {
        return null;
    }
}
global class cc_hk_OnlyHalfOrders extends ccrz.cc_hk_Order {
    global cc_hk_OnlyHalfOrders() {

    }
    global override Map<String,Object> fetchOrderHistory(Map<String,Object> inputData) {
        return null;
    }
}
global class cc_hk_ReorderDouble extends ccrz.cc_hk_Order {
    global cc_hk_ReorderDouble() {

    }
    global override Map<String,Object> reorder(Map<String,Object> inputData) {
        return null;
    }
}
}
