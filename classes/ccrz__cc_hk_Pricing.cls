/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_hk_Pricing implements ccrz.cc_if_api {
    global static String HK_ID;
    global static String KIT_COMPONENT_PROD_LIST;
    global static String KIT_COMPOSITE_PROD_LIST;
    global static String PARAM_ACCOUNTS;
    global static String PARAM_CART_BEAN;
    global static String PARAM_CART_ITEMS;
    global static String PARAM_CURRENCY_CODE;
    global static String PARAM_EFF_DATE;
    global static String PARAM_EVAL;
    global static String PARAM_EVAL_BEST;
    global static String PARAM_EVAL_SEQ;
    global static String PARAM_EXTERNAL_PRODUCTS;
    global static String PARAM_GROUP_ACC;
    global static String PARAM_GROUP_TYPES;
    global static String PARAM_GROUPS;
    global static String PARAM_INCL_SUBSCRIPTIONS;
    global static String PARAM_MODE;
    global static String PARAM_MODE_BASE;
    global static String PARAM_MODE_BOTH;
    global static String PARAM_MODE_STANDARD;
    global static String PARAM_PL_IDS;
    global static String PARAM_PL_ITEMS;
    global static String PARAM_PL_NAME;
    global static String PARAM_PRODUCT_DATA;
    global static String PARAM_PRODUCT_MAP;
    global static String PARAM_PRODUCTS;
    global static String PARAM_RET;
    global static String PARAM_RET_DATA_BREAKDOWN;
    global static String PARAM_RET_DATA_MAP;
    global static String PARAM_RET_DATA_SELLERS;
    global static String PARAM_RET_DATA_STANDARD;
    global static String PARAM_RULE_SOURCES;
    global static String PARAM_SCOPE;
    global static String PARAM_SCOPE_CART;
    global static String PARAM_SCOPE_CATALOG;
    global static String PARAM_SCOPE_REVIEW;
    global static String PARAM_SELLERS;
    global static String PARAM_SKUS;
    global static String PARAM_STOREFRONT;
    global static String PARAM_SUBSCRIPTIONS;
    global static String PG_QTY_ITEMS;
    global static String PL_SEQ;
    global static String PRICE_MAP_ENTRIES;
    global static String PRICE_MAP_PRICE;
    global static String PRICE_MAP_SUBAMOUNT;
    global static String PRICE_MAP_SUBPRODTERM;
    global static String PRICE_RESULTS;
    global static String PRICE_TYPE;
    global static String PRIORITY;
    global static String PRIORITY_ACCOUNT;
    global static String PRIORITY_CUSTOM;
    global static String PRIORITY_EFF_ACCOUNT;
    global static String PRIORITY_PRICE_GROUP;
    global static String PRIORITY_PRICE_GROUP_FALLBACK;
    global static String PROD_MAP_QTY;
    global static String PROD_MAP_SKU;
    global static String PROD_MAP_UOM;
    global static String RET_PRICE_ENTRIES;
    global static String RULE_MODS;
    global static String RULES_DATA;
    global cc_hk_Pricing() {

    }
    global virtual Map<String,Object> applyPricingCode(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> applyRules(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> constructPricingProducts(Map<String,Object> inputData) {
        return null;
    }
    global static Map<String,Map<String,Object>> convertToMap(List<ccrz.cc_bean_ItemPrice> sourceItems) {
        return null;
    }
    global virtual Map<String,Object> evaluatePricingResults(Map<String,Object> inputData) {
        return null;
    }
    global static List<ccrz__E_AccountGroupPriceList__c> fetchAccountGroupPricelists(ccrz__E_AccountGroup__c accountGroup) {
        return null;
    }
    global virtual Map<String,Object> fetchEntitlements(Map<String,Object> inputData) {
        return null;
    }
    global static List<ccrz__E_PriceGroupAccount__c> fetchPriceGroupData(List<String> accountIDs, List<String> types) {
        return null;
    }
    global static ccrz__E_PriceGroup__c fetchPriceGroupDetails(String priceGroupID, List<String> accountIDs) {
        return null;
    }
    global virtual Map<String,Object> fetchPriceGroups(Map<String,Object> inputData) {
        return null;
    }
    global static List<ccrz__E_PriceListItem__c> fetchPricelistItems(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> fetchRules(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_hk_Pricing getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual void populatePricingContext(Map<String,Object> inputData) {

    }
    global virtual Map<String,Object> postProcessPricing(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> postProcessRules(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> preProcessPricing(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> price(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processAlternatePricing(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processBaselinePricing(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processPriceGroupPricing(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> processPricing(Map<String,Object> inputData) {
        return null;
    }
    global virtual Map<String,Object> qualifyPricingCode(Map<String,Object> inputData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> storeSettings) {

    }
    global virtual List<ccrz.cc_bean_ItemPrice> translatePricingResults(Map<String,Object> inputData) {
        return null;
    }
}
