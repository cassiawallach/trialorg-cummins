/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_Catalog implements ccrz.cc_if_api {
    global static String HK_ID;
    global static String PARAM_FILTER_DATA;
    global static String PARAM_RESULTS_LIMIT;
    global static String PARAM_SCOPE_STRING;
    global static String PARAM_SEARCH_RESULTS;
    global static String PARAM_SEARCH_STRING;
    global static String PARAM_SKU_LIST;
    global static String PARAM_STOREFRONT;
    global static String PARAM_STOREFRONT_STRING;
    global static String SCOPE_PRODUCT_SEARCH;
    global static String SCOPE_QUICK_ORDER;
    global cc_hk_Catalog() {

    }
    global virtual Map<String,Object> autoComplete(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> filterCatalogData(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_hk_Catalog getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> modifyAutoComplete(Map<String,Object> inputResults) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
global class cc_catalog_testHook extends ccrz.cc_hk_Catalog {
    global cc_catalog_testHook() {

    }
    global override virtual Map<String,Object> autoComplete(Map<String,Object> inputData) {
        return null;
    }
}
}
