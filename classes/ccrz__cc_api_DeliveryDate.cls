/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class cc_api_DeliveryDate implements ccrz.cc_if_api {
    global static String ACCOUNT_ID;
    global static String API_ERROR;
    global static String CART_ID;
    global static String DAYS_FILTER;
    global static String DURATION;
    global static String EXCLUDED_DATES;
    global static String HK_ID;
    global static String INCLUDED_DATES;
    global static String MAX_DATE;
    global static String MESSAGES;
    global static String MIN_DATE;
    global static String OFFSET;
    global static String SCOPE;
    global static String SCOPE_CHECKOUT;
    global static String SCOPE_EFF;
    global static String SHIP_ADDRESS;
    global static String STOREFRONT;
    global cc_api_DeliveryDate() {

    }
    global virtual Map<String,Object> getDeliveryDates(Id accountID, String cartId, ccrz.cc_bean_MockContactAddress address) {
        return null;
    }
    global virtual Map<String,Object> getDeliveryDates(Map<String,Object> inputData) {
        return null;
    }
    global static ccrz.cc_api_DeliveryDate getInstance(Map<String,Object> inputData) {
        return null;
    }
    global virtual void setDaoObject(ccrz.cc_if_dao obj) {

    }
    global virtual void setServiceObject(ccrz.cc_if_service obj) {

    }
    global virtual void setStorefrontSettings(Map<String,Object> settings) {

    }
global class alwaysFails extends ccrz.cc_api_DeliveryDate {
    global alwaysFails() {

    }
    global override Map<String,Object> getDeliveryDates(Map<String,Object> inputData) {
        return null;
    }
}
global class helloWorld extends ccrz.cc_api_DeliveryDate {
    global helloWorld() {

    }
    global override Map<String,Object> getDeliveryDates(Map<String,Object> inputData) {
        return null;
    }
}
global class onlyTomorrow extends ccrz.cc_api_DeliveryDate {
    global onlyTomorrow() {

    }
    global override Map<String,Object> getDeliveryDates(Map<String,Object> inputData) {
        return null;
    }
}
global class tomorrowExcluded extends ccrz.cc_api_DeliveryDate {
    global tomorrowExcluded() {

    }
    global override Map<String,Object> getDeliveryDates(Map<String,Object> inputData) {
        return null;
    }
}
}
