/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_EffectiveAccount implements ccrz.cc_if_api {
    global static String ASSIGNED_ACCOUNT_ALWAYS;
    global static String ASSIGNED_ACCOUNT_NEVER;
    global static String ASSIGNED_ACCOUNT_ONLYEMPTY;
    global static String CART_MODE_EFF_CARTS;
    global static String CART_MODE_SINGLE;
    global static String FETCH_ENTITLED;
    global static String FETCH_GROUP;
    global static String FETCH_PARENT;
    global static String HK_ID;
    global static String PARAM_ACCOUNT_ID;
    global static String PARAM_ADDR_SOURCE;
    global static String PARAM_ASSIGNED_ACCT_MODE;
    global static String PARAM_CART_BEAN;
    global static String PARAM_CART_CREATE_MODE;
    global static String PARAM_CART_DATA;
    global static String PARAM_EFFACCOUNT;
    global static String PARAM_EFFACCOUNT_LIST;
    global static String PARAM_FETCH_MODE;
    global static String PARAM_MISC_DATA;
    global static String PARAM_STOREFRONT;
    global static String PARAM_USER_ID;
    global cc_hk_EffectiveAccount() {

    }
    global List<ccrz.cc_bean_EffectiveAccount> buildEffectiveAccountData(List<Account> accountList, String addressSource) {
        return null;
    }
    global List<Account> fetchAccountData(String whereClause, String orderBy) {
        return null;
    }
    global virtual Map<String,Object> fetchAccounts(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> filterAccounts(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_hk_EffectiveAccount getInstance(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_api_DeliveryDate instantiateDateAPI(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processDeliveryDates(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> saveCart(Map<String,Object> inputData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
}
