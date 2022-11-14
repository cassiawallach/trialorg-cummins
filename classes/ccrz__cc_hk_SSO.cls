/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_SSO implements ccrz.cc_if_api {
    global static String CSRQUERYSTRING;
    global String CSRQueryString {
        get;
        set;
    }
    global static String ENCRYPTEDCARTID;
    global String encryptedCartId {
        get;
        set;
    }
    global static String HEADER_LOGIN;
    global static String HEADER_LOGOUT;
    global static String HEADER_MYACCOUNT;
    global static String HK_ID;
    global String ipAddressLocation {
        get;
        set;
    }
    global String ipAddressLocationKey {
        get;
        set;
    }
    global static String MINICART_LOGIN;
    global static String MYACCOUNT_CHANGEPASSWORD;
    global static String MYACCOUNT_EDITPROFILE;
    global static String PARAM_STOREFRONT;
    global cc_hk_SSO() {

    }
    global virtual String getCheckOutLink() {
        return null;
    }
    global virtual System.PageReference getCheckoutPage(String stepName) {
        return null;
    }
    global virtual String getCheckoutViewState() {
        return null;
    }
    global virtual String getEditUserInfoLink() {
        return null;
    }
    global static ccrz.cc_hk_SSO getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> getLinkOverrideMap(Map<String,Object> inpData) {
        return null;
    }
    global virtual String getLoginLink() {
        return null;
    }
    global virtual String getLogoutLink() {
        return null;
    }
    global virtual String getMyAccountLink() {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
}
